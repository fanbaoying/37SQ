//
//  MyTableViewCell.m
//  37shequ
//
//  Created by administrator on 16/9/22.
//  Copyright © 2016年 hjp. All rights reserved.
/*
 @property (strong, nonatomic)UIImageView *headImg;
 
 @property (strong, nonatomic)UILabel *name;
 
 @property (strong, nonatomic)UIImageView *commentImg;
 
 @property (strong, nonatomic)UILabel *commentCount;
 
 @property (strong, nonatomic)UILabel *title;
 
 @property (strong, nonatomic)UIImageView *contentImg;
 
 @property (strong, nonatomic)UILabel *content;
 
 @property (strong, nonatomic)UILabel *type;
 
 @property (strong, nonatomic)UILabel *time;
 */

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //用户头像
        self.headImg = [[UIImageView alloc]init];
        self.headImg.layer.cornerRadius = 15;
        self.headImg.clipsToBounds = YES;
        [self.contentView addSubview:_headImg];
        //用户名
        self.name = [[UILabel alloc]init];
        self.name.textColor = [UIColor darkTextColor];
        self.name.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_name];
        //评论图标
        self.commentImg = [[UIImageView alloc]init];
        [self.contentView addSubview:_commentImg];
        //评论数量
        self.commentCount = [[UILabel alloc]init];
        self.commentCount.textColor = [UIColor grayColor];
        self.commentCount.font = [UIFont systemFontOfSize:12.0];
        self.commentCount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_commentCount];
        //帖子标题
        self.title = [[UILabel alloc]init];
        self.title.numberOfLines = 0;
        self.title.font = [UIFont systemFontOfSize:15.0 weight:0.5];
        self.title.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_title];
        //帖子插图
        self.contentImg = [[UIImageView alloc]init];
        self.contentImg.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_contentImg];
        //帖子正文
        self.content = [[UILabel alloc]init];
        self.content.numberOfLines = 0;
        self.content.font = [UIFont systemFontOfSize:13.0];
        self.content.textColor = [UIColor grayColor];
        [self.contentView addSubview:_content];
        //帖子类型
        self.type = [[UILabel alloc]init];
        self.type.textColor = [UIColor grayColor];
        self.type.font = [UIFont systemFontOfSize:12.0];
        self.type.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_type];
        //发帖时间
        self.time = [[UILabel alloc]init];
        self.time.textColor = [UIColor grayColor];
        self.time.font = [UIFont systemFontOfSize:12.0];
        self.time.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_time];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.headImg.frame = CGRectMake(10, 10, 30, 30);
    self.name.frame = CGRectMake(50, 15, [UIScreen mainScreen].bounds.size.width-200, 20);
    self.commentCount.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 15, 40, 20);
    self.commentImg.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, 15, 20, 20);
    self.title.frame = CGRectMake(10, 50, [UIScreen mainScreen].bounds.size.width-150, 40);
    self.contentImg.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-130, 50, 120, 120);
    self.content.frame = CGRectMake(10, 90, [UIScreen mainScreen].bounds.size.width-150, 80);
    self.type.frame = CGRectMake(10, 180, 150, 20);
    self.time.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, 180, 80, 20);
}
@end
