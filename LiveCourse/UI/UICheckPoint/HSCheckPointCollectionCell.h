//
//  HSCheckPointCollectionCell.h
//  HSWordsPass
//
//  Created by yang on 14/11/7.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckPointModel;


@interface HSCheckPointCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgvLockedStatu;
@property (weak, nonatomic) IBOutlet UILabel *lblIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic) CheckPointModel *checkPointModel;

@property (nonatomic) NSInteger index;
@property (readonly) BOOL isUnLocked;
@property (readonly) CGFloat height;
@property (strong, nonatomic) UIImageView *imgvLink;

- (void)relayoutCheckPointLink;
- (void)refreshCheckPointProgress;

@end
