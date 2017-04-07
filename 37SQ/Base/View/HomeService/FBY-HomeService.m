//
//  FBY-HomeService.m
//  FBY--first
//
//  Created by administrator on 16/9/29.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "FBY-HomeService.h"
#import "AFNetworking.h"
#import "ThirdViewController.h"

//#define uurl @"http://115.159.195.113:8000/37App/index.php/home/index/index"
//#define WEATHER_KEY @"pageNum"

@implementation FBY_HomeService

- (void)searchMessage:(NSString *)pageNum andWithAction:(NSString *)action andUrl:(NSString *)url andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(int))failure{
    
    //    ThirdViewController *
    //网络请求
    NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithCapacity:0];

    if ([action isEqualToString:@"user"]) {
        
        [mutDic setObject:pageNum forKey:@"userid"];

    }else if ([action isEqualToString:@"phonenum"]){
    
        [mutDic setObject:pageNum forKey:@"userphonenum"];
    }
    //保存
    else if ([action isEqualToString:@"videoURL"]){
    
        [mutDic setObject:pageNum forKey:@"videoid"];
        
    }
    //广告
    else if ([action isEqualToString:@"type"]){
    
        [mutDic setObject:pageNum forKey:@"type"];
        
    }
    //刷新
    else if ([action isEqualToString:@"num"]){
    
        [mutDic setObject:pageNum forKey:@"page"];
        
    }
    //好友ID
    else if ([action isEqualToString:@"otherid"]){
    
        [mutDic setObject:pageNum forKey:@"userid"];
        
    }
    
    NSString *urlstr=url;
    

    
    
    //1.创建ADHTTPSESSIONMANGER对象
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //2.设置该对象返回类型
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    [manager POST:urlstr parameters:mutDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject;
        
        success(dic);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----返回错误");

    }];
    
}


@end
