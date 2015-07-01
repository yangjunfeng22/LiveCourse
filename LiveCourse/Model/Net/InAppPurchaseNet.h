//
//  InAppPurchaseNet.h
//  HelloHSK
//
//  Created by Lu on 14/11/18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppPurchaseNet : NSObject

//请求购买数据
-(void)requestInAppPurchaseCompletion:(void (^)(BOOL finished, id result, NSError *error))completion;

//获取订单
-(void)requestInAppPurchaseOrderWithCardID:(NSString *)cardID Completion:(void (^)(BOOL finished, id result, NSError *error))completion;

//更新订单信息
-(void)requestInAppPurchaseSuccessWithOrderID:(NSString *)orderID Currency:(NSString *)currency Money:(NSString *)money Completion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)cancelRequest;

@end
