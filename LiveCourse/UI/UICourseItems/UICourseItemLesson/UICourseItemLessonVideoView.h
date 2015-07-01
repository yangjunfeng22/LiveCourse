//
//  UICourseItemLessonVideoView.h
//  LiveCourse
//
//  Created by Lu on 15/1/13.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUIPlayerView.h"

@protocol UICourseItemLessonVideoViewDelegate <NSObject>

-(void)playerFullscreenStatusChange:(BOOL)isFull;

@end

@interface UICourseItemLessonVideoView : UIView

@property (weak, nonatomic) id<UICourseItemLessonVideoViewDelegate> delegate;
@property (strong, nonatomic) GUIPlayerView *playerView;


-(void)videoStartWithUrl:(NSURL *)url;

-(void)videoStop;

@end
