//
//  AddNewCollectionReusableView.m
//  37SQ
//
//  Created by administrator on 16/11/5.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "AddNewCollectionReusableView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface AddNewCollectionReusableView()<UIScrollViewDelegate>

@end

@implementation AddNewCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        //小画布
        
        self.adView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        self.adView.backgroundColor = [UIColor clearColor];
        
        self.adScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        self.adScrollView.delegate = self;
        self.adScrollView.pagingEnabled = YES;
        self.adScrollView.backgroundColor = [UIColor whiteColor];
        self.adScrollView.showsHorizontalScrollIndicator = FALSE;
        self.adScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_WIDTH/2);
        
        self.titleImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        
        [self.adScrollView addSubview:_titleImg1];
        
        self.titleImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        //        self.titleImg2.image = [UIImage imageNamed:@"bg.jpg"];
        [self.adScrollView addSubview:_titleImg2];
        
        self.titleImg3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        //        self.titleImg3.image = [UIImage imageNamed:@"bg.jpg"];
        [self.adScrollView addSubview:_titleImg3];
        
        [self.adView addSubview:_adScrollView];
        [self addSubview:_adView];
        
        self.myPag = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, SCREEN_WIDTH/2-20, 40, 20)];
        self.myPag.backgroundColor = [UIColor clearColor];
        self.myPag.numberOfPages = 3;
        self.myPag.currentPageIndicatorTintColor = [UIColor colorWithRed:35/255.0 green:203/255.0 blue:255/255.0 alpha:1];//选中页码的颜色
        self.myPag.pageIndicatorTintColor = [UIColor whiteColor];//未选中页码的颜色
        self.myPag.currentPage = 0;//当前选中页
        self.myPag.tag = 101;
        [self.adView addSubview:_myPag];

    }
    
    
    
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UITableView class]])
    {
        //        NSLog(@"scrollViewDidEndDecelerating %@",scrollView);
    }
    else{
        //scrollView的偏移量，x,y值
        int current = scrollView.contentOffset.x/SCREEN_WIDTH;
        self.myPag = (UIPageControl *)[self viewWithTag:101];  //类型强转，查找
        self.myPag.currentPage = current;
        //        NSLog(@"scrollViewDidEndDecelerating %@",scrollView);
        //        NSLog(@"%f",scrollView.contentOffset.x);//打印偏移量值
    }
}

@end
