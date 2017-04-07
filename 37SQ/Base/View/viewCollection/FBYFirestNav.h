//
//  FBYFirestNav.h
//  37SQ
//
//  Created by administrator on 16/11/2.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBYFirestNav : UIView

@property(strong,nonatomic)UIImageView *bgImg;

@property(strong,nonatomic)UIButton *collectBtn;
@property(strong,nonatomic)UIButton *titleBtn;
@property(strong,nonatomic)UIButton *typeBtn;

- (instancetype)initWithTitle:(NSString *)titleBtn andWithByImg:(NSString *)bgName andWithCollect:(NSString *)collectBtn andWithType:(NSString *)typeBtn ;

@end
