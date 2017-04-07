//
//  FourthCollectionReusableView.m
//  37SQ
//
//  Created by administrator on 16/10/14.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "FourthCollectionReusableView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation FourthCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.myLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH, 20)];
        
        self.myLab.font = [UIFont systemFontOfSize:18.0];

        [self addSubview:_myLab];
        
    }
    
    
    
    return self;
}

@end
