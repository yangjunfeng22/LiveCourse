//
//  UITestTopicOptionMany.h
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 根据录音选择图片类型的答案

@protocol UITestTopicOptionManyDelegate;

@interface UITestTopicOptionMany : UIView


@property (nonatomic, weak) id<UITestTopicOptionManyDelegate> delegate;

/**
 *  设置标题 语音路径和选项个数
 *
 *  @param audioPath
 *  @param num
 */
-(void)setTitle:(NSString *)title andAudioPath:(NSString *)path andOptionNum:(NSInteger)num;


/**
 *  高度
 */
@property (nonatomic,assign,readonly) CGFloat optionHeight;



/**
 *  关闭每个选项的交互
 */
-(void)setEveryItemUnenable;


/**
 *  用户选择正确
 */
-(void)setIfUserChooseRight;

/**
 *  答错了
 *
 *  @param trueItem 正确答案
 */
-(void)setIfUserChooseWrongWithTrueItem:(NSInteger)trueItem;

/**
 *  清空已经选择的答案
 */
-(void)resetChooseItem;

/**
 *  播放多媒体音频。
 */
- (void)playMedia;

@end

@protocol UITestTopicOptionManyDelegate <NSObject>


/**
 *  用户选择答案后返回
 *
 *  @param index  本选项是第几个选项
 *  @param result 答案
 */
- (void)userChoseResult:(UITestTopicOptionMany *)topic withIndex:(NSInteger)index andResult:(NSInteger)result;

@end
