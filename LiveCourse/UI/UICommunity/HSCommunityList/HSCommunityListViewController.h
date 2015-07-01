//
//  HSCommunityListViewController.h
//  HelloHSK
//
//  Created by Lu on 14/12/1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBaseTableViewController.h"
#import "CommunityModel.h"

@interface HSCommunityListViewController : HSBaseTableViewController

-(void)startReloadData;

//更新某个帖子
-(void)updatePostsFromTopicID:(NSString *)topicID Liked:(NSInteger)liked Replied:(NSInteger)replied;

@end
