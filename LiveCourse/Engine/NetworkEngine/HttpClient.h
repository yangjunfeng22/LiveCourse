//
//  HttpClient.h
//  PinyinGame
//
//  Created by yang on 13-11-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface HttpClient : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic, readonly)NSInteger statuCode;
@property (nonatomic, readonly)BOOL isRequestCanceled;

@property (nonatomic, strong)NSError *error;

- (void)getRequestFromURL:(NSString *)url params:(NSString *)params completion:(void (^)(BOOL finished, NSData *responseData, NSString *responseString, NSError *error))completion;

- (void)postRequestFromURL:(NSString *)url params:(NSString *)params completion:(void (^)(BOOL finished, NSData *responseData, NSString *responseString, NSError *error))completion;

/**
 *  带标志的Get请求。
 *   -- 以便后期根据这个标志取消对应的请求
 *
 *  @param url        url 地址
 *  @param identifier 标志
 *  @param completion 回调
 */
- (void)getRequestFromURL:(NSString *)url identifier:(NSString *)identifier completion:(void (^)(BOOL, NSData *, NSString *, NSError *))completion;

/**
 *  带标志的post请求。
 *   -- 以便后期根据这个标志取消对应的请求。
 *
 *  @param url        url 地址
 *  @param identifier 标志
 *  @param completion 回调。
 */
- (void)postRequestFromURL:(NSString *)url identifier:(NSString *)identifier completion:(void (^)(BOOL, NSData *, NSString *, NSError *))completion;

/**
 *  根据标志来取消对应的网络请求。
 *
 *  @param identifier 标志。
 */
- (void)cancelRequestWithIdentifier:(NSString *)identifier;

- (void)cancelAllRequest;

- (BOOL)isRequestAllCanceled;

@end
