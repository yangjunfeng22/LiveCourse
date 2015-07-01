//
//  UITestTopicXzdydjzlxt.m
//  LiveCourse
//
//  Created by Lu on 15/1/29.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicXzdydjzlxt.h"
#import "TopicLabel.h"
#import "UITestTopicOptionCustomBtn.h"
#import "CheckPointDAL.h"


@interface UITestTopicXzdydjzlxt ()

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIView *centerLineView;
@property (nonatomic, strong) UIScrollView *optionScrollView;//选项

@property (nonatomic, strong) UIButton *dragBtn;

@end



@implementation UITestTopicXzdydjzlxt
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
    
    ExamModel *parentExamModel;//父
    NSMutableArray *sonExamModelArray;//子
    
    NSMutableArray *sonExamArrayEIDArray;
    
    
    BOOL hasDrag;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)loadDataWithExamModel:(ExamModel *)examModel{
    
    parentExamModel = examModel;
    
    self.topicTypeTitleLabel.text = parentExamModel.tTypeAlias;
    //NSLog(@"测试题种类: %@", parentExamModel.tTypeAlias);
    //查询子类
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray: [CheckPointDAL queryFinalTestSonDataWithParentID:parentExamModel.eID]];
    sonExamModelArray = [NSMutableArray arrayWithArray: [HSBaseTool chaosArrayFromArry:tempArray withReturnNumber:tempArray.count]];
    
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
//    [titleArray addObject:@"你 好 ， 你 是 ？^Nǐ hǎo , nǐ shì ?"];
//    [titleArray addObject:@"我 刚 搬来 ， 叫 约翰1 。 你 呢 ？^Wǒ ɡānɡ bānlái , jiào Yuēhàn . Nǐ ne ?"];
//    [titleArray addObject:@"小 李 是 我 儿子 ， 大家 都 叫 我 老 李 。^Xiǎo Lǐ shì wǒ érzi , dàjiā dōu jiào wǒ Lǎo Lǐ ."];
    
    optionArray = [NSMutableArray arrayWithCapacity:2];
    
    sonExamArrayEIDArray = [NSMutableArray arrayWithCapacity:2];
    
    for (NSInteger j = 0; j < sonExamModelArray.count; j++) {
        //正确答案数组
        ExamModel *sonExamModel = [sonExamModelArray objectAtIndex:j];
        [trueResultArray addObject:sonExamModel.answer];
        
        [optionArray addObject:sonExamModel.subject];
        
        [sonExamArrayEIDArray addObject:sonExamModel.eID];
        
        
        //初始化用户选择的答案全部设置为-1
        [userChooseResultArray addObject:@"-1"];
    }
    
    
    
    
//    [optionArray addObject:@"小 李 是 我 儿子 ， 大家 都 叫 我 老 李 。^Xiǎo Lǐ shì wǒ érzi , dàjiā dōu jiào wǒ Lǎo Lǐ ."];
//    [optionArray addObject:@"你 好 ， 你 是 ？^Nǐ hǎo , nǐ shì ?"];
//    [optionArray addObject:@"我 刚 搬来 ， 叫 约翰1 。 你 呢 ？^Wǒ ɡānɡ bānlái , jiào Yuēhàn . Nǐ ne ?"];
    
    
    [self loadTitle];
    
    [self loadOption];
    
}


-(void)loadTitle{
    CGFloat space = 15;
    
    CGFloat titleBtnRight = 15;
    CGFloat titleBottom = 10;
    CGFloat titleTop = 10;
    
    for (NSInteger i = 0; i < titleArray.count; i ++) {
        
        UITestTopicOptionCustomBtn *titleBtn = [[UITestTopicOptionCustomBtn alloc] initWithFrame:CGRectMake(titleBtnRight, titleTop, 1300, 45)];
        
        titleBtn.tag = kTestTopicXzdydjzlxtTitleTag + i;
        titleBtn.detailLabel.textColor = kColorMain;
        
        [titleBtn setAbcLabelText:[[HSBaseTool getAbcStrWithIndex:i] stringByAppendingString:@"."] andDetailLabelText:[titleArray objectAtIndex:i]];
        titleBtn.abcLabel.top += 11;
        titleBtn.detailLabel.top = 5;
        titleBtn.detailLabel.left = titleBtn.abcLabel.right;
        titleBtn.height = titleBtn.detailLabel.height + 10;
        titleBtn.abcLabel.centerY = titleBtn.height/2;
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        titleBtn.width = titleBtn.detailLabel.right + 10;
        
        
        //换行
        if (titleBtn.right > self.titleScrollView.width - 15) {
            
            titleBtn.left = 15;
            
            titleBtn.width = self.titleScrollView.width - 30;
            
            [titleBtn setAbcLabelText:[[HSBaseTool getAbcStrWithIndex:i] stringByAppendingString:@"."] andDetailLabelText:[titleArray objectAtIndex:i]];
            titleBtn.detailLabel.top = 5;
            titleBtn.detailLabel.left = titleBtn.abcLabel.right;
            titleBtn.width = titleBtn.detailLabel.right + 10;
            titleBtn.height = titleBtn.detailLabel.height + 10;
        
            titleTop = titleBottom + space;
            
            titleBtn.top = titleTop;
            
        }
        
        titleBottom = titleBtn.bottom;
        titleBtnRight = titleBtn.right + space;
        
        [self.titleScrollView addSubview:titleBtn];
    }
    
    self.titleScrollView.contentSize = CGSizeMake(0, titleBottom + 20);
}

-(void)titleBtnClick:(id)sender{
    
    UITestTopicOptionCustomBtn *chooseBtn = (UITestTopicOptionCustomBtn *)sender;
    [chooseBtn editBtnUnEnable];
    
    
    //用于显示用户选择的btn 用于显示再（）中
    UIButton *showAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicXzdydjzlxtShowAnswerTag + chooseBtn.tag - kTestTopicXzdydjzlxtTitleTag)];
    
    if (!showAnswerBtn) {
        showAnswerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self.optionScrollView addSubview:showAnswerBtn];
        showAnswerBtn.backgroundColor = kColorClear;
        [showAnswerBtn setTitleColor:kColorMain forState:UIControlStateNormal];

        [showAnswerBtn setTitle:[HSBaseTool getAbcStrWithIndex:(chooseBtn.tag - kTestTopicXzdydjzlxtTitleTag)] forState:UIControlStateNormal];
        showAnswerBtn.tag = KTestTopicXzdydjzlxtShowAnswerTag + chooseBtn.tag - kTestTopicXzdydjzlxtTitleTag;
        [showAnswerBtn addTarget:self action:@selector(showAnswerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    showAnswerBtn.center = CGPointMake(self.titleScrollView.centerX, self.titleScrollView.bottom);
    
    showAnswerBtn.alpha = 1.0f;
    [showAnswerBtn.layer addAnimation:[self coutomAnimation] forKey:@"scale-layer"];
    
    if (kuohaoSelectedBtn) {
        
        showAnswerBtn.center = kuohaoSelectedBtn.center;
        
        NSInteger index = [kuohaoBtnArray indexOfObject:kuohaoSelectedBtn];
        
        [userChooseResultArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%li",(chooseBtn.tag - kTestTopicXzdydjzlxtTitleTag)]];
        
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
            
//            if (hasDrag) {
//                
//                CGRect tempRect = CGRectMake(nextKuohaoBtn.left, nextKuohaoBtn.top - 20, nextKuohaoBtn.width, nextKuohaoBtn.height + 90);
//                [self.optionScrollView scrollRectToVisible:tempRect animated:YES];
//            }else{
//                [self.optionScrollView scrollRectToVisible:nextKuohaoBtn.frame animated:YES];
//            }
            CGRect tempRect = CGRectMake(nextKuohaoBtn.left, nextKuohaoBtn.top - 20, nextKuohaoBtn.width, nextKuohaoBtn.height + 90);
            [self.optionScrollView scrollRectToVisible:tempRect animated:YES];
            
            
        }else{
            kuohaoSelectedBtn.selected = NO;
            kuohaoSelectedBtn = nil;
        }
    }
    
    
    if (![userChooseResultArray containsObject:@"-1"]) {
        [self editContinueBtnIsEnable:YES];
    }
}


-(void)showAnswerBtnClick:(id)sender{
    //取消选中 撤销选好的答案
    
    UIButton *showAnswerBtn = (UIButton *)sender;
    
    UITestTopicOptionCustomBtn *optionBtn = (UITestTopicOptionCustomBtn *)[self viewWithTag:showAnswerBtn.tag - KTestTopicXzdydjzlxtShowAnswerTag + kTestTopicXzdydjzlxtTitleTag];
    
    [UIView animateWithDuration:0.2f animations:^{
        //        showAnswerBtn.center = optionBtn.center;
        showAnswerBtn.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [optionBtn editBtnEnable];
        
        optionBtn.detailLabel.textColor = kColorMain;
        optionBtn.abcLabel.textColor = kColorMain;
        
        //修改userChooseResultArray
    }];
    
    NSInteger index = [userChooseResultArray indexOfObject:[NSString stringWithFormat:@"%li",(optionBtn.tag - kTestTopicXzdydjzlxtTitleTag)]];
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

-(void)resetAllOption{
    
    CGRect tempRect = CGRectMake(0,0, self.optionScrollView.width, 10);
    [self.optionScrollView scrollRectToVisible:tempRect animated:YES];
    
    //重置
    for (NSInteger i = 0; i < userChooseResultArray.count ; i++) {
        
        NSString *userChooseStr = [userChooseResultArray objectAtIndex:i];
        if (![userChooseStr isEqualToString:@"-1"]) {
            isReset = YES;
            UIButton *tempShowAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicXzdydjzlxtShowAnswerTag + [userChooseStr integerValue])];
            
            [self showAnswerBtnClick:tempShowAnswerBtn];
        }
    }
    
    //将光标移动到第一个
    UIButton *tempKuohaoBtn = [kuohaoBtnArray objectAtIndex:0];
    [self kuohaoBtnClick:tempKuohaoBtn];
    
}


-(NSInteger)checkResultAndReturnRightStarNum{
    
    for (NSInteger i = 0; i < trueResultArray.count; i++) {
        
        NSString *trueStr = [trueResultArray objectAtIndex:i];
        NSString *userChooseStr = [userChooseResultArray objectAtIndex:i];
        
        UIButton *tempShowAnswerBtn = (UIButton *)[self viewWithTag:(KTestTopicXzdydjzlxtShowAnswerTag + [userChooseStr integerValue])];
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


-(void)loadOption{
    
    CGFloat optionLabelLeft = 30;
    CGFloat optionLabelBottom = 10;
    
    for (NSInteger i = 0; i < optionArray.count; i ++) {
        
        //括号
        UILabel *kuohaoLabel = [[UILabel alloc] init];
        kuohaoLabel.text = @"(        )";
        kuohaoLabel.textColor = kColorMain;
        kuohaoLabel.textAlignment = NSTextAlignmentLeft;
        kuohaoLabel.width = 50;
        kuohaoLabel.right = self.titleScrollView.width - 5;
        kuohaoLabel.height = 30;
        [self.optionScrollView addSubview:kuohaoLabel];
        
        
        //
        TopicLabel *optionLabel = [[TopicLabel alloc] initWithFrame:CGRectMake(optionLabelLeft, optionLabelBottom, kuohaoLabel.left - optionLabelLeft , 45)];
        optionLabel.font = [UIFont systemFontOfSize:15.0f];
        optionLabel.numberOfLines = 0;
        optionLabel.text = [optionArray objectAtIndex:i];
        [optionLabel sizeToFit];
        optionLabel.width = kuohaoLabel.left - optionLabelLeft;
        optionLabel.textColor = kColorMain;
        [self.optionScrollView addSubview:optionLabel];
        
        kuohaoLabel.centerY = optionLabel.centerY;
        
        optionLabelBottom = optionLabel.bottom + 20;
        
        
        //序号
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textColor = kColorWord;
        
        numLabel.width = 30;
        numLabel.height = 30;
        
        numLabel.text = [NSString stringWithFormat:@"%li.",(i+1)];
        [numLabel sizeToFit];
        numLabel.right = optionLabel.left - 5;
//        numLabel.top = optionLabel.top + 19;
        numLabel.centerY = optionLabel.centerY;
        [self.optionScrollView addSubview:numLabel];
        
        
        UIButton *kuoHaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        kuoHaoBtn.frame = kuohaoLabel.frame;
        kuoHaoBtn.left += 6;
        kuoHaoBtn.width -= 15;
        kuoHaoBtn.height -= 12;
        kuoHaoBtn.centerY = kuohaoLabel.centerY;
        
        [kuoHaoBtn addTarget:self action:@selector(kuohaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [kuoHaoBtn setBackgroundImage:[UIImage imageWithColor:kColorMainWithA(0.3) andSize:kuoHaoBtn.size] forState:UIControlStateSelected];
        
        [kuohaoBtnArray addObject:kuoHaoBtn];
        
        if (kuoHaoFirstSelected) {
            [self kuohaoBtnClick:kuoHaoBtn];//第一次进来选中第一个
            kuoHaoFirstSelected = NO;
        }
        [self.optionScrollView addSubview:kuoHaoBtn];
    }
    
    self.optionScrollView.contentSize = CGSizeMake(self.backScrollView.width, optionLabelBottom + 20);
}




-(void)kuohaoBtnClick:(id)sender{
    kuohaoSelectedBtn.selected = !kuohaoSelectedBtn.selected;
    
    UIButton *kuohaoBtn = (UIButton *)sender;
    
//    DLog(@"kuohaoSelectedBtn--------%i",[kuohaoBtnArray indexOfObject:kuohaoBtn]);
    
    kuohaoBtn.selected = !kuohaoBtn.selected;
    
    kuohaoSelectedBtn = kuohaoBtn;
}




#pragma mark - UI
-(UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.backScrollView.width, self.backScrollView.height/2)];
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
        _optionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.centerLineView.bottom, self.backScrollView.width, self.backScrollView.height/2)];
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
