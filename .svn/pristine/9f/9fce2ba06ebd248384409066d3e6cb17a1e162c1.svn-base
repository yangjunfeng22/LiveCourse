//
//  HSTopicBaseView.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/28.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSTopicBaseView.h"
#import "HSImageChoiceTopic.h"

#define kChoiceTopic @"ChoiceTopic"

@implementation HSTopicBaseView

+ (id)topicViewWithName:(NSString *)name frame:(CGRect)frame
{
    HSTopicBaseView *baseView = nil;
    if ([name isEqualToString:kChoiceTopic]) {
        baseView = [[HSImageChoiceTopic alloc] initWithFrame:frame];
    }
    
    return baseView;
}



@end
