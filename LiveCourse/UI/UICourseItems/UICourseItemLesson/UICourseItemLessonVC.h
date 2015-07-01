//
//  UICourseItemLessonVC.h
//  LiveCourse
//
//  Created by Lu on 15/1/12.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSBaseViewController.h"

@protocol UICourseItemLessonVCDelegate;

@interface UICourseItemLessonVC : HSBaseViewController
@property (weak, nonatomic)id<UICourseItemLessonVCDelegate>delegate;

@end

@protocol UICourseItemLessonVCDelegate <NSObject>

@optional
- (void)continueToLearnWithCheckPointType:(NSInteger)type;
- (void)continueToLearnWithCheckPoint:(id)checkPoint;

@end
