//
//  UITestTopicGjqjxzhsdda.m
//  LiveCourse
//
//  Created by Lu on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicGjqjxzhsdda.h"
#import "UITestTopicOptionCustomBtn.h"

@interface UITestTopicGjqjxzhsdda ()

@property (nonatomic, strong) TopicLabel *topicTitleLabel;//题目描述

@property (nonatomic, strong) UIView *centerLineView;

@end



@implementation UITestTopicGjqjxzhsdda
{
    UITestTopicOptionCustomBtn *tempBtn;
    
    NSInteger rightResult;//正确答案
    NSInteger userChooseResult;//用户选择的答案
    
    ExamModel *parentExamModel;
    
    NSMutableArray *optionArray;
    
}



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)loadDataWithExamModel:(ExamModel *)examModel{
    
    parentExamModel = examModel;
    
    self.topicTypeTitleLabel.text = parentExamModel.tTypeAlias;
    
    [self randomItemsAndAnswer];
    
//    rightResult = [parentExamModel.answer integerValue];
    
    self.topicTitleLabel.text = parentExamModel.subject;
    [self.topicTitleLabel sizeToFit];
    self.topicTitleLabel.top = 30;
    self.topicTitleLabel.centerX = self.backScrollView.width/2;
    
    self.centerLineView.top = self.topicTitleLabel.bottom + 30;
    
    
    //加载答案选项
//    optionArray = [NSMutableArray arrayWithArray:[parentExamModel.items componentsSeparatedByString:@"|"]];
    
    CGFloat firstTop = self.centerLineView.bottom + 20;
    CGFloat lastItemBottom = 0;
    
    for (NSInteger i = 0; i < optionArray.count; i++) {
        
        CGFloat top = firstTop + i*(optionBtnHeight +optionBtnSpace);
        
        UITestTopicOptionCustomBtn *optionBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(optionBtnLeft, top, self.backScrollView.width - optionBtnLeft*2, optionBtnHeight)];
        optionBtn.tag = KTestTopicGjqjxzhsddaTag + i;
        
        [optionBtn setAbcLabelText:[HSBaseTool getAbcStrWithIndex:i] andDetailLabelText:[optionArray objectAtIndex:i]];
        [optionBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        optionBtn.detailLabel.top = 5;
        optionBtn.height = optionBtn.detailLabel.height + 10;
        
        [self.backScrollView addSubview:optionBtn];
        
        lastItemBottom = optionBtn.bottom;
    }
    
    self.backScrollView.contentSize = CGSizeMake(0, lastItemBottom + 20);
}

//随机选项和答案
-(void)randomItemsAndAnswer{
    NSInteger oldAnswer = [parentExamModel.answer integerValue];//旧答案
    NSMutableArray *oldItems = [NSMutableArray arrayWithArray:[parentExamModel.items componentsSeparatedByString:@"|"]];
    
    //根据旧答案获取到正确选项数据
    NSString *trueItemStr = [oldItems objectAtIndex:oldAnswer];
    
    //打乱数据
    optionArray = [NSMutableArray arrayWithArray: [HSBaseTool chaosArrayFromArry:oldItems withReturnNumber:oldItems.count]];
    
    rightResult = [optionArray indexOfObject:trueItemStr];
}

- (void) buttonTouch:(id)sender {
    
    [self editContinueBtnIsEnable:YES];
    
    tempBtn.selected = !tempBtn.selected;
    
    UITestTopicOptionCustomBtn *button = (UITestTopicOptionCustomBtn *)sender;
    button.selected = !button.selected;
    
    tempBtn = button;
    
    userChooseResult = button.tag - KTestTopicGjqjxzhsddaTag;
}

-(NSInteger)checkResultAndReturnRightStarNum{
    for (NSInteger i = 0; i < optionArray.count; i++) {
        UITestTopicOptionCustomBtn *optionCustomBtn  = (UITestTopicOptionCustomBtn*)[self viewWithTag:(KTestTopicGjqjxzhsddaTag + i)];
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
    
    UITestTopicOptionCustomBtn *tempRightBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:KTestTopicGjqjxzhsddaTag + rightResult];
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
        _topicTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_topicTitleLabel isPinyinHighlight:YES andColor:kColorMain];
        
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
