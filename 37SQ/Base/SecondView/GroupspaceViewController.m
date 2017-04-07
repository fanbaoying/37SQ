//
//  GroupspaceViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/9.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "GroupspaceViewController.h"
#import "GroupspaceTableViewCell.h"
#import "MyNav.h"
#import "GiveService.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
//#import "SecondPlayer/SecondVideoplayerViewController.h"
#import "VideoPlayViewController.h"
#import "AFNetworking.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface GroupspaceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *groupmessageTab;
@property(strong,nonatomic)NSMutableArray *homeArr;
@property(assign,nonatomic)NSInteger pagenum;
@end

@implementation GroupspaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //准备区
    self.homeArr=[[NSMutableArray alloc]initWithCapacity:0];
    self.pagenum=0;
    //导航栏
    MyNav *nav = [[MyNav alloc]initWithTitle:@"群组空间" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction) forControlEvents:UIControlEventTouchUpInside];
//    [  nav.rightBtn  addTarget:self action:@selector(rightaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
    //tabview
    self.groupmessageTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDHN , SCREEN_HEIGHT-64) style:0];
    
    self.groupmessageTab.dataSource=self;
    self.groupmessageTab.delegate=self;
    [self.view addSubview:_groupmessageTab];
//    //    //网络请求

  MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //下拉刷新
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    self.groupmessageTab.mj_header = header;
    //上拉加载
//    NSString *const MJRefreshAutoFooterIdleText = @"";
   self.groupmessageTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //隐藏FOOT
    
  [self.view addSubview:_groupmessageTab];
    [self.groupmessageTab.mj_header beginRefreshing];
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
//返回
-(void)leftaction{

    [self.navigationController popViewControllerAnimated:YES];

}
//上拉加载更多数据
- (void)loadMoreData{
    self.pagenum++;
    NSLog(@"-------%ld",(long)_pagenum);
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/mygroupspace";
    //全局取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
        //1.创建ADHTTPSESSIONMANGER对象
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:_dlgroupid forKey:@"groupid"];
        NSLog(@"++++%@",_dlgroupid);
        [dic setObject:[NSString stringWithFormat:@"%lD",(long)_pagenum] forKey:@"page"];
   
        [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSArray *res = [responseObject objectForKey:@"data"];
            [self.homeArr addObjectsFromArray:res];
             [self.groupmessageTab reloadData];
            [self.groupmessageTab.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"(没有返回值)---");
            self.pagenum --;
        }];
        
        
        
    }
    
    
}

//刷新函数
-(void)loadNewData{
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/mygroupspace";
    //全局取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
        
        //1.创建ADHTTPSESSIONMANGER对象
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:_dlgroupid forKey:@"groupid"];
        [dic setObject:@"1" forKey:@"page"];
        
        [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.homeArr =[[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
            [self.groupmessageTab reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"(没有返回值)---");
        }];
    }

    [self.groupmessageTab.mj_header endRefreshing];
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _homeArr.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 150;

}
//did
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击跳转视频播放器页
    
    
   VideoPlayViewController  *vc = [[VideoPlayViewController alloc]init];
    
    vc.VideoId =  [_homeArr[indexPath.row]objectForKey:@"video_id" ];
//    vc.v
//    NSLog(@"---------%@------------",vc.VideoId);
    [self.navigationController pushViewController:vc animated:YES];
 
    
    //快速变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GroupspaceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[GroupspaceTableViewCell alloc]init];
    }
    [cell.upheadImg sd_setImageWithURL:[_homeArr[indexPath.row] objectForKey:@"user_headimg" ] placeholderImage:[UIImage imageNamed:@"load"]];
    cell.upname.text=[_homeArr[indexPath.row] objectForKey:@"user_name" ];
    //转为万
    int intComment =[[_homeArr[indexPath.row] objectForKey:@"video_comment"] intValue];
    if (intComment >= 10000) {
        cell.commentLab.text = [NSString stringWithFormat:@"%d.%d万",intComment/10000,intComment%10000/1000];}else{
            cell.commentLab.text=[_homeArr[indexPath.row] objectForKey:@"video_comment"];}
//    
//    cell.commentLab.text=[_homeArr[indexPath.row] objectForKey:@"video_comment" ];
    cell.uptimeLab.text=[self timeD_Value:[_homeArr[indexPath.row] objectForKey:@"video_time" ]];
    
    cell.movietitLab.text=[_homeArr[indexPath.row] objectForKey:@"video_name" ];
    cell.moviecontent.text=[_homeArr[indexPath.row] objectForKey:@"video_sign" ];
    [cell.movieImg sd_setImageWithURL:[_homeArr[indexPath.row] objectForKey:@"video_img" ] placeholderImage:[UIImage imageNamed:@"load"]];
    
   
    
    
    
    return cell;


}
//@property(strong,nonatomic)UIImageView *upheadImg;//up主头像
//@property(strong,nonatomic)UILabel *upname;//up名字
//@property(strong,nonatomic)UIImageView *commentImg;//评论图标
//@property(strong,nonatomic)UILabel *commentLab;//评论数
//@property(strong,nonatomic)UILabel *uptimeLab;//上传时间
//@property(strong,nonatomic)UILabel *movietitLab;//标题
//@property(strong,nonatomic)UILabel *moviecontent;//正文
//@property(strong,nonatomic)UIImageView *movieImg;//封面
- (NSString *)timeD_Value:(NSString *)serverMessageTime{
    
    NSDate *date = [NSDate date];
    
    
    //将服务器时间string(参数serverMessageTime)转化为NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-d HH:mm:ss"];
    NSDate *note_date = [formatter dateFromString:serverMessageTime];
    //    NSLog(@"%@",note_date);
    
    //获取时间差
    NSUInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unit fromDate:note_date toDate:date options:NSCalendarWrapComponents];
    //        NSLog(@"%ld",(long)components.year);
    //        NSLog(@"%ld",(long)components.month);
    //        NSLog(@"%ld",(long)components.day);
    //        NSLog(@"%ld",(long)components.hour);
    //        NSLog(@"%ld",(long)components.minute);
    //        NSLog(@"%ld",(long)components.second);
    NSString *year = [NSString stringWithFormat:@"%ld%@",(long)
                      components.year,@"年前"];
    NSString *month = [NSString stringWithFormat:@"%ld%@",(long)components.month,@"月前"];
    NSString *day = [NSString stringWithFormat:@"%ld%@",(long)components.day,@"天前"];
    NSString *hour = [NSString stringWithFormat:@"%ld%@",(long)components.hour,@"小时前"];
    NSString *minute = [NSString stringWithFormat:@"%ld%@",(long)components.minute,@"分钟前"];
    //    NSString *second = [NSString stringWithFormat:@"%ld%@",components.second,@"秒前"];
    
    if (components.year > 0) {
        return year;
    }else if (components.month > 0){
        return month;
    }else if (components.day > 0){
        return day;
    }else if (components.hour > 0){
        return hour;
    }else {
        return minute;
    }
    
}

@end
