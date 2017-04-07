//
//  CollectTableViewCell.m
//  37SQ
//
//  Created by administrator on 16/10/28.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "CollectTableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation CollectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.myView = [[UIView alloc]init];
        
        self.videoImg = [[UIImageView alloc]init];
        //        [self.videoImg.layer setBorderWidth:1.0];
        //        self.videoImg.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.videoImg.layer setCornerRadius:5.0];
        self.videoImg.clipsToBounds = YES;
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.font = [UIFont systemFontOfSize:15.0];
        self.titleLab.numberOfLines = 2;
        
        self.nameLab = [[UILabel alloc]init];
        self.nameLab.font = [UIFont systemFontOfSize:12.0];
        self.nameLab.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        
        self.nameLab1 = [[UILabel alloc]init];
        self.nameLab1.font = [UIFont systemFontOfSize:12.0];
        self.nameLab1.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        self.nameLab1.textAlignment = NSTextAlignmentLeft;
        
        self.playLab = [[UILabel alloc]init];
        self.playLab.font = [UIFont systemFontOfSize:12.0];
        self.playLab.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        
        self.playLab1 = [[UILabel alloc]init];
        self.playLab1.font = [UIFont systemFontOfSize:12.0];
        self.playLab1.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        
        [self.myView addSubview:_playLab1];
        [self.myView addSubview:_nameLab1];
        [self.myView addSubview:_playLab];
        [self.myView addSubview:_nameLab];
        [self.myView addSubview:_titleLab];
        [self.myView addSubview:_videoImg];
        [self.contentView addSubview:_myView];
        
        
    }
    
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.myView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    
    self.videoImg.frame = CGRectMake(10, 20, (SCREEN_WIDTH-20)/3, 60);
    
    self.titleLab.frame = CGRectMake((SCREEN_WIDTH-20)/3+20, 20, SCREEN_WIDTH-(SCREEN_WIDTH-20)/3-30, 40);
    
    self.nameLab.frame = CGRectMake((SCREEN_WIDTH-20)/3+20, 60, 35, 20);
    
    self.nameLab1.frame = CGRectMake((SCREEN_WIDTH-20)/3+55, 60, 60, 20);
    
    self.playLab.frame = CGRectMake(SCREEN_WIDTH-80, 60, 30, 20);
    
    self.playLab1.frame = CGRectMake(SCREEN_WIDTH-50, 60, 40, 20);
    
}


@end
