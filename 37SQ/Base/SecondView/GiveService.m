//
//  HomeService.m
//  37SQ
//
//  Created by administrator on 16/9/28.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "GiveService.h"
#import "AFNetworking.h"

@implementation GiveService
//网络请求类
- (void)searchMessage:(NSString *)userid andAction:(NSString *)action andUrl:(NSString *)url andNum:(NSString *)num andSuccess:(void (^)(NSDictionary *))success{
    NSMutableDictionary *mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
    if ([action isEqualToString:@"group"]) {
        
    
        [mutdic setObject:userid forKey:@"userid"];}
   
    if ([action isEqualToString:@"groupmember"]) {
        
        
        [mutdic setObject:userid forKey:@"groupid"];}
    
    
    if ([action isEqualToString:@"mylove"]) {
        [mutdic setObject:userid forKey:@"userid"];
        [mutdic setObject:@"1" forKey:@"page"];
    }
    
    if ([action isEqualToString:@"Videodetail"]) {
        
        
        [mutdic setObject:userid forKey:@"videoid"];
    }
    if ([action isEqualToString:@"videocomment"]) {
        
//        NSLog(@"--=-=-=-=-%@",userid);
        [mutdic setObject:userid forKey:@"videoid"];
    }
       //1.创建ADHTTPSESSIONMANGER对象
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //2.设置该对象返回类型
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject;
        
        success(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"返回错误(没有返回值)");
    }];

}

@end
