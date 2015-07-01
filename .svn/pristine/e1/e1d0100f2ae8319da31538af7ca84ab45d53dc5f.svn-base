//
//  UpdateAppDAL.m
//  HelloHSK
//
//  Created by yang on 14-4-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UpdateAppDAL.h"
#import "URLUtility.h"


@implementation UpdateAppDAL

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}



+ (NSString *)getCheckAppUpdateInfoURLWithProductID:(NSString *)productID version:(NSString *)version language:(NSString *)language
{
    // 过滤非法字符。
    version = [NSString safeString:version];
    // 构建url
    NSString *url = [kLifeHostUrl stringByAppendingString:kUpdateApp];
    
    return [URLUtility getURL:url fromParams:@{@"name":productID, @"version":version, @"language":language}];
}

+ (void)parseAppUpdateInfoByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{

    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        NSString *message = [resultData objectForKey:@"Message"];
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        BOOL must    = [[resultData objectForKey:@"Must"] boolValue];
        
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:success userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (completion) {
            completion(success, @(must), error);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

@end
