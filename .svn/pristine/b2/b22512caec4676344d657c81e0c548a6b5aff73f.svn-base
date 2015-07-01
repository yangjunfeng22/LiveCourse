//
//  UITestTopicGjkwnrxzzqdda.m
//  LiveCourse
//
//  Created by Lu on 15/1/28.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicGjkwnrxzzqdda.h"
#import "TopicLabel.h"

#import "UITestTopicOptionCustomBtn.h"
#import "CheckPointDAL.h"

@interface UITestTopicGjkwnrxzzqdda ()

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIView *centerLineView;
@property (nonatomic, strong) UIScrollView *optionScrollView;//选项

@property (nonatomic, strong) UIButton *dragBtn;


@end



@implementation UITestTopicGjkwnrxzzqdda
{
    NSString *titleStr;

    NSMutableArray *kuohaoBtnArray;//括号label数组
    
    CGFloat titleLabelBottom;
    CGFloat optionBottom;
    
    NSMutableArray *optionArray;
    
    NSMutableArray *trueResultArray;
    NSMutableArray *userChooseResultArray;
    NSInteger userTrueNum;//正确个数
    
    UIButton *kuohaoSelectedBtn;//选中的括号按钮
    
    BOOL isReset;//是否重置
    
    ExamModel *parentExamModel;
    NSMutableArray *sonExamModelArray;
    
    NSMutableArray *sonExamArrayEIDArray;
    
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
    
    sonExamModelArray = [NSMutableArray arrayWithArray:[CheckPointDAL queryFinalTestSonDataWithParentID:parentExamModel.eID]];
    
    self.topicTypeTitleLabel.text = parentExamModel.tTypeAlias;
    
    self.titleScrollView.backgroundColor = kColorClear;
    self.centerLineView.top = self.titleScrollView.bottom;
    self.optionScrollView.backgroundColor = kColorClear;
    
    self.dragBtn.backgroundColor = kColorClear;
    [self bringSubviewToFront:self.dragBtn];
    
    kuohaoBtnArray = [NSMutableArray arrayWithCapacity:2];
    optionArray = [NSMutableArray arrayWithCapacity:2];
    isReset = NO;
    
    userTrueNum = 0;
    
//    [optionArray addObject:@"是^shi"];
//    [optionArray addObject:@"儿子^érzi"];
//    [optionArray addObject:@"都^dou"];
//    [optionArray addObject:@"叫^jiào"];
//    [optionArray addObject:@"李^li"];
    
    userChooseResultArray = [NSMutableArray arrayWithCapacity:2];
    trueResultArray = [NSMutableArray arrayWithCapacity:2];
    
    NSString *items = parentExamModel.items;
    
    NSArray *itemsArray = [NSArray arrayWithArray:[items componentsSeparatedByString:@"|"]];
    
    if (sonExamModelArray.count != itemsArray.count) {
        
        [self errorAndToNextTopic];
        
        return;
    }
    
    
    sonExamArrayEIDArray = [NSMutableArray arrayWithCapacity:2];
    
    for (NSInteger j = 0; j < sonExamModelArray.count; j++) {
        //正确答案数组
        ExamModel *conExamModel = [sonExamModelArray objectAtIndex:j];

        [trueResultArray addObject:conExamModel.answer];
        
        [sonExamArrayEIDArray addObject:conExamModel.eID];
        
        [optionArray addObject:[itemsArray objectAtIndex:j]];
        
        //初始化用户选择的答案全部设置为-1
        [userChooseResultArray addObject:@"-1"];
    }
    
    
    [self loadTitle];
    
    [self loadOption];
}


-(void)loadTitle{
//    titleStr = @"小 李 是 我 () ， 大家 () 叫 我 老 李 。小 李 是 我 儿子 ， 大家 都 叫 我 老 () 。小 李 () 我 儿子 ， 大家 都 叫 我 老 李 。小 李 是 我 儿子 ， 大家 都 () 我 老 李 。^Xiǎo Lǐ shì wǒ () , dàjiā () jiào wǒ Lǎo Lǐ .Xiǎo Lǐ shì wǒ érzi , dàjiā dōu jiào wǒ Lǎo () .Xiǎo Lǐ () wǒ érzi , dàjiā dōu jiào wǒ Lǎo Lǐ .Xiǎo Lǐ shì wǒ érzi , dàjiā dōu () wǒ Lǎo Lǐ .";
    titleStr = parentExamModel.subject;
    
    NSString *chineseStr = [[titleStr componentsSeparatedByString:@"^"] objectAtIndex:0];
    NSString *pinyinStr = [[titleStr componentsSeparatedByString:@"^"] objectAtIndex:1];
    
    NSArray *chineseArray = [NSArray arrayWithArray:[chineseStr componentsSeparatedByString:@" "]];
    NSArray *pinArray = [NSArray arrayWithArray:[pinyinStr componentsSeparatedByString:@" "]];
    
    
    CGFloat labelRight = 10;
    CGFloat labelTop = 10;
    CGFloat labelHeight = 44.5;
    titleLabelBottom = 0;
    
    BOOL kuoHaoFirstSelected = YES;
    
    for (NSInteger i = 0; i < chineseArray.count; i++) {
        
        TopicLabel *label = [[TopicLabel alloc] initWithFrame:CGRectMake(0, labelTop, 1000, labelHeight)];
        [label isPinyinHighlight:YES andColor:kColorMain];
        
        NSString *chineseStr = [chineseArray objectAtIndex:i];

        if ([chineseStr hasPrefix:@"["]) {
            chineseStr = @"()";
        }
        
        NSString *pinStr = [pinArray objectAtIndex:i];
        
        label.text = [[chineseStr stringByAppendingString:@"^"] stringByAppendingString:pinStr];
        label.textColor = kColorWord;
        [label sizeToFit];
        
        label.left = labelRight;
        
        
        //如果label过大则换行
        if (label.right > self.titleScrollView.width) {
            labelTop = titleLabelBottom + 10;
            label.top = labelTop;
            
            label.left = 10;
        }
        
        [self.titleScrollView addSubview:label];
        
        titleLabelBottom = label.bottom;
        labelRight = label.right;
        
        
        if ([chineseStr isEqualToString:@"()"]) {
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
            [self.titleScrollView addSubview:kuoHaoBtn];
        }
    }
    
    self.titleScrollView.contentSize = CGSizeMake(self.backScrollView.width, titleLabelBottom + 20);
}

-(void)kuohaoBtnClick:(id)sender{
    kuohaoSelectedBtn.selected = !kuohaoSelectedBtn.selected;
    
    UIButton *kuohaoBtn = (UIButton *)sender;
    
    DLog(@"kuohaoSelectedBtn--------%i",[kuohaoBtnArray indexOfObject:kuohaoBtn]);
    
    kuohaoBtn.selected = !kuohaoBtn.selected;
    
    kuohaoSelectedBtn = kuohaoBtn;
}


-(void)loadOption{
    
    
//    optionBottom = titleLabelBottom + 40;
    optionBottom = 10;
    CGFloat optionSpace = 20;
    CGFloat optionRight = 20;
//    CGFloat optionTop = titleLabelBottom + 40;
    CGFloat optionTop = 10;
    CGFloat horizontalSpace = 20;
    
    for (NSInteger i = 0; i < optionArray.count; i++) {
     
        UITestTopicOptionCustomBtn *optionBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(0, optionTop, 300, 45)];
    
        [optionBtn setAbcLabelText:[HSBaseTool getAbcStrWithIndex:i] andDetailLabelText:[optionArray objectAtIndex:i]];
        [optionBtn.detailLabel sizeToFit];
        optionBtn.detailLabel.left = optionBtn.abcLabel.right;
        optionBtn.detailLabel.textColor = kColorMain;
        
        optionBtn.left = optionRight;
        optionBtn.width = optionBtn.detailLabel.right + 10;
        
        //如果label过大则换行
        if (optionBtn.right + 20 > self.optionScrollView.width) {
            
            optionTop = optionBottom + optionSpace;
            optionBtn.top = optionTop;
            
            optionBtn.left = 20;
        }
        optionBtn.tag = KTestTopicGjkwnrxzzqddaOptionTag + i;
        [optionBtn addTarget:self action:@selector(chooseOption:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.optionScrollView addSubview:optionBtn];
        optionBottom = optionBtn.bottom;
        optionRight = optionBtn.right + horizontalSpace;

    }
    
    self.optionScrollView.contentSize = CGSizeMake(self.backScrollView.width, optionBottom + 40);
}



-(void)chooseOption:(id)sender{
    
    UITestTopicOptionCustomBtn *chooseBtn = (UITestTopicOptionCustomBtn *)sender;
    [chooseBtn editBtnUnEnable];
    
    //用于显示用户选择的btn 用于显示再（）中
    UIButton *showAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicGjkwnrxzzqddaShowAnswerTag + chooseBtn.tag - KTestTopicGjkwnrxzzqddaOptionTag)];
    
    if (!showAnswerBtn) {
        showAnswerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        showAnswerBtn.center = CGPointMake(self.titleScrollView.centerX, self.titleScrollView.bottom);
        [self.titleScrollView addSubview:showAnswerBtn];
        showAnswerBtn.backgroundColor = kColorClear;
        [showAnswerBtn setTitleColor:kColorMain forState:UIControlStateNormal];
        [showAnswerBtn setTitle:chooseBtn.abcLabel.text forState:UIControlStateNormal];
        showAnswerBtn.tag = KTestTopicGjkwnrxzzqddaShowAnswerTag + chooseBtn.tag - KTestTopicGjkwnrxzzqddaOptionTag;
        [showAnswerBtn addTarget:self action:@selector(showAnswerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    showAnswerBtn.center = CGPointMake(self.titleScrollView.centerX, self.titleScrollView.bottom);
    
    showAnswerBtn.alpha = 1.0f;
    [showAnswerBtn.layer addAnimation:[self coutomAnimation] forKey:@"scale-layer"];
    
    
//    [UIView animateWithDuration:0.5f animations:^{
//        
//        if (kuohaoSelectedBtn) {
//            
//             showAnswerBtn.center = kuohaoSelectedBtn.center;
//            
//             NSInteger index = [kuohaoBtnArray indexOfObject:kuohaoSelectedBtn];
//            
//            [userChooseResultArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%li",(chooseBtn.tag - KTestTopicGjkwnrxzzqddaOptionTag)]];
//            
//            DLog(@"选择后的userChooseResultArray----------%@",userChooseResultArray);
//            
//            //光标移动到下一个
//            if ([userChooseResultArray containsObject:@"-1"]) {
//                NSInteger nextIndex;
//                if (index == userChooseResultArray.count - 1) {
//                    nextIndex  = [userChooseResultArray indexOfObject:@"-1" inRange:NSMakeRange(0, userChooseResultArray.count )];
//                }else{
//                    nextIndex = [userChooseResultArray indexOfObject:@"-1" inRange:NSMakeRange(index, userChooseResultArray.count - index)];
//                }
//                
//                UIButton *nextKuohaoBtn = [kuohaoBtnArray objectAtIndex:nextIndex];
//                [self kuohaoBtnClick:nextKuohaoBtn];
//            }else{
//                kuohaoSelectedBtn.selected = NO;
//                kuohaoSelectedBtn = nil;
//            }
//        }
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
    if (kuohaoSelectedBtn) {
        
        showAnswerBtn.center = kuohaoSelectedBtn.center;
        
        NSInteger index = [kuohaoBtnArray indexOfObject:kuohaoSelectedBtn];
        
        [userChooseResultArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%li",(chooseBtn.tag - KTestTopicGjkwnrxzzqddaOptionTag)]];
        
        DLog(@"选择后的userChooseResultArray----------%@",userChooseResultArray);
        
        //光标移动到下一个
        if ([userChooseResultArray containsObject:@"-1"]) {
            NSInteger nextIndex;
            if (index == userChooseResultArray.count - 1) {
                nextIndex  = [userChooseResultArray indexOfObject:@"-1" inRange:NSMakeRange(0, userChooseResultArray.count )];
            }else{
                nextIndex = [userChooseResultArray indexOfObject:@"-1" inRange:NSMakeRange(index, userChooseResultArray.count - index)];
            }
            
            UIButton *nextKuohaoBtn = [kuohaoBtnArray objectAtIndex:nextIndex];
            [self kuohaoBtnClick:nextKuohaoBtn];
            
            [self.titleScrollView scrollRectToVisible:nextKuohaoBtn.frame animated:YES];
            
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
    
    UITestTopicOptionCustomBtn *optionBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:showAnswerBtn.tag - KTestTopicGjkwnrxzzqddaShowAnswerTag + KTestTopicGjkwnrxzzqddaOptionTag];
    
    [UIView animateWithDuration:0.2f animations:^{
//        showAnswerBtn.center = optionBtn.center;
        showAnswerBtn.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [optionBtn editBtnEnable];
        
        optionBtn.detailLabel.textColor = kColorMain;
        optionBtn.abcLabel.textColor = kColorMain;
        
        //修改userChooseResultArray
        
        
    }];
    
    NSInteger index = [userChooseResultArray indexOfObject:[NSString stringWithFormat:@"%li",(optionBtn.tag - KTestTopicGjkwnrxzzqddaOptionTag)]];
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


-(NSInteger)checkResultAndReturnRightStarNum{
    
    for (NSInteger i = 0; i < trueResultArray.count; i++) {
    
        NSString *trueStr = [trueResultArray objectAtIndex:i];
        NSString *userChooseStr = [userChooseResultArray objectAtIndex:i];
        
        UIButton *tempShowAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicGjkwnrxzzqddaShowAnswerTag + [userChooseStr integerValue])];
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


-(void)resetAllOption{
    
    CGRect tempRect = CGRectMake(0,0, self.titleScrollView.width, 10);
    [self.titleScrollView scrollRectToVisible:tempRect animated:YES];
    
    //重置
    for (NSInteger i = 0; i < userChooseResultArray.count ; i++) {
        
        NSString *userChooseStr = [userChooseResultArray objectAtIndex:i];
        if (![userChooseStr isEqualToString:@"-1"]) {
            isReset = YES;
             UIButton *tempShowAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicGjkwnrxzzqddaShowAnswerTag + [userChooseStr integerValue])];
            
            [self showAnswerBtnClick:tempShowAnswerBtn];
        }
    }
    
    //将光标移动到第一个
    UIButton *tempKuohaoBtn = [kuohaoBtnArray objectAtIndex:0];
    [self kuohaoBtnClick:tempKuohaoBtn];
}


#pragma mark - UI
-(UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.backScrollView.width, self.backScrollView.height*3/5)];
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
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.backScrollView];
    
    point.y = point.y < 40 ? 40 : point.y;
    
    point.y =  point.y > self.backScrollView.bottom - 80 ? self.backScrollView.bottom - 80 : point.y;
    
    btn.centerY = point.y;
    
    self.centerLineView.top = btn.bottom;
    self.optionScrollView.top = self.centerLineView.centerY;
    self.optionScrollView.height = self.backScrollView.bottom - self.centerLineView.bottom;
    
    self.titleScrollView.height = self.centerLineView.top;
    
}



-(UIScrollView *)optionScrollView{
    if (!_optionScrollView) {
        _optionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.centerLineView.bottom, self.backScrollView.width, self.backScrollView.height*2/5)];
        [self.backScrollView addSubview:_optionScrollView];
    }
    return _optionScrollView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
