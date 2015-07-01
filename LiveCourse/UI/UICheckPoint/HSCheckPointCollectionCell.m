//
//  HSCheckPointCollectionCell.m
//  HSWordsPass
//
//  Created by yang on 14/11/7.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCheckPointCollectionCell.h"
#import "HSCheckPointCollectionView.h"
#import "HSCollectionViewCheckPointLayout.h"

#import "CheckPointNet.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"
#import "HSCheckPointHandle.h"
#import "UIImageView+WebCache.h"
#import "HSUIAnimateHelper.h"

@interface HSCheckPointCollectionCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, readonly, weak)HSCheckPointCollectionView *parentView;
@property (nonatomic, strong) CheckPointNet *cpNet;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, getter=isDownloaded) BOOL downloaded;

@end

@implementation HSCheckPointCollectionCell
{
    CGFloat progress;
    CGFloat titleWidth;
    CGFloat cHeight;
    NSInteger status; // 0:锁定；1:解锁；2:完成
    NSString *tCheckPointName;
    
    UIImage *imgUnLocked;
    UIImage *imgLocked;
    UIImage *imgFinished;
    
    UIImage *imgLink_S;
    UIImage *imgLink;
    UIImage *imgHLink_S;
    UIImage *imgHLink;
    
    BOOL shouldShowProgress;
}

@synthesize parentView = _parentView;

- (instancetype)initWithFrame:(CGRect)frame
{
    //DLOG_CMETHOD;
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrViews = [[NSBundle mainBundle] loadNibNamed:@"HSCheckPointCollectionCell" owner:self options:nil];
        
        if ([arrViews count] < 1){
            return nil;
        }
        
        if (![[arrViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        
        self = [arrViews objectAtIndex:0];
        self.backgroundColor = kColorRed;
        
        
        [self addGestureRecognizer:self.longPress];
        
        imgLink_S   = [UIImage imageNamed:@"img_checkPoint_link_s"];
        imgLink     = [UIImage imageNamed:@"img_checkPoint_link"];
        imgHLink_S  = [UIImage imageNamed:@"img_checkPoint_link_h_s"];
        imgHLink    = [UIImage imageNamed:@"img_checkPoint_link_h"];
        
        kAddObserverNotification(self, @selector(refreshCheckPointStatus:), kRefreshCheckPointStatus, nil);
    }
    return self;
}

- (void)dealloc
{
    kRemoveObserverNotification(self, kRefreshCheckPointStatus, nil);
}

- (UIImageView *)imgvLink
{
    if (!_imgvLink)
    {
        _imgvLink = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgvLink.alpha = 0;
        [self addSubview:_imgvLink];
    }
    return _imgvLink;
}

- (HSCheckPointCollectionView *)parentView
{
    if (!_parentView) {
        UIView *view = self.superview;
        _parentView = (HSCheckPointCollectionView *)view;
    }
    return _parentView;
}

- (CheckPointNet *)cpNet
{
    if (!_cpNet)
    {
        _cpNet = [[CheckPointNet alloc] init];
    }
    return _cpNet;
}

- (BOOL)isDownloaded
{
    NSString *dataPath = [NSString stringWithFormat:@"%@", self.checkPointModel.cpID];
    NSString *dataDir =[kDownloadedPath stringByAppendingPathComponent:dataPath];
    BOOL downloaded = [[NSFileManager defaultManager] fileExistsAtPath:dataDir];
    
    return downloaded;
}

#pragma mark - 通知处理
- (void)refreshCheckPointStatus:(NSNotification *)notification
{
    NSString *cpID = [notification.userInfo objectForKey:@"CheckPointID"];
    if ([cpID isEqualToString:self.checkPointModel.cpID])
    {
        __weak HSCheckPointCollectionCell *weakSelf = self;
        [self loadCheckPointProgressWithUserID:kUserID lessonID:self.checkPointModel.lID checkPointID:cpID completion:^(BOOL finished, BOOL progressExit, NSInteger statu) {
            // 刷新关卡信息和状态
            [weakSelf refreshCheckPointInfoAndStatu:statu];
        }];
    }
}

- (void)nextCheckPoint:(NSNotification *)notification
{
    NSString *cpID = [notification.userInfo objectForKey:@"NextCpID"];
    if ([cpID isEqualToString:self.checkPointModel.cpID])
    {
        __weak HSCheckPointCollectionCell *weakSelf = self;
        [self loadCheckPointProgressWithUserID:kUserID lessonID:self.checkPointModel.lID checkPointID:cpID completion:^(BOOL finished, BOOL progressExit, NSInteger statu) {
            // 刷新关卡信息和状态
            [weakSelf refreshCheckPointInfoAndStatu:statu];
        }];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.clipsToBounds = NO;

    titleWidth = self.lblTitle.width;
    [self layoutTitleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutTitleLabel];
}

- (void)setCheckPointModel:(CheckPointModel *)checkPointModel
{
    _checkPointModel = checkPointModel;
    _index = checkPointModel.indexValue;
    LiveCourseCheckPointType type = checkPointModel.checkPointTypeValue;
    tCheckPointName = checkPointModel.tName;
    [self loadCheckPointStatuImagesWithType:type];
    
    NSString *cpID = [checkPointModel.cpID copy];
    NSString *lID = [checkPointModel.lID copy];
    
    __weak HSCheckPointCollectionCell *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.lblTitle.text  = _checkPointModel.tName;
            [weakSelf layoutTitleLabel];
            
            [weakSelf loadCheckPointProgressWithUserID:kUserID lessonID:lID checkPointID:cpID completion:^(BOOL finished, BOOL progressExit, NSInteger statu) {
                // 根据状态刷新图标:0:锁定；1:解锁；2:完成
                //DLog(@"状态: %d", statu);
                [weakSelf refreshCheckPointInfoAndStatu:statu];
            }];
        });
    });
}

- (void)loadCheckPointStatuImagesWithType:(LiveCourseCheckPointType)type
{
    switch (type)
    {
        case LiveCourseCheckPointTypeWord:
        {
            imgLocked = ImageNamed(@"img_checkPoint_word_locked");
            imgUnLocked = ImageNamed(@"img_checkPoint_word_unlock");
            imgFinished = ImageNamed(@"img_checkPoint_word_finished");
            break;
        }
        case LiveCourseCheckPointTypeSentence:
        {
            imgLocked = ImageNamed(@"img_checkPoint_sentence_locked");
            imgUnLocked = ImageNamed(@"img_checkPoint_sentence_unlock");
            imgFinished = ImageNamed(@"img_checkPoint_sentence_finished");
            break;
        }
        case LiveCourseCheckPointTypeLesson:
        {
            imgLocked = ImageNamed(@"img_checkPoint_text_locked");
            imgUnLocked = ImageNamed(@"img_checkPoint_text_unlock");
            imgFinished = ImageNamed(@"img_checkPoint_text_finished");
            break;
        }
        case LiveCourseCheckPointTypeKnowledge:
        {
            imgLocked = ImageNamed(@"img_checkPoint_knowledge_locked");
            imgUnLocked = ImageNamed(@"img_checkPoint_knowledge_unlock");
            imgFinished = ImageNamed(@"img_checkPoint_knowledge_finished");
            break;
        }
        case LiveCourseCheckPointTypeTest:
        {
            imgLocked = ImageNamed(@"img_checkPoint_exam_locked");
            imgUnLocked = ImageNamed(@"img_checkPoint_exam_unlock");
            imgFinished = ImageNamed(@"img_checkPoint_exam_finished");
            break;
        }
            
        default:
            break;
    }
}

- (void)loadCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID completion:(void (^)(BOOL finished, BOOL progressExit, NSInteger statu))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CheckPointProgressModel *cpProgress = [HSCheckPointHandle checkPointLearnedInfoWithUserID:uID lessonID:lID checkPointID:cpID];
        
        if (self.checkPointModel.indexValue == 1 && !cpProgress)
        {
            [HSCheckPointHandle createCheckPointLearnedInfoWithUserID:uID lessonID:lID checkPointID:cpID status:CheckPointLearnedStatusUnLocked version:nil completion:^(BOOL finished, id obj, NSError * error) {
    
                BOOL exit = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(YES, exit, CheckPointLearnedStatusUnLocked);
                    }
                });
            }];
        }
        else
        {
            CGFloat tmpStatus = cpProgress.statusValue;
            BOOL exit = cpProgress ? YES : NO;
            CheckPointLearnedStatus tStatus = exit ? tmpStatus:CheckPointLearnedStatusLocked;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion) {
                    completion(YES, exit, tStatus);
                }
            });
        }
    });
}

- (void)requestPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID completion:(void (^)(BOOL finished, BOOL progressExit, NSInteger statu))completion
{
    __weak HSCheckPointCollectionCell *weakSelf = self;
    [self.cpNet requestCheckPointSynchronousProgressDataWithUserID:uID lessonID:lID records:@"" completion:^(BOOL finished, id obj, NSError *error) {
        [weakSelf loadCheckPointProgressWithUserID:uID lessonID:lID checkPointID:cpID completion:^(BOOL finished, BOOL progressExit, NSInteger statu) {
            [weakSelf refreshCheckPointInfoAndStatu:statu];
        }];
    }];
}

#pragma mark - 手势
- (UILongPressGestureRecognizer *)longPress
{
    if (!_longPress)
    {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        _longPress.delegate = self;
    }
    return _longPress;
}

#pragma mark - 操作
- (void)longPressAction:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        // 只在begin的时候加载这个框框。
        case UIGestureRecognizerStateBegan:
        {
            if (self.isDownloaded)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocal(@"清除缓存") message:tCheckPointName delegate:self cancelButtonTitle:MyLocal(@"取消") otherButtonTitles:MyLocal(@"确定"), nil];
                [alert show];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 刷新管理
- (void)refreshCheckPointProgress
{
    __weak HSCheckPointCollectionCell *weakSelf = self;
    [self loadCheckPointProgressWithUserID:kUserID lessonID:self.checkPointModel.lID checkPointID:self.checkPointModel.cpID completion:^(BOOL finished, BOOL progressExit, NSInteger statu) {
        // 根据状态刷新图标:0:锁定；1:解锁；2:完成
        //DLog(@"状态: %d", statu);
        [weakSelf refreshCheckPointInfoAndStatu:statu];
    }];
}

- (void)refreshCheckPointInfoAndStatu:(NSInteger)aStatu
{
    UIImage *imgStatu = imgLocked;
    switch (aStatu)
    {
        case CheckPointLearnedStatusLocked:
        {
            _isUnLocked = NO;
            imgStatu = imgLocked;
            self.lblTitle.textColor = [UIColor darkGrayColor];
            break;
        }
        case CheckPointLearnedStatusUnLocked:
        {
            _isUnLocked = YES;
            imgStatu = imgUnLocked;
            self.lblTitle.textColor = kColorBlack;
            break;
        }
        case CheckPointLearnedStatusFinished:
        {
            _isUnLocked = YES;
            imgStatu = imgFinished;
            self.lblTitle.textColor = kColorBlack;
            break;
        }
            
        default:
            _isUnLocked = YES;
            break;
    }

    self.imgvLockedStatu.image = imgStatu;
    status = aStatu;
    
    [self layoutCheckPointLinkWithIndex:self.index];
}

#pragma mark - 布局
- (void)relayoutCheckPointLink
{
    [self layoutCheckPointLinkWithIndex:self.index];
}

// 刷新布局
- (void)layoutTitleLabel
{
    self.lblTitle.width = self.width;
    [self.lblTitle sizeToFit];
    self.lblTitle.centerX = self.width*0.5f;
    self.lblTitle.top = self.imgvLockedStatu.bottom + 2;
    _height = self.lblTitle.bottom;
}

- (void)layoutCheckPointLinkWithIndex:(NSInteger)index
{
    if (index)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            HSCollectionViewCheckPointLayout *layout = ((HSCollectionViewCheckPointLayout *)self.parentView.collectionViewLayout);
            NSInteger numOfElements = layout.numberOfElements;
            // 是水平的还是竖的。
            NSInteger flat = index % numOfElements;

            dispatch_async(dispatch_get_main_queue(), ^{
                if (!flat)
                {
                    @autoreleasepool
                    {
                        CGFloat width = imgHLink_S.size.width;
                        CGFloat height = imgHLink_S.size.height;
                        
                        NSIndexPath *curIndexPath = [self.parentView indexPathForCell:self];
                        NSInteger preItem = curIndexPath.item-1 > 0 ? curIndexPath.item - 1:0;
                        
                        NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:preItem inSection:curIndexPath.section];
                        
                        HSCheckPointCollectionCell *preCell = (HSCheckPointCollectionCell *)[self.parentView cellForItemAtIndexPath:preIndexPath];
                        
                        //DLog(@"自己的顶端: %f, cell的顶端: %f, 上一个的item: %d, 上一个的index: %d, 自己的item: %d, 自己的index: %d", self.top, preCell.top, preItem, preCell.index, curIndexPath.item, index);
                        if (self.center.y > preCell.center.y && preCell.top > 0) {
                            height = self.top - (preCell.top + preCell.height);
                        }
                        
                        self.imgvLink.bounds = CGRectMake(0, 0, width, height);
                        self.imgvLink.center = CGPointMake(self.width*0.5, -height*0.5);
                        
                        // 拐角的关卡,其link需要往上。
                        if (_isUnLocked){
                            self.imgvLink.image = imgHLink_S;
                        }else{
                            self.imgvLink.image = imgLink_S;
                        }
                    }
                }
                else
                {
                    @autoreleasepool
                    {
                        CGFloat totalWidth = self.parentView.width-layout.sectionInset.left-layout.sectionInset.right - numOfElements * (layout.itemSize.width);
                        
                        // 其他的都是平直的。
                        CGFloat width = totalWidth / (numOfElements - 1) + _imgvLockedStatu.left-1;//imgHLink.size.width;
                        CGFloat height = imgHLink.size.height;
                        
                        self.imgvLink.bounds = CGRectMake(0, 0, width, height);
                        
                        if (_isUnLocked){
                            self.imgvLink.image = [imgHLink resizableImageWithCapInsets:UIEdgeInsetsMake(5, 8, 5, 8) resizingMode:UIImageResizingModeStretch];
                        }else{
                            self.imgvLink.image = imgLink;
                        }
                        
                        NSInteger curLine = index / numOfElements + 1;
                        
                        if (curLine % 2 == 0){
                            self.imgvLink.center = CGPointMake(_imgvLockedStatu.right + width*0.5, _imgvLockedStatu.centerY);
                        }else{
                            self.imgvLink.center = CGPointMake(_imgvLockedStatu.left - width*0.5, _imgvLockedStatu.centerY);
                        }
                    }
                }
                
                self.imgvLink.alpha = 1;
            });
        });
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        NSString *lessonDir = [NSString stringWithFormat:@"%@", self.checkPointModel.cpID];
        NSString *dataDir = [kDownloadedPath stringByAppendingPathComponent:lessonDir];
        [[NSFileManager defaultManager] removeItemAtPath:dataDir error:nil];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    shouldShowProgress = NO;
    _isUnLocked = NO;
    self.imgvLink.alpha = 0;
}

@end
