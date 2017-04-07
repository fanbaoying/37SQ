//
//  TypeAllViewController.m
//  FBY--first
//
//  Created by administrator on 16/10/8.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "FireViewController.h"
#import "FBYMyNav.h"
#import "FireTableViewCell.h"
#import "FBY-HomeService.h"
#import "AppDelegate.h"

#import "UIImageView+WebCache.h"

#import "MJRefresh.h"
#import "AFNetworking.h"
#import "VideoPlayViewController.h"

//#import "VideoDetailViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface FireViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)FBYMyNav *nav;

@property(strong,nonatomic)UITableView *table;

@property(strong,nonatomic)NSMutableArray *arr;

@property(assign,nonatomic)int pageNum;

@end

@implementation FireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nav = [[FBYMyNav alloc]initWithTitle:@"热门推荐" andWithByImg:@"NAV" andWithLetBtn1:@"backfby" andWithLeftBtn2:nil andWithRightBtn1:nil andWithRightBtn2:nil];
    
    [self.nav.leftBtn1 addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
   
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.table.showsVerticalScrollIndicator = NO;
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //MJRefresh下拉刷新
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header)];
    
    //MJRefresh上拉加载
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer)];
    
    [self.view addSubview:_table];
    
    
    self.arr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //网络请求
    
    FBY_HomeService *service = [[FBY_HomeService alloc]init];
    [service searchMessage:@"1" andWithAction:@"num" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/index/hotmoney" andSuccess:^(NSDictionary *dic) {
        
//                NSLog(@"%@",dic);
        
        NSArray *temp = [dic objectForKey:@"data"];

        [self.arr addObjectsFromArray:temp];
        
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
    }];
    
    
}

//下拉刷新
- (void)MJRefresh_header{
    
    [self.table.mj_header beginRefreshing];
    
    //    网络监控句柄
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if ((long)status == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不给力" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"请检查网络" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        //status:
        //AFNetworkReachabilityStatusUnknown          = -1,  未知
        //AFNetworkReachabilityStatusNotReachable     = 0,   未连接
        //AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
        //AFNetworkReachabilityStatusReachableViaWiFi = 2,   无线连接
        //            NSLog(@"%ldhahahhahh", (long)status);
    }];
    
    //网络请求
    FBY_HomeService *service = [[FBY_HomeService alloc]init];
    [service searchMessage:@"1" andWithAction:@"num" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/index/hotmoney" andSuccess:^(NSDictionary *dic) {
        
        //        NSLog(@"%@",dic);
        
         NSArray *temp = [dic objectForKey:@"data"];

        [self.arr removeAllObjects];
        
        [self.arr addObjectsFromArray:temp];

        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
    }];
    
    [self.table.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{

    self.pageNum = 1;
    
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
    appDelegate.mids.hidden = YES;
    
}

//上拉刷新
- (void)MJRefresh_footer{
    
    [self.table.mj_footer beginRefreshing];
    
    
    
    //    网络监控句柄
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if ((long)status == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不给力" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"请检查网络" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        //status:
        //AFNetworkReachabilityStatusUnknown          = -1,  未知
        //AFNetworkReachabilityStatusNotReachable     = 0,   未连接
        //AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
        //AFNetworkReachabilityStatusReachableViaWiFi = 2,   无线连接
        //            NSLog(@"%ldhahahhahh", (long)status);
    }];
    
    self.pageNum++;
    
    NSString *str = [NSString stringWithFormat:@"%d",_pageNum];

//    NSLog(@"-----%@",str);

    
    //网络请求
    FBY_HomeService *service = [[FBY_HomeService alloc]init];
    [service searchMessage:str andWithAction:@"num" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/index/hotmoney" andSuccess:^(NSDictionary *dic) {
        
//                NSLog(@"%@",dic);

        NSString *code = [dic objectForKey:@"code"];
        int intString = [code intValue];
        if ( intString == 500) {
            self.pageNum--;
        }
        else{
        
        NSArray *temp = [dic objectForKey:@"data"];
            
        [self.arr addObjectsFromArray:temp];
        
        [self.table reloadData];
        }
        
    } andFailure:^(int fail) {
        
        
        
    }];
    
    [self.table.mj_footer endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _arr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100;
}

//cell 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"我点击了图片");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoPlayViewController *vdvc = [[VideoPlayViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
    appDelegate.mids.hidden = YES;
    
    vdvc.VideoId = [_arr[indexPath.row] objectForKey:@"video_id"];
    
    [self.navigationController pushViewController:vdvc animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[FireTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell.videoImg sd_setImageWithURL:[_arr[indexPath.row] objectForKey:@"video_img"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
    
    cell.titleLab.text = [_arr[indexPath.row] objectForKey:@"video_name"];
    
    cell.nameLab.text = @"UP主:";
    
    cell.nameLab1.text = [_arr[indexPath.row] objectForKey:@"user_name"];
    
    cell.playLab.text = @"播放:";
    
//    NSLog(@"%@",[_arr[0][0] objectForKey:@"video_play"]);
    
    int intPlay = [[_arr[indexPath.row] objectForKey:@"video_play"] intValue];
    if (intPlay >= 10000) {
        cell.playLab1.text = [NSString stringWithFormat:@"%d.%d万",intPlay/10000,intPlay%10000/1000];
    }
    else{
        cell.playLab1.text = [_arr[indexPath.row] objectForKey:@"video_play"];
    }
    return cell;
}

//导航栏返回
- (void)next:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
