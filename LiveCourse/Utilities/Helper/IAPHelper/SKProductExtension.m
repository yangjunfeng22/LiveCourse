//
//  SKProductExtension.m
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "SKProductExtension.h"

@implementation SKProductExtension

+ (NSString *)localizedPrice:(SKProduct *)product
{
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [priceFormatter setLocale:product.priceLocale];
    NSString *price = [priceFormatter stringFromNumber:product.price];
    return price;
}

@end
