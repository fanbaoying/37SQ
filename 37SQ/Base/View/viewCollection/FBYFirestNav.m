//
//  FBYFirestNav.m
//  37SQ
//
//  Created by administrator on 16/11/2.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "FBYFirestNav.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation FBYFirestNav

- (instancetype)initWithTitle:(NSString *)titleBtn andWithByImg:(NSString *)bgName andWithCollect:(NSString *)collectBtn andWithType:(NSString *)typeBtn{

    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    if (self) {
        
        self.bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        self.bgImg.image = [UIImage imageNamed:bgName];
        [self addSubview:_bgImg];
        
        self.collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-66-SCREEN_WIDTH/16, 24, 44, 44)];
        [self.collectBtn setTitle:collectBtn forState:UIControlStateNormal];
        self.collectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        self.collectBtn.backgroundColor = [UIColor purpleColor];
        self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:_collectBtn];
        
        self.titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-22, 24, 44, 44)];
        [self.titleBtn setTitle:titleBtn forState:UIControlStateNormal];
        self.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        self.titleBtn.backgroundColor = [UIColor purpleColor];
        self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:_titleBtn];
        
        self.typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+22+SCREEN_WIDTH/16, 24, 44, 44)];
        [self.typeBtn setTitle:typeBtn forState:UIControlStateNormal];
        self.typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        self.typeBtn.backgroundColor = [UIColor purpleColor];
        self.typeBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:_typeBtn];
        
    }
    return self;
    
}


@end
