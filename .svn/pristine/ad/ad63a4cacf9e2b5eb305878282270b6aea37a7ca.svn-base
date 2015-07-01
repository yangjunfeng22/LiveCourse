//
//  HSCommunityView.h
//  HelloHSK
//
//  Created by junfengyang on 14/12/9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityDetaiModel;

@protocol HSCommunityViewDelegate;

@interface HSCommunityView : UIView
@property (nonatomic, weak) id<HSCommunityViewDelegate>delegate;

@property (nonatomic, copy) NSString *topicID;
@property (nonatomic, strong) CommunityDetaiModel *communityDetail;
@property (nonatomic, readonly) CGFloat headerHeight;
@property (nonatomic, readonly) CGFloat footerHeight;

@end

@protocol HSCommunityViewDelegate <NSObject>

@optional
- (void)communityView:(HSCommunityView *)view didFinishLoad:(CGFloat)height;
- (void)communityView:(HSCommunityView *)view replyAction:(id)sender;
- (void)communityView:(HSCommunityView *)view finishedLaud:(NSInteger)laud;

@end
