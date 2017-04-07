//
//  AddNoteViewController.m
//  37SQ
//
//  Created by administrator on 2016/11/5.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "AddNoteViewController.h"
#import "FinalGiveservice.h"
#import "MyNav.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface AddNoteViewController ()<UITextViewDelegate>
@property(strong,nonatomic)UITextView *MainTV;
@property(strong,nonatomic)UILabel *go;//
@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.view.backgroundColor=[UIColor whiteColor];
     MyNav *nav = [[MyNav alloc]initWithTitle:@"写点评" bgImg:nil leftBtn:@"backfinal" rightBtn:@"savedl"];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction) forControlEvents:UIControlEventTouchUpInside];
     [  nav.rightBtn  addTarget:self action:@selector(addcomment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    self.MainTV=[[UITextView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, SCREEN_HEIGHT-64)];
    self.MainTV.delegate=self;
    self.MainTV.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_MainTV];
    [self.MainTV becomeFirstResponder];
    self.go=[[UILabel alloc]initWithFrame:CGRectMake(4, 70, SCREEN_WIDHN, 20)];
    self.go.textColor=[UIColor lightGrayColor];
    self.go.font=[UIFont systemFontOfSize:15];
    self.go.text=@"不友善言论将被删除,深度言论将优先展示";
    [self.view addSubview:_go];
    
}

- (void)leftaction {
    [self dismissViewControllerAnimated:YES completion:nil];

}
//改变LAB是否出现
-(void)textViewDidChange:(UITextView *)textView{
    
        if (_MainTV.text.length==0) {
            self.go.hidden=NO;
       }else{
            self.go.hidden=YES;
       }
 }
//发送评论
- (void)addcomment{
    //获取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
        if (_MainTV.text.length>2)  {
            //组织时间
            NSDate *date = [NSDate date];
            NSDateFormatter *datefo = [[NSDateFormatter alloc]init];
            [datefo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [datefo stringFromDate:date];
            
            //        NSLog(@"%@---------%@",self.CommentView.VVideoId,_VideoId);
            FinalGiveservice *go=[[FinalGiveservice alloc]init];
            ////测试.-------
            NSMutableDictionary *send=[[NSMutableDictionary alloc]initWithCapacity:0];
            [send setObject:_MainTV.text forKey:@"content"];
            [send setObject:@"1" forKey:@"type"];
            [send setObject:_noteid forKey:@"noteid"];
            //userid//时间
            
            [send setObject:dateStr forKey:@"time"];
            [send setObject:squserid forKey:@"userid"];
            //发送请求
            [go addMessage:@"http://115.159.195.113:8000/37App/index.php/hobby/index/addcomment"andDic:send andSafe:nil andSuccess:^(NSDictionary *dic) {
                //
                //        NSLog(@"%@",dic);
            }];
            [self dismissViewControllerAnimated:YES completion:nil];
            
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
//        [self hidetarget];
        
        
        
    }}

@end
