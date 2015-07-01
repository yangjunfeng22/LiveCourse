//
//  UnLockCourseManager.h
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnLockCourseManager : NSObject

+ (void)purchase:(NSString *)productIdentifier;

+ (void)hasPurchased:(NSString *)productIdentifier;

@end
