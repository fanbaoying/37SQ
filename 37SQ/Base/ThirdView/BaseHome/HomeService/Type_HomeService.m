//
//  Type_HomeService.m
//  37SQ
//
//  Created by administrator on 16/9/29.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "Type_HomeService.h"
#import "AFNetworking.h"

#define uurl @"http://115.159.195.113:8000/37App/index.php/community/index/type"
#define WEATHER_KEY @"pageNum"

@implementation Type_HomeService

- (void)searchMessage:(NSString *)pageNum andWithAction:(NSString *)action andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(int))failure{
    
    //    ThirdViewController *
    //网络请求
    NSString *urlstr=uurl;
    
    NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [mutDic setObject:pageNum forKey:@"pageNum"];
    [mutDic setObject:action forKey:@"type"];
    
    //1.创建ADHTTPSESSIONMANGER对象
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //2.设置该对象返回类型
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manager POST:urlstr parameters:mutDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject;
        
        success(dic);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"返回错误");
        int fail = 1;
        failure(fail);
        
    }];
    
}

@end
