//
//  UITestTopicXctk.m
//  LiveCourse
//
//  Created by Lu on 15/1/30.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicXctk.h"
#import "UITestTopicOptionCustomBtn.h"
#import "CheckPointDAL.h"

@interface UITestTopicXctk ()

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIView *centerLineView;
@property (nonatomic, strong) UIScrollView *optionScrollView;//选项

@property (nonatomic, strong) UIButton *dragBtn;

@end


@implementation UITestTopicXctk
{
    NSMutableArray *trueResultArray;
    NSMutableArray *userChooseResultArray;
    NSInteger userTrueNum;//正确个数
    
    NSMutableArray *titleArray;
    
    NSMutableArray *optionArray;
    
    BOOL kuoHaoFirstSelected;
    UIButton *kuohaoSelectedBtn;//选中的括号按钮
    NSMutableArray *kuohaoBtnArray;
    
    BOOL isReset;

    ExamModel *parentExamModel;
    NSMutableArray *sonExamModelArray;
    
    BOOL hasDrag;
    NSMutableArray *sonExamArrayEIDArray;
}

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
    }
    return self;
}


-(void)loadDataWithExamModel:(ExamModel *)examModel{
    
    parentExamModel = examModel;
    
    //查询子题
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray: [CheckPointDAL queryFinalTestSonDataWithParentID:parentExamModel.eID]];
    sonExamModelArray = [NSMutableArray arrayWithArray: [HSBaseTool chaosArrayFromArry:tempArray withReturnNumber:tempArray.count]];
    
    
    self.topicTypeTitleLabel.text = parentExamModel.tTypeAlias;
    
    self.titleScrollView.backgroundColor = kColorClear;
    self.centerLineView.top = self.titleScrollView.bottom;
    self.optionScrollView.backgroundColor = kColorClear;
    
    self.dragBtn.backgroundColor = kColorClear;
    [self bringSubviewToFront:self.dragBtn];
    
    trueResultArray = [NSMutableArray arrayWithCapacity:2];
    userChooseResultArray = [NSMutableArray arrayWithCapacity:2];
    userTrueNum = 0;
    kuoHaoFirstSelected = YES;
    isReset = NO;
    kuohaoBtnArray = [NSMutableArray arrayWithCapacity:2];
    
    titleArray = [NSMutableArray arrayWithCapacity:2];
    [titleArray setArray:[parentExamModel.items componentsSeparatedByString:@"|"]];
    
    optionArray = [NSMutableArray arrayWithCapacity:2];
    sonExamArrayEIDArray = [NSMutableArray arrayWithCapacity:2];
    
    for (NSInteger j = 0; j < sonExamModelArray.count; j++) {
        //正确答案数组
        ExamModel *sonModel = [sonExamModelArray objectAtIndex:j];
        
        [trueResultArray addObject:sonModel.answer];
        
        [sonExamArrayEIDArray addObject:sonModel.eID];
        
        //初始化用户选择的答案全部设置为-1
        [userChooseResultArray addObject:@"-1"];
        
        [optionArray addObject:sonModel.subject];
    }
    
    DLog(@"正确答案----%@",trueResultArray);
    
    
    
    
//    [optionArray addObject:@"小 李 是 我 儿子 ， 大家 都 叫 我 老 ()^Xiǎo Lǐ shì wǒ érzi , dàjiā dōu jiào wǒ Lǎo ()"];
//    [optionArray addObject:@"小 李 是 我 ()^Xiǎo Lǐ shì wǒ ()"];
//    [optionArray addObject:@"大家 () 叫 我 老 李^dàjiā () jiào wǒ Lǎo Lǐ"];
    
    
    
    [self loadTitle];
    
    [self loadOption];
}

-(void)loadTitle{
    CGFloat titleBottom = 10;
    CGFloat titleSpace = 20;
    CGFloat titleRight = 20;
    //    CGFloat optionTop = titleLabelBottom + 40;
    CGFloat titleTop = 10;
    CGFloat horizontalSpace = 20;
    
    for (NSInteger i = 0; i < titleArray.count; i++) {
        
        UITestTopicOptionCustomBtn *titleBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(0, titleTop, 300, 45)];
        
        [titleBtn setAbcLabelText:[HSBaseTool getAbcStrWithIndex:i] andDetailLabelText:[titleArray objectAtIndex:i]];
        [titleBtn.detailLabel sizeToFit];
        titleBtn.detailLabel.left = titleBtn.abcLabel.right;
        titleBtn.detailLabel.textColor = kColorMain;
        
        titleBtn.left = titleRight;
        titleBtn.width = titleBtn.detailLabel.right + 10;
        
        //如果label过大则换行
        if (titleBtn.right + 20 > self.titleScrollView.width) {
            
            titleTop = titleBottom + titleSpace;
            titleBtn.top = titleTop;
            
            titleBtn.left = 20;
        }
        titleBtn.tag = KTestTopicXctkTitleTag + i;
        [titleBtn addTarget:self action:@selector(chooseOption:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScrollView addSubview:titleBtn];
        titleBottom = titleBtn.bottom;
        titleRight = titleBtn.right + horizontalSpace;
        
    }
    
    self.titleScrollView.contentSize = CGSizeMake(0, titleBottom + 40);
}


-(void)chooseOption:(id)sender{
    
    UITestTopicOptionCustomBtn *chooseBtn = (UITestTopicOptionCustomBtn *)sender;
    [chooseBtn editBtnUnEnable];
    
    
    //用于显示用户选择的btn 用于显示再（）中
    UIButton *showAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicXctkShowAnswerTag + chooseBtn.tag - KTestTopicXctkTitleTag)];
    
    if (!showAnswerBtn) {
        showAnswerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self.optionScrollView addSubview:showAnswerBtn];
        showAnswerBtn.backgroundColor = kColorClear;
        [showAnswerBtn setTitleColor:kColorMain forState:UIControlStateNormal];

        [showAnswerBtn setTitle:[HSBaseTool getAbcStrWithIndex:(chooseBtn.tag - KTestTopicXctkTitleTag)] forState:UIControlStateNormal];
        showAnswerBtn.tag = KTestTopicXctkShowAnswerTag + chooseBtn.tag - KTestTopicXctkTitleTag;
        [showAnswerBtn addTarget:self action:@selector(showAnswerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    showAnswerBtn.alpha = 1.0f;
    [showAnswerBtn.layer addAnimation:[self coutomAnimation] forKey:@"scale-layer"];
    
    if (kuohaoSelectedBtn) {
        
        showAnswerBtn.center = kuohaoSelectedBtn.center;
        
        NSInteger index = [kuohaoBtnArray indexOfObject:kuohaoSelectedBtn];
        
        [userChooseResultArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%li",(chooseBtn.tag - KTestTopicXctkTitleTag)]];
        
        DLog(@"选择后的userChooseResultArray----------%@",userChooseResultArray);
        
        //光标移动到下一个
        if ([userChooseResultArray containsObject:@"-1"]) {
            NSInteger nextIndex;
            if (index == userChooseResultArray.count - 1) {
                nextIndex  = [userChooseResultArray indexOfObject:@"-1" inRange:NSMakeRange(0, userChooseResultArray.count )];
            }else{
                nextIndex = [userChooseResultArray indexOfObject:@"-1" inRange:NSMakeRange(index, userChooseResultArray.count - index)];
            }
            
            if ([kuohaoBtnArray count] > nextIndex)
            {
                UIButton *nextKuohaoBtn = [kuohaoBtnArray objectAtIndex:nextIndex];
                [self kuohaoBtnClick:nextKuohaoBtn];
                
                if (hasDrag) {
                    CGRect tempRect = CGRectMake(nextKuohaoBtn.left, nextKuohaoBtn.top, nextKuohaoBtn.width, nextKuohaoBtn.height + 40);
                    [self.optionScrollView scrollRectToVisible:tempRect animated:YES];
                    
                }else{
                    [self.optionScrollView scrollRectToVisible:nextKuohaoBtn.frame animated:YES];
                }
                
            }
            
        }else{
            kuohaoSelectedBtn.selected = NO;
            kuohaoSelectedBtn = nil;
        }
    }
    
    
    if (![userChooseResultArray containsObject:@"-1"]) {
        [self editContinueBtnIsEnable:YES];
    }
    
    __weak UITestTopicBaseView *weakSelf = self;
    [userChooseResultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (![obj isEqualToString:@"-1"]) {
            
            [weakSelf editResetBtnIsEnable:YES];
            *stop = YES;
        }
        
    }];
}


-(void)showAnswerBtnClick:(id)sender{
    //取消选中 撤销选好的答案
    
    UIButton *showAnswerBtn = (UIButton *)sender;
    
    UITestTopicOptionCustomBtn *optionBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:showAnswerBtn.tag - KTestTopicXctkShowAnswerTag + KTestTopicXctkTitleTag];
    
    [UIView animateWithDuration:0.2f animations:^{
        //        showAnswerBtn.center = optionBtn.center;
        showAnswerBtn.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [optionBtn editBtnEnable];
        
        optionBtn.detailLabel.textColor = kColorMain;
        optionBtn.abcLabel.textColor = kColorMain;
        
        //修改userChooseResultArray
    }];
    
    NSInteger index = [userChooseResultArray indexOfObject:[NSString stringWithFormat:@"%li",(optionBtn.tag - KTestTopicXctkTitleTag)]];
    [userChooseResultArray replaceObjectAtIndex:index withObject:@"-1"];
    DLog(@"取消后的userChooseResultArray----------%@",userChooseResultArray);
    
    
    //取消后将光标移动到该取消处
    //如果是重置 就不用管
    if (!isReset) {
        UIButton *tempKuohaoBtn = [kuohaoBtnArray objectAtIndex:index];
        [self kuohaoBtnClick:tempKuohaoBtn];
    }
    isReset = NO;
    [self editContinueBtnIsEnable:NO];
}




-(void)loadOption{
    
    CGFloat titleLabelBottom = 0;
    
    CGFloat labelTop = 20;
    
    for (NSInteger i = 0; i < optionArray.count; i ++) {
        
        labelTop = titleLabelBottom + 20;
        
        CGFloat labelRight = 30;
        CGFloat labelHeight = 30;
        
        NSString *optionStr = [optionArray objectAtIndex:i];
        
        NSArray *optionArr = [NSArray arrayWithArray:[optionStr componentsSeparatedByString:@"^"]];
        
        NSString *chineseStr = [optionArr objectAtIndex:0];
        NSString *pinyinStr = nil;
        if (optionArr.count >= 2) {
            pinyinStr = [NSString stringWithFormat:@"[optionArr objectAtIndex:1]"];
        }
        
        
        NSArray *chineseArray = [NSArray arrayWithArray:[chineseStr componentsSeparatedByString:@" "]];
        NSArray *pinArray = [NSArray arrayWithArray:[chineseStr componentsSeparatedByString:@" "]];
        
        if (chineseArray.count != pinArray.count) {
            [self errorAndToNextTopic];
            return;
        }
        
        //序号
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textColor = kColorWord;
        
        numLabel.width = 30;
        numLabel.height = 30;
        
        numLabel.text = [NSString stringWithFormat:@"%li.",(i+1)];
        [numLabel sizeToFit];
        numLabel.right = 25;
        numLabel.top = labelTop + 22;
        [self.optionScrollView addSubview:numLabel];
        
        for (NSInteger i = 0; i < chineseArray.count; i++) {
            
            TopicLabel *label = [[TopicLabel alloc] initWithFrame:CGRectMake(0, labelTop, 100, labelHeight)];
            
            NSString *chinese = [chineseArray objectAtIndex:i];
            NSString *pinyin = [pinArray objectAtIndex:i];
            
            //由于服务器返回的是中文的（） 为方便 需处理成英文
            if ([chinese isEqualToString:@"（）"]) {
                chinese = @"()";
            }
            if ([pinyin isEqualToString:@"-"] || [pinyin isEqualToString:@"（）"]) {
                pinyin = @"()";
            }
            
            label.text = [[chinese stringByAppendingString:@"^"] stringByAppendingString:pinyin];
            label.textColor = kColorWord;
            [label sizeToFit];
            label.left = labelRight;
            
            [label isPinyinHighlight:YES andColor:kColorMain];
            
            
            //如果label过大则换行
            if (label.right > self.optionScrollView.width) {
                
                labelTop = titleLabelBottom + 10;
                label.top = labelTop;
                
                label.left = 30;

            }
            
            titleLabelBottom = label.bottom;

            labelRight = label.right;
            
            [self.optionScrollView addSubview:label];
            //NSLog(@"chinese: %@", chinese);
            
            if ([chinese isEqualToString:@"()"]) {
                label.textColor = kColorMain;
                
                UIButton *kuoHaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                kuoHaoBtn.left = label.left + 5;
                kuoHaoBtn.height = label.height - 25;
                kuoHaoBtn.bottom = label.bottom;
                kuoHaoBtn.width = label.width - 15;
                
                [kuoHaoBtn addTarget:self action:@selector(kuohaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [kuoHaoBtn setBackgroundImage:[UIImage imageWithColor:kColorMainWithA(0.3) andSize:kuoHaoBtn.size] forState:UIControlStateSelected];
                
                [kuohaoBtnArray addObject:kuoHaoBtn];
                
                if (kuoHaoFirstSelected) {
                    [self kuohaoBtnClick:kuoHaoBtn];//第一次进来选中第一个
                    kuoHaoFirstSelected = NO;
                }
                [self.optionScrollView addSubview:kuoHaoBtn];
            }
        }
    }
    
    self.optionScrollView.contentSize = CGSizeMake(self.backScrollView.width, titleLabelBottom + 50);
    
}

-(void)kuohaoBtnClick:(id)sender{
    kuohaoSelectedBtn.selected = !kuohaoSelectedBtn.selected;
    
    UIButton *kuohaoBtn = (UIButton *)sender;
    
//    DLog(@"kuohaoSelectedBtn--------%i",[kuohaoBtnArray indexOfObject:kuohaoBtn]);
    
    kuohaoBtn.selected = !kuohaoBtn.selected;
    
    kuohaoSelectedBtn = kuohaoBtn;
}


-(void)resetAllOption{
    CGRect tempRect = CGRectMake(0,0, self.optionScrollView.width, 10);
    [self.optionScrollView scrollRectToVisible:tempRect animated:YES];
    
    //重置
    for (NSInteger i = 0; i < userChooseResultArray.count ; i++) {
        
        NSString *userChooseStr = [userChooseResultArray objectAtIndex:i];
        if (![userChooseStr isEqualToString:@"-1"]) {
            isReset = YES;
            UIButton *tempShowAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicXctkShowAnswerTag + [userChooseStr integerValue])];
            
            [self showAnswerBtnClick:tempShowAnswerBtn];
        }
    }
    
    //将光标移动到第一个
    if ([kuohaoBtnArray count] > 0)
    {
        UIButton *tempKuohaoBtn = [kuohaoBtnArray objectAtIndex:0];
        [self kuohaoBtnClick:tempKuohaoBtn];
    }
    
}


-(NSInteger)checkResultAndReturnRightStarNum{
    for (NSInteger i = 0; i < trueResultArray.count; i++) {
        
        NSString *trueStr = [trueResultArray objectAtIndex:i];
        NSString *userChooseStr = [userChooseResultArray objectAtIndex:i];
        
        UIButton *tempShowAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicXctkShowAnswerTag + [userChooseStr integerValue])];
        tempShowAnswerBtn.userInteractionEnabled = NO;
        [tempShowAnswerBtn.layer addAnimation:[self coutomAnimation] forKey:@"scale-layer"];
        
        NSString *eID = [sonExamArrayEIDArray objectAtIndex:i];
        
        if ([trueStr isEqualToString:userChooseStr]) {
            //变绿
            userTrueNum ++;
            tempShowAnswerBtn.titleLabel.textColor = kColorGreen;
            
            [self savePracticeRecordWithTopicID:eID result:YES answer:userChooseStr];
            
        }else if(![trueStr isEqualToString:userChooseStr]){
            //变红
            tempShowAnswerBtn.titleLabel.textColor = [UIColor redColor];
            
            [self savePracticeRecordWithTopicID:eID result:NO answer:userChooseStr];
        }
    }
    return userTrueNum;
}


-(NSInteger)returnFullStarNum{
    return optionArray.count;
}

#pragma mark - UI
-(UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.backScrollView.width, self.backScrollView.height*2/5)];
        [self.backScrollView addSubview:_titleScrollView];
    }
    return _titleScrollView;
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

-(UIScrollView *)optionScrollView{
    if (!_optionScrollView) {
        _optionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.centerLineView.bottom, self.backScrollView.width, self.backScrollView.height*3/5)];
        [self.backScrollView addSubview:_optionScrollView];
    }
    return _optionScrollView;
}


-(UIButton *)dragBtn{
    if (!_dragBtn) {
        _dragBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"image_finalTest_dragBtn"];
        [_dragBtn setImage:image forState:UIControlStateNormal];
        _dragBtn.size = image.size;
        _dragBtn.centerX = self.centerLineView.centerX;
        _dragBtn.bottom = self.centerLineView.top;
        
        [_dragBtn addTarget:self action:@selector(dragGrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        
        _dragBtn.backgroundColor = kColorClear;
        
        [self.backScrollView addSubview:_dragBtn];
    }
    return _dragBtn;
}

-(void)dragGrag: (UIButton *) btn withEvent:event
{
    
    hasDrag = YES;
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.backScrollView];
    
    point.y = point.y < 40 ? 40 : point.y;
    
    point.y =  point.y > self.backScrollView.bottom - 80 ? self.backScrollView.bottom - 80 : point.y;
    
    btn.centerY = point.y;
    
    self.centerLineView.top = btn.bottom;
    self.optionScrollView.top = self.centerLineView.centerY;
    self.optionScrollView.height = self.backScrollView.bottom - self.centerLineView.bottom;
    
    self.titleScrollView.height = self.centerLineView.top;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
