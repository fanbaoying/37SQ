//
//  VideoDiaryViewController.m
//  37SQ
//
//  Created by administrator on 16/10/29.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "VideoDiaryViewController.h"

@interface VideoDiaryViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(assign,nonatomic)BOOL choose;

@end

@implementation VideoDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建UIImagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    self.choose = NO;
    
    [self camera];
}

- (void)viewWillAppear:(BOOL)animated{

    if (_choose == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)camera{
    
    NSLog(@"+++++++");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        FourthViewController *fvc = [[FourthViewController alloc]init];
        
        
        self.tabBarController.tabBar.hidden = YES;
        
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = YES;
          appDelegate.mids.hidden=YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = @[(NSString *)kUTTypeMovie];
            
            // Present the picker
            [self presentViewController:picker animated:YES completion:nil];
            _choose = YES;
        });
        
//        [self presentViewController:fvc animated:YES completion:nil];
//
    }else{
        //                NSLog(@"该设备没有摄像头");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有开启摄像头" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    _choose = NO;
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        
    }
    else{
        
        self.MyURL = info[UIImagePickerControllerMediaURL];
        
        
//        NSString *path = (NSString *)[info[UIImagePickerControllerMediaURL] path];
//        
//        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//       
//        [self dismissViewControllerAnimated:YES completion:nil];
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_MyURL];
//        //
//        //        [_allArr arrayByAddingObject:data];
//        //访问偏好设置文件夹
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        //存储数据
//        [defaults setObject:data forKey:@"all"];
//        //立刻同步
//        [defaults synchronize];
        
    }
    
    [self createdAssets];
    [self createdCollection];
    [self save];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
//    NSData *data = [NSData dataWithContentsOfURL:_MyURL];
//    
//    
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
//            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//            NSLog(@"是否保存成功：%d",success);
//            [self createdAssets];
//            [self createdCollection];
//            [self save];
//            
//        }];
//    }
    
    NSLog(@"视频保存成功");
//    [self createdAssets];
//    [self createdCollection];
//    [self save];
    
}

/**
 *  获得刚才添加到【相机胶卷】中的图片
 */
- (PHFetchResult<PHAsset *> *)createdAssets
{
    __block NSString *createdAssetId = nil;
    
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{

//        //读取
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSData *arr = [defaults objectForKey:@"all"];
//        
//        NSURL *url = [NSKeyedUnarchiver unarchiveObjectWithData:arr];
        
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:_MyURL].placeholderForCreatedAsset.localIdentifier;
        
    } error:nil];
    
    if (createdAssetId == nil) return nil;
    
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}

/**
 *  获得【自定义相册】
 */
- (PHAssetCollection *)createdCollection
{
    // 获取软件的名字作为相册的标题
    //    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    NSString *title = @"视频日记";
    
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    // 代码执行到这里，说明还没有自定义相册
    
    __block NSString *createdCollectionId = nil;
    
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    if (createdCollectionId == nil) return nil;
    
    // 创建完毕后再取出相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}



/**
 *  保存图片到相册
 */
- (void)save
{
    
    NSLog(@":::::::::");
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    
    // 获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    
    if (createdAssets == nil || createdCollection == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    // 将相片添加到相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 保存结果
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"------");
            _choose = NO;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
