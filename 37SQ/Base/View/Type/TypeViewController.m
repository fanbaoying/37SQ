//
//  TypeViewController.m
//  FBY--first
//
//  Created by administrator on 16/9/29.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "TypeViewController.h"
#import "NextViewController.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface TypeViewController ()<UIWebViewDelegate>

@property(strong,nonatomic)UIWebView *myWebView;


@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.myWebView.delegate = self;
    self.myWebView.scrollView.scrollEnabled = NO;
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSString * htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.myWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    
    
    [self.view addSubview:self.myWebView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];// testapp:alert:Hi_NWJ_9
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"testapp"]) {
        
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"alert"])
        {
            
            //            if ([[components objectAtIndex:2]isEqualToString:@"nvc"]) {
            
            NextViewController *nvc = [[NextViewController alloc]init];
            
            int intString = [[components objectAtIndex:2] intValue];
            
            switch (intString) {
                case 1:
                    nvc.str = @"音乐";
                    nvc.sstr = @"1";
                    break;
                case 2:
                    
                    nvc.str = @"脱口秀";
                    nvc.sstr = @"2";
                    break;
                case 3:
                    nvc.str = @"TV";
                    nvc.sstr = @"3";
                    break;
                case 4:
                    nvc.str = @"科技";
                    nvc.sstr = @"4";
                    break;
                case 5:
                    nvc.str = @"游戏";
                    nvc.sstr = @"5";
                    break;
                case 6:
                    nvc.str = @"天文";
                    nvc.sstr = @"6";
                    break;
                case 7:
                    nvc.str = @"电影";
                    nvc.sstr = @"7";
                    break;
                case 8:
                    nvc.str = @"生活";
                    nvc.sstr = @"8";
                    break;
                case 9:
                    nvc.str = @"搞笑";
                    nvc.sstr = @"9";
                    break;
                    
                default:
                    break;
            }
            
            [self.navigationController pushViewController:nvc animated:YES];
            
            //            }
            //            UIAlertView *alert = [[UIAlertView alloc]
            //                                  initWithTitle:@"测试" message:[components objectAtIndex:2]
            //                                  delegate:self cancelButtonTitle:nil
            //                                  otherButtonTitles:@"OK", nil];
            //            [alert show];
        }
        return NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = NO;
      appDelegate.mids.hidden=NO;

}

//- (void)viewWillDisappear:(BOOL)animated{
//
//    self.tabBarController.tabBar.hidden = YES;
//    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.mid.hidden = YES;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
