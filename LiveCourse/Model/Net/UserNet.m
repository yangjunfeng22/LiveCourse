//
//  UserNet.m
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserNet.h"
#import "HttpClient.h"
#import "UserDAL.h"

#import "OpenUDID.h"

#import "MD5Helper.h"
#import "KeyChainHelper.h"

@interface UserNet ()
{
    
}

@end

@implementation UserNet

#pragma mark - block
- (void)startLoginWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    
    NSString *url = [UserDAL getLoginURLByApKey:[EncryptionHelper md5APKeyWithString:md5] email:email password:password language:currentLanguage() productID:productID()];
    
    [self.requestClient postRequestFromURL:url identifier:kLoginMethod completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}


- (void)tempUserLoginWithCompletion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", productID(),[OpenUDID value], kMD5_KEY];
    
    NSString *url = [UserDAL getTempUserLoginURLWithApKey:[EncryptionHelper md5APKeyWithString:md5] Language:currentLanguage() productID:productID() mcKey:[OpenUDID value]];
    
    [self.requestClient postRequestFromURL:url identifier:kTempUserLoginMethod completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
        
    }];
}

- (void)startRegistWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    
    NSString *url = [UserDAL getRegistURLWithApKey:[EncryptionHelper md5APKeyWithString:md5] email:email password:password language:currentLanguage() productID:productID() mcKey:[OpenUDID value]];
    
    [self.requestClient postRequestFromURL:url identifier:kRegistMethod completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"注册: jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)requestRegistTempContentWithType:(NSString *)type completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *url = [UserDAL getRegistTextContentURLWithApKey:@"" type:type language:currentLanguage() productID:productID()];
    
    [self.requestClient postRequestFromURL:url identifier:kTextContent completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"注册的简单文本: jsonData: %@", jsonData);
        }
        if (jsonData)
        {
            [UserDAL parseTextContentByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}


- (void)startThirdLoginWithUserID:(NSString *)userID Email:(NSString *)email name:(NSString *)name token:(NSString *)token img:(NSString *)imgUrl identifier:(NSString *)identifier completion:(void (^)(BOOL, id, NSError *))completion
{
    if (!userID)
    {
        NSError *error = [NSError errorWithDomain:nil code:1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
    else
    {
        NSString *url = [UserDAL getThirdLoginUrlWithUserID:userID userEmail:email name:name token:token img:imgUrl language:currentLanguage() identifier:identifier productID:productID()];

        [self.requestClient postRequestFromURL:url identifier:kThirdLoginMethod completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
            
            //DLog(@"error: %@", error.localizedDescription);
            id jsonData = nil;
            if (responseData && error.code == 0) {
                jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                //DLog(@"jsonData: %@", jsonData);
            }
            
            if (jsonData) {
                [UserDAL parseUserByData:jsonData completion:completion];
            }
            else
            {
                if (completion){
                    completion(NO, nil, error);
                }
            }
        }];
    }
}

//第三方创建个人档案
-(void)startThirdRegistWithUserID:(NSString *)userID name:(NSString *)name identifier:(NSString *)identifier completion:(void (^)(BOOL, id, NSError *))completion
{
    if (!userID)
    {
        NSError *error = [NSError errorWithDomain:nil code:1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
    else
    {
        NSString *oldemail = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
        NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", productID(),oldemail, kMD5_KEY];
        
        NSString *url = [UserDAL getThirdRegistUrlWithApKey:[EncryptionHelper md5APKeyWithString:md5] userEmail:oldemail language:currentLanguage() productID:productID() UserID:userID name:name identifier:identifier];
        
        [self.requestClient postRequestFromURL:url identifier:kThirdRegistMethod completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
            
            //DLog(@"error: %@", error.localizedDescription);
            id jsonData = nil;
            if (responseData && error.code == 0) {
                jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                //DLog(@"jsonData: %@", jsonData);
            }
            
            if (jsonData) {
                [UserDAL parseUserByData:jsonData completion:completion];
            }
            else
            {
                if (completion){
                    completion(NO, nil, error);
                }
            }
        }];
    }
}

//临时用户注册
- (void)startRegistTempUserWithUserEmail:(NSString *)newEmail password:(NSString *)password completion:(void (^)(BOOL, id, NSError *))completion
{
    
    NSString *oldemail = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@", productID(),[OpenUDID value],oldemail,newEmail,password, kMD5_KEY];
    
    NSString *url =[UserDAL getTempUserRegistURLWithApKey:[EncryptionHelper md5APKeyWithString:md5] eemail:newEmail nemail:oldemail password:password Language:currentLanguage() productID:productID() mcKey:[OpenUDID value]];
    
    
    [self.requestClient postRequestFromURL:url identifier:kTempUserRegistMethod completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)startFindBackUserPasswordWithEmail:(NSString *)email completion:(void (^)(BOOL, id, NSError *))completion
{
    email = [NSString isNullString:email] ?  @"":email;
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    
    NSString *url = [UserDAL getPasswordBackURLWithApKey:[EncryptionHelper md5APKeyWithString:md5] email:email language:currentLanguage() productID:productID()];
    
    [self.requestClient postRequestFromURL:url identifier:kFindPassword completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserFindPasswordData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)requestUserInfoWithUserID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", uID, productID(), kMD5_KEY];

    NSString *url = [UserDAL getUserInfoURLWithApKey:[EncryptionHelper md5APKeyWithString:md5] userID:uID language:currentLanguage() productID:productID()];
    
    [self.requestClient postRequestFromURL:url identifier:kUserInfo completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)requestUserVipProductListWithUserID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *url = [UserDAL getUserVipProductListURLWithApKey:[EncryptionHelper apKey] userID:uID language:currentLanguage() productID:productID()];
    [self.requestClient postRequestFromURL:url identifier:kVipList completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            DLog(@"vip产品数据 jsonData: %@; 源数据: %@", jsonData, responseString);
        }
        
        if (jsonData) {
            [UserDAL parseUserVipProductListData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)requestUserVipBuyWithUserID:(NSString *)uID vipID:(NSString *)vID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *url = [UserDAL getUserVipBuyURLWithApKey:[EncryptionHelper apKey] userID:uID vipID:vID language:currentLanguage() productID:productID()];
    [self.requestClient postRequestFromURL:url identifier:kVipBuy completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            DLog(@"vip购买数据 jsonData: %@; 源数据: %@", jsonData, responseString);
        }
        
        if (jsonData) {
            [UserDAL parseUserVipBuyData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

#pragma mark - Cancel
- (void)cancelLogin
{
    [self.requestClient cancelRequestWithIdentifier:kLoginMethod];
}

@end
