//
//  MessageTableViewCell.h
//  37SQ
//
//  Created by administrator on 2016/10/24.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property(strong,nonatomic)UIButton *headImg;//头像
@property(strong,nonatomic)UIButton *nameBtn;//名字
@property(strong,nonatomic)UILabel *whatLab;//做什么
@property(strong,nonatomic)UIButton *groupBtn;//群组名称
@property(strong,nonatomic)UIButton *RightBtn;//同意
//@property(strong,nonatomic)UIButton *NoBtn;//拒绝
@end
