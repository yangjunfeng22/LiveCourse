//
//  HSCourseItemSentenceView.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/15.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCourseItemSentenceView.h"
#import "UIView+RoundedCorners.h"
#import "SentenceModel.h"
#import "TopicLabel.h"

@interface HSCourseItemSentenceView ()
{
    NSString *sentence;
}

@property (nonatomic, strong) TopicLabel *lblPSentence;

@end

@implementation HSCourseItemSentenceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrViews = [[NSBundle mainBundle] loadNibNamed:@"HSCourseItemSentenceView" owner:nil options:nil];
        
        //DLog(@"views: %@", arrViews);
        if ([arrViews count] < 1){
            return nil;
        }
        
        if (![[arrViews objectAtIndex:0] isKindOfClass:[UIView class]]){
            return nil;
        }
        
        self = [arrViews objectAtIndex:0];
        
        self.btnAudioPlayer.currentButtonType = buttonAudioPlayType;
        self.btnAudioPlayer.currentButtonStyle = audioButtonRoundedStyle;
        self.btnAudioPlayer.roundBackgroundColor = kColorMain;
        [self.btnAudioPlayer addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (TopicLabel *)lblPSentence
{
    if (!_lblPSentence)
    {
        _lblPSentence = [[TopicLabel alloc] initWithFrame:CGRectMake(10, 10, self.width-20, 100)];
        _lblPSentence.textAlignment = NSTextAlignmentCenter;
        _lblPSentence.numberOfLines = 0;
        _lblPSentence.backgroundColor = kColorWhite;
        //_lblPSentence.layer.shadowColor = kColorHintGray.CGColor;
        //_lblPSentence.layer.opacity= 0.6;
        _lblPSentence.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.scrollView addSubview:_lblPSentence];
    }
    return _lblPSentence;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.lblTranslation sizeToFit];
    self.lblTranslation.centerX = self.width * 0.5;
    
    self.lblPSentence.width = self.width * 0.8;
    self.lblPSentence.text = sentence;
    [self.lblPSentence sizeToFit];
    self.lblPSentence.centerX = self.width*0.5;
    CGFloat width = self.scrollView.width;
    CGFloat height = self.lblPSentence.bottom;
    [self.scrollView setContentSize:CGSizeMake(width, height)];
}

- (void)setSentenceData:(id)sentenceData
{
    _sentenceData = sentenceData;
    SentenceModel *sen = (SentenceModel *)sentenceData;
    NSString *chinese = [[NSString alloc] initWithFormat:@"%@^%@", sen.chinese, sen.pinyin];
    sentence = chinese;
    
    //DLog(@"句子区域的宽度: %f", self.lblSentence.width);
    //self.lblSentence.text = chinese;
    self.lblPSentence.text = chinese;
    self.lblPSentence.keyWordHighlightStr = self.highlightStrig;
    self.lblTranslation.text = sen.tChinese;
}

- (IBAction)shouldBackAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sentenceView:shouldShowOther:)])
    {
        [self.delegate sentenceView:self shouldShowOther:YES];
    }
}

- (void)playAudioAction:(id)sender
{
    if (self.btnAudioPlayer.isPlaying)
    {
        [self.btnAudioPlayer stopPlay];
    }
    else
    {
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:((SentenceModel *)_sentenceData).audio];
        [self.btnAudioPlayer playAudio:path completion:^(BOOL finished, NSError *error) {
        }];
    }
}

- (void)playMedia
{
    [self playAudioAction:nil];
}

@end
