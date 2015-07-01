//
//  HSCheckPointHandle.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/13.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCheckPointHandle.h"
#import "CheckPointModel.h"
#import "CheckPointNet.h"
#import "CheckPointDAL.h"
#import "UserLaterStatuModel.h"
#import "UserDAL.h"

#import "MBProgressHUD.h"

@interface HSCheckPointHandle ()

@end

@implementation HSCheckPointHandle

+ (BOOL)isDownloadedCheckPointMediaDataWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID
{
    NSString *dataDir = [kDownloadedPath stringByAppendingPathComponent:cpID];
    BOOL isDownloaded = ([[NSFileManager defaultManager] fileExistsAtPath:dataDir]) ? YES : NO;
    return isDownloaded;
}


+ (id)checkPointDataWithLessonID:(NSString *)lID
{
    return [CheckPointDAL queryCheckPointsWithLessonID:lID];
}

+ (NSInteger)countOfCheckPointLearnedWithUserID:(NSString *)uID lessonID:(NSString *)lID
{
    return [CheckPointDAL countOfCheckPointProgressWithUserID:uID lessonID:lID];
}

+ (id)checkPointLearnedInfoWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID
{
    return [CheckPointDAL queryCheckPointProgressWithUserID:uID lessonID:lID checkPointID:cpID];
}

+ (void)createCheckPointLearnedInfoWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID status:(NSInteger)status version:(NSString *)version completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    [CheckPointDAL saveCheckPointProgressWithUserID:uID CheckPointID:cpID lessonID:lID version:version progress:0 status:status completion:completion];
}

+ (void)requestCheckPointContentDataWithView:(UIView *)view net:(CheckPointNet *)net checkPoint:(id)checkPoint completion:(void (^)(BOOL, id, NSError *))completion
{
    CheckPointModel *cpModel = (CheckPointModel *)checkPoint;
    NSString *cpID = [cpModel.cpID copy];
    NSString *nexCpID = [cpModel.nexCpID copy];
    NSString *uID = [kUserID copy];
    NSString *address = [cpModel.address copy];
    LiveCourseCheckPointType type = cpModel.checkPointTypeValue;
    HSAppDelegate.curCpID = cpID;
    HSAppDelegate.nexCpID = nexCpID;
    HSAppDelegate.curCpType = type;
    
    __block MBProgressHUD *hud;
    BOOL isDownloaded = type == LiveCourseCheckPointTypeKnowledge ? YES : [HSCheckPointHandle isDownloadedCheckPointMediaDataWithUserID:uID lessonID:@"" checkPointID:cpID];
    if (!isDownloaded)
    {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载数据")];
    }
    
    // 下载数据
    [net downloadCheckPointDataWithUserID:uID checkPointID:cpID address:address completion:^(BOOL finished, id obj, NSError *error) {
        if (!isDownloaded)
        {
            NSArray *arrRela = [CheckPointDAL queryCheckPoint2ContentDataWithCheckPointID:cpID];
            NSInteger relaCount = [arrRela count];
            NSInteger contCount = [CheckPointDAL queryCheckPointContentCountWithCheckPointRelation:arrRela checkPintType:type];
            
            BOOL exist = relaCount > 0 && contCount > 0;
            
            if (exist && completion)
            {
                completion(YES, @(type), nil);
            }
            
            // 请求关系数据
            [net requestCheckPointRelationWithUserID:uID checkPointID:cpID completion:^(BOOL finished, id obj, NSError *error) {
                // 获取关卡所需数据
                [net requestCheckPointContentDataWithUserID:uID checkPointID:cpID checkPointType:type completion:^(BOOL finished, id obj, NSError *error) {
                    [hud hide:YES];
                    if (!exist && completion) {
                        completion(finished, @(type), error);
                    }
                }];
            }];
        }
        else
        {
            [hud hide:YES];
        }
    }];
    

    if (isDownloaded)
    {
        NSArray *arrRela = [CheckPointDAL queryCheckPoint2ContentDataWithCheckPointID:cpID];
        NSInteger relaCount = [arrRela count];
        NSInteger contCount = [CheckPointDAL queryCheckPointContentCountWithCheckPointRelation:arrRela checkPintType:type];
        
        BOOL exist = relaCount > 0 && contCount > 0;
        
        if (exist && completion)
        {
            completion(YES, @(type), nil);
        }
        else
        {
            hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载数据")];
        }
        
        // 请求关系数据
        [net requestCheckPointRelationWithUserID:uID checkPointID:cpID completion:^(BOOL finished, id obj, NSError *error) {
            // 获取关卡所需数据
            [net requestCheckPointContentDataWithUserID:uID checkPointID:cpID checkPointType:type completion:^(BOOL finished, id obj, NSError *error) {
                [hud hide:YES];
                if (!exist && completion) {
                    completion(finished, @(type), error);
                }
            }];
        }];
    }
}



#pragma mark - 内存管理
- (void)dealloc
{
    
}

@end
