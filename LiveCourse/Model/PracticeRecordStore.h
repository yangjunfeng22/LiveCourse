//
//  PracticeRecordStore.h
//  LiveCourse
//
//  Created by junfengyang on 15/4/1.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PracticeRecordStore : NSObject

/**
 *  保存用户的做题记录
 *
 *  @param userID           用户
 *  @param courseCategoryID 课程种类ID
 *  @param courseID         课程ID
 *  @param lessonID         课时ID
 *  @param topicID          题ID
 *  @param rightTimes       正确次数
 *  @param wrongTimes       错误次数
 *  @param result           结果；（1：正确， 0：错误）即如果用户做对了，那么为1；做错了，那么为0；
 *  @param answer           答案：选择题保存索引即可，连词成句等题型需要保存用户回答的句子。
 */
+ (void)savePracticeRecordWithUserID:(NSString *)userID courseCategoryID:(NSString *)courseCategoryID courseID:(NSString *)courseID lessonID:(NSString *)lessonID topicID:(NSString *)topicID rightTimes:(NSInteger)rightTimes wrongTimes:(NSInteger)wrongTimes result:(NSInteger)result answer:(NSString *)answer completion:(void (^)(BOOL finished, id data, NSError *error))completion;

/**
 *  构造出用户练习的记录数据。用于同步。
 *
 *  @param userID 用户ID
 *
 *  @return
 */
+ (NSString *)practiceRecordsWithUserID:(NSString *)userID;

@end
