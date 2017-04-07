//
//  GroupLIst_Service.h
//  37SQ
//
//  Created by administrator on 2016/10/29.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupLIst_Service : NSObject

- (void)searchMessage:(NSString *)pageNum andWithAction:(NSString *)action andSuccess:(void(^)(NSDictionary *dic))success andFailure:(void(^)(int fail))failure;
@end
