//
//  MyNav.h
//  0815-作业
//
//  Created by administrator on 16/8/15.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBYMyNav : UIView

@property(strong,nonatomic)UIImageView *bgImg;

@property(strong,nonatomic)UIButton *leftBtn1;

@property(strong,nonatomic)UIButton *rightBtn1;

@property(strong,nonatomic)UIButton *rightBtn2;

@property(strong,nonatomic)UILabel *titleLabel;

@property(strong,nonatomic)UIButton *leftBtn2;

- (instancetype)initWithTitle:(NSString *)title andWithByImg:(NSString *)bgName andWithLetBtn1:(NSString *)leftBtn1 andWithLeftBtn2:(NSString *)leftBtn2 andWithRightBtn1:(NSString *)rightBtn1 andWithRightBtn2:(NSString *)rightBtn2;

@end
