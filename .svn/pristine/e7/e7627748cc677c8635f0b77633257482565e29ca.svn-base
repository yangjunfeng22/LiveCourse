//
//  CustomPaymentObserver.m
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CustomPaymentObserver.h"
#import "InAppPurchaseManager.h"

@implementation CustomPaymentObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased: // 交易完成
            {
                [self completeTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:  // 交易失败
            {
                [self failedTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored: // 交易恢复
            {
                [self restoreTransaction:transaction];
                break;
            }
                
            default:
                break;
        }
    }
}



- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    //NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    //NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    //NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark -
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paymentObserver:completeTransaction:)])
    {
        [self.delegate paymentObserver:self completeTransaction:transaction];
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paymentObserver:failedTransaction:)])
    {
        [self.delegate paymentObserver:self failedTransaction:transaction];
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paymentObserver:restoreTransaction:)])
    {
        [self.delegate paymentObserver:self restoreTransaction:transaction];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    
}

@end
