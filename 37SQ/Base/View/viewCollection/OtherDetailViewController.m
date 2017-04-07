//
//  VideoDetailViewController.m
//  FBY--first
//
//  Created by administrator on 16/10/8.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "OtherDetailViewController.h"
#import "UIImageView+WebCache.h"

#import "OtherTableViewCell.h"
#import "VideoPlayViewController.h"
#import "AppDelegate.h"
#import "NoteViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

#import "FBY-HomeService.h"

//私信
#import "chatViewController.h"
#import "SecondViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface OtherDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(strong,nonatomic)UIView *myView;

@property(strong,nonatomic)UIImageView *headImg;

@property(strong,nonatomic)UIImageView *bgImg;

@property(strong,nonatomic)UIButton *addFriendBtn;

@property(strong,nonatomic)UIButton *letterBtn;

@property(strong,nonatomic)UIButton *attentionBtn;

//@property(strong,nonatomic)UIButton *supportBtn;

@property(strong,nonatomic)UIButton *backBtn;

@property(strong,nonatomic)UILabel *nameLab;

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


@property(assign,nonatomic)int pageNum;

//好友id请求
@property(strong,nonatomic)NSArray *fbyUserIdArr;

//关注BOOL值
@property(assign,nonatomic)BOOL ismylove;

//判断好友
@property(assign,nonatomic)BOOL friendlove;

@end

@implementation OtherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.friendlove = NO;

    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];
    self.myView.backgroundColor = [UIColor purpleColor];
    
    self.bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];
    
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/16, SCREEN_WIDTH*3/8-35, 70, 70)];
    [self.headImg.layer setBorderWidth:1.0];
    self.headImg.layer.borderColor = [UIColor clearColor].CGColor;
    [self.headImg.layer setCornerRadius:35];
    self.headImg.clipsToBounds = YES;

    self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/16, SCREEN_WIDTH*3/8+35, 70, 20)];
    self.nameLab.textColor = [UIColor whiteColor];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.font = [UIFont systemFontOfSize:12.0];
    
    self.signLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_WIDTH*3/8+35, 160, 20)];
    self.signLab.textColor = [UIColor whiteColor];
    self.signLab.font = [UIFont systemFontOfSize:12.0];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
//    self.backBtn.backgroundColor = [UIColor redColor];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    //私信
    self.letterBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_WIDTH*3/8-30, 40, 25 )];
    self.letterBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    self.letterBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    self.letterBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.letterBtn addTarget:self action:@selector(letter:) forControlEvents:UIControlEventTouchUpInside];
    [self.letterBtn setTitle:@"私信" forState:UIControlStateNormal];
//    [self.letterBtn.layer setBorderWidth:1.0];
//    self.letterBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.letterBtn.layer setCornerRadius:12.0];
    self.letterBtn.clipsToBounds = YES;
    
    //关注
    self.attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH+10)*2/3-10, SCREEN_WIDTH*3/8-30, 40, 25 )];
    self.attentionBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    self.attentionBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.attentionBtn addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
    [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
//    [self.attentionBtn.layer setBorderWidth:1.0];
//    self.attentionBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.attentionBtn.layer setCornerRadius:12.0];
    self.attentionBtn.clipsToBounds = YES;
    
    //赞
//    self.supportBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, SCREEN_WIDTH*3/8-30, 40, 25 )];
//    self.supportBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
//    self.supportBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
//    self.supportBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.supportBtn addTarget:self action:@selector(support:) forControlEvents:UIControlEventTouchUpInside];
//    [self.supportBtn.layer setBorderWidth:1.0];
//    self.supportBtn.layer.borderColor = [UIColor clearColor].CGColor;
//    [self.supportBtn.layer setCornerRadius:12.0];
//    self.supportBtn.clipsToBounds = YES;
    
    //添加好友
    self.addFriendBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, SCREEN_WIDTH*3/8-30, 40, 25 )];
    self.addFriendBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    self.addFriendBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    self.addFriendBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.addFriendBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
//    [self.addFriendBtn setTitle:@"+好友" forState:UIControlStateNormal];
    [self.addFriendBtn.layer setBorderWidth:1.0];
    self.addFriendBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.addFriendBtn.layer setCornerRadius:12.0];
    self.addFriendBtn.clipsToBounds = YES;
    
    //投稿
    self.videoBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_WIDTH*3/4-45, (SCREEN_WIDTH-40)/3, 30 )];
    self.videoBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    self.videoBtn.tag = 2001;
    self.videoBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
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
    self.noteBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
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
    self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
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
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/hobby/index/personmessage";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_otherUserid forKey:@"userid"];
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
        
        [self.userArr addObjectsFromArray:userTemp];
        [self.noteArr addObjectsFromArray:noteTemp];
        [self.videoArr addObjectsFromArray:videoTemp];
        [self.myArr addObjectsFromArray:myTemp];
        
        [self.bgImg sd_setImageWithURL:[_myArr[0] objectForKey:@"user_bgimg"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
        [self.headImg sd_setImageWithURL:[_myArr[0] objectForKey:@"user_headimg"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
        self.nameLab.text = [_myArr[0] objectForKey:@"user_name"];
        self.signLab.text = [_myArr[0] objectForKey:@"user_sign"];
//        NSString *supporStr = [NSString stringWithFormat:@"赞(%@)",[_myArr[0] objectForKey:@"user_praise"]];
//        [self.supportBtn setTitle:supporStr forState:UIControlStateNormal];
        
        [self.videoBtn setTitle:[NSString stringWithFormat:@"投稿(%lu)",(unsigned long)_videoArr.count ] forState:UIControlStateNormal];
        
        [self.noteBtn setTitle:[NSString stringWithFormat:@"帖子(%lu)",(unsigned long)_noteArr.count] forState:UIControlStateNormal];
        
        [self.collectBtn setTitle:[NSString stringWithFormat:@"关注(%lu)",(unsigned long)_userArr.count] forState:UIControlStateNormal];
        
        
        [self.table1 reloadData];
        [self.table2 reloadData];
        [self.table3 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
    //好友列表请求
    //网络请求
    FBY_HomeService *service = [[FBY_HomeService alloc]init];
    [service searchMessage:_otherUserid andWithAction:@"otherid" andUrl:@"http://115.159.195.113:8000/37App/index.php/hobby/friend/testgo" andSuccess:^(NSDictionary *dic) {
        
        NSString *code = [dic objectForKey:@"code"];
        int intString = [code intValue];
        
        if (intString == 500) {
            
        }else{
        
            NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
            NSString *userid = [SQUserid objectForKey:@"userid"];
            
            self.fbyUserIdArr = [dic objectForKey:@"data"];
            
            for (int i = 0; i < _fbyUserIdArr.count; i++) {
                NSString *str = [_fbyUserIdArr[i] objectForKey:@"user_id"];
                //            int intString = [str intValue];
                NSLog(@"%@",str);
                
                if ([str isEqualToString:userid] ) {
                    
                    self.friendlove = YES;
                    break;
                }
            }
            
            
            if (!userid) {
                
                self.addFriendBtn.hidden = YES;
                
            }else{
                
                self.addFriendBtn.hidden = NO;
 
                    if (self.friendlove == YES ) {
                        
                        [self.addFriendBtn setTitle:@"已添加" forState:UIControlStateNormal];
                        self.addFriendBtn.hidden = YES;
                        
                    }else{
                        
                        [self.addFriendBtn setTitle:@"+好友" forState:UIControlStateNormal];
                        
                    }
                }
            
        }
        
        
    } andFailure:^(int fail) {
        
    }];
    
    
    //是否关注
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
        AFHTTPSessionManager *what=[AFHTTPSessionManager manager];
        NSMutableDictionary *ddic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [ddic setObject: squserid forKey:@"userid"];
        [ddic setObject:_otherUserid forKey:@"upid"];
        [what POST:@"http://115.159.195.113:8000/37App/index.php/home/type/whatlove" parameters:ddic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject) {
                [self.attentionBtn setTitle:@"已关注" forState:0];
                
                self.ismylove=YES;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"(没有返回值)---%@",error);
        }];
    }
    
    [self.view addSubview:_myView];
    [self.myView addSubview:_bgImg];
    [self.myView addSubview:_nameLab];
    [self.myView addSubview:_headImg];
    [self.myView addSubview:_signLab];
    [self.myView addSubview:_backBtn];
    [self.myView addSubview:_letterBtn];
    [self.myView addSubview:_attentionBtn];
//    [self.myView addSubview:_supportBtn];
    [self.myView addSubview:_addFriendBtn];
    [self.myView addSubview:_videoBtn];
    [self.myView addSubview:_noteBtn];
    [self.myView addSubview:_collectBtn];
    
    [self.view addSubview:_videoScrollView];

}


//私信跳转
- (void)letter:(UIButton *)sender{
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    if (userid == nil) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请登录后尝试" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
            
            if (self.friendlove == YES) {
                //新建一个聊天会话View Controller对象
                chatViewController *cvc = [[chatViewController alloc]init];
                //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
                cvc.conversationType = ConversationType_PRIVATE;
                //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
                cvc.targetId = _otherUserid;
                //设置聊天会话界面要显示的标题
                cvc.title = [_myArr[0] objectForKey:@"user_name"];
                //显示聊天会话界面
                [self presentViewController:cvc animated:YES completion:nil];
            }else{
            
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请添加好友后尝试" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alert addAction:action1];
                [self presentViewController:alert animated:YES completion:nil];
                
            }

    }
}
//关注跳转
- (void)attention:(UIButton *)sender{
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        NSString *squserid = [SQUserid objectForKey:@"userid"];
        if (squserid) {
            
            if (_ismylove == YES) {
                //取消关注
                AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
                NSMutableDictionary *collect=[[NSMutableDictionary alloc]initWithCapacity:0];
                [collect setObject: squserid forKey:@"userid"];
                [collect setObject:_otherUserid forKey:@"upid"];
                [manager POST:@"http://115.159.195.113:8000/37App/index.php/home/type/deletelove" parameters:collect progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self.attentionBtn setTitle:@"+关注" forState:0];
                    self.ismylove=NO;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消关注成功" preferredStyle:UIAlertControllerStyleAlert];
                    [self  presentViewController:alert animated:YES completion:nil];
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //        NSLog(@"(没有返回值)---%@",error);
                }];
            }else{
                //添加收藏
                
                AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
                NSMutableDictionary *collect=[[NSMutableDictionary alloc]initWithCapacity:0];
                [collect setObject: squserid forKey:@"userid"];
                [collect setObject:_otherUserid forKey:@"upid"];
                [manager POST:@"http://115.159.195.113:8000/37App/index.php/home/type/addlove" parameters:collect progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self.attentionBtn setTitle:@"已关注" forState:0];
                    self.ismylove=YES;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加关注成功" preferredStyle:UIAlertControllerStyleAlert];
                    //
                    [self  presentViewController:alert animated:YES completion:nil];
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //        NSLog(@"(没有返回值)---%@",error);
                }];
                
            }
            
        }
    
}

//提示框消失
- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}

//添加好友
- (void)addFriend:(UIButton *)sender{

    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];

    
        for (int i = 0; i < _fbyUserIdArr.count; i++) {
            NSString *str = [_fbyUserIdArr[i] objectForKey:@"user_id"];
            if ([str isEqualToString:userid] ) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经是好友了" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                }];
                
                [alert addAction:action1];
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                
                NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
                NSString *squserid = [SQUserid objectForKey:@"userid"];
                AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
                [dic setObject:squserid forKey:@"userid"];
                [dic setObject:_otherUserid forKey:@"upid"];
                [dic setObject:@"1" forKey:@"type"];//1表示加好友类型

                NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/addfriend";
                [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求发送成功~" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好~" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                    [self.addFriendBtn setTitle:@"已发送" forState:UIControlStateNormal];
                        }];
                        [alert addAction:action1];
                        [self  presentViewController:alert animated:YES completion:nil];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    }];
                
            }
        }
        
//    }
    
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
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/hobby/index/personmessage";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_otherUserid forKey:@"userid"];
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
        
        [self.collectBtn setTitle:[NSString stringWithFormat:@"关注(%lu)",(unsigned long)_userArr.count] forState:UIControlStateNormal];
        
        
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
    
    NSString *urlstr=@"http://115.159.195.113:8000/37App/index.php/hobby/index/personmessage";
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_otherUserid forKey:@"userid"];
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
        
        [self.collectBtn setTitle:[NSString stringWithFormat:@"收藏(%lu)",(unsigned long)_userArr.count] forState:UIControlStateNormal];
        
        
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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.pageNum = 1;
    
    self.tabBarController.tabBar.hidden = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
}

//画布跳转
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
    }else if (tableView.tag == 1003){
    
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
    
    OtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[OtherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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

//返回跳转
- (void)back:(UIButton *)sender{
    

    [self dismissViewControllerAnimated:YES completion:nil];

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
