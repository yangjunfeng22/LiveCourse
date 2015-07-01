//
//  UICourseItemKnowledgeSentenceView.h
//  LiveCourse
//
//  Created by Lu on 15/1/14.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICourseItemKnowledgeSentenceDelegate <NSObject>

-(void)rotationToWordView;

@end

@interface UICourseItemKnowledgeSentenceView : UIView


-(void)loadDataWithKeyWord:(NSString *)keyWord KID:(NSString *)knowledgeID;

@property (nonatomic, weak) id <UICourseItemKnowledgeSentenceDelegate>delegate;

@end
