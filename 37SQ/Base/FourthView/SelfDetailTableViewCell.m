//
//  SelfDetailTableViewCell.m
//  37SQ
//
//  Created by administrator on 16/10/18.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "SelfDetailTableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation SelfDetailTableViewCell

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
        self.titleLab.font = [UIFont systemFontOfSize:12.0];
        self.titleLab.numberOfLines = 2;
        
        self.playImg = [[UIImageView alloc]init];
        
        self.playLab1 = [[UILabel alloc]init];
        self.playLab1.font = [UIFont systemFontOfSize:12.0];
        self.playLab1.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        
        self.commentImg = [[UIImageView alloc]init];
        
        
        self.commentLab1 = [[UILabel alloc]init];
        self.commentLab1.font = [UIFont systemFontOfSize:12.0];
        self.commentLab1.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        
        self.nameLab = [[UILabel alloc]init];
        self.nameLab.font = [UIFont systemFontOfSize:12.0];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        
        self.headImg = [[UIImageView alloc]init];
        [self.headImg.layer setBorderWidth:1.0];
        self.headImg.layer.borderColor = [UIColor clearColor].CGColor;
        [self.headImg.layer setCornerRadius:35];
        self.headImg.clipsToBounds = YES;
        
        self.signLab = [[UILabel alloc]init];
        self.signLab.font = [UIFont systemFontOfSize:12.0];
        self.signLab.numberOfLines = 3;
        self.signLab.textAlignment = NSTextAlignmentLeft;
        self.signLab.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        
        [self.myView addSubview:_signLab];
        [self.myView addSubview:_nameLab];
        [self.myView addSubview:_headImg];
        [self.myView addSubview:_playLab1];
        [self.myView addSubview:_playImg];
        [self.myView addSubview:_commentLab1];
        [self.myView addSubview:_commentImg];
        [self.myView addSubview:_titleLab];
        [self.myView addSubview:_videoImg];
        [self.contentView addSubview:_myView];
        
        
    }
    
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.myView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    
    self.videoImg.frame = CGRectMake(10, 10, (SCREEN_WIDTH-20)/3, 80);
    
    self.titleLab.frame = CGRectMake((SCREEN_WIDTH-20)/3+20, 10, SCREEN_WIDTH-(SCREEN_WIDTH-20)/3-30, 40);
    
    self.playImg.frame = CGRectMake((SCREEN_WIDTH-20)/3+20, 65, 15, 15);
    
    self.playLab1.frame = CGRectMake((SCREEN_WIDTH-20)/3+40, 62, 50, 20);
    
    self.commentImg.frame = CGRectMake(SCREEN_WIDTH-80, 65, 15, 15);
    
    self.commentLab1.frame = CGRectMake(SCREEN_WIDTH-60, 62, 40, 20);
    
    self.nameLab.frame = CGRectMake((SCREEN_WIDTH-20)/3+20, 20, SCREEN_WIDTH-(SCREEN_WIDTH-20)/3-30, 30);
    
    self.headImg.frame = CGRectMake(SCREEN_WIDTH/16, 15, 70, 70);
    
    self.signLab.frame = CGRectMake((SCREEN_WIDTH-20)/3+20, 50, SCREEN_WIDTH-(SCREEN_WIDTH-20)/3-30, 40);

}

@end
