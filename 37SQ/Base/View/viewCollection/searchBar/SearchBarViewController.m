//
//  SearchBarViewController.m
//  37SQ
//
//  Created by administrator on 16/10/26.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "SearchBarViewController.h"
#import "SearchBarTableViewCell.h"
#import "FBYMyNav.h"
#import "MJRefresh.h"
#import "AFNetworking.h"

#import "VideoPlayViewController.h"
#import "UIImageView+WebCache.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SearchBarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)FBYMyNav *nav;

@property(strong,nonatomic)UITableView *table;

@property(strong,nonatomic)NSMutableArray *arr;

@property(assign,nonatomic)int pageNum;

@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nav = [[FBYMyNav alloc]initWithTitle:nil andWithByImg:@"NAV" andWithLetBtn1:@"backfinal" andWithLeftBtn2:nil andWithRightBtn1:nil andWithRightBtn2:nil];
    
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
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/index/selectname";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_str forKey:@"name"];
    [mutdic setObject:@"1" forKey:@"page"];
    //    [mutdic setObject:uurl forKey:@"key"];
    //    NSLog(@"%@",mutd/ic);
    //1.创建ADHTTPSESSIONMANGER对象
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
        NSLog(@"%@",di);
        
        NSString *str = [di objectForKey:@"code"];
        int intString = [str intValue];
        
        if (intString == 500) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未搜索到相关内容" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
        
        NSArray *temp = [di objectForKey:@"data"];
        
        [self.arr addObjectsFromArray:temp];
        
        [self.table reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
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
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/index/selectname";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_str forKey:@"name"];
    [mutdic setObject:@"1" forKey:@"page"];
    //    [mutdic setObject:uurl forKey:@"key"];
    //    NSLog(@"%@",mutd/ic);
    //1.创建ADHTTPSESSIONMANGER对象
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
//        NSLog(@"%@",di);
        
        NSArray *temp = [di objectForKey:@"data"];
        
        [self.arr removeAllObjects];
        
        [self.arr addObjectsFromArray:temp];
        
        [self.table reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
    [self.table.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.pageNum = 1;
    
}

//上拉加载
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
    
        NSLog(@"-----%@",str);
    //网络请求
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/index/selectname";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_str forKey:@"name"];
    [mutdic setObject:str forKey:@"page"];
    //1.创建ADHTTPSESSIONMANGER对象
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
        //                NSLog(@"%@",di);
        
        NSString *code = [di objectForKey:@"code"];
        int intString = [code intValue];
        if ( intString == 500) {
            self.pageNum--;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未搜索到更多内容" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else{
            
            NSArray *temp = [di objectForKey:@"data"];
            
            [self.arr addObjectsFromArray:temp];
            
            [self.table reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
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
    
    SearchBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[SearchBarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell.videoImg sd_setImageWithURL:[_arr[indexPath.row] objectForKey:@"video_img"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
    
    cell.titleLab.text = [_arr[indexPath.row] objectForKey:@"video_name"];
    
    cell.playLab.text = @"播放:";
    
    int intPlay = [[_arr[indexPath.row] objectForKey:@"video_play"] intValue];
    if (intPlay >= 10000) {
        cell.playLab1.text = [NSString stringWithFormat:@"%d.%d万",intPlay/10000,intPlay%10000/1000];
    }
    else{
        cell.playLab1.text = [_arr[indexPath.row] objectForKey:@"video_play"];
    }
    
    cell.collectLab.text = @"评论:";
    
    int intCollect = [[_arr[indexPath.row] objectForKey:@"video_collect"] intValue];
    if (intCollect >= 10000) {
        cell.collectLab1.text = [NSString stringWithFormat:@"%d.%d万",intCollect/10000,intCollect%10000/1000];
    }
    else{
        cell.collectLab1.text = [_arr[indexPath.row] objectForKey:@"video_collect"];
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
