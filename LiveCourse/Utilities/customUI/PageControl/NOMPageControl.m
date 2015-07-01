//
//  NOMPageControl.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/23.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "NOMPageControl.h"

@implementation NOMPageControl
{
    UIImage *activeImage;
    UIImage *inactiveImage;
}

-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        activeImage = [UIImage imageNamed:@"pageControlSelected.png"];
        
        inactiveImage = [UIImage imageNamed:@"pageControlUnSelected.png"];
    }
    
    return self;
    
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];

    NSArray *subViews = self.subviews;
    NSInteger i = 0;
    for (UIImageView *subView in subViews)
    {
        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIImageView class])]) {
            subView.image = (currentPage == i ? activeImage : inactiveImage);
        }
        i++;
    }
}

/*
- (void)updateDots
{
    NSArray *subViews = self.subviews;
    NSInteger i = 0;
    for (UIImageView *subView in subViews)
    {
        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIImageView class])])
        {
            CGPoint center = subView.center;
            subView.bounds = CGRectMake(0, 0, 2, 2);
            subView.center = center;
            subView.image = (self.currentPage == i ? activeImage :inactiveImage);
            break;
        }
        i++;
    }
}
 */

@end
