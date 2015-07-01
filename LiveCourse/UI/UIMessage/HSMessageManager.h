//
//  HSMessageManager.h
//  HelloHSK
//
//  Created by yang on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  管理消息模块
 *    -- 将所有的消息处理整理出来，进行统一管理,在这里可以对消息界面进行调度。
 *    -- 管理消息的获取，数据的保存及读取。
 */

@interface HSMessageManager : NSObject

/**
 *  显示消息界面
 *   -- 消息界面的显示也是通过这个管理类来处理。通过传递父视图，先判断传递过来的父视图是view还是controller。
 *      如果是一个view那么直接往这个view上添加消息列表的view就可以了。
 *      如果是一个controller那么就用消息的controller来处理。
 *
 *  @param obj 父视图
 */
+ (void)showMessageInterfaceWithParent:(id)obj;

// 消息的数量
+ (void)messageUnReadCountWithCompletion:(void (^)(BOOL finished, id obj, NSError *error))completion;

// 只进行消息的本地过滤
+ (NSArray *)messageFilteredWithOffset:(NSInteger)offset limit:(NSInteger)lengtLimit messageType:(NSString *)messageType;

// 获取消息
+ (void)messageRequestWithStartMessageID:(NSString *)messageID length:(NSInteger)length messageType:(NSString *)messageType completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

+ (void)messageReadedWithMessageID:(NSString *)messageID completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

+ (void)messageDeletedWithMessageID:(NSString *)messageID completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

+ (void)clearnAndCancel;

+ (NSInteger)messageCount;
+ (void)setMessageCount:(NSInteger)msgCount;

@end
