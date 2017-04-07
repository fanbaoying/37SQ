//
//  HomeService.h
//  37SQ
//
//  Created by administrator on 16/9/28.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiveService : NSObject

- (void)searchMessage:(NSString *)userid andAction:(NSString *)action andUrl:(NSString *)url andNum:(NSString *)num andSuccess:(void(^)(NSDictionary *dic))success;

@end
