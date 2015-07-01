//
//  UITestTopicGjjzpddc.m
//  LiveCourse
//
//  Created by Lu on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicGjjzpddc.h"
#import "UITestTopicOptionCustomBtn.h"

@interface UITestTopicGjjzpddc ()

@property (nonatomic, strong) TopicLabel *topicTitleLabel;//题目描述
@property (nonatomic, strong) UIView *centerLineView;
@property (nonatomic, strong) UILabel *wenLabel;//问:
@property (nonatomic, strong) TopicLabel *questionLabel;//提问

@property (nonatomic, strong) UITestTopicOptionCustomBtn *rightBtn;
@property (nonatomic, strong) UITestTopicOptionCustomBtn *wrongBtn;

@end


@implementation UITestTopicGjjzpddc
{
    UITestTopicOptionCustomBtn *tempBtn;
    
    NSInteger rightResult;//正确答案
    NSInteger userChooseResult;//用户选择的答案
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadData];
    }
    return self;
}


-(void)loadData
{
    
    self.topicTypeTitleLabel.text = @"根据句子，判断对错";
    
    rightResult = 0;//测试数据
    
    userChooseResult = NO;
    
    self.backScrollView.backgroundColor = kColorClear;
    
    self.topicTitleLabel.text = @"小 李 是 我 儿子 ， 大家 都 叫 我 老 李 。^Xiǎo Lǐ shì wǒ érzi , dàjiā dōu jiào wǒ Lǎo Lǐ .";
    self.topicTitleLabel.top = 0;
    [self.topicTitleLabel sizeToFit];
    
    self.centerLineView.top = self.topicTitleLabel.bottom + 15;
    
    self.wenLabel.text = MyLocal(@"问:");
    self.wenLabel.top = self.centerLineView.bottom +35;
    [self.wenLabel sizeToFit];
    
    self.questionLabel.top = self.centerLineView.bottom + 15;
    self.questionLabel.left = self.wenLabel.right + 5;
    self.questionLabel.width = self.backScrollView.width - self.wenLabel.right - 15;
    self.questionLabel.text = @"小 李 是 我 儿子 ， 大家 都 叫 我 老 李 。^Xiǎo Lǐ shì wǒ érzi , dàjiā dōu jiào wǒ Lǎo Lǐ .";
    [self.questionLabel sizeToFit];
    self.rightBtn.top = self.questionLabel.bottom + 40;
    
    self.wrongBtn.top = self.rightBtn.bottom + 10;
    
    self.backScrollView.contentSize = CGSizeMake(0, self.wrongBtn.bottom + 20);
}

-(NSInteger)checkResultAndReturnRightStarNum{
    self.rightBtn.userInteractionEnabled = NO;
    self.wrongBtn.userInteractionEnabled = NO;
    
    if (rightResult == userChooseResult) {
        //答对
        
        [self editResultBtnIfRight];
        
        return 1;
    }else if(rightResult != userChooseResult)
    {
        //答错
        
        [self editResultBtnIfWrong];
        
        return 0;
    }
    return 0;
}


-(void)editResultBtnIfRight{
    
    [tempBtn setIfUserChooseRight];
}

-(void)editResultBtnIfWrong{
    
    [tempBtn setIfUserChooseWrong];
    
    UITestTopicOptionCustomBtn *tempRightBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:KTestTopicGjjzpddcTag + rightResult];
    [tempRightBtn setIfIsRightButUserNotChoose];
}

- (void) buttonTouch:(id)sender {
    
    [self editContinueBtnIsEnable:YES];
    
    tempBtn.selected = !tempBtn.selected;
    
    UITestTopicOptionCustomBtn *button = (UITestTopicOptionCustomBtn *)sender;
    button.selected = !button.selected;
    
    tempBtn = button;
    
    userChooseResult = button.tag - KTestTopicGjjzpddcTag;
}

#pragma mark - UI
-(TopicLabel *)topicTitleLabel{
    if (!_topicTitleLabel) {
        _topicTitleLabel = [[TopicLabel alloc] init];
        
        _topicTitleLabel.numberOfLines = 0;
        CGFloat left = 15.0f;
        _topicTitleLabel.left = left;
        _topicTitleLabel.width = self.backScrollView.width - left*2;
        _topicTitleLabel.textColor = kColorWord;
        [_topicTitleLabel isPinyinHighlight:YES andColor:kColorMain];
        _topicTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [self.backScrollView addSubview:_topicTitleLabel];
    }
    return _topicTitleLabel;
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
        _questionLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.backScrollView addSubview:_questionLabel];
    }
    return _questionLabel;
}


-(UITestTopicOptionCustomBtn *)rightBtn{
    if (!_rightBtn) {
         CGFloat left = 15;
        _rightBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(left, self.questionLabel.bottom + 40, self.backScrollView.width - left*2, 40)];
        
        _rightBtn.tag = KTestTopicGjjzpddcTag;
        [_rightBtn setTitle:MyLocal(@"对") forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:_rightBtn];
    }
    return _rightBtn;
}

-(UITestTopicOptionCustomBtn *)wrongBtn{
    if (!_wrongBtn) {
        CGFloat left = 15;
        _wrongBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(left, self.rightBtn.bottom + 10, self.backScrollView.width - left*2, 40)];
        
        _wrongBtn.tag = KTestTopicGjjzpddcTag + 1;
        [_wrongBtn setTitle:MyLocal(@"错") forState:UIControlStateNormal];
        [_wrongBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:_wrongBtn];
    }
    return _wrongBtn;
}

@end
