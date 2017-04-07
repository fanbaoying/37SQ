//
//  GroupspaceTableViewCell.h
//  37SQ
//
//  Created by administrator on 2016/10/9.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupspaceTableViewCell : UITableViewCell

@property(strong,nonatomic)UIImageView *upheadImg;//up主头像
@property(strong,nonatomic)UILabel *upname;//up名字
@property(strong,nonatomic)UIImageView *commentImg;//评论图标
@property(strong,nonatomic)UILabel *commentLab;//评论数
@property(strong,nonatomic)UILabel *uptimeLab;//上传时间
@property(strong,nonatomic)UILabel *movietitLab;//标题
@property(strong,nonatomic)UILabel *moviecontent;//正文
@property(strong,nonatomic)UIImageView *movieImg;//封面

//@property(strong,nonatomic)UILabel *up
@end
