//
//  UITestTopicBaseView.h
//  LiveCourse
//
//  Created by Lu on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicLabel.h"
#import "ExamModel.h"


#define optionBtnSpace 15
#define optionBtnHeight 50
#define optionBtnLeft 15


@protocol UITestTopicDelegate <NSObject>

-(void)userHasChoosePleaseEditContinueBtnEnable;//用户已选择 打开检查按钮

-(void)userNoChoosePleaseEditContinueBtnUnEnable;//用户未选择 关闭检查按钮

-(void)userHasChoose:(BOOL)hasChoose;//选择了

@end



@interface UITestTopicBaseView : UIView

@property (nonatomic, strong) UILabel *topicTypeTitleLabel;//题型label
@property (nonatomic, strong) UIScrollView *backScrollView;

@property (nonatomic, weak) id <UITestTopicDelegate> delegate;



/**
 *  加载数据
 *
 *  @param examModel <#examModel description#>
 */
-(void)loadDataWithExamModel:(ExamModel *)examModel;



/**
 *  检查结果 返回星星
 *
 *  @return 星星数
 */
-(NSInteger)checkResultAndReturnRightStarNum;

/**
 *  返回该题总得星星数
 *
 *  @return <#return value description#>
 */
-(NSInteger)returnFullStarNum;


/**
 *  编辑检查按钮
 *
 *  @param isEnable yes则打开 no关闭
 */
-(void)editContinueBtnIsEnable:(BOOL)isEnable;


/**
 *  编辑重置按钮
 *
 *  @param isEnable isEnable yes则打开 no关闭
 */
-(void)editResetBtnIsEnable:(BOOL)isEnable;


/**
 *  重置所有选项
 */
-(void)resetAllOption;

/**
 *  自定义动画
 *
 *  @return
 */
-(CABasicAnimation *)coutomAnimation;

/**
 *  发生错误 直接跳转至下一题
 */
-(void)errorAndToNextTopic;


/**
 *  保存做题记录
 *
 *  @param topicID 题ID
 *  @param result  结果
 *  @param answer  索引
 */
-(void)savePracticeRecordWithTopicID:(NSString *)topicID result:(BOOL)result answer:(NSString *)answer;





@end
