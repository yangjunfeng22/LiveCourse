//
//  HSCollectionViewCheckPointLayoutAttributes.m
//  HSWordsPass
//
//  Created by yang on 14/11/13.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCollectionViewCheckPointLayoutAttributes.h"

@implementation HSCollectionViewCheckPointLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    HSCollectionViewCheckPointLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.checkPointFlowDirection = self.checkPointFlowDirection;
    return attributes;
}

- (NSString *)debugDescription
{
    NSString *highlightedCellDirectionString = [NSString stringWithFormat:@"CheckPoint cell direction: %@; ", (self.checkPointFlowDirection == HSCollectionViewCheckPointLayoutFlowDirectionLeft) ? @"Left" : @"Right"];
    
    return [self.description stringByAppendingFormat:@"%@", highlightedCellDirectionString];
}

@end
