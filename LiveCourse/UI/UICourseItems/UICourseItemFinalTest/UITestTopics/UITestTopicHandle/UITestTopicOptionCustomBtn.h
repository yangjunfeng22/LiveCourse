//
//  UITestTopicOptionCustomBtn.h
//  LiveCourse
//
//  Created by Lu on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicLabel.h"

@interface UITestTopicOptionCustomBtn : UIButton

@property (nonatomic, strong)UILabel *abcLabel;//选项
@property (nonatomic, strong)TopicLabel *detailLabel;

/**
 *  初始化 !!!!!!!!需强制执行!!!!!!!!!
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
-(id)initWithFrame:(CGRect)frame;

/**
 *  是否显示边框
 *
 *  @param isShow <#isShow description#>
 */
-(void)isShowBoard:(BOOL)isShow;


/**
 *  设置abc文字和中间详情文字
 *
 *  @param abcText    <#abcText description#>
 *  @param detailText <#detailText description#>
 */
-(void)setAbcLabelText:(NSString *)abcText andDetailLabelText:(NSString *)detailText;

/**
 *  用户选择正确了
 */
-(void)setIfUserChooseRight;

/**
 *  用户选择错误了
 */
-(void)setIfUserChooseWrong;


/**
 *  正确答案 但是用户未选择正确 而是选错了
 */
-(void)setIfIsRightButUserNotChoose;


/**
 *  使有效
 */
-(void)editBtnEnable;




/**
 *  使无效
 */
-(void)editBtnUnEnable;


/**
 *  自定义动画
 *
 *  @return
 */
-(CABasicAnimation *)coutomAnimation;

@end
