//
//  FinalGiveservice.m
//  37SQ
//
//  Created by administrator on 2016/10/17.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "FinalGiveservice.h"
#import "AFNetworking.h"
@implementation FinalGiveservice

-(void)addMessage:(NSString *)url andDic:(NSMutableDictionary *)dic andSafe:(NSString *)safe andSuccess:(void(^)(NSDictionary *dic))success;{

    
    //1.创建ADHTTPSESSIONMANGER对象
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //2.设置该对象返回类型
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    //添加类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/xml",@"application/json", @"text/xml", nil];
    
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject;
        
        success(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误(没有返回值)---%@",error);
    }];
    
    



}


@end
