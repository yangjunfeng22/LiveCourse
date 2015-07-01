//
//  CourseNet.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "CourseNet.h"
#import "CourseDAL.h"

@interface CourseNet ()

@end

@implementation CourseNet

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


-(void)requestCourseListDataWithUserID:(NSString *)uID Completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *params = [CourseDAL getCourseListURLParamsWithApKey:[EncryptionHelper apKey] userID:uID language:currentLanguage() productID:productID()];
    [self.requestClient postRequestFromURL:[kLifeHostUrl stringByAppendingString:kCourseList] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"课程数据 jsonData: %@; 源数据: %@", jsonData, responseString);
        }
        
        if (jsonData) {
            [CourseDAL parseCourseListByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}


- (void)requestLessonListDataWithUserID:(NSString *)uID courseID:(NSString *)cID completion:(void (^)(BOOL, id, NSError *))completion
{

    NSString *params = [CourseDAL getLessonListURLParamsWithApKey:[EncryptionHelper apKey] userID:uID courseID:cID language:currentLanguage() productID:productID()];
    
    [self.requestClient postRequestFromURL:[kLifeHostUrl stringByAppendingString:kLessonList] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"课时数据 jsonData: %@; 源数据: %@", jsonData, responseString);
        }
        
        if (jsonData) {
            [CourseDAL parseLessonListByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)requestLessonProgressWithUserID:(NSString *)uID courseID:(NSString *)cID lessonID:(NSString *)lID records:(NSString *)records completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *params = [CourseDAL getLessonProgressURLParamsWithApKey:[EncryptionHelper apKey] userID:kUserID courseID:cID lessonID:lID records:records language:currentLanguage() productID:productID()];
    DLog(@"课时进度参数: %@", params);
    [self.requestClient postRequestFromURL:[kLifeHostUrl stringByAppendingString:kLessonProgress] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            DLog(@"课时进度数据 jsonData: %@; 原始数据: %@", jsonData, responseString);
        }
        
        if (jsonData) {
            [CourseDAL parseLessonProgressByData:jsonData completion:completion];
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
