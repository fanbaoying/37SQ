//
//  VideoPlayViewController.m
//  LZHPlayer
//
//  Created by lzh on 16/8/9.
//  Copyright © 2016年 lzh. All rights reserved.
//

#import "XYVideoPlayerView.h"
#import "XYVideoModel.h"
#import "GiveService.h"
#import "Masonry.h"
#import "VideoCommentViewController.h"
#import "VideoPlayViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "FinalGiveservice.h"
#import "OtherDetailViewController.h"//他人详情页
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "ReportViewController.h"
#import "SelfDetailViewController.h"

//#import "UIButton+WebCache.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface VideoPlayViewController ()<XYVideoPlayerViewDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    UIView *_headPlayerView;
}
@property(strong,nonatomic)VideoCommentViewController *CommentView;//第二界面
//评论的
@property(strong,nonatomic)UIButton *linkstartBtn;//测试连接开始按钮
@property(strong,nonatomic)UIButton *hideBtn;//消失的Btn
@property(strong,nonatomic)UIButton *headbtn;//头像
@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UILabel *go;
@property (nonatomic, strong) UITextView *testTextField;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *curve;
@property (weak, nonatomic) IBOutlet UIView *videoBackView;
@property(strong,nonatomic)XYVideoModel *model;//视频播放模型
@property(strong,nonatomic)UIButton *backback;//返回按钮
@property(strong,nonatomic)UILabel *lineLab;//简介下面的线
@property(strong,nonatomic)UIButton *TopdetailBtn;//最上面两个LAB
@property(strong,nonatomic)UIButton *TopcommeBtn;
@property (strong,nonatomic) UIView *Bottomview;//下方大VIEW
@property(strong,nonatomic)UIScrollView *BottomScl;//下方SCL
@property(strong,nonatomic)NSTimer *refresh;//定时器
@property(strong,nonatomic)UIButton *ThreeBtn;//三个按钮
@property(strong,nonatomic)UILabel *ThreeLab;
@property(strong,nonatomic)UILabel *playLab;//播放量
@property(strong,nonatomic)UILabel *commentLab;
@property(strong,nonatomic)UIView *FirstView;//SCL第一界面
@property(strong,nonatomic)NSMutableArray *homeArr;//总数据数组
@property(strong,nonatomic)NSArray *buttonpicArr;//按钮图片数组
@property(assign,nonatomic)CGFloat  whatWID;//评论长度
@property(assign,nonatomic)BOOL iscollect;//是否收藏
@property(assign,nonatomic)BOOL ismylove;//是否关注
@property(strong,nonatomic)UIButton *addlove;//关注按钮
@property(strong,nonatomic)UIView *yanView;//颜文字VIEW
@property(assign,nonatomic)BOOL yanBool;//颜文字BOOL
@property(strong,nonatomic)UIButton *LeftBtn;//颜文字按钮
@property(assign,nonatomic)BOOL supportBool;//点赞BOOL
@property(assign,nonatomic)CGFloat WhatKeyboardH;

/** 视频播放视图 */
@property (nonatomic, strong) XYVideoPlayerView *playerView;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //准备区
    self.iscollect=NO;
    self.ismylove=NO;
    //隐藏下方
    self.tabBarController.tabBar.hidden=YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    //创建视频插件
    // 创建视频播放控件
    self.model = [[XYVideoModel alloc]init];
  _headPlayerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.width*9/16.0)];
    [self.view addSubview:_headPlayerView];
    
    self.playerView = [XYVideoPlayerView videoPlayerView];
    self.playerView.delegate = self;
    [_headPlayerView addSubview:self.playerView];
    self.playerView = self.playerView;
    self.playerView.frame=CGRectMake(0, 0, SCREEN_WIDHN, SCREEN_WIDHN*9/16.0);
 
   
    //button按钮图
    self.buttonpicArr=@[@"播放器点赞",@"stardl",@"播放器举报"];
    
    
    //下方VIEW
 self.Bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDHN*9/16.0, SCREEN_WIDHN, SCREEN_HEIGHT-SCREEN_WIDHN*9/16.0)];
    self.Bottomview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_Bottomview];
    
   
    //下方控件
    //scl
    self.BottomScl=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDHN, SCREEN_HEIGHT-SCREEN_WIDHN*9/16.0-30)];
    self.BottomScl.contentSize=CGSizeMake(SCREEN_WIDHN*2, SCREEN_HEIGHT-SCREEN_WIDHN*9/16.0-30);
    self.BottomScl.delegate=self;
    self.BottomScl.pagingEnabled=YES;
    self.BottomScl.showsVerticalScrollIndicator=NO;
    [self.Bottomview addSubview:_BottomScl];
    
    //scl第一界面
    
    self.FirstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, SCREEN_HEIGHT-SCREEN_WIDHN*9/16.0-30)];
    
    self.FirstView.backgroundColor=[UIColor whiteColor];
    [self.BottomScl addSubview:_FirstView];
   //评论页
    self.CommentView=[[VideoCommentViewController alloc]init];
    [self addChildViewController:_CommentView];
    _CommentView.view.frame=CGRectMake(SCREEN_WIDHN, 0, SCREEN_WIDHN, SCREEN_HEIGHT-SCREEN_WIDHN*9/16.0);
    [self.BottomScl addSubview:self.CommentView.view];
        //滑动的标题
    //简介按钮
    self.TopdetailBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/8 *1.5, 0, SCREEN_WIDHN/8, 30)];
    [self.TopdetailBtn addTarget:self action:@selector(changeoffset:) forControlEvents:UIControlEventTouchUpInside];
    [self.TopdetailBtn setTitle:@"简介" forState:0];
    self.TopdetailBtn.tag=1;
    self.TopdetailBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.TopdetailBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.TopdetailBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];

     [self.Bottomview addSubview:_TopdetailBtn];
    //评论
   self.TopcommeBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/8*5.5, 0, 40, 30)];
    self.TopcommeBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
     [self.TopcommeBtn addTarget:self action:@selector(changeoffset:) forControlEvents:UIControlEventTouchUpInside];

     self.TopcommeBtn.tag=2;
     self.TopcommeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.TopcommeBtn setTitleColor:[UIColor lightGrayColor] forState:0];

    [self.Bottomview addSubview:_TopcommeBtn];
    
    //三个button
    for (int i=0; i < 3; i++) {
        self.ThreeBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-120)/4 *(i+1) +40*i,  90, 40, 40)];
//        self.ThreeBtn.backgroundColor=[UIColor grayColor];
        self.ThreeBtn.tag=1000 +i;
        [self.ThreeBtn setImage:[UIImage imageNamed:_buttonpicArr[i]] forState:UIControlStateNormal];
    //BUTTON下面数字
        self.ThreeLab=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-120)/4 *(i+1) +40*i, 130, 40, 20)];
        self.ThreeLab.tag=2000+i;
        self.ThreeLab.textColor=[UIColor lightGrayColor];
        self.ThreeLab.textAlignment=NSTextAlignmentCenter;
        self.ThreeLab.font=[UIFont systemFontOfSize:12];
//        self.ThreeLab.backgroundColor=[UIColor blueColor];
    
        //预留事件
        [self.ThreeBtn addTarget:self action:@selector(addcollect:) forControlEvents:UIControlEventTouchUpInside];

        [self.FirstView addSubview:_ThreeBtn];
        [self.FirstView addSubview:_ThreeLab];
      }
    //两个小图标和lable
    UIImageView *play=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-120)/4, 60, 20, 20)];
    play.image=[UIImage imageNamed:@"play"];
    
    self.playLab=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-120)/4+20, 60, 40, 20)];
    self.playLab.font=[UIFont systemFontOfSize:12];
    self.playLab.textColor=[UIColor lightGrayColor];
    [self.FirstView addSubview:_playLab];
    [self.FirstView addSubview:play];
    //评论小图标 暂弃
//    UIImageView *comment=[[UIImageView alloc]initWithFrame:CGRectMake(90, 40, 20, 20)];
//    comment.image=[UIImage imageNamed:@"commentdl"];
//    [self.FirstView addSubview:comment];
//    self.commentLab=[[UILabel alloc]initWithFrame:CGRectMake(110, 40, 40, 20)];
//    self.commentLab.font=[UIFont systemFontOfSize:12];
//    self.commentLab.textColor=[UIColor lightGrayColor];
//   [self.FirstView addSubview:_commentLab];
    //关注
 self.addlove=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN-80, 190, 60, 30)];
    [_addlove addTarget:self action:@selector(addup:) forControlEvents:UIControlEventTouchUpInside];
    
    [_addlove setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
_addlove.layer.borderColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
    _addlove.layer.borderWidth=1;
    _addlove.titleLabel.font=[UIFont systemFontOfSize:13 weight:0.5];
    [_addlove setTitle:@"关注" forState:UIControlStateNormal];
    _addlove.layer.cornerRadius=5;
    _addlove.clipsToBounds=YES;
    [self.FirstView addSubview:_addlove];
    //简介下面的线
    self.lineLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/8*1.5, 30, SCREEN_WIDHN/8, 2)];
    self.lineLab.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.Bottomview addSubview:_lineLab];
    
    
    
    //定时器
     self.refresh =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshname) userInfo:nil repeats:YES];
  
    //网络请求//评论页id


    GiveService *tesit=[[GiveService alloc]init];
//    NSLog(@"+++++++++++++%@",_VideoId);
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/videodetail";
    [tesit searchMessage:_VideoId andAction:@"Videodetail" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
//                    NSLog(@"-------%@",dic);
//        NSLog(@"+++++++++++++%@",_VideoId);
        self.homeArr  =[dic objectForKey:@"data"];
            self.CommentView.VVideoId=_VideoId;
      
//        [self.CommentView gethomemessage];
//                NSLog(@"%@",_homeArr);
    }
     ];
 //评论的位置
    self.testView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -50, SCREEN_WIDHN, 50)];
    self.testView.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:_testView];
    
    self.testTextField = [[UITextView alloc] initWithFrame:CGRectMake(60, 5, SCREEN_WIDHN-120, 40)];
    self.testTextField.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
//    self.testTextField.backgroundColor=[UIColor redColor];
    self.testTextField.textColor=[UIColor whiteColor];
    self.testTextField.delegate=self;
    
   

    [self setkeyboardview];
    
 //判断是否收藏
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
   NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
   AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *collect=[[NSMutableDictionary alloc]initWithCapacity:0];
    [collect setObject: squserid forKey:@"userid"];
    [collect setObject:_VideoId forKey:@"videoid"];
 [manager POST:@"http://115.159.195.113:8000/37App/index.php/home/type/whatcollect" parameters:collect progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     if (responseObject) {
      UIButton *haven=[self.view viewWithTag:1001];
     [haven setImage:[UIImage imageNamed:@"heartdl"] forState:0];
         self.iscollect=YES;}
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"(没有返回值)---%@",error);
    }];
       }
    
    
}

//点赞
-(void)addsafe{
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/test/thumb";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_VideoId forKey:@"video_id"];
    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
    }];
    
}
//取消点赞
- (void)dele{
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/test/thumb";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_VideoId forKey:@"video_id"];
    [dic setObject:_VideoId forKey:@"what"];

    
    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
    }];
    
}


//提示框消失
- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;}
//添加关注
- (void)addup:(UIButton *)sender{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
        
            if (_ismylove==YES) {
             //取消关注
                AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
                NSMutableDictionary *collect=[[NSMutableDictionary alloc]initWithCapacity:0];
                [collect setObject: squserid forKey:@"userid"];
                [collect setObject:[_homeArr[0] objectForKey:@"user_id"] forKey:@"upid"];
                [manager POST:@"http://115.159.195.113:8000/37App/index.php/home/type/deletelove" parameters:collect progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [self.addlove setTitle:@"关注" forState:0];
                    self.ismylove=NO;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消关注成功" preferredStyle:UIAlertControllerStyleAlert];
                    [self  presentViewController:alert animated:YES completion:nil];
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //        NSLog(@"(没有返回值)---%@",error);
                }];
            }else{
                //添关注
                
                AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
                NSMutableDictionary *collect=[[NSMutableDictionary alloc]initWithCapacity:0];
                [collect setObject: squserid forKey:@"userid"];
                [collect setObject:[_homeArr[0] objectForKey:@"user_id"] forKey:@"upid"];
                [manager POST:@"http://115.159.195.113:8000/37App/index.php/home/type/addlove" parameters:collect progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [self.addlove setTitle:@"已关注" forState:0];
                    self.ismylove=YES;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加关注成功" preferredStyle:UIAlertControllerStyleAlert];
                    //
                    [self  presentViewController:alert animated:YES completion:nil];
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //        NSLog(@"(没有返回值)---%@",error);
                }];
            }}else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"还没有登录哦" preferredStyle:UIAlertControllerStyleAlert];
                //
                [self  presentViewController:alert animated:YES completion:nil];
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
           }


}

//添加收藏事件
- (void)addcollect:(UIButton *)sender{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
     
    if (sender.tag==1001) {
   if (_iscollect) {
            //取消收藏
           AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
            NSMutableDictionary *collect=[[NSMutableDictionary alloc]initWithCapacity:0];
            [collect setObject: squserid forKey:@"userid"];
            [collect setObject:_VideoId forKey:@"videoid"];
            [manager POST:@"http://115.159.195.113:8000/37App/index.php/home/type/deletecollect" parameters:collect progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                UIButton *haven=[self.view viewWithTag:1001];
                [haven setImage:[UIImage imageNamed:@"stardl"] forState:0];
                self.iscollect=NO;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消收藏成功" preferredStyle:UIAlertControllerStyleAlert];
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
            [collect setObject:_VideoId forKey:@"videoid"];
            [manager POST:@"http://115.159.195.113:8000/37App/index.php/home/type/addcollect" parameters:collect progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                UIButton *haven=[self.view viewWithTag:1001];
                [haven setImage:[UIImage imageNamed:@"heartdl"] forState:0];
                self.iscollect=YES;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加收藏成功" preferredStyle:UIAlertControllerStyleAlert];
                //
                [self  presentViewController:alert animated:YES completion:nil];
                 [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //        NSLog(@"(没有返回值)---%@",error);
            }];
          }}
        //举报
        if(sender.tag==1002){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {}];
             UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"举报" style:2 handler:^(UIAlertAction * _Nonnull action) {
                 ReportViewController *vc=[[ReportViewController alloc]init];
                 vc.Whatid=_VideoId;
                 vc.Whattype=0;
                 [self presentViewController:vc animated:YES completion:nil];
             }];
             [alert addAction:action1];
            [alert addAction:action2];
            [self  presentViewController:alert animated:YES completion:nil];
          
         }
        if(sender.tag==1000){
            if (_supportBool==NO) {
                [sender setImage:[UIImage imageNamed:@"播放器点赞红色"] forState:0];
                [self addsafe];
                self.supportBool=YES;
            }else{
                [sender setImage:[UIImage imageNamed:@"播放器点赞"] forState:0];
                self.supportBool=NO;
                [self dele];
            }}
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"还没有登录哦" preferredStyle:UIAlertControllerStyleAlert];
        //
        [self  presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    }

}





//最上面BUTTON事件
-(void)changeoffset:(UIButton *)sender{
    UIButton *geter=[self.view viewWithTag:sender.tag];
    if (geter.tag==1) {
        [self.BottomScl setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
[self.BottomScl setContentOffset:CGPointMake(SCREEN_WIDHN, 0) animated:YES];
    
    }

}

//SCOL控制函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.lineLab.frame=CGRectMake(SCREEN_WIDHN/8.0*1.5 +SCREEN_WIDHN/8.0*3.5*(scrollView.contentOffset.x/SCREEN_WIDHN), 30, SCREEN_WIDHN/8 +(_whatWID-SCREEN_WIDHN/8)*(scrollView.contentOffset.x/SCREEN_WIDHN), 2);
    if (scrollView.contentOffset.x/(SCREEN_WIDHN-150.0)>1) {
        [self.TopcommeBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];
        [self.TopdetailBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    }else{
        [self.TopdetailBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];
        [self.TopcommeBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    }

}

////详情正文高度自适应
- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}


//Lab自适应长度
- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
- (void) startlink{
  
    [self setUI];

    [self.linkstartBtn removeFromSuperview];

}
- (void)refreshname{
    if (_homeArr) {
        
        
        //是否关注
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        NSString *squserid = [SQUserid objectForKey:@"userid"];
        if (squserid) {
        AFHTTPSessionManager *what=[AFHTTPSessionManager manager];
        NSMutableDictionary *ddic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [ddic setObject: squserid forKey:@"userid"];
        [ddic setObject:[_homeArr[0] objectForKey:@"user_id"]  forKey:@"upid"];
        [what POST:@"http://115.159.195.113:8000/37App/index.php/home/type/whatlove" parameters:ddic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject) {
                [self.addlove setTitle:@"已关注" forState:0];
                self.ismylove=YES;}
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"(没有返回值)---%@",error);
        }];
        }

        
        
        
        //创建视频播放器
//         [self setUI];
        self.linkstartBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2.0-25,(SCREEN_WIDHN*9/16.0)/2 -25, 50, 50)];
//        self.linkstartBtn.backgroundColor=[UIColor redColor];
        [self.linkstartBtn setImage:[UIImage imageNamed:@"play1025"] forState:0];
        [self.linkstartBtn addTarget:self action:@selector(startlink) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_linkstartBtn];
        
       //各种label,button
        //最上面评论数
       [self.TopcommeBtn setTitle:[NSString stringWithFormat:@"评论(%@)",[_homeArr[0] objectForKey:@"video_comment"]] forState:0];
      self.whatWID=  [self getWidthWithTitle:_TopcommeBtn.titleLabel.text font:_TopcommeBtn.titleLabel.font];
        self.TopcommeBtn.frame=CGRectMake(SCREEN_WIDHN/8*5.0, 0, _whatWID, 30);
       
        //播放量和评论数
    //转为多少万
    int intPlay =[[_homeArr[0] objectForKey:@"video_play"] intValue];
    if (intPlay >= 10000) {
        self.playLab.text = [NSString stringWithFormat:@"%d.%d万",intPlay/10000,intPlay%10000/1000];}else{
            self.playLab.text=[_homeArr[0] objectForKey:@"video_play"];}
//        self.commentLab.text=[_homeArr[0] objectForKey:@"video_comment"];
        //分享数 收藏数
        for (int i=0; i <2 ; i++){
        
            UILabel *go=[self.view viewWithTag:2000+i];
            if (i==0) {
                go.text=[_homeArr[0] objectForKey:@"video_share"];

            }
            if (i==1) {
                go.text=[_homeArr[0] objectForKey:@"video_collect"];

            }}
        
        //视频简介
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDHN-20, 80)];
        title.numberOfLines=0;
        
       CGFloat whatheight=[self getHeightByWidth:SCREEN_WIDHN-20 title:[_homeArr[0] objectForKey:@"video_sign"] font:[UIFont systemFontOfSize:12]] ;
      title.text=[_homeArr[0] objectForKey:@"video_sign"];
        title.font=[UIFont systemFontOfSize:12];
        title.textAlignment=NSTextAlignmentCenter;
        if (whatheight<60) {
             title.frame=CGRectMake(10, 10, SCREEN_WIDHN-20, whatheight);
        }
       
        [self.FirstView addSubview:title];
        
        //头像
       self.headbtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-120)/4, 180, 50, 50)];
        self.headbtn.backgroundColor=[UIColor yellowColor];
        self.headbtn.layer.cornerRadius=25;
        self.headbtn.clipsToBounds=YES;
        [self.headbtn addTarget:self action:@selector(goupView:) forControlEvents:UIControlEventTouchUpInside];
        [self.headbtn sd_setImageWithURL:[_homeArr[0] objectForKey:@"user_headimg"] forState:UIControlStateNormal];
       self. headbtn.tag=[[_homeArr[0] objectForKey:@"user_id"] intValue];
        [self.FirstView addSubview:_headbtn];
        //名字
        UILabel *upname=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-120)/4+55, 190, 120, 20)];
        upname.font=[UIFont systemFontOfSize:12];
        upname.text=[_homeArr[0] objectForKey:@"user_name"];
//        upname.backgroundColor=[UIColor yellowColor];
        [self.FirstView addSubview:upname];
        
        //时间
        UILabel *uptime=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-120)/4+55, 210, 100, 20)];
        uptime.textColor=[UIColor lightGrayColor];
        uptime.font=[UIFont systemFontOfSize:12];
        uptime.text=[NSString stringWithFormat:@"%@投递",[self timeD_Value:[_homeArr[0] objectForKey:@"video_time"]]];
//        uptime.backgroundColor=[UIColor redColor];
        [self.FirstView addSubview:uptime];
        
        [self.refresh invalidate];
        self.refresh=nil;
        
    }

    
}
//跳转UP主页
- (void)goupView:(UIButton *)sender{
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if ([[NSString stringWithFormat:@"%ld",(long)_headbtn.tag] isEqualToString:squserid]) {
        SelfDetailViewController *vc=[[SelfDetailViewController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        OtherDetailViewController *vc=[[OtherDetailViewController alloc]init];
        vc.otherUserid =[NSString stringWithFormat:@"%ld",(long)_headbtn.tag];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)MakeBottomView{

}

//导航栏消失
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
//状态栏显示控制
- (BOOL)prefersStatusBarHidden {
    return YES;//隐藏为YES，显示为NO
}
- (void)setUI{
    
    
    
    self.model.url = [NSURL URLWithString:[_homeArr[0] objectForKey:@"video_url"]];
    //
    self.model.name = [_homeArr[0] objectForKey:@"video_name"];
    self.playerView.videoModel = _model;
    //[self.playerView changeCurrentplayerItemWithVideoModel:model];
    ////////////测试
//    [self.playerView dlpause];
   
}

#pragma mark XYVideoPlayerViewDelegate
- (void)fullScreenWithPlayerView:(XYVideoPlayerView *)videoPlayerView
{
    if (self.playerView.isRotate) {
        [UIView animateWithDuration:0.3 animations:^{
            _headPlayerView.transform = CGAffineTransformRotate(self.videoBackView.transform, M_PI_2);
            _headPlayerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
            self.playerView.frame = _headPlayerView.bounds;
            //消失
            self.Bottomview.hidden=YES;
            self.testView.hidden=YES;
            self.linkstartBtn.hidden=YES;
            
        }];
        
    }else{
        //改变透明度d
        
        self.testView.alpha=0;
        self.Bottomview.alpha=0;
        self.linkstartBtn.alpha=0;
        [UIView animateWithDuration:0.3 animations:^{
            _headPlayerView.transform = CGAffineTransformIdentity;
            _headPlayerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16);
            self.playerView.frame = _headPlayerView.bounds;
             //出现
                self.Bottomview.hidden=NO;
                self.Bottomview.alpha=1;
            self.testView.hidden=NO;
            self.testView.alpha=1;
            self.linkstartBtn.hidden=NO;
            self.linkstartBtn.alpha=1;
        }];
        
    }
}
- (void)backToBeforeVC{
    
    if (!self.playerView.isRotate) {
     //显示下方
        self.tabBarController.tabBar.hidden=NO;
        
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = NO;
          appDelegate.mids.hidden=NO;

                if (self.CommentView.thumbArr.count>0) {
            //发送点赞
          NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/test/thumb";
            AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:_CommentView.thumbArr forKey:@"comment_id"];
            
            [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"(没有返回值)---");
            }];}
         
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)dealloc{
    
    [self.playerView deallocPlayer];
}

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

//改变LAB是否出现
-(void)textViewDidChange:(UITextView *)textView{
  
}

// 自定义系统弹出键盘上方的view --->
- (void)setkeyboardview
{
    //    self.testTextField = [[UITextView alloc] initWithFrame:CGRectMake(60, 5, SCREEN_WIDHN-120, 40)];
    
//    _testView.backgroundColor=[UIColor groupTableViewBackgroundColor];
      self.go=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDHN-120, 20)];
    self.go.textColor=[UIColor whiteColor];
    self.go.font=[UIFont systemFontOfSize:12];
//    self.go.backgroundColor=[UIColor lightGrayColor];
    self.go.text=@"随便说点什么";
    [self.testTextField addSubview:_go];
    [_testView addSubview:_testTextField];
   UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn addTarget:self action:@selector(addcomment) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"飞机"] forState:0];
    rightBtn.frame = CGRectMake(SCREEN_WIDHN-50, 10, 40, 30);
   [_testView addSubview:rightBtn];
    self.LeftBtn=[[UIButton alloc]init];
//    self.LeftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.LeftBtn setImage:[UIImage imageNamed:@"playcommentdl"] forState:0];
    self.LeftBtn.frame = CGRectMake(10, 10, 30, 30);
    [self.LeftBtn addTarget:self action:@selector(yanaction) forControlEvents:UIControlEventTouchUpInside];
  
    [_testView addSubview:_LeftBtn];
    //线
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(60, 42, SCREEN_WIDHN-120, 1)];
    line.backgroundColor=[UIColor whiteColor];
    [self.testView addSubview:line];
    //颜文字VIEW及颜文字
    NSArray *yanArr=@[@[@"(●'◡'●)ﾉ♥",@"<(▰˘◡˘▰)>",@"(｡・`ω´･) ",@"(≖ ‿ ≖)✧"],
  @[@"( ° ▽、° )",@"(｡･ω･)ﾉﾞ",@"(/= _ =)/~┴┴",@" (ノ｀Д´)ノ "],
  @[@"<(￣︶￣)>",@" []~(￣▽￣)~*",@"╮(╯▽╰)╭",@"(￣３￣)a"],
  @[@" (＞﹏＜) ",@"(→_→)",@"(￣o￣) . z Z",@"o(￣ヘ￣*o)"]];
    self.yanView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDHN, 280)];
    self.yanView.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            UIButton *yan=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-50)/4*j+10*(j+1),30+(i*50), (SCREEN_WIDHN-50)/4, 30)];
            [yan setTitleColor:[UIColor lightGrayColor] forState:0];
            yan.titleLabel.font=[UIFont systemFontOfSize:10];
//            yan.backgroundColor=[UIColor redColor];
            [yan addTarget:self action:@selector(addyanAction:) forControlEvents:UIControlEventTouchUpInside];
           [ yan setTitle:yanArr[i][j] forState:0];
            yan.titleLabel.text=yanArr[i][j];
            [self.yanView addSubview:yan];
        }
        
        
    }
//透明隐藏按钮
    self.hideBtn=[[UIButton alloc]init];
        _hideBtn.backgroundColor=[UIColor lightGrayColor];
        self.hideBtn.alpha=0.7;
       [_hideBtn addTarget:self action:@selector(hidetarget) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_hideBtn];
    // 通知-监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    // 通知-监听键盘回收事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
//颜文字按钮
- (void)addyanAction:(UIButton *)sender{
   self.testTextField.text=[NSString stringWithFormat:@"%@%@",_testTextField.text,sender.titleLabel.text];

}
//颜文字
- (void)yanaction{
    if (_yanBool==NO) {
        
        [self.LeftBtn setImage:[UIImage imageNamed:@"keyboarddl"] forState:0];
    [self.testTextField resignFirstResponder];
         self.testTextField.inputView=_yanView ;
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waitplease) userInfo:nil repeats:NO];
  
        self.yanBool=YES;
        
    }else{
        [self.LeftBtn setImage:[UIImage imageNamed:@"playcommentdl"] forState:0];
            self.testTextField.inputView=nil ;
            [self.testTextField resignFirstResponder];
      [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waitplease) userInfo:nil repeats:NO];
        
        self.yanBool=NO;
        }

}
- (void)waitplease{
 
          [self.testTextField becomeFirstResponder];
 
}
- (void)changeKeyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    // 键盘弹出后的frame的结构体对象
    NSValue *valueEndFrame = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 得到键盘弹出后的键盘视图所在y坐标
    CGFloat keyBoardEndY = valueEndFrame.CGRectValue.origin.y;
    // 键盘弹出的动画时间
    self.duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    // 键盘弹出的动画曲线
    self.curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    //消失的btn
   self.hideBtn.hidden=NO;
   self.hideBtn.frame=CGRectMake(0,  [UIScreen mainScreen].bounds.size.width*9/16.0+30, SCREEN_WIDHN, keyBoardEndY -50-[UIScreen mainScreen].bounds.size.width*9/16.0-30);
    //提示LAB
    self.go.hidden=YES;
    ///Users/administrator/Desktop/37SQ-5 2/37SQ.xcodeproj颜文字view
//    self.yanView.frame=CGRectMake(0, keyBoardEndY, SCREEN_WIDHN, SCREEN_HEIGHT-keyBoardEndY);
//    
    // 添加移动动画，使视图跟随键盘移动(动画时间和曲线都保持一致)
    [UIView animateWithDuration:[_duration doubleValue] animations:^{
//        [UIView setAnimationBeginsFromCurrentState:YES];
       [UIView setAnimationCurve:[_curve intValue]];
        self.testView.center = CGPointMake(_testView.center.x, keyBoardEndY - _testView.bounds.size.height/2.0 );
        self.WhatKeyboardH=keyBoardEndY;
        //input view 自动的
 //        self.yanView.frame=CGRectMake(0, 0, SCREEN_WIDHN,  (SCREEN_HEIGHT-keyBoardEndY)*2);
//        NSLog(@"_________%f",keyBoardEndY);
        self.hideBtn.alpha=0.8;
        
    }];
    
}
//键盘弹回去函数
- (void)changeKeyboardWillHideNotification:(NSNotification *)notification
{
//    [self.LeftBtn setImage:[UIImage imageNamed:@"playcommentdl"] forState:0];
    if (_testTextField.text.length==0) {
        self.go.hidden=NO;
    }
    [UIView animateWithDuration:[_duration doubleValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[_curve intValue]];
        _testView.frame=CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDHN, 50);
    }];
}
//键盘弹回去
-(void)hidetarget{
//    [self.view endEditing:YES];
    [self.testTextField resignFirstResponder];
    self.yanBool=YES;
//    [self.hideBtn removeFromSuperview];
    self.hideBtn.hidden=YES;
    self.hideBtn.alpha=0;
}
//发送评论
- (void)addcomment{
    //获取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
    if (_testTextField.text.length>2)  {
        //组织时间
        NSDate *date = [NSDate date];
        NSDateFormatter *datefo = [[NSDateFormatter alloc]init];
        [datefo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [datefo stringFromDate:date];
    
//        NSLog(@"%@---------%@",self.CommentView.VVideoId,_VideoId);
    FinalGiveservice *go=[[FinalGiveservice alloc]init];
    ////测试.-------
    NSMutableDictionary *send=[[NSMutableDictionary alloc]initWithCapacity:0];
    [send setObject:_testTextField.text forKey:@"content"];
    [send setObject:@"0" forKey:@"type"];
    [send setObject:_VideoId forKey:@"videoid"];
    //userid//时间
      
         [send setObject:dateStr forKey:@"time"];
        [send setObject:squserid forKey:@"userid"];
    //发送请求
    [go addMessage:@"http://115.159.195.113:8000/37App/index.php/hobby/index/addcomment"andDic:send andSafe:nil andSuccess:^(NSDictionary *dic) {
//
//        NSLog(@"%@",dic);
  }];
        self.testTextField.text=nil;
        [self hidetarget];
//        //刷新评论列表//刷新完主页面没有重新加载
//        VideoCommentViewController *vc=[[VideoCommentViewController alloc]init];
//        vc.VVideoId=_VideoId;
//        [vc gethomemessage];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"这可是回帖啊" message:@"太短了..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"唔..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]; [alert addAction:action1];
        [self  presentViewController:alert animated:YES completion:nil];
    
    }
        
    }else{
        //未登录事件
              
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好好好,这就去." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
              
              [alert addAction:action1];
              [self  presentViewController:alert animated:YES completion:nil];
        [self hidetarget];
        
            
    
    }}


@end
