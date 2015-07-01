//
//  HSCheckPointHandle.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/13.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCheckPointHandle : NSObject

/**
 *  判断是否下载了关卡的多媒体数据
 *
 *  @param email <#email description#>
 *  @param lID   <#lID description#>
 *  @param cpID  <#cpID description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isDownloadedCheckPointMediaDataWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID;

/**
 *  关卡数据
 *
 *  @param lID <#lID description#>
 *
 *  @return <#return value description#>
 */
+ (id)checkPointDataWithLessonID:(NSString *)lID;

/**
 *  关卡已学记录的数量
 *
 *  @param uID <#uID description#>
 *  @param lID <#lID description#>
 *
 *  @return <#return value description#>
 */
+ (NSInteger)countOfCheckPointLearnedWithUserID:(NSString *)uID lessonID:(NSString *)lID;

/**
 *  关卡学习情况表
 *
 *  @param uID  <#uID description#>
 *  @param lID  <#lID description#>
 *  @param cpID <#cpID description#>
 *
 *  @return <#return value description#>
 */
+ (id)checkPointLearnedInfoWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID;

/**
 *  创建一条关卡学习情况记录
 *
 *  @param uID     <#uID description#>
 *  @param lID     <#lID description#>
 *  @param cpID    <#cpID description#>
 *  @param status  <#status description#>
 *  @param version <#version description#>
 *
 *  @return <#return value description#>
 */
+ (void)createCheckPointLearnedInfoWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID status:(NSInteger)status version:(NSString *)version completion:(void (^)(BOOL finished, id obj, NSError *error))completion;


+ (void)requestCheckPointContentDataWithView:(UIView *)view net:(id)net checkPoint:(id)checkPoint completion:(void (^)(BOOL, id, NSError *))completion;




@end
