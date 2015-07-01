//
//  UICourseItemKnowledgeVC.h
//  LiveCourse
//
//  Created by Lu on 15/1/13.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICourseItemKnowledgeVCDelegate;

@interface UICourseItemKnowledgeVC : UIViewController

@property (weak, nonatomic)id<UICourseItemKnowledgeVCDelegate>delegate;

@end


@protocol UICourseItemKnowledgeVCDelegate <NSObject>

@optional
- (void)continueToLearnWithCheckPointType:(NSInteger)type;
- (void)continueToLearnWithCheckPoint:(id)checkPoint;

@end