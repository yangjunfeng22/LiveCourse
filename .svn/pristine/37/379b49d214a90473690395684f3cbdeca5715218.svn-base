//
//  InAppPurchaseManager.m
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "CustomPaymentObserver.h"
#import "UnLockCourseManager.h"

NSString *const InAppPurchaseManagerProductsFetchedNotification = @"InAppPurchaseManagerProductsFetchedNotification";
NSString *const InAppPurchaseManagerTransactionFailedNotification = @"InAppPurchaseManagerTransactionFailedNotification";
NSString *const InAppPurchaseManagerTransactionSucceededNotification = @"InAppPurchaseManagerTransactionSucceededNotification";
NSString *const InAppPurchaseManagerTransactionRestoredNotification = @"InAppPurchaseManagerTransactionRestoredNotification";
NSString *const InAppPurchaseManagerRequestFailedNotification = @"InAppPurchaseManagerRequestFailedNotification";

@interface InAppPurchaseManager ()<CustomPaymentObserverDelegate>

@end

@implementation InAppPurchaseManager
{
    CustomPaymentObserver *theObserver;
    SKProductsRequest *productsRequest;
}

+ (InAppPurchaseManager *)sharedInstance
{
    static dispatch_once_t once;
    static InAppPurchaseManager *sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        theObserver = [[CustomPaymentObserver alloc] init];
        theObserver.delegate = self;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:theObserver];
    }
    return self;
}

- (BOOL)canMakePayments
{
    return [SKPaymentQueue canMakePayments];
}

- (void)requestProductData:(NSArray *)products
{
    NSSet *productIdentifiers = [[NSSet alloc] initWithArray:products];
    
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}


#pragma mark - SKProductsRequestDelegate
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    @autoreleasepool
    {
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:error, @"error", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchaseManagerRequestFailedNotification object:self userInfo:userInfo];
    }
    
    // showMessage : 服务器无响应
    [self showMessage:NSLocalizedString(@"Service Unavailable", @"") title:@"Message"];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //NSLog(@"加载应用内购买产品...");
    
    NSArray *skProducts = response.products;
    //NSLog(@"产品: %@", skProducts);
    
    NSMutableArray *arrProductID = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (SKProduct *skProduct in skProducts)
    {
        NSString *strProIdentifier = skProduct.productIdentifier;
        [arrProductID addObject:strProIdentifier];
    }
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:skProducts forKeys:arrProductID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchaseManagerProductsFetchedNotification object:self userInfo:userInfo];
}

#pragma mark - CustomPaymentObserver Delegate
- (void)paymentObserver:(CustomPaymentObserver *)observer completeTransaction:(SKPaymentTransaction *)transaction
{
    [self completeTransaction:transaction];
}

- (void)paymentObserver:(CustomPaymentObserver *)observer failedTransaction:(SKPaymentTransaction *)transaction
{
    [self failedTransaction:transaction];
}

- (void)paymentObserver:(CustomPaymentObserver *)observer restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self restoreTransaction:transaction];
}

#pragma mark - Pay Manager
// 购买该产品。
- (void)purchaseProduct:(SKProduct *)product
{
    if (product)
    {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        // 把付款对象添加到付款队列中
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

// 交易完成
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    //NSLog(@"交易完成......");
    //[self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    
    //[UnLockCourseManager purchase:transaction.payment.productIdentifier];
    // 把交易从付款队列中移除
    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self finishTransaction:transaction finished:YES];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:transaction, @"transaction", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchaseManagerTransactionSucceededNotification object:nil userInfo:userInfo];
}

// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    //NSLog(@"交易失败......");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // showMessage;
        //NSLog(@"交易失败: %@", transaction.error.localizedDescription);
        [self showMessage:transaction.error.localizedDescription title:@"Message"];
    }
    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self finishTransaction:transaction finished:NO];
}

// 交易恢复
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    //NSLog(@"交易恢复......");
    
    //[self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    
    [UnLockCourseManager purchase:transaction.originalTransaction.payment.productIdentifier];
    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self finishTransaction:transaction finished:YES];
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:transaction, @"transaction", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchaseManagerTransactionRestoredNotification object:self userInfo:userInfo];
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction finished:(BOOL)finished
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    @autoreleasepool
    {
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:transaction, @"transaction", nil];
        if (finished)
        {
            //[[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
        }
    }
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    
}

- (void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - ShowMessage
- (void)showMessage:(NSString *)message title:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    DLOG_CMETHOD;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:theObserver];
    theObserver = nil;
    [productsRequest cancel];
    productsRequest = nil;
}

@end
