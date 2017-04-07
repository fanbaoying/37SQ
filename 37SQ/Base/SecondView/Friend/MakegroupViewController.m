//
//  MakegroupViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/25.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "MakegroupViewController.h"
#import "MyNav.h"
#import "AFNetworking.h"


#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface MakegroupViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
}
@property(strong,nonatomic)UIButton *groupimg;//头像按钮
@property(strong,nonatomic)UITextField *groupname;//群名称输入
@property(strong,nonatomic)UITextView *groupsign;//群组简介
@property(strong,nonatomic)UILabel *placesign;//TEXTVIEW的PLacehod  LAB
@property(strong,nonatomic)MyNav *nav;//导航栏
@property(strong,nonatomic)UIImage *headimg;//选中的头像

@end

@implementation MakegroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建UIImagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    ///
    
    //导航栏
    self.view.backgroundColor=[UIColor whiteColor];
    self.nav = [[MyNav alloc]initWithTitle:@"创建群组" bgImg:nil leftBtn:@"backfinal" rightBtn:@"savedl"];
    [  _nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
    [  _nav.rightBtn  addTarget:self action:@selector(rightaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    //头像
    self.groupimg=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2-SCREEN_WIDHN/8, 100, SCREEN_WIDHN/4, SCREEN_WIDHN/4)];
    self.groupimg.layer.borderWidth=1;
    self.groupimg.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.groupimg.layer.cornerRadius=SCREEN_WIDHN/8;
    self.groupimg.clipsToBounds=YES;
    self.groupimg.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.groupimg setTitle:@"请选择群头像" forState:0];
    [self.groupimg setTitleColor:[UIColor lightGrayColor] forState:0];
    [self.groupimg addTarget:self action:@selector(selectImageFromAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_groupimg];
    //头像下面的线
    UILabel *headline= [[UILabel alloc]initWithFrame:CGRectMake(10, 110+SCREEN_WIDHN/4, SCREEN_WIDHN-20, 1)];
    headline.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview: headline];
    //群组名称
    self.groupname=[[UITextField alloc]initWithFrame:CGRectMake(10, 115+SCREEN_WIDHN/4, SCREEN_WIDHN-20, 30)];
//    self.groupname.backgroundColor=[UIColor yellowColor];
    self.groupname.placeholder=@"请输入群名称";

    self.groupname.font=[UIFont systemFontOfSize:12];
    //输入前的空格
    UIView *textview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 5)];
    self.groupname.leftView=textview;
    self.groupname.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_groupname];
    
    UILabel *nameline=[[UILabel alloc]initWithFrame:CGRectMake(10, _groupname.frame.origin.y +35, SCREEN_WIDHN-20, 1)];
    nameline.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:nameline];
   //群组简介
    self.groupsign=[[UITextView alloc]initWithFrame:CGRectMake(10, _groupname.frame.origin.y +40, SCREEN_WIDHN-20, 60)];
    self.groupsign.delegate=self;
    self.groupsign.font=[UIFont systemFontOfSize:12];
//    self.groupsign.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:_groupsign];
   self.placesign=[[UILabel alloc]initWithFrame:CGRectMake(13, _groupname.frame.origin.y +45, SCREEN_WIDHN-20, 20)];
    self.placesign.text=@"来为你的群添加几句介绍吧";
    self.placesign.font=[UIFont systemFontOfSize:12];
    self.placesign.textColor=[UIColor lightGrayColor];
    [self.view addSubview:_placesign];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}
//返回
-(void)leftaction:(UIButton * )sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//隐藏TEXTVIEW的介绍
-(void)textViewDidChange:(UITextView *)textView{
    if (_groupsign.text.length==0) {
        self.placesign.hidden=NO;
    }else{
     self.placesign.hidden=YES;
    }
    


}

//确定键
-(void)rightaction:(UIButton * )sender{
    
    
    if (_headimg) {
        
    
    if(_groupname.text.length!=0){
    
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
             NSString *squserid = [SQUserid objectForKey:@"userid"];
        
        
        UIAlertController *alertqq = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认创建么" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        //网络请求
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:_groupname.text forKey:@"name"];
        [dic setObject:_groupsign.text forKey:@"sign"];
        [dic setObject:squserid forKey:@"userid"];
        [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/friend/makegroup" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData *data = UIImagePNGRepresentation(_headimg);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
          
            //                NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            // 回到主队列刷新UI,用户自定义的进度条
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                self.progressView.progress = 1.0 *
                //                uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            });
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //                NSLog(@"上传成功 %@", responseObject);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"创建成功!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"朕知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:action1];
            
            [self  presentViewController:alert animated:YES completion:nil];
           
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //                NSLog(@"上传失败 %@", error);
        }];
            //
               }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"等等" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertqq addAction:action2];
        [alertqq addAction:action1];
        [self  presentViewController:alertqq animated:YES completion:nil];
     }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有名字怎么行!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"起名真难" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        
        [self  presentViewController:alert animated:YES completion:nil];
        
        
    
    
    
    }
    self.nav.rightBtn.enabled=NO;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择头像" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好好好,这就去." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
    
        [self  presentViewController:alert animated:YES completion:nil];

    
    
    }
}
#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}


//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        ////        如果是图片
        self.headimg=info[UIImagePickerControllerEditedImage];
        [self.groupimg setImage:_headimg forState:0];
        
        
    }else{UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好好好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action1];
        [self  presentViewController:alert animated:YES completion:nil];
    
    }

    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//图片保存完毕后的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}


@end
