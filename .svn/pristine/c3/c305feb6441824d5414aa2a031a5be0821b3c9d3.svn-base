//
//  UITestTopicGjlyxztp.m
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicGjlyxzzqdaMany.h"
#import "UITestTopicOptionMany.h"
#import "TopicLabel.h"
#import "CheckPointDAL.h"



//#define oneLineNum 3    //一行展示几个
#define verticalSpace 20 //垂直向间隔
#define horizontalSpace 20 //横向间隔
#define borderSapce 20 //距离边界的距离
#define btnHeight 40.0f //按钮的高度


@interface UITestTopicGjlyxzzqdaMany ()<UITestTopicOptionManyDelegate>

@property (nonatomic, strong) UIScrollView *imageScrollView;//图片
@property (nonatomic, strong) UIView *centerLineView;
@property (nonatomic, strong) UIScrollView *optionScrollView;//选项

@property (nonatomic, strong) UIButton *dragBtn;
@property (nonatomic, strong) NSMutableArray *sonExamArray;

@end


@implementation UITestTopicGjlyxzzqdaMany
{
    NSInteger optionNum;//选项个数
    
    NSMutableArray *trueResultArray;//正确答案的数组
    NSMutableArray *userChooseResultArray;//用户选择后的答案数组
    
    NSInteger userTrueNum;//用户正确的个数
    
    ExamModel *parentExamModel;//
    
    NSMutableArray *titleArray;
    
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
    
    self.topicTypeTitleLabel.text = parentExamModel.tTypeAlias;
    
    //解析题目
    NSString *itemsStr = parentExamModel.items;
    titleArray = [NSMutableArray arrayWithArray:[itemsStr componentsSeparatedByString:@"|"]];
    
    //搜索出子题
    NSArray *tempArray = [CheckPointDAL queryFinalTestSonDataWithParentID:examModel.eID];
    
    NSArray *array = [HSBaseTool chaosArrayFromArry:tempArray withReturnNumber:[tempArray count]];
    [self.sonExamArray setArray:array];
    //sonExamArray = [NSMutableArray arrayWithArray: [HSBaseTool chaosArrayFromArry:tempArray withReturnNumber:tempArray.count]];
    
    self.imageScrollView.backgroundColor = kColorClear;
    self.centerLineView.top = self.imageScrollView.bottom;
    self.optionScrollView.backgroundColor = kColorWhite;
    
    self.dragBtn.backgroundColor = kColorClear;
    [self bringSubviewToFront:self.dragBtn];
    
    optionNum = [self.sonExamArray count];
    
    if(optionNum != titleArray.count){
        [self errorAndToNextTopic];
        
        return;
    }
    
    userChooseResultArray = [NSMutableArray arrayWithCapacity:2];
    userTrueNum = 0;
    
    trueResultArray = [NSMutableArray arrayWithCapacity:2];
    sonExamArrayEIDArray = [NSMutableArray arrayWithCapacity:2];
    
    for (NSInteger j = 0; j < optionNum; j++) {
        
        ExamModel *examModel = [self.sonExamArray objectAtIndex:j];
        NSString *answer = [[NSString alloc] initWithFormat:@"%@", [examModel.answer mutableCopy]];
        [trueResultArray addObject:answer];
        
        [sonExamArrayEIDArray addObject:examModel.eID];
        
        //初始化用户选择的答案全部设置为-1
        [userChooseResultArray addObject:@"-1"];
    }
    DLog(@"正确答案------------%@",trueResultArray);
    
    [self setTitleView];
    [self setOption];
}


-(void)setTitleView{
    //布局
    CGFloat newBtnHeight = kiPhone ? btnHeight : btnHeight + 30;
    
    CGFloat scrollHeight = 0;
    
    CGFloat labelRight = 35;
    CGFloat labelTop = 10;
    CGFloat labelBottom = 10;
    
    for (NSInteger i = 0; i < optionNum; i++) {
        
        TopicLabel *label = [[TopicLabel alloc] initWithFrame:CGRectMake(0, labelTop, 300, newBtnHeight)];
        label.numberOfLines = 1;
        label.textColor = kColorMain;
        label.text = [titleArray objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:16.0f];
        
        label.left = labelRight;
        [label sizeToFit];
        
        //换行
        if (label.right > self.imageScrollView.width - 15) {
            labelTop = labelBottom + verticalSpace;
            
            label.top = labelTop;
            label.left = 35;
        }
        
        labelBottom = label.bottom;
        labelRight = label.right + horizontalSpace + 15;
        
        [self.imageScrollView addSubview:label];
        
        UILabel *abcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 20, 20)];
        abcLabel.right = label.left - 5;
        abcLabel.bottom = label.bottom - 2;
        abcLabel.textAlignment = NSTextAlignmentRight;
        abcLabel.text = [[HSBaseTool getAbcStrWithIndex:i] stringByAppendingString:@"."];
        abcLabel.textColor = kColorWord;
        abcLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.imageScrollView addSubview:abcLabel];
        
        scrollHeight = labelBottom;
    }
    self.imageScrollView.contentSize = CGSizeMake(self.width, scrollHeight + 20);
}


-(void)setOption
{
    CGFloat height = 80;
    CGFloat space = 10;
    CGFloat top = 0;
    CGFloat optionScrollViewHeight = 0;
    
    for (NSInteger i = 0; i < optionNum; i++)
    {   
        UITestTopicOptionMany *optionMany = [[UITestTopicOptionMany alloc] initWithFrame:CGRectMake(0, top, self.optionScrollView.width, 0)];
        
        optionMany.backgroundColor = kColorClear;
        
        ExamModel *sonModel = [self.sonExamArray objectAtIndex:i];
        NSString *audioStr = [[NSString alloc] initWithFormat:@"%@", [sonModel.audio mutableCopy]];
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:audioStr];
        
        [optionMany setTitle:[NSString stringWithFormat:@"%@.", @(i+1)] andAudioPath:path andOptionNum:optionNum];
        optionMany.delegate = self;
        optionMany.tag = KTestTopicGjlyxzzqdaMany + i;
        
        height = optionMany.optionHeight;
        
        [self.optionScrollView addSubview:optionMany];
        optionScrollViewHeight = optionMany.bottom;
        top = optionMany.bottom + space;
        
        if (i <= 0) [optionMany performSelector:@selector(playMedia) withObject:nil afterDelay:0.3];
        
    }
    self.optionScrollView.contentSize = CGSizeMake(self.width, optionScrollViewHeight + 40);
}

//optionMany.delegate
- (void)userChoseResult:(UITestTopicOptionMany *)topic withIndex:(NSInteger)index andResult:(NSInteger)result
{
    [userChooseResultArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%li",(long)result]];
    DLog(@"userChooseResultArray------%@",userChooseResultArray);
    
    //判断有无全部选择 全部选择 则打开检查按钮
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
    
    
    
    
    // 做完上一题之后自动滚动到下一题可见。
    UITestTopicOptionMany *optionMany = (UITestTopicOptionMany *)[self viewWithTag:topic.tag+1];
    
    if (hasDrag) {
        
        CGRect tempRect = CGRectMake(optionMany.left, optionMany.bottom, optionMany.width, optionMany.height);
        [self.optionScrollView scrollRectToVisible:tempRect animated:YES];
        
    }else{
        [self.optionScrollView scrollRectToVisible:optionMany.frame animated:YES];
    }
    
    [optionMany performSelector:@selector(playMedia) withObject:nil afterDelay:0.3];
}

//检查答案
-(NSInteger)checkResultAndReturnRightStarNum{
    for (NSInteger k = 0; k < optionNum; k++) {
        NSString *trueEveryResult = [trueResultArray objectAtIndex:k];
        NSString *userChooseResult = [userChooseResultArray objectAtIndex:k];
        
        UITestTopicOptionMany *tempOptionMany = (UITestTopicOptionMany *)[self viewWithTag:(KTestTopicGjlyxzzqdaMany + k)];
        //让所有选项停止交互
        [tempOptionMany setEveryItemUnenable];

        NSString *eID = [sonExamArrayEIDArray objectAtIndex:k];
        

        if ([trueEveryResult isEqualToString:userChooseResult]) {
            //答对
            userTrueNum ++;
            
            [tempOptionMany setIfUserChooseRight];
            //告诉他答对了 变蓝色
            
            [self savePracticeRecordWithTopicID:eID result:YES answer:userChooseResult];
            
        }else{
            [tempOptionMany setIfUserChooseWrongWithTrueItem:[trueEveryResult integerValue]];
            
            [self savePracticeRecordWithTopicID:eID result:NO answer:userChooseResult];

            
        }
    }
    return userTrueNum;
}

-(NSInteger)returnFullStarNum{
    return optionNum;
}

//重置
-(void)resetAllOption{
    CGRect tempRect = CGRectMake(0,0, self.optionScrollView.width, 10);
    [self.optionScrollView scrollRectToVisible:tempRect animated:YES];
    
    for (NSInteger j = 0; j < optionNum; j++) {
        //用户选择的答案全部设置为-1
        [userChooseResultArray replaceObjectAtIndex:j withObject:@"-1"];
        
        UITestTopicOptionMany *tempOptionMany = (UITestTopicOptionMany *)[self viewWithTag:(KTestTopicGjlyxzzqdaMany + j)];
        //清空用户选择的答案
        [tempOptionMany resetChooseItem];
    }
}

#pragma mark - UI
-(UIScrollView *)imageScrollView{
    if (!_imageScrollView) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.backScrollView.width, self.backScrollView.height*2/5)];
        [self.backScrollView addSubview:_imageScrollView];
    }
    return _imageScrollView;
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

-(void)dragGrag:(UIButton *)btn withEvent:event
{

    hasDrag = YES;
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.backScrollView];
    
    point.y = point.y < 40 ? 40 : point.y;
    
    point.y =  point.y > self.backScrollView.bottom - 80 ? self.backScrollView.bottom - 80 : point.y;
    
    btn.centerY = point.y;
    
    self.centerLineView.top = btn.bottom;
    self.optionScrollView.top = self.centerLineView.bottom;
    self.optionScrollView.height = self.backScrollView.bottom - self.centerLineView.bottom;
    
    self.imageScrollView.height = self.centerLineView.top;
    
}

-(UIScrollView *)optionScrollView{
    if (!_optionScrollView) {
        _optionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.centerLineView.bottom, self.backScrollView.width, self.backScrollView.height*3/5)];
        [self.backScrollView addSubview:_optionScrollView];
    }
    return _optionScrollView;
}

- (NSMutableArray *)sonExamArray
{
    if (!_sonExamArray) {
        _sonExamArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _sonExamArray;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
