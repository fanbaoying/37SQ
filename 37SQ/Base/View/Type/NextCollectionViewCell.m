//
//  NextCollectionViewCell.m
//  37SQ
//
//  Created by administrator on 16/10/12.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "NextCollectionViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation NextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        //影片主题
        
        self.titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)*2/6)];
        //        [self.titleImg.layer setBorderWidth:0.5];
        //        self.titleImg.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.titleImg.layer setCornerRadius:5.0];
        self.titleImg.clipsToBounds = YES;
        
        //        [self.titleBtn  addTarget:self action:@selector(movieNext:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_titleImg];
        
        //播放量+图片
        self.playImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, (SCREEN_WIDTH-30)*2/6-20, 15, 15)];
        
        [self addSubview:_playImg];
        
        self.playLab = [[UILabel alloc]initWithFrame:CGRectMake(20, (SCREEN_WIDTH-30)*2/6-22, 50, 20)];
        //        self.playLab.backgroundColor = [UIColor redColor];
        
        //    self.playLab.backgroundColor = [UIColor redColor];
        self.playLab.textColor = [UIColor whiteColor];
        self.playLab.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:_playLab];
        
        //评论量+图片
        self.commentImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)*2/6, (SCREEN_WIDTH-30)*2/6-20, 15, 15)];
        
        [self addSubview:_commentImg];
        
        self.commentLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)*2/6+15, (SCREEN_WIDTH-30)*2/6-22, 30, 20)];
        //        self.commentLab.backgroundColor = [UIColor redColor];
        
        
        self.commentLab.textColor = [UIColor whiteColor];
        self.commentLab.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:_commentLab];
        
        //简介
        self.contentLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREEN_WIDTH-30)*2/6,  (SCREEN_WIDTH-30)/2, 30)];
        
        self.contentLab.numberOfLines = 2;
        self.contentLab.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:_contentLab];
        
    }
    
    
    
    return self;
}

@end
