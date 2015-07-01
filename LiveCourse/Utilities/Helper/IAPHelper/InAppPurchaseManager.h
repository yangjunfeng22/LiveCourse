//
//  InAppPurchaseManager.h
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const InAppPurchaseManagerProductsFetchedNotification;
UIKIT_EXTERN NSString *const InAppPurchaseManagerTransactionFailedNotification;
UIKIT_EXTERN NSString *const InAppPurchaseManagerTransactionSucceededNotification;
UIKIT_EXTERN NSString *const InAppPurchaseManagerTransactionRestoredNotification;
UIKIT_EXTERN NSString *const InAppPurchaseManagerRequestFailedNotification;

@interface InAppPurchaseManager : NSObject<SKProductsRequestDelegate>

+ (InAppPurchaseManager *)sharedInstance;

/**
 *  检查是否可购买: 比如家长设置了不可购买，那么就提示不可购买
 *
 *  @return 检查结果
 */
- (BOOL)canMakePayments;


/**
 *  获取产品的购买信息
 *
 *  @param products 所有bookidentifier组合而成的产品数组
 */
- (void)requestProductData:(NSArray *)products;

/**
 *  购买产品
 *
 *  @param product 单个产品
 */
- (void)purchaseProduct:(SKProduct *)product;

/**
 *  恢复购买
 */
- (void)restoreCompletedTransactions;

@end
