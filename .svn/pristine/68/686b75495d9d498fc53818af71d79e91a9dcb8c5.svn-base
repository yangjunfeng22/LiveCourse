//
//  UICourseItemLessonVideoView.m
//  LiveCourse
//
//  Created by Lu on 15/1/13.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseItemLessonVideoView.h"

#import <MediaPlayer/MediaPlayer.h>

@interface UICourseItemLessonVideoView ()<GUIPlayerViewDelegate>
{
    
}

//@property (nonatomic,strong) MPMoviePlayerController* player;
//@property (nonatomic, strong) MPMoviePlayerViewController *mvPlayer;
//@property (nonatomic, strong) UIActivityIndicatorView *activity;



@end

@implementation UICourseItemLessonVideoView
{
     NSURL *videoUrl;
}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorWhite;
        
        [self initView];
    }
    return self;
}

-(void)videoStartWithUrl:(NSURL *)url{
    videoUrl = url;
//    [self.player setContentURL:videoUrl];
//    [self.player play];
    
    [self.playerView setVideoURL:videoUrl];
    [self.playerView prepareAndPlayAutomatically:YES];
    
}

-(void)initView
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movienotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self selector:@selector(stateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

//- (void)stateChanged
//{
//    switch (self.player.playbackState) {
//        case MPMoviePlaybackStatePlaying:
//            DLog(@"播放");
//            [self.activity stopAnimating];
//            break;
//        case MPMoviePlaybackStatePaused:
//            DLog(@"暂停");
//            [self.activity startAnimating];
//            break;
//        case MPMoviePlaybackStateStopped:
//            // 执行[self.moviePlayer stop]或者前进后退不工作时会触发
//            DLog(@"停止");
//            break;
//        case MPMoviePlaybackStateInterrupted:
//            // 执行[self.moviePlayer stop]或者前进后退不工作时会触发
//            DLog(@"打断");
//            break;
//        default:
//            break;
//    }
//}
//
//-(MPMoviePlayerController *)player{
//    if (!_player) {
//        _player=[[MPMoviePlayerController alloc] init];
//        [self addSubview:_player.view];
//        //[_player setFullscreen:YES animated:YES];
//        _player.view.frame=CGRectMake(0,  0, self.width, self.width*0.7);
//        _player.view.centerY = self.height*0.4;
//        _player.repeatMode = MPMovieRepeatModeNone;
//        _player.controlStyle = MPMovieControlStyleEmbedded;
//        
//        [_player prepareToPlay];
//
//    }
//    return _player;
//}
//
//
//
//
//- (UIActivityIndicatorView *)activity
//{
//    if (!_activity)
//    {
//        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        _activity.frame = CGRectMake(0, 0, 30, 30);
//        _activity.centerX = self.player.view.width*0.5;
//        _activity.centerY = self.player.view.height*0.5;
//        _activity.hidesWhenStopped = YES;
//        _activity.userInteractionEnabled = NO;
//        [self.player.view addSubview:_activity];
//    }
//    return _activity;
//}
//
//-(void)movienotification:(id)sender{
//    if(self.player.isFullscreen){
//        self.player.contentURL =  videoUrl;
//        [self.player prepareToPlay];
//    }
//}


-(void)videoStop{
//    [self.player stop];
    [self.playerView pause];
}

- (GUIPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[GUIPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width*0.7)];
        _playerView.centerY = self.height*0.4;
        [_playerView setDelegate:self];
        
        [self addSubview:_playerView];
    }
    return _playerView;
}

#pragma mark - GUI Player View Delegate Methods

- (void)playerWillEnterFullscreen {
    
    [[self.firstViewController navigationController] setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerFullscreenStatusChange:)]) {
        [self.delegate playerFullscreenStatusChange:YES];
    }
    
}

- (void)playerWillLeaveFullscreen {
    [[self.firstViewController navigationController]setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerFullscreenStatusChange:)]) {
        [self.delegate playerFullscreenStatusChange:NO];
    }
}

- (void)playerDidEndPlaying {
    
//    [self.playerView clean];
    
}

- (void)playerFailedToPlayToEnd {
    DLog(@"Error: could not play video");
    [self.playerView clean];
}




//-(void)dealloc
//{
//    DLOG_CMETHOD;
//    _player = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    kRemoveObserverNotification(self, MPMoviePlayerPlaybackStateDidChangeNotification, nil);
//}
@end
