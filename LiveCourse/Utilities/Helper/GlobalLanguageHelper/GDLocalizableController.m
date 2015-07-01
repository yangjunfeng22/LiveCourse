//
//  GDLocalizableController.m
//  LiveInShanghai
//
//  Created by junfengyang on 15/3/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "GDLocalizableController.h"

@implementation GDLocalizableController

static NSBundle *bundle = nil;
+ (NSBundle *)bundle
{
    return bundle;
}

+ (void)initUserLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    if (string.length <= 0) {
        // 获取系统当前语言版本
        NSArray *languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];
        string = current;
        [def setValue:current forKey:@"userLanguage"];
        [def synchronize];
    }
    
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+ (NSString *)userLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def objectForKey:@"userLanguage"];
    return language;
}

+ (void)setUserLanguage:(NSString *)language
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    // 1、第一步，改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    
    // 2、第二步，持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}

@end
