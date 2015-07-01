//
//  UITestTopicTdhxzzqdda.m
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicTdhxzzqdda.h"
#import "HSAudioPlayerButton.h"
#import "UITestTopicOptionCustomBtn.h"

@interface UITestTopicTdhxzzqdda ()

@property (nonatomic, strong)HSAudioPlayerButton *audioPlayerButton;
@property (nonatomic, strong) UIView *centerLineView;

@property (nonatomic, strong) UILabel *wenLabel;//问:
@property (nonatomic, strong) TopicLabel *questionLabel;//提问

@end

@implementation UITestTopicTdhxzzqdda
{
    NSInteger optionNum;//选项个数
    UITestTopicOptionCustomBtn *tempBtn;
    
    NSInteger rightResult;//正确答案
    NSInteger userChooseResult;//用户选择的答案
    
    ExamModel *parentExamModel;
    
    NSMutableArray *answerItemsArray;
    
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
    
    self.topicTypeTitleLabel.text = parentExamModel.tTypeAlias;
    
    [self randomItemsAndAnswer];
    
//    rightResult = [parentExamModel.answer integerValue];
    
//    answerItemsArray = [NSMutableArray arrayWithArray:[parentExamModel.items componentsSeparatedByString:@"|"]];
    optionNum = answerItemsArray.count;
    
    self.audioPlayerButton.backgroundColor = kColorClear;
    
    self.centerLineView.top = self.audioPlayerButton.bottom + 30;
    
    
    self.wenLabel.text = MyLocal(@"问:");
    self.wenLabel.top = self.centerLineView.bottom +35;
    [self.wenLabel sizeToFit];
    
    self.questionLabel.top = self.centerLineView.bottom + 20;
    self.questionLabel.left = self.wenLabel.right + 5;
    self.questionLabel.width = self.backScrollView.width - self.wenLabel.right - 15;
    self.questionLabel.text = parentExamModel.question;
    [self.questionLabel sizeToFit];
    
    self.wenLabel.bottom = self.questionLabel.bottom;
    
    //加载答案选项
    
    CGFloat firstTop = self.questionLabel.bottom + 40;
    CGFloat lastItemBottom = 0;
    for (NSInteger i = 0; i < optionNum; i++) {
        
        CGFloat top = firstTop + i*(optionBtnHeight +optionBtnSpace);
        
        UITestTopicOptionCustomBtn *optionBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(optionBtnLeft, top, self.backScrollView.width - optionBtnLeft*2, optionBtnHeight)];
        optionBtn.tag = KTestTopicTdhxzzqddaTag + i;
        [optionBtn setAbcLabelText:[HSBaseTool getAbcStrWithIndex:i] andDetailLabelText:[answerItemsArray objectAtIndex:i]];
        [optionBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:optionBtn];
        
        lastItemBottom = optionBtn.bottom;
    }
    
    self.backScrollView.contentSize = CGSizeMake(0, lastItemBottom + 20);
    
    [self playAudioAction:self.audioPlayerButton];
}



//随机选项和答案
-(void)randomItemsAndAnswer{
    NSInteger oldAnswer = [parentExamModel.answer integerValue];//旧答案
    NSMutableArray *oldItems = [NSMutableArray arrayWithArray:[parentExamModel.items componentsSeparatedByString:@"|"]];
    
    //根据旧答案获取到正确选项数据
    NSString *trueItemStr = [oldItems objectAtIndex:oldAnswer];
    
    //打乱数据
    answerItemsArray = [NSMutableArray arrayWithArray: [HSBaseTool chaosArrayFromArry:oldItems withReturnNumber:oldItems.count]];
    
    rightResult = [answerItemsArray indexOfObject:trueItemStr];
}




- (void) buttonTouch:(id)sender {
    
    [self editContinueBtnIsEnable:YES];
    
    tempBtn.selected = !tempBtn.selected;
    
    UITestTopicOptionCustomBtn *button = (UITestTopicOptionCustomBtn *)sender;
    button.selected = !button.selected;
    
    tempBtn = button;
    
    userChooseResult = button.tag - KTestTopicTdhxzzqddaTag;
}


-(NSInteger)checkResultAndReturnRightStarNum{
    for (NSInteger i = 0; i < optionNum; i++) {
        UITestTopicOptionCustomBtn *optionCustomBtn  = (UITestTopicOptionCustomBtn*)[self viewWithTag:(KTestTopicTdhxzzqddaTag + i)];
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
    
    UITestTopicOptionCustomBtn *tempRightBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:KTestTopicTdhxzzqddaTag + rightResult];
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

-(UIView *)centerLineView{
    if (!_centerLineView) {
        _centerLineView = [[UIView alloc] init];
        _centerLineView.left = 0;
        _centerLineView.width = self.backScrollView.width;
        _centerLineView.height = 1.0f;
        _centerLineView.backgroundColor = kColorLine2;
        [self.backScrollView addSubview:_centerLineView];
    }
    return _centerLineView;
}


-(UILabel *)wenLabel{
    if (!_wenLabel) {
        _wenLabel = [[UILabel alloc] init];
        _wenLabel.left = 15;
        _wenLabel.textColor = kColorWord;
        _wenLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.backScrollView addSubview:_wenLabel];
    }
    return _wenLabel;
}

-(TopicLabel *)questionLabel{
    if (!_questionLabel) {
        _questionLabel = [[TopicLabel alloc] init];
        
        _questionLabel.textColor = kColorWord;
        [_questionLabel isPinyinHighlight:YES andColor:kColorMain];
        _questionLabel.numberOfLines = 0;
        _questionLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.backScrollView addSubview:_questionLabel];
    }
    return _questionLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
