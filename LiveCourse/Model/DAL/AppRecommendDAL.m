//
//  AppRecommendDAL.m
//  HelloHSK
//
//  Created by yang on 14-4-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "AppRecommendDAL.h"
#import "URLUtility.h"
#import "Constants.h"
#import "RecommendModel.h"

static AppRecommendDAL *instance = nil;

@implementation AppRecommendDAL

+(AppRecommendDAL *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)dealloc
{
    instance = nil;
}

+ (NSString *)getCheckAppRecommendInfoURLParamsWithProductID:(NSString *)productID language:(NSString *)language
{
    productID = [NSString isNullString:productID] ? @"":productID;
    language = [NSString isNullString:language] ? @"":language;
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:productID, language, nil] forKeys:[NSArray arrayWithObjects:@"productID", @"language", nil]]];
}

+ (id)parseAppRecommendInfoByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    id object = nil;
    //NSLog(@"resultData: %@", resultData);
    NSError * error = [NSError errorWithDomain:GDLocal(@"连接失败") code:2 userInfo:nil];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        NSString *message = [resultData objectForKey:@"Message"];
        
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        id results = [resultData objectForKey:@"Results"];
        NSInteger errorCode = success ? 0 : 1;
        //NSLog(@"errorCode: %d", errorCode);
        error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
        if (success)
        {
            [self parseAppRecommendInfo:results completion:completion];
        }else{
            if (completion) {
                completion(success, nil, error);
            }
        }
    }else
    {
        NSError *error = [NSError errorWithDomain:GDLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
    return object;
}

+ (void)parseAppRecommendInfo:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    NSMutableArray *arrApp = [[NSMutableArray alloc] initWithCapacity:2];
    if ([resultData isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dicResult in resultData)
        {
            NSString *appID          = [dicResult objectForKey:@"AppID"];
            NSString *appIcoURL      = [dicResult objectForKey:@"AppIcoURL"];
            NSString *appName        = [dicResult objectForKey:@"AppName"];
            NSString *appDescription = [dicResult objectForKey:@"AppDescription"];
            NSString *appURL         = [dicResult objectForKey:@"AppURL"];
            NSString *appUpdated     = [dicResult objectForKey:@"AppUpdated"];
            
            RecommendModel *recommendModel = [[RecommendModel alloc] init];
            recommendModel.appID = appID;
            recommendModel.appIcoURL = appIcoURL;
            recommendModel.appName = appName;
            recommendModel.appDescription = appDescription;
            recommendModel.appURL = appURL;
            recommendModel.appUpdated = appUpdated;
            
            [arrApp addObject:recommendModel];
        }
        
        if (completion) {
            completion(YES, arrApp, nil);
        }
        
    }else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

@end
