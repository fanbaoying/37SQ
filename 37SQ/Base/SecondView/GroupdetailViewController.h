//
//  GroupdetailViewController.h
//  37SQ
//
//  Created by administrator on 2016/9/29.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupdetailViewController : UIViewController
@property(copy,nonatomic)NSString *grname;
@property(copy,nonatomic)NSString *grsign;
@property(copy,nonatomic)NSString *grnum;
@property(copy,nonatomic)NSString *grid;
@property(strong,nonatomic)NSArray *memberArr;//群组成员数据
@property(assign,nonatomic)BOOL Vic;//是否为游客
@end
