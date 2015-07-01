//
//  EncryptionHelper.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/21.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionHelper : NSObject

+ (NSString *)apKey;

+ (NSString *)md5APKeyWithString:(NSString *)aString;

@end
