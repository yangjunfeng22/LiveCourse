//
//  HSUIAnimateHelper.h
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, HSUIViewAnimationOptions){
    HSUIViewAnimationOptionRotateY                 = 1 <<  0,
    HSUIViewAnimationOptionRotateX                 = 1 <<  1,
    /*
    HSUIViewAnimationOptionRotateZ                 = 1 <<  2,
    
    HSUIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
    HSUIViewAnimationOptionCurveEaseIn               = 1 << 16,
    HSUIViewAnimationOptionCurveEaseOut              = 2 << 16,
    HSUIViewAnimationOptionCurveLinear               = 3 << 16,
    
    HSUIViewAnimationOptionTransitionNone            = 0 << 20, // default
    HSUIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
    HSUIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
    HSUIViewAnimationOptionTransitionCurlUp          = 3 << 20,
    HSUIViewAnimationOptionTransitionCurlDown        = 4 << 20,
    HSUIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
    HSUIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
    HSUIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
     */
};

@interface HSUIAnimateHelper : NSObject

+ (CATransition *)pushInFromLeftOfCustomView;

+ (CATransition *)pushInFromRightOfCustomView;

+ (CATransition *)pushInFromBottomOfCustomView;

+ (CATransition *)moveInFromTopOfCustomView;

+ (CATransition *)moveInFromBottomOfCustomView;

+ (CATransition *)moveOutFromBottomOfCustomView;


+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView completion:(void (^)(BOOL finished))completion;

+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView speed:(CGFloat)speed bounciness:(CGFloat)bounciness options:(HSUIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;

+ (void)popUpAnimationWithView:(UIView *)view;

+ (void)scaleAnimationWithView:(UIView *)view scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY;

+ (void)transitionView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter completion:(void (^)(BOOL finished))completion;

+ (void)transitionView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;

+ (void)transitionView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;

+ (void)transitionView:(UIView *)view fromFrame:(CGRect)fFrame toFrame:(CGRect)tFrame;

+ (void)transitionView:(UIView *)view fromAlpha:(CGFloat)fAlpha toAlpha:(CGFloat)tAlpha;

+ (void)springView:(UIView *)view fromCenter:(CGPoint)fCenter toCenter:(CGPoint)tCenter completion:(void (^)(BOOL finished))completion;

+ (void)percentCountingAnimationWithLabel:(UILabel *)label fromValue:(CGFloat)fValue toValue:(CGFloat)tValue delay:(CGFloat)delay;

@end
