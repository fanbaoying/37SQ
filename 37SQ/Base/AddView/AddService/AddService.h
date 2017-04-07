//
//  AddService.h
//  37SQ
//
//  Created by administrator on 16/10/11.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddService : NSObject

- (void)searchMessage:(NSString *)note_name andWithAction:(NSString *)note_content  andWithAction:(NSString *)note_type andWithAction:(NSString *)note_time andWithAction:(NSString *)user_id andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(int))failure;

@end
