//
//  MyloveTableViewCell.m
//  37SQ
//
//  Created by administrator on 2016/10/8.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "MyloveTableViewCell.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation MyloveTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        self.upheadImg=[[UIImageView alloc]init];
        self.upheadImg.layer.cornerRadius=20;
        self.upheadImg.clipsToBounds=YES;
//         self.upheadImg.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_upheadImg];
        //名字
        self.upnameLab=[[UILabel alloc]init];
        self.upnameLab.font=[UIFont systemFontOfSize:13 ];
//        self.upnameLab.textColor=[UIColor lightGrayColor];
//         self.upnameLab.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_upnameLab];

        //上传时间
        self.uptimeLab=[[UILabel alloc]init];
        self.uptimeLab.font=[UIFont systemFontOfSize:13 ];
        self.uptimeLab.textColor=[UIColor lightGrayColor];
//         self.uptimeLab.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_uptimeLab];

        //视频封面
        self.upmovieImg=[[UIImageView alloc]init];
//        self.upmovieImg.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_upmovieImg];

        //视频标题
        self.upmovieLab=[[UILabel alloc]init];
        self.upmovieLab.font=[UIFont systemFontOfSize:13 ];
        self.upmovieLab.numberOfLines=2;
//        self.upmovieLab.textColor=[UIColor lightGrayColor];
//         self.upmovieLab.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_upmovieLab];

        //播放量
        self.playImg=[[UIImageView alloc]init];
        self.playImg.image=[UIImage imageNamed:@"play"];
        [self.contentView addSubview:_playImg];
        
        self.playLab=[[UILabel alloc]init];
        self.playLab.font=[UIFont systemFontOfSize:13 ];
        self.playLab.textColor=[UIColor lightGrayColor];
//           self.playLab.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_playLab];

        //评论量
        self.commentImg=[[UIImageView alloc]init];
      
        self.commentImg.image=[UIImage imageNamed:@"commentdl"];
        [self.contentView addSubview:_commentImg];

        self.commentLab=[[UILabel alloc]init];
          self.commentLab.font=[UIFont systemFontOfSize:13 ];
        self.commentLab.textColor=[UIColor lightGrayColor];
//        self.commentLab.backgroundColor=[UIColor blueColor];
        [self.contentView addSubview:_commentLab];
        //线
       self.line=[[UILabel alloc]initWithFrame:CGRectMake(20, 175, SCREEN_WIDHN-40, 1)];
        self.line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_line];

    }
    return self;

}
-(void)layoutSubviews{

    [super layoutSubviews];
    self.upheadImg.frame=CGRectMake(20, 10, 40, 40);
    self.upnameLab.frame=CGRectMake(75, 10, 100, 20);
    self.uptimeLab.frame=CGRectMake(75, 30, 100, 20);
    self.upmovieImg.frame=CGRectMake(20, 60, 120/320.0*SCREEN_WIDHN, 100);
    self.upmovieLab.frame=CGRectMake(0.5*SCREEN_WIDHN, 70, 150, 50);
    self.playImg.frame=CGRectMake(0.5*SCREEN_WIDHN, 140, 20, 20);
    self.playLab.frame=CGRectMake(0.5*SCREEN_WIDHN+27, 140, 60, 20);
    self.commentImg.frame=CGRectMake(0.5*SCREEN_WIDHN+90, 140, 20, 20);
    self.commentLab.frame=CGRectMake(0.5*SCREEN_WIDHN+90+27, 140, 60, 20);
}

@end
//@property(strong,nonatomic)UIImageView *upheadImg;//UP主头像
//@property(strong,nonatomic)UILabel *upnameLab;//UP主名字
//@property(strong,nonatomic)UILabel *uptimeLab;//上传时间
//@property(strong,nonatomic)UIImageView *upmovieImg;//视频封面
//@property(strong,nonatomic)UILabel *upmovieLab;//视频标题
//@property(strong,nonatomic)UIImageView *playImg;//播放量
//@property(strong,nonatomic)UILabel *playLab;
//@property(strong,nonatomic)UIImageView *commentImg;//评论量
//@property(strong,nonatomic)UILabel *commentLab;
