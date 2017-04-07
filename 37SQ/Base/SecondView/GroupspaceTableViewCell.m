//
//  GroupspaceTableViewCell.m
//  37SQ
//
//  Created by administrator on 2016/10/9.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "GroupspaceTableViewCell.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation GroupspaceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifierP{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifierP];
    if (self) {
        self.upheadImg=[[UIImageView alloc]init];
        self.upheadImg.layer.cornerRadius=20;
        self.upheadImg.clipsToBounds=YES;
//        self.upheadImg.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_upheadImg];
        
        self.upname=[[UILabel alloc]init];
        self.upname.font=[UIFont systemFontOfSize:13];
//        self.upname.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_upname];
        
        self.commentImg=[[UIImageView alloc]init];
        self.commentImg.image=[UIImage imageNamed:@"commentdl"];
        [self.contentView addSubview:_commentImg];
        
        self.commentLab=[[UILabel alloc]init];
        self.commentLab.textColor=[UIColor lightGrayColor];
        self.commentLab.font=[UIFont systemFontOfSize:13];
//        self.commentLab.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_commentLab];
        
        self.movietitLab=[[UILabel alloc]init];
        self.movietitLab.font=[UIFont systemFontOfSize:15];
//        self.movietitLab.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_movietitLab];
        
        self.moviecontent=[[UILabel alloc]init];
       self.moviecontent.textColor=[UIColor lightGrayColor];
        self.moviecontent.font=[UIFont systemFontOfSize:13];
         self.moviecontent.numberOfLines=3;
//        self.moviecontent.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_moviecontent];
        
        self.movieImg=[[UIImageView alloc]init];
//        self.movieImg.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_movieImg];
        
        self.uptimeLab=[[UILabel alloc]init];
        self.uptimeLab.textColor=[UIColor lightGrayColor];
        self.uptimeLab.font=[UIFont systemFontOfSize:13];
//        self.uptimeLab.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_uptimeLab];
        
    }
    return  self;
    //@property(strong,nonatomic)UIImageView *upheadImg;//up主头像
//    @property(strong,nonatomic)UILabel *upname;//up名字
    //@property(strong,nonatomic)UIImageView *commentImg;//评论图标
    //@property(strong,nonatomic)UILabel *commentLab;//评论数
    //@property(strong,nonatomic)UILabel *uptimeLab;//上传时间
    //@property(strong,nonatomic)UILabel *movietitLab;//标题
    //@property(strong,nonatomic)UILabel *moviecontent;//正文
    //@property(strong,nonatomic)UIImageView *movieImg;//封面


}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.commentImg.frame=CGRectMake(SCREEN_WIDHN/2.0+10, 15, 20, 20);
    self.commentLab.frame=CGRectMake(SCREEN_WIDHN/2.0+35, 15, 50, 20);
    self.uptimeLab.frame=CGRectMake(SCREEN_WIDHN-80, 15, 70, 20);
    self.upheadImg.frame=CGRectMake(10, 5, 40, 40);
    self.upname.frame=CGRectMake(60, 15, 90, 20);

    self.movietitLab.frame=CGRectMake(10, 60, SCREEN_WIDHN/2.0-20, 20);
    self.moviecontent.frame=CGRectMake(10, 80,SCREEN_WIDHN/2.0-20 ,60);
    self.movieImg.frame=CGRectMake(SCREEN_WIDHN/2.0+10, 60, SCREEN_WIDHN/2.0-20, 80);
}


@end
