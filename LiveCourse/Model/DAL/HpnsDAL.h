//
//  HpnsDAL.h
//  HSWordsPass
//
//  Created by Lu on 15/4/14.
//  Copyright (c) 2015年 yang. All rights reserved.
//


@interface HpnsDAL : NSObject

/**
 *  <#Description#>
 *
 *  @param code         <#code description#>
 *  @param language     <#language description#>
 *  @param device_uuid  <#device_uuid description#>
 *  @param device_name  <#device_name description#>
 *  @param device_token <#device_token description#>
 *  @param mail         <#mail description#>
 *  @param uid          <#uid description#>
 *  @param version      <#version description#>
 *  @param app_id       <#app_id description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getHpnsParamsWithCode:(NSString *)code language:(NSString *)language device_uuid:(NSString *)device_uuid device_name:(NSString *)device_name device_token:(NSString *)device_token mail:(NSString *)mail  uid:(NSString *)uid version:(NSString *)version app_id:(NSString *)app_id;

@end
