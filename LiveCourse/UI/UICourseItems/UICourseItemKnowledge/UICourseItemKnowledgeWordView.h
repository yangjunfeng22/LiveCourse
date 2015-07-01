//
//  UICourseItemKnowledgeWordView.h
//  LiveCourse
//
//  Created by Lu on 15/1/14.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowledgeModel.h"



@interface UICourseItemKnowledgeWordView : UIView

@property (nonatomic) BOOL isOverturn;//是否旋转
/**
 *  加载数据
 */
-(void)loadWithData;

-(void)loadWithKnowledgeModel:(KnowledgeModel *)model;

/**
 *  如果显示例句了 则翻转回去
 */
-(void)rotationToStartStatus;

@end
