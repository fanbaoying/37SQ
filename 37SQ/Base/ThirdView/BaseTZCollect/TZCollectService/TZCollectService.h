//
//  TZCollectService.h
//  37SQ
//
//  Created by administrator on 16/10/9.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZCollectService : NSObject

- (void)searchMessage:(NSString *)pageNum andWithAction:(NSString *)action andSuccess:(void(^)(NSDictionary *dic))success andFailure:(void(^)(int fail))failure;

@end
