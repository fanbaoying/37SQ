//
//  AddNewViewController.m
//  37SQ
//
//  Created by administrator on 16/11/1.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "AddNewViewController.h"
#import "FBYMyNav.h"
#import "AppDelegate.h"
#import "AddNewCollectionReusableView.h"
#import "AddNewCollectionViewCell.h"
#import "FBY-HomeService.h"

//第一
#import "HeaderViewController.h"
//第二
#import "LikeViewController.h"
//第三
#import "CommunViewController.h"

//视频日记
#import "VideoDiaryViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface AddNewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic)FBYMyNav *nav;
@property(strong,nonatomic)UICollectionView *collect;
@property(strong,nonatomic)UICollectionViewFlowLayout *layout;

//图片数组
@property(strong,nonatomic)NSArray *picArr;
@property(strong,nonatomic)NSArray *titleArr;

@property(strong,nonatomic)NSArray *ADArr;

@property(strong,nonatomic)UILabel *Lab;

@end

@implementation AddNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.Lab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/2+115, SCREEN_WIDTH, SCREEN_HEIGHT- SCREEN_WIDTH/2-115)];
//    self.Lab.backgroundColor = [UIColor purpleColor];
    self.Lab.textColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    self.Lab.font = [UIFont systemFontOfSize:12.0];
    self.Lab.textAlignment = NSTextAlignmentLeft;
    self.Lab.text = @"  37摄区无法控制利用本服务制作、上传、存储、传播之内容，也无法对用户的使用行为进行全面监视与控制，因此37摄区不保证内容的合法性、正确性、完整性、真实性或品质；你已预知使用本服务时，可能会接触到令人不快、不适当或令人厌恶之内容，并同意将自行加以判断并承担所有风险，而不依赖于37摄区.";
    self.Lab.numberOfLines = 0;
    
    self.nav = [[FBYMyNav alloc]initWithTitle:@"上传" andWithByImg:@"NAV" andWithLetBtn1:@"backfby" andWithLeftBtn2:nil andWithRightBtn1:nil andWithRightBtn2:nil];
    [self.nav.leftBtn1 addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];

    self.layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局为垂直流布局
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置每个item的大小
    self.layout.itemSize = CGSizeMake((SCREEN_WIDTH-3)/4, SCREEN_HEIGHT/6);
    
    //设置上左下右的距离
    self.layout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
    
    //创建collectionview 通过一个布局策略layout来创建
    self.collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-44) collectionViewLayout:_layout];
    self.collect.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:239/255.0];
    
    //代理设置
    self.collect.dataSource = self;
    self.collect.delegate = self;
    
    //注册item 类型 这里使用系统的类型
    [self.collect registerClass:[AddNewCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.collect registerClass:[AddNewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fby"];
    
    [self.view addSubview:_collect];
    [self.collect addSubview:_Lab];
    
    self.picArr = @[@"6001",@"6002",@"6003",@"6004"];
    self.titleArr = @[@"公开视频",@"群组视频",@"发布帖子",@"视频日记"];
    
    //广告网络请求
    FBY_HomeService *service1 = [[FBY_HomeService alloc]init];
    [service1 searchMessage:@"1" andWithAction:@"type" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/type/adtype" andSuccess:^(NSDictionary *dic) {
        
        //        NSLog(@"%@",dic);
        
        self.ADArr = [dic objectForKey:@"data"];
        
        [self.collect reloadData];
        
    } andFailure:^(int fail) {
        
    }];

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
    
    return 4;
}

//每个分区头部的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2+45);
}

//item 点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HeaderViewController *hvc = [[HeaderViewController alloc]init];
        
        [self presentViewController:hvc animated:YES completion:nil];
        
    }else if (indexPath.row == 1){
    
        LikeViewController *lvc = [[LikeViewController alloc]init];
        
        [self presentViewController:lvc animated:YES completion:nil];
        
    }else if (indexPath.row == 2){
        
        CommunViewController *cvc = [[CommunViewController alloc]init];
        
        [self presentViewController:cvc animated:YES completion:nil];
        
    }else if (indexPath.row == 3){
        
        VideoDiaryViewController *vdvc = [[VideoDiaryViewController alloc]init];
        
        [self presentViewController:vdvc animated:YES completion:nil];
        
    }

    
}
//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AddNewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor purpleColor];
    
    cell.myImg.image = [UIImage imageNamed:_picArr[indexPath.row]];

    cell.myLab.text = _titleArr[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    AddNewCollectionReusableView *myheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fby" forIndexPath:indexPath];
    

    [myheader.titleImg1 sd_setImageWithURL:[_ADArr[0] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg1"]];
    [myheader.titleImg2 sd_setImageWithURL:[_ADArr[1] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg2"]];
    [myheader.titleImg3 sd_setImageWithURL:[_ADArr[2] objectForKey:@"ad_pic"] placeholderImage:[UIImage imageNamed:@"bg3"]];
    
    myheader.myLab.text = @"选择上传";
    
    return myheader;
    
}

- (void)viewWillAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
    appDelegate.mids.hidden=YES;

}

//导航栏返回
- (void)next:(UIButton *)sender{
    
    //    //隐藏tabbar及中间的加号
    self.tabBarController.tabBar.hidden = NO;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = NO;
      appDelegate.mids.hidden=NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
