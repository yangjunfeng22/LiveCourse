//
//  CommunityDAL.m
//  HelloHSK
//
//  Created by junfengyang on 14/12/8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CommunityDAL.h"
#import "URLUtility.h"

#import "CommunityModel.h"
#import "CommunityDetaiModel.h"
#import "CommunityReplyModel.h"
#import "CommunityPlateModel.h"

#import "CommunityAudioModel.h"

@implementation CommunityDAL

#pragma mark - api所需的参数列表
+ (NSString *)getCommunityListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID mid:(NSString *)mid length:(NSInteger)length filter:(NSInteger)filter version:(NSInteger)version keyWords:(NSString *)keyWords boardID:(NSInteger)boardID
{
    email = [NSString isNullString:email] ? @"":email;
    mid =[NSString isNullString:mid] ? @"":mid;
    keyWords = [NSString safeString:keyWords];
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":email, @"language":language, @"productID":productID, @"mid":mid, @"length":[NSNumber numberWithInteger:length], @"filter":[NSNumber numberWithInteger:filter], @"version":[NSNumber numberWithInteger:version],@"keyWords":keyWords,@"boardID":[NSNumber numberWithInteger:boardID]}];
}

+ (NSString *)getCommunityURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID topicID:(NSString *)topicID
{
    email = [NSString isNullString:email] ? @"":email;
    topicID =[NSString isNullString:topicID] ? @"":topicID;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":email, @"language":language, @"productID":productID, @"topicID":topicID}];
}

+ (NSString *)getCommunityReplyURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID topicID:(NSString *)topicID targetID:(NSString *)targetID targetType:(NSInteger)targetType content:(NSString *)content audio:(NSString *)audio duration:(NSInteger)duration picture:(NSString *)picture thumbnail:(NSString *)thumbnail posted:(NSInteger)posted
{
    email = [NSString isNullString:email] ? @"":email;
    topicID =[NSString isNullString:topicID] ? @"":topicID;
    targetID = [NSString isNullString:targetID] ? @"":targetID;
    content =[NSString isNullString:content] ? @"":content;
    audio = [NSString isNullString:audio] ? @"":audio;
    picture =[NSString isNullString:picture] ? @"":picture;
    thumbnail = [NSString isNullString:thumbnail] ? @"":thumbnail;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":email, @"language":language, @"productID":productID, @"topicID":topicID, @"targetID":targetID, @"targetType":[NSNumber numberWithInteger:targetType], @"content":content, @"audio":audio, @"duration":[NSNumber numberWithInteger:duration] ,@"picture":picture, @"thumbnail":thumbnail, @"posted":[NSNumber numberWithInteger:posted]}];
}

+ (NSString *)getCommunityMoreReplyURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID topicID:(NSString *)topicID mid:(NSString *)mid length:(NSInteger)length
{
    email = [NSString isNullString:email] ? @"":email;
    mid =[NSString isNullString:mid] ? @"":mid;
    topicID = [NSString isNullString:topicID] ? @"":topicID;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":email, @"language":language, @"productID":productID, @"topicID":topicID, @"mid":mid, @"length":[NSNumber numberWithInteger:length]}];
}

+ (NSString *)getCommunityLaudURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID topicID:(NSString *)topicID targetID:(NSString *)targetID targetType:(NSInteger)targetType action:(NSInteger)action
{
    email = [NSString isNullString:email] ? @"":email;
    topicID =[NSString isNullString:topicID] ? @"":topicID;
    targetID = [NSString isNullString:targetID] ? @"":targetID;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":email, @"language":language, @"productID":productID, @"topicID":topicID, @"targetID":targetID, @"targetType":[NSNumber numberWithInteger:targetType], @"action":[NSNumber numberWithInteger:action]}];
}

+ (NSString *)getCommunityPostURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID borderID:(NSString *)borderID title:(NSString *)title content:(NSString *)content audio:(NSString *)audio duration:(NSInteger)duration picture:(NSString *)picture thumbnail:(NSString *)thumbnail posted:(NSInteger)posted
{
    email = [NSString isNullString:email] ? @"":email;
    borderID =[NSString isNullString:borderID] ? @"":borderID;
    title = [NSString isNullString:title] ? @"":title;
    content =[NSString isNullString:content] ? @"":content;
    audio = [NSString isNullString:audio] ? @"":audio;
    picture =[NSString isNullString:picture] ? @"":picture;
    thumbnail = [NSString isNullString:thumbnail] ? @"":thumbnail;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":email, @"language":language, @"productID":productID, @"borderID":borderID, @"title":title, @"content":content, @"audio":audio,@"duration":[NSNumber numberWithInteger:duration], @"picture":picture, @"thumbnail":thumbnail, @"posted":[NSNumber numberWithInteger:posted]}];
}

#pragma mark - 解析数据
// 帖子列表
+ (void)parseCommunityListByData:(id)resultData listRequestType:(CommunityListRequestType)type completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSString *uID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Uid"]];
        id results = [resultData objectForKey:@"Records"];
        
        //保存录音时间
        NSInteger postLimit = [[resultData objectForKey:@"PostLimit"] integerValue];
        NSInteger replyLimit = [[resultData objectForKey:@"ReplyLimit"] integerValue];
        [USER_DEFAULT setInteger:postLimit forKey:@"PostLimit"];
        [USER_DEFAULT setInteger:replyLimit forKey:@"ReplyLimit"];
        
        
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseCommunityListDetail:results userID:uID listRequestType:type completion:completion];
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
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseCommunityListDetail:(id)resultData userID:(NSString *)uID listRequestType:(CommunityListRequestType)type completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        NSMutableArray *arrList = [[NSMutableArray alloc] initWithCapacity:2];
        if (CommunityListRequestTypeDataSave == type)
        {
            [self deleteCommunityListWithUserID:uID];
        }
        
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *boardID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"BoardID"]];
            NSString *topicID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"TopicID"]];
            NSString *tag     = [dicRecord objectForKey:@"Tag"];
            NSString *tagName = [dicRecord objectForKey:@"TagName"];
            NSString *title   = [dicRecord objectForKey:@"Title"];
            NSString *summary = [dicRecord objectForKey:@"Summary"];
            NSString *picture = [dicRecord objectForKey:@"Picture"];
            NSString *audio   = [dicRecord objectForKey:@"Audio"];
            NSInteger status  = [[dicRecord objectForKey:@"Status"] integerValue];
            NSString *owner   = [dicRecord objectForKey:@"Owner"];
            NSInteger liked   = [[dicRecord objectForKey:@"Liked"] integerValue];
            NSInteger replied = [[dicRecord objectForKey:@"Replied"] integerValue];
            NSInteger posted  = [[dicRecord objectForKey:@"Posted"] integerValue];
            NSInteger duration = [[NSString safeString:[dicRecord objectForKey:@"Duration"]] integerValue];
            
            CommunityModel *community = [CommunityModel createEntityInContext:[NSManagedObjectContext contextForCurrentThread]];
            community.boardID = boardID;
            community.topicID = topicID;
            community.tag = tag;
            community.tagName = tagName;
            community.title = title;
            community.summary = summary;
            community.picture = picture;
            community.audio = [NSString safeString:audio];
            community.statusValue = (int32_t)status;
            community.owner = owner;
            community.likedValue = (int32_t)liked;
            community.repliedValue = (int32_t)replied;
            community.postedValue = (int32_t)posted;
            community.durationValue = (int32_t)duration;
            [arrList addObject:community];

            // 只有下拉刷新的时候才需要保存当前条数。
            if (CommunityListRequestTypeDataSave == type)
            {
                [self saveCommunityListDataWithUserID:uID boardID:boardID topicID:topicID tag:tag tagName:tagName title:title summary:summary picture:picture audio:audio status:status owner:owner liked:liked replied:replied posted:posted duration:(NSInteger)duration completion:^(BOOL finished, id obj, NSError *error) {
                    //DLog(@"保存社区列表至数据库成功");
                }];
            }
        }
        if (completion) {
            completion(YES, arrList, nil);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}


// 帖子详情
+ (void)parseCommunityDetailByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSString *uID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Uid"]];
        id results = [resultData objectForKey:@"Topic"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseCommunity:results userID:uID completion:completion];
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
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseCommunity:(id)resultData userID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        
        NSString *boardID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"BoardID"]];
        NSString *topicID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"TopicID"]];
        NSString *tag     = [resultData objectForKey:@"Tag"];
        NSString *tagName = [resultData objectForKey:@"TagName"];
        NSString *title   = [resultData objectForKey:@"title"];
        NSString *content = [resultData objectForKey:@"Content"];
        NSString *avatars    = [resultData objectForKey:@"Avatars"];
        NSString *picture = [resultData objectForKey:@"Picture"];
        NSString *audio   = [resultData objectForKey:@"Audio"];
        NSInteger duration = [[NSString safeString:[resultData objectForKey:@"Duration"]] integerValue];
        NSInteger status  = [[resultData objectForKey:@"Status"] integerValue];
        NSString *owner   = [resultData objectForKey:@"Owner"];
        NSInteger liked   = [[resultData objectForKey:@"Liked"] integerValue];
        NSInteger replied = [[resultData objectForKey:@"Replied"] integerValue];
        NSInteger posted  = [[resultData objectForKey:@"Posted"] integerValue];
        BOOL praised = [[resultData objectForKey:@"Praised"] boolValue];
        NSArray *arrReply  = [resultData objectForKey:@"Replies"];
        
        CommunityDetaiModel *communityDetail = [[CommunityDetaiModel alloc] init];
        communityDetail.boardID = boardID;
        communityDetail.topicID = topicID;
        communityDetail.tag = tag;
        communityDetail.tagName = tagName;
        communityDetail.title = title;
        communityDetail.content = content;
        communityDetail.avatars = avatars;
        communityDetail.picture = picture;
        communityDetail.audio = audio;
        communityDetail.duration = duration;
        communityDetail.status = status;
        communityDetail.owner = owner;
        communityDetail.liked = liked;
        communityDetail.replied = replied;
        communityDetail.posted = posted;
        communityDetail.praised = praised;
        
        NSMutableArray *arrCommunityReply = [[NSMutableArray alloc] init];
        for (NSDictionary *dicReply in arrReply)
        {
            NSString *replyID = [[NSString alloc] initWithFormat:@"%@", [dicReply objectForKey:@"ReplyID"]];
            NSString *content = [dicReply objectForKey:@"Content"];
            NSString *tag     = [dicReply objectForKey:@"Tag"];
            NSString *tagName = [dicReply objectForKey:@"TagName"];
            NSString *avatars    = [dicReply objectForKey:@"Avatars"];
            NSString *picture = [dicReply objectForKey:@"Picture"];
            NSString *audio   = [dicReply objectForKey:@"Audio"];
            NSInteger duration = [[dicReply objectForKey:@"Duration"] integerValue];
            NSInteger status  = [[dicReply objectForKey:@"Status"] integerValue];
            NSString *owner   = [dicReply objectForKey:@"Owner"];
            NSInteger liked   = [[dicReply objectForKey:@"Liked"] integerValue];
            NSInteger replied = [[dicReply objectForKey:@"Replied"] integerValue];
            NSString *replyTo = [dicReply objectForKey:@"ReplyTo"];
            NSInteger posted  = [[dicReply objectForKey:@"Posted"] integerValue];
            
            CommunityReplyModel *communityReply = [[CommunityReplyModel alloc] init];
            communityReply.replyID = replyID;
            communityReply.content = content;
            communityReply.tag = tag;
            communityReply.tagName = tagName;
            communityReply.avatars = avatars;
            communityReply.picture = picture;
            communityReply.audio = audio;
            communityReply.duration = duration;
            communityReply.status = status;
            communityReply.owner = owner;
            communityReply.liked = liked;
            communityReply.replied = replied;
            communityReply.replyTo = replyTo;
            communityReply.posted = posted;
            
            [arrCommunityReply addObject:communityReply];
        }
        communityDetail.replies = arrCommunityReply;
        
        if (completion) {
            completion(YES, communityDetail, nil);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

// 回复帖子
+ (void)parseCommunityReplyByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSString *uID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Uid"]];
        id results = [resultData objectForKey:@"Reply"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseCommunityReply:results userID:uID completion:completion];
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
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseCommunityReply:(id)dicReply userID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([dicReply isKindOfClass:[NSDictionary class]])
    {
        NSString *topicID = [[NSString alloc] initWithFormat:@"%@", [dicReply objectForKey:@"TopicID"]];
        NSString *replyID = [[NSString alloc] initWithFormat:@"%@", [dicReply objectForKey:@"ReplyID"]];
        NSString *content = [dicReply objectForKey:@"Content"];
        NSString *tag     = [dicReply objectForKey:@"Tag"];
        NSString *tagName = [dicReply objectForKey:@"TagName"];
        NSString *avatars = [dicReply objectForKey:@"Avatars"];
        NSString *picture = [dicReply objectForKey:@"Picture"];
        NSString *audio   = [dicReply objectForKey:@"Audio"];
        NSInteger duration = [[dicReply objectForKey:@"Duration"] integerValue];
        //NSInteger status  = [[dicReply objectForKey:@"Status"] integerValue];
        NSString *owner   = [dicReply objectForKey:@"Owner"];
        NSInteger liked   = [[dicReply objectForKey:@"Liked"] integerValue];
        NSInteger replied = [[dicReply objectForKey:@"Replied"] integerValue];
        NSString *replyTo = [dicReply objectForKey:@"ReplyTo"];
        NSInteger posted  = [[dicReply objectForKey:@"Posted"] integerValue];
        
        CommunityReplyModel *communityReply = [[CommunityReplyModel alloc] init];
        communityReply.topicID = topicID;
        communityReply.replyID = replyID;
        communityReply.content = content;
        communityReply.tag = tag;
        communityReply.tagName = tagName;
        communityReply.Avatars = avatars;
        communityReply.picture = picture;
        communityReply.audio = audio;
        communityReply.duration = duration;
        //communityReply.status = status;
        communityReply.owner = owner;
        communityReply.liked = liked;
        communityReply.replied = replied;
        communityReply.replyTo = replyTo;
        communityReply.posted = posted;
        
        if (completion) {
            completion(YES, communityReply, nil);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

// 更多回复
+ (void)parseCommunityMoreReplyByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSString *uID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Uid"]];
        id results = [resultData objectForKey:@"Topic"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseCommunityMoreReply:results userID:uID completion:completion];
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
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseCommunityMoreReply:(id)result userID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSArray *arrReplies = [result objectForKey:@"Replies"];
        
        NSMutableArray *arrReply = [[NSMutableArray alloc] initWithCapacity:2];
        for (NSDictionary *dicReply in arrReplies)
        {
            
            NSString *replyID = [[NSString alloc] initWithFormat:@"%@", [dicReply objectForKey:@"ReplyID"]];
            NSString *content = [dicReply objectForKey:@"Content"];
            NSString *tag     = [dicReply objectForKey:@"Tag"];
            NSString *tagName = [dicReply objectForKey:@"TagName"];
            NSString *avatars    = [dicReply objectForKey:@"Avatars"];
            NSString *picture = [dicReply objectForKey:@"Picture"];
            NSString *audio   = [dicReply objectForKey:@"Audio"];
            //NSInteger status  = [[dicReply objectForKey:@"Status"] integerValue];
            NSString *owner   = [dicReply objectForKey:@"Owner"];
            NSInteger liked   = [[dicReply objectForKey:@"Liked"] integerValue];
            NSInteger replied = [[dicReply objectForKey:@"Replied"] integerValue];
            NSString *replyTo = [dicReply objectForKey:@"ReplyTo"];
            NSInteger posted  = [[dicReply objectForKey:@"Posted"] integerValue];
            
            CommunityReplyModel *communityReply = [[CommunityReplyModel alloc] init];
            communityReply.replyID = replyID;
            communityReply.content = content;
            communityReply.tag = tag;
            communityReply.tagName = tagName;
            communityReply.avatars = avatars;
            communityReply.picture = picture;
            communityReply.audio = audio;
            //communityReply.status = status;
            communityReply.owner = owner;
            communityReply.liked = liked;
            communityReply.replied = replied;
            communityReply.replyTo = replyTo;
            communityReply.posted = posted;
            
            [arrReply addObject:communityReply];
        }
        NSError *error = [NSError errorWithDomain:MyLocal(@"") code:0 userInfo:nil];
        if (completion) {
            completion(YES, arrReply, error);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

// 赞相关
+ (void)parseCommunityLaudByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
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
        if (completion) {
            completion(success, nil, error);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

// 发帖子
+ (void)parseCommunityPostByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSString *uID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Uid"]];
        id results = [resultData objectForKey:@"Topic"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseCommunityPost:results userID:uID completion:completion];
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
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseCommunityPost:(id)dicRecord userID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([dicRecord isKindOfClass:[NSDictionary class]])
    {
        NSString *boardID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"BoardID"]];
        NSString *topicID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"TopicID"]];
        NSString *tag     = [dicRecord objectForKey:@"Tag"];
        NSString *tagName = [dicRecord objectForKey:@"TagName"];
        NSString *title   = [dicRecord objectForKey:@"title"];
        NSString *summary = [dicRecord objectForKey:@"Summary"];
        NSString *picture = [dicRecord objectForKey:@"Picture"];
        NSString *audio   = [dicRecord objectForKey:@"Audio"];
        NSInteger status  = [[dicRecord objectForKey:@"Status"] integerValue];
        NSString *owner   = [dicRecord objectForKey:@"Owner"];
        NSInteger liked   = [[dicRecord objectForKey:@"Liked"] integerValue];
        NSInteger replied = [[dicRecord objectForKey:@"Replied"] integerValue];
        NSInteger posted  = [[dicRecord objectForKey:@"Posted"] integerValue];
        
        CommunityModel *community = [CommunityModel createEntityInContext:[NSManagedObjectContext contextForCurrentThread]];
        community.boardID = boardID;
        community.topicID = topicID;
        community.tag = tag;
        community.tagName = tagName;
        community.title = title;
        community.summary = summary;
        community.picture = picture;
        community.audio = audio;
        community.statusValue = status;
        community.owner = owner;
        community.likedValue = liked;
        community.repliedValue = replied;
        community.postedValue = posted;
        
        if (completion) {
            completion(YES, community, nil);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

#pragma mark - 保存数据
// 帖子列表
+ (void)saveCommunityListDataWithUserID:(NSString *)uID boardID:(NSString *)boardID topicID:(NSString *)topicID tag:(NSString *)tag tagName:(NSString *)tagName title:(NSString *)title summary:(NSString *)summary picture:(NSString *)picture audio:(NSString *)audio status:(NSInteger)status owner:(NSString *)owner liked:(NSInteger)liked replied:(NSInteger)replied posted:(NSInteger)posted duration:(NSInteger)duration completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    CommunityModel *community = [self queryCommunityWithUserID:uID boardID:boardID topicID:topicID];
    
    BOOL needUpdate = [community.userID isEqualToString:uID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CommunityModel *tCommunity = needUpdate ? [community inContext:localContext] : [CommunityModel createEntityInContext:localContext];
        uID   ? tCommunity.userID = uID:uID;
        boardID ? tCommunity.boardID = boardID:boardID;
        topicID ? tCommunity.topicID = topicID:topicID;
        tag ? tCommunity.tag = tag:tag;
        tagName ? tCommunity.tagName = tagName:tagName;
        title ? tCommunity.title = title:title;
        summary ? tCommunity.summary = summary:summary;
        picture ? tCommunity.picture = picture:picture;
        tCommunity.audio = [NSString safeString:audio];
        tCommunity.statusValue = status;
        owner ? tCommunity.owner = owner:owner;
        tCommunity.likedValue = liked;
        tCommunity.repliedValue = replied;
        tCommunity.postedValue = posted;
        tCommunity.durationValue = duration;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion){
            completion(success, nil, error);
        }
    }];
}

// 帖子详情

#pragma mark - 删除数据
+ (BOOL)deleteCommunityListWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", uID];
//    BOOL deleted = [CommunityModel deleteAllMatchingPredicate:predicate inContext:context];
    BOOL deleted = [CommunityModel deleteAllMatchingPredicate:nil];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

#pragma mark - 查询数据
+ (CommunityModel *)queryCommunityWithUserID:(NSString *)uID boardID:(NSString *)boardID topicID:(NSString *)topicID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND boardID == %@ AND topicID == %@", uID, boardID, topicID];
    CommunityModel *community = [CommunityModel findFirstWithPredicate:predicate inContext:context];
    return community;
}

+ (NSArray *)queryCommunityListWithUserID:(NSString *)uID boardID:(NSString *)boardID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND boardID == %@", uID, boardID];
    NSArray *list = [CommunityModel findAllSortedBy:@"posted" ascending:YES withPredicate:predicate inContext:context];
    return list;
}

+ (NSArray *)queryCommunityListWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", uID];
    NSArray *list = [CommunityModel findAllWithPredicate:predicate inContext:context];
    return list;
}

+ (id)fetchCommunityListWithUserID:(NSString *)uID boardID:(NSString *)boardID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context =[NSManagedObjectContext contextForCurrentThread];
    //自定义fetch查询
    NSFetchRequest *request = [CommunityModel createFetchRequestInContext:context];
    
    //使用谓词指定查询条件。
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND boardID == %@", uID, boardID];
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posted" ascending:YES];
    [sortDescriptors addObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    
    //指定查询偏移量
    request.fetchOffset = fetchOffset;
    request.fetchLimit = fetchLimit;
    NSArray *fetchResult = [CommunityModel executeFetchRequest:request inContext:context];
    
    return fetchResult;
}

+ (id)fetchCommunityListWithUserID:(NSString *)uID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context =[NSManagedObjectContext contextForCurrentThread];
    //自定义fetch查询
    NSFetchRequest *request = [CommunityModel createFetchRequestInContext:context];
    
    //使用谓词指定查询条件。
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@", uID];
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posted" ascending:YES];
    [sortDescriptors addObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    
    //指定查询偏移量
    request.fetchOffset = fetchOffset;
    request.fetchLimit = fetchLimit;
    NSArray *fetchResult = [CommunityModel executeFetchRequest:request inContext:context];
    
    return fetchResult;
}




#pragma mark - 板块

+(NSString *)getCommunityPlateListURLParamsWithUserID:(NSString *)uID ApKey:(NSString *)apKey language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString safeString:uID];
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":uID, @"language":language, @"productID":productID}];
}


+(void)parseCommunityPlateListByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion{
    
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseCommunityPlateListDetail:results completion:completion];
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
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}


+ (void)parseCommunityPlateListDetail:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        
        [self deleteCommunityPlateListWithUserID:kUserID];
        
        NSInteger totalCount = ((NSArray *)resultData).count;
        __block NSInteger nowCount = 0;
        for (NSDictionary *dicRecord in resultData)
        {
            NSInteger boardID = [[dicRecord objectForKey:@"BoardID"] integerValue];
            NSString *icon = [dicRecord objectForKey:@"Icon"];
            NSInteger quantity = [[dicRecord objectForKey:@"Quantity"] integerValue];
            NSInteger weight = [[dicRecord objectForKey:@"Weight"] integerValue];
            NSString *title = [dicRecord objectForKey:@"Title"];
            
            [self saveCommunityListPlateDataWithUserID:kUserID boardID:boardID title:title quantity:quantity weight:weight icon:icon completion:^(BOOL finished, id obj, NSError *error) {
                nowCount ++;
                
                if (nowCount >= totalCount){
                    if (completion) {
                        completion(YES, nil, error);
                    }
                }
            }];
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (BOOL)deleteCommunityPlateListWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", uID];
    BOOL deleted = [CommunityPlateModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

+ (void)saveCommunityListPlateDataWithUserID:(NSString *)uID boardID:(NSInteger )boardID title:(NSString *)title quantity:(NSInteger)quantity weight:(NSInteger)weight icon:(NSString *)icon completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    CommunityPlateModel *community = [self queryCommunityPlateWithUserID:uID boardID:boardID];
    
    BOOL needUpdate = [community.userID isEqualToString:uID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CommunityPlateModel *tCommunity = needUpdate ? [community inContext:localContext] : [CommunityPlateModel createEntityInContext:localContext];
        uID   ? tCommunity.userID = uID:uID;
        title ? tCommunity.title = title:title;
        tCommunity.weightValue = weight;
        tCommunity.quantityValue = quantity;
        tCommunity.boardIDValue = boardID;
        icon ?  tCommunity.icon = icon : icon;
        
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion){
            completion(success, nil, error);
        }
    }];
}

+ (CommunityPlateModel *)queryCommunityPlateWithUserID:(NSString *)uID boardID:(NSInteger)boardID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND boardID == %@", uID, [NSNumber numberWithInteger:boardID]];
    
    CommunityPlateModel *community = [CommunityPlateModel findFirstWithPredicate:predicate inContext:context];
    return community;
}

+(NSArray *)queryCommunityPlateListWithUserID:(NSString *)uID{
    
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", uID];
    NSArray *list = [CommunityPlateModel findAllWithPredicate:predicate inContext:context];
    return list;
}



+(void)saveAudioDataWithAudioUrl:(NSString *)audioUrl andAudioData:(NSData *)audioData
{
    //当超过5个的时候 先删除最早的一个
    
    NSInteger communityAudioModelCount = [CommunityAudioModel MR_countOfEntities];
    DLog(@"communityAudioModelCount--------------%i",communityAudioModelCount);
    
    if (communityAudioModelCount >= 5) {
        [self deleteAudioData];
    }
    
    //保存
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
       CommunityAudioModel *communityAudioModel = [CommunityAudioModel createEntityInContext:localContext];
        communityAudioModel.audioUrl = [NSString safeString:audioUrl];
        NSDate *nowDate = [NSDate date];
        communityAudioModel.createTime = nowDate;
        communityAudioModel.audioData = audioData;
    }];
    
    
}


+ (void)deleteAudioData
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    CommunityAudioModel *model = [CommunityAudioModel findFirstOrderedByAttribute:@"createTime" ascending:YES inContext:context];
    
    [model deleteEntity];
    
    [context saveToPersistentStoreAndWait];
}


+(id)queryAudioDataWithAudioUrl:(NSString *)audioUrl{
    
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"audioUrl == %@", audioUrl];
    
    CommunityAudioModel *community = [CommunityAudioModel findFirstWithPredicate:predicate inContext:context];
    
    return community;
}

@end
