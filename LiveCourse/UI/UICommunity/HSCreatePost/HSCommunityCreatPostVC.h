//
//  HSCommunityCreatPostVC.h
//  LiveCourse
//
//  Created by Lu on 15/6/1.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSBaseViewController.h"


@protocol CommunityCreatPostVCDelegate <NSObject>

-(void)backToListViewAndGoToDetailViewWithTopicID:(NSString *)topicID;

@end


@interface HSCommunityCreatPostVC : HSBaseViewController

-(id)initWithPlateID:(NSInteger)plateIDStr;

@property (nonatomic, weak) id <CommunityCreatPostVCDelegate>delegate;

@end
