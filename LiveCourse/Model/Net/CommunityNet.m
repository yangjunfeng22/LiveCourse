//
//  CommunityNet.m
//  HelloHSK
//
//  Created by junfengyang on 14/12/8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CommunityNet.h"
#import "CommunityDAL.h"
#import "HttpClient.h"
#import "EncryptionHelper.h"

@interface CommunityNet ()
{
    
}
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation CommunityNet

hsSharedInstanceImpClass(CommunityNet)

- (void)dealloc
{
    [_requestClient cancelAllRequest];
    _requestClient = nil;
}

- (HttpClient *)requestClient
{
    if (!_requestClient) _requestClient = [[HttpClient alloc] init];
    return _requestClient;
}

- (void)cancel
{
    [self.requestClient cancelAllRequest];
}


#pragma mark - 请求数据
// 帖子列表
- (void)requestCommunityListWithUserID:(NSString *)uID mID:(NSString *)mid length:(NSInteger)length filter:(NSInteger)filter version:(NSInteger)version keyWords:(NSString *)keyWords boardID:(NSInteger)boardID requestType:(CommunityListRequestType)requestType completion:(void (^)(BOOL, id, NSError *))completion
{

    NSString *safeMid = [NSString safeString:mid];
    NSString *params = [CommunityDAL getCommunityListURLParamsWithApKey:[EncryptionHelper apKey] email:uID language:currentLanguage() productID:productID() mid:safeMid length:length filter:filter version:version keyWords:keyWords boardID:boardID];
    
    NSString *url = [kHostUrl stringByAppendingString:kCommunityList];
    
    [self.requestClient postRequestFromURL:url params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CommunityDAL parseCommunityListByData:jsonData listRequestType:requestType completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

// 帖子详情
- (void)requestCommunityDetailWithUserID:(NSString *)uID topicID:(NSString *)topicID completion:(void (^)(BOOL, id, NSError *))completion
{
    
    NSString *params = [CommunityDAL getCommunityURLParamsWithApKey:[EncryptionHelper apKey] email:uID language:currentLanguage() productID:productID() topicID:topicID];
    
    [self.requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kCommunityDetail] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CommunityDAL parseCommunityDetailByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

// 回复帖子
- (void)requestCommunityReplyWithUserID:(NSString *)uID topicID:(NSString *)topicID targetID:(NSString *)targetID targetType:(NSInteger)targetType content:(NSString *)content audio:(NSString *)audio duration:(NSInteger)duration picture:(NSString *)picture thumbnail:(NSString *)thumbnail posted:(NSInteger)posted completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *params = [CommunityDAL getCommunityReplyURLParamsWithApKey:[EncryptionHelper apKey] email:uID language:currentLanguage() productID:productID() topicID:topicID targetID:targetID targetType:targetType content:content audio:audio duration:duration picture:picture thumbnail:thumbnail posted:posted];
    
    [self.requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kCommunityReply] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CommunityDAL parseCommunityReplyByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

// 更多回复
- (void)requestCommunityMoreRepliesWithUserID:(NSString *)uID topicID:(NSString *)topicID mID:(NSString *)mid length:(NSInteger)length completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *params = [CommunityDAL getCommunityMoreReplyURLParamsWithApKey:[EncryptionHelper apKey] email:uID language:currentLanguage() productID:productID() topicID:topicID mid:mid length:length];
    
    [self.requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kCommunityMoreReply] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CommunityDAL parseCommunityMoreReplyByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

// 赞/取消赞
- (void)requestCommunityLaudWithUserID:(NSString *)uID topicID:(NSString *)topicID targetID:(NSString *)targetID targetType:(NSInteger)targetType action:(NSInteger)action completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *params = [CommunityDAL getCommunityLaudURLParamsWithApKey:[EncryptionHelper apKey] email:uID language:currentLanguage() productID:productID() topicID:topicID targetID:targetID targetType:targetType action:action];
    
    [self.requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kCommunityLaud] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CommunityDAL parseCommunityLaudByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

// 发帖
- (void)requestCommunityPostWithUserID:(NSString *)uID borderID:(NSString *)borderID title:(NSString *)title content:(NSString *)content audio:(NSString *)audio duration:(NSInteger)duration picture:(NSString *)picture thumbnail:(NSString *)thumbnail posted:(NSInteger)posted completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *params = [CommunityDAL getCommunityPostURLParamsWithApKey:[EncryptionHelper apKey] email:uID language:currentLanguage() productID:productID() borderID:borderID title:title content:content audio:audio duration:duration picture:picture thumbnail:thumbnail posted:posted];
    
    NSString *url = [kHostUrl stringByAppendingString:kCommunityPost];
//    NSString *url = [NSString stringWithFormat:@"http://192.168.10.66/hsk/code/%@",kCommunityPost];
    
    [self.requestClient postRequestFromURL:url params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CommunityDAL parseCommunityPostByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}


#pragma mark - 板块

//板块列表
-(void)requestCommunityPlateListCompletion:(void (^)(BOOL, id, NSError *))completion
{
    
    NSString *params = [CommunityDAL getCommunityPlateListURLParamsWithUserID:kUserID ApKey:[EncryptionHelper apKey] language:currentLanguage() productID:productID()];
    
    NSString *urlStr = [kHostUrl stringByAppendingString:kCommunityPlatePost];
    
    [self.requestClient postRequestFromURL:urlStr params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
      
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CommunityDAL parseCommunityPlateListByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
        
    }];
}

@end
