//
//  AppRecommendNet.h
//  HelloHSK
//
//  Created by yang on 14-4-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppRecommendNet : NSObject


- (void)requestAppRecommendCompletion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)cancelCheck;

@end
