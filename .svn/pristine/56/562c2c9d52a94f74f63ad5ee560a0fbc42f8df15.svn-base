//
//  UICourseItemFinalTestReportVC.m
//  LiveCourse
//
//  Created by Lu on 15/1/14.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseItemFinalTestReportVC.h"
#import "HSCheckPointViewController.h"
#import "HSVipShopViewController.h"
#import "CourseDAL.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "LessonModel.h"
#import "LessonProgressModel.h"
#import "MessageHelper.h"
#import "HSUIAnimateHelper.h"
#import "HSCheckPointHandle.h"

#import "CheckPointNet.h"
#import "PracticeRecordStore.h"

#define kSuccessFactor 0.8

@interface UICourseItemFinalTestReportVC ()<HSVipShopDelegate>
{
    BOOL isFinishedAllLesson;
    BOOL isGetedCoin;
}

@property (nonatomic, strong) UIScrollView *backScrollView;

@property (nonatomic, strong) UILabel *testResultLabel;//测试结果Label
@property (nonatomic, strong) UIImageView *testResultImageView;//测试结果图片

@property (nonatomic, strong) UILabel *rewardsLabel;//奖励label
@property (nonatomic, strong) UIButton *bottomBtn;//底部按钮

@property (nonatomic, strong) UIImageView *moneyImageView;//50汉生币
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIImageView *unlockImageView;//解锁
@property (nonatomic, strong) UILabel *unlockLabel;


@property (nonatomic, strong) UILabel *starNumLabel;//星星个数
@property (nonatomic, strong) UIImageView *starImageView;//星星图标

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) CheckPointNet *cpNet;


@end

@implementation UICourseItemFinalTestReportVC
{
    BOOL resultSuccess;//测试结果
    NSInteger userTrueNum;
    NSInteger userAllStarNum;
    NSString *nexLID;
    NSString *curLID;
}


-(id)initWithTrueStarNum:(NSInteger)trueNum andAllStarNum:(NSInteger)allStarNum
{
    self = [super init];
    if (self)
    {
        userTrueNum = trueNum;
        userAllStarNum = allStarNum;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (kiOS7_OR_LATER)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = kColorWhite;
    self.title = MyLocal(@"测试结果");
    CGFloat progress = (CGFloat)userTrueNum/(CGFloat)userAllStarNum;
    resultSuccess = progress >= kSuccessFactor;
    
    CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"ico_navigation_back"], @selector(back), self, YES);
    
    curLID = [HSAppDelegate.curLID copy];
    nexLID = [HSAppDelegate.nexLID copy];
    
    isFinishedAllLesson = [curLID isEqualToString:nexLID];

    // 判断是否已经获取过汉声币了。
    LessonProgressModel *lessonPro = [CourseDAL queryLessonProgressDataWithLessonID:curLID userID:kUserID];
    isGetedCoin = NO;
    if (lessonPro && lessonPro.statusValue == LessonLearnedStatusFinished && lessonPro.progressValue >= kSuccessFactor) {
        isGetedCoin = YES;
    }
    
    if (resultSuccess)
    {
        // 如果达到过关条件，那么置本关为完成状态，否则是处于解锁状态。
        NSString *curCpID = [HSAppDelegate.curCpID copy];
        // 1、将当前测试关卡置为完成状态。
        __weak UICourseItemFinalTestReportVC *weakSelf = self;
        [HSCheckPointHandle createCheckPointLearnedInfoWithUserID:kUserID lessonID:HSAppDelegate.curLID checkPointID:curCpID status:CheckPointLearnedStatusFinished version:nil completion:^(BOOL finished, id obj, NSError *error) {
            // 发送本地通知
            kPostNotification(kRefreshCheckPointStatus, nil, @{@"CheckPointID":curCpID});
            
            // 同步关卡进度
            NSString *record = [[NSString alloc] initWithFormat:@"%@|%@|%f", curCpID, @(CheckPointLearnedStatusFinished), 1.0];
            [weakSelf.cpNet requestCheckPointSynchronousProgressDataWithUserID:kUserID lessonID:curLID records:record completion:^(BOOL finished, id obj, NSError *error) {}];
        }];
        
        // 2、置本课为完成状态
        [CourseDAL saveLessonProgressDataWithLessonID:curLID userID:kUserID progress:1 status:LessonLearnedStatusFinished curStars:userTrueNum totalStars:userAllStarNum completion:^(BOOL finished, id obj, NSError *error) {
            // 通知课时界面刷新。
            kPostNotification(kRefreshLessonProgressAndStatus, nil, @{@"LessonID":curLID});
        }];
        
        // 3、如果本关已经达到要求。判断用户角色, 是否解锁下一关。
        [self judgeUserRoleToUnlockLesson:nexLID];
    }
    
    // 加载UI显示所需的数据
    [self loadUIData];
    // 同步练习的记录。
    [self synchronousPracticeRecord];
}

- (void)back
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[HSCheckPointViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

-(void)loadUIData
{
    NSString *testResultStr = nil;
    NSString *bottomBtnText = nil;
    UIImage *testResultImg = nil;
    NSString *rewardsStr = nil;
    if (resultSuccess) {
        testResultStr = isFinishedAllLesson ? MyLocal(@"真棒，你已学完本课了。该课程已经全部结束了哦。"): MyLocal(@"真棒！您已学完本课了哟~");
        self.testResultLabel.textColor = HEXCOLOR(0xFB5100);
        bottomBtnText = MyLocal(@"进入下一课");
        testResultImg = [UIImage imageNamed:@"image_finalTest_passCup"];
        rewardsStr = isFinishedAllLesson ? @"" : MyLocal(@"小小奖励作为鼓励，要继续保持哦~");
        
    }else{
        testResultStr = MyLocal(@"没有通过呢，再努力一下下吧~");
        bottomBtnText = MyLocal(@"重新测试");
        testResultImg = [UIImage imageNamed:@"image_finalTest_noPass"];
        rewardsStr = isFinishedAllLesson ? @"" : MyLocal(@"通关以后你可以获得以下奖励:");
    }
    
    //添加入UI
    self.testResultLabel.text = testResultStr;
    [self.testResultLabel sizeToFit];
    self.testResultLabel.centerX = self.view.width*0.5;
    [HSUIAnimateHelper popUpAnimationWithView:self.testResultLabel];
    self.testResultImageView.image = testResultImg;
    self.testResultImageView.size = testResultImg.size;
    self.testResultImageView.top = self.testResultLabel.bottom+2;
    self.testResultImageView.centerX = self.view.width/2;
    
    self.starNumLabel.text = [NSString stringWithFormat:@"%li/%li",(long)userTrueNum,(long)userAllStarNum];
    [self.starNumLabel sizeToFit];
    self.starNumLabel.centerX = self.view.width/2;
    
    self.starImageView.right = self.starNumLabel.left - 10;
    self.starImageView.centerY = self.starNumLabel.centerY;
    
    self.rewardsLabel.top = self.starNumLabel.bottom + 30;
    self.rewardsLabel.text = rewardsStr;
    
    if (resultSuccess && isFinishedAllLesson){
        //self.bottomBtn.hidden = YES;
        [self.bottomBtn setTitle:MyLocal(@"返回") forState:UIControlStateNormal];
    }else{
        //self.bottomBtn.hidden = NO;
        [self.bottomBtn setTitle:bottomBtnText forState:UIControlStateNormal];
    }
    
    [self loadRewardsImageAndText];
}


-(void)loadRewardsImageAndText
{
    LessonModel *lesson = [CourseDAL queryLessonDataWithCourseID:HSAppDelegate.curCID lessonID:HSAppDelegate.curLID];
    
    NSString *reward = isGetedCoin ? @"":[[NSString alloc] initWithFormat:MyLocal(@"送您%@汉声币"), @(lesson.rewardValue)];
    self.moneyImageView.backgroundColor = kColorClear;
    self.moneyLabel.text = reward;
    [self.moneyLabel sizeToFit];
    self.moneyLabel.centerY = self.moneyImageView.centerY;

    if (!isFinishedAllLesson)
    {
        LessonModel *nexLesson = [CourseDAL queryLessonDataWithCourseID:HSAppDelegate.curCID lessonID:nexLID];
        NSString *nexLessonName = [[NSString alloc] initWithFormat:MyLocal(@"您可以来学%@啦"), nexLesson.tTitle];
        self.unlockImageView.backgroundColor = kColorClear;
        self.unlockLabel.text =nexLessonName;
        [self.unlockLabel sizeToFit];
        self.unlockLabel.centerY = self.unlockImageView.centerY;
    }
    else
    {
        // 全部都学完了，不需要这个图标了。
        self.unlockImageView.image = nil;
    }
    self.backScrollView.contentSize = CGSizeMake(self.view.width, self.unlockLabel.bottom + 10);
}

- (void)bottomButtonAction:(id)sender
{
    
    if (isFinishedAllLesson)
    {
        // 如果全部的都完成了，那么回退到首页。
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (resultSuccess)
    {
        NSInteger curTime = [timeStamp() integerValue];
        NSInteger vipEndTime = (NSInteger)self.userModel.roleEndDateValue;
        if (vipEndTime > curTime)
        {
            // 还在vip期间内, 那么可以直接进入下一课。
            // 进入下一课
            kPostNotification(kNexLessonNotification, nil, @{@"LessonID":nexLID});
        }
        else
        {
            // 弹出vip购买的界面
            HSVipShopViewController *shopVC = [[HSVipShopViewController alloc] init];
            shopVC.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopVC];
            [self presentViewController:nav animated:YES completion:^{}];
        }
    }
    else
    {
        // 重新测试
        kPostNotification(kReFinalTestNotification, nil, nil);
    }
}

- (void)unlockNextLesson:(NSString *)aNexLID
{
    if (!isFinishedAllLesson)
    {
        DLog(@"在解锁下一课");
        // 2、置下一课为解锁状态。
        [CourseDAL saveLessonProgressDataWithLessonID:aNexLID userID:kUserID progress:0 status:LessonLearnedStatusUnLocked curStars:0 totalStars:0 completion:^(BOOL finished, id obj, NSError *error) {
            // 通知课时界面刷新。
            kPostNotification(kRefreshLessonProgressAndStatus, nil, @{@"LessonID":aNexLID});
        }];
    }
}

- (void)judgeUserRoleToUnlockLesson:(NSString *)lID
{
    //NSUInteger curTime = [timeStamp() integerValue];
    //NSUInteger vipEndTime = (NSUInteger)self.userModel.roleEndDateValue;
    //if (vipEndTime > curTime)
    //{
        // 还在vip期间内, 那么可以直接解锁下一课。
        // 如果不在vip期间内, 点击下一关的时候需要购买vip。
        [self unlockNextLesson:lID];
    //}
}
#pragma mark - 同步做题记录的数据
- (void)synchronousPracticeRecord
{
    NSString *record = [PracticeRecordStore practiceRecordsWithUserID:kUserID];
    [self.cpNet synchronousPracticeRecordWithUserID:kUserID record:record completion:^(BOOL finished, id data, NSError *error) {
        DLog(@"data: %@; error: %@", data, error);
    }];
}

#pragma mark - vip购买 代理
- (void)vipShop:(HSVipShopViewController *)vipShopController finishedBuy:(BOOL)flag
{
    [self judgeUserRoleToUnlockLesson:nexLID];
}

#pragma mark - 属性获取
- (UserModel *)userModel
{
    if (!_userModel)
    {
        _userModel = [UserDAL queryUserInfoWithUserID:kUserID];
    }
    return _userModel;
}

- (CheckPointNet *)cpNet
{
    if (!_cpNet)
    {
        _cpNet = [[CheckPointNet alloc] init];
    }
    return _cpNet;
}

#pragma mark - UI

-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _backScrollView.height = self.bottomBtn.top - 10;
        [self.view addSubview:_backScrollView];
    }
    return _backScrollView;
}

-(UILabel *)testResultLabel{
    if (!_testResultLabel) {
        _testResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, self.view.width-20, 50)];
        if (!kiOS7_OR_LATER) {
            _testResultLabel.top = 15;
        }
        _testResultLabel.textAlignment = NSTextAlignmentCenter;
        _testResultLabel.font = [UIFont systemFontOfSize:20.0f];
        _testResultLabel.textColor = kColorWord;
        _testResultLabel.numberOfLines = 0;
        _testResultLabel.backgroundColor = kColorClear;
        [self.backScrollView addSubview:_testResultLabel];
    }
    return _testResultLabel;
}


-(UIImageView *)testResultImageView{
    if (!_testResultImageView) {
        _testResultImageView = [[UIImageView alloc] init];
        _testResultImageView.backgroundColor = kColorClear;
        [self.backScrollView addSubview:_testResultImageView];
    }
    return _testResultImageView;
}


-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = kColorMain;
        
        CGFloat left = 10;
        CGFloat height = 44;
        CGRect frame = CGRectMake(left, 0, self.view.width - left*2, height);
        _bottomBtn.frame = frame;
        if (kiOS7_OR_LATER) {
            _bottomBtn.bottom = self.view.height - 15;
        }else{
            _bottomBtn.bottom = self.view.height - 50;
        }
        
        _bottomBtn.layer.cornerRadius = 5.0f;
        _bottomBtn.layer.masksToBounds = YES;
        [_bottomBtn addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomBtn];
    }
    return _bottomBtn;
}

-(UILabel *)rewardsLabel{
    if (!_rewardsLabel) {
        _rewardsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, self.view.width - 20, 30)];
        _rewardsLabel.textColor = kColorWord;
        _rewardsLabel.backgroundColor = kColorClear;
        _rewardsLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.backScrollView addSubview:_rewardsLabel];
    }
    return _rewardsLabel;
}

-(UIImageView *)moneyImageView{
    if (!_moneyImageView) {
        NSString *imageName = @"";
        if (!isGetedCoin)
        {
            if (resultSuccess) {
                imageName = @"image_finalTest_HSMoney_Y";
            }
            else{
                imageName = @"image_finalTest_HSMoney_N";
            }
        }
        
        UIImage *image = [UIImage imageNamed:imageName];
        _moneyImageView = [[UIImageView alloc] initWithImage:image];
        _moneyImageView.size = image.size;
        _moneyImageView.left = 30;
        _moneyImageView.top = self.rewardsLabel.bottom + 15;
        
        !isGetedCoin ? [self.backScrollView addSubview:_moneyImageView]:@"";
    }
    return _moneyImageView;
}

-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:16.0f];
        _moneyLabel.textColor = kColorWord;
        _moneyLabel.numberOfLines = 0;
        _moneyLabel.backgroundColor = kColorClear;
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        
        CGFloat left = self.moneyImageView.right + 20;
        _moneyLabel.left = left;
        _moneyLabel.height = 80;
        _moneyLabel.width = self.view.width - left - 10;
        _moneyLabel.centerY = self.moneyImageView.centerY;
        
        [self.backScrollView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

-(UIImageView *)unlockImageView{
    
    NSString *imageName = @"";
    
    if (!_unlockImageView) {
        
        if (resultSuccess) {
            imageName = @"image_finalTest_UnLock_Y";
        }
        else{
            imageName = @"image_finalTest_UnLock_N";
        }
        
        UIImage *image = [UIImage imageNamed:imageName];
        _unlockImageView = [[UIImageView alloc] initWithImage:image];
        _unlockImageView.size = image.size;
        
        _unlockImageView.left = 30;
        _unlockImageView.top = self.moneyImageView.bottom + 15;
        
        [self.backScrollView addSubview:_unlockImageView];
    }
    return _unlockImageView;
}


-(UILabel *)unlockLabel{
    if (!_unlockLabel) {
        _unlockLabel = [[UILabel alloc] init];
        _unlockLabel.font = [UIFont systemFontOfSize:16.0f];
        _unlockLabel.textColor = kColorWord;
        _unlockLabel.numberOfLines = 0;
        _unlockLabel.textAlignment = NSTextAlignmentLeft;
        _unlockImageView.backgroundColor = kColorClear;
        
        _unlockLabel.height = 80;
        CGFloat left = self.unlockImageView.right + 20;
        _unlockLabel.left = left;
        _unlockLabel.width = self.view.width - left - 10;
        _unlockLabel.centerY = self.unlockImageView.centerY;
        
        [self.backScrollView addSubview:_unlockLabel];
    }
    return _unlockLabel;
}


-(UILabel *)starNumLabel{
    if (!_starNumLabel) {
        _starNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.testResultImageView.bottom + 10, 100, 30)];
        _starNumLabel.textColor = kColorWord;
        _starNumLabel.font = [UIFont systemFontOfSize:15.0f];
        _starNumLabel.textAlignment = NSTextAlignmentCenter;
        [self.backScrollView addSubview:_starNumLabel];
    }
    return _starNumLabel;
}

-(UIImageView *)starImageView{
    if (!_starImageView) {
        UIImage *starImg = [UIImage imageNamed:@"icon_finalTest_star"];
        _starImageView = [[UIImageView alloc] initWithImage:starImg];
        _starImageView.size = starImg.size;
        [self.backScrollView addSubview:_starImageView];
    }
    return _starImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
