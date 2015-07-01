//
//  HSContinueLearnHandle.h
//  LiveCourse
//
//  Created by junfengyang on 15/2/10.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSContinueLearnHandle : NSObject

/**
 *  是否存在学习记录,为继续学习作准备。
 *
 *  @return 是否存在
 */
+ (BOOL)hasContinueLearnRecords;

+ (void)setContinueWithCategoryID:(NSString *)ccID;
+ (void)setContinueWithCourseID:(NSString *)cID;

@end
