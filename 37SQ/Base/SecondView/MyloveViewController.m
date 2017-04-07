//
//  MyloveViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/8.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "MyloveViewController.h"
#import "MyloveTableViewCell.h"
#import "GiveService.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "VideoPlayViewController.h"
#import "AFNetworking.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface MyloveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *myloveTab;
@property(strong,nonatomic)NSMutableArray *homeArr;//装内容的
@property(assign,nonatomic)NSInteger pagenum;//全局页数
@property(strong,nonatomic)UILabel *nulllab;//没有内容时的LAB
@end

@implementation MyloveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //准备区
    self.pagenum=1;
    self.homeArr =[[NSMutableArray alloc]initWithCapacity:0];
   //tabview
    self.myloveTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, SCREEN_HEIGHT-160) style:UITableViewStylePlain];
    self.myloveTab.dataSource=self;
    self.myloveTab.delegate=self;
    self.myloveTab.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.myloveTab.showsVerticalScrollIndicator=NO;
    //刷新框架
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    //下拉刷新
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    self.myloveTab.mj_header = header;
  
    [self.view addSubview:_myloveTab];
    
    [self.myloveTab.mj_header beginRefreshing];
    //上拉加载
     self.myloveTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}
//界面即将出现
-(void)viewWillAppear:(BOOL)animated{
//    //网络请求
//    GiveService *test=[[GiveService alloc]init];
//    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/mylove";
//    //全局取userid
//    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
//    NSString *squserid = [SQUserid objectForKey:@"userid"];
//    if (squserid) {
//        
//        
//        [test searchMessage:squserid andAction:@"mylove" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
//            //    NSLog(@"%@",dic);
//            self.homeArr=[dic objectForKey:@"data"];
//            [self.myloveTab reloadData];
//        }
//         ];
//    }

}
//上拉加载更多数据
- (void)loadMoreData{
    self.pagenum ++;
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/mylove";
    //全局取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
        
        //1.创建ADHTTPSESSIONMANGER对象
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:squserid forKey:@"userid"];
        [dic setObject:[NSString stringWithFormat:@"%lD",(long)_pagenum] forKey:@"page"];
        
        [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *res = [responseObject objectForKey:@"data"];
        [self.homeArr addObjectsFromArray:res];
            [self.myloveTab reloadData];
            [self.myloveTab.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"(没有返回值)---");
               [self.myloveTab.mj_footer endRefreshing];
            self.pagenum --;
        }];
    }
}

//刷新函数
-(void)loadNewData{
//    [self.myloveTab.mj_header beginRefreshing];
    
    
    //网络请求
    GiveService *test=[[GiveService alloc]init];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/mylove";
    //全局取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
          [test searchMessage:squserid andAction:@"mylove" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
            [self.homeArr removeAllObjects];
            NSArray *res=[dic objectForKey:@"data"];
            [self.homeArr addObjectsFromArray:res];
            [self.myloveTab reloadData];
           
        }
         ];
    }

    [self.myloveTab.mj_header endRefreshing];
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyloveTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[MyloveTableViewCell alloc]init];
    }
    //隐藏没有内容的提示LAB
    self.nulllab.hidden=YES;
    
    [cell.upheadImg sd_setImageWithURL:[_homeArr[indexPath.row] objectForKey:@"user_headimg"] placeholderImage:[UIImage imageNamed:@"backfinal"]];
    cell.upnameLab.text=[_homeArr[indexPath.row] objectForKey:@"user_name"];
//    NSString *go;
    
    cell.uptimeLab.text= [self timeD_Value:[_homeArr[indexPath.row] objectForKey:@"video_time"]];
    [cell.upmovieImg sd_setImageWithURL:[_homeArr[indexPath.row] objectForKey:@"video_img"] placeholderImage:[UIImage imageNamed:@"backfinal"]];
    cell.upmovieLab.text=[_homeArr[indexPath.row] objectForKey:@"video_name"];
    //转为多少万
    int intPlay =[[_homeArr[indexPath.row] objectForKey:@"video_play"] intValue];
    if (intPlay >= 10000) {
        cell.playLab.text = [NSString stringWithFormat:@"%d.%d万",intPlay/10000,intPlay%10000/1000];}else{
            cell.playLab.text=[_homeArr[indexPath.row] objectForKey:@"video_play"];
        }
    int intComment =[[_homeArr[indexPath.row] objectForKey:@"video_comment"] intValue];
    if (intComment >= 10000) {
        cell.commentLab.text = [NSString stringWithFormat:@"%d.%d万",intComment/10000,intComment%10000/1000];}else{
            cell.commentLab.text=[_homeArr[indexPath.row] objectForKey:@"video_comment"];
        }
   

    return cell;

    //@property(strong,nonatomic)UIImageView *upheadImg;//UP主头像
    //@property(strong,nonatomic)UILabel *upnameLab;//UP主名字
    //@property(strong,nonatomic)UILabel *uptimeLab;//上传时间
    //@property(strong,nonatomic)UIImageView *upmovieImg;//视频封面
    //@property(strong,nonatomic)UILabel *upmovieLab;//视频标题
    //@property(strong,nonatomic)UIImageView *playImg;//播放量
    //@property(strong,nonatomic)UILabel *playLab;
    //@property(strong,nonatomic)UIImageView *commentImg;//评论量
    //@property(strong,nonatomic)UILabel *commentLab;
}
//did
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoPlayViewController *vc=[[VideoPlayViewController alloc]init];
    vc.VideoId=[_homeArr[indexPath.row] objectForKey:@"video_id"] ;
    
    [self.navigationController pushViewController:vc animated:YES ];
    //快速变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_homeArr.count==0){
        if (!_nulllab) {
            self.nulllab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDHN, 50)];
            self.nulllab.textColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
            self.nulllab.textAlignment=NSTextAlignmentCenter;
            self.nulllab.text=@"你还没有关注的人哦~";
            [self.myloveTab addSubview:_nulllab];
        }
        self.nulllab.hidden=NO;
    }
      return _homeArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 180;


}
//
- (NSString *)timeD_Value:(NSString *)serverMessageTime{
    
    NSDate *date = [NSDate date];
    
    //将服务器时间string(参数serverMessageTime)转化为NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-d HH:mm:ss"];
    NSDate *note_date = [formatter dateFromString:serverMessageTime];
      //获取时间差
    NSUInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unit fromDate:note_date toDate:date options:NSCalendarWrapComponents];
    NSString *year = [NSString stringWithFormat:@"%ld%@",(long)components.year,@"年前"];
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
