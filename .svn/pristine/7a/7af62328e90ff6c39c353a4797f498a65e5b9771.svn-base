//
//  MessageDAL.m
//  HelloHSK
//
//  Created by yang on 14-7-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "MessageDAL.h"
#import "URLUtility.h"
#import "MessageModel.h"
#import "NewsModel.h"

static MessageDAL *instance = nil;

@implementation MessageDAL
+(MessageDAL *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)dealloc
{
    instance = nil;
}

+ (NSString *)getMessageCountURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messages:(NSString *)messages language:(NSString *)language productID:(NSString *)productID
{
    email = [NSString isNullString:email] ? @"":email;
    messages =[NSString isNullString:messages] ? @"":messages;
    
    NSDictionary *dicParams = @{@"apkey":apKey, @"uID":email, @"messages":messages, @"language":language, @"productID":productID};
    return [URLUtility getURLFromParams:dicParams];
}

+ (NSString *)getMessageListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messageID:(NSString *)messageID language:(NSString *)language productID:(NSString *)productID start:(NSInteger)start length:(NSInteger)length version:(NSInteger)version messageType:(NSString *)messsageType
{
    email = [NSString isNullString:email] ? @"":email;
    messageID =[NSString isNullString:messageID] ? @"":messageID;
    
    NSDictionary *dicParams = @{@"apkey":apKey, @"uID":email, @"mid":messageID, @"language":language, @"productID":productID, @"start":@(start), @"length":@(length), @"version":@(version), @"type":messsageType};
    return [URLUtility getURLFromParams:dicParams];
}

+ (NSString *)getMessageListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID
{

    email = [NSString isNullString:email] ? @"":email;

    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"language", @"productID", nil]]];
}

+ (NSString *)getMessageContentURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messageID:(NSString *)messageID language:(NSString *)language productID:(NSString *)productID
{

    email = [NSString isNullString:email] ? @"":email;
    messageID =[NSString isNullString:messageID] ? @"":messageID;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, messageID, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"messageID", @"language", @"productID", nil]]];
}

+ (NSString *)getMessageUpdateURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messages:(NSString *)messages language:(NSString *)language productID:(NSString *)productID version:(NSInteger)version
{

    email = [NSString isNullString:email] ? @"":email;
    messages =[NSString isNullString:messages] ? @"":messages;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, messages, language, productID, [NSNumber numberWithInteger:version], nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"messages", @"language", @"productID", @"version", nil]]];
}

// 实例方法

- (NSString *)getMessageListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messageID:(NSString *)messageID language:(NSString *)language productID:(NSString *)productID start:(NSInteger)start length:(NSInteger)length version:(NSInteger)version messageType:(NSString *)messsageType
{
    email = [NSString isNullString:email] ? @"":email;
    messageID =[NSString isNullString:messageID] ? @"":messageID;
    
    NSDictionary *dicParams = @{@"apkey":apKey, @"uID":email, @"mid":messageID, @"language":language, @"productID":productID, @"start":@(start), @"length":@(length), @"version":@(version), @"type":messsageType};
    return [URLUtility getURLFromParams:dicParams];
}

- (NSString *)getMessageListURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID
{
    email = [NSString isNullString:email] ? @"":email;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"language", @"productID", nil]]];
}

- (NSString *)getMessageContentURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messageID:(NSString *)messageID language:(NSString *)language productID:(NSString *)productID
{

    email = [NSString isNullString:email] ? @"":email;
    messageID =[NSString isNullString:messageID] ? @"":messageID;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, messageID, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"messageID", @"language", @"productID", nil]]];
}

- (NSString *)getMessageUpdateURLParamsWithApKey:(NSString *)apKey email:(NSString *)email messages:(NSString *)messages language:(NSString *)language productID:(NSString *)productID version:(NSInteger)version
{

    email = [NSString isNullString:email] ? @"":email;
    messages =[NSString isNullString:messages] ? @"":messages;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, messages, language, productID, [NSNumber numberWithInteger:version], nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"messages", @"language", @"productID", @"version", nil]]];
}

#pragma mark - 解析消息数据
- (id)parseMessageListData:(id)resultData
{
    id object = nil;
    
    //NSLog(@"resultData: %@", resultData);
    
    _error = [NSError errorWithDomain:MyLocal(@"连接失败", @"") code:1 userInfo:nil];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        id results = [resultData objectForKey:@"Results"];
        
        NSInteger errorCode = success ? 0 : 1;
        //NSLog(@"errorCode: %d", errorCode);
        _error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
        if (success)
        {
            object = [self parseMessageCountResult:results];
        }
    }
    return object;
}

- (id)parseMessageCountResult:(id)resultData
{
    //NSLog(@"resultData2: %@", resultData);
    NSMutableArray *arrMessages = [[NSMutableArray alloc] initWithCapacity:3];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        id messages = [resultData objectForKey:@"Messages"];
        
        if ([messages isKindOfClass:[NSArray class]])
        {
            NSInteger count = [messages count];
            NSInteger lCount = [MessageDAL countOfMessagesWithUserID:kUserID];
            if (count > 0 && count < lCount){
                DLog(@"删除消息");
                [MessageDAL deleteMessageWithUserID:kUserID offset:(lCount - count) limit:lCount];
            }
            DLog(@"添加消息");
            // 用来给消息排序用得
            NSInteger index = 0;
            for ( NSDictionary *dicRecord in messages)
            {
                NSString *messageID = [dicRecord objectForKey:@"MessageID"];
                NSString *title     = [dicRecord objectForKey:@"Title"];
                NSString *type      = [dicRecord objectForKey:@"Type"];
                NSString *typeName  = [dicRecord objectForKey:@"TypeName"];
                NSString *icon      = [dicRecord objectForKey:@"Icon"];
                NSString *summary   = [dicRecord objectForKey:@"Summary"];
                NSString *link      = [dicRecord objectForKey:@"Link"];
                BOOL readed         = [[dicRecord objectForKey:@"Viewed"] boolValue];
                NSString *timeStamp = [dicRecord objectForKey:@"Posted"];
                NSString *targetID  = [dicRecord objectForKey:@"TargetID"];
                NSString *typeColor = [dicRecord objectForKey:@"TypeBgColor"];
                
                [MessageDAL saveUserMessageInfoWithUserID:kUserID messageID:[messageID integerValue] title:title type:type typeName:typeName icon:icon summary:summary link:link content:@"" readed:readed timeStamp:timeStamp index:index targetID:targetID typeColor:typeColor completion:nil];
                index++;
            }
        }
    }
    return arrMessages;
}

- (id)parseMessageContentData:(id)resultData
{
    id object = nil;
    
    //NSLog(@"resultData: %@", resultData);
    
    _error = [NSError errorWithDomain:MyLocal(@"连接失败") code:1 userInfo:nil];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSString *content = [resultData objectForKey:@"Content"];
        object = content;
        
        NSInteger errorCode = success ? 0 : 1;
        //NSLog(@"errorCode: %d", errorCode);
        _error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
        
    }
    return object;
}

- (id)parseMessageReadedData:(id)resultData
{
    id object = nil;
    
    //NSLog(@"resultData: %@", resultData);
    
    _error = [NSError errorWithDomain:MyLocal(@"连接失败", @"") code:1 userInfo:nil];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSInteger errorCode = success ? 0 : 1;
        //NSLog(@"errorCode: %d", errorCode);
        _error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
        
    }
    return object;
}

#pragma mark - 类方法
+ (void)parseMessageCountData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSInteger quantity = [[resultData objectForKey:@"Quantity"] integerValue];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        NSNumber *numObj = success ? [NSNumber numberWithInteger:quantity]:@0;
        if (completion) {
            completion(success, numObj, error);
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

+ (void)parseMessageListData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        id results = [resultData objectForKey:@"Results"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseMessageListResult:results completion:completion];
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

+ (void)parseMessageListResult:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    
    //NSLog(@"resultData2: %@", resultData);
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        id messages = [resultData objectForKey:@"Messages"];
        
        if ([messages isKindOfClass:[NSArray class]])
        {
            NSInteger count = [messages count];
            NSInteger lCount = [MessageDAL countOfMessagesWithUserID:kUserID];
        
            if (count > 0 && count < lCount){
                DLog(@"删除消息");
                [self deleteMessageWithUserID:kUserID offset:(lCount - count) limit:lCount];
            }
            DLog(@"添加消息");
            
            // 用来给消息排序用得
            NSInteger index = 0;
            __block NSInteger curCount = 0;
            for ( NSDictionary *dicRecord in messages)
            {
                NSString *messageID = [dicRecord objectForKey:@"MessageID"];
                NSString *title     = [dicRecord objectForKey:@"Title"];
                NSString *type      = [dicRecord objectForKey:@"Type"];
                NSString *typeName  = [dicRecord objectForKey:@"TypeName"];
                NSString *icon      = [dicRecord objectForKey:@"Icon"];
                NSString *summary   = [dicRecord objectForKey:@"Summary"];
                NSString *link      = [dicRecord objectForKey:@"Link"];
                BOOL readed         = [[dicRecord objectForKey:@"Viewed"] boolValue];
                NSString *timeStamp = [dicRecord objectForKey:@"Posted"]; // 时间戳
                NSString *targetID  = [dicRecord objectForKey:@"TargetID"];
                NSString *typeColor = [dicRecord objectForKey:@"TypeBgColor"];
                
                [self saveUserMessageInfoWithUserID:kUserID messageID:[messageID integerValue] title:title type:type typeName:typeName icon:icon summary:summary link:link content:@"" readed:readed timeStamp:timeStamp index:index targetID:targetID typeColor:typeColor completion:^(BOOL finished, id obj, NSError * error) {
                    curCount++;
                    if (curCount >= count) {
                        if (completion) {
                            completion(YES, obj, error);
                        }
                    }
                }];
                index++;
            }
        }
    }
}

+ (void)parseMessageContentData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSString *content = [resultData objectForKey:@"Content"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (completion) {
            completion(success, content, error);
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

+ (void)parseMessageReadedData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion
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

#pragma mark - 保存数据
+ (void)saveUserMessageInfoWithUserID:(NSString *)userID messageID:(NSInteger)messageID title:(NSString *)title type:(NSString *)type typeName:(NSString *)typeName icon:(NSString *)icon summary:(NSString *)summary link:(NSString *)link content:(NSString *)content readed:(BOOL)readed timeStamp:(NSString *)timeStamp index:(NSInteger)index targetID:(NSString *)targetID typeColor:(NSString *)typeColor completion:(void (^)(BOOL, id, NSError *))completion
{
    // 先查询
    MessageModel *messageModel = [MessageDAL queryUserMessageInfoWithUserID:userID messageID:messageID];
    
    BOOL needUpdate = [messageModel.userID isEqualToString:userID] && messageModel.messageIDValue == messageID;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        MessageModel *tMessageModel = needUpdate ? [messageModel inContext:localContext] : [MessageModel createEntityInContext:localContext];
        userID   ? tMessageModel.userID = userID:userID;
        tMessageModel.messageIDValue = (int32_t)messageID;
        title ? tMessageModel.title = title:title;
        type ? tMessageModel.type = type:type;
        typeName ? tMessageModel.typeName = typeName:typeName;
        icon ? tMessageModel.icon = icon:icon;
        summary ? tMessageModel.summary = summary:summary;
        link ? tMessageModel.link = link:link;
        tMessageModel.readedValue = tMessageModel.readedValue ? YES : readed;
        timeStamp ? tMessageModel.timeStamp = timeStamp:timeStamp;
        tMessageModel.indexValue = (int32_t)(index >=0 ? index:0);
        targetID ? tMessageModel.targetID = targetID:targetID;
        typeColor ? tMessageModel.typeColor = typeColor:typeColor;
    } completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}


#pragma mark - 查询消息。
// 所有的用户未读的消息
+ (NSArray *)queryAllUserUnReadMessageInfoWithUserID:(NSString *)userID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND readed == %@ AND status == 0", userID, [NSNumber numberWithBool:NO]];
    
    NSArray *arrItems = [MessageModel findAllWithPredicate:predicate inContext:localContext];
    
    return arrItems;
}

+ (NSArray *)queryAllUserMessageInfoWithUserID:(NSString *)userID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND status == 0", userID];
    
    NSArray *arrItems = [MessageModel findAllSortedBy:@"index,timeStamp" ascending:NO withPredicate:predicate inContext:localContext];
    
    return arrItems;
}

+ (id)fetchAllMessagesWithUserID:(NSString *)uID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context =[NSManagedObjectContext contextForCurrentThread];
    //自定义fetch查询
    NSFetchRequest *request = [MessageModel createFetchRequestInContext:context];
    
    //使用谓词指定查询条件。
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND status == 0", uID];
    [request setPredicate:predicate];
    // 按时间排序
    NSArray *arrSort = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO], nil];
    [request setSortDescriptors:arrSort];
    
    [request setReturnsObjectsAsFaults:NO];
    
    //指定查询偏移量
    request.fetchOffset = fetchOffset;
    request.fetchLimit = fetchLimit;
    NSArray *fetchResult = [MessageModel executeFetchRequest:request inContext:context];
    
    return fetchResult;
}

+ (id)fetchAllMessagesWithUserID:(NSString *)uID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit messageType:(NSString *)messageType
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context =[NSManagedObjectContext contextForCurrentThread];
    //自定义fetch查询
    NSFetchRequest *request = [MessageModel createFetchRequestInContext:context];
    
    //使用谓词指定查询条件。
    NSPredicate *predicate = [messageType isEqualToString:kMessageAll] ? [NSPredicate predicateWithFormat:@"userID == %@ AND status == 0", uID] : [NSPredicate predicateWithFormat:@"userID == %@ AND status == 0 AND type == %@", uID, messageType];
    [request setPredicate:predicate];
    // 按时间排序
    NSArray *arrSort = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO], nil];
    [request setSortDescriptors:arrSort];
    
    [request setReturnsObjectsAsFaults:NO];
    
    //指定查询偏移量
    request.fetchOffset = fetchOffset;
    request.fetchLimit = fetchLimit;
    NSArray *fetchResult = [MessageModel executeFetchRequest:request inContext:context];
    
    return fetchResult;
}

+ (MessageModel *)queryUserMessageInfoWithUserID:(NSString *)userID messageID:(NSInteger)messageID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND messageID == %@", userID, [NSNumber numberWithInteger:messageID]];
    
    MessageModel *messageModel = (MessageModel *)[MessageModel findFirstWithPredicate:predicate inContext:localContext];
    
    return messageModel;
}

+ (NSInteger)countOfMessagesWithUserID:(NSString *)userID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", userID];
    NSInteger count = [MessageModel countOfEntitiesWithPredicate:predicate inContext:localContext];
    
    return count;
}

+ (BOOL)deleteMessageWithUserID:(NSString *)userID offset:(NSInteger)offset limit:(NSInteger)limit
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND index >= %d", userID, offset];
    BOOL deleted = [MessageModel deleteAllMatchingPredicate:predicate inContext:localContext];
    [localContext saveToPersistentStoreAndWait];
    return deleted;
}

@end
