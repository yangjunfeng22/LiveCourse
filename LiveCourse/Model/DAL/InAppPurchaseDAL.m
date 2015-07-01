//
//  InAppPurchaseDAL.m
//  HelloHSK
//
//  Created by Lu on 14/11/18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "InAppPurchaseDAL.h"
#import "URLUtility.h"
#import "FailOrderModel.h"
#import "KeyChainHelper.h"

@implementation InAppPurchaseDAL

+(NSString *)getInAppPurchaseParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID
{
    email = [NSString isNullString:email] ? @"":email;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"language", @"productID", nil]]];
}


+(NSString *)getInAppPurchaseOrderParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID cardID:(NSString *)cardID
{
    email = [NSString isNullString:email] ? @"":email;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, language, productID,cardID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"language", @"productID",@"cardID", nil]]];
}

+ (void)parseInAppPurchaseContentData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;
{
    if ([resultData isKindOfClass:[NSDictionary class]]) {
        
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSString *content = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        
        NSError * error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
        
        if (success)
        {
            if (completion) {
                completion(YES,content,error);
            }
        }else{
            if (completion) {
                completion(success, nil, error);
            }
        }
    }else
    {
        NSError *error = [NSError errorWithDomain:GDLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}


+(void)parseInAppPurchaseOrderContentData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]]) {
        
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSString *content = [resultData objectForKey:@"Order"];
        
        NSInteger errorCode = success ? 0 : 1;
        
        NSError * error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
        
        if (success)
        {
            if (completion) {
                completion(YES,content,error);
            }
        }else{
            if (completion) {
                completion(success, nil, error);
            }
        }
    }else
    {
        NSError *error = [NSError errorWithDomain:GDLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}


+(NSString *)getInAppPurchaseSuccessUpdateOrderParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID orderID:(NSString *)orderID payOrder:(NSString *)payOrder type:(NSString *)type Currency:(NSString *)currency Money:(NSString *)money
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, language, productID,orderID,payOrder,type,currency,money, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"language", @"productID",@"orderID",@"payOrder",@"type",@"currency",@"price", nil]]];
}

+(void)parseInAppPurchaseSuccessContentData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]]) {
        
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSString *content = [resultData objectForKey:@"Result"];
        
        NSInteger errorCode = success ? 0 : 1;
        
        NSError * error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
        
        if (success)
        {
            if (completion) {
                completion(YES,content,error);
            }
        }else{
            if (completion) {
                completion(success, nil, error);
            }
        }
    }else
    {
        NSError *error = [NSError errorWithDomain:GDLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}


+(void)saveFailOrderWithUserEmail:(NSString *)userEmail orderID:(NSString *)orderID price:(NSString *)price currency:(NSString *)currency showPrice:(NSString *)showPrice
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        FailOrderModel *failOrder = [FailOrderModel createEntityInContext:localContext];
        failOrder.email = userEmail;
        failOrder.orderID = orderID;
        failOrder.price = price;
        failOrder.currency = currency;
        failOrder.createDate = [NSDate date];
        failOrder.showPrice = showPrice;
        
    } completion:^(BOOL success, NSError *error) {
        if (success) {
            DLog(@"失败订单保存成功");
        }else{
            DLog(@"失败订单保存失败");
        }
    }];
}

+(NSArray *)searchAllFailOrder{
    //查询该用户的数据并返回
    NSString *email = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    NSArray *array = [FailOrderModel findByAttribute:@"email" withValue:email];
    return array;
}

@end
