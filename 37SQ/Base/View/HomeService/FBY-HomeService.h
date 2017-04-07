//
//  FBY-HomeService.h
//  FBY--first
//
//  Created by administrator on 16/9/29.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBY_HomeService : NSObject

- (void)searchMessage:(NSString *)pageNum andWithAction:(NSString *)action andUrl:(NSString *)url andSuccess:(void(^)(NSDictionary *dic))success andFailure:(void(^)(int fail))failure;

@end
