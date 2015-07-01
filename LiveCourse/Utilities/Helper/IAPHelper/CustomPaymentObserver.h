//
//  CustomPaymentObserver.h
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol CustomPaymentObserverDelegate;

@interface CustomPaymentObserver : NSObject<SKPaymentTransactionObserver>

@property (weak, nonatomic)id<CustomPaymentObserverDelegate>delegate;

@end


@protocol CustomPaymentObserverDelegate <NSObject>

@required

- (void)paymentObserver:(CustomPaymentObserver *)observer completeTransaction:(SKPaymentTransaction *)transaction;

- (void)paymentObserver:(CustomPaymentObserver *)observer failedTransaction:(SKPaymentTransaction *)transaction;

- (void)paymentObserver:(CustomPaymentObserver *)observer restoreTransaction:(SKPaymentTransaction *)transaction;

@end