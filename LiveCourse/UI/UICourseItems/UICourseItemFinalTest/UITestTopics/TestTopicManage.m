//
//  UITestTopicManage.m
//  LiveCourse
//
//  Created by Lu on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "TestTopicManage.h"
#import "UITestTopicGjjzpddc.h"
#import "UITestTopicGjqjxzhsdda.h"
#import "UITestTopicXzzqdda.h"
#import "UITestTopicTdhxzzqdda.h"
#import "UITestTopicTlypddc.h"
#import "UITestTopicGjlyxzzqda.h"
#import "UITestTopicGjlyxztp.h"
#import "UITestTopicGjlyxzzqdaMany.h"
#import "UITestTopicGjkwnrxzzqdda.h"
#import "UITestTopicXzdydjzlxt.h"
#import "UITestTopicXctk.h"
#import "UITestTopicLccj.h"




typedef  NS_ENUM(NSInteger, UITestTopicType)
{
    UITestTopicTypeGjjzpddc = 0, //根据句子，判断对错            ------跟1一样合并入1中
    UITestTopicTypeGjqjxzhsdda = 1, //根据情景选择合适的答案
    UITestTopicTypeXzzqdda = 2,//选择正确的答案
    UITestTopicTypeTdhxzzqdda = 3,// 听对话 选择正确的答案        -----跟1一样合并入1中
    UITestTopicTypeTlypddc = 4,//听录音，判断对错,!!!!有两个题型
    UITestTopicTypeGjlyxzzqda = 5,//根据录音，选择正确答案
    UITestTopicTypeGjlyxztp = 6,//根据录音选择图片
    UITestTopicTypeGjlyxzzqdaMany = 7, //根据录音选择正确答案 - 多个选项型
    UITestTopicTypeGjkwnrxzzqdda = 8,//根据课文内容选择正确的答案
    UITestTopicTypeXzdydjzlxt = 9,//选择对应的句子 连线题
    UITestTopicTypeXctk = 10,//选词填空
    UITestTopicTypeLccj = 11,//连词成句
};



@implementation TestTopicManage
{
    BOOL isShowResetBtn;//是否显示重置按钮
}

-(UITestTopicBaseView *)loadWithFrame:(CGRect)frame andData:(ExamModel *)examModel{
    
    UITestTopicBaseView *topicView;
    
    NSInteger type = -1;
    
    NSString *typeStr = examModel.type;
    DLog(@"eID----%@-----typeStr-----%@-------typeAlias------%@",examModel.eID,typeStr,examModel.typeAlias);
    
    if ([typeStr isEqualToString:@"lyxz"])
    {
        type = UITestTopicTypeGjlyxzzqdaMany;//7
    }
    else if ([typeStr isEqualToString:@"tpxz"])
    {
        type = UITestTopicTypeGjlyxzzqda;//5--
    }
    else if ([typeStr isEqualToString:@"xctk"])
    {
        type = UITestTopicTypeXctk;//10
    }
    else if ([typeStr isEqualToString:@"wcjz"])
    {
        type = UITestTopicTypeLccj;//11
    }
    else if ([typeStr isEqualToString:@"lxt"])
    {
        type = UITestTopicTypeXzdydjzlxt;//9
    }
    else if ([typeStr isEqualToString:@"dc"])
    {
        type = UITestTopicTypeTlypddc;//4
    }
    else if ([typeStr isEqualToString:@"xz"])
    {
        if ([examModel.subjectFormat isEqualToString:@"talk"]) {
            type = UITestTopicTypeTdhxzzqdda;//3
        }else{
            type = UITestTopicTypeGjqjxzhsdda;//1--
        }
    }
    else if ([typeStr isEqualToString:@"tyxt"])
    {
        type = UITestTopicTypeGjlyxztp;
    }
    else if ([typeStr isEqualToString:@"kwxz"])
    {
        type = UITestTopicTypeGjkwnrxzzqdda;
    }

    isShowResetBtn = NO;
    
    if (type == UITestTopicTypeGjjzpddc) {
        topicView = [[UITestTopicGjjzpddc alloc] initWithFrame:frame];
    }
    else if (type == UITestTopicTypeGjqjxzhsdda)
    {
        topicView = [[UITestTopicGjqjxzhsdda alloc] initWithFrame:frame];
    }
    else if (type == UITestTopicTypeXzzqdda)
    {
        topicView = [[UITestTopicXzzqdda alloc] initWithFrame:frame];
    }
    else if (type == UITestTopicTypeTdhxzzqdda)
    {
        topicView = [[UITestTopicTdhxzzqdda alloc] initWithFrame:frame];
    }
    else if (type == UITestTopicTypeTlypddc)
    {
        topicView = [[UITestTopicTlypddc alloc] initWithFrame:frame];
    }
    else if (type == UITestTopicTypeGjlyxzzqda)
    {
        topicView = [[UITestTopicGjlyxzzqda alloc] initWithFrame:frame];
    }
    else if (type == UITestTopicTypeGjlyxztp)
    {
        topicView = [[UITestTopicGjlyxztp alloc] initWithFrame:frame];
        
        isShowResetBtn = YES;
    }
    else if (type == UITestTopicTypeGjlyxzzqdaMany)
    {
        topicView = [[UITestTopicGjlyxzzqdaMany alloc] initWithFrame:frame];
        isShowResetBtn = YES;
    }
    else if (type == UITestTopicTypeGjkwnrxzzqdda)
    {
        topicView = [[UITestTopicGjkwnrxzzqdda alloc] initWithFrame:frame];
        isShowResetBtn = YES;
    }
    else if (type == UITestTopicTypeXzdydjzlxt)
    {
        topicView = [[UITestTopicXzdydjzlxt alloc] initWithFrame:frame];
        isShowResetBtn = YES;
    }
    else if (type == UITestTopicTypeXctk)
    {
        topicView = [[UITestTopicXctk alloc] initWithFrame:frame];
        isShowResetBtn = YES;
    }
    else if (type == UITestTopicTypeLccj)
    {
        topicView = [[UITestTopicLccj alloc] initWithFrame:frame];
        isShowResetBtn = YES;
    }else{
        //没有此题型 跳过
        topicView = [[UITestTopicBaseView alloc] initWithFrame:frame];
        [topicView errorAndToNextTopic];
    }
    
    //加载数据
    [topicView loadDataWithExamModel:examModel];
    
    //显示重置按钮
    if (isShowResetBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTestShowResetNotification object:nil userInfo:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kTestHideResetNotification object:nil userInfo:nil];
    }
    
    return topicView;
}

@end
