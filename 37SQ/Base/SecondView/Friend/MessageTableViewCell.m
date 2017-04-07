//
//  MessageTableViewCell.m
//  37SQ
//
//  Created by administrator on 2016/10/24.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImg=[[UIButton alloc]init];
//        self.headImg.backgroundColor=[UIColor blueColor];
        self.headImg.layer.cornerRadius=25;
        self.headImg.clipsToBounds=YES;
        [self.contentView addSubview:_headImg];
        
        self.nameBtn=[[UIButton alloc]init];
        [self.nameBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];
//        self.nameBtn.backgroundColor=[UIColor redColor];
        self.nameBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameBtn];
        
        self.whatLab=[[UILabel alloc]init];
//        self.whatLab.backgroundColor=[UIColor yellowColor];
        self.whatLab.font=[UIFont systemFontOfSize:12];
        self.whatLab.textColor=[UIColor lightGrayColor];
        self.whatLab.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_whatLab];
        
        self.groupBtn=[[UIButton alloc]init];
          [self.groupBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];
//        self.groupBtn.backgroundColor=[UIColor lightGrayColor];
          self.groupBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_groupBtn];
        
        self.RightBtn=[[UIButton alloc]init];
        [self.RightBtn setImage:[UIImage imageNamed:@"yesdl"] forState:0];
//        self.RightBtn.backgroundColor=[UIColor greenColor];
        self.RightBtn.layer.cornerRadius=20;
        self.RightBtn.clipsToBounds=YES;
        [self.contentView addSubview:_RightBtn];
        
//        self.NoBtn=[[UIButton alloc]init];
//        self.NoBtn.backgroundColor=[UIColor redColor];
//        self.NoBtn.layer.cornerRadius=20;
//        self.NoBtn.clipsToBounds=YES;
//        [self.contentView addSubview:_NoBtn];
        
        
        
    }
    //@property(strong,nonatomic)UIButton *headImg;//头像
    //@property(strong,nonatomic)UIButton *nameBtn;//名字
    //@property(strong,nonatomic)UILabel *whatLab;//做什么
    //@property(strong,nonatomic)UIButton *groupBtn;//群组名称
    //@property(strong,nonatomic)UIButton *RightBtn;//同意
    //@property(strong,nonatomic)UIButton *NoBtn;//拒绝

    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.headImg.frame=CGRectMake(10, 20, 50, 50);
    self.nameBtn.frame=CGRectMake(SCREEN_WIDHN/2-100, 15, 200, 20);
    self.whatLab.frame=CGRectMake(SCREEN_WIDHN/2-100, 35, 200, 20);
    self.groupBtn.frame=CGRectMake(SCREEN_WIDHN/2-100, 55, 200, 20);
    self.RightBtn.frame=CGRectMake(SCREEN_WIDHN-50, 30, 40, 40);
//    self.NoBtn.frame=CGRectMake(SCREEN_WIDHN-50, 10, 40, 40);
}
@end
