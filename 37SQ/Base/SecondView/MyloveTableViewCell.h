//
//  MyloveTableViewCell.h
//  37SQ
//
//  Created by administrator on 2016/10/8.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyloveTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView *upheadImg;//UP主头像
@property(strong,nonatomic)UILabel *upnameLab;//UP主名字
@property(strong,nonatomic)UILabel *uptimeLab;//上传时间
@property(strong,nonatomic)UIImageView *upmovieImg;//视频封面
@property(strong,nonatomic)UILabel *upmovieLab;//视频标题
@property(strong,nonatomic)UIImageView *playImg;//播放量
@property(strong,nonatomic)UILabel *playLab;
@property(strong,nonatomic)UIImageView *commentImg;//评论量
@property(strong,nonatomic)UILabel *commentLab;

//
@property(strong,nonatomic)UILabel *line;
@end
