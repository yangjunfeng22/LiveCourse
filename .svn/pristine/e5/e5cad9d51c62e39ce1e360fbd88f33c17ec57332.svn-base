//
//  HSLessonLearnManagerView.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/15.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSLessonLearnManagerView.h"
#import "UICourseItemLessonVC.h"
#import "NOMPageControl.h"
#import "HSTopicBaseView.h"
#import "HSImageChoiceTopic.h"
#import "HSUIAnimateHelper.h"
#import "AppDelegate.h"
#import "VBFPopFlatButton.h"
#import "HSWcjzTopicView.h"
#import "WordModel.h"
#import "SentenceModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface HSLessonLearnManagerView ()<UIScrollViewDelegate, HSTopicDelegate>
{
    NSInteger curPage;
    NSInteger totalPage;
    
    LiveCourseCheckPointType cpType;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgNodataView;

@property (nonatomic, strong) UILabel *lblLoadFailed;

@property (nonatomic, strong) UIButton *btnNext;
@property (nonatomic, strong) UIButton *btnReset;
@property (nonatomic, strong) VBFPopFlatButton *btnArrow;

@property (nonatomic, strong) NOMPageControl *pageControl;


@property (nonatomic, strong) HSTopicBaseView *topicView;
//@property (nonatomic, strong) ASImageNode *imageNode;

@property (nonatomic, strong) NSMutableArray *arrPageViews;
@property (nonatomic, strong) NSMutableArray *arrPageData;
@property (nonatomic, strong) NSMutableArray *arrTotalData;

@end

@implementation HSLessonLearnManagerView

+ (HSLessonLearnManagerView *)instance
{
    NSArray *loginView = [[NSBundle mainBundle] loadNibNamed:@"HSLessonLearnManagerView" owner:nil options:nil];
    return [loginView lastObject];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kColorWhite;
        [self initScrollContent];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = kColorWhite;

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame lessonData:(id)data type:(LiveCourseCheckPointType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self checkDataSource:data type:type];
    }
    return self;
}

- (void)resetLessonData:(id)data type:(LiveCourseCheckPointType)type
{
    [self checkDataSource:data type:type];
    
    switch (type)
    {
        case LiveCourseCheckPointTypeWord:
        case LiveCourseCheckPointTypeSentence:
        {
            // 需要重新配置界面
            [self resetInterface];
            break;
        }
        case LiveCourseCheckPointTypeLesson:
        case LiveCourseCheckPointTypeKnowledge:
        case LiveCourseCheckPointTypeTest:
        {
            [self.firstViewController.navigationController popViewControllerAnimated:NO];
            break;
        }
            
        default:
            break;
    }
}

- (UILabel *)lblLoadFailed
{
    if (!_lblLoadFailed)
    {
        _lblLoadFailed = [[UILabel alloc] init];
        _lblLoadFailed.size = CGSizeMake(self.width, 44);
        _lblLoadFailed.centerX = self.imgNodataView.centerX;
        _lblLoadFailed.text = GDLocal(@"加载失败");
        _lblLoadFailed.textColor = kColorWord;
        _lblLoadFailed.textAlignment = NSTextAlignmentCenter;
        _lblLoadFailed.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_lblLoadFailed];
    }
    return _lblLoadFailed;
}

- (UIImageView *)imgNodataView
{
    if (!_imgNodataView)
    {
        UIImage *img = [UIImage imageNamed:@"noDataImg.png"];
        _imgNodataView = [[UIImageView alloc] init];
        _imgNodataView.image = img;
        _imgNodataView.size = CGSizeMake(40, 40);
        [self addSubview:_imgNodataView];
    }
    return _imgNodataView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        CGFloat gapFactor = 20;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(gapFactor, gapFactor, self.width - gapFactor*2, self.height*0.79)];
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NOMPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[NOMPageControl alloc] initWithFrame:CGRectMake(0.0f, self.scrollView.bottom + 6.0f, self.width, 20.0f)];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = kColorMain;
        _pageControl.currentPage = curPage;
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (UIButton *)btnNext
{
    if (!_btnNext)
    {
        _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height*0.87, self.scrollView.width-28, 44)];
        _btnNext.centerX = self.scrollView.centerX;
        _btnNext.layer.cornerRadius = 6;
        _btnNext.backgroundColor = kColorMain;
        NSString *title = cpType == LiveCourseCheckPointTypeWord ? MyLocal(@"下一词") : MyLocal(@"下一句");
        [_btnNext setTitle:title forState:UIControlStateNormal];
        [_btnNext addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnNext.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_btnNext];

        [RACObserve(self.scrollView, contentOffset) subscribeNext:^(NSValue *contentOffset) {
            CGPoint point = [contentOffset CGPointValue];
            if (point.x >= (totalPage-1)*self.scrollView.width)
            {
                [_btnNext setTitle:MyLocal(@"继续") forState:UIControlStateNormal];
            }
            else if(point.x <= (totalPage-2)*self.scrollView.width)
            {
                NSString *title = cpType == LiveCourseCheckPointTypeWord ? MyLocal(@"下一词") : MyLocal(@"下一句");
                [_btnNext setTitle:title forState:UIControlStateNormal];
            }
        }];
    }
    _btnNext.hidden = totalPage <= 0;
    return _btnNext;
}

- (VBFPopFlatButton *)btnArrow
{
    if (!_btnArrow)
    {
        _btnArrow = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 12, 12) buttonType:buttonOkType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        _btnArrow.centerY = self.scrollView.centerY;
        _btnArrow.centerX = self.width;//totalPage*self.scrollView.width+self.scrollView.left;
        _btnArrow.lineThickness = 1;
        _btnArrow.roundBackgroundColor = kColorLine;
        _btnArrow.lineRadius = 0.5;
        _btnArrow.userInteractionEnabled = NO;
        _btnArrow.tintColor = kColorWhite;
        [self addSubview:_btnArrow];
    }
    return _btnArrow;
}

- (HSTopicBaseView *)topicView
{
    if (!_topicView)
    {
        if (cpType == LiveCourseCheckPointTypeWord)
        {
            _topicView  = [[HSImageChoiceTopic alloc] initWithFrame:self.bounds];
            ((HSImageChoiceTopic *)_topicView).choiceItems = self.arrPageData;
            
        }
        else
        {
            _topicView  = [[HSWcjzTopicView alloc] initWithFrame:self.bounds];
            
            if (totalPage > 0)
            {
                // 从可测试的句子列表中选出一个用来测试。
                NSMutableArray *arrTSen = [[NSMutableArray alloc] initWithCapacity:2];
                for (SentenceModel *sen in self.arrPageData)
                {
                    // 该句子可用来测试
                    if (sen.modeValue)
                    {
                        [arrTSen addObject:sen];
                    }
                }
                SentenceModel *senModel;
                NSInteger index = 0;
                NSInteger count = [arrTSen count];
                if (count > 0)
                {
                    index = arc4random() % count;
                    senModel = [arrTSen objectAtIndex:index];
                }
                else
                {
                    // 如果之前的数据非法, 那么使用全部的来提取数据
                    index = arc4random() % totalPage;
                    senModel = [self.arrPageData objectAtIndex:index];
                }
                
                ((HSWcjzTopicView *)_topicView).sentenceData = senModel;
            }
        }
        
        _topicView.delegate = self;
        _topicView.center = CGPointMake(self.width*1.5, self.height*0.5);
        _topicView.backgroundColor = kColorWhite;
        _topicView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_topicView];
    }
    return _topicView;
}

/*
- (ASImageNode *)imageNode
{
    if (!_imageNode)
    {
        _imageNode = [[ASImageNode alloc] init];
        CGFloat width = self.width;
        CGFloat height = self.height * 0.5;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _imageNode.frame = CGRectMake(0, 0, width, height);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self insertSubview:_imageNode.view belowSubview:self.scrollView];
            });
        });
    }
    return _imageNode;
}
 */

- (NSMutableArray *)arrPageViews
{
    if (!_arrPageViews)
    {
        _arrPageViews = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _arrPageViews;
}

- (NSMutableArray *)arrPageData
{
    if (!_arrPageData)
    {
        _arrPageData = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _arrPageData;
}

- (NSMutableArray *)arrTotalData
{
    if (!_arrTotalData)
    {
        _arrTotalData = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _arrTotalData;
}

- (void)checkDataSource:(NSArray *)data type:(LiveCourseCheckPointType)type
{
    cpType = type;
    totalPage = 0;
    [self.arrTotalData removeAllObjects];
    [self.arrPageData removeAllObjects];
    if ([data isKindOfClass:[NSArray class]] && [data count] > 0)
    {
        switch (type)
        {
            case LiveCourseCheckPointTypeWord:
            case LiveCourseCheckPointTypeSentence:
            {
                // 需要分组
                NSArray *arrRelation = [[data valueForKeyPath:@"@distinctUnionOfObjects.gID"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    
                    return [obj1 compare:obj2];
                }];
                
                for (NSString *gID in arrRelation)
                {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gID == %@", gID];
                    NSArray *arrSubData = [data filteredArrayUsingPredicate:predicate];
                    [self.arrTotalData addObject:arrSubData];
                }
                
                if ([self.arrTotalData count] > 0)
                {
                    self.btnNext.hidden = NO;
                    self.scrollView.hidden = NO;
                    self.pageControl.hidden = NO;
                    self.btnArrow.hidden = NO;
                    self.imgNodataView.hidden = YES;
                    self.lblLoadFailed.hidden = YES;
                    // 剪裁数据。词、句子是一组一组练习的。
                    [self filterTotalData];
                }
                else
                {
                    self.btnNext.hidden = YES;
                    self.scrollView.hidden = YES;
                    self.pageControl.hidden = YES;
                    self.btnArrow.hidden = YES;
                    //添加logo图片 及提示语
                    
                    self.imgNodataView.hidden = NO;
                    self.lblLoadFailed.hidden = NO;
                }
                break;
            }
            case LiveCourseCheckPointTypeLesson:
            {
                
                break;
            }
                
            default:
                break;
        }
    }
    else
    {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        
        [_pageControl removeFromSuperview];
        _pageControl = nil;
        
        [_btnNext removeFromSuperview];
        _btnNext = nil;
        
        [_btnArrow removeFromSuperview];
        _btnArrow = nil;
        
        [_topicView removeFromSuperview];
        _topicView = nil;
        
        //添加logo图片 及提示语
        self.imgNodataView.hidden = NO;
        self.lblLoadFailed.hidden = NO;
    }
}

- (void)filterTotalData
{
    // 获取第一个
    NSArray *arrData = [self.arrTotalData objectAtIndex:0];
    //DLog(@"第一个的数据: %@", arrData);
    // 使用这些数据初始化页面。
    [self initPageWithData:arrData];
    // 将够造过页面的数据删除。
    [self.arrTotalData removeObjectAtIndex:0];
}

- (void)initPageWithData:(NSArray *)data
{
    [self.arrPageData setArray:data];
    totalPage = [self.arrPageData count];
    curPage = 0;
    // 后续步骤
    [self initScrollContent];
}

- (void)initScrollContent
{
    self.pageControl.numberOfPages = totalPage;
    self.pageControl.currentPage = curPage;
    [self bringSubviewToFront:self.scrollView];
    [self.scrollView removeAllSubviews];
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*totalPage, 0);
    // 构造一个空的页面数组
    [self.arrPageViews removeAllObjects];
    for (NSUInteger i = 0; i < totalPage; i++) {
        [self.arrPageViews addObject:[NSNull null]];
    }
    
    [self loadScrollViewPage:0];
    [self loadScrollViewPage:1];
    [self loadScrollViewPage:2];
}


// 重新配置显示的界面
- (void)resetInterface
{
    [_btnArrow removeFromSuperview];
    _btnArrow = nil;
    
    self.scrollView.center = CGPointMake(self.width*1.5, self.scrollView.centerY);
    
    [HSUIAnimateHelper transitionView:self.topicView fromCenter:CGPointMake(self.width*0.5, self.height*0.5) toCenter:CGPointMake(-self.width*0.5, self.height*0.5) completion:^(BOOL finished) {
        [_topicView removeFromSuperview];
        _topicView = nil;
    }];
    [HSUIAnimateHelper transitionView:self.scrollView fromCenter:CGPointMake(self.width*1.5, self.scrollView.centerY) toCenter:CGPointMake(self.width*0.5, self.scrollView.centerY) completion:^(BOOL finished) {
        
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*totalPage, self.scrollView.height);
    self.pageControl.top = self.scrollView.bottom+6;
    self.btnNext.top = kiPhone4 ? self.height * 0.89:self.pageControl.bottom+2;
    self.imgNodataView.centerX = self.width * 0.5;
    self.imgNodataView.centerY = self.height * 0.36;
    self.lblLoadFailed.centerX = self.width * 0.5;
    self.lblLoadFailed.top = self.imgNodataView.bottom+20;
}

- (void)loadScrollViewPage:(NSInteger)page
{
    if (page < 0){
        return;
    }else if (page >= totalPage){
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            
            HSLessonPageView *tempView = [self.arrPageViews objectAtIndex:page];
            if ((NSNull *)tempView == [NSNull null])
            {
                // 在这里创建page的时候,我们可以使用传递进来的数据来创建具体的页面。
                // 然后根据cpType来加载不同类型的页面。
                // 可以将cpType传递给HSLessonPageView,然后pageView根据类型加载不同的view到页面上。
                id obj = [self.arrPageData objectAtIndex:page];
                tempView = [[HSLessonPageView alloc] initWithPageData:obj type:cpType];
                [self.arrPageViews replaceObjectAtIndex:page withObject:tempView];
            }
            
            if (tempView && (NSNull *)tempView != [NSNull null])
            {
                if (nil == tempView.superview)
                {
                    CGRect frame = self.scrollView.frame;
                    frame.origin.x = frame.size.width * page;
                    frame.origin.y = 0;
                    tempView.frame = CGRectMake(frame.size.width * page + 14, 0, frame.size.width-28, frame.size.height);
                    tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
                    [self.scrollView addSubview:tempView];
                }
                
                if (page != curPage){
                    [tempView resignCurrentPage];
                }else{
                    [tempView playMedia];
                }
            }
        });
    });
}

// 进入测试界面
- (void)pushIntoCheckTopicInterface
{
    [self.scrollView setContentOffset:self.scrollView.contentOffset animated:NO];
    __weak HSLessonLearnManagerView *weakSelf = self;
    [HSUIAnimateHelper transitionView:self.topicView fromCenter:CGPointMake(self.width*1.5, self.height*0.5) toCenter:CGPointMake(self.width*0.5, self.height*0.5) completion:^(BOOL finished) {
        [weakSelf.topicView playMedia];
    }];
    [HSUIAnimateHelper transitionView:self.scrollView fromCenter:CGPointMake(self.width*0.5, self.scrollView.centerY) toCenter:CGPointMake(-self.width*0.5, self.scrollView.centerY) completion:^(BOOL finished) {}];
    [HSUIAnimateHelper transitionView:self.btnArrow fromCenter:self.btnArrow.center toCenter:CGPointMake(-self.width*0.5, self.scrollView.centerY) completion:^(BOOL finished) {}];
}

#pragma mark - Action
- (void)nextAction:(id)sender
{
    // 自动滑动到下一页
    if (curPage >= totalPage - 1)
    {
        //进入测试界面
        if (totalPage > 0)
        {
            [self pushIntoCheckTopicInterface];
        }
        
    }
    else
    {
        UIButton *btn = (UIButton *)sender;
        btn.enabled = NO;
        CGFloat xOffset = (curPage + 1)*self.scrollView.width;
        CGRect nexRect = CGRectMake(xOffset, self.scrollView.top, self.scrollView.width, self.scrollView.height);
        [self.scrollView scrollRectToVisible:nexRect animated:YES];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pageControl.currentPage = page;
            
            if (page >= totalPage-1)
            {
                CGFloat distance = scrollView.contentOffset.x - pageWidth*(totalPage-1);
                
                if (scrollView.contentOffset.x + pageWidth - scrollView.contentSize.width > pageWidth*0.2)
                {
                    if (self.btnArrow.currentButtonType != buttonForwardType)
                    {
                        self.btnArrow.tintColor = kColorMain;
                        [self.btnArrow animateToType:buttonForwardType];
                    }
                }
                else
                {
                    self.btnArrow.centerX = self.width-distance*0.5;
                    if (self.btnArrow.currentButtonType != buttonOkType)
                    {
                        self.btnArrow.tintColor = kColorWhite;
                        [self.btnArrow animateToType:buttonOkType];
                    }
                }
            }
            else if (fabsf(scrollView.contentOffset.x - pageWidth*curPage) > pageWidth*0.5 && curPage < totalPage)
            {
                HSLessonPageView *tempView = [self.arrPageViews objectAtIndex:curPage];
                [tempView resignCurrentPage];
            }
        });
    });
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGFloat pageWidth = scrollView.frame.size.width;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (curPage >= totalPage-1 && totalPage > 0 && scrollView.contentOffset.x + pageWidth - scrollView.contentSize.width > pageWidth*0.2)
            {
                // 进入测试界面
                [self pushIntoCheckTopicInterface];
            }
        });
    });
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    curPage = page;
    
    [self loadScrollViewPage:page - 1];
    [self loadScrollViewPage:page];
    [self loadScrollViewPage:page + 1];
    [self loadScrollViewPage:page + 2];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.btnNext.enabled = YES;
    [self scrollViewDidEndDecelerating:scrollView];
}


#pragma mark - Topic Delegate
- (void)topicFinishedToContinue
{
    if ([self.arrTotalData count] >0)
    {
        [self filterTotalData];
        [self resetInterface];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(continueLearn)])
        {
            [self.delegate continueLearn];
        }
    }
    
}

#pragma mark - 内存管理
- (void)dealloc
{

}

@end
