//
//  SetupTableViewCell.m
//  37SQ
//
//  Created by administrator on 16/10/17.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "SetupTableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@implementation SetupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.myView = [[UIView alloc]init];
        
        self.setupLab = [[UILabel alloc]init];
        self.setupLab.font = [UIFont systemFontOfSize:15.0];
        
        self.nextImg = [[UIImageView alloc]init];
        
        self.setupLab3 = [[UILabel alloc]init];
        self.setupLab3.font = [UIFont systemFontOfSize:15.0];
        
        self.contentLab3 = [[UILabel alloc]init];
        self.contentLab3.textAlignment = NSTextAlignmentRight;
        self.contentLab3.textColor = [UIColor colorWithRed:191/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        self.contentLab3.font = [UIFont systemFontOfSize:15.0];
        
        self.leaveLab = [[UILabel alloc]init];
        self.leaveLab.textAlignment = NSTextAlignmentCenter;
        self.leaveLab.textColor = [UIColor redColor];
        self.leaveLab.font = [UIFont systemFontOfSize:15.0];
        
        [self.myView addSubview:_leaveLab];
        [self.myView addSubview:_contentLab3];
        [self.myView addSubview:_setupLab3];
        [self.myView addSubview:_nextImg];
        [self.myView addSubview:_setupLab];
        [self.contentView addSubview:_myView];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.myView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    
    self.setupLab.frame = CGRectMake(15, 10, 180, 20);
    
    self.nextImg.frame = CGRectMake(SCREEN_WIDTH-20, 15, 10, 15);
    
    self.setupLab3.frame = CGRectMake(15, 10, SCREEN_WIDTH/3-20, 20);

    self.contentLab3.frame = CGRectMake(SCREEN_WIDTH/3, 10, SCREEN_WIDTH*2/3-20, 20);
    
    self.leaveLab.frame = CGRectMake(SCREEN_WIDTH/2-60, 10, 120, 20);
}

@end
