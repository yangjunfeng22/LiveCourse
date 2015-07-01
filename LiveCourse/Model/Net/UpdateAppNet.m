//
//  UpdateAppNet.m
//  HelloHSK
//
//  Created by yang on 14-4-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UpdateAppNet.h"
#import "UpdateAppDAL.h"

@interface UpdateAppNet ()


@end

@implementation UpdateAppNet

- (void)checkAppUpdateInfoCompletion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *url = [UpdateAppDAL getCheckAppUpdateInfoURLWithProductID:productID() version:kSoftwareVersion language:currentLanguage()];
    
    [self.requestClient postRequestFromURL:url identifier:kUpdateApp completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"推送数据 jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UpdateAppDAL parseAppUpdateInfoByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)cancelCheck
{
    [self cancelRequest];
}

@end
