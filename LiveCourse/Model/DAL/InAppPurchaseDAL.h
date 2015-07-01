//
//  InAppPurchaseDAL.h
//  HelloHSK
//
//  Created by Lu on 14/11/18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppPurchaseDAL : NSObject

+ (NSString *)getInAppPurchaseParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getInAppPurchaseOrderParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID cardID:(NSString *)cardID;


+ (void)parseInAppPurchaseContentData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

+ (void)parseInAppPurchaseOrderContentData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

+ (NSString *)getInAppPurchaseSuccessUpdateOrderParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID orderID:(NSString *)orderID payOrder:(NSString *)payOrder type:(NSString *)type Currency:(NSString *)currency Money:(NSString *)money;


+ (void)parseInAppPurchaseSuccessContentData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

//保存更新失败的订单
+(void)saveFailOrderWithUserEmail:(NSString *)userEmail orderID:(NSString *)orderID price:(NSString *)price currency:(NSString *)currency showPrice:(NSString *)showPrice;

+(NSArray *)searchAllFailOrder;

@end
