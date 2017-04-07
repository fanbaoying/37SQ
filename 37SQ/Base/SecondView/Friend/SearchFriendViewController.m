//
//  SearchFriendViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/25.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "SearchFriendViewController.h"


#import "MyNav.h"
#import "AppDelegate.h"
#import "GiveService.h"
#import "DLTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewmessageViewController.h"
#import "AFNetworking.h"
//搜索群页
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SearchFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITextField *groupname;
@property(strong,nonatomic)UIButton *searchbtn;
@property(strong,nonatomic)UITableView *mygroup;
@property(strong,nonatomic)NSMutableArray *mygrouArr;
@end

@implementation SearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //数组初始化
    self.mygrouArr=[[NSMutableArray alloc]initWithCapacity:0];
    //搜索结果TABLEVIEW
    self.mygroup=[[UITableView alloc]initWithFrame:CGRectMake(0, 170, SCREEN_WIDHN, SCREEN_HEIGHT-170-49) style:UITableViewStylePlain];
    
    self.mygroup.dataSource=self;
    self.mygroup.delegate=self;
    self.mygroup.tableFooterView=[[UIView alloc]init];;
    [self.mygroup setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
    //    self.mygroup.backgroundColor=[UIColor redColor];
    [self.view addSubview:_mygroup];
    
    
    
    
    //隐藏下方TARBAR
    //
    self.tabBarController.tabBar.hidden=YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    //导航栏
    
    MyNav *nav = [[MyNav alloc]initWithTitle:@"搜索好友" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:nav];
    
    //搜索栏
    self.groupname=[[UITextField alloc]initWithFrame:CGRectMake(10, 74, SCREEN_WIDHN-20, 40)];
    self.groupname.placeholder=@"请输入要添加的昵称";
    self.groupname.textAlignment=NSTextAlignmentCenter;
    self.groupname.layer.borderWidth=1;
    self.groupname.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.groupname.font=[UIFont systemFontOfSize:13 weight:0.5];
    [self.view addSubview:_groupname];
    
    //搜索按钮
    self.searchbtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 124, SCREEN_WIDHN-30, 33)];
    self.searchbtn.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.searchbtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
    
    self.searchbtn.titleLabel.font=[UIFont systemFontOfSize:13 ];
    [self.searchbtn setTitle:@"发起搜索" forState:UIControlStateNormal];
    self.searchbtn.layer.cornerRadius=5;
    self.searchbtn.clipsToBounds=YES;
    [self.view addSubview:_searchbtn];
    [self.searchbtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    //给页面添加手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //向右
    [self.view addGestureRecognizer:swipeGesture];
    
    
}
//轻扫手势触发方法
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//搜索事件
-(void)search:(UIButton *)sender{
    
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSDictionary *dic=@{@"name":_groupname.text};
    
    NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/searchfriend";
    [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *haha = responseObject;
        if ([@"200" isEqualToString:[haha objectForKey:@"code"]]) {
        self.mygrouArr =[haha objectForKey:@"data"];
            [self.mygroup reloadData];}
        else{
                self.mygrouArr =[haha objectForKey:@"data"];
                [self.mygroup reloadData];                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有找到相关用户" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"纳,纳尼?" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:action1];
                    [self  presentViewController:alert animated:YES completion:nil];}
            
            
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}


//群组列表
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //行数
    return _mygrouArr.count;
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[DLTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"go"];
        
    }
    
    [  cell.grouppic sd_setImageWithURL:[_mygrouArr[indexPath.row] objectForKey:@"user_headimg" ] placeholderImage:[UIImage imageNamed:@"addfinal"]];
    cell.groupnum.backgroundColor=nil;
    cell.groupnum.tag=indexPath.row;
    
    cell.groupname.text=[_mygrouArr[indexPath.row] objectForKey:@"user_name" ];
    [cell.groupnum addTarget:self action:@selector(AddGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}
-(void)AddGroup:(UIButton *)sender{
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (![squserid isEqualToString:[_mygrouArr[sender.tag] objectForKey:@"user_id" ]]) {
     AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:squserid forKey:@"userid"];
    [dic setObject:[_mygrouArr[sender.tag] objectForKey:@"user_id" ] forKey:@"upid"];
    [dic setObject:@"1" forKey:@"type"];//1表示加好友类型
//    [dic  setObject:[_mygrouArr[sender.tag] objectForKey:@"group_maker" ]  forKey:@"maker"];
    NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/addfriend";
    [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求发送成功~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好~" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sender setBackgroundImage:nil forState:0];
            [sender setTitleColor:[UIColor lightGrayColor] forState:0];
            sender.titleLabel.font=[UIFont systemFontOfSize:12];
            [sender setTitle:@"已发" forState:0];
        }];
        [alert addAction:action1];
        [self  presentViewController:alert animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"(没有返回值)---");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你已经加过此人啦" preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"纳,纳尼?" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action1];
        [self  presentViewController:alert animated:YES completion:nil];
    }];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"冷静点" message:@"和自己聊天会人格分裂的.." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"纳,纳尼?" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action1];
        [self  presentViewController:alert animated:YES completion:nil];
      }
    sender.enabled=NO;
    
}

-(void)leftaction:(UIButton * )sender{
    
    [self.navigationController popViewControllerAnimated:YES];
 
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //快速变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
