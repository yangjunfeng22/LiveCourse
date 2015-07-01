//
//  RageIAPHelper.m
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance
{
    static dispatch_once_t once;
    static RageIAPHelper *sharedInstance;
    dispatch_once(&once, ^{
       
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                     @"hschinese.funnyGame.elves",
//                                     @"hschinese.xiyou.ChineseParadise.hanyuVOne",
//                                     @"hschinese.xiyou.ChineseParadise.liberateLearnChineseVOne",
//                                     @"hschinese.xiyou.ChineseParadise.standardChineseVOne",
//                                     @"hschinese.xiyou.ChineseParadise.yuwenBeijingVOne",
//                                     @"hschinese.xiyou.ChineseParadise.yuwenShanghaiVOne",
//                                     @"hschinese.xiyou.ChineseParadise.zhongwenVOne",
                                     nil];
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (NSArray *)productIdentifiers
{
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"hschinese.funnyGame.elves",
//                                 @"hschinese.xiyou.ChineseParadise.hanyuVOne",
//                                 @"hschinese.xiyou.ChineseParadise.liberateLearnChineseVOne",
//                                 @"hschinese.xiyou.ChineseParadise.standardChineseVOne",
//                                 @"hschinese.xiyou.ChineseParadise.yuwenBeijingVOne",
//                                 @"hschinese.xiyou.ChineseParadise.yuwenShanghaiVOne",
//                                 @"hschinese.xiyou.ChineseParadise.zhongwenVOne",
                                 nil];
    return [productIdentifiers allObjects];
}

@end
