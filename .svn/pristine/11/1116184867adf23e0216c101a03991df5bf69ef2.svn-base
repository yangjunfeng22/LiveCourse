#import "UIView+RoundedCorners.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (RoundedCorners)

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size {
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    
    CAShapeLayer* maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    self.layer.masksToBounds = YES;

}

- (void)setBorderWidth:(NSUInteger)borderWidth andBorderColor:(UIColor *)borderColor
{
    if (self.layer.mask)
    {
        CAShapeLayer *maskLayer = (CAShapeLayer *)self.layer.mask;
        CGPathRef ref = maskLayer.path;
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:ref];
        //其它操作
        //CAShapeLayer* maskLayer = [CAShapeLayer new];
        
        maskLayer.borderWidth = borderWidth;
        
        maskLayer.borderColor = [borderColor CGColor];
    
        //maskLayer.fillColor = [[UIColor clearColor] CGColor];
        //maskLayer.path = bezierPath.CGPath;
        //[self.layer addSublayer:maskLayer];
        self.layer.mask = maskLayer;
        
    }
    else
    {
        UIBezierPath* maskPath = [UIBezierPath bezierPath];
        //其它处理
        
        CAShapeLayer* maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.bounds;
        
        
        maskLayer.borderWidth = borderWidth;
        
        maskLayer.borderColor = [borderColor CGColor];


        
        maskLayer.path = maskPath.CGPath;
        
        self.layer.mask = maskLayer;
    }
    
}

@end