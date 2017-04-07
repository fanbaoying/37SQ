//
//  GroupmemberViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/8.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "GroupmemberViewController.h"
#import "GiveService.h"
#import "MyNav.h"
#import "UIImageView+WebCache.h"
#import "OtherDetailViewController.h"
#import "SelfDetailViewController.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface GroupmemberViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property(strong,nonatomic)NSArray *memberArr;

@end

@implementation GroupmemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    //导航栏
    
    MyNav *nav = [[MyNav alloc]initWithTitle:@"群组成员" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
     //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为水平/竖直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    layout.itemSize = CGSizeMake((SCREEN_WIDHN-30)/4.0,(SCREEN_WIDHN-30)/4.0);
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    //代理设置
    collect.backgroundColor=[UIColor groupTableViewBackgroundColor];
    collect.delegate=self;
    collect.dataSource=self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.view addSubview:collect];

    
    //网络请求
    GiveService *tesit=[[GiveService alloc]init];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/detail";
    [tesit searchMessage:self.groupid andAction:@"groupmember" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
        //            NSLog(@"%@",dic);
        self.memberArr  =[dic objectForKey:@"data"];
        if (_memberArr) {
            [collect reloadData];
        }
        
        //        NSLog(@"%@",test.memberArr);
    }
     ];
    
    
    
}
-(void)leftaction{

    [self.navigationController popViewControllerAnimated:YES];

}
//每个分区头部的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDHN, 10);
}


//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

//返回每个item

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    //名字
        UILabel *test=[[UILabel alloc]initWithFrame:CGRectMake(5,( (SCREEN_WIDHN-30)/4.0-20), (SCREEN_WIDHN-30)/4.0-10, 20)];

    test.font=[UIFont systemFontOfSize:12];
    test.textAlignment=NSTextAlignmentCenter;
    test.text=[_memberArr[indexPath.row] objectForKey:@"user_name"];
//        test.backgroundColor=[UIColor redColor];
        [cell addSubview:test];
    
    UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, (SCREEN_WIDHN-30)/4.0-20, (SCREEN_WIDHN-30)/4.0-20)];
    [head sd_setImageWithURL:[_memberArr[indexPath.row] objectForKey:@"user_headimg"] placeholderImage:[UIImage imageNamed:@"loadhead"]];
    head.layer.cornerRadius=((SCREEN_WIDHN-30)/4.0-20)/2;
    head.clipsToBounds=YES;
//    head.backgroundColor=[UIColor blueColor];
    [cell addSubview:head];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
    
}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _memberArr.count;
}
//item的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if ([[NSString stringWithFormat:@"%@",[_memberArr[indexPath.row] objectForKey:@"user_id"]] isEqualToString:squserid]) {
        SelfDetailViewController *vc=[[SelfDetailViewController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        OtherDetailViewController *vc=[[OtherDetailViewController alloc]init];
        vc.otherUserid =[_memberArr[indexPath.row] objectForKey:@"user_id"];
        [self presentViewController:vc animated:YES completion:nil];
    }

}



@end
