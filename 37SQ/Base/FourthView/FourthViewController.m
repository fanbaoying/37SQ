//
//  FourthViewController.m
//  37shequ
//
//  Created by administrator on 16/9/22.
//  Copyright © 2016年 hjp. All rights reserved.
//

#import "FourthViewController.h"
#import "FBYMyNav.h"

#import "FourthCollectionReusableView.h"
#import "FourthCollectionViewCell.h"

#import "FBY-HomeService.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "SetupViewController.h"
#import "AppDelegate.h"
#import "SelfDetailViewController.h"

#import "NSGIF.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "VideoCutViewController.h"

//登录
#import "LoginViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface FourthViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    
    UIImagePickerController *_imagePickerController;
    
}

@property(strong,nonatomic)UIAlertController *alert;

@property(strong,nonatomic)UIAlertAction *action1;

@property(strong,nonatomic)UIAlertAction *action2;

@property(strong,nonatomic)UIAlertAction *action3;

@property(strong,nonatomic)UIActivityIndicatorView *activityIndicator;

@property(strong,nonatomic)NSURL *MyURL;

@property(strong,nonatomic)FBYMyNav *nav;

@property(strong,nonatomic)UICollectionView *collect;

@property(strong,nonatomic)UICollectionViewFlowLayout *layout;

@property(strong,nonatomic)UIView *myView;

@property(strong,nonatomic)UIImageView *bgImg;

@property(strong,nonatomic)UIButton *headBtn;

@property(strong,nonatomic)UILabel *nameLab;

@property(strong,nonatomic)UILabel *likeLab;

//登录按钮
@property(strong,nonatomic)UIButton *loginBtn;



@property(strong,nonatomic)NSArray *arr;

@property(strong,nonatomic)NSDictionary *DataDic;

@property(strong,nonatomic)NSArray *userArr;

@property(strong,nonatomic)NSArray *picArr;

@property(strong,nonatomic)NSArray *titleArr;


@property(assign,nonatomic)int diary;

@property(assign,nonatomic)BOOL choose;

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
        self.headBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/16, SCREEN_WIDTH/4-55, 70, 70)];
        [self.headBtn.layer setBorderWidth:1.0];
        self.headBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.headBtn.layer setCornerRadius:35];
        self.headBtn.clipsToBounds = YES;
    
        self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-55, SCREEN_WIDTH/4-15, 110, 30)];
        self.loginBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:205/255.0 blue:253/255.0 alpha:1];
        [self.loginBtn setTitle:@"注册 / 登录" forState:UIControlStateNormal];
        self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.loginBtn.layer setBorderWidth:1.0];
        self.loginBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.loginBtn.layer setCornerRadius:5];
        self.loginBtn.clipsToBounds = YES;
    
    
    //网络请求
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    if (userid == nil) {
        self.headBtn.hidden = NO;
        self.headBtn.hidden = YES;
        self.bgImg.image = [UIImage imageNamed:@"bg.jpg"];
        self.nameLab.text = nil;
        self.likeLab.text = nil;

        [self.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
    
    FBY_HomeService *service = [[FBY_HomeService alloc]init];
    [service searchMessage:userid andWithAction:@"user" andUrl:@"http://115.159.195.113:8000/37App/index.php/hobby/index/giveme" andSuccess:^(NSDictionary *dic) {
        
//                        NSLog(@"%@",dic);
        
        self.userArr = [dic objectForKey:@"data"];
        
        [self.headBtn sd_setImageWithURL:[_userArr[0] objectForKey:@"user_headimg"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg.jpg"]];

        self.nameLab.text = [_userArr[0] objectForKey:@"user_name"];

        self.likeLab.text = [_userArr[0] objectForKey:@"user_sign"];
        
        [self.bgImg sd_setImageWithURL:[_userArr[0] objectForKey:@"user_bgimg"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
        
        [self.collect reloadData];
        
    } andFailure:^(int fail) {
        
    }];
        
        [self.headBtn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];

        self.headBtn.hidden = NO;
        self.loginBtn.hidden = YES;
        
    }
    
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    self.myView.backgroundColor = [UIColor whiteColor];
    
    self.bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    
    self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH+10)/3, SCREEN_WIDTH/4-55, SCREEN_WIDTH/2, 30)];
    self.nameLab.textColor = [UIColor whiteColor];
    self.nameLab.font = [UIFont systemFontOfSize:17.0];
    
    self.likeLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH+10)/3, SCREEN_WIDTH/4-20, SCREEN_WIDTH/2, 45)];
    self.likeLab.numberOfLines = 3;
    self.likeLab.textColor = [UIColor whiteColor];
    self.likeLab.font = [UIFont systemFontOfSize:12.0];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 100, 50, 50)];
    self.activityIndicator.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;//设置进度轮显示类型
    
//    [self.myView addSubview:_activityIndicator];
    
    
    
    [self.myView addSubview:_bgImg];
    [self.myView addSubview:_likeLab];
    [self.myView addSubview:_nameLab];
    [self.myView addSubview:_headBtn];
    [self.myView addSubview:_loginBtn];
    [self.view addSubview:_myView];
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置布局方向为垂直流布局
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    self.layout.itemSize = CGSizeMake((SCREEN_WIDTH-3)/4, SCREEN_HEIGHT/6);
    
    self.layout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
    
    //创建collectionView 通过一个布局策略layout来创建
    self.collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*1/2+44, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*1/2-93) collectionViewLayout:_layout];
    self.collect.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    //隐藏滚动条
    self.collect.showsVerticalScrollIndicator = NO;
    
    //代理设置
    self.collect.dataSource = self;
    self.collect.delegate = self;
    
    //注册item类型 这里使用系统的类型
    [self.collect registerClass:[FourthCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.collect registerClass:[FourthCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fby"];
//    self.collect.layer.cornerRadius = 5;
    
    self.titleArr = @[@"日记列表",@"剪辑工具",@"转gif",@"个人主页",@"",@"",@"",@""];
    
    self.picArr = @[@"101",@"102",@"103",@"104",@"",@"",@"",@""];
    
    [self.collect addSubview:_activityIndicator];
    
    [self.view addSubview:_collect];
    
    self.nav = [[FBYMyNav alloc]initWithTitle:@"我的" andWithByImg:@"NAV" andWithLetBtn1:nil andWithLeftBtn2:nil andWithRightBtn1:@"setup" andWithRightBtn2:nil];

    [self.nav.rightBtn1 addTarget:self action:@selector(setup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
    //创建UIImagePickerController对象
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
}

//头像跳转
- (void)detail{

    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    if (userid == nil) {
        
        
    }
    else{
    
    SelfDetailViewController *svc = [[SelfDetailViewController alloc]init];
    
        self.tabBarController.tabBar.hidden = YES;
        
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = YES;
          appDelegate.mids.hidden=YES;
    [self presentViewController:svc animated:YES completion:nil];
    }
    
}

//页面即将出现时
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    self.diary = 0;
    
    //网络请求
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    
    if (userid == nil) {
        
        self.loginBtn.hidden = NO;
        self.headBtn.hidden = YES;
        self.bgImg.image = [UIImage imageNamed:@"bg.jpg"];
        self.nameLab.text = nil;
        self.likeLab.text = nil;
        

        [self.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];

        
    }else{
        
        FBY_HomeService *service = [[FBY_HomeService alloc]init];
        [service searchMessage:userid andWithAction:@"user" andUrl:@"http://115.159.195.113:8000/37App/index.php/hobby/index/giveme" andSuccess:^(NSDictionary *dic) {
            
//            NSLog(@"%@",dic);
            
            self.userArr = [dic objectForKey:@"data"];
            
            [self.headBtn sd_setImageWithURL:[_userArr[0] objectForKey:@"user_headimg"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
            self.nameLab.text = [_userArr[0] objectForKey:@"user_name"];
            self.likeLab.text = [_userArr[0] objectForKey:@"user_sign"];
            [self.bgImg sd_setImageWithURL:[_userArr[0] objectForKey:@"user_bgimg"] placeholderImage:[UIImage imageNamed:@"bg.jpg"]];
            [self.collect reloadData];
            
        } andFailure:^(int fail) {
            
        }];
        

        [self.headBtn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];

        self.headBtn.hidden = NO;
        self.loginBtn.hidden = YES;
        
    }
    self.tabBarController.tabBar.hidden = NO;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.addType = 4;
    appDelegate.mid.hidden = NO;
      appDelegate.mids.hidden=NO;
    
}

//登陆跳转
- (void)login:(UIButton *)sender{

    LoginViewController *lc = [[LoginViewController alloc]init];

    self.tabBarController.tabBar.hidden = YES;

    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;

    [self.navigationController pushViewController:lc animated:YES];


}

//设置跳转
- (void)setup:(UIButton *)sender{

    SetupViewController *svc = [[SetupViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    
    [self.navigationController pushViewController:svc animated:YES];
    
}


//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}


//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}

//返回分区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 8;
}

//每个分区头部的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(SCREEN_WIDTH, 45);
}

//脚部位置设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 10);
}

//item 点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.row == 3) {
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        NSString *userid = [SQUserid objectForKey:@"userid"];
        
        if (userid == nil) {
        }
        else{
            
            SelfDetailViewController *svc = [[SelfDetailViewController alloc]init];
            
            self.tabBarController.tabBar.hidden = YES;
            
            AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.mid.hidden = YES;
              appDelegate.mids.hidden=YES;
            
            [self presentViewController:svc animated:YES completion:nil];
        }
        
    }else if (indexPath.row == 2){
    
        self.alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"快来转GIF呀!" preferredStyle:UIAlertControllerStyleAlert];
        
        self.action1 = [UIAlertAction actionWithTitle:@"现拍现转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
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
            });
            }else{
//                NSLog(@"该设备没有摄像头");
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有开启摄像头" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                [alert addAction:action1];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }];
        
        self.action2 = [UIAlertAction actionWithTitle:@"去相册看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.tabBarController.tabBar.hidden = YES;
            
            AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.mid.hidden = YES;
              appDelegate.mids.hidden=YES;
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
                
            }
            
            picker.delegate = self;
            picker.allowsEditing = NO;
            
            [self presentViewController:picker animated:YES completion:nil];

        }];
        
        self.action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [self.alert addAction:_action1];
        [self.alert addAction:_action2];
        [self.alert addAction:_action3];
        [self presentViewController:_alert animated:YES completion:nil];
        
    }else if (indexPath.row == 1){
    
        VideoCutViewController *vcvc = [[VideoCutViewController alloc]init];
        
        self.tabBarController.tabBar.hidden = YES;
        
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = YES;
          appDelegate.mids.hidden=YES;
        [self.navigationController pushViewController:vcvc animated:YES];
        
    }else if (indexPath.row == 0){
    
        self.tabBarController.tabBar.hidden = YES;
        
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = YES;
          appDelegate.mids.hidden=YES;
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            
        }
        
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        _choose = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
    
}

//转GIF
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        
    }
    else{
        
        self.MyURL = info[UIImagePickerControllerMediaURL];
        
        if (_choose == YES) {
            _choose = NO;
        }else{
        
        if (_MyURL) {
            [self.activityIndicator startAnimating];
            self.action1.enabled = NO;
            self.action2.enabled = NO;
            
            
            [NSGIF createGIFfromURL:_MyURL withFrameCount:30 delayTime:.010 loopCount:0 completion:^(NSURL *GifURL) {
                
                NSLog(@"Finished generating GIF: %@", GifURL);
                
                [self.activityIndicator stopAnimating];
                [UIView animateWithDuration:0.3 animations:^{
//                    self.action1.alpha = 0.0f;
//                    self.action2.alpha = 0.0f;
//                    self.webView.alpha = 1.0f;
                }];
//                [self.webView loadRequest:[NSURLRequest requestWithURL:GifURL]];
                
                UIAlertController *alert;
                if (GifURL){
                    
                    alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你成功创建GIF" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                        
                        NSData *data = [NSData dataWithContentsOfURL:GifURL];
                        
                        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
                            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                                [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
                            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                                NSLog(@"是否保存成功：%d",success);
                            }];
                        }
                        //                else {
                        //                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                        //                    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                        //                    }];
                        //                }
                        
                        
//                        UIImageWriteToSavedPhotosAlbum(_finishImage,self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                        
                        self.tabBarController.tabBar.hidden = YES;
                        
                        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        appDelegate.mid.hidden = YES;
                          appDelegate.mids.hidden=YES;
                        [self presentViewController:picker animated:YES completion:nil];
                        
                        
                    }];
                    
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
//                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    
                    [alert addAction:action2];
                    [alert addAction:action1];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"出现错误" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    
                    [alert addAction:action1];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            }];
        }
    
        }
    }
    self.tabBarController.tabBar.hidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    [self dismissViewControllerAnimated:YES completion:nil];

}


//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FourthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
//        cell.backgroundColor = [UIColor purpleColor];
    
    cell.myImg.image = [UIImage imageNamed:_picArr[indexPath.row]];
    
    cell.myLab.text = _titleArr[indexPath.row];
    
       return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    FourthCollectionReusableView *myheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fby" forIndexPath:indexPath];
    
    myheader.myLab.text = @"个人中心";
    
    return myheader;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
