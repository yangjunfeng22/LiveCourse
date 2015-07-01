//
//  CommunityDAL.h
//  HelloHSK
//
//  Created by junfengyang on 14/12/8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunityNet.h"

@class CommunityModel;
/**
 *  处理帖子api相关的数据
 *    -- 构建帖子相关请求api的参数列表。
 *    -- 解析帖子请求返回的数据。
 *    -- 保存帖子相关的数据。
 *    -- 查询帖子相关的数据。
 */
@interface CommunityDAL : NSObject

#pragma mark - api所需的参数列表
/**
 *  社区帖子列表api的参数。
 *
 *  @param apKey     验证
 *  @param email     邮箱
 *  @param language  语言
 *  @param productID 产品ID
 *  @param mid       上拉加载时，显示的最后一条帖子的ID(即当前请求的帖子列表的起始ID)
 *  @param length    请求的帖子的数量
 *  @param filter    过滤：0：所有帖子， 1：我的帖子
 *  @param version   api的版本。
 *
 *  @return 参数列表
 */
+ (NSString *)getCommunityListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID mid:(NSString *)mid length:(NSInteger)length filter:(NSInteger)filter version:(NSInteger)version keyWords:(NSString *)keyWords boardID:(NSInteger)boardID;

/**
 *  帖子的api的参数
 *    -- 用于请求帖子的相关信息。帖子的详情，用户回复之类的。
 *
 *  @param apKey     验证
 *  @param email     邮箱
 *  @param language  语言
 *  @param productID 产品ID
 *  @param invID     帖子ID
 *
 *  @return 参数列表
 */
+ (NSString *)getCommunityURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID topicID:(NSString *)topicID;

/**
 *  回复帖子的api的参数
 *
 *  @param apKey      验证
 *  @param email      邮箱
 *  @param language   语言
 *  @param productID  产品ID
 *  @param invID      帖子ID
 *  @param targetID   目标ID: 目标可以为：1、主贴; 2、主贴的回复。
 *  @param targetType 目标类型: 0、回复主贴; 1、回复主贴的回复。
 *  @param content    回复的内容(纯文字).
 *  @param audio      回复的音频
 *  @param picture    回复的图片
 *  @param thumbnail  回复的缩略图
 *  @param posted     时间戳
 *
 *  @return 参数列表
 */
+ (NSString *)getCommunityReplyURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID topicID:(NSString *)topicID targetID:(NSString *)targetID targetType:(NSInteger)targetType content:(NSString *)content audio:(NSString *)audio duration:(NSInteger)duration picture:(NSString *)picture thumbnail:(NSString *)thumbnail posted:(NSInteger)posted;

/**
 *  更多回复的帖子的api的参数。
 *
 *  @param apKey     验证
 *  @param email     邮箱
 *  @param language  语言
 *  @param productID 产品ID
 *  @param invID     帖子ID
 *  @param mid       上拉加载时，显示的最后一条帖子的ID(即当前请求的帖子列表的起始ID)
 *  @param length    请求的帖子的数量
 *
 *  @return 参数列表
 */
+ (NSString *)getCommunityMoreReplyURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID topicID:(NSString *)topicID mid:(NSString *)mid length:(NSInteger)length;

/**
 *  赞/取消赞帖子的api的参数
 *
 *  @param apKey      验证
 *  @param email      邮箱
 *  @param language   语言
 *  @param productID  产品ID
 *  @param invID      帖子ID
 *  @param targetID   目标ID
 *  @param targetType 目标类型
 *  @param action     动作: 0: 赞, 1: 取消赞。
 *
 *  @return 参数列表
 */
+ (NSString *)getCommunityLaudURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID topicID:(NSString *)topicID targetID:(NSString *)targetID targetType:(NSInteger)targetType action:(NSInteger)action;

/**
 *  发帖api的参数
 *
 *  @param apKey     验证
 *  @param email     邮箱
 *  @param language  语言
 *  @param productID 产品ID
 *  @param borderID  帖子的版块的ID
 *  @param title     帖子的标题。
 *  @param content   内容。
 *  @param audio     音频
 *  @param picture   图片
 *  @param thumbnail 缩略图
 *  @param posted    时间戳
 *
 *  @return 参数列表
 */
+ (NSString *)getCommunityPostURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID borderID:(NSString *)borderID title:(NSString *)title content:(NSString *)content audio:(NSString *)audio  duration:(NSInteger)duration picture:(NSString *)picture thumbnail:(NSString *)thumbnail posted:(NSInteger)posted;

#pragma mark - 解析数据
/**
 *  解析帖子列表
 *
 *  @param resultData 返回的数据
 *  @param completion 回调
 */
+ (void)parseCommunityListByData:(id)resultData listRequestType:(CommunityListRequestType)type completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  解析帖子详情?
 *
 *  @param resultData
 *  @param completion 
 */
+ (void)parseCommunityDetailByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  解析回复帖子的数据
 *
 *  @param resultData
 *  @param completion 
 */
+ (void)parseCommunityReplyByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  解析更多回复的数据
 *
 *  @param resultData
 *  @param completion 
 */
+ (void)parseCommunityMoreReplyByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  赞相关的数据
 *
 *  @param resultData
 *  @param completion 
 */
+ (void)parseCommunityLaudByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  发帖相关的返回数据
 *
 *  @param resultData
 *  @param completion 
 */
+ (void)parseCommunityPostByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;
#pragma mark - 查询数据
/**
 *  查询帖子列表里面某条帖子
 *
 *  @param uID     用户ID
 *  @param boardID 版块ID
 *  @param topicID 帖子ID
 *
 *  @return 帖子。
 */
+ (CommunityModel *)queryCommunityWithUserID:(NSString *)uID boardID:(NSString *)boardID topicID:(NSString *)topicID;

/**
 *  查询特定版块下面的帖子列表
 *
 *  @param uID     用户ID
 *  @param boardID 版块ID
 *
 *  @return 帖子列表
 */
+ (NSArray *)queryCommunityListWithUserID:(NSString *)uID boardID:(NSString *)boardID;

/**
 *  查询用户所有的帖子列表
 *
 *  @param uID 用户ID
 *
 *  @return 帖子列表
 */
+ (NSArray *)queryCommunityListWithUserID:(NSString *)uID;

/**
 *  根据所设置的偏移量，查询特定版块下面的帖子列表
 *   -- 查询出来的数据是根据时间戳来进行排序的。
 *
 *  @param uID         用户ID
 *  @param boardID     版块ID
 *  @param fetchOffset 起始位置
 *  @param fetchLimit  指定条数
 *
 *  @return 帖子列表
 */
+ (id)fetchCommunityListWithUserID:(NSString *)uID boardID:(NSString *)boardID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit;

/**
 *  查询特定版块下面的帖子列表
 *
 *  @param uID         用户ID
 *  @param fetchOffset 起始位置
 *  @param fetchLimit  指定条数
 *
 *  @return 帖子列表
 */
+ (id)fetchCommunityListWithUserID:(NSString *)uID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit;



#pragma mark - 板块

/**
 *  板块列表
 *
 *  @param uID       <#uID description#>
 *  @param apKey     <#apKey description#>
 *  @param language  <#language description#>
 *  @param productID <#productID description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getCommunityPlateListURLParamsWithUserID:(NSString *)uID ApKey:(NSString *)apKey language:(NSString *)language productID:(NSString *)productID;



+ (void)parseCommunityPlateListByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;


/**
 *  查询板块
 */
+ (NSArray *)queryCommunityPlateListWithUserID:(NSString *)uID;


#pragma mark - 音频

/**
 *  保存音频数据
 *
 *  @param topicID   <#topicID description#>
 *  @param audioData <#audioData description#>
 */
+ (void)saveAudioDataWithAudioUrl:(NSString *)audioUrl andAudioData:(NSData*) audioData;


+ (id)queryAudioDataWithAudioUrl:(NSString *)audioUrl;


@end
