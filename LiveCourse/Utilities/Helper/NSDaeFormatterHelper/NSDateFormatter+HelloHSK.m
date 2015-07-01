//
//  NSDateFormatter+HelloHSK.m
//  HelloHSK
//
//  Created by junfengyang on 14/12/10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "NSDateFormatter+HelloHSK.h"

static NSDateFormatter *stHelloHSKDateFormatter = nil;

@implementation NSDateFormatter (HelloHSK)

+ (NSDateFormatter *)helloHSKDateFormatter
{
    if(stHelloHSKDateFormatter == nil)
    {
        stHelloHSKDateFormatter = [[NSDateFormatter alloc] init];
        [stHelloHSKDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [stHelloHSKDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [stHelloHSKDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [stHelloHSKDateFormatter setLocale:[NSLocale currentLocale]];
    }
    
    return stHelloHSKDateFormatter;
}

@end
