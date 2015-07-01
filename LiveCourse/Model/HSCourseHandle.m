//
//  HSCourseHandle.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCourseHandle.h"
#import "CourseDAL.h"
#import "CheckPointDAL.h"
#import "LessonProgressModel.h"
#import "EncryptionHelper.h"
#import "AppDelegate.h"

@interface HSCourseHandle ()


@end

@implementation HSCourseHandle

+ (void)lessonProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSInteger count = [CheckPointDAL queryAllCheckPointProgressCountWithUserID:uID lessonID:lID statu:CheckPointLearnedStatusFinished];
    NSInteger totalCount = [CheckPointDAL checkPointCountWithLessonID:lID];
    CGFloat progress = totalCount > 0 ? (CGFloat)count/(CGFloat)totalCount:0;
    progress = progress > 1 ? 1.0:progress;
    //DLog(@"数量问题: %@; %@", @(count), @(totalCount));
    if (count > 0)
    {
        // 说明有记录。那么说明这一课已经处于解锁状态
        LessonLearnedStatus statu = (count == totalCount) && progress >= 1 ? LessonLearnedStatusFinished:LessonLearnedStatusUnLocked;
        [CourseDAL saveLessonProgressDataWithLessonID:lID userID:uID progress:progress status:statu curStars:0 totalStars:0 completion:^(BOOL finished, id obj, NSError *error) {
            if (completion) {
                completion(finished, @(progress), error);
            }
        }];
    }
    else
    {
        LessonProgressModel *lProgress = [CourseDAL queryLessonProgressDataWithLessonID:lID userID:uID];
        // 没有记录,且进度不存在, 那么该课还没有解锁。那么就不做任何操作。
        if (lProgress)
        {
            [CourseDAL saveLessonProgressDataWithLessonID:lID userID:uID progress:progress status:LessonLearnedStatusUnLocked curStars:0 totalStars:0 completion:^(BOOL finished, id obj, NSError *error) {
                if (completion) {
                    completion(finished, @(progress), error);
                }
            }];
        }
        else
        {
            if (completion) {
                completion(YES, @(0), nil);
            }
        }
    }
    
    
}


@end
