//
//  CommunityDetaiModel.m
//  HelloHSK
//
//  Created by junfengyang on 14/12/9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CommunityDetaiModel.h"

@implementation CommunityDetaiModel

/*
 @property (nonatomic, copy) NSString *boardID;
 @property (nonatomic, copy) NSString *topicID;
 @property (nonatomic, copy) NSString *tag;
 @property (nonatomic, copy) NSString *tagName;
 @property (nonatomic, copy) NSString *title;
 @property (nonatomic, copy) NSString *content;
 @property (nonatomic, copy) NSString *icon;
 @property (nonatomic, copy) NSString *picture;
 @property (nonatomic, copy) NSString *audio;
 @property (nonatomic, assign) NSInteger status;
 @property (nonatomic, copy) NSString *owner;
 @property (nonatomic, assign) NSInteger liked;
 @property (nonatomic, assign) NSInteger replied;
 @property (nonatomic, assign) NSInteger posted;
 @property (nonatomic, strong) NSMutableArray *replies;

 */

- (id)copyWithZone:(NSZone *)zone
{
    CommunityDetaiModel *communityDetail = [[[self class] alloc] init];
    communityDetail.boardID = [self.boardID mutableCopyWithZone:zone];
    communityDetail.topicID = [self.topicID mutableCopyWithZone:zone];
    communityDetail.tag = [self.tag mutableCopyWithZone:zone];
    communityDetail.tagName = [self.tagName mutableCopyWithZone:zone];
    communityDetail.title = [self.title mutableCopyWithZone:zone];
    communityDetail.content = [self.content mutableCopyWithZone:zone];
    communityDetail.avatars = [self.avatars mutableCopyWithZone:zone];
    communityDetail.picture = [self.picture mutableCopyWithZone:zone];
    communityDetail.audio = [self.audio mutableCopyWithZone:zone];
    communityDetail.duration = self.duration;
    communityDetail.status = self.status;
    communityDetail.owner = [self.owner mutableCopyWithZone:zone];
    communityDetail.liked = self.liked;
    communityDetail.replied = self.replied;
    communityDetail.posted = self.posted;
    communityDetail.replies = [self.replies mutableCopyWithZone:zone];
    communityDetail.praised = self.praised;
    return communityDetail;
}

- (void)dealloc
{
    _boardID = nil;
    _topicID = nil;
    _tag     = nil;
    _tagName = nil;
    _title   = nil;
    _content = nil;
    _avatars = nil;
    _picture = nil;
    _audio   = nil;
    _owner   = nil;
    _replies = nil;
    _duration = nil;
}

@end
