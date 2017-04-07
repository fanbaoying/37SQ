//
//  NextViewController.m
//  FBY--first
//
//  Created by administrator on 16/9/30.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "NextViewController.h"
#import "FBYMyNav.h"
#import "FBY-HomeService.h"
#import "AppDelegate.h"

#import "NextCollectionReusableView.h"
#import "NextCollectionViewCell.h"

#import "UIImageView+WebCache.h"

#import "OtherDetailViewController.h"
#import "VideoPlayViewController.h"

//刷新
#import "MJRefresh.h"
//网络监测
#import "AFNetworking.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface NextViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic)FBYMyNav *nav;

@property(strong,nonatomic)UICollectionView *collect;

@property(strong,nonatomic)UICollectionViewFlowLayout *layout;


@property(strong,nonatomic)NSMutableArray *arr;

@property(strong,nonatomic)NSArray *ADArr;

@property(strong,nonatomic)NSDictionary *DataDic;

@property(assign,nonatomic)int pageNum;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局为垂直流布局
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置每个item的大小
    self.layout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)*2/6+30);
    
    //设置上左下右的距离
    self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    //创建collectionview 通过一个布局策略layout来创建
    self.collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44) collectionViewLayout:_layout];
    self.collect.backgroundColor = [UIColor whiteColor];
    
    //代理设置
    self.collect.dataSource = self;
    self.collect.delegate = self;
    
    //注册item 类型 这里使用系统的类型
    [self.collect registerClass:[NextCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.collect registerClass:[NextCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fby"];
    
    [self.view addSubview:_collect];

    
    self.nav = [[FBYMyNav alloc]initWithTitle:_str andWithByImg:@"NAV" andWithLetBtn1:@"backfby" andWithLeftBtn2:nil andWithRightBtn1:nil andWithRightBtn2:nil];
    
    [self.nav.leftBtn1 addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nav];
    
    //MJRefresh下拉刷新
    self.collect.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header)];
    
    //MJRefresh上拉加载
    self.collect.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer)];

    self.arr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //网络请求

    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/index/whattype";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_sstr forKey:@"type"];
    [mutdic setObject:@"1" forKey:@"page"];
    //    [mutdic setObject:uurl forKey:@"key"];
    //    NSLog(@"%@",mutd/ic);
    //1.创建ADHTTPSESSIONMANGER对象
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
//                NSLog(@"%@",di);

        NSArray *temp = [di objectForKey:@"data"];

        [self.arr addObjectsFromArray:temp];
        
        [self.collect reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
    
    //广告网络请求
    FBY_HomeService *service1 = [[FBY_HomeService alloc]init];
    [service1 searchMessage:_sstr andWithAction:@"type" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/type/adtype" andSuccess:^(NSDictionary *dic) {
        
//        NSLog(@"%@",dic);
        
        self.ADArr = [dic objectForKey:@"data"];
        
        [self.collect reloadData];
        
    } andFailure:^(int fail) {
        
    }];
    

}

//下拉刷新
- (void)MJRefresh_header{
    
    [self.collect.mj_header beginRefreshing];
    
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
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/index/whattype";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_sstr forKey:@"type"];
    [mutdic setObject:@"1" forKey:@"page"];
    //    [mutdic setObject:uurl forKey:@"key"];
    //    NSLog(@"%@",mutd/ic);
    //1.创建ADHTTPSESSIONMANGER对象
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
//                NSLog(@"%@",di);
        
        NSArray *temp = [di objectForKey:@"data"];
        
        [self.arr removeAllObjects];
        
        [self.arr addObjectsFromArray:temp];
        
        [self.collect reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
    //广告网络请求
    FBY_HomeService *service1 = [[FBY_HomeService alloc]init];
    [service1 searchMessage:@"1" andWithAction:@"type" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/type/adtype" andSuccess:^(NSDictionary *dic) {
        
//        NSLog(@"%@",dic);
        
        self.ADArr = [dic objectForKey:@"data"];
        
        [self.collect reloadData];
        
    } andFailure:^(int fail) {
        
    }];
    
    [self.collect.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.pageNum = 1;
    
    self.tabBarController.tabBar.hidden = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    
}

//上拉加载
- (void)MJRefresh_footer{
    
    [self.collect.mj_footer beginRefreshing];

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
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/home/index/whattype";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_sstr forKey:@"type"];
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
        }
        else{
            
            NSArray *temp = [di objectForKey:@"data"];
            
            [self.arr addObjectsFromArray:temp];
            
            [self.collect reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
    [self.collect.mj_footer endRefreshing];
}



//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
}

//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 10;
}

//返回分区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _arr.count;
}

//每个分区的头部高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    CGSize size1;
    
    if (section == 0) {
        size1 = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2+45);
    }else{
        size1 = CGSizeMake(SCREEN_WIDTH, 30);
    }
    return size1;
    
}

//item 点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"我点击了图片");
    VideoPlayViewController *vdvc = [[VideoPlayViewController alloc]init];
    
    vdvc.VideoId = [_arr[indexPath.row] objectForKey:@"video_id"];
//    NSLog(@"-----------%@-",vdvc.VideoId);
    [self.navigationController pushViewController:vdvc animated:YES];
    
}

//头部自定义
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    NextCollectionReusableView *myheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fby" forIndexPath:indexPath];
    
    [myheader.titleImg1 sd_setImageWithURL:[_ADArr[0] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg1"]];
    [myheader.titleImg2 sd_setImageWithURL:[_ADArr[1] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg2"]];
    [myheader.titleImg3 sd_setImageWithURL:[_ADArr[2] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg3"]];
    
    [myheader.btn1 setImage:[UIImage imageNamed:@"newPic2"] forState:UIControlStateNormal];
    
    myheader.lab1.text = @"全区动态";
    
    return myheader;
    
    
}

//item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    NextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
//        cell.backgroundColor = [UIColor purpleColor];
    //图片
    [cell.titleImg sd_setImageWithURL:[_arr[indexPath.row] objectForKey:@"video_img"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
    
    cell.playImg.image = [UIImage imageNamed:@"playPic"];
    
    //播放量
    int intPlay = [[_arr[indexPath.row] objectForKey:@"video_play"] intValue];
    if (intPlay >= 10000) {
        cell.playLab.text = [NSString stringWithFormat:@"%d.%d万",intPlay/10000,intPlay%1000/1000];
    }
    else{
        cell.playLab.text = [_arr[indexPath.row] objectForKey:@"video_play"];
    }
    
    //    NSLog(@"%@",cell.playLab.text);
    
    //评论量
    int intComment = [[_arr[indexPath.row] objectForKey:@"video_comment"] intValue];
    
    if (intComment >= 10000) {
        cell.commentLab.text = [NSString stringWithFormat:@"%d.%d万",intComment/10000,intComment%10000/1000];
    }
    else{
        cell.commentLab.text = [_arr[indexPath.row] objectForKey:@"video_comment"];
    }
    
    cell.commentImg.image = [UIImage imageNamed:@"comment"];
    
    cell.contentLab.text = [_arr[indexPath.row] objectForKey:@"video_name"];
    
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
