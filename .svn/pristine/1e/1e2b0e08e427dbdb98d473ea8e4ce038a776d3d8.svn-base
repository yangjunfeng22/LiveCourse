//
//  UICourseItemFinalTestVC.m
//  LiveCourse
//
//  Created by Lu on 15/1/15.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseItemFinalTestVC.h"
#import "ZDProgressView.h"
#import "UICourseItemFinalTestReportVC.h"

#import "UICourseItemKnowledgeWordView.h"
#import "MBProgressHUD.h"

#import "UITestTopicBaseView.h"
#import "TestTopicManage.h"
#import "CheckPointNet.h"
#import "CheckPointDAL.h"
#import "ExamModel.h"
#import "HSCheckPointHandle.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"
#import "AudioPlayHelper.h"

NSInteger examArraySort(ExamModel *obj1, ExamModel *obj2, void *context)
{
    float price1 = [obj1.weight floatValue];
    float price2 = [obj2.weight floatValue];
    
    NSString *alias1 = obj1.typeAlias;
    NSString *alias2 = obj2.typeAlias;
    
    if ([alias1 isEqualToString:alias2]) {
        NSInteger random = arc4random()%3;
        if (random == 0) {
            return (NSComparisonResult)NSOrderedSame;
        }
        else if (random == 1)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (random == 2)
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
    }
    
    if (price1 > price2) {
        return (NSComparisonResult)NSOrderedDescending;
    }else if (price1 < price2){
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
}


#define  buttonLeft 10

@interface UICourseItemFinalTestVC ()<UIScrollViewDelegate,UIAlertViewDelegate,UITestTopicDelegate>

@property (nonatomic, strong) UIButton *continueBtn;//继续按钮
@property (nonatomic, strong) UIButton *resetBtn;//重置按钮
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) ZDProgressView *progressView;//进度
@property (nonatomic, strong) UILabel *progressLabel;//进度label
@property (nonatomic, strong) UIImageView *starImageView;//星星图标
@property (nonatomic, strong) UILabel *starNumLabel;//星星个数

@property (nonatomic, strong) CheckPointNet *cpNet;

@end


@implementation UICourseItemFinalTestVC
{
    NSInteger pageNum;
    NSInteger currentPageNum;
    BOOL isClickCheck;//是否点击了检查
    NSInteger userGetStarNum;//星星个数
    NSInteger allTopicFullStarNum;//所以题目的星星数
    
    TestTopicManage *testTopicManage;
    
    CGFloat continueBtnWidth;
    CGFloat resetBtnWidth;
    
    NSMutableArray *examArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;

    if (kiOS7_OR_LATER)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 关卡名称
    CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithLessonID:HSAppDelegate.curLID checkPointID:HSAppDelegate.curCpID];
    self.title = checkPoint.tName;
    
    CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"ico_navigation_back"], @selector(cancleTest), self, YES);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showResetBtn) name:kTestShowResetNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideResetBtn) name:kTestHideResetNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorDataAndToNext) name:kTestErrorDataNotification object:nil];


    testTopicManage = [[TestTopicManage alloc] init];
    isClickCheck = NO;
    examArray = [NSMutableArray arrayWithCapacity:2];
    
    //[self requestData];
    
    currentPageNum = 0;
    [self preload];
//    [self loadData];
}

-(void)cancleTest{
    [self.navigationController popViewControllerAnimated:YES];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocal(@"您确定要退出吗?") message:MyLocal(@"此测试进度将丢失。") delegate:self cancelButtonTitle:MyLocal(@"取消") otherButtonTitles:MyLocal(@"退出") , nil];
//    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - action
/*
-(void)requestData{
    NSString *curCpID = [HSAppDelegate.curCpID copy];
    DLog(@"requestDatacurCpID--------%@",curCpID);
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载数据")];
    [finalTestNet requestFinalTestDataWithCpID:curCpID Completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        if (!finished) {
            NSString *errorDomain = error.domain;
            [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:errorDomain isHide:YES position:HUDYOffSetPositionCenter];
        }
        
        [self preload];
    }];
}
 */

-(void)preload
{
    NSArray *arrExam = [CheckPointDAL queryCheckPointContentDataListWithCheckPointID:HSAppDelegate.curCpID checkPointType:LiveCourseCheckPointTypeTest];
    
    if (arrExam && [arrExam count] > 0)
    {
        [examArray setArray:[arrExam sortedArrayUsingFunction:examArraySort context:nil]];
    }
    
    pageNum = examArray.count;
    
    [self loadData];
}


- (void)loadData{
    self.continueBtn.backgroundColor = kColorClear;
    self.resetBtn.backgroundColor = kColorClear;
    self.starImageView.backgroundColor = kColorClear;
    [self editStarLabelNumWithAllStarNum:0];
    self.mainScrollView.backgroundColor = kColorClear;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.width * pageNum, 0);
    
    [self setProgressValue];
    [self loadDetailView];
}


//加载词详情至scroll
-(void)loadDetailView{
    NSInteger tag = KTestTopicTag + currentPageNum;
    
    UITestTopicBaseView *topicView = (UITestTopicBaseView *)[self.mainScrollView viewWithTag:tag];
    if (!topicView) {
        
        CGRect wordViewFrame = CGRectMake(currentPageNum * self.mainScrollView.width, 30, self.mainScrollView.width, self.mainScrollView.height - 40);
        if (pageNum > currentPageNum) topicView = [testTopicManage loadWithFrame:wordViewFrame andData:[examArray objectAtIndex:currentPageNum]];//测试使用currentPageNum
        topicView.alpha = 0.0f;
        topicView.delegate = self;
        topicView.backgroundColor = kColorClear;
        topicView.tag = KTestTopicTag + currentPageNum;
        [self.mainScrollView addSubview:topicView];
        
        [UIView animateWithDuration:0.3f animations:^{
            topicView.alpha = 1.0f;
        }];
    }
}



//设置进度
-(void)setProgressValue
{
    [UIView animateWithDuration:0.3f animations:^{
        self.progressView.progress = (CGFloat)(currentPageNum+1)/pageNum;
    }];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%li/%li",currentPageNum + 1,(long)pageNum];
    [self.progressLabel sizeToFit];
    self.progressLabel.centerY = self.progressView.centerY;
}


-(void)errorDataAndToNext{
    DLog(@"发生错误，跳转至下一题------------------");
    isClickCheck = YES;
    [self performSelector:@selector(continueBtnClick:) withObject:nil afterDelay:0.5f];
}

-(void)continueBtnClick:(id)sender{
    
    //点击检查后 就将检查按钮无效
    self.resetBtn.enabled = NO;
    self.resetBtn.layer.borderColor = HEXCOLOR(0xE3E3E3).CGColor;
    
    //如果未检查 则点击后开始检查  如果已经检查 则跳转下一题
    if (!isClickCheck) {
        
        [self editContinueBtnText];
        
        UITestTopicBaseView *topicView = (UITestTopicBaseView *)[self.mainScrollView viewWithTag:KTestTopicTag + currentPageNum];
        NSInteger rightStarNum = [topicView checkResultAndReturnRightStarNum];
        NSInteger theTopicViewFullStarNum = [topicView returnFullStarNum];
        allTopicFullStarNum += theTopicViewFullStarNum;
        
        //答对个数
        if (rightStarNum == 0) {
            //错误
        }else{
            //正确则为正确个数
             [self editStarAnimationWithNewStarNum:rightStarNum];
        }
        // 播放音效
        [self playCheckResult:(rightStarNum >= theTopicViewFullStarNum)];
       
        isClickCheck = YES;
    }
    else
    {
        if (currentPageNum >= pageNum - 1) {
            DLog(@"测试结果");
            /*
            NSString *curCpID = [HSAppDelegate.curCpID copy];
            // 1、将当前关卡置为完成状态。
            __weak UICourseItemFinalTestVC *weakSelf = self;
            [HSCheckPointHandle createCheckPointLearnedInfoWithUserID:kUserID lessonID:HSAppDelegate.curLID checkPointID:curCpID status:CheckPointLearnedStatusFinished version:nil completion:^(BOOL finished, id obj, NSError *error) {
                // 发送本地通知
                kPostNotification(kRefreshCheckPointStatus, nil, @{@"CheckPointID":curCpID});
                
                // 同步关卡进度
                NSString *record = [[NSString alloc] initWithFormat:@"%@|%@|%f", curCpID, @(CheckPointLearnedStatusFinished), 1.0];
                
                [weakSelf.cpNet requestCheckPointSynchronousProgressDataWithUserID:kUserID lessonID:HSAppDelegate.curLID records:record completion:^(BOOL finished, id obj, NSError *error) {}];
            }];
             */
            // 1、进入报表
            UICourseItemFinalTestReportVC *reportVC = [[UICourseItemFinalTestReportVC alloc] initWithTrueStarNum:userGetStarNum andAllStarNum:allTopicFullStarNum];
            [self.navigationController pushViewController:reportVC animated:YES];
        }
        else
        {
            DLog(@"下一页");
            
            currentPageNum += 1;
            if (currentPageNum > pageNum-1) {
                currentPageNum = pageNum-1;
                return;
            }
            
            [self editContinueBtnText];
            
            isClickCheck = NO;
            [self rollScroolView];
        }
    }
}

- (void)playCheckResult:(BOOL)right
{
    NSString *audio = @"wrong.mp3";
    if (right){
        audio = @"right.mp3";
    }
    [AudioPlayHelper stopAndCleanAudioPlay];
    NSString *path = [[NSBundle mainBundle] pathForResource:audio ofType:nil];
    AudioPlayHelper *audioPlayer = [AudioPlayHelper initWithAudioName:path delegate:nil];
    [audioPlayer playAudio];
}

-(void)resetBtnClick:(id)sender
{
    //关闭继续按钮
    self.continueBtn.enabled = NO;
    _continueBtn.layer.borderColor = HEXCOLOR(0xE3E3E3).CGColor;
    _continueBtn.layer.borderWidth = 1.0f;
    
    self.resetBtn.enabled = NO;
    [self userHasChoose:NO];
    
    UITestTopicBaseView *topicView = (UITestTopicBaseView *)[self.mainScrollView viewWithTag:KTestTopicTag + currentPageNum];
    [topicView resetAllOption];
}


//编辑答对星星个数
-(void)editStarAnimationWithNewStarNum:(NSInteger)newStartNum
{
    userGetStarNum += newStartNum;
    
    __block UILabel *animationLable = [[UILabel alloc] init];
    animationLable.center = CGPointMake(self.view.width/2, self.view.height/2);
    animationLable.width = 40;
    animationLable.height = 20;
    animationLable.backgroundColor = kColorClear;
    animationLable.textColor = kColorWord;
    animationLable.font = [UIFont systemFontOfSize:25.0f];
    NSString *animationTitle = [NSString stringWithFormat:@"+%li",(long)newStartNum];
    animationLable.text = animationTitle;
    [animationLable sizeToFit];
    [self.view addSubview:animationLable];
    [self.view bringSubviewToFront:animationLable];
    
    CGPoint point = self.starNumLabel.center;
    
    [UIView animateWithDuration:1.0f animations:^{
        animationLable.center = point;
        animationLable.alpha = 0;
    } completion:^(BOOL finished) {
        [self editStarLabelNumWithAllStarNum:userGetStarNum];
        animationLable = nil;
    }];
}

-(void)editStarLabelNumWithAllStarNum:(NSInteger)allStartNum{
    self.starNumLabel.text = [NSString stringWithFormat:@"%li",(long)allStartNum];
    [self.starNumLabel sizeToFit];
    _starNumLabel.centerY = self.progressView.centerY;
    _starNumLabel.right = self.starImageView.left - 5;
}

//设置继续按钮
-(void)editContinueBtnText{
    
    NSString *text = nil;
    if (isClickCheck) {
        text = MyLocal(@"检查");
    }
    else{
        text = MyLocal(@"继续");
    }
    self.continueBtn.titleLabel.alpha = 0;
    [UIView animateWithDuration:0.2f animations:^{
        self.continueBtn.titleLabel.alpha = 1;
        [self.continueBtn setTitle:text forState:UIControlStateNormal];
    }];
}


- (void)rollScroolView
{
    CGFloat xOffset = currentPageNum * self.view.width;
    CGFloat yOffset = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(xOffset, yOffset);
    [self.mainScrollView setContentOffset:offset animated:YES];
}


#pragma mark - UITestTopicDelegate
-(void)userHasChoosePleaseEditContinueBtnEnable{
    self.continueBtn.enabled = YES;
    _continueBtn.layer.borderColor = kColorMain.CGColor;
    _continueBtn.layer.borderWidth = 1.0f;
}

-(void)userNoChoosePleaseEditContinueBtnUnEnable{
    self.continueBtn.enabled = NO;
    _continueBtn.layer.borderColor = HEXCOLOR(0xE3E3E3).CGColor;
    _continueBtn.layer.borderWidth = 1.0f;
}

-(void)userHasChoose:(BOOL)hasChoose{
//    DLog(@"hasChoosehasChoosehasChoose----------%hhd",hasChoose);
    if (hasChoose) {
        self.resetBtn.enabled = YES;
        self.resetBtn.layer.borderColor = kColorMain.CGColor;
    }else{
        self.resetBtn.enabled = NO;
        self.resetBtn.layer.borderColor = HEXCOLOR(0xE3E3E3).CGColor;
    }
}

//显示重置按钮
-(void)showResetBtn{
    [self userHasChoose:NO];
    
    //显示有效
    if (self.resetBtn.hidden == NO) {
        return;
    }
   
    //动画
    self.resetBtn.width = 0;
    self.resetBtn.hidden = YES;
    [UIView animateWithDuration:0.5f animations:^{
        self.resetBtn.hidden = NO;
        self.resetBtn.width = resetBtnWidth;
        self.continueBtn.left = self.resetBtn.right + 10;
        self.continueBtn.width = self.resetBtn.width;
    } completion:^(BOOL finished) {
        
    }];
}

//隐藏

-(void)hideResetBtn{
    if (self.resetBtn.hidden == YES) {
        return;
    }
    
    self.resetBtn.hidden = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.resetBtn.width = 0;
        self.resetBtn.hidden = YES;
        
        self.continueBtn.left = buttonLeft;
        self.continueBtn.width = continueBtnWidth;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - scrollDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat distance = scrollView.contentOffset.x;
    NSInteger tempPageNum = distance/self.view.width;
    if (tempPageNum == currentPageNum) {
        return;
    }
    [self handleEndScroll:distance];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat distance = scrollView.contentOffset.x;
        [self handleEndScroll:distance];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat distance = scrollView.contentOffset.x;
    [self handleEndScroll:distance];
}

- (void)handleEndScroll:(CGFloat)distance
{
    if (distance >= 0)
    {
        self.continueBtn.enabled = NO;
        _continueBtn.layer.borderColor = HEXCOLOR(0xE3E3E3).CGColor;
        _continueBtn.layer.borderWidth = 1.0f;
        currentPageNum = distance/self.view.width;
        
        [self setProgressValue];
        
        [self loadDetailView];
        
    }
}


#pragma mark - UI

-(UIButton *)continueBtn{
    if (!_continueBtn) {
       
        CGFloat height = 40;
        continueBtnWidth = self.view.width - buttonLeft*2;
        CGRect frame = CGRectMake(buttonLeft, 0, continueBtnWidth , height);
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.frame = frame;
        if (kiOS7_OR_LATER) {
            _continueBtn.bottom = self.view.height - 15;
        }else{
            _continueBtn.bottom = self.view.height - 50;
        }
        
        _continueBtn.layer.cornerRadius = 5.0f;
        _continueBtn.layer.masksToBounds = YES;

        _continueBtn.enabled = NO;
        [_continueBtn setBackgroundImage:[UIImage imageWithColor:kColorWhite andSize:_continueBtn.size] forState:UIControlStateNormal];
        [_continueBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xE3E3E3) andSize:_continueBtn.size] forState:UIControlStateDisabled];
        [_continueBtn setTitleColor:kColorMain forState:UIControlStateNormal];
        [_continueBtn setTitleColor:kColorWord forState:UIControlStateDisabled];
        [_continueBtn setTitle:MyLocal(@"检查") forState:UIControlStateNormal];
        [_continueBtn addTarget:self action:@selector(continueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_continueBtn];
    }
    return _continueBtn;
}

-(UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat height = 40;
        resetBtnWidth = (self.view.width - buttonLeft*3)/2;
        CGRect frame = CGRectMake(buttonLeft, 0,resetBtnWidth , height);
        _resetBtn.frame = frame;
        if (kiOS7_OR_LATER) {
            _resetBtn.bottom = self.view.height - 15;
        }else{
            _resetBtn.bottom = self.view.height - 50;
        }
        
        _resetBtn.layer.cornerRadius = 5.0f;
        _resetBtn.layer.masksToBounds = YES;
        _resetBtn.layer.borderWidth = 1.0f;
        _resetBtn.layer.borderColor = kColorMain.CGColor;
        
        [_resetBtn setBackgroundImage:[UIImage imageWithColor:kColorWhite andSize:_resetBtn.size] forState:UIControlStateNormal];
        [_resetBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xE3E3E3) andSize:_resetBtn.size] forState:UIControlStateDisabled];
        [_resetBtn setTitleColor:kColorMain forState:UIControlStateNormal];
        [_resetBtn setTitleColor:kColorWord forState:UIControlStateDisabled];
        [_resetBtn setTitle:MyLocal(@"重置") forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn.hidden = YES;
        
        [self.view addSubview:_resetBtn];
    }
    return _resetBtn;
}


-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        //CGFloat top = StatuBar_HEIGHT + NavigationBar_HEIGHT;
        CGFloat top = 0;
        if (kiOS7_OR_LATER)
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
            top = self.navigationController.navigationBar.bottom;
        }
        if (!kiOS7_OR_LATER) {
            top = 0;
        }
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, self.view.width, 0)];
        _mainScrollView.height = self.continueBtn.top - top;
        _mainScrollView.backgroundColor = kColorClear;
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.scrollEnabled = NO;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}


-(ZDProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[ZDProgressView alloc] init];
        _progressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _progressView.height = 13;
        if (kiOS7_OR_LATER) {
            _progressView.top = StatuBar_HEIGHT + NavigationBar_HEIGHT + 10;
        }else{
            _progressView.top = 10;
        }
        
        _progressView.left = 15;
        _progressView.width = 125;
        _progressView.noColor = kColorWhite;
        _progressView.textColor = kColorBlack;
        _progressView.borderColor = HEXCOLOR(0x43C55D);
        _progressView.prsColor = HEXCOLOR(0x43C55D);
        _progressView.textFont = [UIFont fontWithName:@"System Bold" size:12];
        
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.left = self.progressView.right + 5;
        _progressLabel.textColor = kColorWord;
        _progressLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.view addSubview:_progressLabel];
    }
    return _progressLabel;
}


-(UIImageView *)starImageView{
    if (!_starImageView) {
        UIImage *image = [UIImage imageNamed:@"icon_finalTest_star"];
        _starImageView = [[UIImageView alloc] initWithImage:image];
        _starImageView.size = image.size;
        _starImageView.centerY = self.progressView.centerY;
        _starImageView.right = self.view.width - 15;
        [self.view addSubview:_starImageView];
    }
    return _starImageView;
}

-(UILabel *)starNumLabel{
    if (!_starNumLabel) {
        _starNumLabel = [[UILabel alloc] init];
        _starNumLabel.width = 100;
        _starNumLabel.right = self.starImageView.left - 5;
        _starNumLabel.height = 15;
        _starNumLabel.textAlignment = NSTextAlignmentRight;
        _starNumLabel.textColor = kColorWord;
        _starNumLabel.centerY = self.progressView.centerY;
        _starNumLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.view addSubview:_starNumLabel];
    }
    return _starNumLabel;
}

- (CheckPointNet *)cpNet
{
    if (!_cpNet)
    {
        _cpNet = [[CheckPointNet alloc] init];
    }
    return _cpNet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    kRemoveObserverNotification(self, nil, nil);
    [examArray removeAllObjects];
    examArray = nil;
}

@end
