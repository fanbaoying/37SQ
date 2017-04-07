//
//  VideoCommentViewController.h
//  37SQ
//
//  Created by administrator on 2016/10/13.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCommentViewController : UIViewController
@property(copy,nonatomic)NSString  *VVideoId;
@property(strong,nonatomic)NSMutableArray *thumbArr;//点赞数组


//- (void)gethomemessage;//发起网络请求


@end
