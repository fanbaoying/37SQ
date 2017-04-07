//
//  VideoCutViewController.m
//  37SQ
//
//  Created by administrator on 16/10/25.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "VideoCutViewController.h"
#import "FBYMyNav.h"
#import <Photos/Photos.h>
#import "ICGVideoTrimmerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface VideoCutViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ICGVideoTrimmerDelegate>


{
    
    UIImagePickerController *_imagePickerController;
    
}

@property(strong,nonatomic)UIButton *phoneBtn;

@property(strong,nonatomic)FBYMyNav *nav;

@property (assign, nonatomic) BOOL isPlaying;

@property (strong, nonatomic) AVAsset *asset;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (strong, nonatomic) NSTimer *playbackTimeCheckerTimer;

@property (assign, nonatomic) CGFloat videoPlaybackPosition;



@property(strong,nonatomic)UIView *videoPlayer;

@property(strong,nonatomic)UIView *videoLayer;

@property(strong,nonatomic)ICGVideoTrimmerView *trimmerView;

@property(strong,nonatomic)UIButton *trimButton;

@property (strong, nonatomic) NSString *tempVideoPath;

@property (strong, nonatomic) AVAssetExportSession *exportSession;


@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat stopTime;



@end

@implementation VideoCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
    
    self.nav = [[FBYMyNav alloc]initWithTitle:@"视频剪辑" andWithByImg:@"NAV" andWithLetBtn1:@"backfby" andWithLeftBtn2:nil andWithRightBtn1:nil andWithRightBtn2:nil];
    
    [self.nav.leftBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
    self.tempVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpMov.mov"];
    
    
    self.phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/16, 84, SCREEN_WIDTH/4, 40)];
    self.phoneBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    [self.phoneBtn setTitle:@"相册" forState:UIControlStateNormal];
    self.phoneBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.phoneBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.phoneBtn.layer setBorderWidth:1.0];
    self.phoneBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.phoneBtn.layer setCornerRadius:15.0];
    self.phoneBtn.clipsToBounds = YES;
    [self.phoneBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    self.trimButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/16-SCREEN_WIDTH/4, 84, SCREEN_WIDTH/4, 40)];
    [self.trimButton setTitle:@"保存" forState:UIControlStateNormal];
    self.trimButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.trimButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.trimButton.layer setBorderWidth:1.0];
    self.trimButton.layer.borderColor = [UIColor clearColor].CGColor;
    [self.trimButton.layer setCornerRadius:12.0];
    self.trimButton.clipsToBounds = YES;
    [self.trimButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.trimButton.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1 alpha:1];
    
    
    self.videoPlayer = [[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_WIDTH)];
    self.videoPlayer.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    
    self.videoLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    self.videoLayer.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];


    self.trimmerView = [[ICGVideoTrimmerView alloc]initWithFrame:CGRectMake(0, 465, SCREEN_WIDTH, 100)];
    self.trimmerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    self.trimmerView.delegate = self;
    
    [self.view addSubview:_videoPlayer];
    [self.videoPlayer addSubview:_videoLayer];
    
    [self.view addSubview:_trimmerView];
    [self.view addSubview:_trimButton];
    [self.view addSubview:_phoneBtn];
    
    //创建UIImagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    
}

//导航栏返回
- (void)back:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)next{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        
//    }
    
    picker.delegate = self;
    
    picker.allowsEditing = NO;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (void)trimmerView:(ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime
{
    
    
    if (startTime != self.startTime) {
        
        //then it moved the left position, we should rearrange the bar
        [self seekVideoToPos:startTime];
    }
    self.startTime = startTime;
    self.stopTime = endTime;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能选择照片" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    self.asset = [AVAsset assetWithURL:url];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
    
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    [self.videoLayer.layer addSublayer:self.playerLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];

    [self.videoLayer addGestureRecognizer:tap];
    
    self.videoPlaybackPosition = 0;
    
    // set properties for trimmer view
    [self.trimmerView setThemeColor:[UIColor lightGrayColor]];
    [self.trimmerView setAsset:self.asset];
    [self.trimmerView setShowsRulerView:YES];
    [self.trimmerView setTrackerColor:[UIColor cyanColor]];
    [self.trimmerView setDelegate:self];
    
    // important: reset subviews
    [self.trimmerView resetSubviews];
    
    [self.trimButton setHidden:NO];
        
    }
    
}

- (void)deleteTempFile
{
    NSURL *url = [NSURL fileURLWithPath:self.tempVideoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"文件删除");
        if (err) {
            NSLog(@"文件删除错误, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"没有文件名称");
    }
}

- (void)save
{
    [self deleteTempFile];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存视频" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:self.asset];
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
            
            self.exportSession = [[AVAssetExportSession alloc]
                                  initWithAsset:self.asset presetName:AVAssetExportPresetPassthrough];
            // Implementation continues.
            
            NSURL *furl = [NSURL fileURLWithPath:self.tempVideoPath];
            
            self.exportSession.outputURL = furl;
            self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
            
            CMTime start = CMTimeMakeWithSeconds(self.startTime, self.asset.duration.timescale);
            CMTime duration = CMTimeMakeWithSeconds(self.stopTime - self.startTime, self.asset.duration.timescale);
            CMTimeRange range = CMTimeRangeMake(start, duration);
            self.exportSession.timeRange = range;
            
            [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([self.exportSession status]) {
                    case AVAssetExportSessionStatusFailed:
                        
                        NSLog(@"导出失败: %@", [[self.exportSession error] localizedDescription]);
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        
                        NSLog(@"取消出口");
                        break;
                    default:
                        NSLog(@"NONE");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSURL *movieUrl = [NSURL fileURLWithPath:self.tempVideoPath];
                            UISaveVideoAtPathToSavedPhotosAlbum([movieUrl relativePath], self,@selector(video:didFinishSavingWithError:contextInfo:), nil);
                        });
                        
                        break;
                }
            }];
            
        }

        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
    }

- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"视频保存失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频保存成功" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.playerLayer.frame = CGRectMake(0, 0, self.videoLayer.frame.size.width, self.videoLayer.frame.size.height);
}

- (void)viewWillDisappear:(BOOL)animated{

    [self.playerLayer removeFromSuperlayer];
    
}

- (void)tapOnVideoLayer:(UITapGestureRecognizer *)tap
{
    if (self.isPlaying) {
        [self.player pause];
        [self stopPlaybackTimeChecker];
    }else {
        [self.player play];
        [self startPlaybackTimeChecker];
    }
    self.isPlaying = !self.isPlaying;
    [self.trimmerView hideTracker:!self.isPlaying];
}

- (void)startPlaybackTimeChecker
{
    [self stopPlaybackTimeChecker];
    
    self.playbackTimeCheckerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onPlaybackTimeCheckerTimer) userInfo:nil repeats:YES];
}

- (void)stopPlaybackTimeChecker
{
    if (self.playbackTimeCheckerTimer) {
        [self.playbackTimeCheckerTimer invalidate];
        self.playbackTimeCheckerTimer = nil;
    }
}

- (void)onPlaybackTimeCheckerTimer
{
    self.videoPlaybackPosition = CMTimeGetSeconds([self.player currentTime]);
    
    [self.trimmerView seekToTime:CMTimeGetSeconds([self.player currentTime])];
    
    if (self.videoPlaybackPosition >= self.stopTime) {
        self.videoPlaybackPosition = self.startTime;
        [self seekVideoToPos: self.startTime];
        [self.trimmerView seekToTime:self.startTime];
    }
}

- (void)seekVideoToPos:(CGFloat)pos
{
    self.videoPlaybackPosition = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.player.currentTime.timescale);
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

@end
