//
//  HSCollectionViewCheckPointLayout.h
//  HSWordsPass
//
//  Created by yang on 14/11/13.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCollectionViewCheckPointLayoutAttributes.h"

@class HSCollectionViewCheckPointLayout;

@protocol HSCollectionViewCheckPointLayoutDelegate <NSObject>

@optional
/**
 *  判断在某一行关卡排列的方向。
 *   -- 是从右向左还是从左向右。
 *
 *  @param collectionView
 *  @param collectionViewLayout
 *  @param line                 某一行，相当于tableview的cell。
 *  @param indexPath            某一个item。
 *
 *  @return 方向
 */
- (HSCollectionViewCheckPointLayoutFlowDirection)collectionView:(UICollectionView *)collectionView layout:(HSCollectionViewCheckPointLayout *)collectionViewLayout checkPointDirectionForLine:(NSInteger)line atIndexPath:(NSIndexPath *)indexPath;

@end

@interface HSCollectionViewCheckPointLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<HSCollectionViewCheckPointLayoutDelegate> delegate;
@property (nonatomic, assign) NSUInteger numberOfElements; // Number to be grouped cells. Default: 3

- (NSInteger)currentLineAtIndexPath:(NSIndexPath *)indexPath;

@end
