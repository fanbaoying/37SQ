//
//  MyNav.h
//  37shequ
//
//  Created by administrator on 16/9/22.
//  Copyright © 2016年 hjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNav : UIView

@property (strong, nonatomic)UIImageView *bgImg;

@property (strong, nonatomic)UIButton *leftBtn;

@property (strong, nonatomic)UIButton *rightBtn;

@property (strong, nonatomic)UILabel *title;

- (instancetype)initWithTitle:(NSString *)title bgImg:(NSString *)bgImgName leftBtn:(NSString *)left rightBtn:(NSString *)right;
@end
