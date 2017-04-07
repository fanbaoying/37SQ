//
//  ReportViewController.h
//  37SQ
//
//  Created by administrator on 2016/11/4.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController
@property(strong,nonatomic)NSString *Whatid;//要举报的ID
@property(strong,nonatomic)NSString *Whattype;//要举报的资源类型 0表示影片.1表示帖子.表示评论
@end
