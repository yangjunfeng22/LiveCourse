//
//  NotificationNet.m
//  HelloHSK
//
//  Created by yang on 14-7-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "NotificationNet.h"
#import "NotificationDAL.h"
#import "OpenUDID.h"

@interface NotificationNet ()

@end

@implementation NotificationNet

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


- (void)sendNotificationDeviceTokenWithUserID:(NSString *)uID token:(NSString *)token completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *params = [NotificationDAL getNotificationDeviceTokenURLParamsWithApKey:[EncryptionHelper apKey] email:uID token:token language:currentLanguage() mcKey:[OpenUDID value] productID:productID()];
    
    [self.requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kNotificationToken] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"推送数据 jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [NotificationDAL parseDeviceTokenByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)resetNotificationBadgeWithUserID:(NSString *)uID token:(NSString *)token completion:(void (^)(BOOL, id, NSError *))completion
{
    
    NSString *params = [NotificationDAL getNotificationBadgeURLParamsWithApKey:[EncryptionHelper apKey] email:uID token:token language:currentLanguage() mcKey:[OpenUDID value] productID:productID()];
    
    [self.requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kNotificationBadge] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"推送数据 jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [NotificationDAL parseBadgeByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

@end
