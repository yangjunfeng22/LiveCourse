//
//  NotificationNet.h
//  HelloHSK
//
//  Created by yang on 14-7-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSBaseNet.h"

@interface NotificationNet : HSBaseNet

- (void)sendNotificationDeviceTokenWithUserID:(NSString *)uID token:(NSString *)token completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

- (void)resetNotificationBadgeWithUserID:(NSString *)uID token:(NSString *)token completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

@end
