//
//  NotificationDAL.m
//  HelloHSK
//
//  Created by yang on 14-7-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "NotificationDAL.h"
#import "URLUtility.h"

@implementation NotificationDAL

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

+ (NSString *)getNotificationDeviceTokenURLParamsWithApKey:(NSString *)apKey email:(NSString *)email token:(NSString *)token language:(NSString *)language mcKey:(NSString *)mckey productID:(NSString *)productID
{
    email = [NSString isNullString:email] ? @"":email;
    token =[NSString isNullString:token] ? @"":token;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, token, language, mckey, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"deviceToken", @"language", @"mckey", @"productID", nil]]];
}

+ (NSString *)getNotificationBadgeURLParamsWithApKey:(NSString *)apKey email:(NSString *)email token:(NSString *)token language:(NSString *)language mcKey:(NSString *)mckey productID:(NSString *)productID
{
    email = [NSString isNullString:email] ? @"":email;
    token =[NSString isNullString:token] ? @"":token;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, token, language, mckey, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"deviceToken", @"language", @"mckey", @"productID", nil]]];
}

+ (void)parseDeviceTokenByData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{

    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Result"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (completion) {
            completion(success, results, error);
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

+ (void)parseBadgeByData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Result"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (completion) {
            completion(success, results, error);
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
