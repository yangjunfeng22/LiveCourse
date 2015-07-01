//
//  CircleView.m
//  Popping
//
//  Created by André Schneider on 21.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "CircleView.h"
#import <POP/POP.h>

@interface CircleView()<POPAnimationDelegate>
@property(nonatomic) CAShapeLayer *circleLayer;
@property(nonatomic) CAShapeLayer *backLayer;

- (void)addCircleLayer;
- (void)animateToStrokeEnd:(CGFloat)strokeEnd;
- (void)animateToStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration;
- (void)animateToStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration delay:(CGFloat)delay;

@end

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(frame.size.width == frame.size.height, @"A circle must have the same height and width.");
        _alwaysShowProgress = NO;
        [self addCircleLayer];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated
{
    if (animated) {
        [self animateToStrokeEnd:strokeEnd];
        return;
    }
    self.circleLayer.strokeEnd = strokeEnd;
}

- (void)setAnimatedStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration
{
    [self animateToStrokeEnd:strokeEnd duration:duration];
}

- (void)setAnimatedStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration delay:(CGFloat)delay
{
    [self animateToStrokeEnd:strokeEnd duration:duration delay:delay];
}

- (void)cleanAnimation
{
    if (_circleLayer)
    {
        [_circleLayer pop_removeAllAnimations];
        [_circleLayer removeFromSuperlayer];
        _circleLayer = nil;
    }
}

#pragma mark - Property Setters

- (void)setStrokeColor:(UIColor *)strokeColor
{
    self.circleLayer.strokeColor = strokeColor.CGColor;
    _strokeColor = strokeColor;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.circleLayer.lineWidth = lineWidth;
    self.backLayer.lineWidth = lineWidth;
}

- (void)setBackgroundCircleColor:(UIColor *)backgroundCircleColor
{
    _backgroundCircleColor = backgroundCircleColor;
    self.backLayer.strokeColor = backgroundCircleColor.CGColor;
}

- (CAShapeLayer *)circleLayer
{
    if (!_circleLayer)
    {
        CGFloat lineWidth = 2.f;
        CGFloat radius = CGRectGetWidth(self.bounds)/2 - lineWidth/2;
        CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius * 2, radius * 2);
        
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
        
        _circleLayer.fillColor = nil;
        _circleLayer.lineWidth = lineWidth;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_circleLayer];
    }
    _circleLayer.hidden = NO;
    _circleLayer.lineWidth = self.lineWidth;
    _circleLayer.strokeColor = self.strokeColor ? self.strokeColor.CGColor:(kiOS7_OR_LATER ? self.tintColor.CGColor:[UIColor whiteColor].CGColor);
    return _circleLayer;
}

- (CAShapeLayer *)backLayer
{
    if (!_backLayer)
    {
        CGFloat lineWidth = 2.f;
        CGFloat radius = CGRectGetWidth(self.bounds)/2 - lineWidth/2;
        CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius * 2, radius * 2);
        
        _backLayer = [CAShapeLayer layer];
        _backLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                       cornerRadius:radius].CGPath;
        
        _backLayer.strokeColor = self.backgroundCircleColor.CGColor;
        _backLayer.fillColor = nil;
        _backLayer.lineWidth = lineWidth;
        _backLayer.lineCap = kCALineCapRound;
        _backLayer.lineJoin = kCALineJoinRound;
        [self.layer insertSublayer:_backLayer below:self.circleLayer];
    }
    return _backLayer;
}

#pragma mark - Private Instance methods

- (void)addCircleLayer
{
    self.backLayer.strokeColor = self.backgroundCircleColor ? self.backgroundCircleColor.CGColor:self.backgroundColor.CGColor;
    
}

- (void)animateToStrokeEnd:(CGFloat)strokeEnd
{
    [self animateToStrokeEnd:strokeEnd duration:0.3f delay:0];
}

- (void)animateToStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration
{
    [self animateToStrokeEnd:strokeEnd duration:duration delay:0];
}

- (void)animateToStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration delay:(CGFloat)delay
{
    POPBasicAnimation *strokeAnimation = [self.circleLayer pop_animationForKey:@"layerStrokeAnimation"];
    if (strokeAnimation)
    {
        strokeAnimation.fromValue = @(0);
        strokeAnimation.beginTime = CACurrentMediaTime()+delay;
        strokeAnimation.toValue = @(strokeEnd);
        strokeAnimation.duration = duration;
        strokeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (!_alwaysShowProgress)
            {
                [self cleanAnimation];
            }
        };
    }
    else
    {
        strokeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        strokeAnimation.fromValue = @(0);
        strokeAnimation.beginTime = CACurrentMediaTime()+delay;
        strokeAnimation.toValue = @(strokeEnd);
        strokeAnimation.duration = duration;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        strokeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (!_alwaysShowProgress)
            {
                [self cleanAnimation];
            }
        };
        [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
    }
    
}

- (void)animateToStrokeEnd:(CGFloat)strokeEnd start:(CGFloat)strokeStart duration:(CGFloat)duration delay:(CGFloat)delay
{
    POPBasicAnimation *strokeAnimation = [self.circleLayer pop_animationForKey:@"layerStrokeAnimation"];
    if (strokeAnimation)
    {
        strokeAnimation.fromValue = @(strokeStart);
        strokeAnimation.beginTime = CACurrentMediaTime()+delay;
        strokeAnimation.toValue = @(strokeEnd);
        strokeAnimation.duration = duration;
        strokeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (!_alwaysShowProgress)
            {
                [self cleanAnimation];
            }
        };
    }
    else
    {
        strokeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        strokeAnimation.fromValue = @(strokeStart);
        strokeAnimation.beginTime = CACurrentMediaTime()+delay;
        strokeAnimation.toValue = @(strokeEnd);
        strokeAnimation.duration = duration;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        strokeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (!_alwaysShowProgress)
            {
                [self cleanAnimation];
            }
        };
        [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
    }
}

- (void)setAnimatedStrokeEnd:(CGFloat)strokeEnd from:(CGFloat)strokeFrom duration:(CGFloat)duration delay:(CGFloat)delay
{
    [self animateToStrokeEnd:strokeEnd start:strokeFrom duration:duration delay:delay];
}

- (void)setAnimatedDefaultStartStrokeEnd:(CGFloat)strokeEnd duration:(CGFloat)duration delay:(CGFloat)delay
{
    POPBasicAnimation *strokeAnimation = [self.circleLayer pop_animationForKey:@"layerStrokeAnimation"];
    if (strokeAnimation)
    {
        strokeAnimation.beginTime = CACurrentMediaTime()+delay;
        strokeAnimation.toValue = @(strokeEnd);
        strokeAnimation.duration = duration;
        strokeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (!_alwaysShowProgress)
            {
                [self cleanAnimation];
            }
        };
    }
    else
    {
        strokeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        strokeAnimation.beginTime = CACurrentMediaTime()+delay;
        strokeAnimation.toValue = @(strokeEnd);
        strokeAnimation.duration = duration;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        strokeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (!_alwaysShowProgress)
            {
                [self cleanAnimation];
            }
        };
        [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
    }
}

@end
