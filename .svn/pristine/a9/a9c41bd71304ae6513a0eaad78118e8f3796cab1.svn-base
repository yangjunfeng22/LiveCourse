//
//  IAPHelper.h
//  ChineseForKids
//
//  Created by yang on 14-4-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray *products);

@interface IAPHelper : NSObject

/**
 *  初始化方法
 *    -- 用来获取一系列的 IAP product identifiers。
 *
 *  @param productIdentifiers IAP product identifiers集合
 *
 *  @return 返回对象
 */
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

/**
 *  从iTunes Connect 服务器获取产品信息。
 *
 *  @param completionHander 因为该方法是异步进行的，所以使用block参数来通知呼叫者他完成信息获取了。
 */
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHander;

/**
 *  用来开始一个购买
 *
 *  @param product 待购买的产品
 */
- (void)buyPorduct:(SKProduct *)product;

/**
 *  用来判断是否这个产品已经被购买
 *
 *  @param productIdentifier 产品标识
 *
 *  @return 判断结果
 */
- (BOOL)productPurchased:(NSString *)productIdentifier;

/**
 *  恢复购买
 */
- (void)restoreCompletedTransactions;

@end
