//
//  VideoDiaryViewController.h
//  37SQ
//
//  Created by administrator on 16/10/29.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"

@interface VideoDiaryViewController : UIViewController

{
    
    UIImagePickerController *_imagePickerController;
    
}

@property(strong,nonatomic)NSURL *MyURL;

- (void)camera;
- (PHFetchResult<PHAsset *> *)createdAssets;
- (PHAssetCollection *)createdCollection;
- (void)save;

@end
