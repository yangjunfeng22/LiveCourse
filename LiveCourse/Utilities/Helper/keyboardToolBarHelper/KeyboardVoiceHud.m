//
//  KeyboardVoiceHud.m
//  LiveCourse
//
//  Created by Lu on 15/6/9.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "KeyboardVoiceHud.h"
#import "KeyBoardVoiceManageView.h"


#define greenImgViewHeight 50

@interface KeyboardVoiceHud ()

@property (nonatomic, strong) UIImageView *hudImageView;    //图片

@property (nonatomic, strong) UILabel *timeLabel;           //时间

@property (nonatomic, strong) UILabel *hintLabel;           //提示

@property (nonatomic, strong) UIImageView *greenImgView;

@end





@implementation KeyboardVoiceHud

{
    CGFloat greenImgViewBottom;
}

-(id)init{
    self = [super initWithFrame:CGRectMake(0, 0, 140, 140)];
    
    if (self) {
        self.centerX = SCREEN_WIDTH/2;
        self.centerY = SCREEN_HEIGHT/2;
        self.backgroundColor = kColorWhite;
        
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        
        [self initAction];
    }
    return self;
}


#pragma mark - action

-(void)initAction{
    self.hudImageView.backgroundColor = kColorClear;
    self.hintLabel.backgroundColor = kColorClear;
    self.greenImgView.backgroundColor = kColorClear;
    self.greenImgView.hidden = YES;
    [self setTimeText:0];
}

-(void)show{
    self.isShow = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 1;
        
    }];
}

-(void)hide{
    [self setTimeText:0];
    self.isShow = NO;
    [self removeFromSuperview];
}


-(void)setTimeText:(int)time{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.timeLabel.text = [HSBaseTool timeFormatted:time];
    }];
}

-(void)setHintLabelText:(NSString *)hintText{
    self.hintLabel.text = hintText;
}


-(void)setProgress:(CGFloat)progress{
    self.greenImgView.hidden = NO;
    [UIView animateWithDuration:0.2f animations:^{
        self.greenImgView.height = greenImgViewHeight * progress;
        self.greenImgView.bottom = greenImgViewBottom;
    }];
}

#pragma mark - UI
-(UIImageView *)hudImageView{
    if (!_hudImageView) {
        UIImage *image = [UIImage imageNamed:@"voice_hud"];
        _hudImageView = [[UIImageView alloc] initWithImage:image];
        _hudImageView.size = self.size;
        _hudImageView.origin = CGPointMake(0, 0);
        
        [self addSubview:_hudImageView];
    }
    return _hudImageView;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, self.width, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.textColor = kColorWhite;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = kColorClear;
        
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}


-(UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        _hintLabel.textColor = kColorWhite;
        _hintLabel.font = [UIFont systemFontOfSize:12.0f];
        _hintLabel.text = MyLocal(@"手指上滑,取消发送");
        _hintLabel.bottom = self.height - 10;
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_hintLabel];
    }
    return _hintLabel;
}


-(UIImageView *)greenImgView{
    if (!_greenImgView) {
        UIImage *img = [UIImage imageNamed:@"green"];
        _greenImgView = [[UIImageView alloc] initWithImage:img];
        _greenImgView.size = CGSizeMake(35, greenImgViewHeight);
        _greenImgView.center = CGPointMake(self.width/2, self.height/2 - 3);
        greenImgViewBottom = _greenImgView.bottom;
        [self addSubview:_greenImgView];
        [self insertSubview:_greenImgView belowSubview:self.hudImageView];
    }
    return _greenImgView;
}

@end
