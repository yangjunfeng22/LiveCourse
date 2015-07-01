//
//  UserNet.h
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSBaseNet.h"
@interface UserNet : HSBaseNet

#pragma mark - 数据请求
#pragma mark -
- (void)startLoginWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)tempUserLoginWithCompletion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)startRegistWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL finished, id result, NSError *error))completion;

// 注册界面的简单文本
- (void)requestRegistTempContentWithType:(NSString *)type completion:(void(^)(BOOL finished, id obj, NSError *error))completion;

//创建个人档案
- (void)startRegistTempUserWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL finished, id result, NSError *error))completion;

//第三方登陆
- (void)startThirdLoginWithUserID:(NSString *)userID Email:(NSString *)email name:(NSString *)name token:(NSString *)token img:(NSString *)imgUrl identifier:(NSString *)identifier completion:(void (^)(BOOL finished, id result, NSError *error))completion;

//第三方创建个人档案
- (void)startThirdRegistWithUserID:(NSString *)userID name:(NSString *)name identifier:(NSString *)identifier completion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)requestUserInfoWithUserID:(NSString *)uID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)startFindBackUserPasswordWithEmail:(NSString *)email completion:(void (^)(BOOL finished, id result, NSError *error))completion;

// vip处理
- (void)requestUserVipProductListWithUserID:(NSString *)uID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)requestUserVipBuyWithUserID:(NSString *)uID vipID:(NSString *)vID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)cancelLogin;

@end
