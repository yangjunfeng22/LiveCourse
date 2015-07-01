//
//  HSContinueLearnHandle.m
//  LiveCourse
//
//  Created by junfengyang on 15/2/10.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSContinueLearnHandle.h"
#import "UserLaterStatuModel.h"
#import "UserDAL.h"

@implementation HSContinueLearnHandle

+ (BOOL)hasContinueLearnRecords
{
    BOOL has = NO;
    UserLaterStatuModel *model = [UserDAL userLaterStatuWithUserID:kUserID courseCategoryID:kCourseCategoryID];
    //DLog(@"种类ID: %@, 继续学习: %@", kCourseCategoryID, model);
    if (model && ![NSString isNullString:model.cID] && ![NSString isNullString:model.unitID] && ![NSString isNullString:model.lID] && ![NSString isNullString:model.cpID])
    {
        has = YES;
    }
    return has;
}

+ (void)setContinueWithCategoryID:(NSString *)ccID
{
    UserLaterStatuModel *model = [UserDAL userLaterStatuWithUserID:kUserID courseCategoryID:ccID];
    if (!model)
    {
        // 不存在的话，那就自己创建一个。
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext){
            UserLaterStatuModel *tUser = [UserLaterStatuModel createEntityInContext:localContext];
            kUserID ? tUser.uID   = kUserID:@"";
            ccID ? tUser.ccID = ccID:ccID;
        }];
    }
    else
    {
        model.categoryID = ccID;
    }
}

+ (void)setContinueWithCourseID:(NSString *)cID
{
    // 所以，这里要将categoryID保存好
    UserLaterStatuModel *model = [UserDAL userLaterStatuWithUserID:kUserID courseCategoryID:kCourseCategoryID];
    if (!model)
    {
        // 不存在的话，那就自己创建一个。
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext){
            UserLaterStatuModel *tUser = [UserLaterStatuModel createEntityInContext:localContext];
            kUserID ? tUser.uID   = kUserID:@"";
            kCourseCategoryID ? tUser.ccID = kCourseCategoryID:@"";
            cID ? tUser.cID = cID:cID;
        }];
    }
    else
    {
        model.courseID = cID;
    }
}

@end
