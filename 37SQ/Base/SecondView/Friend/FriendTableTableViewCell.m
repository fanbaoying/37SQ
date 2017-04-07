//
//  FriendTableTableViewCell.m
//  37SQ
//
//  Created by administrator on 2016/10/19.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "FriendTableTableViewCell.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation FriendTableTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.FriendheadImg=[[UIImageView alloc]init];
        self.FriendheadImg.layer.cornerRadius=25;
        self.FriendheadImg.clipsToBounds=YES;
        [self.contentView addSubview:_FriendheadImg];
        
        self.FriendName=[[UILabel alloc]init];
//        self.FriendName.backgroundColor=[UIColor redColor];
        self.FriendName.textAlignment=NSTextAlignmentCenter;
        self.FriendName.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_FriendName];
        
        self.FriendSign=[[UILabel alloc]initWithFrame:CGRectMake(70, 40, SCREEN_WIDHN-80, 20)];
        self.FriendSign.textColor=[UIColor lightGrayColor];
        self.FriendSign.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_FriendSign];
        
        
    }
//    @property(strong,nonatomic)UIImageView *FriendheadImg;//头像
//    @property(strong,nonatomic)UILabel *FriendName;//名字
//    @property(strong,nonatomic)UILabel *FriendSign;//个性签名
    return self;

}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.FriendName.frame=CGRectMake(70, 15,SCREEN_WIDHN-80 , 20);
    
    self.FriendheadImg.frame=CGRectMake(10, 10, 50, 50);

}
@end
