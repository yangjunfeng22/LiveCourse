//
//  PlayerLayer.m
//  LiveCourse
//
//  Created by junfengyang on 15/2/10.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "PlayerLayer.h"

@implementation PlayerLayer


#pragma mark 绘制一个实心三角形
- (void)drawInContext:(CGContextRef)ctx
{
    CGSize size = self.bounds.size;
    
    //DLog(@"size: %@", NSStringFromCGSize(size));
    // 设置为白色
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    //CGContextSetFillColorWithColor(ctx, self.backgroundColor);
    // 设置起点
    CGContextMoveToPoint(ctx, 0, 0);
    // 从(0, 0)连线到(0, 100)
    CGContextAddLineToPoint(ctx, 0, size.height);
    // 从(0, 100)连线到(100, 100)
    CGContextAddLineToPoint(ctx, size.width, size.height*0.5);
    // 合并路径，连接起点和终点
    CGContextClosePath(ctx);
   
    // 绘制路径
    CGContextFillPath(ctx);
}


@end
