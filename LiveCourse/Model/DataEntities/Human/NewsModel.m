//
//  NewsModel.m
//  HelloHSK
//
//  Created by yang on 14-7-22.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (void)dealloc
{
    self.content = nil;
    self.link = nil;
    self.summary = nil;
    self.title = nil;
    self.userID = nil;
}

- (BOOL)isLink
{
    BOOL aLink = ![[self.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
    return aLink;
}

@end
