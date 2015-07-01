//
//  HSDragView.h
//  HelloHSK
//
//  Created by yang on 14-3-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  HSDragViewDelegate;

@interface HSDragView : UIView

@property (weak, nonatomic)id<HSDragViewDelegate>delegate;
@property (readwrite, nonatomic)NSInteger type;
@property (copy, nonatomic)NSMutableArray *arrDragLabel;
@property (assign, nonatomic)BOOL showAnswer;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, readonly) CGFloat totalHeight;


- (void)reShowDragLabelWithText:(NSString *)text;

- (void)reShowDragLabelWithText:(NSString *)text fromCenter:(CGPoint)center;

@end

@protocol  HSDragViewDelegate <NSObject>

@optional
- (void)dragView:(HSDragView *)view clicked:(id)sender;
- (void)dragView:(HSDragView *)view selectedText:(NSString *)text;

@end
