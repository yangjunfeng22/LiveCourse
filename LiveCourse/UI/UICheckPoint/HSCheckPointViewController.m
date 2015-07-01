//
//  HSCheckPointViewController.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/12.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCheckPointViewController.h"
#import "HSCheckPointView.h"
#import "HSCheckPointHandle.h"
#import "HSCourseHandle.h"
#import "MessageHelper.h"
#import "MBProgressHUD.h"
#import "UserDAL.h"
#import "AppDelegate.h"

#import "HSLessonLearnViewController.h"
#import "HSLessonInfoView.h"
#import "HSPinyinLabel.h"
#import "UICourseItemFinalTestVC.h"
#import "CheckPoint2ContentModel.h"
#import "UICourseItemLessonVC.h"
#import "UICourseItemKnowledgeVC.h"

#import "CourseDAL.h"
#import "CheckPointNet.h"
#import "CheckPointDAL.h"
#import "CheckPointModel.h"

#import "LessonModel.h"
#import "LessonProgressModel.h"
#import "UserLaterStatuModel.h"
#import "AudioPlayHelper.h"
#import "HSUIAnimateHelper.h"

#import "UICourseItemFinalTestReportVC.h"
#import "UINavigationController+Extern.h"

@interface HSCheckPointViewController ()<HSCheckPointViewDelegate, DownloadDelegate, HSLessonLearnViewControllerDelegate, UICourseItemLessonVCDelegate, UICourseItemKnowledgeVCDelegate>
@property (nonatomic, strong) HSCheckPointView *checkPointView;
@property (nonatomic, strong) HSLessonInfoView *lessonInfoView;

@property (nonatomic, strong) CheckPointNet *cpNet;

@property (nonatomic, strong) HSCheckPointHandle *checkPointHandle;
@property (nonatomic, strong) HSCourseHandle *courseHandle;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation HSCheckPointViewController

- (HSCheckPointView *)checkPointView
{
    if (!_checkPointView)
    {
        _checkPointView = [[HSCheckPointView alloc] initWithFrame:CGRectMake(0, self.lessonInfoView.bottom, self.view.width, self.view.height-self.lessonInfoView.height)];
        _checkPointView.delegate = self;
        [self.view addSubview:_checkPointView];
    }
    return _checkPointView;
}

- (HSLessonInfoView *)lessonInfoView
{
    if (!_lessonInfoView)
    {
        CGFloat start = kiOS7_OR_LATER ? self.navigationController.navigationBar.bottom:0;
        _lessonInfoView = [[HSLessonInfoView alloc] initWithFrame:CGRectMake(0, start, self.view.width, self.view.height*0.127)];
        _lessonInfoView.backgroundColor = kColorWhite;//[UIColor greenColor];
        _lessonInfoView.layer.borderWidth = 1;
        _lessonInfoView.layer.borderColor = kColorLine.CGColor;
        [self.view addSubview:_lessonInfoView];
    }
    return _lessonInfoView;
}

- (CheckPointNet *)cpNet
{
    if (!_cpNet)
    {
        _cpNet = [[CheckPointNet alloc] init];
        _cpNet.delegate = self;
    }
    return _cpNet;
}

- (HSCourseHandle *)courseHandle
{
    if (!_courseHandle)
    {
        _courseHandle = [[HSCourseHandle alloc] init];
    }
    return  _courseHandle;
}

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD)
    {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}


// 设置是否继续学习。
- (void)setContinueLearn:(BOOL)continueLearn
{
    _continueLearn = continueLearn;
    if (continueLearn)
    {
        // 继续学习
        UserLaterStatuModel *userLater = [UserDAL userLaterStatuWithUserID:kUserID courseCategoryID:kCourseCategoryID];
        CheckPointModel *checkpoint = [CheckPointDAL queryCheckPointWithLessonID:userLater.lID checkPointID:userLater.cpID];
        
        NSString *cpID = [checkpoint.cpID copy];
        NSInteger type = checkpoint.checkPointTypeValue;
        HSAppDelegate.curCpType = type;
        __weak HSCheckPointViewController *weakSelf = self;
        __block MBProgressHUD *hud;
        BOOL isDownloaded = type == LiveCourseCheckPointTypeKnowledge ? YES : [HSCheckPointHandle isDownloadedCheckPointMediaDataWithUserID:kUserID lessonID:@"" checkPointID:cpID];
        // 如果没有下载过数据，那么下载数据
        if (!isDownloaded)
        {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载数据")];
            // 下载数据
            [self.cpNet downloadCheckPointDataWithUserID:kUserID checkPointID:cpID address:checkpoint.address completion:^(BOOL finished, id obj, NSError *error) {
                NSArray *arrRela = [CheckPointDAL queryCheckPoint2ContentDataWithCheckPointID:cpID];
                NSInteger relaCount = [arrRela count];
                NSInteger contCount = [CheckPointDAL queryCheckPointContentCountWithCheckPointRelation:arrRela checkPintType:type];
                
                BOOL exist = relaCount > 0 && contCount > 0;
                
                if (exist)
                {
                    [hud hide:YES];
                    // 进入关卡
                    [weakSelf pushInCheckPointWithType:type animated:YES];
                }
                else
                {
                    // 请求关系数据
                    [weakSelf.cpNet requestCheckPointRelationWithUserID:kUserID checkPointID:cpID completion:^(BOOL finished, id obj, NSError *error) {
                        // 获取关卡所需数据
                        [weakSelf.cpNet requestCheckPointContentDataWithUserID:kUserID checkPointID:cpID checkPointType:type completion:^(BOOL finished, id obj, NSError *error) {
                            [hud hide:YES];
                            // 进入关卡
                            [weakSelf pushInCheckPointWithType:type animated:YES];
                        }];
                    }];
                }
                
            }];
        }
        else
        {
            // 下载过数据了，判断有没有文字数据。如果有文字数据,那么直接进入，没有的话，需要请求数据
            NSArray *arrRela = [CheckPointDAL queryCheckPoint2ContentDataWithCheckPointID:cpID];
            NSInteger relaCount = [arrRela count];
            NSInteger contCount = [CheckPointDAL queryCheckPointContentCountWithCheckPointRelation:arrRela checkPintType:type];
            
            BOOL exist = relaCount > 0 && contCount > 0;
            
            if (exist)
            {
                // 进入关卡
                [self pushInCheckPointWithType:type animated:NO];
            }
            else
            {
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载数据")];
            }
            
            // 请求关系数据
            [self.cpNet requestCheckPointRelationWithUserID:kUserID checkPointID:cpID completion:^(BOOL finished, id obj, NSError *error) {
                // 获取关卡所需数据
                [weakSelf.cpNet requestCheckPointContentDataWithUserID:kUserID checkPointID:cpID checkPointType:type completion:^(BOOL finished, id obj, NSError *error) {
                    [hud hide:YES];
                    if (!exist) {
                        [weakSelf pushInCheckPointWithType:type animated:YES];
                    }
                }];
            }];
        }
    }
    else
    {
        // 开始学习
        // 从第一个关卡开始学习。
        __block MBProgressHUD *hud;
        __weak HSCheckPointViewController *weakSelf = self;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载数据")];
        NSArray *arrCheckPoint = [CheckPointDAL queryCheckPointsWithLessonID:HSAppDelegate.curLID];
        if ([arrCheckPoint count] > 0)
        {
            [self loadPointDownloadDataWithCheckPoints:arrCheckPoint hud:hud];
        }
        else
        {
            // 关卡数据不存在
            [self.cpNet requestCheckPointListDataWithUserID:kUserID lessonID:HSAppDelegate.curLID completion:^(BOOL finished, id result, NSError *error) {
                
                // 然后再查询出来数据
                NSArray *arrCheckPoint = [CheckPointDAL queryCheckPointsWithLessonID:HSAppDelegate.curLID];
                [weakSelf loadPointDownloadDataWithCheckPoints:arrCheckPoint hud:hud];
            }];
        }
    }
}

- (void)loadPointDownloadDataWithCheckPoints:(NSArray *)arrCheckPoint hud:(MBProgressHUD *)hud
{
    if ([arrCheckPoint count] <= 0) return;
    CheckPointModel *checkpoint = [arrCheckPoint objectAtIndex:0];
    NSString *cpID = checkpoint.cpID;
    NSInteger type = checkpoint.checkPointTypeValue;
    HSAppDelegate.curCpType = type;
    HSAppDelegate.curCpID = cpID;
    if ([arrCheckPoint count] > 1)
    {
        CheckPointModel *checkpoint = [arrCheckPoint objectAtIndex:1];
        HSAppDelegate.nexCpID = checkpoint.cpID;
    }
    else
    {
        HSAppDelegate.nexCpID = checkpoint.cpID;
    }
    
    // 如果是开始学习的话，肯定是没有下载过数据的。
    // 那么首先要做的事就是下载数据。
    // 下载数据
    __weak HSCheckPointViewController *weakSelf = self;
    [self.cpNet downloadCheckPointDataWithUserID:kUserID checkPointID:cpID address:checkpoint.address completion:^(BOOL finished, id obj, NSError *error) {
        NSArray *arrRela = [CheckPointDAL queryCheckPoint2ContentDataWithCheckPointID:cpID];
        NSInteger relaCount = [arrRela count];
        NSInteger contCount = [CheckPointDAL queryCheckPointContentCountWithCheckPointRelation:arrRela checkPintType:type];
        
        BOOL exist = relaCount > 0 && contCount > 0;
        
        if (exist)
        {
            [hud hide:YES];
            // 进入关卡
            [weakSelf pushInCheckPointWithType:type animated:YES];
        }
        else
        {
            // 请求关系数据
            [self.cpNet requestCheckPointRelationWithUserID:kUserID checkPointID:cpID completion:^(BOOL finished, id obj, NSError *error) {
                // 获取关卡所需数据
                [weakSelf.cpNet requestCheckPointContentDataWithUserID:kUserID checkPointID:cpID checkPointType:type completion:^(BOOL finished, id obj, NSError *error) {
                    [hud hide:YES];
                    // 进入关卡
                    [weakSelf pushInCheckPointWithType:type animated:YES];
                }];
            }];
        }
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refreshLessonInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorWhite;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:ImageNamed(@"ico_navigation_back")];
    
    kAddObserverNotification(self, @selector(reFinalTest:), kReFinalTestNotification, nil);
    
    LessonModel *lesson = [CourseDAL queryLessonDataWithCourseID:HSAppDelegate.curCID lessonID:HSAppDelegate.curLID];
    self.lessonInfoView.obtain = lesson.tObtain;
    self.lessonInfoView.lessonProgress = 0;

    __block MBProgressHUD *hud;
    NSArray *arrCps = [CheckPointDAL queryCheckPointsWithLessonID:HSAppDelegate.curLID];
    NSInteger cpCount = [arrCps count];
    if (cpCount > 0)
    {
        [self.checkPointView refreshCheckPointWithData:arrCps];
    }
    else
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载数据")];
        hud.removeFromSuperViewOnHide = YES;
    }
    
    __weak HSCheckPointViewController *weakSelf = self;
    [self.cpNet requestCheckPointListDataWithUserID:kUserID lessonID:HSAppDelegate.curLID completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        if (cpCount <= 0) {
            // FIXME: 这里刷新了，相当于刷新界面多次，会造成闪烁。需要修改。
            [weakSelf refreshCheckPointData];
        }
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.checkPointView.top = self.lessonInfoView.bottom;
    self.checkPointView.height = self.view.height-self.lessonInfoView.height;
}

- (void)languageDidChanged:(NSNotification *)notification
{
    NSString *msg = [[NSString alloc] initWithFormat:@"%@",  notification.userInfo];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本地化以改变" message:msg delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil];
    [alert show];
}

- (void)refreshCheckPointData
{
    NSArray *arrCps = [CheckPointDAL queryCheckPointsWithLessonID:HSAppDelegate.curLID];
    [self.checkPointView refreshCheckPointWithData:arrCps];
}

- (void)refreshLessonInfo
{
    __weak HSCheckPointViewController *weakSelf = self;
    NSString *lID = [HSAppDelegate.curLID copy];
    [HSCourseHandle lessonProgressWithUserID:kUserID lessonID:lID completion:^(BOOL finished, id obj, NSError *error) {
        
        CGFloat progress = [obj floatValue];
        if (progress <= 0)
        {
            LessonProgressModel *lProgress = [CourseDAL queryLessonProgressDataWithLessonID:HSAppDelegate.curLID userID:kUserID];
            progress = lProgress.progressValue >= 0 ? lProgress.progressValue : 0;
        }

        weakSelf.lessonInfoView.lessonProgress = progress;
        
        // 通知课时界面刷新。
        kPostNotification(kRefreshLessonProgressAndStatus, nil, @{@"LessonID":lID});
    }];
}

// 重新测试。
- (void)reFinalTest:(NSNotification *)notification
{
    [self.navigationController popToViewController:self animated:NO];
    [self pushInCheckPointWithType:LiveCourseCheckPointTypeTest animated:NO];
}

#pragma mark - HSCheckPointView Delegate
- (void)checkPointView:(HSCheckPointView *)view selectCheckPoint:(id)checkpoint
{
    __weak HSCheckPointViewController *weakSelf = self;
    [HSCheckPointHandle requestCheckPointContentDataWithView:self.view net:self.cpNet checkPoint:checkpoint completion:^(BOOL finished, id obj, NSError * error) {
        [weakSelf pushInCheckPointWithType:[obj integerValue] animated:YES];
    }];
}

// 根据不同的类型进入不同的页面。
- (void)pushInCheckPointWithType:(LiveCourseCheckPointType)type animated:(BOOL)animated
{
    switch (type) {
        case LiveCourseCheckPointTypeWord:
        case LiveCourseCheckPointTypeSentence:
        {
            // 响应用户点击的这个事件，进入相应的关卡进行学习。
            HSLessonLearnViewController *lessonLearnVC = [[HSLessonLearnViewController alloc] initWithNibName:nil bundle:nil];
            lessonLearnVC.delegate = self;
            [self.navigationController pushViewController:lessonLearnVC animated:animated];
            break;
        }
        case LiveCourseCheckPointTypeLesson:
        {
            UICourseItemLessonVC *lessonVC = [[UICourseItemLessonVC alloc] initWithNibName:nil bundle:nil];
            lessonVC.delegate = self;
            [self.navigationController pushViewController:lessonVC animated:animated];
            break;
        }
        case LiveCourseCheckPointTypeKnowledge:
        {
            UICourseItemKnowledgeVC *knowledge = [[UICourseItemKnowledgeVC alloc] initWithNibName:nil bundle:nil];
            knowledge.delegate = self;
            [self.navigationController pushViewController:knowledge animated:animated];
            break;
        }
        case LiveCourseCheckPointTypeTest:
        {
            // 响应用户点击的这个事件，进入相应的关卡进行学习。
            UICourseItemFinalTestVC *testVC = [[UICourseItemFinalTestVC alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:testVC animated:animated];
            break;
        }
        default:
            break;
    }
    //DLog(@"userID: %@, cCID: %@, CID: %@, UID: %@, LID: %@, CPID: %@, NCPID: %@", kUserID, HSAppDelegate.curCCID, HSAppDelegate.curCID, HSAppDelegate.curUnitID, HSAppDelegate.curLID, HSAppDelegate.curCpID, HSAppDelegate.nexCpID);
    // 保存学习的状态
    [UserDAL saveUserLaterStatusWithUserID:[kUserID copy] categoryID:[HSAppDelegate.curCCID copy] courseID:[HSAppDelegate.curCID copy] unitID:[HSAppDelegate.curUnitID copy] lessonID:[HSAppDelegate.curLID copy] checkPointID:[HSAppDelegate.curCpID copy] nexCheckPointID:[HSAppDelegate.nexCpID copy] timeStamp:[timeStamp() integerValue] completion:^(BOOL finished, id result, NSError *error) {}];
}

- (void)continueToLearnWithCheckPointType:(NSInteger)type
{
    [self pushInCheckPointWithType:type animated:NO];
}


- (void)downloadProgress:(float)progress
{
    
}

#pragma mark - 内存管理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc
{
    _checkPointHandle = nil;
    _courseHandle     = nil;
    
    [AudioPlayHelper stopAndCleanAudioPlay];
    kRemoveObserverNotification(self, kReFinalTestNotification, nil);
    
    _cpNet = nil;
}

@end
