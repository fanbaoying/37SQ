//
//  FinalGiveservice.h
//  37SQ
//
//  Created by administrator on 2016/10/17.
//  Copyright © 2016年 practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinalGiveservice : NSObject


-(void)addMessage:(NSString *)url andDic:(NSDictionary *)dic andSafe:(NSString *)safe andSuccess:(void(^)(NSDictionary *dic))success;
@end
