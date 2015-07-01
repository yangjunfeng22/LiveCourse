//
//  CommunityReplyModel.m
//  HelloHSK
//
//  Created by junfengyang on 14/12/9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CommunityReplyModel.h"

@implementation CommunityReplyModel

- (id)copyWithZone:(NSZone *)zone
{
    CommunityReplyModel *communityReply = [[[self class] alloc] init];
    communityReply.topicID = [self.topicID mutableCopyWithZone:zone];
    communityReply.replyID = [self.replyID mutableCopyWithZone:zone];
    communityReply.content = [self.content mutableCopyWithZone:zone];
    communityReply.tag     = [self.tag mutableCopyWithZone:zone];
    communityReply.tagName = [self.tagName mutableCopyWithZone:zone];
    communityReply.avatars = [self.avatars mutableCopyWithZone:zone];
    communityReply.picture = [self.picture mutableCopyWithZone:zone];
    communityReply.audio   = [self.audio mutableCopyWithZone:zone];
    communityReply.duration = self.duration;
    communityReply.status  = self.status;
    communityReply.owner   = [self.owner mutableCopyWithZone:zone];
    communityReply.liked   = self.liked;
    communityReply.replied = self.replied;
    communityReply.replyTo = [self.replyTo mutableCopyWithZone:zone];
    communityReply.posted  = self.posted;
    return communityReply;
}

- (void)dealloc
{
    _topicID = nil;
    _replyID = nil;
    _content = nil;
    _tag = nil;
    _tagName = nil;
    _avatars = nil;
    _picture = nil;
    _audio = nil;
    _owner = nil;
    _replyTo = nil;
}

@end
