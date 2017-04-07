//
//  AddNewCollectionViewCell.m
//  37SQ
//
//  Created by administrator on 16/11/5.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "AddNewCollectionViewCell.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation AddNewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.myImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/16, (SCREEN_WIDTH-3)/16, (SCREEN_WIDTH-3)/8, (SCREEN_WIDTH-3)/8)];
        //        self.myImg.backgroundColor = [UIColor redColor];
        [self addSubview:_myImg];
        
        self.myLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-3)/32, (SCREEN_WIDTH-3)/16+(SCREEN_WIDTH-3)/8+5, (SCREEN_WIDTH-3)*3/16, 20)];
        //        self.myLab.backgroundColor = [UIColor redColor];
        self.myLab.textAlignment = NSTextAlignmentCenter;
        self.myLab.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_myLab];
        
    }
    
    
    
    return self;
}

@end
