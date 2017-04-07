//
//  LikeViewController.m
//  37SQ
//
//  Created by administrator on 16/11/1.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "LikeViewController.h"
#import "GroupChooseViewController.h"

@interface LikeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(assign,nonatomic)BOOL VideoBool;
@property(strong,nonatomic)MyNav *nav;
@property(assign,nonatomic)BOOL Backbool;//是是否在上传的BOOL
@property(strong,nonatomic)UIView *BackView;//遮挡的VIEW
@end

@implementation LikeViewController{
    UIImagePickerController *_imagePickerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.SPimage = [[UIImage alloc]init];
    self.SPimage = nil;
    
    self.groupListArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    //创建UIImagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    
    self.nav = [[MyNav alloc]initWithTitle:@"上传至群组" bgImg:nil leftBtn:@"TZBack" rightBtn:@"savedl"];
    [ self.nav.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [ self.nav.rightBtn addTarget:self action:@selector(SPsign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
    
    self.SPtitle = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    //        self.TZtitle.backgroundColor = [UIColor orangeColor];
    self.SPtitle.placeholder = @"视频主题";
    self.SPtitle.font = [UIFont systemFontOfSize:20.0];
    self.SPtitle.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.SPtitle.textAlignment = NSTextAlignmentCenter;
    self.SPtitle.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_SPtitle];
    
    self.SPhtml = [[UITextView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_WIDTH*0.4+SCREEN_WIDTH*(0.8/3+0.05)*2)];
    //        self.SPhtml.backgroundColor = [UIColor orangeColor];
    self.SPhtml.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:_SPhtml];
    
    
    //上传视频的页面
    UIButton *SPbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.05, 120+SCREEN_WIDTH*0.4+SCREEN_WIDTH*(0.8/3+0.05)*2, SCREEN_WIDTH*0.4, SCREEN_WIDTH*0.3)];
    [SPbtn addTarget:self action:@selector(selectSPvideo) forControlEvents:UIControlEventTouchUpInside];
    [SPbtn setBackgroundImage:[UIImage imageNamed:@"SPmovie"] forState:UIControlStateNormal];
    
    [self.view addSubview:SPbtn];
    
    self.SPLab1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.05, 120+SCREEN_WIDTH*0.4+SCREEN_WIDTH*(0.8/3+0.05)*2+SCREEN_WIDTH*0.3, SCREEN_WIDTH*0.4, SCREEN_WIDTH*0.05)];
    self.SPLab1.text = @"选择视频";
    self.SPLab1.font = [UIFont systemFontOfSize:13.0];
    self.SPLab1.textColor = [UIColor grayColor];
    self.SPLab1.textAlignment = NSTextAlignmentCenter;
    //        SPLab1.backgroundColor = [UIColor redColor];
    [self.view addSubview:_SPLab1];
    //轮选
    
    
    UIButton *SPimg = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55, 120+SCREEN_WIDTH*0.4+SCREEN_WIDTH*(0.8/3+0.05)*2, SCREEN_WIDTH*0.4, SCREEN_WIDTH*0.3)];
    [SPimg addTarget:self action:@selector(selectSPimage) forControlEvents:(UIControlEventTouchUpInside)];
    [SPimg setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    
    [self.view addSubview:SPimg];
    
    UILabel *SPLab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55, 120+SCREEN_WIDTH*0.4+SCREEN_WIDTH*(0.8/3+0.05)*2+SCREEN_WIDTH*0.3, SCREEN_WIDTH*0.4, SCREEN_WIDTH*0.05)];
    SPLab2.text = @"选择视频封面";
    SPLab2.font = [UIFont systemFontOfSize:13.0];
    SPLab2.textColor = [UIColor grayColor];
    SPLab2.textAlignment = NSTextAlignmentCenter;
    //        SPLab2.backgroundColor = [UIColor redColor];
    [self.view addSubview:SPLab2];

    // Do any additional setup after loading the view.
}

- (void)selectSPimage{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择视频封面" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.VideoBool=NO;
        [self selectImageFromAlbum];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"即拍选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.VideoBool=NO;
        [self selectImageFromCamera];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)selectSPvideo {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择视频" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.VideoBool=YES;
        [self selectImageFromAlbum];
        
    }];
   
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"即拍即传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         self.VideoBool =YES;
        [self selectImageFromCamera];
        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}



- (void)SPsign {
    
    if (_SPtitle.text.length==0 ) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"主题不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (_data == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择上传的视频" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if(_SPimage == nil){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择上传的视频封面" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
     
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"选择群组" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                GroupChooseViewController *vc = [[GroupChooseViewController alloc]init];
                vc.delegate=self;
                [self presentViewController:vc animated:YES completion:nil];
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //视频上传
                if (_groupSign.count>=1) {
                    if (!_BackView) {
                        self.BackView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
                        self.BackView.backgroundColor=[UIColor lightGrayColor];
                        self.BackView.alpha=0.8;
                        [self.view addSubview:_BackView];
                    }
                    //上传按钮关闭
                    self.Backbool=YES;
                    self.nav.rightBtn.enabled=NO;
                    NSDate *date = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *strDate = [dateFormatter stringFromDate:date];
                    
                    //网络请求
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    
                    //组织字典
                    NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithCapacity:0];
                    //取全局USERID
                    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
                    NSString *squserid = [SQUserid objectForKey:@"userid"];
                    [mutDic setObject:self.SPtitle.text forKey:@"video_name"];
                    [mutDic setObject:self.SPhtml.text forKey:@"video_sign"];
                    //                    [mutDic setObject:@"3" forKey:@"video_type"];
                    [mutDic setObject:strDate forKey:@"video_time"];
                    [mutDic setObject:squserid forKey:@"video_user"];
                    [mutDic setObject:_groupSign forKey:@"group"];
                    
                    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
                    [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/index/uploadpv" parameters:mutDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        
                        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                        // 要解决此问题，
                        // 可以在上传时使用当前的系统事件作为文件名
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        // 设置时间格式
                        formatter.dateFormat = @"yyyyMMddHHmmss";
                        NSString *str = [formatter stringFromDate:[NSDate date]];
                        
                        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
                        
                        NSString *fileName1 = [NSString stringWithFormat:@"%@1.png", str];
                        //上传
                        /*
                         此方法参数
                         1. 要上传的[二进制数据]
                         2. 对应网站上[upload.php中]处理文件的[字段"file"]
                         3. 要保存在服务器上的[文件名]
                         4. 上传文件的[mimeType]
                         */
                        [formData appendPartWithFileData:_data name:@"video" fileName:fileName mimeType:@"video/mp4"];
                        
                        NSData *imgdata = UIImagePNGRepresentation(self.SPimage);
                        [formData appendPartWithFileData:imgdata name:@"image" fileName:fileName1 mimeType:@"image/png"];
                        
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                        
                        // NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                        // 回到主队列刷新UI,用户自定义的进度条
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            //                self.progressView.progress = 1.0 *
                            //                uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
                            [SVProgressHUD showProgress:1.0 *
                             uploadProgress.completedUnitCount / uploadProgress.totalUnitCount];
                        
                            
                        });
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        [SVProgressHUD dismiss];
                        self.Backbool=NO;
                        NSLog(@"上传成功 %@", responseObject);
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                            appDelegate.mid.hidden = NO;
                            [self dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
                        [alert addAction:action1];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        [SVProgressHUD dismiss];
                        self.Backbool=NO;
                        NSLog(@"上传失败 %@", error);
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传失败,请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            //上传按钮开启
                            self.nav.rightBtn.enabled=YES;
                        }];
                        [alert addAction:action1];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }];
                }else{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择群组" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:action1];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                }
                
                
            }];
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:action1];
        if (_groupSign.count>0) {
            [alert addAction:action2];}
            [alert addAction:action3];
            
            [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        ////        如果是图片
        self.SPimage = info[UIImagePickerControllerEditedImage];
        
        UIImageView *SPimgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55, 120+SCREEN_WIDTH*0.4+SCREEN_WIDTH*(0.8/3+0.05)*2, SCREEN_WIDTH*0.4, SCREEN_WIDTH*0.3)];
        SPimgView.image = _SPimage;
        [self.view addSubview:SPimgView];
        
    }else {
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        
        //播放视频
        //        _moviePlayer.contentURL = url;.        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        //        UIImageView *SPimgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDHN*0.05, 120+SCREEN_WIDHN*0.4+SCREEN_WIDHN*(0.8/3+0.05)*2, SCREEN_WIDHN*0.4, SCREEN_WIDHN*0.2)];
        //        SPimgView.image = [UIImage imageNamed:@""];
        //        [self.view addSubview:SPimgView];
        
        
        self.SPLab1.text = @"视频已选择";
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        self.data = [NSData dataWithContentsOfURL:url];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    _imagePickerController.videoMaximumDuration = 0;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
//    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    if (_VideoBool==YES) {
        //只能拍视频
        NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects: requiredMediaType1, nil];
        
        [_imagePickerController setMediaTypes:arrMediaTypes];
    }else{
        //只能拍照片
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects: requiredMediaType, nil];
        
        [_imagePickerController setMediaTypes:arrMediaTypes];
        
        
    }
     //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
//    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    
    [_imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];// 设置类型
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    if (_VideoBool==YES) {
        [mediaTypes addObject:( NSString *)kUTTypeMovie];
    }else{
        [mediaTypes addObject:( NSString *)kUTTypeImage];
    }
    [_imagePickerController setMediaTypes:mediaTypes];
    //    [controller setDelegate:self];// 设置代理
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    //NSLog(@"相册");
//    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    [self presentViewController:_imagePickerController animated:YES completion:nil];
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

//代理
- (void)givemeSelectGroup:(NSArray *)group{
    _groupSign = group;
    NSLog(@"%@",_groupSign);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

@end
