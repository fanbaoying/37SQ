//
//  VideoCommentTableViewCell.m
//  37SQ
//
//  Created by administrator on 2016/10/13.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "VideoCommentTableViewCell.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation VideoCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.vipheaderBtn=[[UIButton alloc]init];
//        self.vipheaderBtn.backgroundColor=[UIColor redColor];
        self.vipheaderBtn.layer.cornerRadius=20;
        self.vipheaderBtn.clipsToBounds=YES;
        [self.contentView addSubview:_vipheaderBtn];
        
        self.vipnameLab=[[UILabel alloc]init];
        self.vipnameLab.font=[UIFont systemFontOfSize:12];

//        self.vipnameLab.backgroundColor=[UIColor yellowColor];
//        self.vipnameLab.textColor
        [self.contentView addSubview:_vipnameLab];
        
        self.vipturnLab=[[UILabel alloc]init];
//        self.vipturnLab.backgroundColor=[UIColor blueColor];
        self.vipturnLab.font=[UIFont systemFontOfSize:12];
        self.vipturnLab.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_vipturnLab];
        
        self.viptimeLab=[[UILabel alloc]init];
        self.viptimeLab.font=[UIFont systemFontOfSize:12];
        self.viptimeLab.textColor=[UIColor lightGrayColor];
//        self.viptimeLab.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_viptimeLab];
        
        self.vipcontentLab=[[UILabel alloc]init];
//        self.vipcontentLab.backgroundColor=[UIColor grayColor];
//        self.vipcontentLab.numberOfLines=0;
        [self.contentView addSubview:_vipcontentLab];
        
        //点赞图
        self.vipAgreeBtn=[[UIButton alloc]init];
        [self.vipAgreeBtn setImage:[UIImage imageNamed:@"thumbdl"] forState:0];
        [self.contentView addSubview:_vipAgreeBtn];
        //
        self.vipDianBtn=[[UIButton alloc]init];
        [self.vipDianBtn setImage:[UIImage imageNamed:@"播放器评论举报"] forState:0];
        [self.contentView addSubview:_vipDianBtn];
        
        self.vipAgreeLab=[[UILabel alloc]init];
        self.vipAgreeLab.textColor=[UIColor lightGrayColor];
//        self.vipAgreeLab.backgroundColor=[UIColor yellowColor];
        self.vipAgreeLab.font=[UIFont systemFontOfSize:12];
//        self.vipAgreeLab.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_vipAgreeLab];
        
        
        
        
    }
//    @property(strong,nonatomic)UIImageView *vipheaderImg;//评论人头像
//    @property(strong,nonatomic)UILabel *vipnameLab;//名字
//    @property(strong,nonatomic)UILabel *vipturnLab;//楼层
//    @property(strong,nonatomic)UILabel *viptimeLab;//时间
//    @property(strong,nonatomic)UIButton *vipAgreeBtn;//点赞图标
//    @property(strong,nonatomic)UILabel *vipAgreeLab;//点赞数
//    //@property(strong,nonatomic)UIImageView *vipxxxx //预留楼中楼
//    @property(strong,nonatomic)UILabel *vipcontentLab;//评论正文

    return self;

}

- (void)layoutSubviews{
[super layoutSubviews];
    self.vipheaderBtn.frame=CGRectMake(10, 10, 40, 40);
    self.vipnameLab.frame=CGRectMake(60, 15, 100, 20);
     self.vipturnLab.frame=CGRectMake(60, 35, 30, 20);
    self.viptimeLab.frame=CGRectMake(90, 35, 60, 20);
//    self.vipcontentLab.frame=CGRectMake(60, 60, SCREEN_WIDHN-100, 20);
    self.vipAgreeBtn.frame=CGRectMake(SCREEN_WIDHN-70, 15, 20, 20);
     self.vipAgreeLab.frame=CGRectMake(SCREEN_WIDHN-50, 17, 30, 20);
     self.vipDianBtn.frame=CGRectMake(SCREEN_WIDHN-30, 15, 25, 25);
}

@end
