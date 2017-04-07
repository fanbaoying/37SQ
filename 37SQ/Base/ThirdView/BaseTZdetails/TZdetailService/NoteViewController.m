//
//  NoteViewController.m
//  37SQ
//
//  Created by administrator on 2016/11/3.
//  Copyright © 2016年 practice. All rights reserved.
// 帖子详情页 11-3

#import "NoteViewController.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ReportViewController.h"
#import "NotechatViewController.h"
#import "SelfDetailViewController.h"
#import "OtherDetailViewController.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface NoteViewController ()<UIScrollViewDelegate>
@property(strong,nonatomic)UILabel *Titlab;//标题LAB
@property(strong,nonatomic)UIImageView *TitImg;//标题帖子
@property(strong,nonatomic)UIScrollView *mainScl;//
@property(strong,nonatomic)UITextView *ContentLab;//主题
@property(strong,nonatomic)NSMutableDictionary *homeDic;//数据字典
@property(strong,nonatomic)UIButton *upBtn;//
@property(strong,nonatomic)UIImageView *titPic;//首部图
@property(assign,nonatomic)BOOL thumbBool;//是否点赞
@property(assign,nonatomic)BOOL heartBool;//是否关注
@property(strong,nonatomic)UILabel *thumbLab;//点赞表
@property(strong,nonatomic)UILabel *heartLab;//关注表
@property(strong,nonatomic)UILabel *commentLab;//评论表
@property(strong,nonatomic)NSMutableArray *picArr;
@property(assign,nonatomic)CGFloat whatheight;//第一图之前的高度
@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    //隐藏tabbar及中间的加号
        self.tabBarController.tabBar.hidden = YES;
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = YES;
    appDelegate.mids.hidden=YES;
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.upBtn=[[UIButton alloc]init];
    self.mainScl=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, SCREEN_HEIGHT)];
//    self.mainScl.backgroundColor=[UIColor blueColor];
    self.ContentLab=[[UITextView alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDHN-20, 500)];
    [self.ContentLab setEditable:NO];
    self.ContentLab.textColor=[UIColor lightGrayColor];
       self.ContentLab.font=[UIFont systemFontOfSize:12];
//    self.ContentLab.backgroundColor=[UIColor yellowColor];
    self.Titlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDHN-20, 20)];
//    self.Titlab.backgroundColor=[UIColor redColor];
    self.Titlab.font=[UIFont systemFontOfSize:13 weight:0.5];
    self.Titlab.textAlignment=NSTextAlignmentCenter;
    self.Titlab.numberOfLines=2;
    [self.mainScl addSubview:_ContentLab];
    [self.mainScl addSubview:_upBtn];
    [self.mainScl addSubview:_Titlab];
    self.mainScl.delegate=self;
    [self.view addSubview:_mainScl];
    [self getinfo];
  //下方工具栏
    UIView *toolView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, SCREEN_WIDHN, 30)];
    toolView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:toolView];
    NSArray *BtnArr=@[@"threebackdl",@"threethumbdl",@"threelikedl",@"threechatdl",@"threedeledl"];
    for (int i=0; i<5; i++) {
        UIButton *toolBtn=[[UIButton alloc]initWithFrame:CGRectMake((i+1)*(SCREEN_WIDHN-100)/6+20*i,  5, 20, 20)];
        if (i==1) {
            self.thumbLab=[[UILabel alloc]initWithFrame:CGRectMake((i+1)*(SCREEN_WIDHN-100)/6+20*(i+1),  5, 40, 20)];
            self.thumbLab.textAlignment=NSTextAlignmentCenter;
            self.thumbLab.textColor=[UIColor lightGrayColor];
//            self.thumbLab.backgroundColor=[UIColor blueColor];
            self.thumbLab.font=[UIFont systemFontOfSize:10];
            [toolView addSubview:_thumbLab];
        }
        if (i==2) {
            self.heartLab=[[UILabel alloc]initWithFrame:CGRectMake((i+1)*(SCREEN_WIDHN-100)/6+20*(i+1),  5, 40, 20)];
            self.heartLab.font=[UIFont systemFontOfSize:12];
            self.heartLab.textColor=[UIColor lightGrayColor];
            self.heartLab.textAlignment=NSTextAlignmentCenter;
//            self.heartLab.backgroundColor=[UIColor blueColor];
            [toolView addSubview:_heartLab];
        }
        if (i==3) {
            self.commentLab=[[UILabel alloc]initWithFrame:CGRectMake((i+1)*(SCREEN_WIDHN-100)/6+20*(i+1),  5, 40, 20)];
            self.commentLab.font=[UIFont systemFontOfSize:12];
            self.commentLab.textColor=[UIColor lightGrayColor];
            self.commentLab.textAlignment=NSTextAlignmentCenter;
//                        self.commentLab.backgroundColor=[UIColor blueColor];
            [toolView addSubview:_commentLab];
        }
        [toolBtn setImage:[UIImage imageNamed:BtnArr[i]] forState:0];
        toolBtn.tag=1000+i;
//        toolBtn.backgroundColor=[UIColor lightGrayColor];
        [toolBtn addTarget:self action:@selector(fourbtn:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:toolBtn];
        }
    //判断是否收藏
    [self isorno];
    //给页面添加手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //向右
    [self.view addGestureRecognizer:swipeGesture];
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft; //向左
    [self.view addGestureRecognizer:swipeGestureLeft];
    
    
    
}
//轻扫手势触发方法
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NotechatViewController *vc=[[NotechatViewController alloc]init];
        vc.Whatid=_TZid;
        [self presentViewController:vc animated:YES completion:nil];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {  self.tabBarController.tabBar.hidden=NO;
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = NO;
        appDelegate.mids.hidden=NO;
        
         [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//four BTN
- (void)fourbtn:(UIButton *)sender{
//  UIButton *haha=  [self.view viewWithTag:sender.tag];
    if (sender.tag==1000) {
        self.tabBarController.tabBar.hidden=NO;
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = NO;
         appDelegate.mids.hidden=NO;
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (sender.tag==1001) {
        if (_thumbBool==NO) {
              [sender setImage:[UIImage imageNamed:@"threethumbreddl"] forState:0];
            [self addsafe];
            self.thumbBool=YES;
        }else{
        [sender setImage:[UIImage imageNamed:@"threethumbdl"] forState:0];
            [self dele];
            self.thumbBool=NO;
        }}
    //关注
    if (sender.tag==1002) {
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        NSString *squserid = [SQUserid objectForKey:@"userid"];
        if (squserid) {
        if (_heartBool==NO) {
            [sender setImage:[UIImage imageNamed:@"threeheardreddl"] forState:0];
            self.heartBool=YES;
            [self addlove];
            
        }else{
        [sender setImage:[UIImage imageNamed:@"threelikedl"] forState:0];
            self.heartBool=NO;
            [self delelove];
        }}else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"还没有登录哦" preferredStyle:UIAlertControllerStyleAlert];
            //
            [self  presentViewController:alert animated:YES completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
        }
    }//举报页
    if (sender.tag==1004) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"举报" style:2 handler:^(UIAlertAction * _Nonnull action) {
            ReportViewController *vc=[[ReportViewController alloc]init];
            vc.Whattype=@"1";
            vc.Whatid=_TZid;
            [self presentViewController:vc animated:YES completion:nil];
        
        }];
        [alert addAction:action1];
          [alert addAction:action2];
        [self  presentViewController:alert animated:YES completion:nil];
   }
    if (sender.tag==1003) {
        NotechatViewController *vc=[[NotechatViewController alloc]init];
        vc.Whatid=_TZid;
        [self presentViewController:vc animated:YES completion:nil];
    }

}
//提示框消失
- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;}
//检测是否收藏
- (void)isorno{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/test/whatcollect";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:squserid forKey:@"userid"];
    [dic setObject:_TZid forKey:@"noteid"];
    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *howlong=responseObject;
        if (howlong.count>0) {
            UIButton *btn=[self.view viewWithTag:1002];
            [btn setImage:[UIImage imageNamed:@"threeheardreddl"] forState:0];
            self.heartBool=YES;
        }
        NSLog(@"%@",howlong);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];}

}


//添加收藏
-(void)addlove{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/test/addcollect";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:squserid forKey:@"userid"];
    [dic setObject:_TZid forKey:@"noteid"];
    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功~" preferredStyle:UIAlertControllerStyleAlert];
        //
        [self  presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
    }];

}

- (void)delelove{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/test/deletecollect";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:squserid forKey:@"userid"];
    [dic setObject:_TZid forKey:@"noteid"];
    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
    }];

}
//点赞
-(void)addsafe{
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/test/thumb";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_TZid forKey:@"allnote_id"];
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
    [dic setObject:_TZid forKey:@"allnote_id"];
    [dic setObject:_TZid forKey:@"what"];

    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
    }];

}
//发起请求
- (void)getinfo{
    //图片数组
    self.homeDic=[[NSMutableDictionary alloc]initWithCapacity:0];
    self.picArr=[[NSMutableArray alloc]initWithCapacity:0];
    
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/community/index/notedetail";
       AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:_TZid forKey:@"noteid"];
       [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
           NSArray *con = [responseObject objectForKey:@"data"];
           self.picArr=[responseObject objectForKey:@"pic"];
               NSLog(@"%lu",(unsigned long)_picArr.count);
           self.homeDic=con[0];
           [self givemevalue];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"(没有返回值)---");
        }];

}
//赋值
- (void)givemevalue{
   
    //
    self.thumbLab.text=[_homeDic objectForKey:@"allnote_safe"];
    self.heartLab.text=[_homeDic objectForKey:@"allnote_collect"];
    self.commentLab.text=[_homeDic objectForKey:@"allnote_comment"];

        self.titPic=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 9/16.0*SCREEN_WIDHN)];
        self.titPic.backgroundColor=[UIColor blackColor];
        [self.titPic sd_setImageWithURL:[_homeDic objectForKey:@"allnote_img"] placeholderImage:[UIImage imageNamed:@"load"]];
        [self.mainScl addSubview:_titPic];
 //自适应行高
    CGFloat height=[self getHeightByWidth:SCREEN_WIDHN-20 title:[_homeDic objectForKey:@"allnote_content"] font:[UIFont systemFontOfSize:12]];
//    CGFloat whatimgH = 0.0;
//     CGFloat HavenimgH = 0.0;
     self.whatheight=_titPic.frame.size.height+height+150;
    NSLog(@"_+_+_+_+_+_+_%f",_whatheight);
    for (int i=1; i<_picArr.count; i++) {
        UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(0, _whatheight, SCREEN_WIDHN, SCREEN_WIDHN)];
//        pic.backgroundColor=[UIColor redColor];
//        whatimgH=pic.frame.origin.y+9/16.0*SCREEN_WIDHN;
        [pic sd_setImageWithURL:[_picArr[i] objectForKey:@"noteimg_path"] placeholderImage:[UIImage imageNamed:@"load"]];
        pic.contentMode=UIViewContentModeScaleAspectFit;
        [self.mainScl addSubview:pic];
        self.whatheight=_whatheight+pic.frame.size.height+5;
        NSLog(@"-------%f",_whatheight);
        NSLog(@"++++++++%f",pic.frame.size.height);
//        pic.image.imageOrientation
//        UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(0, _whatheight+(9/16.0*SCREEN_WIDHN+5) *i, SCREEN_WIDHN, 9/16.0*SCREEN_WIDHN)];
        //我先把图片设置成屏幕宽,屏幕高
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
//        [self addSubview:img];
//        //图片会根据宽度自适应高度
//        img.contentMode = UIViewContentModeScaleAspectFit;
//        //图片会根据高度自适应宽度
//        //img.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    if((_whatheight)<SCREEN_HEIGHT){
        self.mainScl.contentSize=CGSizeMake(SCREEN_WIDHN,  SCREEN_HEIGHT+1);}else{
        self.mainScl.contentSize=CGSizeMake(SCREEN_WIDHN,  _whatheight+40);
        }
 
//    self.whatheight=_titPic.frame.size.height+150+height;
//    self.mainScl.contentSize=CGSizeMake(SCREEN_WIDHN, 1000);
    NSLog(@"--------%f",_titPic.frame.size.height+150+height);
    //UP名字头像等
    self.upBtn.frame=CGRectMake(10, _titPic.frame.size.height+50, 20, 20);
    self.upBtn.tag=[[_homeDic objectForKey:@"user_id"] integerValue];
    [self.upBtn sd_setImageWithURL:[_homeDic objectForKey:@"user_name"] forState:0 placeholderImage:[UIImage imageNamed:@"loadhead"]];
    [self.upBtn addTarget:self action:@selector(goupView:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *upname=[[UILabel alloc]initWithFrame:CGRectMake(40, _titPic.frame.size.height+50, 200, 20)];
    upname.font=[UIFont systemFontOfSize:12];
    upname.text=[_homeDic objectForKey:@"user_name"];
    [self.mainScl addSubview:upname];
 
    //主体加标题
    self.Titlab.frame=CGRectMake(10, _titPic.frame.size.height, SCREEN_WIDHN, 40);
    self.ContentLab.frame=CGRectMake(10, _titPic.frame.size.height+100, SCREEN_WIDHN-20, height+20);
   self.ContentLab.text=[_homeDic objectForKey:@"allnote_content"];

    self.Titlab.text=[_homeDic objectForKey:@"allnote_name"];

}
//循环创建IMGVIEW
- (void)makephoto{
 
 
}

//跳转UP主页
- (void)goupView:(UIButton *)sender{
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if ([[NSString stringWithFormat:@"%ld",(long)_upBtn.tag] isEqualToString:squserid]) {
        SelfDetailViewController *vc=[[SelfDetailViewController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        OtherDetailViewController *vc=[[OtherDetailViewController alloc]init];
        vc.otherUserid =[NSString stringWithFormat:@"%ld",(long)_upBtn.tag];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

//自适应高度
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

@end
