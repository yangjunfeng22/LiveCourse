//
//  HSLessonLearnViewController.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/14.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSBaseViewController.h"
@protocol HSLessonLearnViewControllerDelegate;

@interface HSLessonLearnViewController : HSBaseViewController
@property (weak, nonatomic)id<HSLessonLearnViewControllerDelegate>delegate;


@end

@protocol HSLessonLearnViewControllerDelegate <NSObject>

@optional
- (void)continueToLearnWithCheckPointType:(NSInteger)type;

- (void)continueToLearnWithCheckPoint:(id)checkPoint;

@end
