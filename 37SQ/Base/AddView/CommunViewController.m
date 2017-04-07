//
//  CommunViewController.m
//  37SQ
//
//  Created by administrator on 16/11/1.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "CommunViewController.h"

@interface CommunViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(assign,nonatomic)BOOL Backbool;//是是否在上传的BOOL
@property(strong,nonatomic)UIView *BackView;//遮挡的VIEW
@property(strong,nonatomic)MyNav *nav;
@end

@implementation CommunViewController
{
    UIImagePickerController *_imagePickerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.photoArr = [[NSMutableArray alloc]initWithCapacity:0];

    
    //创建UIImagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    
    self.nav = [[MyNav alloc]initWithTitle:@"上传帖子" bgImg:nil leftBtn:@"TZBack" rightBtn:@"savedl"];
    [self.nav.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.nav.rightBtn addTarget:self action:@selector(TZsign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
    //上传帖子的界面
    self.TZtitle = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    self.TZtitle.placeholder = @"请输入帖子标题(必选)";
    self.TZtitle.font = [UIFont systemFontOfSize:20.0];
    self.TZtitle.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.TZtitle.textAlignment = NSTextAlignmentCenter;
    self.TZtitle.borderStyle = UITextBorderStyleRoundedRect;
    self.TZtitle.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:_TZtitle];
    
    self.TZhtml = [[UITextView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT*0.5)];
    //        self.TZhtml.backgroundColor = [UIColor orangeColor];
    self.TZhtml.font = [UIFont systemFontOfSize:15.0];
    self.TZhtml.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:_TZhtml];
    
    self.btnView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.04, _TZhtml.frame.size.height+114, SCREEN_WIDTH*0.92, SCREEN_WIDTH*0.48)];
    //        self.btnView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_btnView];
    
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
    //        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.04, _TZhtml.frame.size.height+114, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(selectTZimage) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:_btn];
    

    // Do any additional setup after loading the view.
}

//为帖子选择图片
- (void)selectTZimage {
    [self.photoArr removeAllObjects];
    [self.btnView removeFromSuperview];
    
    self.btnView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.04, _TZhtml.frame.size.height+114, SCREEN_WIDTH*0.92, SCREEN_WIDTH*0.48)];
    //    self.btnView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_btnView];
    
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(selectTZimage) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:_btn];
    
    //    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
    //    delete.backgroundColor = [UIColor redColor];
    //    [self.btn addSubview:delete];
    
    //创建一个图片选择库实例并选择其显示界面
    SuPhotoPicker *picker = [[SuPhotoPicker alloc]init];
    
    //最大选择图片的数量以及最大快速预览图片的数量
    picker.selectedCount = 8;
    picker.preViewCount = 99;
    
    
    [picker showInSender:self handle:^(NSArray<UIImage *> *photos) {
        //完成选择后的操作
        
        [self.photoArr addObjectsFromArray:photos];
        
        switch (photos.count) {
                
            case 1:{
                [self.btn setImage:photos[0] forState:0];
                
            }
                break;
                
            case 2:{
                [self.btn setImage:photos[0] forState:0];
                
                UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                [imageBtn setImage:photos[1] forState:0];
                [self.btnView addSubview:imageBtn];
                
                //                UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                //                delete.backgroundColor = [UIColor redColor];
                //                [imageBtn addSubview:delete];
            }
                break;
                
            case 3:{
                [self.btn setImage:photos[0] forState:0];
                
                for (int i = 1; i < 3; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i] forState:0];
                    [self.btnView addSubview:imageBtn];
                    
                    //                    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                    //                    delete.backgroundColor = [UIColor redColor];
                    //                    [imageBtn addSubview:delete];
                }
            }
                break;
                
            case 4:{
                [self.btn setImage:photos[0] forState:0];
                
                for (int i = 1; i < 4; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i] forState:0];
                    [self.btnView addSubview:imageBtn];
                    
                    //                    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                    //                    delete.backgroundColor = [UIColor redColor];
                    //                    [imageBtn addSubview:delete];
                }
            }
                break;
                
            case 5:{
                [self.btn setImage:photos[0] forState:0];
                
                for (int i = 1; i < 4; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i] forState:0];
                    [self.btnView addSubview:imageBtn];
                    
                    //                    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                    //                    delete.backgroundColor = [UIColor redColor];
                    //                    [imageBtn addSubview:delete];
                }
                UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*0.24, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                [imageBtn setImage:photos[4] forState:0];
                [self.btnView addSubview:imageBtn];
                
                //                UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                //                delete.backgroundColor = [UIColor redColor];
                //                [imageBtn addSubview:delete];
                
            }
                break;
                
            case 6:{
                [self.btn setImage:photos[0] forState:0];
                for (int i = 1; i < 4; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i] forState:0];
                    [self.btnView addSubview:imageBtn];
                }
                for (int i = 0; i < 2; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, SCREEN_WIDTH*0.24, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i+4] forState:0];
                    [self.btnView addSubview:imageBtn];
                    
                    //                    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                    //                    delete.backgroundColor = [UIColor redColor];
                    //                    [imageBtn addSubview:delete];
                }
            }
                break;
                
            case 7:{
                [self.btn setImage:photos[0] forState:0];
                for (int i = 1; i < 4; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i] forState:0];
                    [self.btnView addSubview:imageBtn];
                    
                    //                    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                    //                    delete.backgroundColor = [UIColor redColor];
                    //                    [imageBtn addSubview:delete];
                }
                for (int i = 0; i < 3; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, SCREEN_WIDTH*0.24, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i+4] forState:0];
                    [self.btnView addSubview:imageBtn];
                    
                    //                    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                    //                    delete.backgroundColor = [UIColor redColor];
                    //                    [imageBtn addSubview:delete];
                }
            }
                break;
                
            case 8:{
                [self.btn setImage:photos[0] forState:0];
                for (int i = 1; i < 4; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i] forState:0];
                    [self.btnView addSubview:imageBtn];
                    
                    //                    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                    //                    delete.backgroundColor = [UIColor redColor];
                    //                    [imageBtn addSubview:delete];
                }
                for (int i = 0; i < 4; i++) {
                    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24*i, SCREEN_WIDTH*0.24, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
                    [imageBtn setImage:photos[i+4] forState:0];
                    [self.btnView addSubview:imageBtn];
                    
                    //                    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.16, 0, SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.04)];
                    //                    delete.backgroundColor = [UIColor redColor];
                    //                    [imageBtn addSubview:delete];
                }
            }
                break;
            default:
                break;
        }
    }];
}

//帖子上传
- (void)TZsign {
    
 
    
    if (self.TZtitle.text.length == 0 ) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入主题" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择该贴子的类型" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"创意分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.TZtype = @"1";
            [self goupdate];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"游戏杂谈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.TZtype = @"2";
              [self goupdate];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"情感故事" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.TZtype = @"3";
              [self goupdate];
        }];
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
         [alert addAction:action4];
        
        [self presentViewController:alert animated:YES completion:nil];
        
////        [self.view endEditing:YES];
    }
}
//上传函数
- (void) goupdate{
    self.Backbool=YES;
    self.nav.rightBtn.enabled=NO;
    if (!_BackView) {
        self.BackView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        self.BackView.backgroundColor=[UIColor lightGrayColor];
        self.BackView.alpha=0.8;
        [self.view addSubview:_BackView];
    }
    //组织时间
    NSDate *date = [NSDate date];
    NSDateFormatter *datefo = [[NSDateFormatter alloc]init];
    [datefo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [datefo stringFromDate:date];
    //        //网络请求
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
            NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithCapacity:0];
    
            //取全局USERID
            NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
            NSString *squserid = [SQUserid objectForKey:@"userid"];
            [mutDic setObject:self.TZtitle.text forKey:@"allnote_name"];
            [mutDic setObject:self.TZhtml.text forKey:@"allnote_content"];
            [mutDic setObject:_TZtype forKey:@"allnote_type"];
            [mutDic setObject:dateStr forKey:@"allnote_time"];
            [mutDic setObject:squserid forKey:@"user_id"];
            if (_photoArr.count == 0) {
    
    
            }else {
    
                [manager POST:@"http://115.159.195.113:8000/37App/index.php/community/index/uploadnote" parameters:mutDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
                    for (int i = 0; i < _photoArr.count; i++) {
          NSData *data = UIImagePNGRepresentation(_photoArr[i]);
                        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                        // 要解决此问题，
                        // 可以在上传时使用当前的系统事件作为文件名
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        // 设置时间格式
                        formatter.dateFormat = @"yyyyMMddHHmmss";
                        NSString *str = [formatter stringFromDate:[NSDate date]];
                        NSString *fileName = [NSString stringWithFormat:@"%@%d.png",str,i];
                          NSString *imagename = [NSString stringWithFormat:@"image%d",i];
                        [formData appendPartWithFileData:data name:imagename fileName:fileName mimeType:@"image/png"];
                    }
    
                }progress:^(NSProgress * _Nonnull uploadProgress) {
    
                    // NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    // 回到主队列刷新UI,用户自定义的进度条
    
                    dispatch_async(dispatch_get_main_queue(), ^{
    
                        [SVProgressHUD showProgress:1.0 *
                         uploadProgress.completedUnitCount / uploadProgress.totalUnitCount];
    
                        //                    self.progressView.progress = 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
                    });
    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    self.Backbool=NO;
                    [SVProgressHUD dismiss];
//                    self.nav.rightBtn.enabled=YES;
                    NSLog(@"上传成功 %@", responseObject);
    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        self.tabBarController.tabBar.hidden=NO;
                        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        appDelegate.mid.hidden = NO;
                          appDelegate.mids.hidden=YES;
                        [self dismissViewControllerAnimated:YES completion:nil];
    
                    }];
                    [alert addAction:action1];
    
                    [self presentViewController:alert animated:YES completion:nil];
    
    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    self.nav.rightBtn.enabled=YES;
                    [SVProgressHUD dismiss];
                    self.Backbool=NO;
                    NSLog(@"上传失败 %@", error);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传失败,请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                    [alert addAction:action1];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }];
            }



}


//图片和视频保存完毕后的回调
- (void)image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)back {
    if (_Backbool==YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"正在上传,确定离开么" preferredStyle:0];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"离开" style:2 handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

@end
