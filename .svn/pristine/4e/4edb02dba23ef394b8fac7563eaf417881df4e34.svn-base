//
//  HSCheckPointView.h
//  HSWordsPass
//
//  Created by yang on 14-9-3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSCheckPointViewDelegate;

@interface HSCheckPointView : UIView

@property (nonatomic, weak)id<HSCheckPointViewDelegate>delegate;

/**
 *  初始化函数，从nib文件中获取对象
 *
 *  @return 该对象实例。
 */
+ (HSCheckPointView *)instance;

- (void)refreshCheckPointWithData:(id)data;

@end

@protocol HSCheckPointViewDelegate <NSObject>

@optional

- (void)checkPointView:(HSCheckPointView *)view selectCheckPoint:(id)checkpoint;

- (void)checkPointView:(HSCheckPointView *)view selectCheckPoint:(NSString *)cpID nexCheckPoint:(NSString *)nexCpID;

- (void)checkPointView:(HSCheckPointView *)view selectCheckPoint:(NSString *)cpID nexCheckPoint:(NSString *)nexCpID currentCheckPointType:(LiveCourseCheckPointType)type;

- (void)checkPointView:(HSCheckPointView *)view syncWordLearnRecordsFinished:(NSString *)cpID;
- (void)checkPointView:(HSCheckPointView *)view syncCheckPointProgressFinished:(NSString *)cpID;


@end