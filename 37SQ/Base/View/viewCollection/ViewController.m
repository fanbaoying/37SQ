//
//  ViewController.m
//  22222
//
//  Created by administrator on 16/11/5.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "ViewController.h"
//页面跳转控制
#import "AppDelegate.h"
//自定义导航栏
#import "FBYFirestNav.h"
//封装网络请求
#import "FBY-HomeService.h"

//热门推荐页面
#import "FireViewController.h"
//分类页面
#import "NextViewController.h"

//图片加载
#import "UIImageView+WebCache.h"

//collectionview
#import "MyCollectionReusableView.h"
#import "MyCollectionViewCell.h"

//下拉刷新
#import "MJRefresh.h"

//网络请求
#import "AFNetworking.h"

//视频详情页
#import "VideoPlayViewController.h"

//搜索
#import "SearchBarViewController.h"

//收藏页面
#import "CollectViewController.h"

#import "TypeViewController.h"
//融云
#import <RongIMKit/RongIMKit.h>

#import "FinalGiveservice.h"

#define RONGAPPKEY @"4z3hlwrv348ct"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UIScrollViewDelegate>

@property(strong,nonatomic)FBYFirestNav *nav;

@property(strong,nonatomic)UICollectionView *collect;

@property(strong,nonatomic)UICollectionViewFlowLayout *layout;


//搜索框
@property(strong,nonatomic)UISearchBar *searchBar;

//大画布
@property(strong,nonatomic)UIScrollView *myScrollView;
//线
@property(strong,nonatomic)UILabel *chooseLab;


@property(strong,nonatomic)NSArray *picArr;

@property(strong,nonatomic)NSArray *titArr;

@property(strong,nonatomic)NSArray *numArr;

@property(strong,nonatomic)NSArray *allArr;

@property(strong,nonatomic)NSArray *arr0;
@property(strong,nonatomic)NSArray *arr1;
@property(strong,nonatomic)NSArray *arr2;
@property(strong,nonatomic)NSArray *arr3;
@property(strong,nonatomic)NSArray *arr4;
@property(strong,nonatomic)NSArray *arr5;
@property(strong,nonatomic)NSArray *arr6;
@property(strong,nonatomic)NSArray *arr7;
@property(strong,nonatomic)NSArray *arr8;
@property(strong,nonatomic)NSArray *arr9;

@property(strong,nonatomic)NSArray *arr;

@property(strong,nonatomic)NSArray *ADArr;

@property(strong,nonatomic)NSArray *videoArr;

@property(strong,nonatomic)NSDictionary *DataDic;

//label点击事件
@property(strong,nonatomic)UITapGestureRecognizer *labTGR1;

@property(strong,nonatomic)UITapGestureRecognizer *labTGR2;

@property(assign,nonatomic)long int a;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //写入TOKEN
//    NSString *squserid = [SQUserid objectForKey:@"userid"];
    FinalGiveservice *dlservice=[[FinalGiveservice alloc]init];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    NSMutableArray *tokenArr=[[NSMutableArray alloc]initWithCapacity:0];
    [dic setObject:@"11" forKey:@"userid"];
    [dic setObject:@"name" forKey:@"username"];
    [dic setObject:@"userimg" forKey:@"userimg"];
    [dlservice addMessage:@"file:///Users/fby/Desktop/server-sdk-php-master/API/methods/User.php" andDic:dic andSafe:nil andSuccess:^(NSDictionary *dic) {
        NSDictionary *recieve = dic;
        
//        [tokenArr addObject:recieve];
        NSLog(@"%@",recieve);
//        [SQUserid setObject:[tokenArr[0] objectForKey:@"token"] forKey:@"usertoken"];
        
        //登录融云
//        NSString *usertoken=[SQUserid objectForKey:@"usertoken"];
//        [[RCIM sharedRCIM] initWithAppKey:RONGAPPKEY];
//        [[RCIM sharedRCIM] connectWithToken:usertoken success:^(NSString *userId) {
//            
//            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//        } error:^(RCConnectErrorCode status) {
//            NSLog(@"登陆的错误码为:%ld", (long)status);
//        } tokenIncorrect:^{
//            
//            NSLog(@"token错误");
        }];
    
    //融云激活
//    [[RCIM sharedRCIM] initWithAppKey:RONGAPPKEY];
//    
//    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
//    NSString *usertoken=[SQUserid objectForKey:@"usertoken"];
//    
//    [[RCIM sharedRCIM] connectWithToken:usertoken success:^(NSString *userId) {
//        
//        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"登陆的错误码为:%ld", (long)status);
//    } tokenIncorrect:^{
//        
//        NSLog(@"token错误");
//    }];
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    self.myScrollView.showsHorizontalScrollIndicator = FALSE;
    //画布位置跳
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.delegate = self;
    self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-113);
    [self.myScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    
    CollectViewController *cvc = [[CollectViewController alloc]init];
    
    cvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
    cvc.view.tag = 1001;
    [self addChildViewController:cvc];
    
    [self.myScrollView addSubview:cvc.view];
    
    
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置布局方向为垂直流布局
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    self.layout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)*2/6+30);
    
    self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    //创建collectionView 通过一个布局策略layout来创建
    self.collect = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 44, SCREEN_WIDTH, SCREEN_HEIGHT-157) collectionViewLayout:_layout];
    self.collect.backgroundColor = [UIColor whiteColor];
    
    //隐藏滚动条
    self.collect.showsVerticalScrollIndicator = NO;
    
    //代理设置
    self.collect.dataSource = self;
    self.collect.delegate = self;
    
    //注册item类型 这里使用系统的类型
    [self.collect registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.collect registerClass:[MyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fby"];
    self.collect.tag = 1002;
    
    [self.myScrollView addSubview:_collect];
    
    
    //MJRefresh下拉刷新
    self.collect.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header)];
    
    self.nav = [[FBYFirestNav alloc]initWithTitle:@"首页" andWithByImg:@"NAV" andWithCollect:@"收藏" andWithType:@"分类"];
    
    [self.nav.collectBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    self.nav.collectBtn.tag = 2001;
    
    [self.nav.titleBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    self.nav.titleBtn.tag = 2002;
    
    [self.nav.typeBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    self.nav.typeBtn.tag = 2003;
    
    [self.view addSubview:_nav];
    
    //搜索框
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 44)];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.searchBar.placeholder = @"请输入关键字";
    
    //    [self.searchBar setKeyboardType:UIKeyboardTypeEmailAddress];
    
    self.searchBar.delegate = self;
    self.searchBar.tag = 1002;
    
    [self.myScrollView addSubview:_searchBar];
    
    
    
    TypeViewController *tvc = [[TypeViewController alloc]init];
    
    tvc.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    tvc.view.tag = 1003;
    
    [self addChildViewController:tvc];
    [self.myScrollView addSubview:tvc.view];
    
    [self.view addSubview:_myScrollView];
    
    //线
    self.chooseLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, 58, 40, 2)];
    //    self.chooseLab = [[UILabel alloc]init];
    self.chooseLab.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_chooseLab];
    
    //分类数组
    self.picArr = @[@"fire",@"music",@"show",@"TV",@"science",@"game",@"astronomy",@"movie",@"life",@"comic"];
    
    self.titArr = @[@"热门推荐",@"音乐",@"脱口秀",@"TV",@"科技",@"游戏",@"天文",@"电影",@"生活",@"搞笑"];
    
    self.numArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    
    //网络请求
    FBY_HomeService *service = [[FBY_HomeService alloc]init];
    [service searchMessage:nil andWithAction:nil andUrl:@"http://115.159.195.113:8000/37App/index.php/home/index/index" andSuccess:^(NSDictionary *dic) {
        
        //NSLog(@"%@",dic);
        
        
        self.DataDic = [dic objectForKey:@"data"];
        
        self.arr0 = [self.DataDic objectForKey:@"data0"];
        self.arr1 = [self.DataDic objectForKey:@"data1"];
        self.arr2 = [self.DataDic objectForKey:@"data2"];
        self.arr3 = [self.DataDic objectForKey:@"data3"];
        self.arr4 = [self.DataDic objectForKey:@"data4"];
        self.arr5 = [self.DataDic objectForKey:@"data5"];
        self.arr6 = [self.DataDic objectForKey:@"data6"];
        self.arr7 = [self.DataDic objectForKey:@"data7"];
        self.arr8 = [self.DataDic objectForKey:@"data8"];
        self.arr9 = [self.DataDic objectForKey:@"data9"];
        self.arr = @[_arr0,_arr1,_arr2,_arr3,_arr4,_arr5,_arr6,_arr7,_arr8,_arr9];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_arr];
        //
        //        [_allArr arrayByAddingObject:data];
        //访问偏好设置文件夹
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //存储数据
        [defaults setObject:data forKey:@"all"];
        //立刻同步
        [defaults synchronize];
        
        
        // NSLog(@"%@",_arr);
        //        NSLog(@"%@",[_arr[0][0] objectForKey:@"video_type"]);
        
        [self.collect reloadData];
        
    } andFailure:^(int fail) {
        
    }];
    
    
    //广告网络请求
    FBY_HomeService *service1 = [[FBY_HomeService alloc]init];
    [service1 searchMessage:@"0" andWithAction:@"type" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/type/adtype" andSuccess:^(NSDictionary *dic) {
        
        //                        NSLog(@"%@",dic);
        
        self.ADArr = [dic objectForKey:@"data"];
        
        [self.collect reloadData];
        
    } andFailure:^(int fail) {
        
    }];
    
    
    
}

- (void)choose:(UIButton *)sender{
    
    if (sender.tag == 2001) {
        
        [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if (sender.tag == 2002){
        
        [self.myScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        
    }else{
        
        [self.myScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        
    }
    
}

//按钮画布跳转
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"%f",self.myScrollView.contentOffset.x);

     self.chooseLab.frame = CGRectMake(SCREEN_WIDTH/2-64-SCREEN_WIDTH/16+(44+SCREEN_WIDTH/16.0)*(self.myScrollView.contentOffset.x/SCREEN_WIDTH), 58, 40, 2);
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //读取
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *arr = [defaults objectForKey:@"all"];
    
    _arr = [NSKeyedUnarchiver unarchiveObjectWithData:arr];
    //    NSLog(@"%@",_arr);
    
    self.tabBarController.tabBar.hidden = NO;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = NO;
    appDelegate.mids.hidden = NO;
}


//搜索按钮点击的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
    
    SearchBarViewController *fvc = [[SearchBarViewController alloc]init];
    
    fvc.str = _searchBar.text;
    
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
    appDelegate.mids.hidden = YES;
    
    [self.navigationController pushViewController:fvc animated:YES];
    
    self.searchBar.text = nil;
    
}

//下拉刷新
- (void)MJRefresh_header{
    
    [self.collect.mj_header beginRefreshing];
    
    //    网络监控句柄
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if ((long)status == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不给力,请检查网络" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    [service searchMessage:nil andWithAction:nil andUrl:@"http://115.159.195.113:8000/37App/index.php/home/index/index" andSuccess:^(NSDictionary *dic) {
        
        //                NSLog(@"%@",dic);
        
        self.DataDic = [dic objectForKey:@"data"];
        
        self.arr = [self.DataDic allValues];
        
        [self.collect reloadData];
        
    } andFailure:^(int fail) {
        
    }];
    
    //广告网络请求
    FBY_HomeService *service1 = [[FBY_HomeService alloc]init];
    [service1 searchMessage:@"0" andWithAction:@"type" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/type/adtype" andSuccess:^(NSDictionary *dic) {
        
        //        NSLog(@"%@",dic);
        
        self.ADArr = [dic objectForKey:@"data"];
        
        [self.collect reloadData];
        
    } andFailure:^(int fail) {
        
    }];
    
    
    [self.collect.mj_header endRefreshing];
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}


//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

//返回分区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _arr.count;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
}

//每个分区头部的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size1;
    
    if (section == 0) {
        size1 = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*27/80+47);
    }else{
        size1 = CGSizeMake(SCREEN_WIDTH, 30);
    }
    return size1;
}

//脚部位置设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 0);
}

//item 点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    NSLog(@"我点击了图片");
    VideoPlayViewController *vdvc = [[VideoPlayViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
    appDelegate.mids.hidden = YES;
    
    vdvc.VideoId = [_arr[indexPath.section][indexPath.row] objectForKey:@"video_id"];
    
    [self.navigationController pushViewController:vdvc animated:YES];
    
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSLog(@"视频保存成功");
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionReusableView *myheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fby" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        myheader.myPag.hidden = NO;
        
        [myheader.titleImg1 sd_setImageWithURL:[_ADArr[0] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg1"]];
        [myheader.titleImg2 sd_setImageWithURL:[_ADArr[1] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg2"]];
        [myheader.titleImg3 sd_setImageWithURL:[_ADArr[2] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg3"]];
        
        [myheader.btn1 setImage:[UIImage imageNamed:@"fire"] forState:UIControlStateNormal];
        [myheader.btn1 addTarget:self action:@selector(fireNext:) forControlEvents:UIControlEventTouchUpInside];
        
        myheader.lab1.text = @"热门推荐";
        self.labTGR1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fireNext:)];
        [myheader.lab1 addGestureRecognizer:_labTGR1];
        
        [myheader.btn2 setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [myheader.btn2 addTarget:self action:@selector(fireNext:) forControlEvents:UIControlEventTouchUpInside];
        
        myheader.lab2.text = @"排行榜";
        self.labTGR2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fireNext:)];
        [myheader.lab2 addGestureRecognizer:_labTGR2];
        
        [myheader.btn3 setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [myheader.btn3 addTarget:self action:@selector(fireNext:) forControlEvents:UIControlEventTouchUpInside];
        
        [myheader.btn11 setImage:nil forState:UIControlStateNormal];
        
        [myheader.btn12 setTitle:nil forState:UIControlStateNormal];
        
        [myheader.btn13 setTitle:nil forState:UIControlStateNormal];
        
        [myheader.btn33 setImage:nil forState:UIControlStateNormal];
        
    }
    else{
        
        [myheader.btn11 addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        int intString1 = [_numArr[indexPath.section] intValue];
        myheader.btn11.tag = intString1;
        [myheader.btn11 setImage:[UIImage imageNamed:_picArr[indexPath.section]] forState:UIControlStateNormal];
        
        [myheader.btn12 addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [myheader.btn12 setTitle:_titArr[indexPath.section] forState:UIControlStateNormal];
        int intString2 = [_numArr[indexPath.section] intValue];
        myheader.btn12.tag = intString2;
        
        [myheader.btn13 addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [myheader.btn13 setTitle:@"更多" forState:UIControlStateNormal];
        int intString3 = [_numArr[indexPath.section] intValue];
        myheader.btn13.tag = intString3;
        
        [myheader.btn33 setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        int intString4 = [_numArr[indexPath.section] intValue];
        myheader.btn33.tag = intString4;
        [myheader.btn33 addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [myheader.btn1 setImage:nil forState:UIControlStateNormal];
        
        myheader.lab1.text = nil;
        
        [myheader.btn2 setImage:nil forState:UIControlStateNormal];
        
        myheader.lab2.text = nil;
        
        [myheader.btn3 setImage:nil forState:UIControlStateNormal];
        
        myheader.titleImg1.image = nil;
        myheader.titleImg2.image = nil;
        myheader.titleImg3.image = nil;
        myheader.myPag.hidden = YES;
        
    }
    
    
    return myheader;
    
}

////分类跳转
- (void)next:(UIButton *)sender{
    
    // NSLog(@"%@",[sender restorationIdentifier]);
    //NSLog(@"%ld",(long)sender.tag);
    NextViewController *nvc = [[NextViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    
    switch ((long)sender.tag) {
        case 1:
            nvc.str = _titArr[1];
            nvc.sstr = @"1";
            break;
        case 2:
            
            nvc.str = _titArr[2];
            nvc.sstr = @"2";
            break;
        case 3:
            
            nvc.str = _titArr[3];
            nvc.sstr = @"3";
            break;
        case 4:
            
            nvc.str = _titArr[4];
            nvc.sstr = @"4";
            break;
        case 5:
            
            nvc.str = _titArr[5];
            nvc.sstr = @"5";
            break;
        case 6:
            
            nvc.str = _titArr[6];
            nvc.sstr = @"6";
            break;
        case 7:
            
            nvc.str = _titArr[7];
            nvc.sstr = @"7";
            break;
        case 8:
            
            nvc.str = _titArr[8];
            nvc.sstr = @"8";
            break;
        case 9:
            
            nvc.str = _titArr[9];
            nvc.sstr = @"9";
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:nvc animated:YES];
    
}

//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    // NSLog(@"%ld",indexPath.section);
    
    [cell.titleImg sd_setImageWithURL:[_arr[indexPath.section][indexPath.row] objectForKey:@"video_img"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
    
    //播放量
    cell.playImg.image = [UIImage imageNamed:@"playPic"];
    
    int intPlay = [[_arr[indexPath.section][indexPath.row] objectForKey:@"video_play"] intValue];
    if (intPlay >= 10000) {
        cell.playLab.text = [NSString stringWithFormat:@"%d.%d万",intPlay/10000,intPlay%10000/1000];
    }
    else{
        cell.playLab.text = [_arr[indexPath.section][indexPath.row] objectForKey:@"video_play"];
    }
    
    //    NSLog(@"%@",cell.playLab.text);
    
    //评论量
    cell.commentImg.image = [UIImage imageNamed:@"comment"];
    int intComment = [[_arr[indexPath.section][indexPath.row] objectForKey:@"video_comment"] intValue];
    
    if (intComment >= 10000) {
        cell.commentLab.text = [NSString stringWithFormat:@"%d.%d万",intComment/10000,intComment%10000/1000];
    }
    else{
        cell.commentLab.text = [_arr[indexPath.section][indexPath.row] objectForKey:@"video_comment"];
    }
    
    cell.contentLab.text = [_arr[indexPath.section][indexPath.row] objectForKey:@"video_sign"];
    
    return cell;
}




//热门推荐跳转
- (void)fireNext:(UIButton *)sender{
    
    FireViewController *fvc = [[FireViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
    appDelegate.mids.hidden = YES;
    
    [self.navigationController pushViewController:fvc animated:YES];
    
}


//弹出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
