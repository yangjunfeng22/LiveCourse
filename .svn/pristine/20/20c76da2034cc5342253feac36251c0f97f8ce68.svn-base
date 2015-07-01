//
//  CommunityAudioBtn.h
//  LiveCourse
//
//  Created by Lu on 15/5/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityAudioBtn;

@protocol CommunityAudioBtnDelegate <NSObject>

@optional
- (void)communityAudioBtnDelegateDidStartPlaying:(CommunityAudioBtn *)voiceBubble;

- (void)communityAudioBtnDelegateDidEndPlaying:(CommunityAudioBtn *)voiceBubble;


@end



@interface CommunityAudioBtn : UIView

@property (nonatomic, weak) id <CommunityAudioBtnDelegate> delegate;

@property (nonatomic,assign) NSInteger duration;
@property (nonatomic, copy) NSString *audioUrl;


@property (readonly, getter=isPlaying) BOOL playing;

@property (nonatomic, assign) BOOL isCache;//是否做缓存 默认为no


-(void)playOrStop;

- (void)playAction;
- (void)stopAction;

- (void)startAnimating;
- (void)stopAnimating;

@end
