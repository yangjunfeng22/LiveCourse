//
//  CheckPointNet.h
//  HSWordsPass
//
//  Created by yang on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSBaseNet.h"

@protocol DownloadDelegate;

@interface CheckPointNet : HSBaseNet
@property (weak, nonatomic) id<DownloadDelegate>delegate;

#pragma mark - 数据请求
#pragma mark -
/**
 *  开始获取关卡列表数据的请求
 *
 *  @param email      传递当前用户的email，以便跟踪哪个用户下载数据了。
 *  @param completion 完成的block。
 */
- (void)requestCheckPointListDataWithUserID:(NSString *)uID lessonID:(NSString *)lID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  获取关卡的版本数据,
 *   -- 本地数据库中会保存一份，
 *   -- 如果服务器端的版本与本地的不一致，那么去更新相应的数据。
 *   -- 如果是关卡-词对应关系有更改，那么先删除所有的本地的对应关系，然后重新去加载新的对应关系。
 *
 *  @param email      email
 *  @param cpID       关卡ID
 *  @param completion 回调
 */
- (void)requestCheckPointVersionWithUserID:(NSString *)uID checkPointID:(NSString *)cpID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  获取关卡与内容之间的关系数据
 *
 *  @param params     <#params description#>
 *  @param completion <#completion description#>
 */
- (void)requestCheckPointRelationWithUserID:(NSString *)uID checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  同步关卡进度的数据
 *
 *  @param email      用户email
 *  @param records    关卡进度记录
 *  @param completion 完成的回调
 */
- (void)requestCheckPointSynchronousProgressDataWithUserID:(NSString *)uID lessonID:(NSString *)lID records:(NSString *)records completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  下载关卡所需的数据
 *
 *  @param email      用户email
 *  @param cpID       关卡ID
 *  @param completion 回调的block
 */
- (void)downloadCheckPointDataWithUserID:(NSString *)uID checkPointID:(NSString *)cpID address:(NSString *)address completion:(void (^)(BOOL finished, id obj, NSError *error))completion;
#pragma mark -

#pragma mark - 
/**
 *  获取关卡词汇的数据
 *
 *  @param params     参数列表
 *  @param completion 回调
 */
- (void)requestCheckPointWordDataWithUserID:(NSString *)uID checkPointID:(NSString *)cpID completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

/**
 *  获取关卡句子的数据
 *
 *  @param params     参数列表
 *  @param completion 回调
 */
- (void)requestCheckPointSentenceDataWithUserID:(NSString *)uID checkPointID:(NSString *)cpID completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

/**
 *  获取关卡的课文内容的数据
 *
 *  @param uID        <#uID description#>
 *  @param cpID       <#cpID description#>
 *  @param completion <#completion description#>
 */
- (void)requestCheckPointLessonTextDataWithUserID:(NSString *)uID checkPointID:(NSString *)cpID Completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  获取知识点的数据
 *
 *  @param uID        <#uID description#>
 *  @param cpID       <#cpID description#>
 *  @param completion <#completion description#>
 */
- (void)requestCheckPointKnowledgeDataWithUserID:(NSString *)uID checkPointID:(NSString *)cpID Completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  获取关卡最后测试题的数据
 *
 *  @param uID        <#uID description#>
 *  @param cpID       <#cpID description#>
 *  @param completion <#completion description#>
 */
- (void)requestCheckPointFinalTestDataWithUserID:(NSString *)uID checkPointID:(NSString *)cpID Completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  根据不同的type获取不同的数据
 *
 *  @param userID     用户ID
 *  @param cpID       关卡ID
 *  @param type       类型
 *  @param completion 回调
 */
- (void)requestCheckPointContentDataWithUserID:(NSString *)userID checkPointID:(NSString *)cpID checkPointType:(LiveCourseCheckPointType)type completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

#pragma mark - 同步记录的测验数据
- (void)synchronousPracticeRecordWithUserID:(NSString *)userID record:(NSString *)record completion:(void (^)(BOOL finished, id data, NSError *error))completion;

#pragma mark - 其他处理
/**
 *  取消该请求
 */
- (void)cancelRequest;

/**
 *  取消下载
 */
- (void)cancelDownload;

/**
 *  请求是否已取消
 *
 *  @return 是否已取消
 */
- (BOOL)isRequestCanceled;

/**
 *  下载是否已取消
 *
 *  @return 是否已取消
 */
- (BOOL)isDownloadCanceled;

@end

@protocol DownloadDelegate <NSObject>

@optional
- (void)downloadProgress:(float)progress;

@end