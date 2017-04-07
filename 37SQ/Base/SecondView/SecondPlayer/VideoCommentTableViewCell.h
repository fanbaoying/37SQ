//
//  VideoCommentTableViewCell.h
//  37SQ
//
//  Created by administrator on 2016/10/13.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCommentTableViewCell : UITableViewCell
@property(strong,nonatomic)UIButton *vipheaderBtn;//评论人头像
@property(strong,nonatomic)UILabel *vipnameLab;//名字
@property(strong,nonatomic)UILabel *vipturnLab;//楼层
@property(strong,nonatomic)UILabel *viptimeLab;//时间
@property(strong,nonatomic)UIButton *vipAgreeBtn;//点赞图标
@property(strong,nonatomic)UILabel *vipAgreeLab;//点赞数
@property(strong,nonatomic)UIButton *vipDianBtn;//点点
//@property(strong,nonatomic)UIImageView *vipxxxx //预留楼中楼
@property(strong,nonatomic)UILabel *vipcontentLab;//评论正文
@end
