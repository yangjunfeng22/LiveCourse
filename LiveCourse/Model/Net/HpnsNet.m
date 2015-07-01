//
//  HpnsNet.m
//  HSWordsPass
//
//  Created by Lu on 15/4/14.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import "HpnsNet.h"
#import "XGPush.h"
#import "HpnsDAL.h"
#import "OpenUDID.h"

#import "HttpClient.h"

#import "KeyChainHelper.h"

@interface HpnsNet ()

@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation HpnsNet
- (void)dealloc
{
    
    _requestClient = nil;
}

- (HttpClient *)requestClient
{
    if (!_requestClient) _requestClient = [[HttpClient alloc] init];
    return _requestClient;
}

- (void)hpnsDeviceRegister:(NSString *)tokenStr completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *email = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *params = [HpnsDAL getHpnsParamsWithCode:productID() language:currentLanguage() device_uuid:[OpenUDID value] device_name:device() device_token:tokenStr mail:email uid:userID version:@"2" app_id:@"2200094765"];
    
    NSString *url = [kHpnsUrl stringByAppendingString:hpnsRegister];
    
    [self.requestClient postRequestFromURL:url params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            DLog(@"jsonData: %@", jsonData);
        }
        
        if (completion){
            completion(YES, jsonData, error);
        }
    }];
}

@end
