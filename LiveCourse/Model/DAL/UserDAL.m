//
//  UserDAL.m
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserDAL.h"
#import "UserModel.h"
#import "UserLaterStatuModel.h"
#import "URLUtility.h"
#import "Constants.h"
#import "KeyChainHelper.h"

#import "VipModel.h"

@implementation UserDAL

+ (NSString *)getLoginURLByApKey:(NSString *)apKey email:(NSString *)email password:(NSString *)password language:(NSString *)language productID:(NSString *)productID
{
    // 过滤非法字符。
    apKey = [NSString isNullString:apKey] ? @"":apKey;
    email = [NSString isNullString:email] ? @"":email;
    password = [NSString isNullString:password] ? @"":password;
    language = [NSString isNullString:language] ? @"":language;
    // 构建url
    NSString *url = [kLifeHostUrl stringByAppendingString:kLoginMethod];
    
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"email":email, @"password":password, @"language":language, @"productID":productID}];
}

+ (NSString *)getRegistTextContentURLWithApKey:(NSString *)apKey type:(NSString *)type language:(NSString *)language productID:(NSString *)productID
{
    NSString *url = [kLifeHostUrl stringByAppendingString:kTextContent];
    return [URLUtility getURL:url fromParams:@{@"type":type, @"language":language, @"productID":productID}];
}

+ (NSString *)getTempUserLoginURLWithApKey:(NSString *)apKey Language:(NSString *)language productID:(NSString *)productID mcKey:(NSString *)mcKey
{
    NSString *url = [kLifeHostUrl stringByAppendingString:kTempUserLoginMethod];
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"language":language, @"comefrom":productID, @"mckey":mcKey}];
}

+ (NSString *)getThirdLoginUrlWithUserID:(NSString *)userID userEmail:(NSString *)userEmail name:(NSString *)name token:(NSString *)token img:(NSString *)imgUrl language:(NSString *)language identifier:(NSString *)identifier productID:(NSString *)productID{
    
    userID = [NSString isNullString:userID] ? @"":userID;
    userEmail = [NSString isNullString:userEmail] ? @"":userEmail;
    name = [NSString isNullString:name] ? @"":name;
    token = [NSString isNullString:token] ? @"":token;
    imgUrl = [NSString isNullString:imgUrl] ? @"":imgUrl;
    
    NSString *url = [kLifeHostUrl stringByAppendingString:kThirdLoginMethod];
    return [URLUtility getURL:url fromParams:@{@"userID":userID, @"email":userEmail, @"name":name, @"token":token, @"image":imgUrl, @"language":language, @"identifier":identifier, @"productID":productID}];
}

+ (NSString *)getRegistURLWithApKey:(NSString *)apKey email:(NSString *)email password:(NSString *)password language:(NSString *)language productID:(NSString *)productID mcKey:(NSString *)mcKey
{
    email = [NSString isNullString:email] ? @"":email;
    
    NSString *url = [kLifeHostUrl stringByAppendingString:kRegistMethod];
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"email":email, @"password":password, @"language":language, @"comefrom":productID, @"mckey":mcKey}];
}


+ (NSString *)getTempUserRegistURLWithApKey:(NSString *)apKey eemail:(NSString *)eemail nemail:(NSString *)nemail password:(NSString *)password Language:(NSString *)language productID:(NSString *)productID mcKey:(NSString *)mcKey{
    eemail = [NSString isNullString:eemail] ? @"":eemail;
    nemail = [NSString isNullString:nemail] ? @"":nemail;
    
    NSString *url = [kLifeHostUrl stringByAppendingString:kTempUserRegistMethod];
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"email":eemail, @"nemail":nemail, @"password":password, @"language":language, @"comefrom":productID, @"mckey":mcKey}];
}


+(NSString *)getThirdRegistUrlWithApKey:(NSString *)apKey userEmail:(NSString *)userEmail language:(NSString *)language productID:(NSString *)productID UserID:(NSString *)userID name:(NSString *)name identifier:(NSString *)identifier
{
    userEmail = [NSString isNullString:userEmail] ? @"":userEmail;
    userID = [NSString isNullString:userID] ? @"":userID;
    name = [NSString isNullString:name] ? @"":name;
    identifier = [NSString isNullString:identifier] ? @"":identifier;
    
    NSString *url = [kLifeHostUrl stringByAppendingString:kThirdRegistMethod];
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"email":userEmail, @"userID":userID, @"name":name, @"identifier":identifier, @"language":language, @"productID":productID}];
}


+ (NSString *)getPasswordBackURLWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID
{
    email = [NSString isNullString:email] ? @"":email;
    
    NSString *url = [kLifeHostUrl stringByAppendingString:kFindPassword];
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"email":email, @"language":language, @"productID":productID}];
}

+ (NSString *)getUserInfoURLWithApKey:(NSString *)apKey userID:(NSString *)uID language:(NSString *)language productID:(NSString *)productID
{
    NSString *url = [kLifeHostUrl stringByAppendingString:kUserInfo];
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"uID":uID, @"language":language, @"productID":productID}];
}

+ (NSString *)getUserVipProductListURLWithApKey:(NSString *)apKey userID:(NSString *)uID language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    
    NSString *url = [kLifeHostUrl stringByAppendingString:kVipList];
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"uID":uID, @"language":language, @"productID":productID}];
}

+ (NSString *)getUserVipBuyURLWithApKey:(NSString *)apKey userID:(NSString *)uID vipID:(NSString *)vID language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    vID = [NSString isNullString:vID] ? @"":vID;
    
    NSString *url = [kLifeHostUrl stringByAppendingString:kVipBuy];
    return [URLUtility getURL:url fromParams:@{@"apkey":apKey, @"uID":uID, @"itemID":vID, @"language":language, @"productID":productID}];
}

#pragma mark - block
// 登陆/注册
+ (void)parseUserByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        id results = [resultData objectForKey:@"User"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseUserLogin:results completion:^(BOOL finished, id obj, NSError *aError) {
                if (completion) {
                    completion(finished, obj, aError);
                }
            }];
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:GDLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseTextContentByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            NSString *content = [resultData objectForKey:@"Content"];
            content = [NSString safeString:content];
            if (completion) {
                completion(success, content, error);
            }
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:GDLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseUserLogin:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        //NSLog(@"结果数据: %@", resultData);
        NSString *userID    = [resultData objectForKey:@"Uid"];
        NSString *userEmail = [resultData objectForKey:@"Email"];
        NSString *endDate   = [resultData objectForKey:@"Enddate"];
        NSString *image     = [resultData objectForKey:@"Avatars"];
        NSString *name      = [resultData objectForKey:@"Nickname"];
        NSString *role      = [resultData objectForKey:@"Role"];
        NSInteger coin      = [[resultData objectForKey:@"Balance"] integerValue];
        // vip过期的时间
        NSUInteger endTime   = [[resultData objectForKey:@"EndTime"] integerValue];
        
        BOOL enabled        = [[resultData objectForKey:@"Enabled"] boolValue];
        
        NSString *null = @"(null)";
        userID = [userID isEqualToString:null] ? nil:userID;
        userEmail = [userEmail isEqualToString:null] ? nil:userEmail;
        endDate = [endDate isEqualToString:null] ? nil:endDate;
        image = [image isEqualToString:null] ? nil:image;
        name = [name isEqualToString:null] ? nil:name;
        role = [role isEqualToString:null] ? nil:role;
        
        kSetUDUserID(userID);
        kSetUDUserEamil(userEmail);
        
        BOOL emptyEmail = [[userEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || !userEmail;
        if (!emptyEmail)
        {
            [KeyChainHelper saveUserName:userEmail userNameService:KEY_USERNAME password:@"" passwordService:KEY_PASSWORD];
        }
        [self saveUserDataWithUserID:userID userEmail:userEmail enabled:enabled endDate:endDate endTime:endTime logined:YES name:name role:role picture:image coin:coin completion:completion];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

// 找回密码
+ (void)parseUserFindPasswordData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        
        if (completion) {
            completion(success, nil, error);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:GDLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseUserVipProductListData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        // 特权
        //NSString *prerogative = [resultData objectForKey:@"Prerogative"];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        if (success)
        {
            if ([results isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arrVip = [[NSMutableArray alloc] initWithCapacity:2];
                for (NSDictionary *dicRecord in results)
                {
                    NSString *vID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Vid"]];
                    NSString *duration     = [dicRecord objectForKey:@"Duration"];
                    NSString *price  = [dicRecord objectForKey:@"Price"];
                    NSString *explain  = [dicRecord objectForKey:@"Description"];
                    
                    VipModel *vipModel = [[VipModel alloc] init];
                    vipModel.vID = vID;
                    vipModel.duration = duration;
                    vipModel.price = price;
                    vipModel.explain = explain;
                    [arrVip addObject:vipModel];
                }
                
                if (completion){
                    completion(YES, arrVip, error);
                }
            }
            else
            {
                NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!", @"") code:-1 userInfo:nil];
                if (completion) {
                    completion(NO, nil, error);
                }
            }
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseUserVipBuyData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Result"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        if (success)
        {
            if ([results isKindOfClass:[NSDictionary class]])
            {
                //NSString *duration     = [results objectForKey:@"Duration"];
                //NSString *price  = [results objectForKey:@"Price"];
                NSString *role = [[NSString alloc] initWithFormat:@"%@", [results objectForKey:@"Role"]];
                NSUInteger endTime  = [[results objectForKey:@"EndTime"] integerValue];
                NSInteger coin      = [[results objectForKey:@"Balance"] integerValue];
                //DLog(@"duration: %@, price: %@, endTiem: %@", duration, price, endTime);
                UserModel *userModel = [UserDAL queryUserInfoWithUserID:kUserID];
                userModel.vipEndTime = endTime;
                userModel.userRole = role;
                userModel.userCoin = coin;
                
                if (completion){
                    completion(YES, @(coin), error);
                }
            }
            else
            {
                NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!", @"") code:-1 userInfo:nil];
                if (completion) {
                    completion(NO, nil, error);
                }
            }
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

#pragma mark - 保存用户数据
+ (void)saveUserDataWithUserID:(NSString *)uID userEmail:(NSString *)email enabled:(BOOL)enabled endDate:(NSString *)endDate endTime:(NSUInteger)endTime logined:(BOOL)logined name:(NSString *)name role:(NSString *)role picture:(NSString *)picture coin:(NSInteger)coin completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    UserModel *user = [UserDAL queryUserInfoWithUserID:uID];
    
    BOOL needUpdate = [user.userID isEqualToString:uID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        UserModel *tUser = needUpdate ? [user inContext:localContext] : [UserModel createEntityInContext:localContext];
        uID   ? tUser.userID = uID:uID;
        email ? tUser.email = email:email;
        name  ? tUser.name = name:name;
        picture ? tUser.image = picture:picture;
        role ? tUser.role = role:role;
        tUser.roleEndDateValue < endTime ? tUser.roleEndDateValue = endTime:endTime;
        tUser.enabledValue = enabled;
        tUser.loginedValue = logined;
        tUser.coinValue = (int32_t)coin;
    }completion:^(BOOL success, NSError *error) {
        if (completion){
            completion(success, user, error);
        }
    }];
}

#pragma mark - 查询用户数据
+ (UserModel *)queryUserInfoWithUserID:(NSString *)userID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    UserModel *user = (UserModel *)[UserModel findFirstByAttribute:@"userID" withValue:userID inContext:localContext];
    return user;
}

// 用户最近的学习状态
+ (void)saveUserLaterStatusWithUserID:(NSString *)uID categoryID:(NSString *)ccID courseID:(NSString *)cID unitID:(NSString *)unitID lessonID:(NSString *)lID checkPointID:(NSString *)cpID nexCheckPointID:(NSString *)nexCpID timeStamp:(NSInteger)timeStamp completion:(void (^)(BOOL finished, id result, NSError *error))completion
{
    // 先删除旧的信息，确保数据库中只有一条该用户的数据。
    [NSManagedObjectContext clearContextForCurrentThread];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND ccID == %@", uID, ccID];
    [UserLaterStatuModel deleteAllMatchingPredicate:predicate];
    [context saveToPersistentStoreAndWait];
    
    // 保存数据
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND ccID == %@", uID, ccID];
        UserLaterStatuModel *user = (UserLaterStatuModel *)[UserLaterStatuModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [user.uID isEqualToString:uID];
        
        UserLaterStatuModel *tUser = needUpdate ? [user inContext:localContext] : [UserLaterStatuModel createEntityInContext:localContext];
        
        uID ? tUser.uID   = uID:uID;
        ccID ? tUser.ccID = ccID:ccID;
        cID ? tUser.cID   = cID:cID;
        lID ?  tUser.lID  = lID:lID;
        cpID ? tUser.cpID = cpID:cpID;
        unitID ? tUser.unitID   = unitID:unitID;
        nexCpID ? tUser.nexCpID = nexCpID:nexCpID;
        tUser.timeStampValue    = (int32_t)timeStamp;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(YES, nil, error);
        }
    }];
}

+ (NSInteger)userLaterStatusCountWithUserID:(NSString *)uID courseCategoryID:(NSString *)ccID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND ccID == %@", uID, ccID];
    NSInteger count = [UserLaterStatuModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

+ (UserLaterStatuModel *)userLaterStatuWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@", uID];
    UserLaterStatuModel *userLaterStatu = [UserLaterStatuModel findFirstWithPredicate:predicate inContext:context];
    return userLaterStatu;
}

+ (UserLaterStatuModel *)userLaterStatuWithUserID:(NSString *)uID courseCategoryID:(NSString *)ccID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND ccID == %@", uID, ccID];
    UserLaterStatuModel *userLaterStatu = [UserLaterStatuModel findFirstWithPredicate:predicate inContext:context];
    return userLaterStatu;
}

+ (BOOL)userVipRoleEnable
{
    UserModel *userModel = [self queryUserInfoWithUserID:kUserID];
    NSUInteger curTime = [timeStamp() integerValue];
    NSUInteger vipEndTime = (NSUInteger)userModel.roleEndDateValue;
    BOOL vipEnabled = (vipEndTime > curTime);
    return vipEnabled;
}

@end
