//
//  DLTableViewCell.m
//  37SQ
//
//  Created by administrator on 2016/9/28.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "DLTableViewCell.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
///群组列表样式
@implementation DLTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        self.grouppic=[[UIImageView alloc]init];
//        self.grouppic.backgroundColor=[UIColor redColor];
        self.grouppic.layer.cornerRadius=20;
        self.grouppic.clipsToBounds=YES;
        [self.contentView addSubview:_grouppic];
        
        //群组名
        self.groupname=[[UILabel alloc]init];
//        self.groupname.backgroundColor=[UIColor redColor];
        self.groupname.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_groupname];
        
        //动态数
        self.groupnum=[[UIButton alloc]init];
        [self.groupnum setBackgroundImage:[UIImage imageNamed:@"more"] forState:0];
        self.groupnum.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
        self.groupnum.titleLabel.font=[UIFont systemFontOfSize:12];
//        self.groupnum.layer.borderColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
        [self.groupnum setTitleColor:[UIColor whiteColor] forState:0];
//        self.groupnum.layer.borderWidth=1;
        self.groupnum.layer.cornerRadius=22;
        [self.contentView addSubview:_groupnum];
    }

    return self;


}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.grouppic.frame=CGRectMake(10, 5, 40, 40);
    
    self.groupname.frame=CGRectMake(100, 15, SCREEN_WIDHN/2, 30);
    
    self.groupnum.frame=CGRectMake(SCREEN_WIDHN-50, 8, 44, 44);

}



@end
