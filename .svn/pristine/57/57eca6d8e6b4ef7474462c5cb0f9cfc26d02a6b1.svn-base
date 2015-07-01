//
//  NotificationDAL.h
//  HelloHSK
//
//  Created by yang on 14-7-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

+ (NSString *)getNotificationDeviceTokenURLParamsWithApKey:(NSString *)apKey email:(NSString *)email token:(NSString *)token language:(NSString *)language mcKey:(NSString *)mckey productID:(NSString *)productID;
+ (NSString *)getNotificationBadgeURLParamsWithApKey:(NSString *)apKey email:(NSString *)email token:(NSString *)token language:(NSString *)language mcKey:(NSString *)mckey productID:(NSString *)productID;

+ (void)parseDeviceTokenByData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

+ (void)parseBadgeByData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

@end
