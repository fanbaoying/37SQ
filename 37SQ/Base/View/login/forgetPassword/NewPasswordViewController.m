//
//  NewPasswordViewController.m
//  37SQ
//
//  Created by administrator on 16/10/13.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "FBYMyNav.h"
#import "AFNetworking.h"
#import "FinalGiveservice.h"

#import <RongIMKit/RongIMKit.h>

#define RONGAPPKEY @"4z3hlwrv348ct"

#define uurl @"http://115.159.195.113:8000/37App/index.php/home/index/expassword"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface NewPasswordViewController ()

@property(strong,nonatomic)FBYMyNav *nav;

@property(strong,nonatomic)UIImageView *MyImg;

@property(strong,nonatomic)UITextField *pwText;

@property(strong,nonatomic)UILabel *pwLabel;

@property(strong,nonatomic)UITextField *againPWText;

@property(strong,nonatomic)UILabel *againPWLabel;

@property(strong,nonatomic)UIButton *loginBtn;

@property(strong,nonatomic)UIView *myView;

@property(strong,nonatomic)NSArray *dataArr;

@property(strong,nonatomic)NSString *registerStr;

@end

@implementation NewPasswordViewController

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
    
    self.pwText = [[UITextField alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-60, SCREEN_WIDTH-60, 40)];
    self.pwText.placeholder = @"请输入您的新密码(6~20位数字,字母,符号组成)";
    [self.pwText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.pwText.secureTextEntry = YES;
    self.pwText.keyboardType = 1;
    self.pwText.font = [UIFont systemFontOfSize:12.0];
    
    //线
    self.pwLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-24, SCREEN_WIDTH-60, 0.5)];
    self.pwLabel.backgroundColor = [UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1];
    
    self.againPWText = [[UITextField alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-20, SCREEN_WIDTH-60, 40)];
    self.againPWText.placeholder = @"请再次输入";
    [self.againPWText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.againPWText.secureTextEntry = YES;
    self.againPWText.keyboardType = 1;
    self.againPWText.font = [UIFont systemFontOfSize:12.0];
    
    //线
    self.againPWLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2+16, SCREEN_WIDTH-60, 0.5)];
    self.againPWLabel.backgroundColor = [UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1];
    
    
    //注册按钮
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2+36, SCREEN_WIDTH-60, 30)];
    [self.loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor lightGrayColor];
    [self.loginBtn.layer setCornerRadius:5.0];
    self.loginBtn.titleLabel.font  = [UIFont systemFontOfSize:12.0];
 
    //键盘的显示和退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    [self.view addSubview:_myView];
    [self.myView addSubview:_loginBtn];
    
    [self.myView addSubview:_pwLabel];
    [self.myView addSubview:_pwText];
    [self.myView addSubview:_againPWText];
    [self.myView addSubview:_againPWLabel];

    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.pwText) {
        if (textField.text.length > 5 & textField.text.length < 21) {
            
            self.loginBtn.backgroundColor = [UIColor lightGrayColor];
            
            //点击事件
//            [self.loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if (textField.text.length > 20){
                
                textField.text = [textField.text substringToIndex:20];
            }else{
                
                self.loginBtn.backgroundColor = [UIColor lightGrayColor];
                
            }
        }
    }
    
    if (textField == self.againPWText) {
        if (textField.text.length > 5 & textField.text.length < 21) {
            
            self.loginBtn.backgroundColor = [UIColor colorWithRed:36/255.0 green:203/255.0 blue:1 alpha:1];
            
            //点击事件
            [self.loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if (textField.text.length > 20){
                
                textField.text = [textField.text substringToIndex:20];
            }else{
                
                self.loginBtn.backgroundColor = [UIColor lightGrayColor];
                
            }
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

//登录成功
- (void)loginBtn:(UIButton *)sender{

    NSString *urlstr=uurl;
    
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutdic setObject:_str forKey:@"userphonenum"];
    
    if ([self.pwText.text isEqualToString: self.againPWText.text]) {
        [mutdic setObject:_pwText.text forKey:@"userpassword"];
    }
    else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入的密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"请重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        self.againPWText.text = nil;
        
    }
    //    [mutdic setObject:uurl forKey:@"key"];
    //    NSLog(@"%@",mutd/ic);
    //1.创建ADHTTPSESSIONMANGER对象
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager POST:urlstr parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *di=responseObject;
        NSLog(@"%@",di);
        
        self.registerStr = [di objectForKey:@"code"];
        
        NSLog(@"%@",self.registerStr);
        
        long int intString = [_registerStr integerValue];
        
        if (intString == 500) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改密码与原密码相同" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"请重输密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
        
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        [SQUserid setObject:[di objectForKey:@"userid"] forKey:@"userid"];
        [SQUserid synchronize];
            ///-----------
            //写入TOKEN
            NSString *squserid = [SQUserid objectForKey:@"userid"];
            FinalGiveservice *dlservice=[[FinalGiveservice alloc]init];
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
            NSMutableArray *tokenArr=[[NSMutableArray alloc]initWithCapacity:0];
            [dic setObject:squserid forKey:@"userid"];
            [dic setObject:@"name" forKey:@"username"];
            [dic setObject:@"userimg" forKey:@"userimg"];
            [dlservice addMessage:@"http://115.159.195.113:8000/API/logintoken.php" andDic:dic andSafe:nil andSuccess:^(NSDictionary *dic) {
                NSDictionary *recieve = dic;
                
                [tokenArr addObject:recieve];
                NSLog(@"%@",recieve);
                [SQUserid setObject:[tokenArr[0] objectForKey:@"token"] forKey:@"usertoken"];
                
                //登录融云
                NSString *usertoken=[SQUserid objectForKey:@"usertoken"];
                [[RCIM sharedRCIM] initWithAppKey:RONGAPPKEY];
                [[RCIM sharedRCIM] connectWithToken:usertoken success:^(NSString *userId) {
                    
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"登陆的错误码为:%ld", (long)status);
                } tokenIncorrect:^{
                    
                    NSLog(@"token错误");
                }];
            }];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
            
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误");
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
