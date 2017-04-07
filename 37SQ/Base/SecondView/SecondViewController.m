//
//  SecondViewController.m
//  37shequ
//
//  Created by administrator on 16/9/22.
//  Copyright © 2016年 hjp. All rights reserved.
//

#import "SecondViewController.h"
#import "MyNav.h"
#import "DLTableViewCell.h"
#import "GiveService.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "ronglistViewController.h"
#import "AddgroupViewController.h"
#import "GroupdetailViewController.h"//群组详情
#import "AppDelegate.h"
#import "MyloveViewController.h"//我的关注界面
#import "GroupspaceViewController.h"//群组消息界面
#import "ScRightUpViewController.h"

#import "FinalGiveservice.h"
#import "AFNetworking.h"

#import "MJRefresh.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,RCIMUserInfoDataSource>
@property(strong,nonatomic)UIButton *hobbyleftbtn;
@property(strong,nonatomic)UIButton *hobbyrightbtn;
@property(strong,nonatomic)UITableView *mygroup;
@property(strong,nonatomic)NSMutableArray *mygrouArr;
@property(strong,nonatomic)NSMutableArray *myArr;//userARR
@property(strong,nonatomic)UIScrollView *twoviewScl;
@property(strong,nonatomic)NSMutableArray *FirstRreshArr;//刷新的GIF
@property(strong,nonatomic)NSMutableArray *SecondRreshArr;
@property(strong,nonatomic)NSMutableArray *ThreeRreshArr;
@property(strong,nonatomic)UILabel * linelab;//线LAB
@property(strong,nonatomic)UIImageView *unloginImg;//未登录盖住的
@property(strong,nonatomic)UIImageView *nulltest;//测试没有内容时

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    //导航栏
    MyNav *nav = [[MyNav alloc]initWithTitle:@"喜好" bgImg:nil leftBtn:@"envelopefinal" rightBtn:@"addfinal"];
   [  nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
     [  nav.rightBtn  addTarget:self action:@selector(rightaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
 
 
    //画布
    self.twoviewScl =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDHN, SCREEN_HEIGHT-160)];
    self.twoviewScl.delegate=self;
    self.twoviewScl.contentSize=CGSizeMake(SCREEN_WIDHN *2, SCREEN_HEIGHT-160);
    [self.view addSubview:_twoviewScl];
    self.twoviewScl.showsHorizontalScrollIndicator=NO;
    self.twoviewScl.pagingEnabled=YES;
    //我的关注界面
     MyloveViewController *myloveview=[[MyloveViewController alloc]init];
    [self addChildViewController:myloveview];
    myloveview.view.frame=CGRectMake(SCREEN_WIDHN, 0, SCREEN_WIDHN, SCREEN_HEIGHT-160);
     [self.twoviewScl addSubview:myloveview.view];
    
    //群组列表
    self.mygroup=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, SCREEN_HEIGHT-160) style:UITableViewStylePlain];
    
    self.mygroup.dataSource=self;
    self.mygroup.delegate=self;
    self.mygroup.tableFooterView=[[UIView alloc]init];;
    [self.mygroup setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
    //

    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
  

    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    //GIF太长 暂时搁置
//    [header setImages:self.FirstRreshArr forState:MJRefreshStateRefreshing];
//    [header setImages:self.SecondRreshArr forState:MJRefreshStateIdle];
//    [header setImages:self.ThreeRreshArr forState:MJRefreshStatePulling];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
    
    // Set header
    self.mygroup.mj_header = header;
    //
    [self.twoviewScl addSubview:_mygroup];
   
//    //我的群组按钮.
    self.hobbyleftbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 69,(SCREEN_WIDHN-30)/2, 30)];
    self.hobbyleftbtn.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
   
    

    self.hobbyleftbtn.titleLabel.font=[UIFont systemFontOfSize:13 weight:0.5];
    [self.hobbyleftbtn setTitle:@"我的群组" forState:UIControlStateNormal];
    self.hobbyleftbtn.layer.cornerRadius=5;
   self.hobbyleftbtn.clipsToBounds=YES;
    
    [self.hobbyleftbtn addTarget:self action:@selector(mygroup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hobbyleftbtn];
    //我的关注按钮
    self.hobbyrightbtn=[[UIButton alloc]initWithFrame:CGRectMake(20+(SCREEN_WIDHN-30)/2, 69,(SCREEN_WIDHN-30)/2, 30)];

    [self.hobbyrightbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    self.hobbyrightbtn.layer.borderColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
     self.hobbyrightbtn.layer.borderWidth=1;
    self.hobbyrightbtn.titleLabel.font=[UIFont systemFontOfSize:13 weight:0.5];
    [self.hobbyrightbtn setTitle:@"我的关注" forState:UIControlStateNormal];
    self.hobbyrightbtn.layer.cornerRadius=5;
   self.hobbyrightbtn.clipsToBounds=YES;
  [self.hobbyrightbtn addTarget:self action:@selector(mylove:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hobbyrightbtn];
 [self.mygroup.mj_header beginRefreshing];
    
    }

//融云获得自己信息和对手信息
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        NSString *gosquserid = [SQUserid objectForKey:@"userid"];
    //自己
    NSLog(@"uuuuuuu--%@---%@",userId,gosquserid);
    if ([gosquserid isEqual: userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = [self.myArr[0] objectForKey:@"user_id"];
        user.name = [self.myArr[0] objectForKey:@"user_name"];
        NSLog(@"%@",user.name);
        user.portraitUri =[self.myArr[0] objectForKey:@"user_headimg"];
        
        return completion(user);
       
    }else{
    
    //别人
    //1.创建ADHTTPSESSIONMANGER对象
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //2.设置该对象返回类型
    manager.responseSerializer=[AFJSONResponseSerializer serializer];

    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];

    [dic setObject:userId forKey:@"userid"];
    
   [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/index/giveme" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      NSDictionary *what = responseObject;
      NSArray *test=[what objectForKey:@"data"];
       RCUserInfo *user = [[RCUserInfo alloc]init];
       user.userId = [test[0] objectForKey:@"user_id"];
       user.name = [test[0] objectForKey:@"user_name"];
       user.portraitUri =[test[0] objectForKey:@"user_headimg"];
       
       return completion(user);
       
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误(没有返回值)---%@",error);
    }];}
}

//界面即将出现

- (void)viewWillAppear:(BOOL)animated{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.addType = 2;
    
    
    //数组初始化
//    self.mygrouArr=[[NSMutableArray alloc]initWithCapacity:0];
//    self.myArr=[[NSMutableArray alloc]initWithCapacity:0];
//    //取userid
//    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
//    NSString *squserid = [SQUserid objectForKey:@"userid"];
////    //网络请求
////    if (squserid) {
//        self.unloginImg.hidden=YES;
//        
//       GiveService *test=[[GiveService alloc]init];
//        NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/index";
//        [test searchMessage:squserid andAction:@"group" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
//            if (dic.count>0) {
//              
//            
//            self.mygrouArr=[dic objectForKey:@"data"];
////            [self.mygroup reloadData];
//            }else{
//                
//                if (!_nulltest) {
//                     self.nulltest=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, SCREEN_HEIGHT-64)];
//                     self.nulltest.image=[UIImage imageNamed:@"nogroup"];
//                    [self.mygroup addSubview:_nulltest];
//                }
//                self.nulltest.hidden=NO;
//            }
//        
//        }];
//       self.unloginImg.hidden=YES;
//    
//    
//    ///获取三大信息
//        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//      NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
//        [dic setObject:squserid forKey:@"userid"];
//        
//        [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/index/giveme" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary *qqq = responseObject;
//            if (qqq.count>0) {
//                 self.myArr=[qqq objectForKey:@"data"];
//            }
//           
//          
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////            NSLog(@"返回三大数据失误");
//        }];
//   }
//    //未登录状态
//    else{
//        if (!_unloginImg) {
//         self.unloginImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, SCREEN_HEIGHT-49-64)];
//        self.unloginImg.image=[UIImage imageNamed:@"unloginbac.jpg"];
//        [self.view addSubview:_unloginImg];}
//        self.unloginImg.hidden=NO;
//        self.nulltest.hidden=YES;
//    }

}
//刷新框架
-(void)loadNewData{
//[self.mygroup.mj_header beginRefreshing];
//    NSLog(@"hahah");
    //取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    
    if (squserid) {
       GiveService *test=[[GiveService alloc]init];
        NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/index";
        [test searchMessage:squserid andAction:@"group" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
            //    NSLog(@"%@",dic);
            self.mygrouArr=[dic objectForKey:@"data"];
            self.myArr=[dic objectForKey:@"user"];
            [self.mygroup reloadData];
//            NSLog(@"------------");
         
        }
         ];}
 [self.mygroup.mj_header endRefreshing];
}

//融云(左边按钮)
-(void)leftaction:(UIButton *)sender{
  //取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
//    NSString *usertoken=[SQUserid objectForKey:@"usertoken"];


    if (squserid) {
   //隐藏下方TARBAR
    self.tabBarController.tabBar.hidden=YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
          appDelegate.mids.hidden=YES;
    ronglistViewController *go=[[ronglistViewController alloc]init];
    
    self.navigationController.navigationBar.hidden=NO;

        [self.navigationController pushViewController:go animated:YES];
    }
    
    else{
            //未登录事件
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好好好,这就去." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]; [alert addAction:action1];
            [self  presentViewController:alert animated:YES completion:nil];
        }

}
//搜索群组(右边按钮)
-(void)rightaction:(UIButton * )sender{
   //取userid
//    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
//    NSString *squserid = [SQUserid objectForKey:@"userid"];
//    if (squserid) {
     ScRightUpViewController *go=[[ScRightUpViewController alloc]init];
        [self.navigationController  pushViewController:go animated:YES];
//}else{
//        
//            //未登录事件
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好好好,这就去." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            }]; [alert addAction:action1];
//            [self  presentViewController:alert animated:YES completion:nil];
    
        
//        }
    
}


//群组列表
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//行数
  
    return _mygrouArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[DLTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"go"];
   
    }
    self.nulltest.hidden=YES;
    //群组空间按钮
    if (_mygrouArr.count>0) {
        cell.groupnum.tag=[[_mygrouArr[indexPath.row] objectForKey:@"group_id"] intValue];
    [cell.groupnum addTarget:self action:@selector(gospace:) forControlEvents:UIControlEventTouchUpInside];
    [cell.groupnum setBackgroundImage:nil forState:0];
    if ([[_mygrouArr[indexPath.row] objectForKey:@"group_message"] intValue]>99) {
        [cell.groupnum setTitle:@"99+" forState:0];
    }else{
        [cell.groupnum setTitle:[_mygrouArr[indexPath.row] objectForKey:@"group_message"] forState:0];}
    //头像及名字
    [  cell.grouppic sd_setImageWithURL:[_mygrouArr[indexPath.row] objectForKey:@"group_img" ] placeholderImage:[UIImage imageNamed:@"load"]];
 cell.groupname.text=[_mygrouArr[indexPath.row] objectForKey:@"group_name" ];
    }
 return cell;
}
//群组空间按钮
-(void)gospace:(UIButton *)sender{
    //发送请求清空动态
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];

        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:squserid forKey:@"userid"];
        [dic setObject:[NSString stringWithFormat:@"%lD",(long)sender.tag] forKey:@"groupid"];
        
        [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/index/removemes" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
      [sender setTitle:@"0" forState:0];
    
    GroupspaceViewController *go=[[GroupspaceViewController alloc]init];
    go.dlgroupid=[NSString stringWithFormat:@"%ld",(long)sender.tag ];
    
    [self.navigationController pushViewController:go animated:YES];
    
    

}


///每行的点击位置
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupdetailViewController *test=[[GroupdetailViewController alloc]init];
   //快速变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    test.grnum=[_mygrouArr[indexPath.row] objectForKey:@"group_number"];
    test.grname=[_mygrouArr[indexPath.row] objectForKey:@"group_name"];
    test.grsign=[_mygrouArr[indexPath.row] objectForKey:@"group_sign"];
    test.grid=[_mygrouArr[indexPath.row] objectForKey:@"group_id"];
    [self.navigationController pushViewController:test animated:YES];
    
}

-  (void)mygroup:(UIButton *)sender{
//自己变色
    self.hobbyleftbtn.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.hobbyleftbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //对手变色
    self.hobbyrightbtn.backgroundColor=[UIColor whiteColor];
    [self.hobbyrightbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
 [self.twoviewScl setContentOffset:CGPointMake(0, 0) animated:YES];

}
-  (void)mylove:(UIButton *)sender{
    //对手变色
    self.hobbyleftbtn.backgroundColor=[UIColor whiteColor];
    [self.hobbyleftbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    self.hobbyleftbtn.layer.borderWidth=1;
      self.hobbyleftbtn.layer.borderColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
    //自己变色
    self.hobbyrightbtn.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.hobbyrightbtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.twoviewScl setContentOffset:CGPointMake(SCREEN_WIDHN, 0) animated:YES];
    
    
}
//滑动时执行的函数

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (_twoviewScl.contentOffset.x>SCREEN_WIDHN/2.0) {
        [self mylove:nil];
//        NSLog(@"ahha");
    }else{
        
        
        [self mygroup:nil];
        
    }
    
}


@end
