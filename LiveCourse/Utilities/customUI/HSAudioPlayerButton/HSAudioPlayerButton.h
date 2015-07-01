//
//  HSAudioPlayerButton.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/23.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSAudioPlayerButtonType) {
    buttonAudioDefaultType,
    buttonAudioPlayType,
    buttonAudioStopType
};

typedef NS_ENUM(NSInteger, HSAudioPlayerButtonStyle) {
    audioButtonPlainStyle,
    audioButtonRoundedStyle
};


@interface HSAudioPlayerButton : UIButton

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic) NSInteger loops;

@property (nonatomic) HSAudioPlayerButtonType currentButtonType;
@property (nonatomic) HSAudioPlayerButtonStyle currentButtonStyle;

//BackgroundColor property for rounded style button only
@property (nonatomic, strong) UIColor *roundBackgroundColor;
@property (nonatomic, strong) UIColor *roundBackgroundBorderColor;
@property (nonatomic, assign) CGFloat roundBackgroundBorderWidth;

- (void)setTintColor:(UIColor *)tintColor forState:(UIControlState)state;
- (UIColor *)tintColorForState:(UIControlState)state;

- (instancetype)initWithFrame:(CGRect)frame
                   buttonType:(HSAudioPlayerButtonType)initType
                  buttonStyle:(HSAudioPlayerButtonStyle)bStyle;

- (void)animateToType:(HSAudioPlayerButtonType)finalType;

- (void)playAudio:(NSString *)audio completion:(void (^)(BOOL finished, NSError *error))completion;

- (void)stopPlay;

@end
