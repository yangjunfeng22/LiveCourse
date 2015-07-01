//
//  UICourseItemKnowledgeSentenceView.m
//  LiveCourse
//
//  Created by Lu on 15/1/14.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseItemKnowledgeSentenceView.h"
#import "TopicLabel.h"
#import "CheckPointDAL.h"
#import "SentenceModel.h"


NSInteger sentenceArraySort(SentenceModel *obj1, SentenceModel *obj2, void *context)
{
    float price1 = [obj1.weight floatValue];
    float price2 = [obj2.weight floatValue];
    
    if (price1 > price2) {
        return (NSComparisonResult)NSOrderedDescending;
    }else if (price1 < price2){
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame; ;
}




@interface UICourseItemKnowledgeSentenceView ()

@property (nonatomic, strong) UIButton *backBtn;//返回按钮
@property (nonatomic, strong) UIScrollView *sentenceScrollView;

@end

@implementation UICourseItemKnowledgeSentenceView
{
    NSString *kID;
    NSMutableArray *noGrammarSentenceArray;
    NSMutableDictionary *hasGrammarSentenceDic;
    NSString *keyKnowledgeWord;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorWhite;
        self.backBtn.backgroundColor = kColorClear;
        self.sentenceScrollView.backgroundColor = kColorClear;
        noGrammarSentenceArray = [NSMutableArray arrayWithCapacity:2];
        hasGrammarSentenceDic = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    
    return self;
}

-(void)loadDataWithKeyWord:(NSString *)keyWord KID:(NSString *)knowledgeID{
    
    kID = knowledgeID;
    keyKnowledgeWord = keyWord;

    //先查询没有语法的数据
    [noGrammarSentenceArray setArray:[[CheckPointDAL querySentenceNoGrammarWithKID:kID] sortedArrayUsingFunction:sentenceArraySort context:nil]];
   
    //再查询有语法的数据
    [hasGrammarSentenceDic setDictionary:[CheckPointDAL querySentenceHasGrammarWithKID:kID]];
    
    CGFloat space = 50;
    CGFloat sentenceLabelBottom = 0;
    
    //先加载没有语法数据
    for (SentenceModel *sentenceModel in noGrammarSentenceArray) {
        
        CGFloat top = sentenceLabelBottom + space;
        TopicLabel *sentenceLabel = [[TopicLabel alloc] initWithFrame:CGRectMake(10, top, self.sentenceScrollView.width - 20, 10)];
        
        
        sentenceLabel.text = [[sentenceModel.chinese stringByAppendingString:@"^"] stringByAppendingString:sentenceModel.pinyin];
        
        sentenceLabel.keyWordHighlightStr = keyKnowledgeWord;
        
        sentenceLabel.font = [UIFont systemFontOfSize:16.0f];
        [sentenceLabel sizeToFit];
        sentenceLabel.centerX = self.sentenceScrollView.width/2;
        
        sentenceLabel.textColor = kColorWord;
        
        [self.sentenceScrollView addSubview:sentenceLabel];
        
        //翻译
        UILabel *sentenceLoaclLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, sentenceLabel.bottom + 10, self.sentenceScrollView.width - 20, 10)];
        sentenceLoaclLabel.textAlignment = NSTextAlignmentCenter;
        sentenceLoaclLabel.textColor = kColorWord;
        sentenceLoaclLabel.numberOfLines = 0;
        sentenceLoaclLabel.font = [UIFont systemFontOfSize:16.0f];
        sentenceLoaclLabel.text = sentenceModel.tChinese;
        [sentenceLoaclLabel sizeToFit];
        sentenceLoaclLabel.width = self.sentenceScrollView.width - 20;
        
        sentenceLoaclLabel.centerX = self.sentenceScrollView.width/2;
        [self.sentenceScrollView addSubview:sentenceLoaclLabel];
        
        sentenceLabelBottom  = sentenceLoaclLabel.bottom;
    }
    
    
    //再加载有语法描述的
    NSArray *keys = [hasGrammarSentenceDic allKeys];
    
    
    for (NSString *key in keys) {
        
        NSArray *sentenceArr = [NSArray arrayWithArray:[hasGrammarSentenceDic objectForKey:key]];
        
        for (SentenceModel *sentenceModel in sentenceArr) {
            
            CGFloat top = sentenceLabelBottom + space;
            
            //语法描述
            UILabel *grammarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.sentenceScrollView.width, 25)];
            grammarLabel.backgroundColor = kColorMainHalf;
            grammarLabel.textColor = kColorWhite;
            grammarLabel.font = [UIFont systemFontOfSize:15.0f];
            grammarLabel.text = [NSString stringWithFormat:@"   %@",key];
            [self.sentenceScrollView addSubview:grammarLabel];
            
            TopicLabel *sentenceLabel = [[TopicLabel alloc] initWithFrame:CGRectMake(10, grammarLabel.bottom + 10, self.sentenceScrollView.width - 20, 10)];

            sentenceLabel.text = [[sentenceModel.chinese stringByAppendingString:@"^"] stringByAppendingString:sentenceModel.pinyin];
            
            sentenceLabel.keyWordHighlightStr = keyKnowledgeWord;
            
            sentenceLabel.font = [UIFont systemFontOfSize:16.0f];
            [sentenceLabel sizeToFit];
            sentenceLabel.centerX = self.sentenceScrollView.width/2;
            
            sentenceLabel.textColor = kColorWord;
            
            [self.sentenceScrollView addSubview:sentenceLabel];
            
            //翻译
            UILabel *sentenceLoaclLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, sentenceLabel.bottom + 10, self.sentenceScrollView.width - 20, 10)];
            sentenceLoaclLabel.textAlignment = NSTextAlignmentCenter;
            sentenceLoaclLabel.textColor = kColorWord;
            sentenceLoaclLabel.numberOfLines = 0;
            sentenceLoaclLabel.font = [UIFont systemFontOfSize:16.0f];
            sentenceLoaclLabel.text = sentenceModel.tChinese;
            [sentenceLoaclLabel sizeToFit];
            sentenceLoaclLabel.width = self.sentenceScrollView.width - 20;
            
            sentenceLoaclLabel.centerX = self.sentenceScrollView.width/2;
            [self.sentenceScrollView addSubview:sentenceLoaclLabel];
            
            sentenceLabelBottom  = sentenceLoaclLabel.bottom;
            
            
        }
    }
    
    
    [self.sentenceScrollView setContentSize:CGSizeMake(0, sentenceLabelBottom + 20)];
}

#pragma mark - action
-(void)backToWordView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rotationToWordView)]) {
        [self.delegate performSelector:@selector(rotationToWordView)];
    }
}

#pragma mark - UI
-(UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.left = 0;
        _backBtn.height = 40;
        _backBtn.width = self.width;
        _backBtn.bottom = self.height;
        [_backBtn setTitle:MyLocal(@"返回") forState:UIControlStateNormal];
        [_backBtn setTitleColor:kColorWord forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backToWordView:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_backBtn];
    }
    return _backBtn;
}


-(UIScrollView *)sentenceScrollView{
    if (!_sentenceScrollView) {
        _sentenceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, self.width - 10, self.backBtn.top - 5)];
        [self addSubview:_sentenceScrollView];
    }
    return _sentenceScrollView;
}


@end
