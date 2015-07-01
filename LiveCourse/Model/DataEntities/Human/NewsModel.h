//
//  NewsModel.h
//  HelloHSK
//
//  Created by yang on 14-7-22.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, readwrite) BOOL readed;
@property (nonatomic, readwrite) NSInteger messageID;

- (BOOL)isLink;

@end
