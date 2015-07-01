//
//  UICourseLevelViewController.h
//  LiveCourse
//
//  Created by Lu on 15/1/9.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBaseTableViewController.h"

@protocol UICourseLevelDelegate <NSObject>

-(void)choseOneCourseWithCourseCID:(NSString *)courseCID courseName:(NSString *)name;

@end

@interface UICourseLevelViewController : HSBaseTableViewController

@property (nonatomic, weak) id<UICourseLevelDelegate> delegate;

@end
