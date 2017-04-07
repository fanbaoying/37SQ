//
//  NewfriendViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/25.
//  Copyright © 2016年 practice. All rights reserved.
//
#import "AFNetworking.h"
#import "MessageTableViewCell.h"
#import "NewfriendViewController.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface NewfriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *FriendTab;//好友请求Tab
@property(strong,nonatomic)NSMutableArray *AllArr;//总数据数组
@end

@implementation NewfriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.FriendTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, SCREEN_HEIGHT-94) style:0];
    self.FriendTab.dataSource=self;
    self.FriendTab.delegate=self;
    [self.view addSubview:_FriendTab];
    //刷新框架
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //下拉刷新
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    self.FriendTab.mj_header = header;
    [self.FriendTab.mj_header beginRefreshing];
    
}
- (void)agreeapply:(UIButton *)sender{
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        NSString *squserid = [SQUserid objectForKey:@"userid"];
  NSLog(@"点击了一下");
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[_AllArr[sender.tag] objectForKey:@"user_id"] forKey:@"userid"];
    [dic setObject:[_AllArr[sender.tag] objectForKey:@"add_id"] forKey:@"addid"];
    NSLog(@"_______%@",[_AllArr[sender.tag] objectForKey:@"add_id"]);
    [dic setObject:squserid forKey:@"upid"];
    NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/personagree";
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
//下拉加载
- (void)loadNewData{
    self.AllArr=[[NSMutableArray alloc]initWithCapacity:0];
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSDictionary *dic=@{@"userid":squserid};
    NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/friendmessage";
    [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *haha = responseObject;
        self.AllArr =[haha objectForKey:@"data"];
    [self.FriendTab.mj_header endRefreshing];
        [self.FriendTab reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
        [self.FriendTab.mj_header endRefreshing];
    }];

}

//拿数据
- (void)viewWillAppear:(BOOL)animated{
//    self.AllArr=[[NSMutableArray alloc]initWithCapacity:0];
//    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
//    NSString *squserid = [SQUserid objectForKey:@"userid"];
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    NSDictionary *dic=@{@"userid":squserid};
//     NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/friendmessage";
//    [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSDictionary *haha = responseObject;
//        self.AllArr =[haha objectForKey:@"data"];
//        NSLog(@"%@",haha);
////        NSLog(@"%@",_homeArr);
//        [self.FriendTab reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"(没有返回值)---");
//    }];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _AllArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[MessageTableViewCell alloc]init];
        
    }
    [cell.headImg sd_setImageWithURL:[_AllArr[indexPath.row] objectForKey:@"user_headimg"] forState:0 placeholderImage:[UIImage imageNamed:@"load"]];
    cell.headImg.tag=[[_AllArr[indexPath.row] objectForKey:@"user_id"] intValue];
    cell.RightBtn.tag=indexPath.row ;
    
    [cell.RightBtn addTarget:self action:@selector(agreeapply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.nameBtn setTitle:[_AllArr[indexPath.row] objectForKey:@"user_name"] forState:0];
    cell.whatLab.text=@"请求添加你为好友";
    return cell;
    //@property(strong,nonatomic)UIButton *headImg;//头像
    //@property(strong,nonatomic)UIButton *nameBtn;//名字
    //@property(strong,nonatomic)UILabel *whatLab;//做什么
    //@property(strong,nonatomic)UIButton *groupBtn;//群组名称
    //@property(strong,nonatomic)UIButton *RightBtn;//同意
    //@property(strong,nonatomic)UIButton *NoBtn;//拒绝
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //快速变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
