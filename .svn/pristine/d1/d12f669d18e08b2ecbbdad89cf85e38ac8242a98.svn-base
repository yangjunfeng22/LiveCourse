//
//  UITestTopicGjlyxzzqda.m
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicGjlyxzzqda.h"
#import "HSAudioPlayerButton.h"

#import "UITestTopicOptionImageBtn.h"
#import "MBProgressHUD.h"

#define oneLineNum 2    //一行展示几个
#define verticalSpace 20 //垂直向间隔
#define horizontalSpace 15 //横向间隔
#define borderSapce 15 //距离边界的距离
#define btnHeight 100.0f //按钮的高度


@interface UITestTopicGjlyxzzqda ()

@property (nonatomic, strong) HSAudioPlayerButton *audioPlayerButton;

@end

@implementation UITestTopicGjlyxzzqda
{
    NSInteger optionNum;//选项个数
    
    NSInteger rightResult;//正确答案
    NSInteger userChooseResult;//用户选择的答案
    UITestTopicOptionImageBtn *tempBtn;
    CGFloat scrollHeight;
    
    ExamModel *examParentModel;
    
    NSMutableArray *oldItems;
    NSMutableArray *answerItemsArray;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)loadDataWithExamModel:(ExamModel *)examModel{
    
    examParentModel = examModel;
    
    [self randomItemsAndAnswer];

    self.topicTypeTitleLabel.text = examParentModel.tTypeAlias;
    
    self.audioPlayerButton.backgroundColor = kColorClear;
    
    scrollHeight = self.audioPlayerButton.bottom;
    
    [self setBtn];
    
    [self playAudioAction:self.audioPlayerButton];
}



//随机选项和答案
-(void)randomItemsAndAnswer{
    NSInteger oldAnswer = [examParentModel.answer integerValue];//旧答案
    oldItems = [NSMutableArray arrayWithArray:[examParentModel.items componentsSeparatedByString:@"|"]];
    
    //根据旧答案获取到正确选项数据
    NSString *trueItemStr = [oldItems objectAtIndex:oldAnswer];
    
    //打乱数据
    answerItemsArray = [NSMutableArray arrayWithArray: [HSBaseTool chaosArrayFromArry:oldItems withReturnNumber:oldItems.count]];
    
    rightResult = [answerItemsArray indexOfObject:trueItemStr];
}



-(void)setBtn{
    //布局选项按钮
    CGFloat beginTop = self.audioPlayerButton.bottom + 30;
    
    CGFloat newBtnHeight = kiPhone ? btnHeight : btnHeight + 30;
    
    CGFloat btnWidth = (self.backScrollView.width - borderSapce*2 - horizontalSpace*(oneLineNum-1))/oneLineNum;

    optionNum = [answerItemsArray count];
    
    for (NSInteger i = 0; i < optionNum; i++)
    {
        
        NSInteger lineNum = i/oneLineNum;
        NSInteger columnNum = i%oneLineNum;
        
        CGFloat tempTop = beginTop + newBtnHeight * lineNum + verticalSpace*lineNum;
        CGFloat tempLeft = borderSapce + btnWidth * columnNum + horizontalSpace*columnNum;
        
        UITestTopicOptionImageBtn *imageBtn = [[UITestTopicOptionImageBtn alloc] initWithFrame:CGRectMake(tempLeft, tempTop, btnWidth, newBtnHeight)];
        NSString *imgName = [answerItemsArray objectAtIndex:i];
        NSString *path = [HSBaseTool picturePathWithCheckPoinID:HSAppDelegate.curCpID picture:imgName];

        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [imageBtn setImage:image andTitleText:@"Hello"];
        [imageBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.tag = KTestTopicGjlyxzzqdaTag + i;
        
        [self.backScrollView addSubview:imageBtn];
        
        scrollHeight = imageBtn.bottom + 20;
    }
    self.backScrollView.contentSize = CGSizeMake(0, scrollHeight);
}


- (void) buttonTouch:(id)sender {
    
    [self editContinueBtnIsEnable:YES];
    
    tempBtn.selected = !tempBtn.selected;
    
    UITestTopicOptionImageBtn *button = (UITestTopicOptionImageBtn *)sender;
    button.selected = !button.selected;
    
    tempBtn = button;
    
    userChooseResult = button.tag - KTestTopicGjlyxzzqdaTag;
}


-(NSInteger)checkResultAndReturnRightStarNum{
    for (NSInteger i = 0; i < optionNum; i++) {
        UITestTopicOptionImageBtn *optionCustomBtn  = (UITestTopicOptionImageBtn*)[self viewWithTag:(KTestTopicGjlyxzzqdaTag + i)];
        optionCustomBtn.userInteractionEnabled = NO;
    }
    
    NSString *oldIndex = [self oldIndex];

    if (rightResult == userChooseResult) {
        //答对
        
        [self editResultBtnIfRight];
        [self savePracticeRecordWithTopicID:examParentModel.eID result:YES answer:oldIndex];
        return 1;
    }else if(rightResult != userChooseResult)
    {
        //答错
        
        [self editResultBtnIfWrong];
        
        [self savePracticeRecordWithTopicID:examParentModel.eID result:NO answer:oldIndex];
        
        return 0;
    }
    return 0;
}

//计算选择的一项在原来的数组索引
-(NSString *)oldIndex{
    
    NSString *oldItem = [answerItemsArray objectAtIndex:userChooseResult];
    
    NSInteger oldSelectIndex = [oldItems indexOfObject:oldItem];
    
    return [NSString stringWithFormat:@"%i",oldSelectIndex];
}


-(void)editResultBtnIfRight{
    
    [tempBtn setIfUserChooseRight];
}

-(void)editResultBtnIfWrong{
    
    [tempBtn setIfUserChooseWrong];
    
    UITestTopicOptionImageBtn *tempRightBtn = (UITestTopicOptionImageBtn *)[self viewWithTag:KTestTopicGjlyxzzqdaTag + rightResult];
    [tempRightBtn setIfIsRightButUserNotChoose];
}




- (void)playAudioAction:(id)sender
{
    if (self.audioPlayerButton.isPlaying)
    {
        [self.audioPlayerButton stopPlay];
    }
    else
    {
        NSString *audio = examParentModel.audio;
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:audio];
        [self.audioPlayerButton playAudio:path completion:^(BOOL finished, NSError *error) {
            
        }];
    }
}


#pragma mark - UI

-(HSAudioPlayerButton *)audioPlayerButton{
    if (!_audioPlayerButton) {
        _audioPlayerButton = [[HSAudioPlayerButton alloc] initWithFrame:CGRectMake(0, 15, 50, 50) buttonType:buttonAudioPlayType buttonStyle:audioButtonRoundedStyle];
        
        _audioPlayerButton.roundBackgroundColor = kColorMain;
        _audioPlayerButton.tintColor = kColorMain;
        _audioPlayerButton.centerX = self.backScrollView.width/2;
        [_audioPlayerButton addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:_audioPlayerButton];
        
    }
    return _audioPlayerButton;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
