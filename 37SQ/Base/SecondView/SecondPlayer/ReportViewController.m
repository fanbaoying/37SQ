//
//  ReportViewController.m
//  37SQ
//
//  Created by administrator on 2016/11/4.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "ReportViewController.h"
#import "MyNav.h"
#import "AFNetworking.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ReportViewController ()
@property(strong,nonatomic)UIScrollView *mainscl;
@property(strong,nonatomic)UITextView *what;
@property(copy,nonatomic)NSString *content;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.view.backgroundColor=[UIColor whiteColor];
    MyNav *nav = [[MyNav alloc]initWithTitle:@"举报" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    self.mainscl=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, SCREEN_HEIGHT-64)];
    self.mainscl.contentSize=CGSizeMake(SCREEN_WIDHN, SCREEN_HEIGHT);
    [self.view addSubview:_mainscl];
    NSArray *titArr=@[@[@"广告",@"色情"],@[@"重复内容",@"暗示"],@[@"破坏和谐",@"恶意攻击"]];
    for (int i=0; i<3; i++) {
        for (int j=0; j<2; j++) {
            UIButton *whatBtn=[[UIButton alloc]initWithFrame:CGRectMake(20 +j*SCREEN_WIDHN/2.0, 50+i*50, SCREEN_WIDHN/3.0, 30)];
//            whatBtn.layer.
//            whatBtn.backgroundColor=[UIColor redColor];
            [whatBtn addTarget:self action:@selector(whatyousay:) forControlEvents:UIControlEventTouchUpInside];
            [whatBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];
            whatBtn.layer.borderColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
            whatBtn.layer.borderWidth=1;
            whatBtn.layer.cornerRadius=5;
            whatBtn.clipsToBounds=YES;
            whatBtn.titleLabel.text=titArr[i][j];
            whatBtn.titleLabel.font=[UIFont systemFontOfSize:12];
            [whatBtn setTitle:titArr[i][j] forState:0] ;
            [self.mainscl addSubview:whatBtn];
   } }
    
    self.what=[[UITextView alloc]initWithFrame:CGRectMake(20, 200, SCREEN_WIDHN-40, 100)];
    self.what.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.mainscl addSubview:_what];
    
    UIButton *sub=[[UIButton alloc]initWithFrame:CGRectMake(10, _what.frame.origin.y+20+100, SCREEN_WIDHN-20, 44)];
    sub.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    sub.layer.cornerRadius=5;
    sub.clipsToBounds=YES;
    [sub setTitle:@"提交" forState:0];
    [sub addTarget:self action:@selector(gogogo) forControlEvents:UIControlEventTouchUpInside];
    [self.mainscl addSubview:sub];
    
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
- (void)leftaction {

    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)whatyousay:(UIButton *)sender{
//    UIButton *ha=[self.view viewWithTag:sender.tag];
    self.content=[NSString stringWithFormat:@"%@,%@",_content,sender.titleLabel.text];
    [sender setTitleColor:[UIColor whiteColor] forState:0];
    sender.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    sender.enabled=NO;
    NSLog(@"---");

}
//上传
- (void)gogogo{
    self.content=[NSString stringWithFormat:@"%@,%@",_content,_what.text];
     NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        NSString *squserid = [SQUserid objectForKey:@"userid"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
   NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:squserid forKey:@"userid"];
    [dic setObject:_Whatid forKey:@"whatid"];
    [dic setObject:_Whattype forKey:@"whattype"];
    [dic setObject:_content forKey:@"content"];

    [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/test/report" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"举报成功,感谢您为37摄区做出的贡献!" preferredStyle:UIAlertControllerStyleAlert];
        //
        [self  presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误(没有返回值)---%@",error);
    }];


}
//提示框消失
- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
     [self dismissViewControllerAnimated:YES completion:nil];
    alert = nil;}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
