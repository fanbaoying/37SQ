//
//  HeaderViewController.h
//  37SQ
//
//  Created by administrator on 16/11/1.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyNav.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "AddService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SuPhotoPicker.h"
#import "SVProgressHUD.h"
#import "GroupLIst_Service.h"
#import "GroupChooseViewController.h"
//视频日记
#import "VideoDiaryViewController.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HeaderViewController : UIViewController
//视频上传界面属性
@property (strong, nonatomic)UITextField *SPtitle;
@property (strong, nonatomic)UITextView *SPhtml;

@property (strong, nonatomic)NSData *data;
@property (strong, nonatomic)UIImage *SPimage;
@property (strong, nonatomic)UILabel *SPLab1;
@property (strong, nonatomic)NSMutableArray *groupListArr;
@property (strong, nonatomic)NSString *group_id;
@property (strong, nonatomic)NSArray *groupSign;
@end
