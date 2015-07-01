//
//  CourseDAL.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "CourseDAL.h"
#import "URLUtility.h"

#import "CourseModel.h"
#import "CourseTransModel.h"

#import "LessonModel.h"
#import "LessonTransModel.h"
#import "LessonProgressModel.h"

@implementation CourseDAL

#pragma mark - api所需的参数列表
+ (NSString *)getCourseListURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":uID, @"language":language, @"productID":productID}];
}


+ (NSString *)getLessonListURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID courseID:(NSString *)cID language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    cID = [NSString isNullString:cID] ? @"":cID;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":uID, @"courseID":cID, @"language":language, @"productID":productID}];
}

+ (NSString *)getLessonProgressURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID courseID:(NSString *)cID lessonID:(NSString *)lID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    cID =[NSString isNullString:cID] ? @"":cID;
    lID = [NSString isNullString:lID] ? @"":lID;
    records =[NSString isNullString:records] ? @"":records;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":uID, @"courseID":cID, @"lessonID":lID, @"records":records, @"language":language, @"productID":productID}];
}

#pragma mark - 解析Course数据
// 课程列表
+ (void)parseCourseListByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        if (success)
        {
            [self parseCourseListDetail:results completion:completion];
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseCourseListDetail:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        
        __block NSInteger count = 0;
        NSInteger totalCount = [resultData count];
        
        [self deleteCourseListData];
        
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *cID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cid"]];
            NSString *name     = [dicRecord objectForKey:@"Name"];
            NSString *picture  = [dicRecord objectForKey:@"Picture"];
            // 服务器不需返回这个字段
            NSString *version  = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Version"]];
            NSString *parentID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"ParentID"]];
            CGFloat weight     = [[dicRecord objectForKey:@"Weight"] floatValue];
            NSInteger status   = [[dicRecord objectForKey:@"Status"] integerValue];
            NSDictionary *dicTrans = [dicRecord objectForKey:@"Translation"];
            
            NSString *language = [dicTrans objectForKey:@"Language"];
            NSString *tName = [dicTrans objectForKey:@"Name"];
            
            [self saveCourseTranslationListDataCourseID:cID language:language name:tName completion:^(BOOL finished, id obj, NSError *error) {}];
            
            [self saveCourseListDataWithCourseID:cID name:name picture:picture version:version parentID:parentID weight:weight status:status completion:^(BOOL finished, id obj, NSError *error) {
                count++;
                if (count >= totalCount){
                    if (completion) {
                        completion(YES, nil, error);
                    }
                }
            }];
        }
        
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)saveCourseListDataWithCourseID:(NSString *)cID name:(NSString *)name picture:(NSString *)picture version:(NSString *)version parentID:(NSString *)parentID weight:(CGFloat)weight status:(NSInteger)status completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@ AND parentID == %@", cID, parentID];
        CourseModel *course = (CourseModel *)[CourseModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [course.cID isEqualToString:cID] && [course.parentID isEqualToString:parentID];
        
        CourseModel *tCourse = needUpdate ? [course inContext:localContext] : [CourseModel createEntityInContext:localContext];
        cID? tCourse.cID = cID:cID;
        parentID ? tCourse.parentID = parentID:parentID;
        name ? tCourse.name = name:name;
        picture ? tCourse.picture = picture:picture;
        //version ? tCourse.version = version:version;
        tCourse.weightValue = weight;
        tCourse.statusValue = (int32_t)status;

    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}


+ (void)saveCourseTranslationListDataCourseID:(NSString *)cID language:(NSString *)language name:(NSString *)name completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@ AND language == %@", cID, language];
        CourseTransModel *courseTrans = (CourseTransModel *)[CourseTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [courseTrans.cID isEqualToString:cID] && [courseTrans.language isEqualToString:language];
        
        CourseTransModel *tCourseTrans = needUpdate ? [courseTrans inContext:localContext] : [CourseTransModel createEntityInContext:localContext];
        cID ? tCourseTrans.cID = cID:cID;
        language ? tCourseTrans.language = language:language;
        ![NSString isNullString:name] ? tCourseTrans.name = name:name;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}


+ (BOOL)deleteCourseListData
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    BOOL deleted = [CourseModel deleteAllMatchingPredicate:nil inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

+ (BOOL)deleteCourseTransData
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    BOOL deleted = [CourseTransModel deleteAllMatchingPredicate:nil inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}



#pragma mark - 解析Lesson数据
+ (void)parseLessonListByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        if (success)
        {
            [self parseLessonListDetail:results completion:completion];
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseLessonListDetail:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]] )
    {

        __block NSInteger count = 0;
        NSInteger totalCount = [resultData count];
        // 删除对应的数据
        [self deleteLessonListDataWithCourseID:HSAppDelegate.curCID];
        
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *lID          = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Lid"]];
            NSString *cID          = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cid"]];
            NSString *title        = [dicRecord objectForKey:@"Title"];
            NSString *obtain       = [dicRecord objectForKey:@"Obtain"];
            NSString *picture      = [dicRecord objectForKey:@"Picture"];
            NSString *parentID     = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"ParentID"]];
            NSString *version      = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Version"]];
            CGFloat weight         = [[dicRecord objectForKey:@"Weight"] floatValue];
            NSInteger status       = [[dicRecord objectForKey:@"Status"] integerValue];
            NSInteger type         = [[dicRecord objectForKey:@"Type"] integerValue];
            NSInteger reward       = [[dicRecord objectForKey:@"Reward"] integerValue];
            NSDictionary *dicTrans = [dicRecord objectForKey:@"Translation"];

            NSString *language     = [dicTrans objectForKey:@"Language"];
            NSString *tTitle       = [dicTrans objectForKey:@"Name"];
            NSString *tObtain      = [dicTrans objectForKey:@"Obtain"];
        
            // 保存课时翻译的数据
            [self saveLessonTranslationListDataWithLessonID:lID language:language title:tTitle obtain:tObtain completion:^(BOOL finished, id obj, NSError *error) {}];
            
            // 保存课时的数据
            [self saveLessonListDataWithCourseID:cID lessonID:lID title:title obtain:obtain picture:picture version:version parentID:parentID weight:weight status:status type:type reward:reward completion:^(BOOL finished, id obj, NSError *error) {
                count++;
                if (count >= totalCount){
                    if (completion) {
                        completion(YES, nil, error);
                    }
                }
            }];
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)saveLessonListDataWithCourseID:(NSString *)cID lessonID:(NSString *)lID title:(NSString *)title obtain:(NSString *)obtain picture:(NSString *)picture version:(NSString *)version parentID:(NSString *)parentID weight:(CGFloat)weight status:(NSInteger)status type:(NSInteger)type reward:(NSInteger)reward completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        [NSManagedObjectContext clearNonMainThreadContextsCache];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND cID == %@ AND parentID == %@", lID, cID, parentID];
        LessonModel *lesson = (LessonModel *)[LessonModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [lesson.lID isEqualToString:lID] && [lesson.cID isEqualToString:cID] && [lesson.parentID isEqualToString:parentID];
        
        LessonModel *tLesson = needUpdate ? [lesson inContext:localContext] : [LessonModel createEntityInContext:localContext];
        cID? tLesson.cID = cID:cID;
        lID ? tLesson.lID = lID:lID;
        parentID ? tLesson.parentID = parentID:parentID;
        title ? tLesson.title = title:title;
        obtain ? tLesson.obtain = obtain:obtain;
        picture ? tLesson.picture = picture:picture;
        version ? tLesson.version = version:version;
        tLesson.weightValue = weight;
        tLesson.statusValue = (int32_t)status;
        tLesson.lessonTypeValue = (int32_t)type;
        tLesson.rewardValue = (int32_t)reward;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (void)saveLessonTranslationListDataWithLessonID:(NSString *)lID language:(NSString *)language title:(NSString *)title obtain:(NSString *)obtain completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND language == %@", lID, language];
        LessonTransModel *lessonTrans = (LessonTransModel *)[LessonTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [lessonTrans.lID isEqualToString:lID] && [lessonTrans.language isEqualToString:language];
        
        LessonTransModel *tLessonTrans = needUpdate ? [lessonTrans inContext:localContext] : [LessonTransModel createEntityInContext:localContext];
        lID ? tLessonTrans.lID = lID:lID;
        language ? tLessonTrans.language = language:language;
        ![NSString isNullString:title] ? tLessonTrans.title = title:title;
        ![NSString isNullString:obtain] ? tLessonTrans.obtain = obtain:obtain;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (BOOL)deleteLessonListDataWithCourseID:(NSString *)cID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@", cID];
    BOOL deleted = [LessonModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

#pragma mark - query

+ (NSArray *)queryCourseList
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    NSArray *list = [CourseModel findAllInContext:context];
    return list;
}

+ (id)queryCourseWithCourseID:(NSString *)cID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@", cID];
    CourseModel *model = [CourseModel findFirstWithPredicate:predicate inContext:context];
    
    return model;
}

+ (id)queryCourseTranslationWithCourseID:(NSString *)cID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@ AND language == %@", cID, language];
    CourseTransModel *model = [CourseTransModel findFirstWithPredicate:predicate inContext:context];
    
    return model;
}

+ (id)queryLessonListDataWithCourseID:(NSString *)cID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *arr = [LessonModel findByAttribute:@"cID" withValue:cID inContext:context];
    return arr;
}

+ (id)queryLessonDataWithCourseID:(NSString *)cID lessonID:(NSString *)lID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@ AND lID == %@", cID, lID];
    LessonModel *model = [LessonModel findFirstWithPredicate:predicate inContext:context];

    return model;
}



#pragma mark - 解析Lesson进度的数据
+ (void)parseLessonProgressByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseLessonPorgressDetail:results completion:completion];
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseLessonPorgressDetail:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        __block NSInteger count = 0;
        NSInteger totalCount = [resultData count];
        NSString *uID = kUserID;
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *lID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Lid"]];
            CGFloat progress = [[dicRecord objectForKey:@"Progress"] floatValue];
            NSInteger status = [[dicRecord objectForKey:@"Status"] integerValue];
            NSInteger curStars = [[dicRecord objectForKey:@"Obtained"] integerValue];
            NSInteger allStars = [[dicRecord objectForKey:@"Total"] integerValue];
            
            // 保存课时进度的数据
            [self saveLessonProgressDataWithLessonID:lID userID:(NSString *)uID progress:progress status:status curStars:curStars totalStars:allStars completion:^(BOOL finished, id obj, NSError *error) {
                count++;
                if (count >= totalCount) {
                    if (completion) {
                        completion(finished, obj, error);
                    }
                }
            }];
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)saveLessonProgressDataWithLessonID:(NSString *)lID userID:(NSString *)uID progress:(CGFloat)progress status:(NSInteger)status curStars:(NSInteger)curStars totalStars:(NSInteger)totalStars completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND uID == %@", lID, uID];
        LessonProgressModel *lessonProgress = (LessonProgressModel *)[LessonProgressModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [lessonProgress.lID isEqualToString:lID] && [lessonProgress.uID isEqualToString:uID];
        
        LessonProgressModel *tLessonProgress = needUpdate ? [lessonProgress inContext:localContext] : [LessonProgressModel createEntityInContext:localContext];
        uID ? tLessonProgress.uID = uID:uID;
        lID ? tLessonProgress.lID = lID:lID;
        curStars > tLessonProgress.curStarsValue ? tLessonProgress.curStarsValue = (int32_t)curStars:0;
        totalStars > 0 ? tLessonProgress.allStarsValue = (int32_t)totalStars : 0;
        tLessonProgress.progressValue = (progress > tLessonProgress.progressValue && progress <= 1) ? progress:tLessonProgress.progressValue;
        tLessonProgress.statusValue == LessonLearnedStatusLocked ? tLessonProgress.statusValue = (int32_t)status:((tLessonProgress.statusValue == LessonLearnedStatusUnLocked && status == LessonLearnedStatusFinished && progress >= 1) ? tLessonProgress.statusValue = (int32_t)status:0);
    }completion:^(BOOL success, NSError *error) {
        if (completion)
        {
            completion(success, nil, error);
        }
    }];
}

+ (id)queryLessonProgressDataWithLessonID:(NSString *)lID userID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND uID == %@", lID, uID];
    LessonProgressModel *model = [LessonProgressModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (id)queryLessonTranslationWithLessonID:(NSString *)lID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND language == %@", lID, language];
    LessonTransModel *model = [LessonTransModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

@end
