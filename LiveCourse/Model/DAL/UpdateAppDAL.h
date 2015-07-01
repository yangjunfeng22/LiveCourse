//
//  UpdateAppDAL.h
//  HelloHSK
//
//  Created by yang on 14-4-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateAppDAL : NSObject


+ (NSString *)getCheckAppUpdateInfoURLWithProductID:(NSString *)productID version:(NSString *)version language:(NSString *)language;

+ (void)parseAppUpdateInfoByData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;;

@end
