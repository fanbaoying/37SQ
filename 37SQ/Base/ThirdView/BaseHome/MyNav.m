//
//  MyNav.m
//  37shequ
//
//  Created by administrator on 16/9/22.
//  Copyright © 2016年 hjp. All rights reserved.
//

#import "MyNav.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width

@implementation MyNav

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitle:(NSString *)title bgImg:(NSString *)bgImgName leftBtn:(NSString *)left rightBtn:(NSString *)right{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 64)];
    
    if (self) {
        if (bgImgName) {
            self.bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 64)];
            self.bgImg.image = [UIImage imageNamed:bgImgName];
            [self addSubview:_bgImg];
        }else {
            self.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
        }
        
        if (title) {
            self.title = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2-50, 30, 100, 30)];
            self.title.text = title;
            self.title.textColor = [UIColor whiteColor];
            self.title.font = [UIFont systemFontOfSize:17];
            self.title.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_title];
        }
        
        if (left) {
            self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 44, 44)];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:left] forState:0];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:left] forState:1];
            [self addSubview:_leftBtn];
        }
        
        if (right) {
            self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN-54, 20, 44, 44)];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:right] forState:0];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:right] forState:1];
            [self addSubview:_rightBtn];
        }

    }

    return self;
}

@end
