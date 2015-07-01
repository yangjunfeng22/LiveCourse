//
//  AppRecommendNet.m
//  HelloHSK
//
//  Created by yang on 14-4-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "AppRecommendNet.h"
#import "HttpClient.h"
#import "AppRecommendDAL.h"

@interface AppRecommendNet ()

@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation AppRecommendNet
- (HttpClient *)requestClient
{
    if (!_requestClient) _requestClient = [[HttpClient alloc] init];
    return _requestClient;
}

- (void)requestAppRecommendCompletion:(void (^)(BOOL, id, NSError *))completion
{
    
    NSString *params = [AppRecommendDAL getCheckAppRecommendInfoURLParamsWithProductID:productID() language:currentLanguage()];
    
    NSString *url = [kLifeHostUrl stringByAppendingString:KAppRecommend];
    
    [self.requestClient postRequestFromURL:url params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        }
        
        if (jsonData) {
            [AppRecommendDAL parseAppRecommendInfoByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

-(void)dealloc
{
    _requestClient=nil;
}

- (void)cancelCheck
{
    [self.requestClient cancelAllRequest];
}

@end
