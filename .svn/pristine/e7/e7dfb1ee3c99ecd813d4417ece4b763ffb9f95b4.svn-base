//
//  HSCourseItemCourseCell.h
//  HelloHSK
//
//  Created by Lu on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCourseItemBaseCell.h"

#define courseCellHeight 131

typedef  NS_ENUM(NSInteger, HSCourseItemStatusType)
{
    HSCourseItemStatusTypeLock = 0, //未解锁
    HSCourseItemStatusTypeNotStart = 1, //无记录 显示开始
    HSCourseItemStatusTypeHasRecord = 2,//有记录 显示进度
    HSCourseItemStatusTypeFinish = 3,//通关金杯
};

@class LessonModel;
@protocol HSCourseItemCourseCellDelegate;

@interface HSCourseItemCourseCell : HSCourseItemBaseCell
@property (nonatomic, weak) id<HSCourseItemCourseCellDelegate>delegate;

@property (nonatomic) NSInteger unitIndex;
@property (nonatomic) NSInteger lessonIndex;
@property (nonatomic, copy) NSString *lessonTitle;
@property (nonatomic) CGFloat progress;

@property (nonatomic, strong) LessonModel *lesson;

@property (nonatomic)HSCourseItemStatusType courseItemStatusType;

- (void)loadLessonStatusWithLessonID:(NSString *)lessonID;
- (void)refreshLessonStatus;

@end


@protocol HSCourseItemCourseCellDelegate <NSObject>

@optional

- (void)courseItem:(HSCourseItemCourseCell *)cell loadLesson:(NSString *)lessonID;

- (void)courseItem:(HSCourseItemCourseCell *)cell nexLesson:(id)lesson;
@end