//
//  SystemInfoHelper.m
//  HSWordsPass
//
//  Created by yang on 14-9-2.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "SystemInfoHelper.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "sys/utsname.h"

NSString *productID()
{
    NSString *prefix = @"HelloDaily";
    NSString *sufix  = kiPhone ? @"_iOS_iPhone" : @"_iOS_iPad";
    
    NSString *productID = [NSString stringWithFormat:@"%@%@", prefix, sufix];
    return productID;
}

NSString *currentLanguage()
{
//    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
//    NSString *preferredLan = [languages objectAtIndex:0];
//    
//    return preferredLan;
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLan = [GDLocalizableController userLanguage];//[languages objectAtIndex:0];
    
    return preferredLan;
    
}

NSString *timeStamp()
{
    /*
	NSDate* nowDate = [NSDate date];
	NSTimeZone* timename = [[NSTimeZone alloc] init];
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"YYMMddHHmmssSSS"];
	[outputFormatter setTimeZone:timename];
	NSString *newDateString = [outputFormatter stringFromDate:nowDate];
	return newDateString;
     */
    
    NSDate* nowDate = [NSDate date];
    NSUInteger stamp = [nowDate timeIntervalSince1970];
    NSString *strTimeStamp = [[NSString alloc] initWithFormat:@"%@", @(stamp)];
    return strTimeStamp;
}

NSString *device()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return device;
}

NSString *deviceVersion()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *version=[NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    return version;
}

#define USER_APP_PATH                 @"/User/Applications/"
BOOL isJailBreak()
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
        DLog(@"The device is jail broken!");
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
        DLog(@"applist = %@", applist);
        return YES;
    }
    DLog(@"The device is NOT jail broken!");
    return NO;
}

