//
//  SCuploadViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/11.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "SCuploadViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
//#import "GiveService.h"
#import "AFNetworking.h"
@interface SCuploadViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//

//
{
    UIImagePickerController *_imagePickerController;
}
@property (strong, nonatomic)  UIProgressView *progressView;
@end

@implementation SCuploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   










//   //检测网络状态
//    //网络监控句柄
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//
//    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
//    [manager startMonitoring];
//
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        //status:
//        //AFNetworkReachabilityStatusUnknown          = -1,  未知
//        //AFNetworkReachabilityStatusNotReachable     = 0,   未连接
//        //AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
//        //AFNetworkReachabilityStatusReachableViaWiFi = 2,   无线连接
//        NSLog(@"%ldhahahhahh", (long)status);
//    }];

    
    
    
    self.view.backgroundColor=[UIColor grayColor];
    //进度条
    self.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 100, 320, 100)];
    [self.view addSubview:_progressView];
    //
    //创建UIImagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    ///
    

    UIButton *test2=[[UIButton alloc]initWithFrame:CGRectMake(200, 100, 100, 100)];
    test2.backgroundColor=[UIColor redColor];
    
    [test2 addTarget:self action:@selector(selectImageFromAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test2];
    
//
    
    UIButton *test3=[[UIButton alloc]initWithFrame:CGRectMake(200, 300, 100, 100)];
    test3.backgroundColor=[UIColor yellowColor];
    
    [test3 addTarget:self action:@selector(selectImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test3];
    

   
    
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
        UIImage *image=info[UIImagePickerControllerEditedImage];
//        self.imageView.image = info[UIImagePickerControllerEditedImage];
        
        UIImageView *go=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        go.backgroundColor=[UIColor blueColor];
        go.image=image;
        [self.view addSubview:go];
        
        //网络请求
   
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //组织字典,可按老方法
            NSDictionary *dict = @{@"userid":@"2"};
        
            //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/index/uploadimg" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//                UIImage *image =[UIImage imageNamed:@"comment1"];
                NSData *data = UIImagePNGRepresentation(image);
                
        
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
                //上传
                /*
                 此方法参数
                 1. 要上传的[二进制数据]
                 2. 对应网站上[upload.php中]处理文件的[字段"file"]
                 3. 要保存在服务器上的[文件名]
                 4. 上传文件的[mimeType]
                 */
                [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
                
        
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
                
                //
//                NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                // 回到主队列刷新UI,用户自定义的进度条
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressView.progress = 1.0 *
                    uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
                });
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"上传成功 %@", responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
//                NSLog(@"上传失败 %@", error);
            }];
            
        }
    //测试视频
    else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //播放视频
//        _moviePlayer.contentURL = url;
//        [_moviePlayer play];
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        NSData *data = [NSData dataWithContentsOfURL:url];
      
       //网络请求
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //组织字典,可按老方法
        NSDictionary *dict = @{@"userid":@"2"};
        
        //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/index/uploadimg" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            //                UIImage *image =[UIImage imageNamed:@"comment1"];
//            NSData *data = UIImagePNGRepresentation(image);
            
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
            
            //上传
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
            //
            //                NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            // 回到主队列刷新UI,用户自定义的进度条
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = 1.0 *
                uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            });
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //                NSLog(@"上传成功 %@", responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //                NSLog(@"上传失败 %@", error);
        }];

        
    }
    
    
  
    [self dismissViewControllerAnimated:YES completion:nil];
}
//图片和视频保存完毕后的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}
@end
