//
//  InAppPurchaseNet.m
//  HelloHSK
//
//  Created by Lu on 14/11/18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "InAppPurchaseNet.h"
#import "HttpClient.h"

#import "MD5Helper.h"

#import "InAppPurchaseDAL.h"
#import "KeyChainHelper.h"


@interface InAppPurchaseNet()

@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation InAppPurchaseNet

- (HttpClient *)requestClient
{
    if (!_requestClient) _requestClient = [[HttpClient alloc] init];
    return _requestClient;
}


-(void)requestInAppPurchaseCompletion:(void (^)(BOOL finished, id result, NSError *error))completion{
    
    NSString *email = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    
    
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [[MD5Helper md5Digest:md5] uppercaseString];
    
    NSString *params = [InAppPurchaseDAL getInAppPurchaseParamsWithApKey:apKey email:email language:currentLanguage() productID:productID()];
    
    [self.requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kInAppPurchaseNet] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        }
        
        if (jsonData) {
            [InAppPurchaseDAL parseInAppPurchaseContentData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

-(void)requestInAppPurchaseOrderWithCardID:(NSString *)cardID Completion:(void (^)(BOOL finished, id result, NSError *error))completion;{
    
    NSString *email = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@%@", email, productID(),cardID, kMD5_KEY];
    NSString *apKey = [[MD5Helper md5Digest:md5] uppercaseString];
    
    NSString *params = [InAppPurchaseDAL getInAppPurchaseOrderParamsWithApKey:apKey email:email language:currentLanguage() productID:productID() cardID:cardID];
    NSString *url = [kHostUrl stringByAppendingString:kInAppPurchaseOrderNet];
    
    [self.requestClient postRequestFromURL:url params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        }
        
        if (jsonData) {
            [InAppPurchaseDAL parseInAppPurchaseOrderContentData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

-(void)requestInAppPurchaseSuccessWithOrderID:(NSString *)orderID Currency:(NSString *)currency Money:(NSString *)money Completion:(void (^)(BOOL finished, id result, NSError *error))completion
{
    NSString *email = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@", email, productID(),orderID,currency,money, kMD5_KEY];
    NSString *apKey = [[MD5Helper md5Digest:md5] uppercaseString];
    
    NSString *params = [InAppPurchaseDAL getInAppPurchaseSuccessUpdateOrderParamsWithApKey:apKey email:email language:currentLanguage() productID:productID() orderID:orderID payOrder:@"" type:@"AppStore" Currency:currency Money:money];
    
    NSString *url = [kHostUrl stringByAppendingString:kInAppPurchaseSuccessNet];
    
    [self.requestClient postRequestFromURL:url params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        }
        
        if (jsonData) {
            [InAppPurchaseDAL parseInAppPurchaseSuccessContentData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

-(void)cancelRequest{
    [self.requestClient cancelAllRequest];
}
@end
