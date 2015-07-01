//
//  CommunityNet.h
//  HelloHSK
//
//  Created by junfengyang on 14/12/8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CommunityListRequestType) {
    CommunityListRequestTypeDataSave,
    CommunityListRequestTypeDataUnSave
};

// 0全部帖子 1我的帖子 2我回复的
typedef NS_ENUM(NSUInteger, CommunityCategoryType) {
    CommunityAll,
    CommunityMy,
    CommunityIreply
};

/**
 *  论坛：帖子api处理类
 */

@interface CommunityNet : NSObject

hsSharedInstanceDefClass(CommunityNet)

- (void)cancel;

#pragma mark - 请求数据
/**
 *  请求帖子列表
 *
 *  @param email      邮箱
 *  @param mid        起始帖子ID
 *  @param length     请求长度
 *  @param filter     过滤条件: 0:所有帖子; 1:我的帖子
 *  @param version    api版本
 *  @param completion 回调
 */
- (void)requestCommunityListWithUserID:(NSString *)uID mID:(NSString *)mid length:(NSInteger)length filter:(NSInteger)filter version:(NSInteger)version keyWords:(NSString *)keyWords boardID:(NSInteger)boardID requestType:(CommunityListRequestType)requestType completion:(void (^)(BOOL finished, id result, NSError *error))completion;
  
/**
 *  请求帖子详情
 *
 *  @param email      邮箱
 *  @param topicID    帖子ID
 *  @param completion 回调
 */
- (void)requestCommunityDetailWithUserID:(NSString *)uID topicID:(NSString *)topicID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  回复帖子
 *
 *  @param email      邮箱
 *  @param topicID    帖子ID
 *  @param targetID   目标ID（用户的ID）: 目标可以为：1、主贴; 2、主贴的回复
 *  @param targetType 目标类型: 0、回复主贴; 1、回复主贴的回复。
 *  @param content    回复的内容
 *  @param audio      音频
 *  @param picture    图片
 *  @param thumbnail  缩略图
 *  @param posted     时间戳
 *  @param completion 回调
 */
- (void)requestCommunityReplyWithUserID:(NSString *)uID topicID:(NSString *)topicID targetID:(NSString *)targetID targetType:(NSInteger)targetType content:(NSString *)content audio:(NSString *)audio duration:(NSInteger)duration picture:(NSString *)picture thumbnail:(NSString *)thumbnail posted:(NSInteger)posted completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  获取更多的回复
 *   -- 获取主帖的更多的回复。
 *
 *  @param email      邮箱
 *  @param topicID    帖子ID
 *  @param mid        查询的起始ID
 *  @param length     查询的长度
 *  @param completion 回调
 */
- (void)requestCommunityMoreRepliesWithUserID:(NSString *)uID topicID:(NSString *)topicID mID:(NSString *)mid length:(NSInteger)length completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  赞/取消赞
 *
 *  @param email      邮箱
 *  @param topicID    帖子ID
 *  @param targetID   目标ID
 *  @param targetType 目标类型:0、回复主贴; 1、回复主贴的回复
 *  @param action     动作: 0:赞; 1:取消赞
 *  @param completion 回调
 */
- (void)requestCommunityLaudWithUserID:(NSString *)uID topicID:(NSString *)topicID targetID:(NSString *)targetID targetType:(NSInteger)targetType action:(NSInteger)action completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  发帖
 *
 *  @param email      邮箱
 *  @param borderID   版块ID
 *  @param title      标题
 *  @param content    发帖的内容
 *  @param audio      音频
 *  @param duration   音频时长
 *  @param picture    图片
 *  @param thumbnail  缩略图
 *  @param posted     时间戳
 *  @param completion 回调
 */
- (void)requestCommunityPostWithUserID:(NSString *)uID borderID:(NSString *)borderID title:(NSString *)title content:(NSString *)content audio:(NSString *)audio duration:(NSInteger)duration picture:(NSString *)picture thumbnail:(NSString *)thumbnail posted:(NSInteger)posted completion:(void (^)(BOOL finished, id result, NSError *error))completion;



#pragma mark - 板块


/**
 *  版本列表
 *
 *  @param completion <#completion description#>
 */
- (void)requestCommunityPlateListCompletion:(void (^)(BOOL finished, id result, NSError *error))completion;


@end
