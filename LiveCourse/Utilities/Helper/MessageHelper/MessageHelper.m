//
//  MessageHelper.m
//  HSWordsPass
//
//  Created by yang on 14-9-1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "MessageHelper.h"
#import "UIView+Toast.h"
#import "GCDiscreetNotificationView.h"

@implementation MessageHelper

+ (void)showMessage:(NSString *)aMessage view:(UIView *)aView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:aMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

+ (void)makeToastWithMessage:(NSString *)aMessage view:(UIView *)aView
{
    //[aView makeToast:aMessage duration:2.0 position:[NSValue valueWithCGPoint:CGPointMake(aView.center.x, aView.center.y+(aView.bounds.size.height - aView.center.y)/2)]];
    
    [aView makeToast:aMessage duration:2.6 position:[NSValue valueWithCGPoint:aView.center]];
}

+ (void)showDescreetNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    [notificationView hideAnimatedAfter:2.0f];
}

+ (id)descreetNotification:(NSString *)text andView:(UIView *)view andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:YES inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    return notificationView;
}

+ (void)hideDescreetNotification:(id)notification
{
    GCDiscreetNotificationView *notifi = (GCDiscreetNotificationView *)notification;
    [notifi hide:YES];
    [notifi removeFromSuperview];
    notifi = nil;
}

@end
