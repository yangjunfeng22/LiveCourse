//
//  UITestTopicXzzqdda.m
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicXzzqdda.h"
#import "UITestTopicOptionCustomBtn.h"

@interface UITestTopicXzzqdda ()

@property (nonatomic, strong) TopicLabel *topicTitleLabel;//题目描述
@property (nonatomic, strong) UIView *centerLineView;

@end



@implementation UITestTopicXzzqdda
{
    NSInteger optionNum;//选项个数
    UITestTopicOptionCustomBtn *tempBtn;
    
    NSInteger rightResult;//正确答案
    NSInteger userChooseResult;//用户选择的答案

}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
    }
    return self;
}


-(void)loadData{
    
    rightResult = 1;
    
    optionNum = 3;
    
    self.topicTypeTitleLabel.text = @"选择正确的答案";
    
    self.backScrollView.contentSize = CGSizeMake(0, 800);
    
    self.topicTitleLabel.text = @"小 李 () 我 儿子^Xiǎo Lǐ () wǒ érzi";
    [self.topicTitleLabel sizeToFit];
    self.topicTitleLabel.top = 15;
    self.topicTitleLabel.centerX = self.backScrollView.width/2;
    self.centerLineView.top = self.topicTitleLabel.bottom + 30;
    
    
    //加载答案选项
    
    CGFloat firstTop = self.centerLineView.bottom + 20;
    CGFloat lastItemBottom = 0;
    for (NSInteger i = 0; i < optionNum; i++) {
        
        CGFloat top = firstTop + i*(optionBtnHeight +optionBtnSpace);
        
        UITestTopicOptionCustomBtn *optionBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(optionBtnLeft, top, self.backScrollView.width - optionBtnLeft*2, optionBtnHeight)];
        optionBtn.tag = KTestTopicXzzqddaTag + i;
        [optionBtn setAbcLabelText:[HSBaseTool getAbcStrWithIndex:i] andDetailLabelText:@"是^shi"];
        [optionBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:optionBtn];
        
        lastItemBottom = optionBtn.bottom;
    }
    
    self.backScrollView.contentSize = CGSizeMake(0, lastItemBottom + 20);
    
}


- (void) buttonTouch:(id)sender {
    
    [self editContinueBtnIsEnable:YES];
    
    tempBtn.selected = !tempBtn.selected;
    
    UITestTopicOptionCustomBtn *button = (UITestTopicOptionCustomBtn *)sender;
    button.selected = !button.selected;
    
    tempBtn = button;
    
    userChooseResult = button.tag - KTestTopicXzzqddaTag;
}


-(NSInteger)checkResultAndReturnRightStarNum{
    for (NSInteger i = 0; i < optionNum; i++) {
        UITestTopicOptionCustomBtn *optionCustomBtn  = (UITestTopicOptionCustomBtn*)[self viewWithTag:(KTestTopicXzzqddaTag + i)];
        optionCustomBtn.userInteractionEnabled = NO;
    }
    
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
    
    UITestTopicOptionCustomBtn *tempRightBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:KTestTopicXzzqddaTag + rightResult];
    [tempRightBtn setIfIsRightButUserNotChoose];
}


#pragma mark - UI

-(TopicLabel *)topicTitleLabel{
    if (!_topicTitleLabel) {
        _topicTitleLabel = [[TopicLabel alloc] init];
        
        _topicTitleLabel.numberOfLines = 0;
        CGFloat left = 15.0f;
        _topicTitleLabel.left = left;
        _topicTitleLabel.width = self.backScrollView.width - left*2;
        _topicTitleLabel.top = 0;
        _topicTitleLabel.height = 80;
        _topicTitleLabel.textColor = kColorWord;
        _topicTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_topicTitleLabel isPinyinHighlight:YES andColor:kColorMain];
        _topicTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
