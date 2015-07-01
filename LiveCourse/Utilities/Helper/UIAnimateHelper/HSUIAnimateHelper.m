//
//  HSUIAnimateHelper.m
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSUIAnimateHelper.h"

#import <pop/POP.h>

// 将角度转换为弧度
#define DEGREES_TO_RADIANS(d)  ((d) * M_PI / 180.f)

void (^animationCompletion)(BOOL finished);

@interface HSUIAnimateHelper ()

@end

@implementation HSUIAnimateHelper

+ (CATransition *)pushInFromLeftOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    return animation;
}

+ (CATransition *)pushInFromRightOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    return animation;
}

+ (CATransition *)pushInFromBottomOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.2];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animation;
}

+ (CATransition *)moveInFromTopOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

+ (CATransition *)moveInFromBottomOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

+ (CATransition *)moveOutFromBottomOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35];
    [animation setType: kCATransitionReveal];
    [animation setSubtype: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

#pragma mark -
+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView completion:(void (^)(BOOL))completion
{
    [self transitionFromView:fromView toView:toView speed:20 bounciness:12 options:HSUIViewAnimationOptionRotateY completion:completion];
}

+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView speed:(CGFloat)speed bounciness:(CGFloat)bounciness options:(HSUIViewAnimationOptions)options completion:(void (^)(BOOL))completion
{
    
    //fromView.userInteractionEnabled = NO;
    //toView.userInteractionEnabled = NO;
    
    //toView.alpha = 0;
    toView.hidden = YES;
    //fromView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0.0, 1.0, 0.0);
    //toView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0.0, 1.0, 0.0);
    // 初始化3D变换,获取默认值
    
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    // 透视
    perspectiveTransform.m34 = -1.0/800.0;
    
    // 空间旋转
    perspectiveTransform = CATransform3DRotate(perspectiveTransform, DEGREES_TO_RADIANS(-90), 0, 1, 0);
    [CATransaction setDisableActions:YES];
    fromView.layer.transform = perspectiveTransform;
    
    // 初始化3D变换,获取默认值
    
    CATransform3D perspectiveTransform2 = CATransform3DIdentity;
    // 透视
    perspectiveTransform2.m34 = -1.0/800.0;
    
    // 空间旋转
    perspectiveTransform2 = CATransform3DRotate(perspectiveTransform2, DEGREES_TO_RADIANS(90), 0, 1, 0);
    [CATransaction setDisableActions:YES];
    toView.layer.transform = perspectiveTransform2;
    
    NSString *propertyName = (options == HSUIViewAnimationOptionRotateX) ? kPOPLayerRotationX:kPOPLayerRotationY;
    // 源view。
    POPSpringAnimation *rotationY = [POPSpringAnimation animationWithPropertyNamed:propertyName];
    rotationY.springBounciness = bounciness;
    rotationY.springSpeed = speed;
    rotationY.dynamicsTension = 500;
    rotationY.dynamicsMass = 1;
    rotationY.fromValue = @(DEGREES_TO_RADIANS(0));
    rotationY.toValue = @(DEGREES_TO_RADIANS(-90));
    rotationY.animationDidReachToValueBlock = ^(POPAnimation *anim)
    {
        //fromView.alpha = 0;
        fromView.hidden = YES;
        POPSpringAnimation *popSpring = (POPSpringAnimation *)anim;
        popSpring.fromValue = @(DEGREES_TO_RADIANS(-90));
        popSpring.toValue = @(DEGREES_TO_RADIANS(0));
    };
    rotationY.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        fromView.layer.transform = CATransform3DIdentity;
        fromView.userInteractionEnabled = YES;
        [fromView.layer pop_removeAnimationForKey:@"frontLayerAnimation"];
    };
    [fromView.layer pop_addAnimation:rotationY forKey:@"frontLayerAnimation"];
    
    // 目标view。
    POPSpringAnimation *rotationY2 = [POPSpringAnimation animationWithPropertyNamed:propertyName];
    rotationY2.springBounciness = bounciness;
    rotationY2.springSpeed = speed;
    rotationY2.dynamicsTension = 500;
    rotationY2.dynamicsMass = 1;
    rotationY2.fromValue = @(DEGREES_TO_RADIANS(0));
    rotationY2.toValue = @(DEGREES_TO_RADIANS(90));
    rotationY2.animationDidReachToValueBlock = ^(POPAnimation *anim)
    {
        //toView.alpha = 1;
        toView.hidden = NO;
        
        POPSpringAnimation *popSpring = (POPSpringAnimation *)anim;
        popSpring.fromValue = @(DEGREES_TO_RADIANS(90));
        popSpring.toValue = @(DEGREES_TO_RADIANS(0));
    };
    
    rotationY2.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        toView.layer.transform = CATransform3DIdentity;
        toView.userInteractionEnabled = YES;
        [toView.layer pop_removeAnimationForKey:@"backLayerAnimation"];
        if (completion) {
            completion(finished);
        }
    };
    [toView.layer pop_addAnimation:rotationY2 forKey:@"backLayerAnimation"];
}

+ (void)popUpAnimationWithView:(UIView *)view
{
    [view pop_removeAllAnimations];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.springBounciness = 16;
    anim.springSpeed = 20;
    anim.removedOnCompletion = YES;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.1, 1.1)];
    anim.animationDidReachToValueBlock = ^(POPAnimation *anim){
        POPSpringAnimation *popSpring = (POPSpringAnimation *)anim;
        popSpring.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    };
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.3;
    opacityAnim.toValue = @1.0;
    
    [view.layer pop_addAnimation:anim forKey:@"AnimationScale"];
    [view.layer pop_addAnimation:opacityAnim forKey:@"AnimateOpacity"];
}

+ (void)scaleAnimationWithView:(UIView *)view scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY
{
    POPSpringAnimation *anim = [view.layer pop_animationForKey:@"ScaleXY"];
    if (anim)
    {
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(scaleX, scaleY)];
    }
    else
    {
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        anim.springBounciness = 8;
        anim.springSpeed = 20;
        //anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(scaleX, scaleY)];
        [view.layer pop_addAnimation:anim forKey:@"ScaleXY"];
    }
    
    POPBasicAnimation *opacityAnim = [view.layer pop_animationForKey:@"Opacity"];
    if (opacityAnim)
    {
        opacityAnim.toValue = @1.0;
    }
    else
    {
        opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        
        opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        opacityAnim.duration = 0.3;
        opacityAnim.toValue = @1.0;
        
        [view.layer pop_addAnimation:opacityAnim forKey:@"Opacity"];
    }
}

+ (void)transitionView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter completion:(void (^)(BOOL finished))completion
{
    [self transitionView:view fromCenter:fCenter toCenter:tCenter duration:0.3f delay:0 completion:completion];
}

+ (void)transitionView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion
{
    [self transitionView:view fromCenter:fCenter toCenter:tCenter duration:duration delay:0 completion:completion];
}

+ (void)transitionView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion
{
    POPBasicAnimation *positionAnim = [view pop_animationForKey:@"changeposition"];
    if (positionAnim)
    {
        positionAnim.beginTime = CACurrentMediaTime()+delay;
        positionAnim.duration = duration;
        positionAnim.fromValue = [NSValue valueWithCGPoint:fCenter];
        positionAnim.toValue   = [NSValue valueWithCGPoint:tCenter];
    }
    else
    {
        positionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        //positionAnim.springBounciness = 2;
        //positionAnim.springSpeed = 20;
        //positionAnim.dynamicsFriction = 80; // 摩擦
        //positionAnim.dynamicsTension = 500; // 张力
        //positionAnim.removedOnCompletion = YES;
        positionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        positionAnim.beginTime = CACurrentMediaTime()+delay;
        positionAnim.duration = duration;
        positionAnim.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (completion) {
                completion(finished);
            }
        };
        positionAnim.fromValue = [NSValue valueWithCGPoint:fCenter];
        positionAnim.toValue   = [NSValue valueWithCGPoint:tCenter];
        [view pop_addAnimation:positionAnim forKey:@"changeposition"];
    }
}

+ (void)springView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter completion:(void (^)(BOOL finished))completion
{
    [self springView:view fromCenter:fCenter toCenter:tCenter duration:0.1f delay:0 bounciness:6 speed:6 completion:completion];
}

+ (void)springView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter duration:(CGFloat)duration delay:(CGFloat)delay bounciness:(CGFloat)bounciness speed:(CGFloat)speed completion:(void (^)(BOOL finished))completion
{
    POPBasicAnimation *positionAnim = [view pop_animationForKey:@"changeposition"];
    if (positionAnim)
    {
        positionAnim.beginTime = CACurrentMediaTime()+delay;
        positionAnim.duration = duration;
        positionAnim.fromValue = [NSValue valueWithCGPoint:fCenter];
        positionAnim.toValue   = [NSValue valueWithCGPoint:tCenter];
    }
    else
    {
        positionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        //positionAnim.dynamicsFriction = 80; // 摩擦
        //positionAnim.dynamicsTension = 500; // 张力
        //positionAnim.removedOnCompletion = YES;
        positionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        positionAnim.beginTime = CACurrentMediaTime()+delay;
        positionAnim.duration = duration;
        positionAnim.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (completion) {
                completion(finished);
            }
        };
        positionAnim.fromValue = [NSValue valueWithCGPoint:fCenter];
        positionAnim.toValue   = [NSValue valueWithCGPoint:tCenter];
        [view pop_addAnimation:positionAnim forKey:@"changeposition"];
    }
    
    
    POPSpringAnimation *springAnim = [view pop_animationForKey:@"changecenter"];
    if (springAnim)
    {
        springAnim.beginTime = CACurrentMediaTime()+delay;
        springAnim.springBounciness = bounciness;
        springAnim.springSpeed = speed;
        springAnim.fromValue = [NSValue valueWithCGPoint:fCenter];
        springAnim.toValue = [NSValue valueWithCGPoint:tCenter];
    }
    else
    {
        springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnim.beginTime = CACurrentMediaTime()+delay;
        springAnim.springBounciness = bounciness;
        springAnim.springSpeed = speed;
        springAnim.fromValue = [NSValue valueWithCGPoint:fCenter];
        springAnim.toValue = [NSValue valueWithCGPoint:tCenter];
        [view pop_addAnimation:springAnim forKey:@"changecenter"];
    }
}

+ (void)transitionView:(UIView *)view fromFrame:(CGRect)fFrame toFrame:(CGRect)tFrame
{
    POPSpringAnimation *positionAnim = [view pop_animationForKey:@"changeframe"];
    if (positionAnim)
    {
        //positionAnim.fromValue = [NSValue valueWithCGRect:fFrame];
        positionAnim.toValue   = [NSValue valueWithCGRect:tFrame];
    }
    else
    {
        positionAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        //positionAnim.dynamicsFriction = 80; // 摩擦
        //positionAnim.dynamicsTension = 500; // 张力
        positionAnim.removedOnCompletion = YES;
        //positionAnim.fromValue = [NSValue valueWithCGRect:fFrame];
        positionAnim.toValue   = [NSValue valueWithCGRect:tFrame];
        [view pop_addAnimation:positionAnim forKey:@"changealpha"];
    }
}

+ (void)transitionView:(UIView *)view fromAlpha:(CGFloat)fAlpha toAlpha:(CGFloat)tAlpha
{
    POPSpringAnimation *positionAnim = [view pop_animationForKey:@"changealpha"];
    if (positionAnim)
    {
        positionAnim.fromValue = @(fAlpha);
        positionAnim.toValue   = @(tAlpha);
    }
    else
    {
        positionAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        positionAnim.springBounciness = 1;
        positionAnim.springSpeed = 20;
        positionAnim.dynamicsFriction = 80; // 摩擦
        positionAnim.dynamicsTension = 500; // 张力
        positionAnim.removedOnCompletion = YES;
        positionAnim.fromValue = @(fAlpha);
        positionAnim.toValue   = @(tAlpha);
        [view pop_addAnimation:positionAnim forKey:@"changealpha"];
    }
}

+ (void)percentCountingAnimationWithLabel:(UILabel *)label fromValue:(CGFloat)fValue toValue:(CGFloat)tValue delay:(CGFloat)delay
{
    [label pop_removeAnimationForKey:@"counting"];
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 0.3;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.beginTime = CACurrentMediaTime()+delay;
    anim.removedOnCompletion = YES;
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [[obj description] floatValue];
        };
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.0f%%",values[0]]];
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
    
    anim.property = prop;
    
    anim.fromValue = @(fValue);
    anim.toValue = @(tValue);
    
    [label pop_addAnimation:anim forKey:@"counting"];
}


@end
