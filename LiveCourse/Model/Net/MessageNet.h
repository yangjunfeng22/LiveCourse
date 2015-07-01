//
//  MessageNet.h
//  HelloHSK
//
//  Created by yang on 14-7-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageNet : NSObject

#pragma mark - block
- (void)requestMessageCountWithUserID:(NSString *)uID messages:(NSString *)messages completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

- (void)requestMessageListWithUserID:(NSString *)uID messageID:(NSString *)messageID start:(NSInteger)start length:(NSInteger)length messageType:(NSString *)messageType completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

- (void)requestMessageContentWithUserID:(NSString *)uID messageID:(NSString *)messageID completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

- (void)postMessageReadedWithUserID:(NSString *)uID messageID:(NSString *)messageID completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

- (void)postMessageDeletedWithUserID:(NSString *)uID messageID:(NSString *)messageID completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

- (void)cancel;

@end
