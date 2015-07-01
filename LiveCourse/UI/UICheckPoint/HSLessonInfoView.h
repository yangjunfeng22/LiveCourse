//
//  HSLessonInfoView.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/21.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSLessonInfoView : UIView

@property (nonatomic)CGFloat lessonProgress;
@property (nonatomic, copy)NSString *obtain;

- (void)refreshLessonInfoWithLessonData:(id)data progress:(id)progress;

@end
