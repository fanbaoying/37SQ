//
//  CommunViewController.h
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


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CommunViewController : UIViewController

//帖子上传界面属性
@property (strong, nonatomic)UITextField *TZtitle;
@property (strong, nonatomic)UITextView *TZhtml;
@property (strong, nonatomic)UIView *btnView;

@property (strong, nonatomic)NSMutableArray *photoArr;
@property (strong, nonatomic)UIButton *btn;
@property (strong, nonnull)NSString *TZtype;

@end
