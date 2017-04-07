//
//  ActionTableViewCell.h
//  Healthy
//
//  Created by administrator on 16/10/9.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionTableViewCell : UITableViewCell

@property (strong, nonatomic)UIView *myView;

@property (strong, nonatomic)UIImageView *headImage;

@property (strong, nonatomic)UILabel *titleLabel;

@property (strong, nonatomic)UILabel *timesLabel;

@property (strong, nonatomic)UILabel *timeLabel;

@property (strong, nonatomic)UIImageView *confirmBtn;

- (void)setChecked:(BOOL)checked;

@end
