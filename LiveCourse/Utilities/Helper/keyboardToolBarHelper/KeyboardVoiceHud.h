//
//  KeyboardVoiceHud.h
//  LiveCourse
//
//  Created by Lu on 15/6/9.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyBoardVoiceManageView;

@interface KeyboardVoiceHud : UIView


@property (nonatomic, assign) BOOL isShow;

/**
 *  设置显示时间
 *
 *  @param time <#time description#>
 */
-(void)setTimeText:(int)time;

/**
 *  设置提示文字
 *
 *  @param hintText <#hintText description#>
 */
-(void)setHintLabelText:(NSString *)hintText;

/**
 *  设置进度
 *
 *  @param Progress <#Progress description#>
 */
-(void)setProgress:(CGFloat)progress;

-(void)show;

-(void)hide;

@end
