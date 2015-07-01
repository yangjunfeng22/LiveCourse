//
//  RageIAPHelper.h
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "IAPHelper.h"

@interface RageIAPHelper : IAPHelper

@property (nonatomic, readonly) NSArray *productIdentifiers;

+ (RageIAPHelper *)sharedInstance;

@end
