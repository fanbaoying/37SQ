//
//  SelfDetailViewController.m
//  37SQ
//
//  Created by administrator on 16/10/18.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "SelfDetailViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "FBY-HomeService.h"

#import "SelfDetailTableViewCell.h"
#import "VideoPlayViewController.h"
#import "AppDelegate.h"
#import "NoteViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#import "MJRefresh.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SelfDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextViewDelegate>

//@property(strong,nonatomic)UIImagePickerController *_imagePickerController;

{

    UIImagePickerController *_imagePickerController;
    UIImagePickerController *_imagePickerController1;
    
}

@property(strong,nonatomic)UIView *myView;

@property(strong,nonatomic)UIButton *headBtn;

//修改头像
@property(strong,nonatomic)UIImage *alterImg;

@property(strong,nonatomic)UIImage *alterBgImg;


@property(strong,nonatomic)UIImageView *bgImg;

@property(strong,nonatomic)UIButton *saveBtn;

@property(strong,nonatomic)UIButton *bgBtn;

@property(strong,nonatomic)UIButton *backBtn;


@property(strong,nonatomic)UITextField *nameText;

@property(strong,nonatomic)UITextView *signText;
@property(strong,nonatomic)UILabel *signLab;


@property(strong,nonatomic)UIButton *videoBtn;

@property(strong,nonatomic)UIButton *noteBtn;

@property(strong,nonatomic)UIButton *collectBtn;


@property(strong,nonatomic)NSMutableArray *userArr;

@property(strong,nonatomic)NSMutableArray *noteArr;

@property(strong,nonatomic)NSMutableArray *videoArr;

@property(strong,nonatomic)NSMutableArray *myArr;

@property(strong,nonatomic)NSDictionary *DataDic;


//画布
@property(strong,nonatomic)UIScrollView *videoScrollView;

@property(strong,nonatomic)UIImageView *titleImg1;

@property(strong,nonatomic)UIImageView *titleImg2;

@property(strong,nonatomic)UIImageView *titleImg3;


@property(strong,nonatomic)UITableView *table1;
@property(strong,nonatomic)UITableView *table2;
@property(strong,nonatomic)UITableView *table3;

//判断头像背景
@property(assign,nonatomic)int bgNum;

@property(assign,nonatomic)int pageNum;

@end

@implementation SelfDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];
    self.myView.backgroundColor = [UIColor purpleColor];
    
    self.bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];
    
    self.headBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/16, SCREEN_WIDTH*3/8-35, 70, 70)];
    [self.headBtn.layer setBorderWidth:1.0];
    
    [self.headBtn addTarget:self action:@selector(selectImageFromAlbum) forControlEvents:UIControlEventTouchUpInside];
    self.headBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.headBtn.layer setCornerRadius:35];
    self.headBtn.clipsToBounds = YES;
    
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/16, SCREEN_WIDTH*3/8+35, 70, 20)];
    self.nameText.textColor = [UIColor whiteColor];
    self.nameText.placeholder = @"设置昵称";
    self.nameText.textAlignment = NSTextAlignmentCenter;
    self.nameText.font = [UIFont systemFontOfSize:12.0];
    
    self.signText = [[UITextView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-10, SCREEN_WIDTH*3/8+20, 170, 45)];
    self.signText.backgroundColor = [UIColor clearColor];
    self.signText.textColor = [UIColor whiteColor];
    self.signText.delegate = self;
    self.signText.textAlignment = NSTextAlignmentJustified;
    self.signText.font = [UIFont systemFontOfSize:12.0];
    //个性签名提示
    self.signLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-5, SCREEN_WIDTH*3/8+20, 170, 30)];
    self.signLab.backgroundColor= [UIColor clearColor];
    self.signLab.text = @"设置个性签名";
    self.signLab.font = [UIFont systemFontOfSize:12.0];
    self.signLab.textColor = [UIColor colorWithRed:191/255.0 green:192/255.0 blue:199/255.0 alpha:1];
    
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    //    self.backBtn.backgroundColor = [UIColor redColor];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    背景图片
    self.bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, SCREEN_WIDTH*3/8-30, 60, 30 )];
    self.bgBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    [self.bgBtn setTitle:@"修改背景" forState:UIControlStateNormal];
    self.bgBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.bgBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgBtn addTarget:self action:@selector(selectImageFromAlbum1) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn.layer setBorderWidth:1.0];
    self.bgBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.bgBtn.layer setCornerRadius:12.0];
    self.bgBtn.clipsToBounds = YES;
    
    //保存
    self.saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, SCREEN_WIDTH*3/8-30, 60, 30 )];
    self.saveBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.saveBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn.layer setBorderWidth:1.0];
    self.saveBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.saveBtn.layer setCornerRadius:12.0];
    self.saveBtn.clipsToBounds = YES;
    
    //投稿
    self.videoBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_WIDTH*3/4-45, (SCREEN_WIDTH-40)/3, 30 )];
    self.videoBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    self.videoBtn.tag = 2001;
    self.videoBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.videoBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.videoBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
//    [self.videoBtn.layer setBorderWidth:1.0];
//    self.videoBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.videoBtn.layer setCornerRadius:12.0];
    self.videoBtn.clipsToBounds = YES;
    
    //帖子
    self.noteBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-40)/3+20, SCREEN_WIDTH*3/4-45, (SCREEN_WIDTH-40)/3, 30 )];
    self.noteBtn.backgroundColor = [UIColor whiteColor];
    self.noteBtn.tag = 2002;
    [self.noteBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    self.noteBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.noteBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.noteBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
//    [self.noteBtn.layer setBorderWidth:1.0];
//    self.noteBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1].CGColor;
    [self.noteBtn.layer setCornerRadius:12.0];
    self.noteBtn.clipsToBounds = YES;
    
    //关注
    self.collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-40)/3-10, SCREEN_WIDTH*3/4-45, (SCREEN_WIDTH-40)/3, 30 )];
    self.collectBtn.backgroundColor = [UIColor whiteColor];
    self.collectBtn.tag = 2003;
    [self.collectBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.collectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.collectBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
//    [self.collectBtn.layer setBorderWidth:1.0];
//    self.collectBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1].CGColor;
    [self.collectBtn.layer setCornerRadius:12.0];
    self.collectBtn.clipsToBounds = YES;
    
    //画布
    
    self.videoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*3/4, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*3/4)];
    self.videoScrollView.backgroundColor = [UIColor clearColor];
    self.videoScrollView.showsHorizontalScrollIndicator = FALSE;
    self.videoScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-SCREEN_WIDTH*3/4);
    self.videoScrollView.pagingEnabled = YES;
    self.videoScrollView.delegate = self;
    
    self.table1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*3/4)];
    self.table1.tag = 1001;
    [self.videoScrollView addSubview:_table1];
    
    self.table2 = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*3/4)];
    self.table2.tag = 1002;
    [self.videoScrollView addSubview:_table2];
    
    self.table3 = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*3/4)];
    self.table3.tag = 1003;
    [self.videoScrollView addSubview:_table3];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table2.delegate = self;
    self.table2.dataSource = self;
    self.table3.delegate = self;
    self.table3.dataSource = self;
    
    //MJRefresh下拉刷新
    self.table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header1)];
    
    //MJRefresh上拉加载
    self.table1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer1)];
    
    //MJRefresh下拉刷新
    self.table2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header1)];
    
    //MJRefresh上拉加载
    self.table2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer1)];
    
    //MJRefresh下拉刷新
    self.table3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header1)];
    
    //MJRefresh上拉加载
    self.table3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer1)];
    
    
    self.userArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.noteArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.videoArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.myArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //网络请求
    //全局ID
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/hobby/index/personmessage";
    
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
                NSLog(@"%@",di);
        
        NSArray *userTemp = [di objectForKey:@"user"];
        NSArray *noteTemp = [di objectForKey:@"note"];
        NSArray *videoTemp = [di objectForKey:@"video"];
        NSArray *myTemp = [di objectForKey:@"my"];
        
        [self.userArr addObjectsFromArray:userTemp];
        [self.noteArr addObjectsFromArray:noteTemp];
        [self.videoArr addObjectsFromArray:videoTemp];
        [self.myArr addObjectsFromArray:myTemp];
        
        [self.bgImg sd_setImageWithURL:[_myArr[0] objectForKey:@"user_bgimg"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
        [self.headBtn sd_setImageWithURL:[_myArr[0] objectForKey:@"user_headimg"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
        self.nameText.text = [_myArr[0] objectForKey:@"user_name"];
        self.signText.text = [_myArr[0] objectForKey:@"user_sign"];
        
        NSLog(@"%@",[_myArr[0] objectForKey:@"user_sign"]);
        
        [self.videoBtn setTitle:[NSString stringWithFormat:@"投稿(%lu)",(unsigned long)_videoArr.count ] forState:UIControlStateNormal];
        
        [self.noteBtn setTitle:[NSString stringWithFormat:@"帖子(%lu)",(unsigned long)_noteArr.count] forState:UIControlStateNormal];
        
        [self.collectBtn setTitle:[NSString stringWithFormat:@"收藏(%lu)",(unsigned long)_userArr.count ] forState:UIControlStateNormal];
        
        if (self.signText.text.length) {
            
            self.signLab.hidden = YES;
            
        }else{
            
            self.signLab.hidden = NO;
        }
        
        
        [self.table1 reloadData];
        [self.table2 reloadData];
        [self.table3 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];

    [self.view addSubview:_myView];
    [self.myView addSubview:_bgImg];
    [self.myView addSubview:_nameText];
    [self.myView addSubview:_headBtn];
    [self.myView addSubview:_signText];
    [self.myView addSubview:_signLab];
    [self.myView addSubview:_backBtn];
    [self.myView addSubview:_saveBtn];
    [self.myView addSubview:_videoBtn];
    [self.myView addSubview:_noteBtn];
    [self.myView addSubview:_collectBtn];
    [self.myView addSubview:_bgBtn];
    
    //创建UIImagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    
    //创建UIImagePickerController对象
    _imagePickerController1 = [[UIImagePickerController alloc] init];
    _imagePickerController1.delegate = self;
    _imagePickerController1.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController1.allowsEditing = YES;
    
    [self.view addSubview:_videoScrollView];
    
}

//限制手机号输入
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.signText) {
        if (textView.text.length == 0) {
            self.signLab.hidden = NO;
        }else{
            self.signLab.hidden = YES;
        }
    }
}

//table1下拉刷新
- (void)MJRefresh_header1{
    
    //    [self.table1.mj_header beginRefreshing];
    
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
    //全局ID
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/hobby/index/personmessage";
    
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
        //        NSLog(@"%@",di);
        
        NSArray *userTemp = [di objectForKey:@"user"];
        NSArray *noteTemp = [di objectForKey:@"note"];
        NSArray *videoTemp = [di objectForKey:@"video"];
        NSArray *myTemp = [di objectForKey:@"my"];
        
        [self.userArr removeAllObjects];
        [self.noteArr removeAllObjects];
        [self.videoArr removeAllObjects];
        [self.myArr removeAllObjects];
        
        [self.userArr addObjectsFromArray:userTemp];
        [self.noteArr addObjectsFromArray:noteTemp];
        [self.videoArr addObjectsFromArray:videoTemp];
        [self.myArr addObjectsFromArray:myTemp];
        
        [self.videoBtn setTitle:[NSString stringWithFormat:@"投稿(%lu)",(unsigned long)_videoArr.count ] forState:UIControlStateNormal];
        
        [self.noteBtn setTitle:[NSString stringWithFormat:@"帖子(%lu)",(unsigned long)_noteArr.count] forState:UIControlStateNormal];
        
        [self.collectBtn setTitle:[NSString stringWithFormat:@"关注(%lu)",(unsigned long)_userArr.count ] forState:UIControlStateNormal];
        
        
        [self.table1 reloadData];
        [self.table2 reloadData];
        [self.table3 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
    [self.table1.mj_header endRefreshing];
    [self.table2.mj_header endRefreshing];
    [self.table3.mj_header endRefreshing];
}

//table1上拉加载
- (void)MJRefresh_footer1{
    
    //    [self.table1.mj_footer beginRefreshing];
    
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
    
//    NSLog(@"-----%@",str);
    
    //网络请求
    //全局ID
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/hobby/index/personmessage";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:userid forKey:@"userid"];
    [mutdic setObject:str forKey:@"page"];
    //    [mutdic setObject:uurl forKey:@"key"];
    //    NSLog(@"%@",mutd/ic);
    //1.创建ADHTTPSESSIONMANGER对象
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
        //        NSLog(@"%@",di);
        
        NSString *code = [di objectForKey:@"code"];
        int intString = [code intValue];
        if ( intString == 500) {
            self.pageNum--;
        }
        else{
        
        NSArray *userTemp = [di objectForKey:@"user"];
        NSArray *noteTemp = [di objectForKey:@"note"];
        NSArray *videoTemp = [di objectForKey:@"video"];
        NSArray *myTemp = [di objectForKey:@"my"];

        [self.userArr addObjectsFromArray:userTemp];
        [self.noteArr addObjectsFromArray:noteTemp];
        [self.videoArr addObjectsFromArray:videoTemp];
        [self.myArr addObjectsFromArray:myTemp];
        
        [self.videoBtn setTitle:[NSString stringWithFormat:@"投稿(%lu)",(unsigned long)_videoArr.count ] forState:UIControlStateNormal];
        
        [self.noteBtn setTitle:[NSString stringWithFormat:@"帖子(%lu)",(unsigned long)_noteArr.count] forState:UIControlStateNormal];
        
        [self.collectBtn setTitle:[NSString stringWithFormat:@"收藏(%lu)",(unsigned long)_userArr.count ] forState:UIControlStateNormal];
        
        
        [self.table1 reloadData];
        [self.table2 reloadData];
        [self.table3 reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
    [self.table1.mj_footer endRefreshing];
    [self.table2.mj_footer endRefreshing];
    [self.table3.mj_footer endRefreshing];
}

//弹出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

//打开相机
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.bgNum = 1;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        ////        如果是图片
        if (self.bgNum == 1) {
            self.alterImg = info[UIImagePickerControllerEditedImage];
            
            
            [self.headBtn setImage:_alterImg forState:UIControlStateNormal];
            
            self.bgNum = 0;
        }else{
            
        self.alterBgImg = info[UIImagePickerControllerEditedImage];
            
           self.bgImg.image = _alterBgImg;
            self.bgNum = 0;
        }
}
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum1
{
    //NSLog(@"相册");
    _imagePickerController1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.bgNum = 2;
    
    [self presentViewController:_imagePickerController1 animated:YES completion:nil];
    
}

//保存设置
- (void)save:(UIButton *)sender{
    
    [self.view endEditing:YES];

    //    网络监控句柄
    AFNetworkReachabilityManager *manager1 = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager1 startMonitoring];
    
    [manager1 setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //组织字典,可按老方法
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    NSLog(@"%@",userid);
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_nameText.text forKey:@"username"];
    [mutdic setObject:_signText.text forKey:@"usersign"];
    [mutdic setObject:userid forKey:@"userid"];
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:@"http://115.159.195.113:8000/37App/index.php/home/index/exnamesign" parameters:mutdic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        
//        if (!_alterBgImg) {
//            
//            
//        }else
     if (_alterBgImg){
        
            NSData *data = UIImagePNGRepresentation(_alterBgImg);
            
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmm";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            //上传
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            //        NSString *imagename = [NSString stringWithFormat:@"image%d",i];
            
            [formData appendPartWithFileData:data name:@"image1" fileName:fileName mimeType:@"image/png"];
            
        }
        
//        if (!_alterImg){
//            
//        }else
            if (_alterImg){
            
            NSData *bgData = UIImagePNGRepresentation(_alterImg);
            
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *bgFormatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            bgFormatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *bgStr = [bgFormatter stringFromDate:[NSDate date]];
            NSString *bgFileName = [NSString stringWithFormat:@"%@.png", bgStr];
            
            //上传
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            //        NSString *imagename = [NSString stringWithFormat:@"image%d",i];
            
            [formData appendPartWithFileData:bgData name:@"image" fileName:bgFileName mimeType:@"image/png"];
            
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        //
        //                NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showProgress:1.0 *
             uploadProgress.completedUnitCount / uploadProgress.totalUnitCount];
//            self.progressView.progress = 1.0 *
//            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        });

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
                        NSLog(@"上传成功 %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        
                        NSLog(@"上传失败 %@", error);
    }];
    


//[self dismissViewControllerAnimated:YES completion:nil];



}

//图片和视频保存完毕后的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.bgNum = 0;
    
    self.pageNum = 1;
    
    self.tabBarController.tabBar.hidden = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
}


- (void)next:(UIButton *)sender{
    
    if (sender.tag == 2001) {
        
        [self.videoScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if (sender.tag == 2002){
        
        [self.videoScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        
    }else{
        
        [self.videoScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1001) {
        return _videoArr.count;
    }else if(tableView.tag == 1003){
    
        return _userArr.count;
        
    }else{
        
        return _noteArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}

//cell 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 1001) {
        
    VideoPlayViewController *vdvc = [[VideoPlayViewController alloc]init];
    
    vdvc.VideoId = [_videoArr[indexPath.row] objectForKey:@"video_id"];
    NSLog(@"%@",vdvc.VideoId);
    
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
          appDelegate.mids.hidden=YES;
    
    [self presentViewController:vdvc animated:YES completion:nil];
    
    }else if(tableView.tag == 1002){
    
        NoteViewController *tzvc = [[NoteViewController alloc]init];
        
        tzvc.TZid = [_noteArr[indexPath.row] objectForKey:@"allnote_id"];
//        NSLog(@"%@",vdvc.VideoId);
        
        self.tabBarController.tabBar.hidden = YES;
        
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = YES;
          appDelegate.mids.hidden=YES;
        
        [self presentViewController:tzvc animated:YES completion:nil];
    }else{
    
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelfDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[SelfDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (tableView.tag == 1001) {
        
        [cell.videoImg sd_setImageWithURL:[_videoArr[indexPath.row] objectForKey:@"video_img"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
        
        cell.titleLab.text = [_videoArr[indexPath.row] objectForKey:@"video_name"];
        cell.playImg.image = [UIImage imageNamed:@"play"];
        
        int intPlay = [[_videoArr[indexPath.row] objectForKey:@"video_play"] intValue];
        if (intPlay >= 10000) {
            cell.playLab1.text = [NSString stringWithFormat:@"%d.%d万",intPlay/10000,intPlay%10000/1000];
        }
        else{
            cell.playLab1.text = [_videoArr[indexPath.row] objectForKey:@"video_play"];
        }
        
        cell.commentImg.image = [UIImage imageNamed:@"commentdl"];
        
        int intComment = [[_videoArr[indexPath.row] objectForKey:@"video_comment"] intValue];
        if (intComment >= 10000) {
            cell.commentLab1.text = [NSString stringWithFormat:@"%d.%d万",intComment/10000,intComment%10000/1000];
        }
        else{
            cell.commentLab1.text = [_videoArr[indexPath.row] objectForKey:@"video_comment"];
        }
        cell.headImg.image = nil;
        cell.nameLab.text = nil;
        cell.signLab.text = nil;
        
        return cell;
        
    }else if (tableView.tag == 1002){
        
        [cell.videoImg sd_setImageWithURL:[_noteArr[indexPath.row] objectForKey:@"allnote_img"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
        
        cell.titleLab.text = [_noteArr[indexPath.row] objectForKey:@"allnote_name"];
        
        cell.commentImg.image = [UIImage imageNamed:@"commentdl"];
        
        int intComment = [[_noteArr[indexPath.row] objectForKey:@"allnote_comment"] intValue];
        if (intComment >= 10000) {
            cell.commentLab1.text = [NSString stringWithFormat:@"%d.%d万",intComment/10000,intComment%10000/1000];
        }
        else{
            cell.commentLab1.text = [_noteArr[indexPath.row] objectForKey:@"allnote_comment"];
        }
        cell.headImg.image = nil;
        cell.nameLab.text = nil;
        cell.signLab.text = nil;
        
        return cell;
        
        
    }else{
        
        cell.titleLab.text = nil;
        cell.playImg.image = nil;
        cell.playLab1.text = nil;
        cell.commentImg.image = nil;
        cell.commentLab1.text = nil;
        
        [cell.headImg sd_setImageWithURL:[_userArr[indexPath.row] objectForKey:@"user_headimg"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
        cell.nameLab.text = [_userArr[indexPath.row] objectForKey:@"user_name"];
        cell.signLab.text = [_userArr[indexPath.row] objectForKey:@"user_sign"];
        
        return cell;
    }
    
    
}

//按钮画布跳转
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.videoScrollView.contentOffset.x < SCREEN_WIDTH/2.0) {
        self.videoBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
        [self.videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.videoBtn.layer.borderColor = [UIColor clearColor].CGColor;
        self.noteBtn.backgroundColor = [UIColor whiteColor];
        [self.noteBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        self.noteBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1].CGColor;
        
        self.collectBtn.backgroundColor = [UIColor whiteColor];
        [self.collectBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        self.collectBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1].CGColor;
    }
    if (self.videoScrollView.contentOffset.x > SCREEN_WIDTH/2 && self.videoScrollView.contentOffset.x < SCREEN_WIDTH/2+SCREEN_WIDTH) {
        
        self.noteBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
        [self.noteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.noteBtn.layer.borderColor = [UIColor clearColor].CGColor;
        
        self.videoBtn.backgroundColor = [UIColor whiteColor];
        [self.videoBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        self.videoBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1].CGColor;
        
        self.collectBtn.backgroundColor = [UIColor whiteColor];
        [self.collectBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        self.collectBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1].CGColor;
        
    }
    if (self.videoScrollView.contentOffset.x > SCREEN_WIDTH/2.0+SCREEN_WIDTH) {
        
        self.collectBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
        [self.collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.collectBtn.layer.borderColor = [UIColor clearColor].CGColor;
        
        self.videoBtn.backgroundColor = [UIColor whiteColor];
        [self.videoBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        self.videoBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1].CGColor;
        
        self.noteBtn.backgroundColor = [UIColor whiteColor];
        [self.noteBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        self.noteBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1].CGColor;
        
    }
    
}

- (void)back:(UIButton *)sender{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD dismiss];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
