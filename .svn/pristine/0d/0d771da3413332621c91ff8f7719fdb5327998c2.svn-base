//
//  MessageDAL.h
//  HelloHSK
//
//  Created by yang on 14-7-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageModel;

@interface MessageDAL : NSObject
@property (nonatomic, strong, readonly)NSError *error;

+(MessageDAL *)sharedInstance;

// 消息
#pragma mark - 实例方法

- (NSString *)getMessageListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messageID:(NSString *)messageID language:(NSString *)language productID:(NSString *)productID start:(NSInteger)start length:(NSInteger)length version:(NSInteger)version messageType:(NSString *)messsageType;

- (NSString *)getMessageListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID;

- (NSString *)getMessageContentURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messageID:(NSString *)messageID language:(NSString *)language productID:(NSString *)productID;

- (NSString *)getMessageUpdateURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messages:(NSString *)messages language:(NSString *)language productID:(NSString *)productID version:(NSInteger)version;

- (id)parseMessageListData:(id)resultData;
- (id)parseMessageContentData:(id)resultData;
- (id)parseMessageReadedData:(id)resultData;

#pragma mark - 类方法
+ (NSString *)getMessageCountURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messages:(NSString *)messages language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getMessageListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messageID:(NSString *)messageID language:(NSString *)language productID:(NSString *)productID start:(NSInteger)start length:(NSInteger)length version:(NSInteger)version messageType:(NSString *)messsageType;

+ (NSString *)getMessageListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getMessageContentURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messageID:(NSString *)messageID language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getMessageUpdateURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messages:(NSString *)messages language:(NSString *)language productID:(NSString *)productID version:(NSInteger)version;

// 数据解析
+ (void)parseMessageCountData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;
+ (void)parseMessageListData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;
+ (void)parseMessageContentData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;
+ (void)parseMessageReadedData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;


+ (NSArray *)queryAllUserUnReadMessageInfoWithUserID:(NSString *)userID;
+ (NSArray *)queryAllUserMessageInfoWithUserID:(NSString *)userID;

+ (id)fetchAllMessagesWithUserID:(NSString *)uID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit;

+ (id)fetchAllMessagesWithUserID:(NSString *)uID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit messageType:(NSString *)messageType;
/**
 *  查询消息
 *
 *  @param userID    用户ID
 *  @param messageID 消息ID
 *
 *  @return 具体的某条消息
 */
+ (MessageModel *)queryUserMessageInfoWithUserID:(NSString *)userID messageID:(NSInteger)messageID;

@end
