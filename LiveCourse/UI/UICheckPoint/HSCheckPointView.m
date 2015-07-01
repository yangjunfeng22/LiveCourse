//
//  HSCheckPointView.m
//  HSWordsPass
//
//  Created by yang on 14-9-3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCheckPointView.h"
#import "HSCheckPointCollectionCell.h"
#import "HSCheckPointCollectionView.h"
#import "HSCollectionViewCheckPointLayout.h"
#import "MessageHelper.h"
#import "UIView+Additions.h"
#import "HSCheckPointHandle.h"

#import "CheckPointModel.h"
#import "CheckPointNet.h"
#import "HSUIAnimateHelper.h"

#define kPointLeft 30.0f
#define kPointTop 20.0f
#define kPointDistance 36.25f
#define kPointCountPerRow 3

#define kCellTopEdge 5
#define kCellLeftEdge 10
#define kCellBottomEdge 5
#define kCellRightEdge 10

#define kItemWidth 81
#define kItemHeight 63

#define kMinimumLineSpacing 36.0f
#define kMinimumInteritemSpacing 16.0f

@interface HSCheckPointView ()<UICollectionViewDataSource, UICollectionViewDelegate, HSCollectionViewCheckPointLayoutDelegate>
{
    BOOL isScrolled;
    NSInteger curCpTag;
    NSInteger totalCount;
    NSInteger totalRow;
    NSInteger itemCountPerRow;
    NSInteger oldLine;
    NSInteger oldGroup;
    CGFloat itemWidth;
    CGFloat itemHeight;
    
    UIImage *imgUnLocked;
    UIImage *imgLocked;
    UIImage *imgCpLink;
    
}

@property (nonatomic, strong) NSMutableArray *arrCheckPoint;
@property (nonatomic, strong) NSMutableDictionary *dicLineHeight;
@property (nonatomic, strong) HSCheckPointCollectionView *colvCheckPoint;
@property (nonatomic, strong) CheckPointNet *cpNet;


@end

@implementation HSCheckPointView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kColorWhite;

        isScrolled = NO;
        totalCount = 0;
        oldLine    = 0;
        itemWidth  = kItemWidth * (kiPhone ? 1:1.5);
        itemHeight = kItemHeight * (kiPhone ? 1:1.5);
        
        itemCountPerRow = (self.width - 2*kCellLeftEdge)/(itemWidth+kMinimumInteritemSpacing);
        
        [self.colvCheckPoint registerClass:[HSCheckPointCollectionCell class] forCellWithReuseIdentifier:@"CheckPointCollectionCell"];
        //self.colvCheckPoint.userInteractionEnabled = NO;
        
        // 同步进度
        [self requestPointProgress];
    }
    return self;
}

+ (HSCheckPointView *)instance
{
    NSArray *pointViews = [[NSBundle mainBundle] loadNibNamed:@"HSCheckPointView" owner:nil options:nil];
    return [pointViews lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = kColorWhite;
        
        isScrolled = NO;
        totalCount = 0;
        // 同步进度
        [self requestPointProgress];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)arrCheckPoint
{
    if (!_arrCheckPoint)
    {
        _arrCheckPoint = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _arrCheckPoint;
}

- (NSMutableDictionary *)dicLineHeight
{
    if (!_dicLineHeight)
    {
        _dicLineHeight = [[NSMutableDictionary alloc] init];
    }
    return _dicLineHeight;
}

- (HSCheckPointCollectionView *)colvCheckPoint
{
    if (!_colvCheckPoint)
    {
        HSCollectionViewCheckPointLayout *checkPointLayout = [[HSCollectionViewCheckPointLayout alloc] init];
        checkPointLayout.delegate = self;
        checkPointLayout.numberOfElements = itemCountPerRow;
        checkPointLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        // 头上到边框的距离。
        checkPointLayout.headerReferenceSize = CGSizeMake(self.width, kMinimumInteritemSpacing*0.5);
        checkPointLayout.minimumLineSpacing = kMinimumLineSpacing;
        checkPointLayout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        
        _colvCheckPoint = [[HSCheckPointCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:checkPointLayout];
        _colvCheckPoint.dataSource = self;
        _colvCheckPoint.delegate = self;
        _colvCheckPoint.backgroundColor = kColorWhite;
        _colvCheckPoint.alwaysBounceVertical = YES;
        _colvCheckPoint.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_colvCheckPoint];
    }
    return _colvCheckPoint;
}

- (CheckPointNet *)cpNet
{
    if (!_cpNet)
    {
        _cpNet = [[CheckPointNet alloc] init];
    }
    return _cpNet;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

/*
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkPointView:selectCheckPoint:nexCheckPoint:)]){
        [self.delegate checkPointView:self selectCheckPoint:nil nexCheckPoint:nil];
    }
}
 */

- (void)requestPointProgress
{
    __weak HSCheckPointView *weakSelf = self;
    [self.cpNet requestCheckPointSynchronousProgressDataWithUserID:kUserID lessonID:HSAppDelegate.curLID records:@"" completion:^(BOOL finished, id obj, NSError *error) {
        //刷新数据
        [weakSelf refreshVisibleCheckPointProgress];
    }];
}

#pragma mark - 刷新UI
- (void)refreshCheckPointWithData:(id)data
{
    isScrolled = NO;
    
    if (data && [data isKindOfClass:[NSArray class]] && [data count] > 0) {
        [self.arrCheckPoint setArray:data];
    }
    totalCount = [self.arrCheckPoint count];
    //DLog(@"关卡数: %ld", totalCount);
    totalRow = totalCount/itemCountPerRow + (totalCount % itemCountPerRow == 0 ? 0:1);
    
    NSInteger lineIndex = 1;
    CGFloat maxLineHeight = itemHeight;
    NSInteger index = 0;
    
    for (CheckPointModel *checkPoint in self.arrCheckPoint)
    {
        NSInteger curLineIndex = index / itemCountPerRow + 1;
        
        if (lineIndex != curLineIndex || lineIndex == totalRow)
        {
            //DLog(@"旧的那一行: %d, 新的那一行: %d, 总得高度: %f", lineIndex, curLineIndex, maxLineHeight);
            // 如果换行了,先将旧的那行的最大值保存一下。
            NSNumber *numLine = [NSNumber numberWithInteger:lineIndex];
            NSNumber *numLineHeight = [NSNumber numberWithFloat:maxLineHeight];
            [self.dicLineHeight setObject:numLineHeight forKey:numLine];
            // 然后将这个最大值初始化一下
            lineIndex = curLineIndex;
            maxLineHeight = itemHeight;
        }
        
        CGSize size = [[checkPoint.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(itemWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat newHeight = itemHeight + size.height;
        maxLineHeight = newHeight > maxLineHeight ? newHeight:maxLineHeight;
        
        index++;
    }

    [self.colvCheckPoint reloadData];
}

- (void)relayoutVisibleCheckPoint
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *arrCell = [self.colvCheckPoint visibleCells];
            for (HSCheckPointCollectionCell *cell in arrCell){
                [cell relayoutCheckPointLink];
            }
        });
    });
}

- (void)refreshVisibleCheckPointProgress
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *arrCell = [self.colvCheckPoint visibleCells];
            for (HSCheckPointCollectionCell *cell in arrCell){
                [cell refreshCheckPointProgress];
            }
        });
    });
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isScrolled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self relayoutVisibleCheckPoint];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    isScrolled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self relayoutVisibleCheckPoint];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self relayoutVisibleCheckPoint];
    }
}

#pragma mark - UICollectionView DataSource/Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSCheckPointCollectionCell *cell = (HSCheckPointCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CheckPointCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = kColorClear;
    NSInteger index = [indexPath item];
    cell.checkPointModel = self.arrCheckPoint[index];
    cell.index = index;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSCheckPointCollectionCell *cell = (HSCheckPointCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isUnLocked)
    {
        NSInteger index = [indexPath item];
        CheckPointModel *checkPoint = [self.arrCheckPoint objectAtIndex:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkPointView:selectCheckPoint:)]){
            [self.delegate checkPointView:self selectCheckPoint:checkPoint];
        }
        /*
        NSString *cpID = [[NSString alloc] initWithFormat:@"%@", checkPoint.cpID];
        NSString *nexCpID = [[NSString alloc] initWithFormat:@"%@", checkPoint.nexCpID];
        
        DLog(@"选择的关卡: name:%@, type: %d", checkPoint.name, checkPoint.typeValue);
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkPointView:selectCheckPoint:nexCheckPoint:currentCheckPointType:)]){
            [self.delegate checkPointView:self selectCheckPoint:cpID nexCheckPoint:nexCpID currentCheckPointType:checkPoint.typeValue];
        }
         */
    }
    else
    {
        [HSUIAnimateHelper popUpAnimationWithView:cell.imgvLockedStatu];
    }
}

#pragma mark - CollectionViewVunityLayoutDelegate
- (HSCollectionViewCheckPointLayoutFlowDirection)collectionView:(UICollectionView *)collectionView layout:(HSCollectionViewCheckPointLayout *)collectionViewLayout checkPointDirectionForLine:(NSInteger)line atIndexPath:(NSIndexPath *)indexPath
{
    HSCollectionViewCheckPointLayoutFlowDirection direction;
    
    if (line % 2) {
        direction = HSCollectionViewCheckPointLayoutFlowDirectionLeft;
    } else {
        direction = HSCollectionViewCheckPointLayoutFlowDirectionRight;
    }
    
    return direction;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {kCellTopEdge, kCellLeftEdge, kCellBottomEdge, kCellRightEdge};
    return top;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger curLine = indexPath.item / itemCountPerRow + 1;
    NSNumber *numLine = [NSNumber numberWithInteger:curLine];
    CGFloat lineHeight = [[self.dicLineHeight objectForKey:numLine] floatValue];
    lineHeight = lineHeight > 0 ? lineHeight:itemHeight;
    CGSize itemSize = {itemWidth, lineHeight};
    return itemSize;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    kRemoveObserverNotification(self, nil, nil);
    
    imgLocked = nil;
    imgUnLocked = nil;
    imgCpLink = nil;
   
}

@end
