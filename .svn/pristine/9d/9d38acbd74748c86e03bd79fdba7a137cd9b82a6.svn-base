//
//  HSDragView.m
//  HelloHSK
//
//  Created by yang on 14-3-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSDragView.h"
#import "HSDragLabel.h"
#import "HSUIAnimateHelper.h"

@interface HSDragView ()

@property (nonatomic, readwrite) CGFloat totalHeight;

@end

@implementation HSDragView
{
    CGFloat wdtX;
    CGFloat wdtY;
    CGFloat wdtWidth;
    CGFloat dragWidth;
    CGFloat dragHeight;
    CGFloat specY;
    CGFloat specX;
}
@synthesize type;
@synthesize arrDragLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        wdtX = 0.0f;
        wdtY = 26.0f;
        wdtWidth = self.bounds.size.width;
        dragWidth = 80.0f;
        dragHeight = 35.0f;
        specX = 6.0f;
        specY = 6.0f;
        _totalHeight = 0;
        
        arrDragLabel = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.height = _totalHeight;
}

- (void)initInterface
{
    NSArray *arrWord = [self.subject componentsSeparatedByString:@"|"];
    CGFloat dragX = wdtX;
    
    for (NSString *strWord in arrWord)
    {
        if ([strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0)
        {
            continue;
        }
        
        HSDragLabel *lblDrag = [[HSDragLabel alloc] initWithFrame:CGRectMake(dragX, wdtY, wdtWidth, dragHeight)];
        lblDrag.backgroundColor = kColorMain;
        lblDrag.layer.cornerRadius = 5;
        lblDrag.font = kFontHel(15);
        lblDrag.text = strWord;
        lblDrag.type = type;
        [lblDrag sizeToFit];
        [lblDrag addTarget:self action:@selector(clickDragLabel:) forControlEvents:UIControlEventTouchUpInside];
        
        if (dragX + specX + lblDrag.factWidth >= wdtWidth)
        {
            dragX = wdtX;
            wdtY += lblDrag.factHeight + specY;
        }
        CGRect frame = CGRectMake(dragX, wdtY, lblDrag.width, lblDrag.height);
        CGPoint nCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        CGPoint tCenter = [self convertPoint:nCenter toView:self.superview];
        lblDrag.center = tCenter;
        dragX += specX + lblDrag.factWidth;
        [self.superview addSubview:lblDrag];
        //[self addSubview:lblDrag];
        [arrDragLabel addObject:lblDrag];
        
        _totalHeight = lblDrag.bottom;
    }
}

- (void)setType:(NSInteger)aType
{
    type = aType;
    [self initInterface];
}

- (void)clickDragLabel:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragView:clicked:)])
    {
        [self.delegate dragView:self clicked:sender];
    }
}

- (void)reShowDragLabelWithText:(NSString *)text
{
    for (HSDragLabel *lblDragItem in arrDragLabel)
    {
        if ([lblDragItem.text isEqualToString:text])
        {
            //[HSUIAnimateHelper popUpAnimationWithView:lblDragItem];
            lblDragItem.hidden = NO;
            break;
        }
    }
}

- (void)reShowDragLabelWithText:(NSString *)text fromCenter:(CGPoint)center
{
    for (HSDragLabel *lblDragItem in arrDragLabel)
    {
        if ([lblDragItem.text isEqualToString:text])
        {
            CGPoint tCenter = lblDragItem.center;
            lblDragItem.center = center;
            [HSUIAnimateHelper springView:lblDragItem fromCenter:center toCenter:tCenter completion:^(BOOL finished) {}];
            
            lblDragItem.hidden = NO;
            break;
        }
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    _subject = nil;
    [arrDragLabel removeAllObjects];
    self.arrDragLabel = nil;
}

@end
