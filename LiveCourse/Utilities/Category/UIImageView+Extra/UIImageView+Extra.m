//
//  UIImageView+Extra.m
//  LiveCourse
//
//  Created by junfengyang on 15/2/10.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UIImageView+Extra.h"

@implementation UIImageView (Extra)

- (void)showClipImageWithImage:(UIImage *)image
{
    [self setImage:image];
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.contentMode =  UIViewContentModeScaleAspectFill;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
}

@end
