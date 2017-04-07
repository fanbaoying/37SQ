//
//  CollectViewController.m
//  37SQ
//
//  Created by administrator on 16/10/28.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "CollectViewController.h"
#import "FBYMyNav.h"
#import "CollectTableViewCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

#import "UIImageView+WebCache.h"

#import "VideoPlayViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(strong,nonatomic)UITableView *table;

@property(strong,nonatomic)NSMutableArray *arr;

@property(assign,nonatomic)int pageNum;

@property(strong,nonatomic)UIImageView *bgImg;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.nav = [[FBYMyNav alloc]initWithTitle:@"收藏" andWithByImg:@"NAV" andWithLetBtn1:@"backfby" andWithLeftBtn2:nil andWithRightBtn1:nil andWithRightBtn2:nil];
//    
//    [self.nav.leftBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_nav];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.table.showsVerticalScrollIndicator = NO;
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgImg.image = [UIImage imageNamed:@"fby2"];
    
    [self.view addSubview:_table];
    
    
    self.arr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //网络请求
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    if (userid == nil) {
        
        self.bgImg.hidden = NO;
        
    [self.view addSubview:_bgImg];
        
    }else{
    
        self.bgImg.hidden = YES;
    //MJRefresh下拉刷新
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header)];
        
    //MJRefresh上拉加载
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer)];
        
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/type/mycollect";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:userid forKey:@"userid"];
    [mutdic setObject:@"1" forKey:@"page"];
    //    [mutdic setObject:uurl forKey:@"key"];
    //    NSLog(@"%@",mutd/ic);
    //1.创建ADHTTPSESSIONMANGER对象
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
//                        NSLog(@"%@",di);
        
        NSArray *temp = [di objectForKey:@"data"];
        
        [self.arr addObjectsFromArray:temp];
        
        [self.table reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.pageNum = 1;
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    if (userid == nil) {
        
         self.bgImg.hidden = NO;
        
        [self.view addSubview:_bgImg];
        
    }else{
        
        self.bgImg.hidden = YES;
        //MJRefresh下拉刷新
        self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header)];
        
        //MJRefresh上拉加载
        self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer)];
        
        NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/type/mycollect";
        
        NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
        
        [mutdic setObject:userid forKey:@"userid"];
        [mutdic setObject:@"1" forKey:@"page"];
        //    [mutdic setObject:uurl forKey:@"key"];
        //    NSLog(@"%@",mutd/ic);
        //1.创建ADHTTPSESSIONMANGER对象
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *di=responseObject;
            //                        NSLog(@"%@",di);
            
            NSArray *temp = [di objectForKey:@"data"];
            
            [self.arr removeAllObjects];
            
            [self.arr addObjectsFromArray:temp];
            
            [self.table reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"返回错误");
        }];
    }
    
}


//下拉刷新
- (void)MJRefresh_header{
    
    [self.table.mj_header beginRefreshing];
    
    //    网络监控句柄
    AFNetworkReachabilityManager *manager1 = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager1 startMonitoring];
    
    [manager1 setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
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
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    if (userid == nil) {
        
        [self.view addSubview:_bgImg];
        
    }else{
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/type/mycollect";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:userid forKey:@"userid"];
    [mutdic setObject:@"1" forKey:@"page"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
        //                NSLog(@"%@",di);
        
        NSArray *temp = [di objectForKey:@"data"];
        
        [self.arr removeAllObjects];
        
        [self.arr addObjectsFromArray:temp];
        
        [self.table reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"返回错误");
    }];
    }
        
    [self.table.mj_header endRefreshing];
}

//上拉刷新
- (void)MJRefresh_footer{
    
    [self.table.mj_footer beginRefreshing];
    
    
    
    //    网络监控句柄
    AFNetworkReachabilityManager *manager1 = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager1 startMonitoring];
    
    [manager1 setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
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
    
//        NSLog(@"-----%@",str);
    
    //网络请求
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    if (userid == nil) {
        
    }else{
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/type/mycollect";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:userid forKey:@"userid"];
    [mutdic setObject:str forKey:@"page"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
        //                NSLog(@"%@",di);
        
        NSString *code = [di objectForKey:@"code"];
        int intString = [code intValue];
        if ( intString == 500) {
            self.pageNum--;
        }
        else{
        
        NSArray *temp = [di objectForKey:@"data"];
        
        [self.arr addObjectsFromArray:temp];
        
        [self.table reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"返回错误");
    }];
    }
        
    [self.table.mj_footer endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

//cell 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    NSLog(@"我点击了图片");
    
    VideoPlayViewController *vdvc = [[VideoPlayViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    vdvc.VideoId = [_arr[indexPath.row] objectForKey:@"video_id"];
    
    [self.navigationController pushViewController:vdvc animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[CollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
- (void)back:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
