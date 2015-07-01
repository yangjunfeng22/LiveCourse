//
//  CircleView.h
//  Popping
//
//  Created by André Schneider on 21.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property(nonatomic) UIColor *strokeColor;
@property(nonatomic) UIColor *backgroundCircleColor;
@property(nonatomic) CGFloat lineWidth;
@property(nonatomic) BOOL alwaysShowProgress;

- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;
- (void)setAnimatedStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration;
- (void)setAnimatedStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration delay:(CGFloat)delay;
- (void)setAnimatedDefaultStartStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration delay:(CGFloat)delay;
- (void)setAnimatedStrokeEnd:(CGFloat)strokeEnd from:(CGFloat)strokeFrom duration:(CGFloat)duration delay:(CGFloat)delay;

- (void)cleanAnimation;

@end
