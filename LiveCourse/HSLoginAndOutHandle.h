//
//  HSLoginAndOutHandle.h
//  LiveCourse
//
//  Created by Lu on 15/1/8.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSLoginViewController.h"

@interface HSLoginAndOutHandle : NSObject

hsSharedInstanceDefClass(HSLoginAndOutHandle)

@property (strong, nonatomic) HSLoginViewController *loginViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

/**
 *  处理是否是第一次打开程序/是更新后的第一次打开程序
 *
 *  @param isReset 是否是重启应用
 */
- (void)dealFirstLaunch:(BOOL)isReset;


//登陆成功
- (void)loginFinish;

//编辑是否登陆状态
- (void)setLoginStatus:(BOOL)loginStatus;

//退出到登陆页面
- (void)logOut;

//是否登陆
- (BOOL)islogin;


@end
