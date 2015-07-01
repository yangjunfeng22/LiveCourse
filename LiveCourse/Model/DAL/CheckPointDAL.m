//
//  CheckPointDAL.m
//  HSWordsPass
//
//  Created by yang on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"
#import "URLUtility.h"
#import "Constants.h"
#import "CheckPoint2ContentModel.h"
#import "CheckPointTransModel.h"

void (^parseCheckPointDataCompletion)(BOOL finished, id result, NSError *error);
void (^parseCheckPointProgressDataCompletion)(BOOL finished, id result, NSError *error);

@implementation CheckPointDAL

#pragma mark - 组装请求的参数列表

#pragma mark -
+ (NSString *)getCheckPointRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID lessonID:(NSString *)lID language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    lID =[NSString isNullString:lID] ? @"":lID;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, uID, lID, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"lessonID", @"language", @"productID", nil]]];
}

+ (NSString *)getCheckPointRelationRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID checkPointID:(NSString *)cpID language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    cpID =[NSString isNullString:cpID] ? @"":cpID;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, uID, cpID, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"cpID", @"language", @"productID", nil]]];
}

+ (NSString *)getCheckPointTranslationRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID checkPointID:(NSString *)cpID language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    cpID =[NSString isNullString:cpID] ? @"":cpID;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, uID, cpID, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"cpID", @"language", @"productID", nil]]];
}

+ (NSString *)getCheckPointProgressRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID lessonID:(NSString *)lID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID version:(NSString *)version
{
    uID = [NSString isNullString:uID] ? @"":uID;
    lID =[NSString isNullString:lID] ? @"":lID;
    records = [NSString isNullString:records] ? @"":records;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":uID, @"lessonID":lID, @"records":records, @"language":language, @"productID":productID, @"version":version}];
}

+ (NSString *)getCheckPointVersionRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID checkPointID:(NSString *)cpID productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    cpID =[NSString isNullString:cpID] ? @"":cpID;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":uID, @"cpID":cpID, @"productID":productID}];
}

+ (NSString *)getDownloadCheckPointDataURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID address:(NSString *)address productID:(NSString *)productID version:(NSString *)version
{
    uID = [NSString isNullString:uID] ? @"":uID;
    address =[NSString isNullString:address] ? @"":address;
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, uID, address, productID, version, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"uID", @"url", @"productID", @"version", nil]]];
}

#pragma mark - 解析数据

#pragma mark -
#pragma mark 解关卡下载链接数据
+ (void)parseCheckPointDownloadByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    NSError *error;
    if (resultData) {
        error = [NSError errorWithDomain:MyLocal(@"获取信息成功!") code:0 userInfo:nil];
    }else{
        error = [NSError errorWithDomain:MyLocal(@"获取下载链接失败!") code:1 userInfo:nil];
    }
    
    completion(YES, [resultData objectForKey:@"Url"], error);
}

#pragma mark 解关卡列表的数据
+ (void)parseCheckPointByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];

        if (success)
        {
            [self parseCheckPointRequestResult:results completion:completion];
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

+ (void)parseCheckPointRequestResult:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    //DLOG_CMETHOD;
    if ([resultData isKindOfClass:[NSArray class]])
    {
        //parseCheckPointDataCompletion = completion;
        __block NSInteger parseCount = 0;
        NSInteger totalCount = [resultData count];
        
        //NSInteger cpCount = [self checkPointCountWithBookID:bookID];
        
        // 如果新的关卡的总数多于当前的, 那么更新即可。
        // 否则删除多余的关卡
        //if (totalCount < cpCount)
        //{
            //[self deleteAllCheckPointWithBookID:bookID];
        //}
        
        //[self deleteAllCheckPointWithLessonID:HSAppDelegate.curLID];
        
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cpid"]];
            NSString *lID  = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Lid"]];
            NSString *name = [dicRecord objectForKey:@"Name"];
            NSString *address = [dicRecord objectForKey:@"Address"];
            NSString *version = [dicRecord objectForKey:@"Version"];
            NSInteger statu = [[dicRecord objectForKey:@"Statu"] integerValue];
            NSInteger type  = [[dicRecord objectForKey:@"Type"] integerValue];
            NSInteger index = [[dicRecord objectForKey:@"Index"] integerValue];
            NSDictionary *dicTrans = [dicRecord objectForKey:@"Translation"];
            NSString *language = [dicTrans objectForKey:@"Language"];
            NSString *tName = [dicTrans objectForKey:@"Name"];
            
            [self saveCheckPointTranslationWithCheckPointID:cpID language:language name:tName completion:^(BOOL finished, id obj, NSError *error) {}];
            
            [self saveCheckPointWithCheckPointID:cpID lessonID:lID name:name index:index address:address version:version statu:statu type:type completion:^(BOOL finished, id obj, NSError *error) {
                parseCount++;
                if (parseCount >= totalCount)
                {
                    parseCount = 0;
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


#pragma mark 解关卡关系的数据
+ (void)parseCheckPointReplationByData:(id)resultData checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        
        if (success)
        {
            [self parseCheckPointRelationRequestResult:results checkPointID:cpID completion:completion];
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

+ (void)parseCheckPointRelationRequestResult:(id)resultData checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    //DLOG_CMETHOD;
    if ([resultData isKindOfClass:[NSArray class]])
    {
        __block NSInteger parseCount = 0;
        NSInteger totalCount = [resultData count];
        DLog(@"关系数据: %d", totalCount);
        // 先删除所有对应关系的数据
        [self deleteCheckPoint2ContentWithCpID:cpID];
        // 然后保存数据
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *cpID   = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cpid"]];
            NSString *coID   = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Coid"]];
            NSString *gID    = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Gid"]];
            NSInteger type   = [[dicRecord objectForKey:@"Type"] integerValue];
            NSInteger weight = [[dicRecord objectForKey:@"Weight"] integerValue];
            
            [self saveCheckPointRelationWithCheckPointID:cpID groupID:gID contentID:coID type:type weight:weight completion:^(BOOL finished, id obj, NSError *error) {
                parseCount++;
                if (parseCount >= totalCount)
                {
                    parseCount = 0;
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

#pragma mark 解关卡进度的数据
+ (void)parseCheckPointProgressByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSString *uID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Uid"]];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        
        if (success)
        {
            [self parseCheckPointProgressRequestResult:results userID:uID completion:completion];
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

+ (void)parseCheckPointProgressRequestResult:(id)resultData userID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        __block NSInteger parsePCount = 0;
        NSInteger totalPCount = [resultData count];
        
        DLog(@"进度总数：%d", totalPCount);
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cpid"]];
            NSString *lID  = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Lid"]];
            
            CGFloat progress = [[dicRecord objectForKey:@"Progress"] floatValue];
            NSInteger status = [[dicRecord objectForKey:@"Status"] integerValue];
            
            [self saveCheckPointProgressWithUserID:uID CheckPointID:cpID lessonID:lID version:@"" progress:progress status:status completion:^(BOOL finished, id obj, NSError *error) {
                parsePCount++;
                if (parsePCount >= totalPCount)
                {
                    parsePCount = 0;
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

#pragma mark 解关版本的数据
+ (void)parseCheckPointVersionByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        //NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Cpid"]];
        NSString *version = [resultData objectForKey:@"Version"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        
        if (success)
        {
            if (completion) {
                completion(success, version, error);
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
        NSError *error = [NSError errorWithDomain:MyLocal(@"数据封装出错!") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

#pragma mark - 保存数据
// 关卡的数据
+ (void)saveCheckPointWithCheckPointID:(NSString *)cpID lessonID:(NSString *)lID name:(NSString *)name index:(NSInteger)index address:(NSString *)address version:(NSString *)version statu:(NSInteger)statu type:(NSInteger)type completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND cpID == %@", lID, cpID];
        CheckPointModel *checkPoint = (CheckPointModel *)[CheckPointModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [checkPoint.cpID isEqualToString:cpID];
        
        CheckPointModel *tCheckPoint = needUpdate ? [checkPoint inContext:localContext] : [CheckPointModel createEntityInContext:localContext];
        cpID ? tCheckPoint.cpID = cpID:cpID;
        lID ? tCheckPoint.lID = lID:lID;
        name ? tCheckPoint.name = name:name;
        address ? tCheckPoint.address = address:address;
        //version ? tCheckPoint.version = version:version;
        tCheckPoint.checkPointTypeValue = (int32_t)type;
        index >= 0 ? tCheckPoint.indexValue = (int32_t)index:index;
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

// 关卡翻译的数据
+ (void)saveCheckPointTranslationWithCheckPointID:(NSString *)cpID language:(NSString *)language name:(NSString *)name completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@ AND language == %@", cpID, language];
        CheckPointTransModel *modelTrans = (CheckPointTransModel *)[CheckPointTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [modelTrans.cpID isEqualToString:cpID];
        
        CheckPointTransModel *tModelTrans = needUpdate ? [modelTrans inContext:localContext] : [CheckPointTransModel createEntityInContext:localContext];
        cpID ? tModelTrans.cpID = cpID:cpID;
        language ? tModelTrans.language = language:language;
        ![NSString isNullString:name] ? tModelTrans.name = name:name;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

// 关卡与内容关系的数据
+ (void)saveCheckPointRelationWithCheckPointID:(NSString *)cpID groupID:(NSString *)gID contentID:(NSString *)coID type:(NSInteger)type weight:(CGFloat)weight completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@ AND gID == %@ AND coID == %@", cpID, gID, coID];
        CheckPoint2ContentModel *checkPoint2Content = (CheckPoint2ContentModel *)[CheckPoint2ContentModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [checkPoint2Content.cpID isEqualToString:cpID] && [checkPoint2Content.gID isEqualToString:gID] && [checkPoint2Content.coID isEqualToString:coID];
        
        CheckPoint2ContentModel *tcheckPoint2Content = needUpdate ? [checkPoint2Content inContext:localContext] : [CheckPoint2ContentModel createEntityInContext:localContext];
        cpID ? tcheckPoint2Content.cpID = cpID:cpID;
        gID ? tcheckPoint2Content.gID   = gID:gID;
        coID ? tcheckPoint2Content.coID = coID:coID;
//        tcheckPoint2Content.typeValue   = (int32_t)type;
        tcheckPoint2Content.checkPointTypeValue = (int32_t)type;
        tcheckPoint2Content.weightValue = weight;
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}


// 关卡进度的数据
+ (void)saveCheckPointProgressWithUserID:(NSString *)uID CheckPointID:(NSString *)cpID lessonID:(NSString *)lID version:(NSString *)version progress:(CGFloat)progress status:(NSInteger)status completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@", uID, cpID];
        CheckPointProgressModel *checkPoint = (CheckPointProgressModel *)[CheckPointProgressModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [checkPoint.cpID isEqualToString:cpID] && [checkPoint.uID isEqualToString:uID];
        
        CheckPointProgressModel *tCheckPoint = needUpdate ? [checkPoint inContext:localContext] : [CheckPointProgressModel createEntityInContext:localContext];
        cpID ? tCheckPoint.cpID = cpID:cpID;
        uID ? tCheckPoint.uID = uID:uID;
        tCheckPoint.progressValue = progress >= tCheckPoint.progressValue ? progress : tCheckPoint.progressValue;
        tCheckPoint.statusValue == CheckPointLearnedStatusLocked ? tCheckPoint.statusValue = (int32_t)status:((tCheckPoint.statusValue == CheckPointLearnedStatusUnLocked && status == CheckPointLearnedStatusFinished) ? tCheckPoint.statusValue = (int32_t)status:0);
    }completion:^(BOOL success, NSError *error) {

        if (completion) {
            completion(success, nil, error);
        }
    }];
     
    /*
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@", uID, cpID];
        CheckPointProgressModel *checkPoint = (CheckPointProgressModel *)[CheckPointProgressModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [checkPoint.cpID isEqualToString:cpID] && [checkPoint.uID isEqualToString:uID];
        
        CheckPointProgressModel *tCheckPoint = needUpdate ? [checkPoint inContext:localContext] : [CheckPointProgressModel createEntityInContext:localContext];
        cpID ? tCheckPoint.cpID = cpID:cpID;
        uID ? tCheckPoint.uID = uID:uID;
        tCheckPoint.progressValue = progress >= tCheckPoint.progressValue ? progress : tCheckPoint.progressValue;
        tCheckPoint.statusValue == CheckPointLearnedStatusLocked ? tCheckPoint.statusValue = (int32_t)status:((tCheckPoint.statusValue == CheckPointLearnedStatusUnLocked && status == CheckPointLearnedStatusFinished) ? tCheckPoint.statusValue = (int32_t)status:0);
    }];
    
    if (completion) {
        completion(YES, nil, nil);
    }
     */
}

+ (NSArray *)queryCheckPointsWithLessonID:(NSString *)lID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@", lID];
    NSArray *arrModels = [CheckPointModel findAllSortedBy:@"index" ascending:YES withPredicate:predicate inContext:context];
    
    return arrModels;
}

+ (CheckPointModel *)queryCheckPointWithLessonID:(NSString *)lID checkPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND cpID == %@", lID, cpID];
    CheckPointModel *checkPoint = (CheckPointModel *)[CheckPointModel findFirstWithPredicate:predicate inContext:context];
    return checkPoint;
}

+ (id)queryCheckPointTranslationWithCheckPointID:(NSString *)cpID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@ AND language == %@", cpID, language];
    CheckPointTransModel *model = (CheckPointTransModel *)[CheckPointTransModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (CheckPointModel *)queryNextCheckPointWithLessonID:(NSString *)lID index:(NSInteger)index
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND index == %@", lID, [NSNumber numberWithInteger:index]];
    
    CheckPointModel *checkPoint = (CheckPointModel *)[CheckPointModel findFirstWithPredicate:predicate inContext:context];
    
    predicate = [NSPredicate predicateWithFormat:@"lID == %@", lID];
    NSArray *arrCp = [CheckPointModel findAllSortedBy:@"index" ascending:YES withPredicate:predicate inContext:context];
    NSInteger count = [arrCp count];
    NSInteger tIndex = [arrCp indexOfObject:checkPoint];
    if (tIndex >= 0 && tIndex < count-1){
        checkPoint = [arrCp objectAtIndex:tIndex+1];
    }
    return checkPoint;
}

+ (CheckPointModel *)queryCheckPointWithLessonID:(NSString *)lID index:(NSInteger)index
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@ AND index == %@", lID, [NSNumber numberWithInteger:index]];
    
    CheckPointModel *checkPoint = (CheckPointModel *)[CheckPointModel findFirstWithPredicate:predicate inContext:context];
    return checkPoint;
}

+ (NSInteger)checkPointCountWithLessonID:(NSString *)lID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@", lID];
    NSInteger count = [CheckPointModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

+ (BOOL)deleteAllCheckPointWithLessonID:(NSString *)lID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == %@", lID];
    BOOL deleted = [CheckPointModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

+ (BOOL)deleteAllCheckPoint
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lID == self.lID AND cpID == SELF.cpID"];
    BOOL deleted = [CheckPointModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

#pragma mark - 关卡进度数据的查询
+ (CheckPointProgressModel *)queryCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@", uID, cpID];
    CheckPointProgressModel *model = (CheckPointProgressModel *)[CheckPointProgressModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (NSInteger)countOfCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID
{
    NSInteger count = 0;
    NSArray *arrCp = [self queryCheckPointsWithLessonID:lID];
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    for (CheckPointModel *cpModel in arrCp)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@", uID, cpModel.cpID];
        count += [CheckPointProgressModel countOfEntitiesWithPredicate:predicate inContext:context];
    }
    return count;
}

+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND lID == %@", uID, lID];
    NSArray *arr = [CheckPointProgressModel findAllWithPredicate:predicate inContext:context];
    return arr;
}

+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID statu:(CheckPointLearnedStatus)statu
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND lID == %@ AND status == %@", uID, lID, @(statu)];
    NSArray *arr = [CheckPointProgressModel findAllWithPredicate:predicate inContext:context];
    return arr;
}

+ (NSInteger)queryAllCheckPointProgressCountWithUserID:(NSString *)uID lessonID:(NSString *)lID statu:(CheckPointLearnedStatus)statu
{
    NSInteger count = 0;
    NSArray *arrCp = [self queryCheckPointsWithLessonID:lID];
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    for (CheckPointModel *cpModel in arrCp)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@ AND status == %@", uID, cpModel.cpID, @(statu)];
        count += [CheckPointProgressModel countOfEntitiesWithPredicate:predicate inContext:context];
    }
    return count;
}

+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *arr = [CheckPointProgressModel findByAttribute:@"uID" withValue:uID inContext:context];
    return arr;
}

+ (BOOL)deleteAllCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND lID == %@", uID, lID];
    BOOL deleted = [CheckPointProgressModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

+ (BOOL)deleteAllCheckPointProgress
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == self.uID AND lID == SELF.lID AND cpID == self.cpID"];
    BOOL deleted = [CheckPointProgressModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

/**
 *  删除对应关系
 *
 *  @param coID 内容ID
 *
 *  @return
 */
+(BOOL)deleteCheckPoint2ContentWithCpID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
    BOOL deleted = [CheckPoint2ContentModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

/**
 *  保存对应关系
 *
 *  @param coID           <#coID description#>
 *  @param cpID           <#cpID description#>
 *  @param gID            <#gID description#>
 *  @param checkPointType <#checkPointType description#>
 */
+(void)saveCheckPoint2ContentWithCoID:(NSString *)coID Cpid:(NSString *)cpID gID:(NSString *)gID checkPointType:(LiveCourseCheckPointType)checkPointType weight:(CGFloat)weight
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        CheckPoint2ContentModel *checkPoint2ContentModel = [CheckPoint2ContentModel createEntityInContext:localContext];
        coID ? checkPoint2ContentModel.coID = coID:coID;
        cpID ? checkPoint2ContentModel.cpID = cpID:cpID;
        gID ? checkPoint2ContentModel.gID = gID:gID;
        checkPoint2ContentModel.weightValue = weight;
        [checkPoint2ContentModel setCheckPointTypeValue:checkPointType];
        
    }completion:^(BOOL success, NSError *error) {
        
    }];
}


+(NSArray *)queryConIDWIthCpID:(NSString *)cpID gID:(NSString *)gID checkPointType:(LiveCourseCheckPointType)checkPointType
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@ AND gID == %@ AND type == %@", cpID , gID , [NSNumber numberWithInteger:checkPointType]];
//    CheckPoint2ContentModel *checkPoint = (CheckPoint2ContentModel *)[CheckPoint2ContentModel findFirstWithPredicate:predicate inContext:context];
    NSArray *list = [CheckPoint2ContentModel findAllWithPredicate:predicate inContext:context];
    return list;
}

+ (id)queryCheckPoint2ContentDataWithCheckPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
    NSArray *arrCheckPoint = [CheckPoint2ContentModel findAllWithPredicate:predicate inContext:context];
    return arrCheckPoint;
}

+ (NSInteger)queryCheckPoint2ContentCountWithCheckPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
    NSInteger count = [CheckPoint2ContentModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

+ (NSInteger)queryCheckPointContentCountWithCheckPointRelation:(NSArray *)arrRelation checkPintType:(LiveCourseCheckPointType)type
{
    NSInteger count = 0;
    switch (type) {
        case LiveCourseCheckPointTypeWord:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self queryWordWithWordID:cp2Co.coID];
                if (model) {
                    count++;
                }
            }
            break;
        }
        case LiveCourseCheckPointTypeSentence:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self querySentenceWithSentenceID:cp2Co.coID];
                if (model) {
                    count++;
                }
            }
            break;
        }
        case LiveCourseCheckPointTypeLesson:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self queryLessonTextWithTextID:cp2Co.coID];
                if (model) {
                    count++;
                }
            }
            break;
        }
        case LiveCourseCheckPointTypeKnowledge:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self queryKnowledgeDataWithKID:cp2Co.coID];
                if (model) {
                    count++;
                }
            }
            break;
        }
        case LiveCourseCheckPointTypeTest:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self queryExamDataWithEID:cp2Co.coID];
                if (model) {
                    count++;
                }
            }
            break;
        }
            
        default:
            break;
    }
    return count;
}

+ (id)queryCheckPointContentDataListWithCheckPointID:(NSString *)cpID checkPointType:(LiveCourseCheckPointType)type
{
    NSMutableArray *arrList = [[NSMutableArray alloc] initWithCapacity:2];
    NSArray *arrRelation = [self queryCheckPoint2ContentDataWithCheckPointID:cpID];
    if ([arrRelation count] <= 0) return arrList;
    
    switch (type)
    {
        case LiveCourseCheckPointTypeWord:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self queryWordWithWordID:cp2Co.coID];
                if (model) {
                    [arrList addObject:model];
                }
            }
            break;
        }
        case LiveCourseCheckPointTypeSentence:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self querySentenceWithSentenceID:cp2Co.coID];
                if (model) {
                    [arrList addObject:model];
                }
            }
            break;
        }
        case LiveCourseCheckPointTypeLesson:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self queryLessonTextWithTextID:cp2Co.coID];
                if (model) {
                    [arrList addObject:model];
                }
            }
            break;
        }
        case LiveCourseCheckPointTypeKnowledge:
        {
        
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self queryKnowledgeDataWithKID:cp2Co.coID];
                if (model) {
                    [arrList addObject:model];
                }
            }
            break;
        }
        case LiveCourseCheckPointTypeTest:
        {
            for (CheckPoint2ContentModel *cp2Co in arrRelation)
            {
                id model = [self queryExamDataWithEID:cp2Co.coID];
                if (model) {
                    [arrList addObject:model];
                }
            }
            break;
        }
            
        default:
            break;
    }
    
    return arrList;
}

+ (id)aggregateCheckPoint2ContentDataWithCheckPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
    NSArray *arrCheckPoint = [CheckPoint2ContentModel MR_aggregateOperation:@"count:" onAttribute:@"coID" withPredicate:predicate groupBy:@"gID" inContext:context];
    return arrCheckPoint;
}

+ (NSInteger)countOfCheckPoint2ContentDataWithCheckPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
    NSInteger count = [CheckPoint2ContentModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

@end

#pragma mark - Content

#import "WordModel.h"
#import "WordTransModel.h"
#import "Word2SentenceModel.h"
#import "SentenceModel.h"
#import "SentenceTransModel.h"
#import "TextModel.h"
#import "TextTransModel.h"

#pragma mark Word
@implementation CheckPointDAL (Word)

#pragma mark - 组装请求的参数列表
#pragma mark -
+ (NSString *)getCheckPointContentURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID checkPointID:(NSString *)cpID language:(NSString *)language productID:(NSString *)productID
{
    uID = [NSString isNullString:uID] ? @"":uID;
    cpID = [NSString isNullString:cpID] ? @"":cpID;
    
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":uID, @"cpID":cpID, @"language":language, @"productID":productID}];
}


#pragma mark - 解析数据
#pragma mark -

#pragma mark 解关卡内容的词汇数据
+ (void)parseCheckPointContentWordByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        if (success)
        {
            [self parseCheckPintContentWordDetail:results completion:completion];
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

+ (void)parseCheckPintContentWordDetail:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        __block NSInteger count = 0;
        NSInteger totalCount = [resultData count];
        //DLog(@"词汇数据: %d", totalCount);
        // 再保存数据
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *wID      = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Wid"]];
            NSString *gID      = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Gid"]];
            NSString *chinese  = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Chinese"]];
            NSString *pinyin   = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Pinyin"]];
            NSString *property = [dicRecord objectForKey:@"Property"];
            NSString *audio    = [dicRecord objectForKey:@"Audio"];
            NSString *picture  = [dicRecord objectForKey:@"Picture"];
            CGFloat weight     = [[dicRecord objectForKey:@"Weight"] floatValue];
            
            // 保存词
            [self saveWordDataWithWordID:wID groupID:gID chinese:chinese pinyin:pinyin property:property audio:audio picture:picture weight:weight completion:^(BOOL finished, id obj, NSError *error) {
                count++;
                if (count >= totalCount) {
                    if (completion) {
                        completion(finished, nil, error);
                    }
                }
            }];
            
            // 词的翻译
            NSDictionary *dicTrans = [dicRecord objectForKey:@"Translation"];
            NSString *language = [dicTrans objectForKey:@"Language"];
            
            NSString *tChinese = [[NSString alloc] initWithFormat:@"%@", [dicTrans objectForKey:@"Chinese"]];
            NSString *tProperty = [[NSString alloc] initWithFormat:@"%@", [dicTrans objectForKey:@"Property"]];
            DLog(@"词性的翻译: %@; 翻译: %@", tProperty, tChinese);
            // 保存词的翻译
            [self saveWordTranslationDataWordID:wID language:language chinese:tChinese property:tProperty completion:^(BOOL finished, id obj, NSError *error) {}];
            
            // 先删除词-句子的对应关系。
            //[self deleteWord2SentenceWithWordID:wID];
            // 词所带的句子
            NSArray *arrSentence = [dicRecord objectForKey:@"Sentences"];
            for (NSDictionary *dicSentence in arrSentence)
            {
                DLog(@"句子: %@", dicSentence);
                NSString *sID     = [[NSString alloc] initWithFormat:@"%@", [dicSentence objectForKey:@"Sid"]];
                NSString *chinese = [dicSentence objectForKey:@"Chinese"];
                NSString *pinyin  = [dicSentence objectForKey:@"Pinyin"];
                NSString *audio   = [dicSentence objectForKey:@"Audio"];
                NSString *picture = [dicSentence objectForKey:@"Picture"];
                CGFloat weight    = [[dicSentence objectForKey:@"Weight"] floatValue];
                
                // 保存词的句子
                [self saveSentenceWithSID:sID groupID:nil chinese:chinese picture:picture pinyin:pinyin audio:audio weight:weight mode:0 tChinese:nil tPinyin:nil completion:^(BOOL finished, id obj, NSError *error) {}];
                
                // 保存词-句子的关系
                [self saveWord2SentenceDataWordID:wID sentenceID:sID completion:^(BOOL finished, id obj, NSError *error) {}];
                // 句子的翻译
                NSDictionary *dicTrans = [dicSentence objectForKey:@"Translation"];
                NSString *language = /*currentLanguage();//*/[dicTrans objectForKey:@"Language"];
                NSString *tChinese = [dicTrans objectForKey:@"Chinese"];
                
                //保存句子的翻译
                [self saveSentenceTransWithSID:sID language:language chinese:tChinese completion:^(BOOL finished, id obj, NSError *error) {}];
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



#pragma mark - 保存数据
#pragma mark -
+ (void)saveWordDataWithWordID:(NSString *)wID groupID:(NSString *)gID chinese:(NSString *)chinese pinyin:(NSString *)pinyin property:(NSString *)property audio:(NSString *)audio picture:(NSString *)picture weight:(CGFloat)weight completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@", wID];
        WordModel *model = (WordModel *)[WordModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [model.wID isEqualToString:wID];
        
        WordModel *tModel = needUpdate ? [model inContext:localContext] : [WordModel createEntityInContext:localContext];
        wID? tModel.wID = wID:wID;
        gID ? tModel.gID = gID:gID;
        chinese ? tModel.chinese = chinese:chinese;
        pinyin ? tModel.pinyin = pinyin:pinyin;
        property ? tModel.property = property:property;
        audio ? tModel.audio = audio:audio;
        picture ? tModel.picture = picture:picture;
        tModel.weightValue = weight;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}


+ (void)saveWordTranslationDataWordID:(NSString *)wID language:(NSString *)language chinese:(NSString *)chinese property:(NSString *)property completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@ AND language == %@", wID, language];
        WordTransModel *modelTrans = (WordTransModel *)[WordTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [modelTrans.wID isEqualToString:wID];
        
        WordTransModel *tModelTrans = needUpdate ? [modelTrans inContext:localContext] : [WordTransModel createEntityInContext:localContext];
        wID ? tModelTrans.wID = wID:wID;
        language ? tModelTrans.language = language:language;
        ![NSString isNullString:chinese] ? tModelTrans.chinese = chinese:chinese;
        ![NSString isNullString:property] ? tModelTrans.property = property:property;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}


+ (void)saveWord2SentenceDataWordID:(NSString *)wID sentenceID:(NSString *)sID completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@ AND sID == %@", wID, sID];
        Word2SentenceModel *model = (Word2SentenceModel *)[Word2SentenceModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [model.wID isEqualToString:wID];
        
        Word2SentenceModel *tModel = needUpdate ? [model inContext:localContext] : [Word2SentenceModel createEntityInContext:localContext];
        wID ? tModel.wID = wID:wID;
        sID ? tModel.sID = sID:sID;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}



#pragma mark - 删除数据
+ (BOOL)deleteWord2SentenceWithWordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@", wID];
    BOOL deleted = [Word2SentenceModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

#pragma mark - 查询数据
+ (id)queryWordWithWordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@", wID];
    WordModel *model = [WordModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (id)queryWordTransWithWordID:(NSString *)wID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@ AND language == %@", wID, language];
    WordTransModel *model = [WordTransModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (id)queryWord2SentenceWithWordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@", wID];
    Word2SentenceModel *model = [Word2SentenceModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

@end

#pragma mark - Sentence
@implementation CheckPointDAL (Sentence)
#pragma mark - 解析数据
// 关卡内容的句子数据
+ (void)parseCheckPointContentSentenceByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        if (success)
        {
            [self parseCheckPintContentSentenceDetail:results completion:completion];
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

+ (void)parseCheckPintContentSentenceDetail:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        __block NSInteger count = 0;
        NSInteger totalCount = [resultData count];
        
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *sID      = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Sid"]];
            NSString *gID      = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Gid"]];
            NSString *chinese  = [dicRecord objectForKey:@"Chinese"];
            NSString *pinyin   = [dicRecord objectForKey:@"Pinyin"];
            NSString *audio    = [dicRecord objectForKey:@"Audio"];
            NSString *picture  = [dicRecord objectForKey:@"Picture"];
            CGFloat weight     = [[dicRecord objectForKey:@"Weight"] floatValue];
            NSInteger mode     = [[NSString safeString:[dicRecord objectForKey:@"Mode"]] integerValue];
            NSString *qChinese = [dicRecord objectForKey:@"TChinese"];
            NSString *qPinyin  = [dicRecord objectForKey:@"TPinyin"];
            
            // 保存句子
            [self saveSentenceWithSID:sID groupID:gID chinese:chinese picture:picture pinyin:pinyin audio:audio weight:weight mode:mode tChinese:qChinese tPinyin:qPinyin completion:^(BOOL finished, id obj, NSError *error) {
                count++;
                if (count >= totalCount) {
                    completion(finished, obj, error);
                }
            }];
            
            // 句子的翻译
            NSDictionary *dicTrans = [dicRecord objectForKey:@"Translation"];
            NSString *language = /*currentLanguage();//*/[dicTrans objectForKey:@"Language"];
            NSString *tChinese = [dicTrans objectForKey:@"Chinese"];
            
            // 保存句子的翻译
            [self saveSentenceTransWithSID:sID language:language chinese:tChinese completion:^(BOOL finished, id obj, NSError *error) {}];
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
//保存例句
+ (void)saveSentenceWithSID:(NSString *)sID groupID:(NSString *)gID chinese:(NSString *)chinese picture:(NSString *)picture pinyin:(NSString *)pinyin audio:(NSString *)audio weight:(float)weight mode:(NSInteger)mode tChinese:(NSString *)tChinese tPinyin:(NSString *)tPinyin completion:(void (^)(BOOL, id, NSError *))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@", sID];
        SentenceModel *sentenceModel = (SentenceModel *)[SentenceModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [sentenceModel.sID isEqualToString:sID];
        
        SentenceModel *tSentenceModel = needUpdate ? [sentenceModel inContext:localContext] : [SentenceModel createEntityInContext:localContext];
        
        sID ? tSentenceModel.sID = sID:sID;
        gID ? tSentenceModel.gID = gID:gID;
        chinese ? tSentenceModel.chinese = chinese : chinese;
        picture ? tSentenceModel.picture = picture:picture;
        pinyin ? tSentenceModel.pinyin = pinyin:pinyin;
        audio ? tSentenceModel.audio = audio:audio;
        tSentenceModel.weightValue = weight;
        tSentenceModel.modeValue = (int32_t)mode;
        tChinese ? tSentenceModel.qChinese = tChinese:tChinese;
        tPinyin ? tSentenceModel.qPinyin = tPinyin:tPinyin;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+(void)saveSentenceTransWithSID:(NSString *)sID language:(NSString *)language chinese:(NSString *)chinese completion:(void (^)(BOOL, id, NSError *))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@ AND language == %@", sID,language];
        SentenceTransModel *sentenceTransModel = (SentenceTransModel *)[SentenceTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [sentenceTransModel.sID isEqualToString:sID];
        
        SentenceTransModel *tSentenceTransModel = needUpdate ? [sentenceTransModel inContext:localContext] : [SentenceTransModel createEntityInContext:localContext];
        sID ? tSentenceTransModel.sID = sID:sID;
        language ? tSentenceTransModel.language = language : language;
        ![NSString isNullString:chinese] ? tSentenceTransModel.chinese = chinese:chinese;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

#pragma mark - 查询数据
+ (id)querySentenceWithSentenceID:(NSString *)sID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@", sID];
    SentenceModel *model = [SentenceModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (id)querySentenceTransWithSentenceID:(NSString *)sID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@ language == %@", sID, language];
    SentenceTransModel *model = [SentenceTransModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

@end

#pragma mark - Text
@implementation CheckPointDAL (Text)
#pragma mark - 解析数据
+(void)parseLessonTextByCpID:(NSString *)cpID Data:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Result"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        if (success)
        {
            [self parseTextDetail:results cpID:(NSString *)cpID completion:completion];
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

+ (void)parseTextDetail:(id)resultData cpID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        
        NSString *tID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Tid"]];
        NSString *background    = [resultData objectForKey:@"Background"];
        NSString *chinese  = [resultData objectForKey:@"Chinese"];
        NSString *pinyin  = [resultData objectForKey:@"Pinyin"];
        NSString *audio  = [resultData objectForKey:@"Audio"];
        NSString *vedio  = [resultData objectForKey:@"Video"];
        NSString *picture  = [resultData objectForKey:@"Picture"];
        
        NSDictionary *dicTrans = [resultData objectForKey:@"Translation"];
        
        NSString *language = /*currentLanguage();//*/[dicTrans objectForKey:@"Language"];
        NSString *tChinese = [dicTrans objectForKey:@"Chinese"];
        NSString *tBackground = [dicTrans objectForKey:@"Background"];
        
        //保存翻译
        [self saveTextTranslationDataTID:tID language:language chinese:tChinese backGround:tBackground completion:^(BOOL finished, id obj, NSError *error) {}];
        
        [self saveTextDataWithTID:tID background:background chinese:chinese pinyin:pinyin audio:audio vedio:vedio picture:picture completion:^(BOOL finished, id obj, NSError *error) {
            
            if (completion) {
                completion(YES,nil,error);
            }
        }];
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
+ (void)saveTextDataWithTID:(NSString *)tID background:(NSString *)background chinese:(NSString *)chinese pinyin:(NSString *)pinyin audio:(NSString *)audio vedio:(NSString *)vedio picture:(NSString *)picture completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tID == %@", tID];
        TextModel *textModel = (TextModel *)[TextModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [textModel.tID isEqualToString:tID];
        
        TextModel *tTextModel = needUpdate ? [textModel inContext:localContext] : [TextModel createEntityInContext:localContext];
        
        tID? tTextModel.tID = tID:tID;
        background ? tTextModel.background = background:background;
        chinese ? tTextModel.chinese = chinese:chinese;
        pinyin ? tTextModel.pinyin = pinyin:pinyin;
        audio ? tTextModel.audio = audio:audio;
        vedio ? tTextModel.vedio = vedio:vedio;
        picture ? tTextModel.picture = picture:picture;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (void)saveTextTranslationDataTID:(NSString *)tID language:(NSString *)language chinese:(NSString *)chinese backGround:(NSString *)backGround completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tID == %@ AND language == %@", tID, language];
        TextTransModel *textTransModel = (TextTransModel *)[TextTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [textTransModel.tID isEqualToString:tID] && [textTransModel.language isEqualToString:language];
        
        TextTransModel *tTextTransModel = needUpdate ? [textTransModel inContext:localContext] : [TextTransModel createEntityInContext:localContext];
        tID ? tTextTransModel.tID = tID:tID;
        language ? tTextTransModel.language = language:language;
        chinese ? tTextTransModel.chinese = chinese:chinese;
        backGround ? tTextTransModel.background = backGround : backGround;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (id)queryLessonTextWithTextID:(NSString *)tID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tID == %@", tID];
    TextModel *model = [TextModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (id)queryLessonTextTranslationWithTextID:(NSString *)tID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tID == %@ AND language == %@", tID, language];
    TextTransModel *model = [TextTransModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (id)queryLessonTextWithCheckPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    CheckPoint2ContentModel *cp2Co = [[self queryCheckPoint2ContentDataWithCheckPointID:cpID] firstObject];

    return [self queryLessonTextWithTextID:cp2Co.coID];;
}

@end

#pragma mark - Knowledge
#import "KnowledgeModel.h"
#import "KnowledgeTransModel.h"
#import "GrammarModel.h"
#import "GrammarTransModel.h"
#import "SentenceDAL.h"
#import "Knowledge2SentenceModel.h"
#import "Grammar2SentenceModel.h"
#import "Knowledge2GrammarModel.h"
@implementation CheckPointDAL (Knowledge)
#pragma mark - 解析数据
+(void)parseKnowledgeByData:(id)resultData cpID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion{
    
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
            [self parseKnowledgeDetail:results cpID:cpID completion:completion];
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


+ (void)parseKnowledgeDetail:(id)resultData cpID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        
        __block NSInteger count = 0;
        NSInteger totalCount = [resultData count];
        
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *kID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Kid"]];
            
            NSString *title    = [dicRecord objectForKey:@"Title"];
            NSString *quote  = [dicRecord objectForKey:@"Quote"];
            NSString *qpinyin  = [dicRecord objectForKey:@"Qpinyin"];
            NSString *description  = [dicRecord objectForKey:@"Description"];
            CGFloat weight     = [[dicRecord objectForKey:@"Weight"] floatValue];
            
            NSDictionary *translation = [dicRecord objectForKey:@"Translation"];
            NSString *language = /*currentLanguage();//*/[translation objectForKey:@"Language"];
            NSString *tTitle = [translation objectForKey:@"Title"];
            NSString *tQuote = [translation objectForKey:@"Quote"];
            NSString *tDescription = [translation objectForKey:@"Description"];
            
            //保存语法
            [self saveGrammarWithKID:kID GrammarArray:[dicRecord objectForKey:@"Grammar"]];
            
            //保存例句
            [self saveSentenceWithKID:(NSString *)kID SentenceArray:[dicRecord objectForKey:@"Sentences"]];
            
            //保存翻译
            [self saveKnowledgeTranslationDataKID:kID language:language quote:tQuote explain:tDescription title:tTitle completion:^(BOOL finished, id obj, NSError *error) {
            }];
            
            //保存知识点数据
            [self saveKnowledgeDataWithKID:kID quote:quote quotePinyin:qpinyin title:title weight:weight explain:description completion:^(BOOL finished, id obj, NSError *error) {
                
                count++;
                if (count >= totalCount){
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


#pragma mark - 保存数据

#pragma mark 知识点
+ (void)saveKnowledgeDataWithKID:(NSString *)kID quote:(NSString *)quote quotePinyin:(NSString *)quotePinyin title:(NSString *)title  weight:(float)weight explain:(NSString *)explain completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kID == %@", kID];
        KnowledgeModel *knowledgeModel = (KnowledgeModel *)[KnowledgeModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [knowledgeModel.kID isEqualToString:kID];
        
        KnowledgeModel *tKnowledgeModel = needUpdate ? [knowledgeModel inContext:localContext] : [KnowledgeModel createEntityInContext:localContext];
        kID? tKnowledgeModel.kID = kID:kID;
        quote ? tKnowledgeModel.quote = quote:quote;
        quotePinyin ? tKnowledgeModel.quotePinyin = quotePinyin:quotePinyin;
        title ? tKnowledgeModel.title = title:title;
        tKnowledgeModel.weightValue = weight;
        tKnowledgeModel.explain = [NSString safeString:explain];
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

#pragma mark 知识点翻译
+ (void)saveKnowledgeTranslationDataKID:(NSString *)kID language:(NSString *)language quote:(NSString *)quote explain:(NSString *)explain title:(NSString *)title completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kID == %@ AND language == %@", kID, language];
        KnowledgeTransModel *knowledgeTransModel = (KnowledgeTransModel *)[KnowledgeTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [knowledgeTransModel.kID isEqualToString:kID] && [knowledgeTransModel.language isEqualToString:language];
        
        KnowledgeTransModel *tKnowledgeTransModel = needUpdate ? [knowledgeTransModel inContext:localContext] : [KnowledgeTransModel createEntityInContext:localContext];
        kID ? tKnowledgeTransModel.kID = kID:kID;
        language ? tKnowledgeTransModel.language = language:language;
        tKnowledgeTransModel.quote = [NSString safeString:quote];
        tKnowledgeTransModel.explain = [NSString safeString:explain];
        tKnowledgeTransModel.title = [NSString safeString:title];
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
    
}

#pragma mark 语法数组
+(void)saveGrammarWithKID:(NSString *)kID GrammarArray:(NSArray *)grammarArray
{
    for (NSDictionary  *dicRecord in grammarArray) {
        NSString *gID = [NSString stringWithFormat:@"%@",[dicRecord objectForKey:@"Gid"]] ;
        NSString *explain = [dicRecord objectForKey:@"Description"];
        
        [self saveGrammarWithGID:gID explain:explain];
        
        NSDictionary *dic = [dicRecord objectForKey:@"Translation"];
        
        NSString *language = /*currentLanguage();//*/[dic objectForKey:@"Language"];
        NSString *tExplain = [dic objectForKey:@"Description"];
        
        [self saveKnowledge2GrammarModelWithGID:gID kID:kID];
        
        [self saveGrammarTraWithGID:gID language:language explain:tExplain];
    }
}

#pragma mark 保存语法描述和知识点对应关系
+(void)saveKnowledge2GrammarModelWithGID:(NSString *)gID kID:(NSString *)kid{
    [self deleteKnowledge2GrammarWithKID:kid];
    
    [self saveKnowledge2GrammarWithKID:kid gID:gID];
}

#pragma mark 保存语法知识点对应关系
+(void)saveKnowledge2GrammarWithKID:(NSString *)kID gID:(NSString *)gID{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Knowledge2GrammarModel *knowledge2SentenceModel = [Knowledge2GrammarModel createEntityInContext:localContext];
        kID ? knowledge2SentenceModel.kID = kID:kID;
        gID ? knowledge2SentenceModel.gID = gID:gID;
        
    }completion:^(BOOL success, NSError *error) {
        
    }];
}



#pragma mark 保存语法

+(void)saveGrammarWithGID:(NSString *)gID explain:(NSString *)explain
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gID == %@", gID];
        GrammarModel *grammarModel = (GrammarModel *)[GrammarModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [grammarModel.gID isEqualToString:gID];
        
        GrammarModel *tGrammarModel = needUpdate ? [grammarModel inContext:localContext] : [GrammarModel createEntityInContext:localContext];
        gID ? tGrammarModel.gID = gID:gID;
        explain ? tGrammarModel.explain = explain:explain;
        
        
    }completion:^(BOOL success, NSError *error) {
        
    }];
}

#pragma mark 保存语法翻译
+(void)saveGrammarTraWithGID:(NSString *)gID language:(NSString *)language explain:(NSString *)explain
{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gID == %@ AND language == %@", gID,language];
        GrammarTransModel *grammarTransModel = (GrammarTransModel *)[GrammarTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [grammarTransModel.gID isEqualToString:gID];
        
        GrammarTransModel *tGrammarTransModel = needUpdate ? [grammarTransModel inContext:localContext] : [GrammarTransModel createEntityInContext:localContext];
        gID ? tGrammarTransModel.gID = gID:gID;
        language ? tGrammarTransModel.language = language : language;
        explain ? tGrammarTransModel.explain = explain:explain;
        
    }completion:^(BOOL success, NSError *error) {
        
    }];
}

#pragma mark 保存例句数组

+(void)saveSentenceWithKID:(NSString *)kID SentenceArray:(NSArray *)sentenceArray
{
    //如果为空 则保存到Knowledge2SentenceModel中
    [self deleteKnowledge2SentenceWithKID:kID];
    NSMutableArray *grammarIDArray = [NSMutableArray arrayWithCapacity:2];
    
    for (NSDictionary *dicRecord in sentenceArray)
    {
        NSString *sID = [NSString stringWithFormat:@"%@",[dicRecord objectForKey:@"Sid"]];
        NSString *chinese = [dicRecord objectForKey:@"Chinese"];
        NSString *pinyin = [dicRecord objectForKey:@"Pinyin"];
        NSString *audio = [dicRecord objectForKey:@"Audio"];
        NSString *picture = [dicRecord objectForKey:@"Picture"];
        CGFloat weight = [[dicRecord objectForKey:@"Weight"] floatValue];
        
        NSString *grammarID = [NSString stringWithFormat:@"%@",[dicRecord objectForKey:@"GrammarID"]];
        
        //保存例句
        //[SentenceDAL saveSentenceWithSID:sID chinese:chinese picture:picture pinyin:pinyin audio:audio weight:weight];
        [self saveSentenceWithSID:sID groupID:nil chinese:chinese picture:picture pinyin:pinyin audio:audio weight:weight mode:0 tChinese:nil tPinyin:nil completion:^(BOOL finished, id obj, NSError *error) {}];
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [dicRecord objectForKey:@"Translation"]];
        NSString *language = /*currentLanguage();//*/[dic objectForKey:@"Language"];
        NSString *tChinese = [dic objectForKey:@"Chinese"];
        
        //保存翻译
        //[SentenceDAL saveSentenceTransWithSID:sID language:language chinese:tChinese];
        [self saveSentenceTransWithSID:sID language:language chinese:tChinese completion:^(BOOL finished, id obj, NSError *error) {}];
        
        //保存对应关系
        if ([NSString isNullString:grammarID] || [grammarID isEqualToString:@"0"] || [grammarID isEqualToString:@"(null)"]) {

            [self saveKnowledge2SentenceWithKID:kID sID:sID];
            
        }
        else
        {
            //否则保存到Grammar2SentenceModel中
            
            //如果已经删了就不要再删
            if (![grammarIDArray containsObject:grammarID]) {
                [self deleGrammar2SentenceWithGID:grammarID];
                [grammarIDArray addObject:grammarID];
            }
            [self saveGrammar2SentenceWithGID:grammarID sID:sID];
        }
    }
}


#pragma mark 保存知识点例句对应关系

+(void)saveKnowledge2SentenceWithKID:(NSString *)kID sID:(NSString *)sID{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Knowledge2SentenceModel *knowledge2SentenceModel = [Knowledge2SentenceModel createEntityInContext:localContext];
        kID ? knowledge2SentenceModel.kID = kID:kID;
        sID ? knowledge2SentenceModel.sID = sID:sID;
        
    }completion:^(BOOL success, NSError *error) {
        
    }];
}

#pragma mark 保存语法例句对应关系
+(void)saveGrammar2SentenceWithGID:(NSString *)gID sID:(NSString *)sID
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Grammar2SentenceModel *grammar2SentenceModel = [Grammar2SentenceModel createEntityInContext:localContext];
        gID ? grammar2SentenceModel.gID = gID:gID;
        sID ? grammar2SentenceModel.sID = sID:sID;
        
    }completion:^(BOOL success, NSError *error) {
        
    }];
    
}

#pragma mark - 删除数据

#pragma mark 删除知识点语法描述对应关系
+(BOOL)deleteKnowledge2GrammarWithKID:(NSString *)kID{
    
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kID == %@", kID];
    BOOL deleted = [Knowledge2GrammarModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

#pragma mark 删除知识点例句对应关系

+(BOOL)deleteKnowledge2SentenceWithKID:(NSString *)kID{
    
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kID == %@", kID];
    BOOL deleted = [Knowledge2SentenceModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}


#pragma mark 删除语法例句对应关系
+(BOOL)deleGrammar2SentenceWithGID:(NSString *)gID{
    
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gID == %@", gID];
    BOOL deleted = [Grammar2SentenceModel deleteAllMatchingPredicate:predicate inContext:context];
    [context saveToPersistentStoreAndWait];
    return deleted;
}

#pragma mark - 查询数据

+(NSArray *)querySentenceNoGrammarWithKID:(NSString *)kID
{
    //先查询出sid数据
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kID == %@", kID];
    
    NSArray *list = [Knowledge2SentenceModel findAllWithPredicate:predicate inContext:context];
    
    NSMutableArray *sentenceFullArray = [NSMutableArray arrayWithCapacity:2];
    
    for (Knowledge2SentenceModel *knowledge2SentenceModel in list) {
        NSString *sID = knowledge2SentenceModel.sID;
        
        //根据查询出来的sid 查询出对应的例句
        NSArray *sentenceArray = [SentenceDAL querySentenceListWithSID:sID];
        
        [sentenceFullArray addObjectsFromArray:sentenceArray];
    }
    
    return sentenceFullArray;
}

+ (NSDictionary *)querySentenceHasGrammarWithKID:(NSString *)kID{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    
    //先查询出Knowledge2GrammarModel中得gid
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kID == %@", kID];
    
    NSArray *list = [Knowledge2GrammarModel findAllWithPredicate:predicate inContext:context];
    
    //根据gid搜索出对应的sentence
    for (Knowledge2GrammarModel *knowledge2GrammarModel in list) {
        
        NSString *gID = knowledge2GrammarModel.gID;
        //根据gid查询出garmmar数据
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"gID == %@", gID];
        GrammarModel *grammarModel = [GrammarModel findFirstWithPredicate:predicate1 inContext:context];
        
        //根据gid查询出对应的sid
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"gID == %@", gID];
        NSArray *sIDArray = [Grammar2SentenceModel findAllWithPredicate:predicate2 inContext:context];
        
        for (Grammar2SentenceModel *grammar2SentenceModel in sIDArray) {
            NSString *sID = grammar2SentenceModel.sID;
            
            //根据查询出来的sid 查询出对应的例句
            NSArray *sentenceArray = [SentenceDAL querySentenceListWithSID:sID];
            
            [dic setObject:sentenceArray forKey:grammarModel.explain];
        }
    }
    
    return dic;
}

+(NSArray *)queryKnowledgeDataWithcpID:(NSString *)cpID
{
    //先再关系表中查询出对应的内容ID
    NSArray *chekPoint2conModelArray = [CheckPointDAL queryCheckPoint2ContentDataWithCheckPointID:cpID];
    
    NSMutableArray *knowModelArray = [NSMutableArray arrayWithCapacity:2];
    
    for (CheckPoint2ContentModel * checkPoint2ContentModel in chekPoint2conModelArray) {
        NSString *kID = checkPoint2ContentModel.coID;
        
        //查询测试题
        KnowledgeModel *exModel = [self queryKnowledgeDataWithKID:kID];
        
        [knowModelArray addObject:exModel];
    }
    
    return knowModelArray;
}


+(id)queryKnowledgeDataWithKID:(NSString *)kID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kID == %@", kID];
    KnowledgeModel *model = [KnowledgeModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+(id)queryKnowledgeTranslationWithKID:(NSString *)kID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kID == %@ AND language == %@", kID, language];
    KnowledgeTransModel *wordTran = (KnowledgeTransModel *)[KnowledgeTransModel findFirstWithPredicate:predicate inContext:context];
    return wordTran;
}

@end

#pragma mark - Exam
#import "ExamModel.h"
#import "ExamTransModel.h"
#import "PracticeRecordModel.h"
@implementation CheckPointDAL (Exam)

+ (NSString *)getPracticeRecordURLParamsWithApKey:(NSString *)apKey userID:(NSString *)userID record:(NSString *)record language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:@{@"apkey":apKey, @"uID":userID, @"records":record, @"language":language, @"productID":productID}];
}

#pragma mark - 解析数据
+(void)parseFinalTestByData:(id)resultData cpID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        if (success)
        {
            [self parseDetail:results cpID:(NSString *)cpID completion:completion];
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



+ (void)parseDetail:(id)resultData cpID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        
        //删除子类
        [self deleteSonDataWithCpID:cpID];
        __block NSInteger count = 0;
        NSInteger totalCount = [resultData count];
        
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *eID             = [NSString stringWithFormat:@"%@",[NSString safeString:[dicRecord objectForKey:@"Eid"]]] ;

            NSString *answer          = [NSString safeString:[dicRecord objectForKey:@"Answer"]];
            NSString *audio           = [NSString safeString:[dicRecord objectForKey:@"Audio"]];
            CGFloat category          = [[NSString safeString:[dicRecord objectForKey:@"Category"]] floatValue];
            NSString *image           = [NSString safeString:[dicRecord objectForKey:@"Image"]];
            NSString *items           = [NSString safeString:[dicRecord objectForKey:@"Items"]];
            CGFloat level             = [[NSString safeString:[dicRecord objectForKey:@"Level"]] floatValue];
            NSString * parent         = [NSString stringWithFormat:@"%@",[NSString safeString:[dicRecord objectForKey:@"Parent"]]] ;
            NSString *question        = [NSString safeString:[dicRecord objectForKey:@"Question"]];
            CGFloat status            = [[NSString safeString:[dicRecord objectForKey:@"Status"]] floatValue];
            NSString *subject         = [NSString safeString:[dicRecord objectForKey:@"Subject"]] ;
            NSString *subjectFormat   = [NSString safeString:[dicRecord objectForKey:@"SubjectFormat"]];
            CGFloat time              = [[NSString safeString:[dicRecord objectForKey:@"Time"]] floatValue];
            NSString *title           = [NSString safeString:[dicRecord objectForKey:@"Title"]];
            CGFloat total             = [[NSString safeString:[dicRecord objectForKey:@"Total"]] floatValue];
            NSString *type            = [NSString safeString:[dicRecord objectForKey:@"Type"]];
            NSString *typeAlias       = [NSString safeString:[dicRecord objectForKey:@"TypeAlias"]];
            CGFloat weight            = [[NSString safeString:[dicRecord objectForKey:@"Weight"]] floatValue];

            NSDictionary *translation = [dicRecord objectForKey:@"Translation"];
            NSString *tLanguage = [NSString safeString:[translation objectForKey:@"Language"]];
            NSString *tTypeAlias      = [NSString safeString:[translation objectForKey:@"TypeAlias"]];
            //NSLog(@"测试的翻译数据: %@", translation);
            
            [self saveFinalTestTranslationDataEID:eID language:tLanguage tTypeAlias:tTypeAlias completion:^(BOOL finished, id obj, NSError *error) {
                
            }];
            
            [self saveFinalTestDataWithEID:eID answer:answer audio:audio category:category image:image items:items level:level parent:parent question:question status:status subject:subject subjectFormat:subjectFormat time:time title:title total:total type:type typeAlias:typeAlias weight:weight completion:^(BOOL finished, id obj, NSError *error) {
                
                count++;
                if (count >= totalCount){
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


+ (void)parsePracticeRecordByData:(id)data completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[data objectForKey:@"Success"] boolValue];
        NSString *message = [data objectForKey:@"Message"];
        id results = [data objectForKey:@"Result"];
        
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:success userInfo:nil];
        
        if ([results integerValue]) {
            
            // 同步成功之后，删除旧的数据记录。
            [NSManagedObjectContext clearNonMainThreadContextsCache];
            NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", kUserID];
            [PracticeRecordModel deleteAllMatchingPredicate:predicate inContext:context];
            [context saveToPersistentStoreAndWait];
        }
        // 回调
        if (completion) {
            completion(success, results, error);
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
+ (void)saveFinalTestDataWithEID:(NSString *)eID answer:(NSString *)answer audio:(NSString *)audio category:(CGFloat)category image:(NSString *)image items:(NSString *)items  level:(CGFloat)level parent:(NSString *)parent question:(NSString *)question status:(CGFloat)status subject:(NSString *)subject  subjectFormat:(NSString *)subjectFormat time:(CGFloat)time title:(NSString *)title total:(CGFloat)total type:(NSString *)type typeAlias:(NSString *)typeAlias weight:(CGFloat)weight completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eID == %@", eID];
        ExamModel *examModel = (ExamModel *)[ExamModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [examModel.eID isEqualToString:eID];
        
        ExamModel *tExamModel = needUpdate ? [examModel inContext:localContext] : [ExamModel createEntityInContext:localContext];
        
        eID? tExamModel.eID = eID:eID;
        answer ? tExamModel.answer = answer:answer;
        audio ? tExamModel.audio = audio:audio;
        tExamModel.categoryValue = category;
        image ? tExamModel.image = image:image;
        items ? tExamModel.items = items:items;
        tExamModel.levelValue = level;
        parent ? tExamModel.parentID = parent:parent;
        question ? tExamModel.question = question:question;
        tExamModel.statusValue = status;
        subject ? tExamModel.subject = subject:subject;
        subjectFormat ? tExamModel.subjectFormat = subjectFormat:subjectFormat;
        tExamModel.timeValue = time;
        title ? tExamModel.title = title:title;
        tExamModel.totalValue = total;
        type ? tExamModel.type = type:type;
        typeAlias ? tExamModel.typeAlias = typeAlias:typeAlias;
        tExamModel.weightValue = weight;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

// 保存翻译
+ (void)saveFinalTestTranslationDataEID:(NSString *)eID language:(NSString *)language tTypeAlias:(NSString *)tTypeAlias completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eID == %@ AND language == %@", eID, language];
        ExamTransModel *examTransModel = (ExamTransModel *)[ExamTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [examTransModel.eID isEqualToString:eID] && [examTransModel.language isEqualToString:language];
        
        ExamTransModel *tExamTransModel = needUpdate ? [examTransModel inContext:localContext] : [ExamTransModel createEntityInContext:localContext];
        eID ? tExamTransModel.eID = eID:eID;
        language ? tExamTransModel.language = language:language;
        tTypeAlias ? tExamTransModel.typeAlias = tTypeAlias:tTypeAlias;
        
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (void)savePracticeRecordWithUserID:(NSString *)userID courseCategoryID:(NSString *)courseCategoryID courseID:(NSString *)courseID lessonID:(NSString *)lessonID topicID:(NSString *)topicID rightTimes:(NSInteger)rightTimes wrongTimes:(NSInteger)wrongTimes result:(NSInteger)result answer:(NSString *)answer completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND courseCategoyID == %@ AND courseID == %@ AND lessonID == %@ AND topicID == %@", userID, courseCategoryID, courseID, lessonID, topicID];
        PracticeRecordModel *practiceRecord = (PracticeRecordModel *)[PracticeRecordModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = practiceRecord && [practiceRecord.userID isEqualToString:userID];
        
        PracticeRecordModel *tPracticeRecord = needUpdate ? [practiceRecord inContext:localContext] : [PracticeRecordModel createEntityInContext:localContext];
        userID ? tPracticeRecord.userID = userID:userID;
        courseCategoryID ? tPracticeRecord.courseCategoyID = courseCategoryID:courseCategoryID;
        courseID ? tPracticeRecord.courseID = courseID:courseID;
        lessonID ? tPracticeRecord.lessonID = lessonID:lessonID;
        topicID ? tPracticeRecord.topicID = topicID:topicID;
        rightTimes > 0 ? tPracticeRecord.rightTimesValue = (int32_t)rightTimes : rightTimes;
        wrongTimes > 0 ? tPracticeRecord.wrongTimesValue = (int32_t)wrongTimes : wrongTimes;
        tPracticeRecord.resultValue = (int32_t)result;
        answer ? tPracticeRecord.answer = answer:answer;
        tPracticeRecord.timeStamp = timeStamp();
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

#pragma mark - 删除数据

//删除子类
+ (void)deleteSonDataWithCpID:(NSString *)cpID
{
    //先查询出对应关系中得父类
    NSArray *list = [NSArray arrayWithArray:[CheckPointDAL queryCheckPoint2ContentDataWithCheckPointID:cpID]] ;
    for (CheckPoint2ContentModel *checkPoint2ContentModel in list)
    {
        NSString *parentID = checkPoint2ContentModel.coID;
        //删除子类
        [NSManagedObjectContext clearNonMainThreadContextsCache];
        NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentID == %@", parentID];
        [ExamModel deleteAllMatchingPredicate:predicate inContext:context];
        [context saveToPersistentStoreAndWait];
    }
}

#pragma mark - 查询数据
//arc4random()

+(NSArray *)queryFinalTestDataWithcpID:(NSString *)cpID{
    //先再关系表中查询出对应的内容ID
    NSArray *eIDArray = [CheckPointDAL queryConIDWIthCpID:cpID gID:@"0" checkPointType:LiveCourseCheckPointTypeTest];
    
    NSMutableArray *exModelArray = [NSMutableArray arrayWithCapacity:2];
    
    for (CheckPoint2ContentModel * checkPoint2ContentModel in eIDArray)
    {
        NSString *eID = checkPoint2ContentModel.coID;
        //查询测试题
        ExamModel *exModel = [self queryExamDataWithEID:eID];
        
        [exModelArray addObject:exModel];
    }
    return exModelArray;
}

+(id)queryExamDataWithEID:(NSString *)eID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
//    eID = @"21582";//21495
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eID == %@", eID];
    ExamModel *model = [ExamModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+(id)queryExamTranslationWithEID:(NSString *)eID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eID == %@ AND language == %@", eID, language];
    ExamTransModel *model = [ExamTransModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+(NSArray *)queryFinalTestSonDataWithParentID:(NSString *)parentID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentID == %@", parentID];
    NSArray *list = [ExamModel findAllSortedBy:@"weight,eID" ascending:YES withPredicate:predicate inContext:context];
    return list;
}

+ (NSArray *)queryPracticeRecordsWithUserID:(NSString *)userID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", userID];
    NSArray *list = [PracticeRecordModel findAllWithPredicate:predicate inContext:context];
    return list;
}

+ (id)queryPracticeRecordWithUserID:(NSString *)userID courseCategoryID:(NSString *)courseCategoryID courseID:(NSString *)courseID lessonID:(NSString *)lessonID topicID:(NSString *)topicID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND courseCategoyID == %@ AND courseID == %@ AND lessonID == %@ AND topicID == %@", userID,courseCategoryID,courseID,lessonID,topicID];
    id obj = [PracticeRecordModel findFirstWithPredicate:predicate inContext:context];
    return obj;
}

@end