//
//  chatViewController.m
//  37SQ
//
//  Created by administrator on 2016/9/29.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "chatViewController.h"
#import "MyNav.h"
#import<RongIMKit/RongIMKit.h>
#import "OtherDetailViewController.h"
#import "SelfDetailViewController.h"

@interface chatViewController ()

@end
///聊天详情页
@implementation chatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [[RCIM sharedRCIM] setGroupInfoDataSource:self];

    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=YES;
 //
    MyNav *nav = [[MyNav alloc]initWithTitle:self.title bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    

    
}

//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{}
-(void)leftaction:(UIButton * )sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//点击头像事件
- (void)didTapCellPortrait:(NSString *)userId{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if ([userId isEqualToString:squserid]) {
        SelfDetailViewController *vc=[[SelfDetailViewController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        OtherDetailViewController *vc=[[OtherDetailViewController alloc]init];
        vc.otherUserid =userId;
            [self presentViewController:vc animated:YES completion:nil];
    }

}
@end
