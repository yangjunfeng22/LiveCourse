//
//  KeyBoardVoiceManageView.h
//  LiveCourse
//
//  Created by Lu on 15/6/3.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardVoiceManageViewDelegate <NSObject>

@optional

/**
 *  选择好图片的处理
 */
-(void)keyBoardVoiceManageVoiceSelectedDelegate:(NSData *)voiceData andDuration:(NSInteger)duration;


/**
 *  删除掉图片的处理
 */
-(void)keyBoardVoiceManageVoiceDeleteDelegate;


@end



@interface KeyBoardVoiceManageView : UIView

@property (nonatomic, weak) id <KeyBoardVoiceManageViewDelegate> delegate;

@property (nonatomic, assign) NSInteger maxRecodeTime;              //最大录音时长


/**
 *  录音结束
 *
 *  @param sender <#sender description#>
 */
-(void)recordEnd:(id)sender;

/**
 *  取消录音
 *
 *  @param sender <#sender description#>
 */
-(void)recordCancel:(id)sender;


/**
 *  停止播放音频
 */
-(void)stopVoiceAction;

/**
 *  是否在录音
 */
-(BOOL)isRecordIng;


/**
 *  恢复到初始状态
 */
-(void)renewStatus;


@end
