//
//  AudioPlayHelper.h
//  HelloHSK
//
//  Created by yang on 14-3-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVAudioPlayer;
@protocol AudioPlayHelperDelegate;

@interface AudioPlayHelper : NSObject

// 设置循环的次数
@property (nonatomic) NSInteger loops;
// 读取音频播放的时间
@property (readonly) NSTimeInterval duration;
// 读取是否正在播放中。
@property (readonly, getter=isPlaying) BOOL playing;

+ (AudioPlayHelper *)instance;
/**
 *  以音频所在路径来初始化音频播放器。
 *
 *  @param audioName 音频名称(完整的绝对地址)
 *  @param delegate  代理
 *
 *  @return 对象
 */

+ (id)initWithAudioName:(NSString *)audioName delegate:(id<AudioPlayHelperDelegate>)delegate;
/**
 *  停止音频播放，并清理对象。
 */
+ (void)stopAndCleanAudioPlay;

/**
 *  播放当前音频
 */
- (void)playAudio;

/**
 *  停止当前音频
 */
- (void)stopAudio;

@end

@protocol AudioPlayHelperDelegate <NSObject>

@optional
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;

@end
