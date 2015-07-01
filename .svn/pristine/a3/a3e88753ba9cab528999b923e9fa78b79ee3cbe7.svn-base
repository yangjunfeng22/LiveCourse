//
//  KeyBoardVoiceManageView.m
//  LiveCourse
//
//  Created by Lu on 15/6/3.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "KeyBoardVoiceManageView.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "CircleView.h"
#import "KeyboardVoiceHud.h"

#define WAVE_UPDATE_FREQUENCY   0.1

#define minWidth 60


#pragma mark - KeyBoardVoiceManageView
@interface KeyBoardVoiceManageView ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) UIButton *pressOnToVoiceBtn;      //按住说话
@property (nonatomic, strong) UIButton *switchToclickBtn;       //切换为点击录音

@property (nonatomic, strong) UIButton *clickToVoiceBtn;        //点击录音
@property (nonatomic, strong) UILabel *clickToVoiceLabel;       //点击文字
@property (nonatomic, strong) UILabel *timeLabel;               //时间
@property (nonatomic, strong) UIButton *switchToPressOnBtn;     //切换为按住说话


@property (nonatomic, strong) UIButton *audioBtn;               //音频显示
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIImageView *trumpetImageView;    //喇叭

@property (nonatomic, strong) UIButton *reRecordVoice;          //重录

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;       //音频

@property (nonatomic, strong) CircleView *circleView;

@property (nonatomic, strong) KeyboardVoiceHud *voiceHud;

@end



#pragma mark - KeyBoardVoiceManageView;
@implementation KeyBoardVoiceManageView
{
    AVAudioRecorder *audioRecorder;
    NSURL *url;
    NSURL *mp3Url;
    NSData *audioData;
    
    NSTimer * timer;
    
    CGFloat recordTime;

    CGFloat maxWidth;
    
    CGFloat handleWidthSec;//以多少秒数为最长宽度计算
    
    BOOL isPressOnStatus;//是否是长按
    
    CGFloat timeLabelWidth;
    
    BOOL isUserStopRecord;   //是否是用户主动停止
    BOOL isRecordTimeOut;   //是否时间到了

}

-(id)init{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 115)];
    
    if (self) {
        
        self.backgroundColor = kColorBackgroundD0;
        
        [self initAction];
        
    }
    return self;
}


#pragma mark - Action

-(void)initAction{
    isPressOnStatus = YES;
    self.pressOnToVoiceBtn.backgroundColor = kColorWhite;
    self.switchToclickBtn.backgroundColor = kColorClear;
    
    self.clickToVoiceBtn.backgroundColor = kColorLine3;
    self.timeLabel.backgroundColor = kColorDarkOrange;
    self.clickToVoiceLabel.backgroundColor = kColorClear;
    
    self.switchToPressOnBtn.backgroundColor = kColorClear;
    
    url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Documents/MySound.caf", NSHomeDirectory()]];
    
    mp3Url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Documents/MySound.mp3", NSHomeDirectory()]];
    
    maxWidth = self.width*0.6;
    handleWidthSec = 60;
    self.audioBtn.hidden = YES;
}


//切换成点击录音
-(void)switchToclickBtnClick:(id)sender
{
    [self switchVoiceRecodeMode:NO];
    isPressOnStatus = NO;
}

-(void)switchToPressOnBtnClick:(id)sender{
    [self switchVoiceRecodeMode:YES];
    isPressOnStatus = YES;
}

/**
 *  切换录音模式
 *
 *  @param isPressOn 是否切换成按住说话
 */
-(void)switchVoiceRecodeMode:(BOOL)isPressOn{
    
    //切换之前 先停止掉之前的录音
    [self recordCancel:nil];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (!isPressOn) {
            //切换为点击录音
            self.clickToVoiceBtn.hidden = NO;
            self.switchToPressOnBtn.hidden = NO;
            self.clickToVoiceLabel.hidden = NO;
//            self.timeLabel.hidden = NO;
            
            self.pressOnToVoiceBtn.hidden = YES;
            self.switchToclickBtn.hidden = YES;
            
        }else{
            //切换为按住说话
            
            self.pressOnToVoiceBtn.hidden = NO;
            self.switchToclickBtn.hidden = NO;
            
            self.clickToVoiceBtn.hidden = YES;
            self.clickToVoiceLabel.hidden = YES;
            self.switchToPressOnBtn.hidden = YES;
            self.timeLabel.hidden = YES;
        }
    }];
}



//长按录音
-(void)pressOnToVoiceBtnClick:(id)sender
{
    [self.voiceHud show];
    
    [self startRecording:sender];
}

//点击录音
-(void)clickToVoiceBtnClick:(id)sender
{
    if (![audioRecorder isRecording]) {
        DLog(@"--开始录音");
        [UIView animateWithDuration:0.2f animations:^{
            self.clickToVoiceBtn.backgroundColor = HEXCOLOR(0x4fcb19);
            self.clickToVoiceLabel.text = MyLocal(@"点击停止");
            self.timeLabel.hidden = NO;
        }];
        
        [self startRecording:nil];
    }
    else{
        DLog(@"--停止录音");
        [self recordEnd:nil];
    }
}




//开始录音
-(void)startRecording:(id)sender
{
    DLog(@"--------录音开始");
    audioRecorder = nil;
    recordTime = 0;
    isUserStopRecord = NO;
    isRecordTimeOut = NO;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        DLog(@"--%@------%@",error.domain,[[error userInfo] description]);
        return;
    }
    
    
    NSMutableDictionary *recordSetting = [NSMutableDictionary dictionary];
    
    //采样率
    [recordSetting setObject:[NSNumber numberWithFloat:22000] forKey:AVSampleRateKey];//44100
    
    //通道的数目 1单声道 2立体声
    [recordSetting setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    //采样位数 默认16
    [recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    //大字节还是小字节
    [recordSetting setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    
    //采样信号是整数还是浮点数
    [recordSetting setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    //音频质量
    [recordSetting setObject:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    DLog(@"%@------------------",url);
    
    error = nil;
    
    //先看是否存在 存在则删除
    NSData *oldAudioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&error];
    
    if (oldAudioData) {
        //存在了
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&error];
        
        if (error) {
            DLog(@"-------------%@",error.domain);
        }
    }
    
    error = nil;
    
    //存在则停止
    if (audioRecorder) {
        [audioRecorder stop];
        audioRecorder = nil;
    }
    
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    
    audioRecorder.delegate = self;
    
    audioRecorder.meteringEnabled = YES;
    
    [audioRecorder prepareToRecord];
    
    //时间限制
    if (self.maxRecodeTime && self.maxRecodeTime > 5) {
        [audioRecorder recordForDuration:self.maxRecodeTime];
    }else{
        [audioRecorder recordForDuration:120];
    }
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}



- (void)audio_PCMtoMP3
{
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:[mp3Url path] error:nil])
    {
        NSLog(@"删除旧音频文件");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([[url path] cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([[mp3Url path] cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22000);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:MyLocal(@"音频格式转化失败")];
        [alert bk_setCancelButtonWithTitle:MyLocal(@"确定") handler:nil];
        [alert show];
    }
    @finally {
        
         NSLog(@"音频格式转换成功");
        
        [self showVoice];
    }
}



//录制完成后显示
-(void)showVoice{
    //将其余按钮先隐藏
    
    audioData = [NSData dataWithContentsOfURL:mp3Url];
    
    DLog(@"音频大小------%@---------时长---- %f",[HSBaseTool formattedFileSize:[audioData length]],recordTime);
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardVoiceManageVoiceSelectedDelegate:andDuration:)]) {
        [self.delegate keyBoardVoiceManageVoiceSelectedDelegate:audioData andDuration:recordTime];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
       
        self.clickToVoiceBtn.hidden = YES;
        self.switchToPressOnBtn.hidden = YES;
        self.pressOnToVoiceBtn.hidden = YES;
        self.switchToclickBtn.hidden = YES;
        self.clickToVoiceLabel.hidden = YES;
        self.timeLabel.hidden = YES;
    } completion:^(BOOL finished) {
    
        NSString *durationStr = [HSBaseTool timeFormatted:recordTime];
        
        self.audioBtn.hidden = NO;
        
        self.durationLabel.text = durationStr;
        [self.durationLabel sizeToFit];
        self.durationLabel.centerY = self.audioBtn.height/2;
        
        
        //自己计算长度
        CGFloat tempWidth = (recordTime/handleWidthSec) * maxWidth;
        
        if (tempWidth >= maxWidth) {
            self.audioBtn.width = maxWidth;
        }
        else if(tempWidth < minWidth)
        {
            self.audioBtn.width = minWidth;
        }else{
            self.audioBtn.width = tempWidth;
        }
        self.audioBtn.centerX = self.width/2;
        
        self.trumpetImageView.right = self.audioBtn.width;
        
        self.reRecordVoice.left = self.audioBtn.right + 10;
        
        self.reRecordVoice.hidden = NO;
    }];
}



-(void)reRecordVoiceClick:(id)sender
{
    UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:MyLocal(@"重录会删除刚才的录音")];
    
    [alert bk_setCancelButtonWithTitle:MyLocal(@"取消") handler:nil];
    
    [alert bk_addButtonWithTitle:MyLocal(@"重录") handler:^{
        [self renewStatus];
    }];
    
    [alert show];
}




-(void)recordEnd:(id)sender
{
    //如果是自动停止  则不继续处理
    if (isRecordTimeOut) {
        return;
    }
    
    DLog(@"录音结束");
    
    UIButton *btn = (UIButton *)sender;
    
    btn.enabled = NO;
    
    isUserStopRecord = YES;
    
    if ([self isRecordIng]) {
        if (recordTime < 1) {
            
            if (self.voiceHud.isShow) {
                [self.voiceHud setHintLabelText:MyLocal(@"录音时间太短")];
                [self hideVoiceHud:sender];
            }
            [self recordCancel:sender];
        }else{
            [audioRecorder stop];
            
            [self resetTimer];
            
            [self audio_PCMtoMP3];
            
            [self hideVoiceHud:sender];
            
            btn.enabled = YES;
        }
        if (!isPressOnStatus) {
            [UIView animateWithDuration:0.2f animations:^{
                self.clickToVoiceBtn.backgroundColor = kColorLine3;
                self.clickToVoiceLabel.text = MyLocal(@"点击录音");
            }];
        }
    }
}


-(void)recordCancel:(id)sender
{
    //如果是自动停止  则不继续处理
    if (isRecordTimeOut) {
        return;
    }
    
    DLog(@"--------录音取消");
    
    isUserStopRecord = YES;
    
    [self hideVoiceHud:sender];
    
    [self resetTimer];
    
    if ([audioRecorder isRecording]) {
        [audioRecorder stop];
        
        if (!isPressOnStatus) {
            [UIView animateWithDuration:0.2f animations:^{
                self.clickToVoiceBtn.backgroundColor = kColorLine3;
                self.clickToVoiceLabel.text = MyLocal(@"点击录音");
            }];
        }
    }
    audioRecorder = nil;
    audioData = nil;
}


#pragma mark - audio delegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    //如果主动结束  就不再处理
    if (isUserStopRecord) {
        return;
    }
    
    //自动结束的则转化
    
    isRecordTimeOut = YES;
    [self resetTimer];
    
    [self audio_PCMtoMP3];
    
    [self hideVoiceHud:nil];
    
    if (!isPressOnStatus) {
        [UIView animateWithDuration:0.2f animations:^{
            self.clickToVoiceBtn.backgroundColor = kColorLine3;
            self.clickToVoiceLabel.text = MyLocal(@"点击录音");
        }];
    }
}




-(void)hideVoiceHud:(id)sender{
    if (self.voiceHud && self.voiceHud.isShow) {
        self.voiceHud.isShow = NO;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            [self.voiceHud hide];
            
            UIButton *btn = (UIButton *)sender;
            btn.enabled = YES;
            
            self.voiceHud = nil;
        });
    }
}

-(BOOL)isRecordIng{
    return [audioRecorder isRecording];
}

//播放
-(void)audioBtnClick:(id)sender{
    if ([self.audioPlayer isPlaying]) {
        //暂停
        [self stopVoiceAction];
    }else{
    
        [self initAudioPlayer];
        [self playVoiceAction];
    }
    
}

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


-(void)playVoiceAction{
    DLog(@"播放");
    
    if (!self.audioPlayer.isPlaying) {
        [self.audioPlayer play];
        [self startAnimating];
        
        // 阻止锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
}



-(void)stopVoiceAction{
    [self handleNotification:NO];
    
    // 还原锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if (_audioPlayer.isPlaying || self.trumpetImageView.isAnimating) {
        DLog(@"暂停");
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0;
        [self stopAnimating];
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



//传感器
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
        if (!self.audioPlayer.isPlaying) {
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}



-(void)renewStatus{
    
    audioData = nil;
    recordTime = 0;
    [self resetTimer];
    [self stopVoiceAction];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardVoiceManageVoiceDeleteDelegate)]) {
        [self.delegate keyBoardVoiceManageVoiceDeleteDelegate];
    }
    
    
    [UIView animateWithDuration:0.2f animations:^{
        
        [self switchVoiceRecodeMode:isPressOnStatus];
        
    } completion:^(BOOL finished) {
        
        self.audioBtn.hidden = YES;
        self.reRecordVoice.hidden = YES;
    }];
    
}


#pragma mark - Timer Update

- (void)updateMeters {
    
    recordTime += WAVE_UPDATE_FREQUENCY;

    if (audioRecorder) {
        [audioRecorder updateMeters];
    }
    float peakPower = [audioRecorder averagePowerForChannel:0];
    float pickPower = [audioRecorder peakPowerForChannel:0];
    
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
//    double peakPowerForChannel = fabs(100 + [audioRecorder peakPowerForChannel:0]*10/16)*0.01*0.5;
    
    DLog(@"======%f====%f====%f-====%f",peakPower,pickPower,recordTime,peakPowerForChannel);
    [self.circleView setAnimatedDefaultStartStrokeEnd:peakPowerForChannel duration:0.5f delay:0];
    
    [UIView animateWithDuration:0.2f animations:^{
       
        if (!self.timeLabel.hidden) {
            self.timeLabel.text = [HSBaseTool timeFormatted:recordTime];
        }
    }];
    
    if (isPressOnStatus) {
        [self.voiceHud setTimeText:recordTime];
        [self.voiceHud setProgress:peakPowerForChannel];
    }
}

-(void) resetTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}



#pragma mark - delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    DLog(@"播放完成");
    [self.trumpetImageView stopAnimating];
    
    [self handleNotification:NO];
    
    // 还原锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}


#pragma mark - UI
-(UIButton *)pressOnToVoiceBtn{
    if (!_pressOnToVoiceBtn) {
        _pressOnToVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pressOnToVoiceBtn.backgroundColor = kColorWhite;
        
        _pressOnToVoiceBtn.size = CGSizeMake(self.width * 0.55, 40);
        _pressOnToVoiceBtn.centerX = self.width/2;
        _pressOnToVoiceBtn.centerY = self.height/2;
    
        [_pressOnToVoiceBtn setBackgroundImage:[UIImage imageWithColor:kColorWhite andSize:_pressOnToVoiceBtn.size] forState:UIControlStateNormal];
        [_pressOnToVoiceBtn setBackgroundImage:[UIImage imageWithColor:kColorLine3 andSize:_pressOnToVoiceBtn.size] forState:UIControlStateHighlighted];
        [_pressOnToVoiceBtn setTitle:MyLocal(@"按住说话") forState:UIControlStateNormal];
        [_pressOnToVoiceBtn setTitleColor:kColorWord forState:UIControlStateNormal];
        
        _pressOnToVoiceBtn.layer.cornerRadius = 20;
        _pressOnToVoiceBtn.layer.borderWidth = 0.5f;
        _pressOnToVoiceBtn.layer.borderColor = kColorLine3.CGColor;
        _pressOnToVoiceBtn.layer.masksToBounds = YES;
        
        [_pressOnToVoiceBtn addTarget:self action:@selector(pressOnToVoiceBtnClick:) forControlEvents:UIControlEventTouchDown];
        [_pressOnToVoiceBtn addTarget:self action:@selector(recordEnd:) forControlEvents:UIControlEventTouchUpInside];
        [_pressOnToVoiceBtn addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchUpOutside];
        
        [self addSubview:_pressOnToVoiceBtn];
    }
    return _pressOnToVoiceBtn;
}


-(UIButton *)switchToclickBtn{
    if (!_switchToclickBtn) {
        _switchToclickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _switchToclickBtn.size = CGSizeMake(40, 40);
        _switchToclickBtn.right = self.width - 15;
        _switchToclickBtn.centerY = self.height/2;
        
        _switchToclickBtn.layer.cornerRadius = 20;
        _switchToclickBtn.layer.borderWidth = 0.5f;
        _switchToclickBtn.layer.borderColor = kColorLine3.CGColor;
        _switchToclickBtn.layer.masksToBounds = YES;
        
        [_switchToclickBtn setImage:[UIImage imageNamed:@"icon_click_unSel"] forState:UIControlStateNormal];
        [_switchToclickBtn setImage:[UIImage imageNamed:@"icon_click_sel"] forState:UIControlStateHighlighted];
        
        [_switchToclickBtn addTarget:self action:@selector(switchToclickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_switchToclickBtn];
    }
    return _switchToclickBtn;
}


-(UIButton *)clickToVoiceBtn{
    if (!_clickToVoiceBtn) {
        _clickToVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 60;
        _clickToVoiceBtn.size = CGSizeMake(width, width);
        _clickToVoiceBtn.layer.cornerRadius = width/2;
        _clickToVoiceBtn.layer.masksToBounds = YES;
        
        _clickToVoiceBtn.centerX = self.width/2;
        _clickToVoiceBtn.top = 22;
        
        _clickToVoiceBtn.hidden = YES;
        
        UIImage *image = [UIImage imageNamed:@"icon_mic"];
        
        [_clickToVoiceBtn setImage:image forState:UIControlStateNormal];
        
        [_clickToVoiceBtn addTarget:self action:@selector(clickToVoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_clickToVoiceBtn];
    }
    return _clickToVoiceBtn;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 40, 16)];
        _timeLabel.centerX = self.width/2;
        _timeLabel.backgroundColor = kColorDarkOrange;
        _timeLabel.textColor = kColorWhite;
        _timeLabel.layer.cornerRadius = 7;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.hidden = YES;
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}


-(UILabel *)clickToVoiceLabel{
    if (!_clickToVoiceLabel) {
        _clickToVoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.clickToVoiceBtn.bottom + 5, self.width, 20)];
        _clickToVoiceLabel.textColor = kColorWord;
        
        _clickToVoiceLabel.text = MyLocal(@"点击录音");
        _clickToVoiceLabel.textAlignment = NSTextAlignmentCenter;
        _clickToVoiceLabel.hidden = YES;
        _clickToVoiceLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self addSubview:_clickToVoiceLabel];
    }
    return _clickToVoiceLabel;
}


-(CircleView *)circleView
{
    if (!_circleView) {
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(5, 5, self.clickToVoiceBtn.width - 10, self.clickToVoiceBtn.height - 10)];
        
        _circleView.lineWidth = 5.0f;
        _circleView.alpha = 0.7;
        
        _circleView.alwaysShowProgress = YES;
        _circleView.backgroundCircleColor = kColorClear;
        _circleView.strokeColor = kColorLine3;
        _circleView.userInteractionEnabled = NO;
        [self.clickToVoiceBtn addSubview:_circleView];
    }
    return _circleView;
}

-(UIButton *)switchToPressOnBtn{
    if (!_switchToPressOnBtn) {
        _switchToPressOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _switchToPressOnBtn.size = CGSizeMake(40, 40);
        _switchToPressOnBtn.left = 15;
        _switchToPressOnBtn.centerY = self.height/2;
        
        _switchToPressOnBtn.layer.cornerRadius = 20;
        _switchToPressOnBtn.layer.borderWidth = 0.5f;
        _switchToPressOnBtn.layer.borderColor = kColorLine3.CGColor;
        _switchToPressOnBtn.layer.masksToBounds = YES;
        
        _switchToPressOnBtn.hidden = YES;

        [_switchToPressOnBtn setImage:[UIImage imageNamed:@"icon_fingerprint_unSel"] forState:UIControlStateNormal];
        [_switchToPressOnBtn setImage:[UIImage imageNamed:@"icon_fingerprint_sel"] forState:UIControlStateHighlighted];
        
        [_switchToPressOnBtn addTarget:self action:@selector(switchToPressOnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_switchToPressOnBtn];
    }
    return _switchToPressOnBtn;
}




-(UIButton *)audioBtn{
    if (!_audioBtn) {
        _audioBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 40)];
        _audioBtn.center = CGPointMake(self.width/2, self.height/2);
        
        _audioBtn.backgroundColor = RGB(196, 242, 177);
        _audioBtn.layer.borderColor = RGB(68, 197, 20).CGColor;
        _audioBtn.layer.borderWidth = 0.5f;
        _audioBtn.layer.cornerRadius = 15;
        _audioBtn.layer.masksToBounds = YES;
        
        _audioBtn.hidden = YES;
        
        [_audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_audioBtn];
    }
    return _audioBtn;
}


-(UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.audioBtn.width, self.audioBtn.height)];
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
        
        _trumpetImageView.right = self.audioBtn.width;
        _trumpetImageView.centerY = self.audioBtn.height/2;
        
        [self.audioBtn addSubview:_trumpetImageView];
        
        UIImage *image0 = [UIImage imageNamed:@"audio_icon_0"];
        UIImage *image1 = [UIImage imageNamed:@"audio_icon_1"];
        UIImage *image2 = [UIImage imageNamed:@"audio_icon_2"];
        
        _trumpetImageView.animationImages = @[image0,image1,image2];
        _trumpetImageView.animationDuration = 1.0f;
    }
    return _trumpetImageView;
}


-(UIButton *)reRecordVoice{
    if (!_reRecordVoice) {
        _reRecordVoice = [UIButton buttonWithType:UIButtonTypeCustom];
        _reRecordVoice.size = CGSizeMake(60, 40);
       
        _reRecordVoice.centerY = self.height/2;
        
        [_reRecordVoice setTitle:MyLocal(@"重录") forState:UIControlStateNormal];
        [_reRecordVoice setTitleColor:kColorWord forState:UIControlStateNormal];
        _reRecordVoice.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_reRecordVoice sizeToFit];
        
        _reRecordVoice.backgroundColor = kColorWhite;
        
        _reRecordVoice.layer.cornerRadius = 15;
        _reRecordVoice.layer.borderColor = kColorLine3.CGColor;
        _reRecordVoice.layer.borderWidth = 0.5f;
        _reRecordVoice.layer.masksToBounds = YES;
        
        if (!kiOS7_OR_LATER) {
            _reRecordVoice.height += 10;
        }
        
        _reRecordVoice.width += 20;
        _reRecordVoice.centerY = self.height/2;
        _reRecordVoice.hidden = YES;
        
        [_reRecordVoice addTarget:self action:@selector(reRecordVoiceClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_reRecordVoice];
    }
    return _reRecordVoice;
}

-(KeyboardVoiceHud *)voiceHud{
    if (!_voiceHud) {
        _voiceHud = [[KeyboardVoiceHud alloc] init];
    }
    return _voiceHud;
}


-(void)dealloc{
    [self stopVoiceAction];
    audioRecorder = nil;
    timer = nil;
    audioData = nil;
    [self.voiceHud removeFromSuperview];
    self.voiceHud = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

@end
