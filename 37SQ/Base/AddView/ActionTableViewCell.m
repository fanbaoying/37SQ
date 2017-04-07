//
//  ActionTableViewCell.m
//  Healthy
//
//  Created by administrator on 16/10/9.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ActionTableViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation ActionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.myView = [[UIView alloc]init];
        self.headImage = [[UIImageView alloc]init];
        self.titleLabel = [[UILabel alloc]init];
        self.timesLabel = [[UILabel alloc]init];
        self.timeLabel = [[UILabel alloc]init];
        self.confirmBtn = [[UIImageView alloc]init];
        
        
        [self.contentView addSubview:_myView];
        [self.myView addSubview:_headImage];
        [self.myView addSubview:_titleLabel];
        [self.myView addSubview:_timesLabel];
        [self.myView addSubview:_timeLabel];
        [self.myView addSubview:_confirmBtn];
        
    }
    
    return self;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;//去除选择效果
    
    self.myView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    self.myView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    self.headImage.frame = CGRectMake((SCREEN_WIDTH-270)/2, 15, 70, 50);
    
    
    
    self.titleLabel.frame = CGRectMake((SCREEN_WIDTH-270)/2+90, 30, 150, 20);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    
    
    self.timesLabel.frame = CGRectMake(90+(SCREEN_WIDTH-270)/2, 47, 150, 20);
    self.timesLabel.font = [UIFont boldSystemFontOfSize:13];
    
    
    
    self.timeLabel.frame = CGRectMake(180+(SCREEN_WIDTH-270)/2, 47, 40, 20);
    self.timeLabel.font = [UIFont boldSystemFontOfSize:13];
    
    
    self.confirmBtn.frame = CGRectMake(250+(SCREEN_WIDTH-270)/2, 30, 20, 20);
    
}
- (void)setChecked:(BOOL)checked{
    
    if (checked) {
        self.confirmBtn.image = [UIImage imageNamed:@"Achievement-OK"];
    }
    else{
        self.confirmBtn.image = [UIImage imageNamed:@"Achievement-NO"];
    }
    
}

@end
