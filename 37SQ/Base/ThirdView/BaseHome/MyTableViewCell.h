//
//  MyTableViewCell.h
//  37shequ
//
//  Created by administrator on 16/9/22.
//  Copyright © 2016年 hjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (strong, nonatomic)UIImageView *headImg;

@property (strong, nonatomic)UILabel *name;

@property (strong, nonatomic)UIImageView *commentImg;

@property (strong, nonatomic)UILabel *commentCount;

@property (strong, nonatomic)UILabel *title;

@property (strong, nonatomic)UIImageView *contentImg;

@property (strong, nonatomic)UILabel *content;

@property (strong, nonatomic)UILabel *type;

@property (strong, nonatomic)UILabel *time;

@end
