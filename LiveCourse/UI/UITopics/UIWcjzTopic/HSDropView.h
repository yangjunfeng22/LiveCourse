//
//  HSDropView.h
//  HelloHSK
//
//  Created by yang on 14-3-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HSDropViewDelegate;

@interface HSDropView : UIView

@property (weak, nonatomic)id<HSDropViewDelegate>delegate;
@property (copy, nonatomic)NSMutableArray *arrDropLabel;

- (void)addDragLabelWithText:(NSString *)text;

- (void)addDragLabelWithText:(NSString *)text fromCenter:(CGPoint)center;


@end

@protocol  HSDropViewDelegate <NSObject>

@optional
- (void)dropView:(HSDropView *)view clicked:(id)sender;
- (void)dropView:(HSDropView *)view selectedText:(NSString *)text;
- (void)dropView:(HSDropView *)view selectedText:(NSString *)text center:(CGPoint)center;

@end