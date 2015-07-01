//
//  HSLessonLearnManagerView.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/15.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSLessonPageView.h"


@protocol HSLessonLearnManagerViewDelegate;

@interface HSLessonLearnManagerView : UIView

@property (weak, nonatomic) id<HSLessonLearnManagerViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame lessonData:(id)data type:(LiveCourseCheckPointType)type;

- (void)resetLessonData:(id)data type:(LiveCourseCheckPointType)type;

@end

@protocol HSLessonLearnManagerViewDelegate <NSObject>

@optional

/**
 *  继续学习事件.
 *   -- 当一个小测试做完，点击继续，则将这个继续事件传递出来。然后可以继续给这个管理者添加新的数据来继续这个过程。
 */
- (void)continueLearn;

@end
