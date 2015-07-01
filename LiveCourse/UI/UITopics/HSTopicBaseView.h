//
//  HSTopicBaseView.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/28.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSTopicDelegate <NSObject>

@optional
- (void)topicFinishedToContinue;

@end

@interface HSTopicBaseView : UIView

@property (weak, nonatomic) id<HSTopicDelegate>delegate;

+ (id)topicViewWithName:(NSString *)name frame:(CGRect)frame;

- (void)playMedia;

@end
