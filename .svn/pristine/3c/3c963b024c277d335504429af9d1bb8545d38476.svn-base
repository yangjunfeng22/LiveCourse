//
//  HSMessageManager.m
//  HelloHSK
//
//  Created by yang on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMessageManager.h"
#import "HSMessageViewController.h"
#import "KeyChainHelper.h"
#import "MessageNet.h"
#import "MessageDAL.h"
#import "UserDAL.h"
#import "UserModel.h"

NSInteger messageCount = 0;

@interface HSMessageManager ()

@property (nonatomic, strong) MessageNet *messageNet;

@end

@implementation HSMessageManager
{
    
}

HSMessageManager *msgManager = nil;

+ (HSMessageManager *)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        msgManager = [[self alloc] init];
    });
    return msgManager;
}

- (MessageNet *)messageNet
{
    if (!_messageNet) _messageNet = [[MessageNet alloc] init];
    return _messageNet;
}

+ (void)clearnAndCancel
{
    [msgManager.messageNet cancel];
    msgManager = nil;
}

+ (NSInteger)messageCount
{
    return messageCount;
}

+ (void)setMessageCount:(NSInteger)msgCount
{
    messageCount = msgCount;
}

+ (void)showMessageInterfaceWithParent:(id)obj
{
    if ([obj isKindOfClass:[UIView class]])
    {
        // 直接添加视图
    }
    else if ([obj isKindOfClass:[UIViewController class]])
    {
        // 以present的方式弹出来
        UIViewController *controller = (UIViewController *)obj;
        HSMessageViewController *msgViewController = [[HSMessageViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:msgViewController];
        [controller presentViewController:nav animated:YES completion:^{}];
        [msgViewController setQuitBlock:^{}];
    }
}

+ (void)messageUnReadCountWithCompletion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [[self instance].messageNet requestMessageCountWithUserID:kUserID messages:@"" completion:completion];
}

// 只进行消息的本地过滤
+ (NSArray *)messageFilteredWithOffset:(NSInteger)offset limit:(NSInteger)lengtLimit messageType:(NSString *)messageType
{
    NSArray *arrMsg = [MessageDAL fetchAllMessagesWithUserID:kUserID fetchOffset:offset fetchLimit:lengtLimit messageType:messageType];
    return arrMsg;
}

// 获取消息
+ (void)messageRequestWithStartMessageID:(NSString *)messageID length:(NSInteger)length messageType:(NSString *)messageType completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [msgManager.messageNet requestMessageListWithUserID:kUserID messageID:messageID start:0 length:length messageType:messageType completion:completion];
}

+ (void)messageReadedWithMessageID:(NSString *)messageID completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [msgManager.messageNet postMessageReadedWithUserID:kUserID messageID:messageID completion:completion];
}

+ (void)messageDeletedWithMessageID:(NSString *)messageID completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [msgManager.messageNet postMessageDeletedWithUserID:kUserID messageID:messageID completion:completion];
}

@end
