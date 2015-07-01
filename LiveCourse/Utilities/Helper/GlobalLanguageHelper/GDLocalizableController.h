//
//  GDLocalizableController.h
//  LiveInShanghai
//
//  Created by junfengyang on 15/3/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----- 多语言设置
#define CHINESE @"zh-Hans"
#define ENGLISH @"en"
#define JAPAN   @"ja"
#define KOREA   @"ko"

#define GDLocal(key) [[GDLocalizableController bundle] localizedStringForKey:(key) value:@"" table:nil]

@interface GDLocalizableController : NSObject

+ (NSBundle *)bundle; // 获取当前资源文件
+ (void)initUserLanguage; //初始化语言文件
+ (NSString *)userLanguage; //获取应用当前语言
+ (void)setUserLanguage:(NSString *)language; //设置当前语言

@end
