//
//  ForgetPasswordViewController.m
//  FBY--first
//
//  Created by administrator on 16/9/27.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "FBYMyNav.h"
#import "AFNetworking.h"
#import <SMS_SDK/SMSSDK.h>

#import "NewPasswordViewController.h"
#import "FBY-HomeService.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ForgetPasswordViewController ()

@property(strong,nonatomic)FBYMyNav *nav;

@property(strong,nonatomic)UIImageView *MyImg;

@property(strong,nonatomic)UILabel *numLabel;

@property(strong,nonatomic)UILabel *obtainLabel;

@property(strong,nonatomic)UITextField *numText;

@property(strong,nonatomic)UITextField *obtainText;

@property(strong,nonatomic)UIButton *obtainBtn;

@property(strong,nonatomic)UIButton *loginBtn;

@property(strong,nonatomic)UIView *myView;

@property(strong,nonatomic)NSString *registerStr;

//@property(strong,nonatomic)NSTimer *myTime;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-113)];
    self.myView.backgroundColor = [UIColor clearColor];
    
    self.nav = [[FBYMyNav alloc]initWithTitle:@"重置密码" andWithByImg:@"NAV" andWithLetBtn1:nil andWithLeftBtn2:@"返回" andWithRightBtn1:nil andWithRightBtn2:nil];
    
    [self.nav.leftBtn2 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nav];
    
    self.MyImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_WIDTH*1/2)];
    self.MyImg.image = [UIImage imageNamed:@"bg.jpg"];
    [self.view addSubview:_MyImg];
    
    self.numText = [[UITextField alloc]initWithFrame:CGRectMake(30,SCREEN_HEIGHT/2-60, SCREEN_WIDTH-150, 40)];
    self.numText.placeholder = @"请输入手机号";
    [self.numText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.numText.keyboardType = 4;
    self.numText.font = [UIFont systemFontOfSize:12.0];
    
    //线
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-24, SCREEN_WIDTH-60, 0.5)];
    self.numLabel.backgroundColor = [UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1];
    
    //获取验证码按钮
    //按钮样式设置
    self.obtainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.obtainBtn.frame = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/4-40, SCREEN_HEIGHT/2-55, SCREEN_WIDTH/4+10, 30);
    
    [self.obtainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.obtainBtn setTitleColor:[UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [self.obtainBtn.layer setBorderWidth:0.5];
    self.obtainBtn.layer.borderColor = [UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1].CGColor;
    [self.obtainBtn.layer setCornerRadius:5.0];
    self.obtainBtn.titleLabel.font  = [UIFont systemFontOfSize:12.0];
    //点击事件
    [self.obtainBtn addTarget:self action:@selector(obtainBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.obtainText = [[UITextField alloc]initWithFrame:CGRectMake(30,SCREEN_HEIGHT/2-20, SCREEN_WIDTH-60, 40)];
    self.obtainText.placeholder = @"请输入验证码";
    self.obtainText.keyboardType = 4;
    self.obtainText.font = [UIFont systemFontOfSize:12.0];
    
    //线
    self.obtainLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2+16, SCREEN_WIDTH-60, 0.5)];
    self.obtainLabel.backgroundColor = [UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1];
    
    //注册按钮
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2+36, SCREEN_WIDTH-60, 30)];
    [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [self.loginBtn.layer setBorderWidth:0.5];
    self.loginBtn.layer.borderColor = [UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1].CGColor;
    [self.loginBtn.layer setCornerRadius:5.0];
    self.loginBtn.titleLabel.font  = [UIFont systemFontOfSize:12.0];
    //点击事件
    [self.loginBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    //键盘的显示和退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self.view addSubview:_myView];
    [self.myView addSubview:_obtainBtn];
    [self.myView addSubview:_loginBtn];
    
    [self.myView addSubview:_numLabel];
    [self.myView addSubview:_numText];
    [self.myView addSubview:_obtainText];
    [self.myView addSubview:_obtainLabel];
    
}

//限制手机号输入
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.numText) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
            
            [self.obtainBtn setTitleColor:[UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
            
            //点击事件
            self.obtainBtn.enabled = YES;
        }else{
            
            [self.obtainBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            self.obtainBtn.enabled = NO;
        }
    }
}

//pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.myView.transform = CGAffineTransformMakeTranslation(0, - ty + 170);
    }];
    
}
//pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.myView.transform = CGAffineTransformIdentity;
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

//返回登录
- (void)back:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//获取验证码
- (void)obtainBtn:(UIButton *)sender{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.obtainBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.obtainBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.obtainBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                //To do
                [UIView commitAnimations];
                self.obtainBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    
    //网络请求
    FBY_HomeService *service = [[FBY_HomeService alloc]init];
    [service searchMessage:_numText.text andWithAction:@"phonenum" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/index/yanzheng" andSuccess:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        self.registerStr = [dic objectForKey:@"code"];
        
        NSLog(@"%@",self.registerStr);
        
        long int intString = [_registerStr integerValue];
        
        if (intString == 500) {
            
            
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_numText.text
                                           zone:@"86"
                               customIdentifier:nil
                                         result:^(NSError *error){
                                             if (!error) {
                                                 NSLog(@"获取验证码成功");
                                             } else {
                                                 NSLog(@"错误信息：%@",error);
                                             }}];
            
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号未注册" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我要注册!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.obtainBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    self.obtainBtn.userInteractionEnabled = YES;
                });
                
            }];
            
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        
    } andFailure:^(int fail) {
        
    }];
    
}

//登录成功
- (void)next:(UIButton *)sender{

//    NewPasswordViewController *nvc = [[NewPasswordViewController alloc]init];
//    
//    nvc.str = _numText.text;
//    
//    [self.navigationController pushViewController:nvc animated:YES];
    
    
    [SMSSDK commitVerificationCode:self.obtainText.text phoneNumber:_numText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
        if (!error) {
            NSLog(@"验证成功");
            
            NewPasswordViewController *nvc = [[NewPasswordViewController alloc]init];
            nvc.str = _numText.text;
            
            [self.navigationController pushViewController:nvc animated:YES];
        }
        else
        {
            NSLog(@"错误信息:%@",error);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
