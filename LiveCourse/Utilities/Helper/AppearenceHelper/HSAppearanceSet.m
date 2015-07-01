//
//  HSAppearanceSet.m
//  HelloHSK
//
//  Created by Lu on 14/11/7.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAppearanceSet.h"

@implementation HSAppearanceSet


+(void)setupGlobalAppearance
{
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
//    [self setStatusBarAppearance];
//
    [self setupTabBarAppearance];
    
    [self setupNavigationBarAppearance];
    
}

//+ (void)setStatusBarAppearance{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//}

//tabBar
+ (void)setupTabBarAppearance
{
    UITabBar *bar = [UITabBar appearanceWhenContainedIn:[UITabBarController class], nil];
    bar.selectedImageTintColor = kColorMain;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor : kColorMain} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor : kColorMain} forState:UIControlStateHighlighted];
}


#pragma mark - UINavigationBar

+ (void)setupNavigationBarAppearance
{
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil];
    
    if (kiOS7_OR_LATER) {
        bar.barTintColor = kColorWhite;
    }else{
        bar.tintColor = kColorWhite;
        //[bar setBackgroundImage:[UIImage imageWithColor:kColorWhite andSize:bar.size] forBarMetrics:UIBarMetricsDefault];
        //bar.shadowImage = [UIImage imageWithColor:kColorWhite andSize:CGSizeMake(bar.width, 3)];
    }

    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorMain, UITextAttributeTextColor, [UIColor colorWithWhite:1.0f alpha:0.7f], UITextAttributeTextShadowColor, [UIFont fontWithName:@"Helvetica" size:18.0f], UITextAttributeFont, nil]];
    
}




@end
