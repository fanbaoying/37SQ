//
//  upViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/12.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "upViewController.h"

@interface upViewController ()

@end

@implementation upViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //    AFHTTPSessionManager * hahad=[AFHTTPRequestOperationManager manager];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    
//    NSDictionary *dict = @{@"username":@"Saup"};
//    
//    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
//    [manager POST:@"http://115.159.195.113:8000/37App/index.php/hobby/index/upload" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        UIImage *image =[UIImage imageNamed:@"comment1"];
//        NSData *data = UIImagePNGRepresentation(image);
//
//        
//        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//        // 要解决此问题，
//        // 可以在上传时使用当前的系统事件作为文件名
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        // 设置时间格式
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
//        //上传
//        /*
//         此方法参数
//         1. 要上传的[二进制数据]
//         2. 对应网站上[upload.php中]处理文件的[字段"file"]
//         3. 要保存在服务器上的[文件名]
//         4. 上传文件的[mimeType]
//         */
//        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        //上传进度
//        //         @property int64_t totalUnitCount;     需要下载文件的总大小
//        //         @property int64_t completedUnitCount; 当前已经下载的大小
//        
//        //         给Progress添加监听 KVO
//        //        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//        //         回到主队列刷新UI,用户自定义的进度条
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //            self.progressView.progress = 1.0 *
//            //            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//        });
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"上传成功 %@", responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"上传失败 %@", error);
//    }];
//    
//}

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
