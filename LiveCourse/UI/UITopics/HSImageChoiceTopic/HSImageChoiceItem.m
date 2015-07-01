//
//  HSImageChoiceItem.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSImageChoiceItem.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "HSUIAnimateHelper.h"
#import "UIImageView+Extra.h"
#import "UIImageView+UIImageView_FaceAwareFill.h"

@implementation HSImageChoiceItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrViews = [[NSBundle mainBundle] loadNibNamed:@"HSImageChoiceItem" owner:nil options:nil];
        
        //DLog(@"views: %@", arrViews);
        if ([arrViews count] < 1){
            return nil;
        }
        
        if (![[arrViews objectAtIndex:0] isKindOfClass:[UIView class]]){
            return nil;
        }
        
        self = [arrViews objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lblTitle.minimumScaleFactor = 0.6;
    self.lblTitle.adjustsFontSizeToFitWidth = YES;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.lblTitle.text = text;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    //self.imgvPicture.image = image;
    [self.imgvPicture showClipImageWithImage:image];
    //[self.imgvPicture faceAwareFill];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    // 改变状态
    [HSUIAnimateHelper scaleAnimationWithView:self scaleX:0.8 scaleY:0.8];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [HSUIAnimateHelper scaleAnimationWithView:self scaleX:1 scaleY:1];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    if (CGRectContainsPoint(self.bounds, point))
    {
        //DLog(@"包含");
        // 触发事件
    }
    else
    {
        //DLog(@"不包含");
        // 不触发事件, 恢复状态
    }
    [HSUIAnimateHelper scaleAnimationWithView:self scaleX:1 scaleY:1];
    [super touchesEnded:touches withEvent:event];
}


@end
