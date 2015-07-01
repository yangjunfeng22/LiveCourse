//
//  UICourseItemKnowledgeWordView.m
//  LiveCourse
//
//  Created by Lu on 15/1/14.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseItemKnowledgeWordView.h"
#import "UICourseItemKnowledgeSentenceView.h"
#import "TopicLabel.h"

typedef enum {
    ATCurUp = 1,
    ATCurDown = 2
} animationType;

@interface UICourseItemKnowledgeWordView ()<UICourseItemKnowledgeSentenceDelegate>

@property (nonatomic, strong) UIView *backView;//卡片背景
@property (nonatomic, strong) UIView *centerHorizontalLine;//中央横线
@property (nonatomic, strong) UIButton *exSentenceBtn;//查看例句按钮

@property (nonatomic, strong) UIScrollView *wordScrollView;//词
@property (nonatomic, strong) UIScrollView *descriptionScrollView;//解释

@property (nonatomic, strong) UICourseItemKnowledgeSentenceView *sentenceView;//例句视图


@property (nonatomic, strong) UILabel *wordLabel;//词
@property (nonatomic, strong) TopicLabel *quoteLabel; // 引用
@property (nonatomic, strong) UILabel *quoteToLocalLabel;//引用翻译

@property (nonatomic, strong) UILabel *descriptionLabel;//例句
@property (nonatomic, strong) UILabel *descriptionLocalLabel;//翻译

@end


@implementation UICourseItemKnowledgeWordView
{
    NSString *kID;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorClear;
    }
    return self;
}


-(void)loadWithData{
    
    }

-(void)loadWithKnowledgeModel:(KnowledgeModel *)model{
    
    kID = model.kID;
    
    self.backView.backgroundColor = kColorClear;
    self.centerHorizontalLine.backgroundColor = kColorMain;
    self.exSentenceBtn.backgroundColor = kColorClear;
    
    self.wordLabel.text = model.title;
    NSString *quoteStr = [[model.quote stringByAppendingString:@"^"] stringByAppendingString:model.quotePinyin];
    self.quoteLabel.text = quoteStr;
    self.quoteLabel.width = self.wordScrollView.width - 20;
    [self.quoteLabel sizeToFit];
    self.quoteLabel.centerX = self.wordScrollView.width/2;
    
    self.quoteToLocalLabel.top = self.quoteLabel.bottom + 20;
    self.quoteToLocalLabel.text = model.tQuote;
    
    self.wordScrollView.contentSize = CGSizeMake(0, self.quoteToLocalLabel.bottom + 10);
    self.descriptionLabel.text = model.explain;
    [self.descriptionLabel sizeToFit];
    
    self.descriptionLocalLabel.text = model.tExplain;
    
    [self.descriptionLocalLabel sizeToFit];
    
    self.descriptionScrollView.contentSize = CGSizeMake(0, self.descriptionLocalLabel.bottom + 10);

}


-(void)rotationToStartStatus{
    if (self.isOverturn) {
        [self hideSentenceView];
        self.isOverturn = NO;
    }
}

#pragma mark - action
-(void)showSentenceView:(id)sender
{
    if (self.isOverturn) {
        [self hideSentenceView];
        self.isOverturn = NO;
    }else{
        [self showSentenceView];
        self.isOverturn = YES;
    }
}

-(void)showSentenceView
{
    self.sentenceView.hidden = NO;
    [self animation:ATCurUp];
    
    // 显示的时候再去加载一次数据。
    [self.sentenceView loadDataWithKeyWord:self.wordLabel.text KID:kID];
}

-(void)hideSentenceView
{
    self.sentenceView.hidden = YES;
    [self animation:ATCurDown];
}

- (void)animation:(animationType)animationType
{
    [UIView beginAnimations:@"slideAnimation" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (ATCurUp == animationType) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.backView cache:YES];
    }else{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.backView cache:YES];
    }
    [UIView commitAnimations];
}

//UICourseItemKnowledgeSentenceDelegate
-(void)rotationToWordView{
    [self showSentenceView:nil];
}

#pragma mark - UI
-(UIView *)backView{
    if (!_backView) {
        CGRect frame = CGRectMake(15, 10, self.width - 30, self.height - 10);
        _backView = [[UIView alloc] initWithFrame:frame];
        _backView.layer.borderWidth = 1.0f;
        _backView.layer.borderColor = [kColorMain CGColor];
        _backView.layer.cornerRadius = 10.0f;
        _backView.layer.masksToBounds = YES;
        [self addSubview:_backView];
    }
    return _backView;
}


-(UIView *)centerHorizontalLine{
    if (!_centerHorizontalLine) {
        _centerHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.height/2, self.backView.width, 1)];
        _centerHorizontalLine.backgroundColor = kColorMain;
        [self.backView addSubview:_centerHorizontalLine];
    }
    return _centerHorizontalLine;
}

-(UIButton *)exSentenceBtn{
    if (!_exSentenceBtn) {
        _exSentenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exSentenceBtn.left = 0;
        _exSentenceBtn.height = 40;
        _exSentenceBtn.bottom = self.backView.height;
        _exSentenceBtn.width = self.backView.width;
    
        [_exSentenceBtn setTitle:MyLocal(@"点击查看例句") forState:UIControlStateNormal];
        [_exSentenceBtn setTitleColor:kColorWord forState:UIControlStateNormal];
        _exSentenceBtn.titleLabel.font = kFontHel(16);
        [_exSentenceBtn addTarget:self action:@selector(showSentenceView:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_exSentenceBtn];
    }
    return _exSentenceBtn;
}

-(UIScrollView *)wordScrollView{
    if (!_wordScrollView) {
        CGRect frame = CGRectMake(5, 5, self.backView.width - 10, self.backView.height/2 - 10);
        _wordScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _wordScrollView.backgroundColor = kColorClear;
        [self.backView addSubview:_wordScrollView];
    }
    return _wordScrollView;
}

-(UIScrollView *)descriptionScrollView{
    if (!_descriptionScrollView) {
        CGRect frame = CGRectMake(5, self.backView.height/2 + 5, self.backView.width - 10, self.exSentenceBtn.top - self.backView.height/2);
        _descriptionScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _descriptionScrollView.backgroundColor = kColorClear;
        [self.backView addSubview:_descriptionScrollView];
    }
    return _descriptionScrollView;
}


-(UICourseItemKnowledgeSentenceView *)sentenceView{
    if (!_sentenceView) {
        _sentenceView = [[UICourseItemKnowledgeSentenceView alloc] initWithFrame:self.backView.bounds];
        _sentenceView.delegate = self;
        [_sentenceView loadDataWithKeyWord:self.wordLabel.text KID:kID];
        [self.backView addSubview:_sentenceView];
    }
    return _sentenceView;
}



-(UILabel *)wordLabel{
    if (!_wordLabel) {
        _wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.wordScrollView.width - 20, 50)];
        _wordLabel.textColor = kColorMain;
        _wordLabel.font = [UIFont systemFontOfSize:22.0f];
        _wordLabel.textAlignment = NSTextAlignmentCenter;
        _wordLabel.numberOfLines = 1;
        _wordLabel.backgroundColor = kColorClear;
        [self.wordScrollView addSubview:_wordLabel];
    }
    return _wordLabel;
}

-(TopicLabel *)quoteLabel{
    if (!_quoteLabel) {
        _quoteLabel = [[TopicLabel alloc] initWithFrame:CGRectMake(10, self.wordLabel.bottom + 10, self.wordScrollView.width - 20, 60)];
        _quoteLabel.numberOfLines = 2;
        _quoteLabel.textColor = kColorWord;
        _quoteLabel.font = kFontHel(18);
        _quoteLabel.backgroundColor = kColorClear;
        [self.wordScrollView addSubview:_quoteLabel];
    }
    return _quoteLabel;
}

-(UILabel *)quoteToLocalLabel{
    if (!_quoteToLocalLabel) {
        _quoteToLocalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.wordScrollView.width - 20, 50)];
        
        _quoteToLocalLabel.textColor = kColorWord;
        _quoteToLocalLabel.font = [UIFont systemFontOfSize:15.0f];
        _quoteToLocalLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.wordScrollView addSubview:_quoteToLocalLabel];
    }
    return _quoteToLocalLabel;
}

-(UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.descriptionScrollView.width - 20, 60)];
        
        _descriptionLabel.textColor = kColorWord;
        _descriptionLabel.font = kFontHel(18);
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.numberOfLines = 0;
        
        [self.descriptionScrollView addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}


-(UILabel *)descriptionLocalLabel{
    if (!_descriptionLocalLabel) {
        _descriptionLocalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.descriptionLabel.bottom + 10, self.descriptionScrollView.width - 20, 60)];
        
        _descriptionLocalLabel.textColor = kColorWord;
        _descriptionLocalLabel.font = [UIFont systemFontOfSize:16.0f];
        _descriptionLocalLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLocalLabel.numberOfLines = 0;
        
        [self.descriptionScrollView addSubview:_descriptionLocalLabel];
    }
    return _descriptionLocalLabel;
}



@end
