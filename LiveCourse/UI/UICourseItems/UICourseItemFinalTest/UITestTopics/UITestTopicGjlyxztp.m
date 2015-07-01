//
//  UITestTopicGjlyxztp.m
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicGjlyxztp.h"
#import "UITestTopicOptionMany.h"
#import "CheckPointDAL.h"
#import "UIImageView+Extra.h"


#define oneLineNum 2    //一行展示几个
#define verticalSpace 30 //垂直向间隔
#define horizontalSpace 20 //横向间隔
#define borderSapce 20 //距离边界的距离
#define btnHeight 90.0f //按钮的高度


@interface UITestTopicGjlyxztp ()<UITestTopicOptionManyDelegate>

@property (nonatomic, strong) UIScrollView *imageScrollView;//图片
@property (nonatomic, strong) UIView *centerLineView;
@property (nonatomic, strong) UIScrollView *optionScrollView;//选项

@property (nonatomic, strong) UIButton *dragBtn;

@end


@implementation UITestTopicGjlyxztp
{
    NSInteger optionNum;//选项个数
    
    NSMutableArray *trueResultArray;//正确答案的数组
    NSMutableArray *userChooseResultArray;//用户选择后的答案数组
    
    NSInteger userTrueNum;//用户正确的个数
    
    ExamModel *parentExamModel;
    NSMutableArray *sonExamModelArray;
    
    NSMutableArray *imageArray;
    
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
    //查询子题
    sonExamModelArray = [NSMutableArray arrayWithArray:[CheckPointDAL queryFinalTestSonDataWithParentID:parentExamModel.eID]];
    
    self.topicTypeTitleLabel.text = parentExamModel.tTypeAlias;
    
    self.imageScrollView.backgroundColor = kColorClear;
    self.centerLineView.top = self.imageScrollView.bottom;
    
    self.optionScrollView.backgroundColor = kColorClear;
    self.dragBtn.backgroundColor = kColorClear;
    [self bringSubviewToFront:self.dragBtn];
    
    optionNum = sonExamModelArray.count;
    
    userChooseResultArray = [NSMutableArray arrayWithCapacity:2];
    userTrueNum = 0;
    
    trueResultArray = [NSMutableArray arrayWithCapacity:2];
    
    sonExamArrayEIDArray = [NSMutableArray arrayWithCapacity:2];
    
    for (NSInteger j = 0; j < optionNum; j++) {
        
        ExamModel *sonExamModel = [sonExamModelArray objectAtIndex:j];
        
        [trueResultArray addObject:sonExamModel.answer];
        
        [sonExamArrayEIDArray addObject:sonExamModel.eID];
        
        
        //初始化用户选择的答案全部设置为-1
        [userChooseResultArray addObject:@"-1"];
    }
    
    imageArray = [NSMutableArray arrayWithArray:[parentExamModel.items componentsSeparatedByString:@"|"]];
    
    
    
    [self setImageView];
    [self setOption];
}

-(void)setImageView{
    //布局选项按钮
    CGFloat beginTop = 5;
    
    CGFloat newBtnHeight = kiPhone ? btnHeight : btnHeight + 30;
    
    CGFloat btnWidth = (self.backScrollView.width - borderSapce*2 - horizontalSpace*(oneLineNum-1))/oneLineNum;
    
    CGFloat scrollHeight = 0;
    
    for (NSInteger i = 0; i < optionNum; i++) {
        
        NSInteger lineNum = i/oneLineNum;
        NSInteger columnNum = i%oneLineNum;
        
        CGFloat tempTop = beginTop + newBtnHeight * lineNum + verticalSpace*lineNum;
        CGFloat tempLeft = borderSapce + btnWidth * columnNum + horizontalSpace*columnNum;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tempLeft, tempTop, btnWidth, newBtnHeight)];
        imageView.layer.cornerRadius = 8.0f;
        imageView.layer.masksToBounds = YES;
        imageView.tag = KTestTopicGjlyxzzqdaTag + i;
        
        NSString *imageStr = [imageArray objectAtIndex:i];
        NSString *path = [HSBaseTool picturePathWithCheckPoinID:HSAppDelegate.curCpID picture:imageStr];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [imageView showClipImageWithImage:image];
        imageView.autoresizingMask = UIViewAutoresizingNone;
        [self.imageScrollView addSubview:imageView];
        
        UILabel *abcLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left,imageView.bottom , imageView.width, 20)];
        abcLabel.textAlignment = NSTextAlignmentCenter;
        abcLabel.text = [HSBaseTool getAbcStrWithIndex:i];
        abcLabel.textColor = kColorWord;
        abcLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.imageScrollView addSubview:abcLabel];
        
        scrollHeight = abcLabel.bottom + 20;
        
    }
    self.imageScrollView.contentSize = CGSizeMake(0, scrollHeight);
}


-(void)setOption
{
    CGFloat height = 80;
    CGFloat space = 10;
    CGFloat firstTop = 5;
    
    CGFloat optionScrollViewHeight = 0;
    
    for (NSInteger i = 0; i < optionNum; i++)
    {
        
        CGFloat top = i*(height + space) + firstTop;
        
        UITestTopicOptionMany *optionMany = [[UITestTopicOptionMany alloc] initWithFrame:CGRectMake(0, top, self.optionScrollView.width, height)];
        optionMany.backgroundColor = kColorClear;
        
        NSString *audioStr = parentExamModel.audio;
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:audioStr];
        [optionMany setTitle:[NSString stringWithFormat:@"%li.",i+1] andAudioPath:path andOptionNum:optionNum];
        optionMany.backgroundColor = kColorClear;
        optionMany.delegate = self;
        optionMany.tag = KTestTopicGjlyxztpTag + i;
        [self.optionScrollView addSubview:optionMany];
        
        optionScrollViewHeight = optionMany.bottom + 20;
    }
    self.optionScrollView.contentSize = CGSizeMake(self.width, optionScrollViewHeight + 30);
}



-(void)userChoseResult:(UITestTopicOptionMany *)topic withIndex:(NSInteger)index andResult:(NSInteger)result{
    [userChooseResultArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%li",result]];
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
        
        UITestTopicOptionMany *tempOptionMany = (UITestTopicOptionMany *)[self viewWithTag:(KTestTopicGjlyxztpTag + k)];
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
        
        UITestTopicOptionMany *tempOptionMany = (UITestTopicOptionMany *)[self viewWithTag:(KTestTopicGjlyxztpTag + j)];
        //清空用户选择的答案
        [tempOptionMany resetChooseItem];
    }
}

#pragma mark - UI
-(UIScrollView *)imageScrollView{
    if (!_imageScrollView) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.backScrollView.width, self.backScrollView.height*3/5)];
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

-(UIScrollView *)optionScrollView{
    if (!_optionScrollView) {
        _optionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.centerLineView.bottom, self.backScrollView.width, self.backScrollView.height*2/5)];
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
    
    self.imageScrollView.height = self.centerLineView.top;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
