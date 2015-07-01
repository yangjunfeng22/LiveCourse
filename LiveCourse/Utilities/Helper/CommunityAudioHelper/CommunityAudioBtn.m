//
//  CommunityAudioBtn.m
//  LiveCourse
//
//  Created by Lu on 15/5/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "CommunityAudioBtn.h"
#import <AVFoundation/AVFoundation.h>
#import "CommunityDAL.h"
#import "CommunityAudioModel.h"

#define minWidth 60

@interface CommunityAudioBtn ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton *audioBtn;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIImageView *trumpetImageView;    //喇叭

@property (nonatomic, strong) UIActivityIndicatorView *activityView;//菊花

@end

@implementation CommunityAudioBtn
{
    CGFloat maxWidth;
    CGFloat handleWidthSec;//以多少秒数为最长宽度计算
    
    NSData *audioData;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.trumpetImageView.right = self.width - 5;
    
    self.audioBtn.frame = self.bounds;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAction];
    }
    return self;
}

-(void)initAction{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioStop:) name:KAudioShouldStopNotification object:nil];
    
    maxWidth = self.width;
    if (self.width < minWidth) {
        self.width = minWidth;
        maxWidth = minWidth;
    }
    handleWidthSec = 60;
    audioData = nil;
    
    self.isCache = NO;
    
}


-(void)dealloc{
    _audioPlayer = nil;
    _audioUrl = nil;
    [self handleNotification:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KAudioShouldStopNotification object:nil];
}


#pragma mark - action

-(void)setDuration:(NSInteger)duration{
 
    NSString *durationStr = [self timeFormatted:duration];
    self.durationLabel.text = [NSString stringWithFormat:@"%@",durationStr];
    
    [self.durationLabel sizeToFit];
    self.durationLabel.centerY = self.height/2;
    
    //自己计算长度
    CGFloat tempWidth = (duration/handleWidthSec) * maxWidth;
    
    if (tempWidth >= maxWidth) {
        self.width = maxWidth;
    }
    else if(tempWidth < minWidth)
    {
        self.width = minWidth;
    }else{
        self.width = tempWidth;
    }
}

-(void)setAudioUrl:(NSString *)audioUrl{
    
    if (![_audioUrl isEqualToString:audioUrl]) {
        _audioUrl = audioUrl;
    }
}


- (BOOL)isPlaying
{
    return _audioPlayer.isPlaying;
}


-(void)audioBtnClick:(id)sender
{
    self.audioBtn.enabled = NO;
    if (self.trumpetImageView.isAnimating) {
        DLog(@"当前正在播放  暂停");
        [self stopAction];
        self.audioBtn.enabled = YES;
    }else{
        
        CommunityAudioModel *communityAudioModel = [CommunityDAL queryAudioDataWithAudioUrl:self.audioUrl];
        NSData *searchAudioData = communityAudioModel.audioData;
        if (searchAudioData) {
            audioData = searchAudioData;
        }
        if (audioData) {
            DLog(@"有数据 直接播放");
            
            self.audioBtn.enabled = YES;
            
//            [self initAudioPlayer];
            
            [self playOrStop];
            
        }else{
            
            [self activityViewPlay];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //        _asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:self.audioUrl]  options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];
                //
                //        CMTime duration = _asset.duration;
                //        NSInteger seconds = CMTimeGetSeconds(duration);
                //        if (seconds > 60) {
                //            NSLog(@"A voice audio should't last longer than 60 seconds");
                //            _contentURL = nil;
                //            _asset = nil;
                //            return;
                //        }
                audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.audioUrl]];
                if (!audioData) {
                    
                    DLog(@"下载不到数据");
                    self.audioBtn.enabled = YES;
                    [self activityViewStop];
                    
                    return;
                }
                
                if (self.isCache) {
                    [CommunityDAL saveAudioDataWithAudioUrl:self.audioUrl andAudioData:audioData];
                }
                
//                [self initAudioPlayer];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //            NSString *secondsStr = [NSString stringWithFormat:@"%@\"",@(seconds)];
                    
                    NSString *imageSize = [HSBaseTool formattedFileSize:[audioData length]];
                    
                    DLog(@"imageSize--------------------------%@",imageSize);
                    
                    [self activityViewStop];
                    
                    [self playOrStop];
                    
                    self.audioBtn.enabled = YES;
                });
            });
        }
    }
}



-(void)playOrStop{
    if (self.audioPlayer.isPlaying && self.trumpetImageView.isAnimating) {
        DLog(@"playOrStop--------暂停");
        [self stopAction];
    }else{
        DLog(@"将之前的全部暂停");
        [[NSNotificationCenter defaultCenter] postNotificationName:KAudioShouldStopNotification object:nil];
        
        [self initAudioPlayer];
        
        [self playAction];
    }
    
}

-(void)playAction{
    DLog(@"播放");
    if (!self.audioPlayer.isPlaying) {
        [self.audioPlayer play];
        [self startAnimating];
        
        // 阻止锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(communityAudioBtnDelegateDidStartPlaying:)]) {
            [self.delegate communityAudioBtnDelegateDidStartPlaying:self];
        }
    }
}

-(void)stopAction{
    DLog(@"暂停");
    // 还原锁屏
    
    [self handleNotification:NO];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KAudioShouldStopNotification object:nil];
}


-(void)audioStop:(NSNotification *)notification
{
    if (_audioPlayer.isPlaying || self.trumpetImageView.isAnimating) {
        
        DLog(@"通知-----用来关闭音频");
        
        [self handleNotification:NO];
        
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0;
        [self stopAnimating];
        
        // 还原锁屏
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(communityAudioBtnDelegateDidEndPlaying:)]) {
            [self.delegate communityAudioBtnDelegateDidEndPlaying:self];
        }
    }
}

#pragma mark - 传感器

-(void)initAudioPlayer{
    
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [self handleNotification:YES];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:NULL];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
}

- (void)handleNotification:(BOOL)state
{
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state];
    
    if(state){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}


-(void)sensorStateChange:(NSNotificationCenter *)notification{
    if ([[UIDevice currentDevice] proximityState] == YES) {
        DLog(@"贴近了耳朵");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        DLog(@"没有贴近耳朵");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!self.playing) {
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}





- (void)startAnimating
{
    if (!self.trumpetImageView.isAnimating) {
        [self.trumpetImageView startAnimating];
    }
}

- (void)stopAnimating
{
    if (self.trumpetImageView.isAnimating) {
        [self.trumpetImageView stopAnimating];
    }
}


-(void)activityViewPlay{
    self.trumpetImageView.hidden = YES;
    
    [self.activityView startAnimating];
}

-(void)activityViewStop{
    self.trumpetImageView.hidden = NO;
    
    [self.activityView stopAnimating];
}



- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    if (minutes <= 0) {
        return [NSString stringWithFormat:@"%d\"", seconds];
    }
    
    int hours = totalSeconds / 3600;
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%d\'%d\"", minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%d:%d:%d",hours, minutes, seconds];
    }
}


#pragma mark - delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    DLog(@"播放完成");
    [self.trumpetImageView stopAnimating];
    
    [self handleNotification:NO];
    
    // 还原锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityAudioBtnDelegateDidEndPlaying:)]) {
        [self.delegate communityAudioBtnDelegateDidEndPlaying:self];
    }
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
}



#pragma mark - UI

-(UIButton *)audioBtn{
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _audioBtn.backgroundColor = RGB(196, 242, 177);
        _audioBtn.layer.borderColor = RGB(68, 197, 20).CGColor;
        _audioBtn.layer.borderWidth = 0.5f;
        _audioBtn.layer.cornerRadius = 10;
        _audioBtn.layer.masksToBounds = YES;
        [_audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_audioBtn];
    }
    return _audioBtn;
}

-(UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width, self.height)];
        _durationLabel.textColor = kColorWord;
        _durationLabel.backgroundColor = kColorClear;
        _durationLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self.audioBtn addSubview:_durationLabel];
    }
    return _durationLabel;
}

-(UIImageView *)trumpetImageView{
    if (!_trumpetImageView) {
        _trumpetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        
        _trumpetImageView.image = [UIImage imageNamed:@"audio_icon_1"];
        
        _trumpetImageView.right = self.width;
        _trumpetImageView.centerY = self.height/2;
        
        [self.audioBtn addSubview:_trumpetImageView];
        
        UIImage *image0 = [UIImage imageNamed:@"audio_icon_0"];
        UIImage *image1 = [UIImage imageNamed:@"audio_icon_1"];
        UIImage *image2 = [UIImage imageNamed:@"audio_icon_2"];
        
        _trumpetImageView.animationImages = @[image0,image1,image2];
        _trumpetImageView.animationDuration = 1.0f;
    }
    return _trumpetImageView;
}


-(UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _activityView.center = self.trumpetImageView.center;
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.audioBtn addSubview:_activityView];
    }
    return _activityView;
}

@end
