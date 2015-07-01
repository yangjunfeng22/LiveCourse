//
//  IAPHelper.m
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "IAPHelper.h"
//#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation IAPHelper
{
    SKProductsRequest *_productsRequest;
    
    // 需要对completion处理器来进行跟踪，处理器里面会包含查询的IAP产品列表和这列产品是否有已经购买了的。
    RequestProductsCompletionHandler _completionHandler;
    NSSet *_productIdentifiers;
    NSMutableSet *_purchaseProductIdentifiers;
}


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    self = [super init];
    if (self)
    {
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchaseProductIdentifiers = [NSMutableSet set];
        for (NSString *productIdentifier in _productIdentifiers)
        {
            // 检查这个IAP是否已经购买了（基于查询存储在NSUserDefaults里面productidentifiers值），
            // 如果检查到已经购买了则把他放入到一个本地已购买列表里。
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased)
            {
                [_purchaseProductIdentifiers addObject:productIdentifier];
                DLog(@"Previously purchased: %@", productIdentifier);
            }
            else
            {
                DLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        // 添加self作为交易观察者对象
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHander
{
    // 首先copy一个completion block处理器复制到一个instance variable里面，
    // 这样当产品信息请求异步完成时他就能通知呼叫者了。
    _completionHandler = [completionHander copy];
    
    if ([SKPaymentQueue canMakePayments])
    {
        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
        _productsRequest.delegate = self;
        [_productsRequest start];
    }
    else
    {
        // 有设置的情况下
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"访问限制" message:@"您的设备不允许在app store内购买东西" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    DLog(@"Loaded list of products...");
    
    _productsRequest = nil;
    
    NSArray *skProducts = response.products;
    
    /*
    for (SKProduct *skProduct in skProducts)
    {
        DLog(@"Found product: %@, %@, %0.2f", skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue);
    }
    */
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    DLog(@"Failed to laod list of products.");
    
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
}

#pragma - mark buy
- (BOOL)productPurchased:(NSString *)productIdentifier
{
    return [_purchaseProductIdentifiers containsObject:productIdentifier];
}

- (void)buyPorduct:(SKProduct *)product
{
    DLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

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

// 交易完成
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    DLog(@"交易完成......");
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    // 把交易从付款队列中移除
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    DLog(@"交易失败......");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
        DLog(@"交易失败: %@", transaction.error.localizedDescription);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// 交易恢复
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    DLog(@"交易恢复......");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    [_purchaseProductIdentifiers addObject:productIdentifier];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
