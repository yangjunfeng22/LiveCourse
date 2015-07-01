//
//  HSDropView.m
//  HelloHSK
//
//  Created by yang on 14-3-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSDropView.h"
#import "HSDragLabel.h"
#import "UIView+RoundedCorners.h"
#import "HSUIAnimateHelper.h"

@implementation HSDropView
{
    CGFloat wdtX;
    CGFloat wdtY;
    CGFloat wdtWidth;
    CGFloat dragWidth;
    CGFloat dragHeight;
    CGFloat specY;
    CGFloat specX;
}
@synthesize arrDropLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        wdtX = 6.0f;
        wdtY = 6.0f;
        wdtWidth = self.bounds.size.width;
        dragWidth = 80.0f;
        dragHeight = 35.0f;
        specX = 6.0f;
        specY = 6.0f;
        
        arrDropLabel = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

- (void)addDragLabelWithText:(NSString *)text
{
    HSDragLabel *lblDrag = [[HSDragLabel alloc] initWithFrame:CGRectMake(wdtX, wdtY, wdtWidth, dragHeight)];
    lblDrag.backgroundColor = kColorMain;
    lblDrag.layer.cornerRadius = 5;
    lblDrag.font = kFontHel(16);
    lblDrag.text = text;
    lblDrag.type = 0;
    [lblDrag sizeToFit];
    [lblDrag addTarget:self action:@selector(clickDragLabel:) forControlEvents:UIControlEventTouchUpInside];
    if (wdtX + specX + lblDrag.bounds.size.width >= wdtWidth)
    {
        wdtX = 6.0f;
        wdtY += lblDrag.height + specY;
    }
    CGRect frame = CGRectMake(wdtX, wdtY, lblDrag.width, lblDrag.height);
    lblDrag.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    wdtX += specX + lblDrag.width;
    [self addSubview:lblDrag];
    [HSUIAnimateHelper popUpAnimationWithView:lblDrag];
    [arrDropLabel addObject:lblDrag];
}

- (void)addDragLabelWithText:(NSString *)text fromCenter:(CGPoint)center
{
    HSDragLabel *lblDrag = [[HSDragLabel alloc] initWithFrame:CGRectMake(wdtX, wdtY, wdtWidth, dragHeight)];
    lblDrag.backgroundColor = kColorMain;
    lblDrag.layer.cornerRadius = 5;
    lblDrag.font = kFontHel(15);
    lblDrag.text = text;
    lblDrag.type = 0;
    [lblDrag sizeToFit];
    [lblDrag addTarget:self action:@selector(clickDragLabel:) forControlEvents:UIControlEventTouchUpInside];
    if (wdtX + specX + lblDrag.bounds.size.width >= wdtWidth)
    {
        wdtX = 6.0f;
        wdtY += lblDrag.height + specY;
    }
    CGRect frame = CGRectMake(wdtX, wdtY, lblDrag.width, lblDrag.height);
    
    lblDrag.center = center;
    //lblDrag.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    wdtX += specX + lblDrag.width;
    [self.superview.superview addSubview:lblDrag];
    CGPoint nCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    CGPoint tCenter = [self convertPoint:nCenter toView:self.superview.superview];
    
    [HSUIAnimateHelper springView:lblDrag fromCenter:center toCenter:tCenter completion:^(BOOL finished) {}];
    [arrDropLabel addObject:lblDrag];
}

- (void)clickDragLabel:(id)sender
{
    HSDragLabel *lblDrag = (HSDragLabel *)sender;
    /*
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropView:selectedText:)])
    {
        [self.delegate dropView:self selectedText:lblDrag.text];
    }
     */
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropView:selectedText:center:)])
    {
        [self.delegate dropView:self selectedText:lblDrag.text center:lblDrag.center];
    }
    [arrDropLabel removeObject:lblDrag];
    [lblDrag removeFromSuperview];
    lblDrag = nil;
    
    [self resetDragLabels];
}

- (void)resetDragLabels
{
    wdtX = 6.0f;
    wdtY = 6.0f;
    for (HSDragLabel *lblItem in arrDropLabel)
    {
        if (wdtX + specX + lblItem.bounds.size.width >= wdtWidth)
        {
            wdtX = 6.0f;
            wdtY += lblItem.height + specY;
        }
        CGRect frame = CGRectMake(wdtX, wdtY, lblItem.width, lblItem.height);
        CGPoint nCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        CGPoint tCenter = [self convertPoint:nCenter toView:self.superview.superview];
        //lblItem.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        [HSUIAnimateHelper springView:lblItem fromCenter:lblItem.center toCenter:tCenter completion:^(BOOL finished) {}];
        wdtX += specX + lblItem.width;
    }
}

#pragma marik - Memory Manager
- (void)dealloc
{
    [arrDropLabel removeAllObjects];
    self.arrDropLabel = nil;
}

@end
