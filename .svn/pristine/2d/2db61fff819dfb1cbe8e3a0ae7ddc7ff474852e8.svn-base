//
//  HSWcjzTopicView.m
//  HelloHSK
//
//  Created by yang on 14-3-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "HSWcjzTopicView.h"

#import "HSDropView.h"
#import "HSDragView.h"
#import "HSDragLabel.h"

#import "HSPinyinLabel.h"
#import "HSAudioPlayerButton.h"

#import "SentenceModel.h"
#import "AudioPlayHelper.h"
#import "SentenceLabel.h"

#import "HSUIAnimateHelper.h"

@interface HSWcjzTopicView ()<HSDragViewDelegate, HSDropViewDelegate>
{
    NSString *rightAnswer;
    BOOL isCheckRight;
}

@property (nonatomic, strong) HSAudioPlayerButton *btnAudioPlayer;
@property (nonatomic, strong) HSDropView *dropView;
@property (nonatomic, strong) HSDragView *dragView;
@property (nonatomic, strong) UIView *showArea;
@property (nonatomic, strong) HSPinyinLabel *lblSentence;
@property (nonatomic, strong) SentenceLabel *lblAnswer;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *btnContinue;

@end

@implementation HSWcjzTopicView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initInterface];
    }
    return self;
}

- (HSAudioPlayerButton *)btnAudioPlayer
{
    if (!_btnAudioPlayer)
    {
        _btnAudioPlayer = [[HSAudioPlayerButton alloc] initWithFrame:CGRectMake(0, self.height*0.05, 50, 50) buttonType:buttonAudioPlayType buttonStyle:audioButtonRoundedStyle];
        _btnAudioPlayer.roundBackgroundColor = kColorMain;
        _btnAudioPlayer.centerX = self.width*0.5f;
        [_btnAudioPlayer addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_btnAudioPlayer];
    }
    return _btnAudioPlayer;
}

- (UIButton *)btnContinue
{
    if (!_btnContinue)
    {
        _btnContinue = [[UIButton alloc] initWithFrame:CGRectMake(self.showArea.left, self.height*(kiPhone4 ? 0.89:0.87), self.showArea.width, 44)];
        _btnContinue.backgroundColor = [UIColor lightGrayColor];
        _btnContinue.layer.cornerRadius = 5;
        _btnContinue.layer.masksToBounds = YES;
        [_btnContinue setTitle:MyLocal(@"检查") forState:UIControlStateNormal];
        [_btnContinue addTarget:self action:@selector(checkAnswerAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnContinue.enabled = NO;
        [self addSubview:_btnContinue];
    }
    [self bringSubviewToFront:_btnContinue];
    return _btnContinue;
}

- (UIView *)showArea
{
    if (!_showArea)
    {
        CGFloat oY = self.height*0.17 < self.btnAudioPlayer.bottom+6 ? self.btnAudioPlayer.bottom+6:self.height*0.17;
        _showArea = [[HSDropView alloc] initWithFrame:CGRectMake(20, oY, self.bounds.size.width-40.0f, self.height*0.4f)];
        _showArea.layer.cornerRadius = 10;
        _showArea.layer.borderWidth = 1;
        _showArea.layer.borderColor = kColorMain.CGColor;
        _showArea.layer.masksToBounds = YES;
        _showArea.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_showArea];
    }
    return _showArea;
}

- (HSDropView *)dropView
{
    if (!_dropView)
    {
        _dropView = [[HSDropView alloc] initWithFrame:CGRectMake(0, 44, self.showArea.width, self.showArea.height*0.75f)];
        _dropView.delegate = self;
        
        _dropView.layer.masksToBounds = YES;
        _dropView.backgroundColor = [UIColor clearColor];
        [self.showArea addSubview:_dropView];
        
        UILabel *lblSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, self.showArea.width, 1)];
        lblSeperator.backgroundColor = kColorMain;
        [self.showArea addSubview:lblSeperator];
    }
    return _dropView;
}

- (HSDragView *)dragView
{
    if (!_dragView)
    {
        _dragView = [[HSDragView alloc] initWithFrame:CGRectMake(self.showArea.left, self.showArea.bottom, self.showArea.width, self.height*0.29)];
        _dragView.delegate = self;
        _dragView.clipsToBounds = NO;
        _dragView.backgroundColor = kColorClear;
        [self.scrollView addSubview:_dragView];
    }
    return _dragView;
}

- (HSPinyinLabel *)lblSentence
{
    if (!_lblSentence)
    {
        _lblSentence = [[HSPinyinLabel alloc] initWithFrame:CGRectMake(0, 0, self.showArea.width, 44)];
        _lblSentence.backgroundColor = [UIColor clearColor];
        _lblSentence.font = kFontHel(14);
        _lblSentence.textColor = kColorHintGray;
        _lblSentence.textAlignment = NSTextAlignmentCenter;
        _lblSentence.text = @"";
        _lblSentence.numberOfLines = 0;
        [self.showArea addSubview:_lblSentence];
    }
    return _lblSentence;
}

- (SentenceLabel *)lblAnswer
{
    if (!_lblAnswer)
    {
        _lblAnswer = [[SentenceLabel alloc] initWithFrame:CGRectMake(self.dragView.left, self.showArea.bottom+10, self.dragView.width, self.dragView.height)];
        _lblAnswer.backgroundColor = kColorWhite;
        _lblAnswer.font = kFontHel(16);
        _lblAnswer.textColor = kColorGreen;
        _lblAnswer.textAlignment = NSTextAlignmentCenter;
        _lblAnswer.text = @"";
        [self addSubview:_lblAnswer];
    }
    return _lblAnswer;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height*0.87-6)];
        [self addSubview:_scrollView];
        [self sendSubviewToBack:_scrollView];
    }
    return _scrollView;
}

- (void)setSentenceData:(SentenceModel *)sentenceData
{
    _sentenceData = sentenceData;
    
    NSString *strSen;
    if ([sentenceData.qChinese stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
    {
        // 字符不为空
        strSen = [[NSString alloc] initWithFormat:@"%@^%@", sentenceData.qChinese, sentenceData.qPinyin];
    }
    else
    {
        // 字符为空
        strSen = [[NSString alloc] initWithFormat:@"%@^%@", sentenceData.chinese, sentenceData.pinyin];
    }
    
    //strSen = sentenceData.qChinese;
    //DLog(@"strSen: %@", strSen);
    
    //NSString *strSen = sentenceData.typeValue ? [[NSString alloc] initWithFormat:@"%@^%@", sentenceData.chinese, sentenceData.pinyin] : [[NSString alloc] initWithFormat:@"%@^%@", sentenceData.chinese, sentenceData.pinyin];
    
    self.sentence = strSen;
    self.audioPath = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:sentenceData.audio];
}

- (void)setSentence:(NSString *)sentence
{
    _sentence = sentence;
    if (!sentence || sentence.length <= 0) return;
    
    NSPredicate *pinYinTest = [NSPredicate predicateWithFormat:@"SELF LIKE %@", @"*^*"];
    BOOL pinyin = [pinYinTest evaluateWithObject:sentence];
    
    if (pinyin)
    {
        NSArray *arrSen = [sentence componentsSeparatedByString:@"^"];
        NSInteger count = [arrSen count];
        if (count >= 2)
        {
            NSString *chinese = arrSen[0];
            NSString *pinyin  = arrSen[1];
            
            NSArray *arrChinese;
            NSArray *arrPinyin;
            
            NSPredicate *separator = [NSPredicate predicateWithFormat:@"SELF LIKE %@", @"*|*"];
            BOOL sFactor = [separator evaluateWithObject:chinese];
            if (sFactor)
            {
                arrChinese = [chinese componentsSeparatedByString:@"|"];
                arrPinyin  = [pinyin componentsSeparatedByString:@"|"];
            }
            else
            {
                arrChinese = [chinese componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                arrPinyin = [pinyin componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            
            
            NSInteger tCount = [arrChinese count] > [arrPinyin count] ? [arrPinyin count]:[arrChinese count];
            
            NSMutableArray *arrTSen = [[NSMutableArray alloc] initWithCapacity:2];
            for (NSUInteger i = 0; i < tCount; i++)
            {
                NSString *tChinese = [[arrChinese objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *tPinyin  = [[arrPinyin objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *tFormat = [[NSString alloc] initWithFormat:@"%@^%@", tChinese, tPinyin];
                [arrTSen addObject:tFormat];
            }
            
            rightAnswer = [arrTSen componentsJoinedByString:@" "];
            // 2、打乱顺序
            [arrTSen sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSInteger index = arc4random() % 3;
                //DLog(@"index: %d", index);
                NSComparisonResult result = index == 0 ? NSOrderedAscending : (index == 1 ? NSOrderedDescending:NSOrderedSame);
                
                return result;
            }];
            
            NSString *fSen = [arrTSen componentsJoinedByString:@"|"];
            
            DLog(@"fSen: %@", fSen);
            
            self.dragView.subject = fSen;
        }
    }
    else
    {
        rightAnswer = sentence;
        // 1、先将这个sentence按照空格分开，然后再打乱顺序。
        NSArray *arrSen;
        NSPredicate *separator = [NSPredicate predicateWithFormat:@"SELF LIKE %@", @"*|*"];
        BOOL sFactor = [separator evaluateWithObject:sentence];
        if (sFactor)
        {
            arrSen = [sentence componentsSeparatedByString:@"|"];
            rightAnswer = [rightAnswer stringByReplacingOccurrencesOfString:@"|" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, rightAnswer.length)];
        }
        else
        {
            arrSen = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        // 2、打乱顺序
        [arrSen sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger index = arc4random() % 3;
            //DLog(@"index: %d", index);
            NSComparisonResult result = index == 0 ? NSOrderedAscending : (index == 1 ? NSOrderedDescending:NSOrderedSame);
            
            return result;
        }];
        
        self.dragView.subject = [arrSen componentsJoinedByString:@"|"];
    }
    
    
    
    self.dragView.type = 1;
    CGFloat height = self.dragView.totalHeight;
    [self.scrollView setContentSize:CGSizeMake(self.width, height)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)initInterface
{
    [self btnAudioPlayer];
    [self dropView];
    [self btnContinue];

    //self.lblSentence.text = @"认识^renshi|你^ni|很高兴^hengaoxing";
    //self.sentence = /*@"认识 你 很高兴";*/@"认识 你 很高兴^renshi ni hengaoxing";
}

#pragma mark - DragView / DropView delegate
- (void)dragView:(HSDragView *)view clicked:(id)sender
{
    HSDragLabel *dragLabel = (HSDragLabel *)sender;
    dragLabel.hidden = YES;
    NSString *text = dragLabel.text;

    [self.lblSentence appendTextWithSting:text];

    [self.dropView addDragLabelWithText:text fromCenter:dragLabel.center];
    
    BOOL valid = YES;
    for (HSDragLabel *lblDragItem in view.arrDragLabel)
    {
        if (!lblDragItem.hidden)
        {
            valid = NO;
            break;
        }
    }
    // 如果没有完成所有的，或者完成了所有的后来又点回去了，那么当然是非正确的答案了。
    isCheckRight = valid;
    // 如果valid为真，说明句子排列好了。判断对错。
    if (valid)
    {
        self.btnContinue.backgroundColor = kColorWhite;
        self.btnContinue.layer.borderWidth = 1;
        self.btnContinue.layer.borderColor = kColorMain.CGColor;
        [self.btnContinue setTitleColor:kColorHintGray forState:UIControlStateNormal];
        self.btnContinue.enabled = YES;
        NSString *strAnswer = [NSString stringWithFormat:@"%@", [self.lblSentence.text stringByReplacingOccurrencesOfString:@"|" withString:@" "]];
        DLog(@"组合后的数据: %@; subject: %@; rightAnswer: %@", strAnswer, view.subject, rightAnswer);
        isCheckRight = [[strAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[rightAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
}

- (void)dropView:(HSDropView *)view selectedText:(NSString *)text center:(CGPoint)center
{
    [self.lblSentence trimTextWithString:text];
    [self.dragView reShowDragLabelWithText:text fromCenter:center];
    
    if (self.btnContinue.enabled)
    {
        self.btnContinue.backgroundColor = [UIColor lightGrayColor];
        self.btnContinue.layer.borderWidth = 0;
        self.btnContinue.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.btnContinue setTitleColor:kColorWhite forState:UIControlStateNormal];
        self.btnContinue.enabled = NO;
    }
}

#pragma mark - Button Action
- (void)playAudioAction:(id)sender
{
    HSAudioPlayerButton *audioButton = (HSAudioPlayerButton *)sender;
    if (audioButton.isPlaying){
        [audioButton stopPlay];
    }else{
        [audioButton playAudio:self.audioPath completion:^(BOOL finished, NSError *error) {}];
    }
}

- (void)checkAnswerAction:(id)sender
{
    // 播放音频
    [self playCheckResult:isCheckRight];
    // 改变每个item的背景色。
    for (HSDragLabel *lbl in self.dropView.arrDropLabel)
    {
        UIColor *color = kColorLightRed;
        if (isCheckRight)
        {
            color = kColorLightGreen;
            [HSUIAnimateHelper popUpAnimationWithView:lbl];
        }
        lbl.backgroundColor = color;
        lbl.textColor = kColorWhite;
        lbl.userInteractionEnabled = NO;
    }
    
    if (!isCheckRight)
    {
        // 显示出来正确答案。
        NSString *strSen = [[NSString alloc] initWithFormat:@"%@^%@", self.sentenceData.chinese, self.sentenceData.pinyin];
        self.lblAnswer.text = strSen;
        [HSUIAnimateHelper popUpAnimationWithView:self.lblAnswer];
    }
    
    // 改变按钮状态
    UIButton *btn = (UIButton *)sender;
    [self bringSubviewToFront:btn];
    [btn setTitle:MyLocal(@"继续") forState:UIControlStateNormal];
    [btn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [btn removeTarget:self action:NSSelectorFromString(NSStringFromSelector(_cmd)) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = kColorMain;
    [btn addTarget:self action:@selector(continueAction:) forControlEvents:UIControlEventTouchUpInside];
    [HSUIAnimateHelper popUpAnimationWithView:btn];
}

- (void)continueAction:(id)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicFinishedToContinue)])
    {
        [self.delegate topicFinishedToContinue];
    }
}

- (void)playAudio
{
    [self playAudioAction:self.btnAudioPlayer];
}

- (void)playMedia
{
    [self playAudioAction:self.btnAudioPlayer];
}


- (void)playCheckResult:(BOOL)right
{
    NSString *audio = @"wrong.mp3";
    if (right){
        audio = @"right.mp3";
    }
    [AudioPlayHelper stopAndCleanAudioPlay];
    NSString *path = [[NSBundle mainBundle] pathForResource:audio ofType:nil];
    AudioPlayHelper *audioPlayer = [AudioPlayHelper initWithAudioName:path delegate:nil];
    [audioPlayer playAudio];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    
}

@end
