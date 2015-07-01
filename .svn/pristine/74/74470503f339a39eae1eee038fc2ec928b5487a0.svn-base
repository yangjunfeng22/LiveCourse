//
//  UITestTopicOptionMany.m
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicOptionMany.h"
#import "UITestTopicOptionCustomBtn.h"
#import "HSAudioPlayerButton.h"

@interface UITestTopicOptionMany ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) HSAudioPlayerButton *audioPlayerButton;

@property (nonatomic,readwrite) CGFloat optionHeight;

@end


@implementation UITestTopicOptionMany
{
    
    NSInteger optionNum;
    NSString *audioPath;

    UITestTopicOptionCustomBtn *tempBtn;
    
    NSInteger userChooseResult;

    NSString *titleStr;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)setTitle:(NSString *)title andAudioPath:(NSString *)path andOptionNum:(NSInteger)num{
    titleStr = title;
    audioPath = path;
    optionNum = num;
    
    [self loadData];
}

-(void)loadData{
    
    self.titleLabel.text = titleStr;
    [self.titleLabel sizeToFit];
    self.audioPlayerButton.left = self.titleLabel.right + 5;
    self.audioPlayerButton.backgroundColor = kColorClear;
    
    self.audioPlayerButton.centerY = self.titleLabel.centerY;
    
    CGFloat width = 45;
    CGFloat height = 35;
//    CGFloat space = (self.width - optionNum * width)/(optionNum+1);
    CGFloat space = 15;
    CGFloat top = self.audioPlayerButton.bottom + 5;
    
    CGFloat right = 15;
    CGFloat bottom = 0;
    CGFloat topSapce = 5;
    
    for (NSInteger i = 0; i < optionNum; i ++) {
        
        //判断是否出界，出界则自动换行
//        CGFloat left = (i+1)*space + i*width;
        
        UITestTopicOptionCustomBtn *customBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(0, top, width, height)];
        
        customBtn.left = right;
        
        if (customBtn.right > self.width - 15) {
            top = bottom + topSapce;
            
            customBtn.top = top;
            customBtn.left = 15;
        }
        
        
        [customBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [customBtn setTitle:[HSBaseTool getAbcStrWithIndex:i] forState:UIControlStateNormal];
        customBtn.tag = KTestTopicOptionManyTag + i;
        
        bottom = customBtn.bottom;
        right = customBtn.right + space;
        
        [self addSubview:customBtn];
    }

    self.height = bottom + 10;
    self.optionHeight = bottom + 10;
}

-(void)setEveryItemUnenable{
    
    for (NSInteger i = 0; i < optionNum; i ++) {
        UITestTopicOptionCustomBtn *tempCustomBtn= (UITestTopicOptionCustomBtn *)[self viewWithTag:(KTestTopicOptionManyTag + i)];
        tempCustomBtn.userInteractionEnabled = NO;
    }
}


- (void) buttonTouch:(id)sender {
    
    if (tempBtn) {
        tempBtn.selected = !tempBtn.selected;
    }
    
    
    UITestTopicOptionCustomBtn *button = (UITestTopicOptionCustomBtn *)sender;
    button.selected = !button.selected;
    
    userChooseResult = button.tag - KTestTopicOptionManyTag;
    
    tempBtn = button;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userChoseResult:withIndex:andResult:)]) {
        
        [self.delegate userChoseResult:self withIndex:([titleStr integerValue] - 1) andResult:userChooseResult];
    }
}


- (void)playAudioAction:(id)sender
{
    if (self.audioPlayerButton.isPlaying)
    {
        [self.audioPlayerButton stopPlay];
    }
    else
    {
        [self.audioPlayerButton playAudio:audioPath completion:^(BOOL finished, NSError *error) {}];
    }
}


-(void)setIfUserChooseRight{
    //答对了
    [tempBtn setIfUserChooseRight];
}


-(void)setIfUserChooseWrongWithTrueItem:(NSInteger)trueItem
{
    //原来的答错了
    [tempBtn setIfUserChooseWrong];
    
    UITestTopicOptionCustomBtn *tempTrueCustomBtn= (UITestTopicOptionCustomBtn *)[self viewWithTag:(KTestTopicOptionManyTag + trueItem)];
    //正确的答案
    [tempTrueCustomBtn setIfIsRightButUserNotChoose];
}


-(void)resetChooseItem{
    
//    UITestTopicOptionCustomBtn *tempCustomBtn= (UITestTopicOptionCustomBtn *)[self viewWithTag:(KTestTopicOptionManyTag + userChooseResult)];
//    //去除选择状态
//    tempCustomBtn.selected = NO;
    tempBtn.selected = !tempBtn.selected;
    tempBtn = nil;
}

#pragma mark - UI

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 15, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kColorWord;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


-(HSAudioPlayerButton *)audioPlayerButton{
    if (!_audioPlayerButton) {
        _audioPlayerButton = [[HSAudioPlayerButton alloc] initWithFrame:CGRectMake(self.titleLabel.right + 5, 0, 35, 35) buttonType:buttonAudioPlayType buttonStyle:audioButtonRoundedStyle];
        _audioPlayerButton.roundBackgroundColor = kColorMain;
        _audioPlayerButton.tintColor = kColorMain;
        [_audioPlayerButton addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_audioPlayerButton];   
    }
    return _audioPlayerButton;
}

- (void)playMedia
{
    [self playAudioAction:self.audioPlayerButton];
}

@end
