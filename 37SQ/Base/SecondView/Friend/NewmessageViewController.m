//
//  NewmessageViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/24.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "NewmessageViewController.h"
#import "MessageTableViewCell.h"
#import "MyNav.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "NewfriendViewController.h"
#import "MakegroupViewController.h"
#import "MJRefresh.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface NewmessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(strong,nonatomic)UITableView *messageTab;//消息中心
@property(strong,nonatomic)UIScrollView *allAcl;//总的SCL
@property(strong,nonatomic)UIButton *LeftBtn;//
@property(strong,nonatomic)UIButton *RightBtn;//
@property(strong,nonatomic)NSMutableArray *homeArr;//数据源
@property(strong,nonatomic)UILabel *sclline;//scl滑动的线
@end

@implementation NewmessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //准备区
    
    
    
    
    
    //导航栏
  MyNav *nav = [[MyNav alloc]initWithTitle:@"消息中心" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:nav];
    

    
    //scr
    self.view.backgroundColor=[UIColor whiteColor];
    self.allAcl=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 94, SCREEN_WIDHN, SCREEN_HEIGHT-64-30)];
    self.allAcl.contentSize=CGSizeMake(SCREEN_WIDHN*2, SCREEN_HEIGHT-64-30);
    self.allAcl.pagingEnabled=YES;
    self.allAcl.delegate=self;
    [self.view addSubview:_allAcl];
    //上方两个BTN
    self.LeftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN/2.0, 30)];
    self.LeftBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.LeftBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];
    [self.LeftBtn addTarget:self action:@selector(sclleftaction) forControlEvents:UIControlEventTouchUpInside];
    [self.LeftBtn setTitle:@"群组请求" forState:0];
//    self.LeftBtn.backgroundColor=[UIColor redColor];
    [self.view addSubview:_LeftBtn];
    
    self.RightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2.0, 64, SCREEN_WIDHN/2.0, 30)];
    self.RightBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.RightBtn addTarget:self action:@selector(sclrightaction) forControlEvents:UIControlEventTouchUpInside];
    [self.RightBtn setTitle:@"好友请求" forState:0];
    [self.RightBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];
//    self.RightBtn.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_RightBtn];
    UILabel *topline=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2.0, 64+3, 1, 24)];
    topline.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:topline];
    
    //scl线
    self.sclline =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/8.0, 94, SCREEN_WIDHN/4.0, 1)];
    self.sclline.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];

    [self.view addSubview:_sclline];
    
    //消息中心TAB//可在TABAR显示数量
    self.messageTab =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, SCREEN_HEIGHT-64-30) style:UITableViewStylePlain];
    self.messageTab.dataSource=self;
    self.messageTab.delegate=self;
    [self.allAcl addSubview:_messageTab];
//
    //刷新框架
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
   //下拉刷新
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    self.messageTab.mj_header = header;
     [self.messageTab.mj_header beginRefreshing];

    //第二界面
    NewfriendViewController *scview=[[NewfriendViewController alloc]init];
    scview.view.frame=CGRectMake(SCREEN_WIDHN, 0, SCREEN_WIDHN, SCREEN_HEIGHT-64-30);
    [self.allAcl addSubview:scview.view];
    [self addChildViewController:scview];
}
//scl滑动函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.x);
    self.sclline.frame=CGRectMake(SCREEN_WIDHN/8.0 +scrollView.contentOffset.x/SCREEN_WIDHN *SCREEN_WIDHN*4/8.0, 94, SCREEN_WIDHN/4.0, 1) ;

}
//两个按钮事件
- (void)sclleftaction{
[self.allAcl setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)sclrightaction{
    [self.allAcl setContentOffset:CGPointMake(SCREEN_WIDHN, 0) animated:YES];
}
//刷新函数
-(void)loadNewData{
    self.homeArr=[[NSMutableArray alloc]initWithCapacity:0];
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSDictionary *dic=@{@"userid":squserid};
     NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/groupmessage";
    [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *haha = responseObject;
        self.homeArr =[haha objectForKey:@"data"];
        [self.messageTab reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
    }];
    
    [self.messageTab.mj_header endRefreshing];
}


// 同意按钮的事件

- (void)agreeapply :(UIButton *)sender{

//    NSLog(@"点击了一下");
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[_homeArr[sender.tag] objectForKey:@"user_id"] forKey:@"userid"];
     [dic setObject:[_homeArr[sender.tag] objectForKey:@"group_id"] forKey:@"groupid"];
     [dic setObject:[_homeArr[sender.tag] objectForKey:@"add_id"] forKey:@"addid"];
    NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/groupagree";
    [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *haha = responseObject;
    NSLog(@"%@",haha);
     ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");//在此试试改变界面
    }];
//
    [sender setImage:nil forState:0];
    sender.backgroundColor=[UIColor lightGrayColor];
    sender.titleLabel.font=[UIFont systemFontOfSize:12];
    [sender setTitle:@"已同意" forState:0];
    sender.enabled=NO;


}

- (void)viewWillAppear:(BOOL)animated{
//    self.homeArr=[[NSMutableArray alloc]initWithCapacity:0];
//    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
//         NSString *squserid = [SQUserid objectForKey:@"userid"];
//    
//    
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    NSDictionary *dic=@{@"userid":squserid};
//    
//    NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/groupmessage";
//    [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSDictionary *haha = responseObject;
//        self.homeArr =[haha objectForKey:@"data"];
//        NSLog(@"%@",haha);
//        NSLog(@"%@",_homeArr);
//        [self.messageTab reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"(没有返回值)---");
//    }];
    





}


-(void)leftaction:(UIButton * )sender{
    
    [self.navigationController popViewControllerAnimated:YES];}
- (void)rightaction{

    MakegroupViewController *vc=[[MakegroupViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _homeArr.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[MessageTableViewCell alloc]init];
        
    }
    NSLog(@"%@",_homeArr[indexPath.row]);
    
    [cell.headImg sd_setImageWithURL:[_homeArr[indexPath.row] objectForKey:@"user_headimg"] forState:0 placeholderImage:[UIImage imageNamed:@"load"]];
    cell.headImg.tag=[[_homeArr[indexPath.row] objectForKey:@"user_id"] intValue];
     cell.RightBtn.tag=indexPath.row ;
    
    [cell.RightBtn addTarget:self action:@selector(agreeapply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.nameBtn setTitle:[_homeArr[indexPath.row] objectForKey:@"user_name"] forState:0];
     cell.whatLab.text=@"请求加入";
    
     [cell.groupBtn setTitle:[_homeArr[indexPath.row] objectForKey:@"group_name"] forState:0];
    return cell;
    //@property(strong,nonatomic)UIButton *headImg;//头像
    //@property(strong,nonatomic)UIButton *nameBtn;//名字
    //@property(strong,nonatomic)UILabel *whatLab;//做什么
    //@property(strong,nonatomic)UIButton *groupBtn;//群组名称
    //@property(strong,nonatomic)UIButton *RightBtn;//同意
    //@property(strong,nonatomic)UIButton *NoBtn;//拒绝
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



@end
