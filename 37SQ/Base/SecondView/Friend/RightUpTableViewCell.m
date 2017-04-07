//
//  RightUpTableViewCell.m
//  37SQ
//
//  Created by administrator on 2016/11/1.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "RightUpTableViewCell.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation RightUpTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.LeftImg=[[UIImageView alloc]init];
//        self.LeftImg.image=[UIImage imageNamed:@"添加朋友dl"];
        [self.contentView addSubview:_LeftImg];
        self.UpLab=[[UILabel alloc]init];
        self.UpLab.font=[UIFont systemFontOfSize:14];
        //字体颜色
        self.UpLab.textColor=[UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1];
        [self.contentView addSubview:_UpLab];
        
        self.DownLab=[[UILabel alloc]init];
        self.DownLab.textColor=[UIColor lightGrayColor];
        self.DownLab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_DownLab];
        self.RightImg=[[UIImageView alloc]init];
        self.RightImg.image=[UIImage imageNamed:@"箭头灰"];
        [self.contentView addSubview:_RightImg];
    }
    return self;
//    @property(strong,nonatomic)UIImageView *LeftImg;//左边的图
//    @property(strong,nonatomic)UILabel *UpLab;//上方LAB
//    @property(strong,nonatomic)UILabel *DownLab;//下方Lab
//    @property(strong,nonatomic)UIImageView *RightImg;//右边的小箭头
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.LeftImg.frame=CGRectMake(15, 10, 36, 36);
    self.UpLab.frame=CGRectMake(65, 10, 200, 20);
    self.DownLab.frame=CGRectMake(65, 30, 200, 10);
    self.RightImg.frame=CGRectMake(SCREEN_WIDHN-30, 20, 7.5, 15);

}
@end
