//
//  CourseDAL.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseDAL : NSObject

+ (NSString *)getCourseListURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getLessonListURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID courseID:(NSString *)cID language:(NSString *)language productID:(NSString *)productID;
+ (NSString *)getLessonProgressURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID courseID:(NSString *)cID lessonID:(NSString *)lID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID;

+ (void)parseCourseListByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

+ (void)parseLessonListByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

+ (void)parseLessonProgressByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;


#pragma mark - 保存数据
+ (void)saveLessonProgressDataWithLessonID:(NSString *)lID userID:(NSString *)uID progress:(CGFloat)progress status:(NSInteger)status curStars:(NSInteger)curStars totalStars:(NSInteger)totalStars completion:(void (^)(BOOL finished, id obj, NSError *error))completion;
/**
 *  查询课程列表数据
 *
 *  @return
 */
+ (id)queryCourseList;

+ (id)queryCourseWithCourseID:(NSString *)cID;

/**
 *  获取课程的翻译数据
 *
 *  @param cID      <#cID description#>
 *  @param language <#language description#>
 *
 *  @return <#return value description#>
 */
+ (id)queryCourseTranslationWithCourseID:(NSString *)cID language:(NSString *)language;

#pragma mark - 查询Lesson数据
/**
 *  课时列表
 *
 *  @param cID <#cID description#>
 *
 *  @return <#return value description#>
 */

+ (id)queryLessonListDataWithCourseID:(NSString *)cID;

/**
 *  课时
 *
 *  @param cID <#cID description#>
 *  @param lID <#lID description#>
 *
 *  @return <#return value description#>
 */
+ (id)queryLessonDataWithCourseID:(NSString *)cID lessonID:(NSString *)lID;

/**
 *  课时进度
 *
 *  @param lID <#lID description#>
 *  @param uID <#uID description#>
 *
 *  @return <#return value description#>
 */
+ (id)queryLessonProgressDataWithLessonID:(NSString *)lID userID:(NSString *)uID;

/**
 *  查询课时的翻译数据
 *
 *  @param cID      <#cID description#>
 *  @param language <#language description#>
 *
 *  @return <#return value description#>
 */
+ (id)queryLessonTranslationWithLessonID:(NSString *)lID language:(NSString *)language;


@end
