//
//  HSMessageFilterView.h
//  HelloHSK
//
//  Created by junfengyang on 14/11/19.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSMessageFilterViewDelegate;

@interface HSMessageFilterView : UIView
@property (nonatomic, weak) id<HSMessageFilterViewDelegate>delegate;


@end


@protocol HSMessageFilterViewDelegate <NSObject>

@optional
- (void)messageFiltered:(NSString *)messageType;

@end