//
//  PracticeRecordStore.m
//  LiveCourse
//
//  Created by junfengyang on 15/4/1.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "PracticeRecordStore.h"
#import "PracticeRecordModel.h"
#import "CheckPointDAL.h"
#import "AppDelegate.h"

@implementation PracticeRecordStore

+ (void)savePracticeRecordWithUserID:(NSString *)userID courseCategoryID:(NSString *)courseCategoryID courseID:(NSString *)courseID lessonID:(NSString *)lessonID topicID:(NSString *)topicID rightTimes:(NSInteger)rightTimes wrongTimes:(NSInteger)wrongTimes result:(NSInteger)result answer:(NSString *)answer completion:(void (^)(BOOL finished, id data, NSError *error))completion
{
    userID = [NSString isNullString:userID] ? kUserID:userID;
    courseCategoryID = [NSString isNullString:courseCategoryID] ? kCourseCategoryID:courseCategoryID;
    courseID = [NSString isNullString:courseID] ? HSAppDelegate.curCID:courseID;
    lessonID = [NSString isNullString:lessonID] ? HSAppDelegate.curLID:lessonID;
    topicID = [NSString isNullString:topicID] ? @"":topicID;
    PracticeRecordModel *practiceRecord = [CheckPointDAL queryPracticeRecordWithUserID:userID courseCategoryID:courseCategoryID courseID:courseID lessonID:lessonID topicID:topicID];
    
    if (practiceRecord) {
        rightTimes += practiceRecord.rightTimesValue;
        wrongTimes += practiceRecord.wrongTimesValue;
    }
    
    [CheckPointDAL savePracticeRecordWithUserID:userID courseCategoryID:courseCategoryID courseID:courseID lessonID:lessonID topicID:topicID rightTimes:rightTimes wrongTimes:wrongTimes result:result answer:answer completion:completion];
}

+ (NSString *)practiceRecordsWithUserID:(NSString *)userID
{
    NSMutableString *record = [[NSMutableString alloc] init];
    
    NSArray *arrPracticeRecord = [CheckPointDAL queryPracticeRecordsWithUserID:userID];
    for (PracticeRecordModel *practiceRecord in arrPracticeRecord) {
        NSString *lString = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@,", [practiceRecord.courseCategoyID mutableCopy], [practiceRecord.courseID mutableCopy], [practiceRecord.lessonID mutableCopy], [practiceRecord.topicID mutableCopy], practiceRecord.rightTimes, practiceRecord.wrongTimes, practiceRecord.result, practiceRecord.answer, practiceRecord.timeStamp];
        [record appendString:lString];
    }
    record.length > 0 ? [record setString:[record substringToIndex:(record.length-1)]]:record;
    return record;
}

@end
