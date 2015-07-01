//
//  HSDragLabel.m
//  HelloHSK
//
//  Created by yang on 14-3-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSDragLabel.h"
#import "HSPinyinLabel.h"
#import "UIView+RoundedCorners.h"

@implementation HSDragLabel
{
    NSInteger spec;
    HSPinyinLabel *lblText;
}

@synthesize text;
@synthesize font;
@synthesize type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        spec = 1.0f;
        [self initInterface];
    }
    return self;
}

- (void)initInterface
{
    lblText = [[HSPinyinLabel alloc] initWithFrame:self.bounds];
    lblText.backgroundColor = kColorClear;
    lblText.textColor = kColorWhite;
    lblText.numberOfLines = 0;
    lblText.textAlignment = NSTextAlignmentCenter;
    lblText.text = @"";
    [self addSubview:lblText];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Set category Manager
- (void)setText:(NSString *)aText
{
    text = aText;
    lblText.text = aText;
    [lblText sizeToFit];
    [self refreshTextLabel];
}

- (void)setFont:(UIFont *)aFont
{
    font = aFont;
    lblText.font = aFont;
    [lblText sizeToFit];
    [self refreshTextLabel];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    lblText.textColor = textColor;
}

- (void)setType:(NSInteger)aType
{
    switch (aType)
    {
        case 0:
        {
            //self.backgroundColor = kColorMainHalf;
            break;
        }
        case 1:
        {
            self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            self.layer.shadowOpacity = 0.3f;
            self.layer.opacity = 1.0f;
            break;
        }
        case 2:
        {
            self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            self.layer.shadowOpacity = 0.3f;
            self.layer.opacity = 0.7f;
            break;
        }
            
        default:
            break;
    }
}

- (void)refreshTextLabel
{
    
    lblText.width += 10;
    
    _factWidth = lblText.width;
    _factHeight = lblText.height;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [super sizeThatFits:size];
    return lblText.size;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [lblText removeFromSuperview];
    lblText = nil;
    
    self.text = nil;
    self.font = nil;
}

@end
