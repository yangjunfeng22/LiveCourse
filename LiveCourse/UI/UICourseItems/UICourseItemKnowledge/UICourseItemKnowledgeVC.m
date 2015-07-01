//
//  UICourseItemKnowledgeVC.m
//  LiveCourse
//
//  Created by Lu on 15/1/13.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseItemKnowledgeVC.h"
#import "UICourseItemKnowledgeWordView.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CheckPointNet.h"
#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"
#import "HSCheckPointHandle.h"
#import "UINavigationController+Extern.h"

@interface UICourseItemKnowledgeVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *continueBtn;//继续按钮
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) CheckPointNet *cpNet;

@end

@implementation UICourseItemKnowledgeVC
{
    NSInteger pageNum;
    NSInteger currentPageNum;
    
    NSMutableArray *knowledgeArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    
    if (kiOS7_OR_LATER)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 关卡名称
    CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithLessonID:HSAppDelegate.curLID checkPointID:HSAppDelegate.curCpID];
    self.title = checkPoint.tName;
    
    knowledgeArray = [NSMutableArray arrayWithCapacity:2];
    
    currentPageNum = 0;
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    //预加载数据
    
    //[self requestData];
    [self preload];
    
}

-(void)preload
{
    NSArray *arrKnowledge = [CheckPointDAL queryCheckPointContentDataListWithCheckPointID:HSAppDelegate.curCpID checkPointType:LiveCourseCheckPointTypeKnowledge];
    //DLog(@"知识点: %@", arrKnowledge);
    if (arrKnowledge && [arrKnowledge count] > 0)
    {
        [knowledgeArray setArray:arrKnowledge];
    }
    
    pageNum = knowledgeArray.count;
    
    [self loadData];
}


/*
-(void)requestData{
    
    [knowledgeNet requestKnowledgeDataWithCpID:[HSAppDelegate.curCpID copy] Completion:^(BOOL finished, id result, NSError *error) {
      
        if (!finished) {
            NSString *errorDomain = error.domain;
            [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:errorDomain isHide:YES position:HUDYOffSetPositionCenter];
        }
        
        [self preload];
        
    }];
}
*/


#pragma mark - Action

-(void)loadData
{
    self.mainScrollView.contentSize = CGSizeMake(self.view.width * pageNum, 0);
    
    self.pageControl.numberOfPages = pageNum;
    
    [self loadDetailView];
}

//加载词详情至scroll
-(void)loadDetailView{
    NSInteger tag = KCourseItemKnowledgeWordViewTag + currentPageNum;

    UICourseItemKnowledgeWordView *wordView = (UICourseItemKnowledgeWordView *)[self.mainScrollView viewWithTag:tag];
    if (!wordView)
    {

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        CGRect wordViewFrame = CGRectMake(currentPageNum * self.mainScrollView.width, 0, self.mainScrollView.width, self.mainScrollView.height);
        
        wordView = [[UICourseItemKnowledgeWordView alloc] initWithFrame:wordViewFrame];
        wordView.alpha = 0.0f;
        wordView.tag = KCourseItemKnowledgeWordViewTag + currentPageNum;
        if (pageNum > currentPageNum) [wordView loadWithKnowledgeModel:[knowledgeArray objectAtIndex:currentPageNum]];
        [self.mainScrollView addSubview:wordView];
        
        [UIView animateWithDuration:0.3f animations:^{
            wordView.alpha = 1.0f;
        }];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}


-(void)continueBtnClick:(id)sender{
    
    UICourseItemKnowledgeWordView *wordView = (UICourseItemKnowledgeWordView *)[self.mainScrollView viewWithTag:KCourseItemKnowledgeWordViewTag + currentPageNum];
    [wordView rotationToStartStatus];
    
    //如果进入最后一页 则点击进入测试 否则下一题
    if (currentPageNum == pageNum - 1)
    {
        DLog(@"测试");
        __weak UICourseItemKnowledgeVC *weakSelf = self;
        NSString *curCpID = [HSAppDelegate.curCpID copy];
        NSString *nexCpID = [HSAppDelegate.nexCpID copy];
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
        // 3、进入下一关
        CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithLessonID:HSAppDelegate.curLID checkPointID:nexCpID];
        
        [HSCheckPointHandle requestCheckPointContentDataWithView:self.view net:self.cpNet checkPoint:checkPoint completion:^(BOOL finished, id obj, NSError *error) {
            [self.navigationController popViewControllerAnimated:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(continueToLearnWithCheckPointType:)])
            {
                [self.delegate continueToLearnWithCheckPointType:[obj integerValue]];
            }
        }];
    }
    else
    {
        DLog(@"下一页");
        
        currentPageNum += 1;
        if (currentPageNum > pageNum-1) {
            currentPageNum = pageNum-1;
            return;
        }
        
        [self rollScroolView];
    }
}

- (void)rollScroolView
{
    CGFloat xOffset = currentPageNum * self.view.width;
    CGFloat yOffset = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(xOffset, yOffset);
    [self.mainScrollView setContentOffset:offset animated:YES];
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
        currentPageNum = distance/self.view.width;
        [self loadDetailView];
        self.pageControl.currentPage = currentPageNum;
        
        //最后一页 更改继续按钮状态
        if (currentPageNum == pageNum - 1) {
            self.continueBtn.titleLabel.alpha = 0;
            [UIView animateWithDuration:0.5f animations:^{
                self.continueBtn.titleLabel.alpha = 1;
                [self.continueBtn setTitle:MyLocal(@"继续") forState:UIControlStateNormal];
            }];
        }
        if (currentPageNum != pageNum - 1 && [self.continueBtn.titleLabel.text isEqualToString:@"进入练习"]) {
            self.continueBtn.titleLabel.alpha = 0;
            [UIView animateWithDuration:0.5f animations:^{
                self.continueBtn.titleLabel.alpha = 1;
                [self.continueBtn setTitle:MyLocal(@"下一知识点") forState:UIControlStateNormal];
            }];
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    UICourseItemKnowledgeWordView *wordView = (UICourseItemKnowledgeWordView *)[self.mainScrollView viewWithTag:KCourseItemKnowledgeWordViewTag + currentPageNum];
    [wordView rotationToStartStatus];
     */
    CGFloat distance = scrollView.contentOffset.x;
    CGFloat pageWidth = self.mainScrollView.width;
    if (distance + pageWidth - pageWidth*currentPageNum > pageWidth*0.8)
    {
        // 先翻页，再计算新的page。
        UICourseItemKnowledgeWordView *wordView = (UICourseItemKnowledgeWordView *)[self.mainScrollView viewWithTag:KCourseItemKnowledgeWordViewTag + currentPageNum];
        [wordView rotationToStartStatus];
    }

}


#pragma mark - UI

-(UIButton *)continueBtn{
    if (!_continueBtn) {
        CGFloat left = 10;
        CGFloat height = 40;
        CGRect frame = CGRectMake(left, 0, self.view.width - left*2, height);
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.frame = frame;
        _continueBtn.backgroundColor = kColorMain;
        if (kiOS7_OR_LATER) {
            _continueBtn.bottom = self.view.height - 15;
        }else{
            _continueBtn.bottom = self.view.height - 50;
        }
        
        _continueBtn.layer.cornerRadius = 5.0f;
        _continueBtn.layer.masksToBounds = YES;
        [_continueBtn setTitle:MyLocal(@"下一知识点") forState:UIControlStateNormal];
        [_continueBtn addTarget:self action:@selector(continueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_continueBtn];
    }
    return _continueBtn;
}


-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        //CGFloat top = StatuBar_HEIGHT + NavigationBar_HEIGHT;
        CGFloat top = 0;
        if (kiOS7_OR_LATER){
            top = self.navigationController.navigationBar.bottom;
        }
        if (!kiOS7_OR_LATER) {
            top = 0;
        }
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, self.view.width, 0)];
        _mainScrollView.height = self.pageControl.top - top;
        _mainScrollView.backgroundColor = kColorClear;
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        CGFloat height = 20;
        CGRect frame = CGRectMake(0, self.continueBtn.top - height, self.view.width, height);
        _pageControl = [[UIPageControl alloc] initWithFrame:frame];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:kColorMain];
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
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

@end
