//
//  FriendTableViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/19.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "FriendTableViewController.h"
#import "MyNav.h"
#import "FriendTableTableViewCell.h"
#import "chatViewController.h"
#import "FinalGiveservice.h"
#import "UIImageView+WebCache.h"
#import "SearchFriendViewController.h"

#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface FriendTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *FriendTab;//好友列表
@property(strong,nonatomic)NSMutableArray *homeArr;//主数据数组
@end

@implementation FriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyNav *nav = [[MyNav alloc]initWithTitle:@"好友列表" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:nav];
    //准备区
    self.homeArr=[[NSMutableArray alloc]initWithCapacity:0];
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    //TAB
    self.FriendTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, SCREEN_HEIGHT-64) style:0];
    self.FriendTab.delegate=self;
    self.FriendTab.dataSource=self;
    
    [self.view addSubview:_FriendTab];
    //取userid
   
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
//     存
//    SQUserid setObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
        NSString *gosquserid = [SQUserid objectForKey:@"userid"];
    
    
    //网络请求
    FinalGiveservice *fgv=[[FinalGiveservice alloc]init];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:gosquserid forKey:@"userid"];
  [  fgv addMessage:@"http://115.159.195.113:8000/37App/index.php/hobby/friend/index" andDic:dic andSafe:nil andSuccess:^(NSDictionary *dic) {
        
        self.homeArr=[dic objectForKey:@"data"];
      [self.FriendTab reloadData];
 }];
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
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _homeArr.count;

}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;


}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FriendTableTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[FriendTableTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"go"];
        
//       
    }
    [cell.FriendheadImg sd_setImageWithURL:[_homeArr[indexPath.row] objectForKey:@"user_headimg"]placeholderImage:[UIImage imageNamed:@"load"]];
    cell.FriendName.text=[_homeArr[indexPath.row] objectForKey:@"user_name"];
    cell.FriendSign.text=[_homeArr[indexPath.row] objectForKey:@"user_sign"];
   
    //    @property(strong,nonatomic)UIImageView *FriendheadImg;//头像
    //    @property(strong,nonatomic)UILabel *FriendName;//名字
    //    @property(strong,nonatomic)UILabel *FriendSign;//个性签名
      return cell;
}
//点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//融云..
    
    //新建一个聊天会话View Controller对象
    chatViewController *chat = [[chatViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = [_homeArr[indexPath.row] objectForKey:@"user_id"];
    //设置聊天会话界面要显示的标题
    chat.title = [_homeArr[indexPath.row] objectForKey:@"user_name"];
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];


}
//左右按钮事件
-(void)leftaction:(UIButton * )sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    

}



@end
