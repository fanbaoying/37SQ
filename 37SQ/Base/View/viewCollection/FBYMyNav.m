//
//  MyNav.m
//  0815-作业
//
//  Created by administrator on 16/8/15.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "FBYMyNav.h"

@implementation FBYMyNav

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

- (instancetype)initWithTitle:(NSString *)title andWithByImg:(NSString *)bgName andWithLetBtn1:(NSString *)leftBtn1 andWithLeftBtn2:(NSString *)leftBtn2 andWithRightBtn1:(NSString *)rightBtn1 andWithRightBtn2:(NSString *)rightBtn2
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    if (self) {
        
        self.bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        self.bgImg.image = [UIImage imageNamed:bgName];
        [self addSubview:_bgImg];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 30, 200, 30)];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:17.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_titleLabel];
        
        
        if (leftBtn1) {
            self.leftBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
            [self.leftBtn1 setBackgroundImage:[UIImage imageNamed:leftBtn1] forState:UIControlStateNormal];
            [self addSubview:_leftBtn1];

        }
        
        if (leftBtn2) {
            self.leftBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
            [self.leftBtn2 setTitle:leftBtn2 forState:UIControlStateNormal];
            self.leftBtn2.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [self addSubview:_leftBtn2];

        }
        
        if (rightBtn1) {
            self.rightBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-44, 20, 44, 44)];
            [self.rightBtn1 setBackgroundImage:[UIImage imageNamed:rightBtn1] forState:UIControlStateNormal];
            [self addSubview:_rightBtn1];
            
        }
        
        if (rightBtn2) {
            self.rightBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 20, 70, 44)];
            [self.rightBtn2 setTitle:rightBtn2 forState:UIControlStateNormal];
            self.rightBtn2.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [self addSubview:_rightBtn2];
            
        }
        
        
        
        
    }
    return self;
    
    
}

@end
