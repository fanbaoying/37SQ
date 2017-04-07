//
//  UserSuggestViewController.m
//  37SQ
//
//  Created by administrator on 16/10/24.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "UserSuggestViewController.h"
#import "FBYMyNav.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface UserSuggestViewController ()


@property(strong,nonatomic)FBYMyNav *nav;

@end

@implementation UserSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nav = [[FBYMyNav alloc]initWithTitle:@"用户反馈" andWithByImg:@"NAV" andWithLetBtn1:@"backfinal" andWithLeftBtn2:nil andWithRightBtn1:nil andWithRightBtn2:nil];
    
    [self.nav.leftBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
}

//导航栏返回
- (void)back:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
