//
//  GroupdetailViewController.m
//  37SQ
//
//  Created by administrator on 2016/9/29.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "GroupdetailViewController.h"
#import "AppDelegate.h"
#import "MyNav.h"
#import "GiveService.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "GroupmemberViewController.h"
#import "AFNetworking.h"
#import "OtherDetailViewController.h"
#import "SelfDetailViewController.h"


#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface GroupdetailViewController ()
@property(strong,nonatomic)UILabel *groupnumtit;//群号
@property(strong,nonatomic)UILabel *groupnum;
@property(strong,nonatomic)UILabel *groupnametit;//群组名称
@property(strong,nonatomic)UILabel *groupname;
@property(strong,nonatomic)UILabel *groupsigntit;//群组介绍
@property(strong,nonatomic)UILabel *groupsign;
@property(strong,nonatomic)UILabel *groupmakertit;//创建者
@property(strong,nonatomic)UIButton *groupmakerimg;//创建者头像
@property(strong,nonatomic)UILabel *groupmatetit;//群组成员
@property(strong,nonatomic)UIButton *groupmateimg;//群组成员头像
//@property(strong,nonatomic)UILabel *groupmatename;//群组成员名字
@property(strong,nonatomic)NSTimer *refresh;//定时器
@end

@implementation GroupdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.refresh =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshname:) userInfo:nil repeats:YES];
 //测试区
    //网络请求
    GiveService *tesit=[[GiveService alloc]init];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/detail";
    [tesit searchMessage:_grid andAction:@"groupmember" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
        //            NSLog(@"%@",dic);
        self.memberArr  =[dic objectForKey:@"data"];
        //        NSLog(@"%@",test.memberArr);
    }
     ];
   //隐藏下方TARBAR
    //
    self.tabBarController.tabBar.hidden=YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    //导航栏
    
    MyNav *nav = [[MyNav alloc]initWithTitle:@"群组信息" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    //各种标题
    self.groupnametit=[[UILabel alloc]initWithFrame:CGRectMake(10, 100,100, 20)];
    self.groupnametit.font=[UIFont systemFontOfSize:13 ];
//    self.groupnametit.backgroundColor=[UIColor blueColor];
    self.groupnametit.text=@"群组名称";
    self.groupnametit.textColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    self.groupname=[[UILabel alloc]initWithFrame:CGRectMake(110, 100,SCREEN_WIDHN-110, 20)];
    self.groupname.font=[UIFont systemFontOfSize:13 ];
//    self.groupname.backgroundColor=[UIColor blueColor];
    self.groupname.text=_grname;
    self.groupname.textAlignment=NSTextAlignmentCenter;
    //群号
    self.groupnumtit=[[UILabel alloc]initWithFrame:CGRectMake(10, 140,100, 20)];
    self.groupnumtit.font=[UIFont systemFontOfSize:13 ];
    //    self.groupnametit.backgroundColor=[UIColor blueColor];
    self.groupnumtit.text=@"群组号码";
    self.groupnumtit.textColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    self.groupnum=[[UILabel alloc]initWithFrame:CGRectMake(110, 140,SCREEN_WIDHN-110, 20)];
    self.groupnum.font=[UIFont systemFontOfSize:13 ];
    //    self.groupname.backgroundColor=[UIColor blueColor];
    self.groupnum.text=_grnum;
    self.groupnum.textAlignment=NSTextAlignmentCenter;
    //群组介绍
    self.groupsigntit=[[UILabel alloc]initWithFrame:CGRectMake(10, 180, 100, 20)];
    self.groupsigntit.font=[UIFont systemFontOfSize:13 ];
//    self.groupsigntit.backgroundColor=[UIColor blueColor];
      self.groupsigntit.text=@"群组介绍";
    self.groupsigntit.textColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
 
    self.groupsign=[[UILabel alloc]initWithFrame:CGRectMake(110, 180, SCREEN_WIDHN-110, 100)];
    self.groupsign.numberOfLines=0;
//    self.groupsign.backgroundColor=[UIColor redColor];
    self.groupsign.font=[UIFont systemFontOfSize:13 ];
//    self.groupsign.backgroundColor=[UIColor blueColor];
    self.groupsign.text=_grsign;
     self.groupsign.textAlignment=NSTextAlignmentCenter;
    
    
    self.groupmakertit=[[UILabel alloc]initWithFrame:CGRectMake(10, 275, 100, 50)];
    self.groupmakertit.font=[UIFont systemFontOfSize:13 ];
//    self.groupmakertit.backgroundColor=[UIColor blueColor];
              //头像
    self.groupmakertit.text=@"创建者";
   self.groupmakertit.textColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    
    self.groupmatetit=[[UILabel alloc]initWithFrame:CGRectMake(10, 390, 100, 50)];
    self.groupmatetit.font=[UIFont systemFontOfSize:13 ];
//    self.groupmatetit.backgroundColor=[UIColor blueColor];
    self.groupmatetit.text=@"群组成员";
    self.groupmatetit.textColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    
    ///  //退出群组
   
    UIButton * leavegroup=[[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-50,(SCREEN_WIDHN-20), 40)];
    [leavegroup addTarget:self action:@selector(leavehere:) forControlEvents:UIControlEventTouchUpInside];
    
    [leavegroup setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    leavegroup.layer.borderColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
    leavegroup.layer.borderWidth=1;
    leavegroup.titleLabel.font=[UIFont systemFontOfSize:13 weight:0.5];
    [leavegroup setTitle:@"退出群组" forState:UIControlStateNormal];
    leavegroup.layer.cornerRadius=5;
    leavegroup.clipsToBounds=YES;
    
    if (_Vic==NO) {
        [self.view addSubview:leavegroup];
    }
     [self.view addSubview:_groupnum];
    [self.view addSubview:_groupnumtit];
    [self.view addSubview:_groupnametit];
    [self.view addSubview:_groupsigntit];
    [self.view addSubview:_groupname];
    [self.view addSubview:_groupsign];
    [self.view addSubview:_groupmakertit];
    [self.view addSubview:_groupmatetit];
    //给页面添加手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //向右
    [self.view addGestureRecognizer:swipeGesture];
    
    
}
//轻扫手势触发方法
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)leavehere:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定离开群组么" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我得走.." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *gosquserid = [SQUserid objectForKey:@"userid"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
 
    NSMutableDictionary *dic=[[NSMutableDictionary alloc ]initWithCapacity:0];
    [dic setObject:_grid forKey:@"groupid"];
    NSLog(@"%@",_grid);
    [dic setObject:gosquserid forKey:@"userid"];
    //判断是否是群主
    if (![gosquserid isEqualToString:[_memberArr[0] objectForKey:@"user_id" ]]) {
      [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/friend/leavegroup" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *haha=responseObject;
        NSLog(@"%@",haha);
        
        if (200==[[haha objectForKey:@"code"]intValue]) {
            //删除成功
//            NSLog(@"%@",responseObject);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"朕知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //显示下方并返回
                self.tabBarController.tabBar.hidden=NO;
                AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                appDelegate.mid.hidden = NO;
                  appDelegate.mids.hidden=NO;
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:action1];
            [self  presentViewController:alert animated:YES completion:nil];
        }else{
        //失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出失败" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"纳,纳尼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
            }];
             [alert addAction:action1];
            [self  presentViewController:alert animated:YES completion:nil];
          }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误(没有返回值)--%@",error);
    }];}
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"群主不能走..." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"纳,纳尼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        [self  presentViewController:alert animated:YES completion:nil];
     }
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action2];
     [alert addAction:action1];
    [self  presentViewController:alert animated:YES completion:nil];
}

//
-(void)leftaction:(UIButton * )sender{
//    NSLog(@"%@",self.memberArr);
    //显示下方
    self.tabBarController.tabBar.hidden=NO;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = NO;
      appDelegate.mids.hidden=NO;
   [self.navigationController popViewControllerAnimated:YES];}

//定时器d
-(void)refreshname:(UIButton *)sender{
    if (self.memberArr) {
        //群组成员少于三个时
        if (_memberArr.count<3) {
        //群主
            self.groupmakerimg=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2.0-30, 310, 60, 60)];
//            self.groupmakerimg.backgroundColor=[UIColor redColor];
            [self.groupmakerimg sd_setImageWithURL:[_memberArr[0] objectForKey:@"user_headimg"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loadhead"]];
            self.groupmakerimg.tag=[[_memberArr[0] objectForKey:@"user_id"] integerValue];
            NSLog(@"%lD",(long)self.groupmakerimg.tag);
            [self.groupmakerimg addTarget:self action:@selector(godetail:) forControlEvents:UIControlEventTouchUpInside];
         self.groupmakerimg.layer.cornerRadius=30;
            self.groupmakerimg.clipsToBounds=YES;
             [self.view addSubview:_groupmakerimg];
            UILabel *makername=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2.0-50, 380, 100, 20)];
            makername.font=[UIFont systemFontOfSize:13];
            makername.textAlignment=NSTextAlignmentCenter;
            makername.text=[_memberArr[0] objectForKey:@"user_name"];
            [self.view addSubview:makername];
            
            //循环
            if (_Vic==NO) {
                
            
            for ( int i=0; i<_memberArr.count-1; i++) {
                self.groupmateimg=[[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDHN-160)/5) +(i*(40+(SCREEN_WIDHN-160)/5)), 430, 40, 40)];
                self.groupmateimg.tag=[[_memberArr[i+1] objectForKey:@"user_id"]integerValue];
                NSLog(@"____-------%ld",(long)self.groupmateimg.tag);
                [self.groupmateimg sd_setImageWithURL:[_memberArr[i+1] objectForKey:@"user_headimg" ] forState:0 placeholderImage:[UIImage imageNamed:@"addfinal"]];
                [self.groupmateimg addTarget:self action:@selector(godetail:) forControlEvents:UIControlEventTouchUpInside];
//             self.groupmateimg.backgroundColor=[UIColor redColor];
                self.groupmateimg.layer.cornerRadius=20;
                self.groupmateimg.clipsToBounds=YES;
                [self.view addSubview:_groupmateimg];
                //名字
                UILabel *groupmatename=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-160)/5.0 +i*(40+(SCREEN_WIDHN-160)/5.0)-10, 470, 60, 40)];
                groupmatename.textAlignment=NSTextAlignmentCenter;
                groupmatename.text=[_memberArr[i+1] objectForKey:@"user_name"];
                groupmatename.font=[UIFont systemFontOfSize:12 ];
                [self.view addSubview:groupmatename];
            }}}
        
        else{
            //群主
            self.groupmakerimg=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2.0-30, 310, 60, 60)];
            [self.groupmakerimg sd_setImageWithURL:[_memberArr[0] objectForKey:@"user_headimg"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loadhead"]];
             self.groupmakerimg.tag=[[_memberArr[0] objectForKey:@"user_id"] integerValue];
          [self.groupmakerimg addTarget:self action:@selector(godetail:) forControlEvents:UIControlEventTouchUpInside];
            self.groupmakerimg.layer.cornerRadius=30;
            self.groupmakerimg.clipsToBounds=YES;
            //[  self.groupmakerimg sd_setImageWithURL: placeholderImage:[UIImage imageNamed:@"addfinal"]];
            [self.view addSubview:_groupmakerimg];
            UILabel *makername=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2.0-50, 380, 100, 20)];
            
            makername.font=[UIFont systemFontOfSize:13];
            makername.textAlignment=NSTextAlignmentCenter;
            makername.text=[_memberArr[0] objectForKey:@"user_name"];
            [self.view addSubview:makername];
            //群组成员
            if (_Vic==NO) {
                
            
        for ( int i=0; i<3; i++) {
             self.groupmateimg=[[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDHN-160)/5) +(i*(40+(SCREEN_WIDHN-160)/5)), 430, 40, 40)];
            self.groupmateimg.tag=[[_memberArr[i+1] objectForKey:@"user_id"]integerValue];
               NSLog(@"----------%ld",(long)self.groupmateimg.tag);
            [self.groupmateimg sd_setImageWithURL:[_memberArr[i+1] objectForKey:@"user_headimg" ] forState:0 placeholderImage:[UIImage imageNamed:@"addfinal"]];
            [self.groupmateimg addTarget:self action:@selector(godetail:) forControlEvents:UIControlEventTouchUpInside];
            self.groupmateimg.layer.cornerRadius=20;
            self.groupmateimg.clipsToBounds=YES;
            [self.view addSubview:_groupmateimg];
            
            //名字
            UILabel *groupmatename=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDHN-160)/5.0 +i*(40+(SCREEN_WIDHN-160)/5.0)-10, 470, 60, 40)];
            groupmatename.textAlignment=NSTextAlignmentCenter;
            groupmatename.text=[_memberArr[i+1] objectForKey:@"user_name"];
            //        NSLog(@"%@",[self.memberArr[i] objectForKey:@"user_name"]);
            //        NSLog(@"%@",self.memberArr);
//            groupmatename.backgroundColor=[UIColor blueColor];
            groupmatename.font=[UIFont systemFontOfSize:12 ];
            [self.view addSubview:groupmatename];
            //更多按钮
            if (i==2) {
                UIButton *more=[[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDHN-160)/5) +((i+1)*(40+(SCREEN_WIDHN-160)/5)), 430, 40, 40)];
//                more.backgroundColor=[UIColor redColor];
                [more setBackgroundImage:[UIImage imageNamed:@"more"] forState:0];
                more.layer.cornerRadius=20;
                more.clipsToBounds=YES;
                [more addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:more];
            }
        }}}
          [self.refresh invalidate];
            self.refresh=nil;
    }
    
}
//更多按钮的事件
-(void)more{
 GroupmemberViewController *go=[[GroupmemberViewController alloc]init];
    go.groupid=_grid;
 [self.navigationController pushViewController:go animated:YES];
}
//点头像跳转的事件
-(void)godetail:(UIButton *)sender{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if ([[NSString stringWithFormat:@"%ld",(long)sender.tag] isEqualToString:squserid]) {
        SelfDetailViewController *vc=[[SelfDetailViewController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        OtherDetailViewController *vc=[[OtherDetailViewController alloc]init];
        vc.otherUserid =[NSString stringWithFormat:@"%ld",(long)sender.tag];
        [self presentViewController:vc animated:YES completion:nil];
    }
}








@end
