//
//  CourseNet.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSBaseNet.h"

@interface CourseNet : HSBaseNet

/**
 *  课程列表
 *
 *  @param email      用户email
 *  @param completion
 */
- (void)requestCourseListDataWithUserID:(NSString *)uID Completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  课时列表
 *
 *  @param uID        用户ID
 *  @param cID        课程ID
 *  @param completion 回调
 */
- (void)requestLessonListDataWithUserID:(NSString *)uID courseID:(NSString *)cID completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

/**
 *  课时进度
 *
 *   -- lessonID为空时，courseID必填，获取整个课程下的所有课时的进度。
 *   -- 如果lessonID不为空，则只获取传入课时的进度。
 *   -- 两个参数不影响同步上去的数据，只控制需要从服务端获取的进度数据。
 *
 *  @param uID        用户ID
 *  @param cID        课程ID
 *  @param lID        课时ID
 *  @param records    课时的进度记录
 *  @param completion 回调
 */
- (void)requestLessonProgressWithUserID:(NSString *)uID courseID:(NSString *)cID lessonID:(NSString *)lID records:(NSString *)records completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

@end
