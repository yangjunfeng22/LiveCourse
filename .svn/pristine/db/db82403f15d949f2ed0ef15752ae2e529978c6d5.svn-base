//
//  UITestTopicTlypddc.m
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicTlypddc.h"
#import "HSAudioPlayerButton.h"
#import "CircleView.h"
#import "AudioPlayHelper.h"
#import "UITestTopicOptionCustomBtn.h"
#import "HSUIAnimateHelper.h"
#import "UIImageView+Extra.h"

#define bottonHeight 40

@interface UITestTopicTlypddc ()<AudioPlayHelperDelegate>

@property (nonatomic, strong) HSAudioPlayerButton *audioPlayerButton;
@property (nonatomic, strong) CircleView *circleView;

@property (nonatomic, strong) UIImageView *topicImageView;
@property (nonatomic, strong) TopicLabel *topicTitleLabel;

@end

@implementation UITestTopicTlypddc
{
    AudioPlayHelper *audioPlayer;

    UITestTopicOptionCustomBtn *tempBtn;
    
    NSInteger rightResult;//正确答案
    NSInteger userChooseResult;//用户选择的答案
    
     NSArray *trueOrWrongArry;
    
    ExamModel *parentExamModel;
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


#pragma mark - Action
-(void)loadDataWithExamModel:(ExamModel *)examModel{
    
    
    parentExamModel = examModel;
    
    rightResult = [examModel.answer integerValue];
    
    
    trueOrWrongArry = @[MyLocal(@"对"),MyLocal(@"错")];
    
    self.topicTypeTitleLabel.text = examModel.tTypeAlias;
    
    self.audioPlayerButton.backgroundColor = kColorClear;
    
    CGFloat optionBtnFirstTop = self.audioPlayerButton.bottom + 30;
    
    if (![NSString isNullString:parentExamModel.image ]) {
        
        //图片
        NSString *imageStr = parentExamModel.image;
        NSString *path = [HSBaseTool picturePathWithCheckPoinID:HSAppDelegate.curCpID picture:imageStr];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [self.topicImageView showClipImageWithImage:image];
        
        optionBtnFirstTop = self.topicImageView.bottom + 30;
    }
    else
    {
        //文字
        CGFloat left = 15;
        self.topicTitleLabel.left = left;
        self.topicTitleLabel.width = self.backScrollView.width - left*2;
        self.topicTitleLabel.text = parentExamModel.question;
        [self.topicTitleLabel sizeToFit];
        self.topicTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.topicTitleLabel.top = self.audioPlayerButton.bottom + 30;
        self.topicTitleLabel.centerX = self.backScrollView.width/2;
        optionBtnFirstTop = self.topicTitleLabel.bottom + 30;
    }
    
    
    //加载答案选项
    CGFloat lastItemBottom = 0;
    for (NSInteger i = 0; i < 2; i++) {
        
        CGFloat top = optionBtnFirstTop + i*(bottonHeight +optionBtnSpace);
        
        UITestTopicOptionCustomBtn *optionBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(optionBtnLeft, top, self.backScrollView.width - optionBtnLeft*2, bottonHeight)];
        optionBtn.tag = KTestTopicTlypddcTag + i;
        [optionBtn setTitle:[trueOrWrongArry objectAtIndex:i] forState:UIControlStateNormal];
        [optionBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:optionBtn];
        
        lastItemBottom = optionBtn.bottom;
    }
    
    self.backScrollView.contentSize = CGSizeMake(0, lastItemBottom + 20);
    [self playAudioAction:self.audioPlayerButton];
}


- (void) buttonTouch:(id)sender {
    
    [self editContinueBtnIsEnable:YES];
    
    tempBtn.selected = !tempBtn.selected;
    
    UITestTopicOptionCustomBtn *button = (UITestTopicOptionCustomBtn *)sender;
    button.selected = !button.selected;
    
    tempBtn = button;
    
    userChooseResult = button.tag - KTestTopicTlypddcTag;
}


-(NSInteger)checkResultAndReturnRightStarNum{
    for (NSInteger i = 0; i < 2; i++) {
        UITestTopicOptionCustomBtn *optionCustomBtn  = (UITestTopicOptionCustomBtn*)[self viewWithTag:(KTestTopicTlypddcTag + i)];
        optionCustomBtn.userInteractionEnabled = NO;
    }
    
    if (rightResult == userChooseResult) {
        //答对
        
        [self editResultBtnIfRight];
        [self savePracticeRecordWithTopicID:parentExamModel.eID result:YES answer:[NSString stringWithFormat:@"%i",userChooseResult]];
        return 1;
    }else if(rightResult != userChooseResult)
    {
        //答错
        
        [self editResultBtnIfWrong];
        [self savePracticeRecordWithTopicID:parentExamModel.eID result:NO answer:[NSString stringWithFormat:@"%i",userChooseResult]];
        
        return 0;
    }
    return 0;
}


-(void)editResultBtnIfRight{
    
    [tempBtn setIfUserChooseRight];
}

-(void)editResultBtnIfWrong{
    
    [tempBtn setIfUserChooseWrong];
    
    UITestTopicOptionCustomBtn *tempRightBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:KTestTopicTlypddcTag + rightResult];
    [tempRightBtn setIfIsRightButUserNotChoose];
}




- (void)playAudioAction:(id)sender
{
    if (self.audioPlayerButton.isPlaying)
    {
        [self.audioPlayerButton stopPlay];
    }
    else
    {
        NSString *audioStr = parentExamModel.audio;
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:audioStr];
        [self.audioPlayerButton playAudio:path completion:^(BOOL finished, NSError *error) {}];
    }
}


#pragma mark - UI


-(HSAudioPlayerButton *)audioPlayerButton{
    if (!_audioPlayerButton) {
        _audioPlayerButton = [[HSAudioPlayerButton alloc] initWithFrame:CGRectMake(0, 15, 50, 50) buttonType:buttonAudioPlayType buttonStyle:audioButtonRoundedStyle];
        
        _audioPlayerButton.roundBackgroundColor = kColorMain;
        _audioPlayerButton.tintColor = kColorMain;
        _audioPlayerButton.centerX = self.backScrollView.width/2;
        [_audioPlayerButton addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:_audioPlayerButton];
        
    }
    return _audioPlayerButton;
}



- (CircleView *)circleView
{
    if (!_circleView)
    {
        _circleView = [[CircleView alloc] initWithFrame:self.audioPlayerButton.bounds];
        _circleView.strokeColor = kColorMain;
        _circleView.lineWidth = 3;
        _circleView.backgroundCircleColor = kColorLine;
        _circleView.userInteractionEnabled = NO;
        [self.audioPlayerButton addSubview:_circleView];
        
        [_circleView setStrokeEnd:0 animated:NO];
    }
    return _circleView;
}



-(TopicLabel *)topicTitleLabel{
    if (!_topicTitleLabel) {
        _topicTitleLabel = [[TopicLabel alloc] init];
        _topicTitleLabel.textColor = kColorWord;
        [_topicTitleLabel isPinyinHighlight:YES andColor:kColorMain];
        _topicTitleLabel.numberOfLines = 0;
        _topicTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.backScrollView addSubview:_topicTitleLabel];
    }
    return _topicTitleLabel;
}


-(UIImageView *)topicImageView{
    if (!_topicImageView) {
        _topicImageView = [[UIImageView alloc] init];
        _topicImageView.size = CGSizeMake(170, 100);
        _topicImageView.top = self.audioPlayerButton.bottom + 20;
        _topicImageView.centerX = self.backScrollView.width/2;
        
        _topicImageView.layer.cornerRadius = 10.0f;
        _topicImageView.layer.masksToBounds = YES;
        
        [self.backScrollView addSubview:_topicImageView];
    }
    return _topicImageView;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
