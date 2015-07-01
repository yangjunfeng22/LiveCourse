//
//  HSCollectionViewCheckPointLayout.m
//  HSWordsPass
//
//  Created by yang on 14/11/13.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCollectionViewCheckPointLayout.h"
#import "HSCheckPointCollectionCell.h"
#import "HSCheckPointCollectionView.h"

static NSString *const HSCollectionViewCheckPointCellKind = @"HSCollectionViewCheckPointCellKind";

@interface HSCollectionViewCheckPointLayout ()
@property (nonatomic, strong) NSDictionary *layoutInfo;

@property (nonatomic, assign) HSCollectionViewCheckPointLayoutFlowDirection checkPointLineDirection;

@end

@implementation HSCollectionViewCheckPointLayout

#pragma mark - Lifecycle
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Custom Getter
- (NSInteger)numberOfSections
{
    return [self.collectionView numberOfSections];
}

#pragma mark - Setup
- (void)setup
{
    // Default values
    self.numberOfElements = 3;
}

#pragma mark - UICollectionViewLayout
+ (Class)layoutAttributesClass
{
    return [HSCollectionViewCheckPointLayoutAttributes class];
}

- (CGSize)collectionViewContentSize
{
    return [super collectionViewContentSize];
}

#pragma mark - Private Methods

- (void)prepareLayout
{
    [super prepareLayout];
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    NSArray *arrSuper = [super layoutAttributesForElementsInRect:rect];
    for (HSCollectionViewCheckPointLayoutAttributes *attribute in arrSuper)
    {
        
        //DLog(@"中点x : %f; itemWidth: %f", attribute.center.x, self.itemSize.width);
        NSIndexPath *indexPath = attribute.indexPath;
        NSInteger curLine = [self currentLineAtIndexPath:indexPath];
        if (curLine % 2 == 0)
        {
            // 偶数行是从右往左的。
            CGPoint center = attribute.center;
            attribute.center = CGPointMake(width-center.x, center.y);
        }
    }
    return arrSuper;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    //DLog(@"属性: %@", attributes);
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - Line
- (NSInteger)currentLineAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.row + 1;
    
    NSInteger resultValue = item / self.numberOfElements;
    
    NSUInteger mod = item % self.numberOfElements;
    if (mod > 0) {
        resultValue += 1;
    }
    
    return resultValue;
}

- (NSInteger)totalLinesAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    
    if (itemsCount <= self.numberOfElements) {
        return 1;
    }
    
    NSInteger resultValue = itemsCount / self.numberOfElements;
    
    NSUInteger mod = itemsCount % self.numberOfElements;
    if (mod > 0) {
        resultValue += 1;
    }
    
    return resultValue;
}

- (NSInteger)totalGroupsInCollectionView
{
    NSInteger totalGroups = 0;
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        totalGroups += [self totalLinesAtIndexPath:indexPath];
    }
    
    return totalGroups;
}

- (NSInteger)itemCountAtSection:(NSInteger)section
{
    return [[self collectionView] numberOfItemsInSection:section];
}

- (BOOL)isTheLastItemAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.row + 1) == [self itemCountAtSection:indexPath.section]) {
        return YES;
    }
    
    return NO;
}

@end
