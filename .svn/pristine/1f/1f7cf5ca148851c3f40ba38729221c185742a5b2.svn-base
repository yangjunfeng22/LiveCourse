//
//  UITestTopicLccj.m
//  LiveCourse
//
//  Created by Lu on 15/1/30.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicLccj.h"
#import "TopicLabel.h"
#import "UITestTopicOptionCustomBtn.h"
#import "HSUIAnimateHelper.h"

#define answerBackViewHeight 180

@interface UITestTopicLccj ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIView *answerBackView;
@property (nonatomic, strong)TopicLabel *answerLabel;
@property (nonatomic, strong)UIView *centerLineView;

@end

@implementation UITestTopicLccj
{
    
    NSString *trueResultStr;//正确答案字符串
    NSMutableArray *trueResultArray;//正确答案数组
    NSMutableArray *userChooseResultArray;
    NSInteger userTrueNum;//正确个数
    
    NSMutableArray *optionArray;
    
    CGRect centerLineToBackViewRect;//横线相对于backscrollview的布局
    
    NSMutableArray *noChooseBtnArray;//未选择的数组
    NSMutableArray *originalFrameArr;//原来的frame数组
    NSMutableArray *hasChooseBtnArray;//已选择的数组
    
    NSString *userChooseStr;//用户选择后显示的字符串
    
    ExamModel *parentExamModel;
    
    
    
    CGRect btnOlgFrame;//旧的frame
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
    
    userChooseResultArray = [NSMutableArray arrayWithCapacity:2];
    userTrueNum = 0;
    
    optionArray = [NSMutableArray arrayWithCapacity:2];
    hasChooseBtnArray = [NSMutableArray arrayWithCapacity:2];
    originalFrameArr = [NSMutableArray arrayWithCapacity:2];
    noChooseBtnArray = [NSMutableArray arrayWithCapacity:2];
    
    [optionArray setArray:[parentExamModel.items componentsSeparatedByString:@"|"]];
    
    //去除空数据
    [optionArray removeObject:@""];
    
    
    trueResultStr = [parentExamModel.answer stringByReplacingOccurrencesOfString:@"|" withString:@"\n\n"];
    trueResultArray = [NSMutableArray arrayWithArray:[parentExamModel.answer componentsSeparatedByString:@"|"]];
    
    for (NSInteger j = 0; j < optionArray.count; j++) {
        
        //初始化用户选择的答案全部设置为-1
        [userChooseResultArray addObject:@"-1"];
    }
    
    [self loadAnswerUI];
    
    [self loadOption];
}


-(void)loadAnswerUI{
    self.answerBackView.backgroundColor = kColorClear;
    
    self.centerLineView.backgroundColor = kColorMain;
    
    centerLineToBackViewRect = [self.backScrollView convertRect:self.centerLineView.frame fromView:self.answerBackView];
    
}


-(void)loadOption{
    
    CGFloat optionBottom = 10;
    CGFloat optionSpace = 10;
    CGFloat optionRight = 15;
    CGFloat optionTop = self.answerBackView.bottom + 20;
    CGFloat horizontalSpace = 10;
    
    for (NSInteger i = 0; i < optionArray.count; i++) {
        
        UITestTopicOptionCustomBtn *optionBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(0, optionTop, 300, 45)];
        
        //拖动事件
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [optionBtn setUserInteractionEnabled:YES];
        pan.delegate = self;
        [optionBtn addGestureRecognizer:pan];
        
        
        [optionBtn setAbcLabelText:@"" andDetailLabelText:[optionArray objectAtIndex:i]];
        [optionBtn.detailLabel sizeToFit];
        optionBtn.detailLabel.left = 10;
        optionBtn.detailLabel.textColor = kColorWhite;
        optionBtn.detailLabel.backgroundColor = kColorClear;
        [optionBtn.detailLabel isPinyinHighlight:NO andColor:kColorWhite];
        
        optionBtn.left = optionRight;
        optionBtn.width = optionBtn.detailLabel.right + 10;
        
        //如果label过大则换行
        if (optionBtn.right + 20 > self.backScrollView.width) {
            
            optionTop = optionBottom + optionSpace;
            optionBtn.top = optionTop;
            
            optionBtn.left = 15;
        }
        optionBtn.tag = KTestTopicLccjTag + i;
        [optionBtn addTarget:self action:@selector(chooseOption:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backScrollView addSubview:optionBtn];
        optionBottom = optionBtn.bottom;
        optionRight = optionBtn.right + horizontalSpace;
        [optionBtn setBackgroundImage:[UIImage imageWithColor:kColorMain andSize:optionBtn.size] forState:UIControlStateNormal];
        optionBtn.backgroundColor = kColorClear;
        
        NSString *frameStr = [NSString stringWithFormat:@"%@",NSStringFromCGRect(optionBtn.frame)];
        
        [originalFrameArr addObject:frameStr];
        [noChooseBtnArray addObject:optionBtn];
    }
    
    self.backScrollView.contentSize = CGSizeMake(0, optionBottom + 20);
    self.backScrollView.backgroundColor = kColorClear;
}





-(void)handlePan: (UIPanGestureRecognizer *)rec{
    if ([rec.view class] != [UITestTopicOptionCustomBtn class]) {
        return;
    }
    
    UITestTopicOptionCustomBtn *tempView = (UITestTopicOptionCustomBtn *)rec.view;
    
    
    if(rec.state == UIGestureRecognizerStateBegan){
        [self.backScrollView bringSubviewToFront:tempView];
        btnOlgFrame = tempView.frame;
//        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            CGAffineTransform transform = CGAffineTransformMakeScale(1.1, 1.1);
//            tempView.transform = transform;
//        } completion:^(BOOL finished) {
//        }];
        
        [tempView setBackgroundImage:[UIImage imageWithColor:kColorLightGreen andSize:tempView.size] forState:UIControlStateNormal];
        tempView.layer.borderColor = kColorLightGreen.CGColor;
        
    }
    else if (rec.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint point = [rec translationInView:self];
        
        CGSize backScrollContentSize = self.backScrollView.contentSize;
        
        CGFloat left = (tempView.left + point.x) <= 0 ? 0 : (tempView.left + point.x);
        if ((left + tempView.width) >= tempView.superview.width) {
            left = tempView.superview.width - tempView.width;
        }
        
        CGFloat top = (tempView.top + point.y) <= 0 ? 0 : (tempView.top + point.y);
        if ((top + tempView.height) >= backScrollContentSize.height) {
            top = backScrollContentSize.height - tempView.height;
        }
        
        tempView.origin = CGPointMake(left, top);

        [rec setTranslation:CGPointZero inView:self];
        
        
        
        //判断是否到了答题框
        if (CGRectContainsPoint(self.answerBackView.frame, tempView.center)) {
            
            [UIView animateWithDuration:0.2f animations:^{
                self.answerBackView.layer.borderWidth = 1.5f;
                self.answerBackView.layer.borderColor = kColorGreen.CGColor;
                self.centerLineView.backgroundColor = kColorGreen;
                self.centerLineView.height = 1.5f;
            }];
            
            
            
            
            //挤他的兄弟
//            BOOL hasCrowdedOtherBtn = NO;
            for (NSInteger i = 0; i < hasChooseBtnArray.count; i++) {
                UITestTopicOptionCustomBtn *hasChooseBtn = [hasChooseBtnArray objectAtIndex:i];
                
                if (hasChooseBtn != tempView && ![hasChooseBtnArray containsObject:tempView]) {
                    if (CGRectContainsPoint(hasChooseBtn.frame, tempView.center)) {
                        DLog(@"碰到我了啊------------%@",hasChooseBtn.detailLabel.text);
                        
//                        [hasChooseBtnArray insertObject:tempView atIndex:i];
//                        
//                        [self resetHasChooseBtnFrame];
                        
//                        hasCrowdedOtherBtn = YES;
                        break;
                    }
                }
            }

        }else{
//            DLog(@"不在框框-------");
            [UIView animateWithDuration:0.2f animations:^{
                self.answerBackView.layer.borderWidth = 1.0f;
                self.answerBackView.layer.borderColor = kColorMain.CGColor;
                self.centerLineView.backgroundColor = kColorMain;
                self.centerLineView.height = 1.0f;
            }];
            
        }
        
    }
    else if (rec.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2f animations:^{
            self.answerBackView.layer.borderWidth = 1.0f;
            self.answerBackView.layer.borderColor = kColorMain.CGColor;
            self.centerLineView.backgroundColor = kColorMain;
            self.centerLineView.height = 1.0f;
            
            [tempView setBackgroundImage:[UIImage imageWithColor:kColorMain andSize:tempView.size] forState:UIControlStateNormal];
            tempView.layer.borderColor = kColorMain.CGColor;
        }];
        
        
        if (CGRectContainsPoint(self.answerBackView.frame, tempView.center)) {
            
            //放进去比较复杂
//            DLog(@"放放放放放放放放到了框框-------");
//            if ([hasChooseBtnArray containsObject:tempView]) {
//                [UIView animateWithDuration:0.3f animations:^{
//                    tempView.frame = btnOlgFrame;
//                    
//                } completion:^(BOOL finished) {
//                    [HSUIAnimateHelper popUpAnimationWithView:tempView];
//                }];
//
//            }else{
            
                
                //挤他的兄弟
                BOOL hasCrowdedOtherBtn = NO;
                NSInteger touchOthetBtnIndex = -1;
                for (NSInteger i = 0; i < hasChooseBtnArray.count; i++) {
                    UITestTopicOptionCustomBtn *hasChooseBtn = [hasChooseBtnArray objectAtIndex:i];
                    
                    if (hasChooseBtn != tempView) {
                        if (CGRectContainsPoint(hasChooseBtn.frame, tempView.center)) {
                            DLog(@"放下碰到了啊------------%@",hasChooseBtn.detailLabel.text);
                            hasCrowdedOtherBtn = YES;
                            touchOthetBtnIndex = i;
                            break;
                        }
                    }
                }
                if (hasCrowdedOtherBtn) {
                    
                    if (![hasChooseBtnArray containsObject:tempView]) {
                        [hasChooseBtnArray insertObject:tempView atIndex:touchOthetBtnIndex];
                        [noChooseBtnArray removeObject:tempView];
                        
                        [tempView removeTarget:self action:@selector(chooseOption:) forControlEvents:UIControlEventTouchUpInside];
                        [tempView addTarget:self action:@selector(showAnswerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }else{
                        //交换位置
                        NSInteger tempBtnIndex = [hasChooseBtnArray indexOfObject:tempView];
                        [hasChooseBtnArray exchangeObjectAtIndex:tempBtnIndex withObjectAtIndex:touchOthetBtnIndex];
                    }
                    [self resetHasChooseBtnFrame];

                }else{
                    
                    if ([hasChooseBtnArray containsObject:tempView]) {
                        [UIView animateWithDuration:0.3f animations:^{
                            tempView.frame = btnOlgFrame;
                            
                        } completion:^(BOOL finished) {
                            [HSUIAnimateHelper popUpAnimationWithView:tempView];
                        }];
                        return;
                    }else{
                        [self chooseOption:tempView];
                    }
                    
                }
                
//                [self chooseOption:tempView];
            
//            }
            
        }else{
//            DLog(@"不不不不不不不不不在框框-------");
            if ([noChooseBtnArray containsObject:tempView]) {
                [UIView animateWithDuration:0.2f animations:^{
                    tempView.frame = btnOlgFrame;
                    
                } completion:^(BOOL finished) {
                    [HSUIAnimateHelper popUpAnimationWithView:tempView];
                }];
            }else{
                [self showAnswerBtnClick:tempView];
            }
            
        }
        
//        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
//            tempView.transform = transform;
//        } completion:^(BOOL finished) {
//        }];
    }
}



//添
-(void)chooseOption:(id)sender
{
    if ([sender class] != [UITestTopicOptionCustomBtn class]) {
        return;
    }
    
    UITestTopicOptionCustomBtn *chooseBtn = (UITestTopicOptionCustomBtn *)sender;
    
    if ([hasChooseBtnArray containsObject:chooseBtn]) {
        return;
    }
    
    CGPoint point = CGPointZero;
    //先看是否存在已选择的数据
    if (hasChooseBtnArray.count > 0) {
        UITestTopicOptionCustomBtn *lastBtn = [hasChooseBtnArray lastObject];
        
        CGFloat left = lastBtn.right + 10;
        CGFloat right = left + chooseBtn.width + 10;
        CGFloat top = lastBtn.top;
        //如果right大于框框 则换行
        if (right > self.answerBackView.right) {
            
            left = centerLineToBackViewRect.origin.x + 10;
            top = lastBtn.bottom + 10;
        }
        
        point = CGPointMake(left , top);
        
    }else{
        point = CGPointMake(centerLineToBackViewRect.origin.x + 10, centerLineToBackViewRect.origin.y + 10);
    }
    
    [chooseBtn removeTarget:self action:@selector(chooseOption:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBtn addTarget:self action:@selector(showAnswerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加到数组
    [hasChooseBtnArray addObject:chooseBtn];
    [noChooseBtnArray removeObject:chooseBtn];
    
    [UIView animateWithDuration:0.3f animations:^{
        chooseBtn.origin = point;
        if (chooseBtn.bottom > (self.answerBackView.top + answerBackViewHeight)) {
            self.answerBackView.height  = chooseBtn.bottom + 10;
        }else{
            self.answerBackView.height = answerBackViewHeight;
        }
        
        [HSUIAnimateHelper popUpAnimationWithView:chooseBtn];
        
        [self resetNoChooseBtnFrame];
        
    } completion:^(BOOL finished) {
        //更新标题
        [self setAnswerLabelText];
    }];
}


//删
-(void)showAnswerBtnClick:(id)sender
{
    if ([sender class] != [UITestTopicOptionCustomBtn class]) {
        return;
    }
    UITestTopicOptionCustomBtn *showAnswerBtn = (UITestTopicOptionCustomBtn *)sender;
//    if (![hasChooseBtnArray containsObject:showAnswerBtn]) {
//        return;
//    }
    
    NSInteger deleteBtnTag = showAnswerBtn.tag - KTestTopicLccjTag;
    
    CGRect oldRect = CGRectFromString([originalFrameArr objectAtIndex:deleteBtnTag]) ;
    
    [showAnswerBtn removeTarget:self action:@selector(showAnswerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [showAnswerBtn addTarget:self action:@selector(chooseOption:) forControlEvents:UIControlEventTouchUpInside];
    
    [hasChooseBtnArray removeObject:showAnswerBtn];
    [noChooseBtnArray addObject:showAnswerBtn];
    
    //编辑答案
    [self editResultArray];
    
    [UIView animateWithDuration:0.3f animations:^{
        [HSUIAnimateHelper popUpAnimationWithView:showAnswerBtn];
        showAnswerBtn.origin = oldRect.origin;
        
        [self resetShowBtnFrame];
        
        [self resetNoChooseBtnFrame];
        
    } completion:^(BOOL finished) {
        [self setAnswerLabelText];
    }];
}

//重新设置后面答案按钮的布局
-(void)resetShowBtnFrame{
    
    
    for (NSInteger i = 0; i < hasChooseBtnArray.count; i ++) {
        
        //如果删除的是第一个
        CGPoint point = CGPointZero;

        UITestTopicOptionCustomBtn *showAnswerBtn = [hasChooseBtnArray objectAtIndex:i];
        
        if (i == 0) {
            point = CGPointMake(centerLineToBackViewRect.origin.x + 10, centerLineToBackViewRect.origin.y + 10);
        }else{
            
            UITestTopicOptionCustomBtn *lastBtn = [hasChooseBtnArray objectAtIndex:(i - 1)];
            
            CGFloat left = lastBtn.right + 10;
            CGFloat right = left + showAnswerBtn.width + 10;
            CGFloat top = lastBtn.top;
            //如果right大于框框 则换行
            if (right > self.answerBackView.right) {
                
                left = centerLineToBackViewRect.origin.x + 10;
                top = lastBtn.bottom + 10;
                
            }
            
            point = CGPointMake(left , top);
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            showAnswerBtn.origin = point;
            
            if (showAnswerBtn.bottom > (self.answerBackView.top + answerBackViewHeight)) {
                self.answerBackView.height  = showAnswerBtn.bottom + 20;
            }else{
                self.answerBackView.height = answerBackViewHeight;
            }
        
        } completion:^(BOOL finished) {
            
        }];
    }
}


/**
 *  重置未选择的布局
 */
-(void)resetNoChooseBtnFrame{
    
    
    for (NSInteger i = 0; i < noChooseBtnArray.count; i ++) {
        
        CGPoint point = CGPointZero;
        
        UITestTopicOptionCustomBtn *tempBtn = [noChooseBtnArray objectAtIndex:i];
        
        if (i == 0) {
            point = CGPointMake(15, self.answerBackView.bottom + 20);
        }else{
            
            UITestTopicOptionCustomBtn *lastBtn = [noChooseBtnArray objectAtIndex:(i - 1)];
            
            CGFloat left = lastBtn.right + 10;
            CGFloat right = left + tempBtn.width + 10;
            CGFloat top = lastBtn.top;
            //如果right大于框框 则换行
            if (right > self.answerBackView.right) {
                
                left = 15;
                top = lastBtn.bottom + 10;
            }
            
            point = CGPointMake(left , top);
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            tempBtn.origin = point;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}



/**
 *  重置已选择的
 */
-(void)resetHasChooseBtnFrame{
    
    DLog(@"重置选择后的布局");
    for (NSInteger i = 0; i < hasChooseBtnArray.count; i ++) {
        
        CGPoint point = CGPointZero;
        
        UITestTopicOptionCustomBtn *tempBtn = [hasChooseBtnArray objectAtIndex:i];
        
        if (i == 0) {
            point = CGPointMake(centerLineToBackViewRect.origin.x + 10, centerLineToBackViewRect.origin.y + 10);
        }else{
            
            UITestTopicOptionCustomBtn *lastBtn = [hasChooseBtnArray objectAtIndex:(i - 1)];
            
            CGFloat left = lastBtn.right + 10;
            CGFloat right = left + tempBtn.width + 10;
            CGFloat top = lastBtn.top;
            //如果right大于框框 则换行
            if (right > self.answerBackView.right) {
                
                left = centerLineToBackViewRect.origin.x + 10;
                top = lastBtn.bottom + 10;
            }
            
            point = CGPointMake(left , top);
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            tempBtn.origin = point;
            
            if (tempBtn.bottom > (self.answerBackView.top + answerBackViewHeight)) {
                self.answerBackView.height  = tempBtn.bottom + 10;
            }else{
                self.answerBackView.height = answerBackViewHeight;
            }
            
            [self resetNoChooseBtnFrame];
            
        } completion:^(BOOL finished) {
            //更新标题
            [self setAnswerLabelText];
        }];
    }
}

//设置标题
-(void)setAnswerLabelText{
    
    userChooseStr = nil;
    
    for (NSInteger i = 0; i < hasChooseBtnArray.count; i ++) {
        
        UITestTopicOptionCustomBtn *showAnswerBtn = [hasChooseBtnArray objectAtIndex:i];
        NSString *detailStr = showAnswerBtn.detailLabel.text;
        NSString *chineseStr = [[detailStr componentsSeparatedByString:@"^"] objectAtIndex:0];
        
        if (!userChooseStr) {
            userChooseStr = chineseStr;
        }else{
            userChooseStr = [userChooseStr stringByAppendingString:chineseStr];
        }
    }
    
    
    self.answerLabel.text = userChooseStr;
    [self.answerLabel sizeToFit];
    
    self.answerLabel.centerX = self.answerBackView.width/2;
    self.answerLabel.centerY = self.centerLineView.top/2;
    
    [self editResultArray];
   
}

//编辑答案数组
-(void)editResultArray{
    //更改答案
    for (NSInteger i = 0; i < userChooseResultArray.count; i ++) {
        
        if (i < hasChooseBtnArray.count) {
            
            UITestTopicOptionCustomBtn *showAnswerBtn = [hasChooseBtnArray objectAtIndex:i];
            NSInteger result = showAnswerBtn.tag - KTestTopicLccjTag;
            [userChooseResultArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%i",result]];
        }else{
            [userChooseResultArray replaceObjectAtIndex:i withObject:@"-1"];
        }
    }
    
//    DLog(@"答案数组-----%@",userChooseResultArray);
    
    if (![userChooseResultArray containsObject:@"-1"]) {
        [self editContinueBtnIsEnable:YES];
    }else{
        [self editContinueBtnIsEnable:NO];
    }
    
    NSString *firstChoose = [userChooseResultArray firstObject];
    if (![firstChoose isEqualToString:@"-1"]) {
        [self editResetBtnIsEnable:YES];
    }else{
        [self editResetBtnIsEnable:NO];
    }
}


-(NSInteger)checkResultAndReturnRightStarNum
{
    NSString *chooseStr = self.answerLabel.text;
    
    BOOL isRight = NO;
    for (NSString *trueStr in trueResultArray) {
        
//        NSString *newStr = [HSBaseTool removerSymbol:trueStr];
        
        NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *str = [[NSString alloc]initWithString:[trueStr stringByTrimmingCharactersInSet:whiteSpace]];
        
        if ([chooseStr isEqualToString:str]) {
            isRight = YES;
            break;
        }
    }
    
    if (isRight) {
        
        
        for (NSInteger i = 0; i < hasChooseBtnArray.count; i ++) {
            UITestTopicOptionCustomBtn *showAnswerBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:i + KTestTopicLccjTag];
            showAnswerBtn.selected = YES;
            [showAnswerBtn setIfUserChooseRight];
            showAnswerBtn.userInteractionEnabled = NO;
        }
        
        [self savePracticeRecordWithTopicID:parentExamModel.eID result:YES answer:chooseStr];
        
        return 1;
        
    }else{
        
        for (NSInteger i = 0; i < hasChooseBtnArray.count; i ++) {
            UITestTopicOptionCustomBtn *showAnswerBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:i + KTestTopicLccjTag];
            showAnswerBtn.selected = YES;
            [showAnswerBtn setIfUserChooseWrong];
            showAnswerBtn.userInteractionEnabled = NO;
        }
        
        [self showTrueAnswer];
        
        [self savePracticeRecordWithTopicID:parentExamModel.eID result:NO answer:chooseStr];
        
        return 0;
    }
}

//显示正确答案
-(void)showTrueAnswer{
    
    UILabel *trueAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.answerBackView.bottom + 20, self.backScrollView.width - 20, 50)];
    trueAnswerLabel.numberOfLines = 0;
    trueAnswerLabel.textColor = kColorGreen;
    trueAnswerLabel.text = trueResultStr;
    trueAnswerLabel.textAlignment = NSTextAlignmentCenter;
    [self.backScrollView addSubview:trueAnswerLabel];
    [trueAnswerLabel sizeToFit];
    trueAnswerLabel.centerX = self.backScrollView.width*0.5;
    [HSUIAnimateHelper popUpAnimationWithView:trueAnswerLabel];
}


-(void)resetAllOption{
    
    UITestTopicOptionCustomBtn *showAnswerBtn = [hasChooseBtnArray firstObject];
    
    [self showAnswerBtnClick:showAnswerBtn];
    
    if (hasChooseBtnArray.count > 0) {
        [self resetAllOption];
    }
    
}

#pragma mark - UI
-(UIView *)answerBackView{
    if (!_answerBackView) {
        CGFloat left = 15;
        _answerBackView = [[UIView alloc] initWithFrame:CGRectMake(left, 10, self.backScrollView.width - 2*left, answerBackViewHeight)];
        _answerBackView.layer.borderColor = kColorMain.CGColor;
        _answerBackView.layer.borderWidth = 1.0f;
        _answerBackView.layer.cornerRadius = 12.0f;
        _answerBackView.layer.masksToBounds = YES;
        [self.backScrollView addSubview:_answerBackView];
    }
    return _answerBackView;
}

-(TopicLabel *)answerLabel{
    if (!_answerLabel) {
        _answerLabel = [[TopicLabel alloc] initWithFrame:CGRectMake(0, 5, self.answerBackView.width, 40)];
        _answerLabel.textColor = kColorWord;
        _answerLabel.font = [UIFont systemFontOfSize:16.0f];
        [_answerLabel isPinyinHighlight:YES andColor:kColorMain];
        [self.answerBackView addSubview:_answerLabel];
    }
    return _answerLabel;
}

-(UIView *)centerLineView{
    if (!_centerLineView) {
        _centerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.answerLabel.bottom + 5, self.answerBackView.width, 1)];
        _centerLineView.backgroundColor = kColorMain;
        [self.answerBackView addSubview:_centerLineView];
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
