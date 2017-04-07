//
//  AddService.m
//  37SQ
//
//  Created by administrator on 16/10/11.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "AddService.h"
#import "AFNetworking.h"

#define uurl @"http://115.159.195.113:8000/37App/index.php/community/index/getnote"
#define WEATHER_KEY @"pageNum"
@implementation AddService

- (void)searchMessage:(NSString *)note_name andWithAction:(NSString *)note_content  andWithAction:(NSString *)note_type andWithAction:(NSString *)note_time andWithAction:(NSString *)user_id andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(int))failure{
    
    //网络请求
    NSString *urlstr=uurl;
    
    NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [mutDic setObject:note_name forKey:@"note_name"];
    [mutDic setObject:note_content forKey:@"note_content"];
    [mutDic setObject:note_type forKey:@"note_type"];
    [mutDic setObject:note_time forKey:@"note_time"];
    [mutDic setObject:user_id forKey:@"user_id"];
    
    
    //1.创建ADHTTPSESSIONMANGER对象
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //2.设置该对象返回类型
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manager POST:urlstr parameters:mutDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject;
        
        success(dic);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"返回错误");
        
        
    }];
    
}
@end


