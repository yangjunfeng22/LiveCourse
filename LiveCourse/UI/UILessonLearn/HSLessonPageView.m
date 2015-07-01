//
//  HSLessonPageView.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/15.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSLessonPageView.h"
#import "HSCourseItemWordView.h"
#import "HSCourseItemSentenceView.h"

#import "AudioPlayHelper.h"
#import "UIView+RoundedCorners.h"

#import "HSUIAnimateHelper.h"

#import "WordModel.h"


@interface HSLessonPageView ()<HSCourseItemWordViewDelegate, HSCourseItemSentenceViewDelegate>
{
    id data;
}

@property (nonatomic, strong) HSCourseItemWordView *wordView;
@property (nonatomic, strong) HSCourseItemSentenceView *sentenceView;

@end

@implementation HSLessonPageView
{
    BOOL displayingFrontView;
    __weak UIView *frontView;
    __weak UIView *backView;
    
    LiveCourseCheckPointType cpType;
}


- (HSCourseItemWordView *)wordView
{
    if (!_wordView)
    {
        _wordView = [[HSCourseItemWordView alloc] initWithFrame:self.bounds];
        _wordView.backgroundColor = [UIColor whiteColor];
        
        _wordView.layer.borderWidth = 1;
        _wordView.layer.borderColor = kColorMain.CGColor;
        
        _wordView.layer.cornerRadius = 16;
        _wordView.layer.masksToBounds = YES;
        //_wordView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //_wordView.clipsToBounds = YES;
        
        [self addSubview:_wordView];
    }
    return _wordView;
}

- (HSCourseItemSentenceView *)sentenceView
{
    if (!_sentenceView)
    {
        _sentenceView = [[HSCourseItemSentenceView alloc] initWithFrame:self.bounds];
        _sentenceView.backgroundColor = kColorWhite;
        _sentenceView.layer.borderWidth = 1;
        _sentenceView.layer.borderColor = kColorMain.CGColor;
        
        _sentenceView.layer.cornerRadius = 16;
        _sentenceView.layer.masksToBounds = YES;
        
        //_sentenceView.clipsToBounds = YES;
         
        [self addSubview:_sentenceView];
    }
    return _sentenceView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        
    }
    return self;
}

- (id)initWithPageData:(id)pageData type:(LiveCourseCheckPointType)type
{
    self = [super init];
    if (self)
    {
        //DLog(@"page的数据: %@", pageData);
        data = pageData;
        cpType = type;
        self.backgroundColor = kColorWhite;
        [self initPageContent];
    }
    return self;
}

- (void)initPageContent
{
    switch (cpType)
    {
        case LiveCourseCheckPointTypeWord:
        {
            
            frontView = self.wordView;
            backView = self.sentenceView;
            
            self.wordView.delegate = self;
            self.sentenceView.delegate = self;
            
            WordModel *word = (WordModel *)data;
            displayingFrontView = YES;
            self.wordView.wordData = word;
            NSString *hightStr = [[NSString alloc] initWithFormat:@"%@ %@", word.chinese, word.pinyin];
            self.sentenceView.highlightStrig = hightStr;
            self.sentenceView.sentenceData = word.tSentence;
            [self.sentenceView.btnBack setTitle:MyLocal(@"返回") forState:UIControlStateNormal];
            
            [self bringSubviewToFront:frontView];
            break;
        }
        case LiveCourseCheckPointTypeSentence:
        {
            backView = self.sentenceView;
            [self.sentenceView.btnBack setTitle:@"" forState:UIControlStateNormal];
            self.sentenceView.sentenceData = data;
            break;
        }
            
        default:
            break;
    }
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    frontView.frame = self.bounds;
    backView.frame = self.bounds;
}

- (void)flipViews:(id)sender
{
    [HSUIAnimateHelper transitionFromView:(displayingFrontView ? frontView:backView) toView:(displayingFrontView ? backView:frontView) completion:^(BOOL finished) {
        
    }];
    
    displayingFrontView = !displayingFrontView;
}

- (void)playMediaWithType:(BOOL)playFront
{
    (playFront ? [self.wordView playMedia]:[self.sentenceView playMedia]);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)resignCurrentPage
{
    if (!displayingFrontView && cpType == LiveCourseCheckPointTypeWord)
    {
        [self flipViews:nil];
    }
}

- (void)playMedia
{
    switch (cpType)
    {
        case LiveCourseCheckPointTypeWord:
        {
            [self.wordView playMedia];
            break;
        }
        case LiveCourseCheckPointTypeSentence:
        {
            [self.sentenceView playMedia];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - WordView Delegate
- (void)wordView:(HSCourseItemWordView *)view shouldShowOther:(BOOL)flag
{
    [AudioPlayHelper stopAndCleanAudioPlay];
    
    [self flipViews:view];
    [self playMediaWithType:NO];
}

- (void)sentenceView:(HSCourseItemSentenceView *)view shouldShowOther:(BOOL)flag
{
    [AudioPlayHelper stopAndCleanAudioPlay];
    
    [self flipViews:view];
    [self playMediaWithType:YES];
}

- (void)dealloc
{
    
}

@end
