//
//  HSBaseNet.m
//  LiveCourse
//
//  Created by Lu on 15/1/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSBaseNet.h"


@interface HSBaseNet ()



@end


@implementation HSBaseNet


- (HttpClient *)requestClient
{
    if (!_requestClient) _requestClient = [[HttpClient alloc] init];
    return _requestClient;
}



-(void)cancelRequest{
    [self.requestClient cancelAllRequest];
}


-(void)dealloc
{
    [_requestClient cancelAllRequest];
    _requestClient=nil;
}

@end
