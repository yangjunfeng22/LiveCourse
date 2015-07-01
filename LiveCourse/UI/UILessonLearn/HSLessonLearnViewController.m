//
//  HSLessonLearnViewController.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/14.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSLessonLearnViewController.h"

#import "HSLessonLearnManagerView.h"
#import "CheckPointNet.h"
#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"
#import "AudioPlayHelper.h"
#import "HSCheckPointHandle.h"
#import "MBProgressHUD.h"

@interface HSLessonLearnViewController ()<HSLessonLearnManagerViewDelegate>
{
    HSLessonLearnManagerView *managerView;
}

@property (nonatomic, strong) CheckPointNet *cpNet;

@end

@implementation HSLessonLearnViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CreatViewControllerImageBarButtonItem(ImageNamed(@"ico_navigation_back"), @selector(back:), self, YES);
    /**
     *  iOS7之后,如果nav的第一个子视图是scrollview的时候 
     *  系统会自动给scrollview加上64的inset
     *  这偏移与第三方的下拉刷新冲突
     
     *  解决冲突 禁止系统偏移
     */
    CGFloat top = 0;
    if (kiOS7_OR_LATER)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        top = self.navigationController.navigationBar.bottom;
    }
    // 关卡名称
    CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithLessonID:HSAppDelegate.curLID checkPointID:HSAppDelegate.curCpID];
    self.title = checkPoint.tName;
    // 获取数据。
    NSArray *arrContent = [CheckPointDAL queryCheckPointContentDataListWithCheckPointID:HSAppDelegate.curCpID checkPointType:HSAppDelegate.curCpType];
    //DLog(@"获取到的数据: %@", arrContent);
    managerView = [[HSLessonLearnManagerView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height-top) lessonData:arrContent type:HSAppDelegate.curCpType];
    managerView.delegate = self;
    managerView.backgroundColor = kColorWhite;
    managerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:managerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc
{
    [AudioPlayHelper stopAndCleanAudioPlay];
}

- (CheckPointNet *)cpNet
{
    if (!_cpNet)
    {
        _cpNet = [[CheckPointNet alloc] init];
    }
    return _cpNet;
}

- (void)back:(id)sender
{
    if (managerView) {
        [managerView removeFromSuperview];
        managerView = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HSLessonLearnManagerView Delegate
- (void)continueLearn
{
    NSString *curCpID = [HSAppDelegate.curCpID copy];
    NSString *nexCpID = [HSAppDelegate.nexCpID copy];
    
    __weak HSLessonLearnViewController *weakSelf = self;
    
    // 1、将当前关卡置为完成状态。
    [HSCheckPointHandle createCheckPointLearnedInfoWithUserID:kUserID lessonID:HSAppDelegate.curLID checkPointID:curCpID status:CheckPointLearnedStatusFinished version:nil completion:^(BOOL finished, id obj, NSError *error) {
        // 发送本地通知
        kPostNotification(kRefreshCheckPointStatus, nil, @{@"CheckPointID":curCpID});
        
        // 同步关卡进度
        NSString *record = [[NSString alloc] initWithFormat:@"%@|%@|%f", curCpID, @(CheckPointLearnedStatusFinished), 1.0];
        
        [weakSelf.cpNet requestCheckPointSynchronousProgressDataWithUserID:kUserID lessonID:HSAppDelegate.curLID records:record completion:^(BOOL finished, id obj, NSError *error) {}];
    }];
    
    // 2、将下一关置为解锁状态。发送本地通知。
    [HSCheckPointHandle createCheckPointLearnedInfoWithUserID:kUserID lessonID:HSAppDelegate.curLID checkPointID:nexCpID status:CheckPointLearnedStatusUnLocked version:nil completion:^(BOOL finished, id obj, NSError *error) {
        // 发送本地通知
        kPostNotification(kRefreshCheckPointStatus, nil, @{@"CheckPointID":nexCpID});
        
        // 同步关卡进度
        CheckPointProgressModel *cpProgress = [CheckPointDAL queryCheckPointProgressWithUserID:kUserID lessonID:HSAppDelegate.curLID checkPointID:nexCpID];
        
        NSString *record = [[NSString alloc] initWithFormat:@"%@|%d|%f", nexCpID, cpProgress.statusValue, cpProgress.progressValue];
        
        [weakSelf.cpNet requestCheckPointSynchronousProgressDataWithUserID:kUserID lessonID:HSAppDelegate.curLID records:record completion:^(BOOL finished, id obj, NSError *error) {}];
    }];
    
    // 3、获取下一关数据.
    CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithLessonID:HSAppDelegate.curLID checkPointID:nexCpID];
    [HSCheckPointHandle requestCheckPointContentDataWithView:self.view net:self.cpNet checkPoint:checkPoint completion:^(BOOL finished, id obj, NSError *error) {
        
        LiveCourseCheckPointType type = [obj integerValue];
        if (type == LiveCourseCheckPointTypeLesson || type == LiveCourseCheckPointTypeKnowledge || type == LiveCourseCheckPointTypeTest)
        {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(continueToLearnWithCheckPointType:)])
            {
                [weakSelf.delegate continueToLearnWithCheckPointType:type];
            }
        }
        else
        {
            NSArray *arrContent = [CheckPointDAL queryCheckPointContentDataListWithCheckPointID:checkPoint.cpID checkPointType:type];
            [managerView resetLessonData:arrContent type:type];
            weakSelf.title = checkPoint.tName;
        }
    }];
}

@end
