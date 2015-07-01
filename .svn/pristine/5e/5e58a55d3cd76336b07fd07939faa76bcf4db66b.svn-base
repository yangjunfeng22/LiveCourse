//
//  HpnsDAL.m
//  HSWordsPass
//
//  Created by Lu on 15/4/14.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import "HpnsDAL.h"
#import "URLUtility.h"

@implementation HpnsDAL

+(NSString *)getHpnsParamsWithCode:(NSString *)code language:(NSString *)language device_uuid:(NSString *)device_uuid device_name:(NSString *)device_name device_token:(NSString *)device_token mail:(NSString *)mail uid:(NSString *)uid version:(NSString *)version app_id:(NSString *)app_id
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:code, language,device_uuid, device_name,device_token,mail,uid,version,app_id,nil] forKeys:[NSArray arrayWithObjects:@"code", @"language",@"device_uuid" ,@"device_name",@"device_token",@"mail",@"uid",@"version",@"app_id",nil]]];
}

@end
