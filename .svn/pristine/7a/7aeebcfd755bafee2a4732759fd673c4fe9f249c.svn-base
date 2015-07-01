//
//  UITestTopicBaseView.m
//  LiveCourse
//
//  Created by Lu on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicBaseView.h"
#import "AudioPlayHelper.h"
#import "PracticeRecordStore.h"

@interface UITestTopicBaseView ()

@end



@implementation UITestTopicBaseView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


#pragma mark - action


-(void)loadDataWithExamModel:(ExamModel *)examModel
{
    DLog(@"子类继承加载数据方法");
}

-(NSInteger)checkResultAndReturnRightStarNum{
    DLog(@"检查答案");
    return 0;
}

-(NSInteger)returnFullStarNum{
    
    return 1;
    
}

-(void)editContinueBtnIsEnable:(BOOL)isEnable{
    if (isEnable) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(userHasChoosePleaseEditContinueBtnEnable)]) {
            [self.delegate userHasChoosePleaseEditContinueBtnEnable];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(userNoChoosePleaseEditContinueBtnUnEnable)]) {
            [self.delegate userNoChoosePleaseEditContinueBtnUnEnable];
        }
    }
}

-(void)editResetBtnIsEnable:(BOOL)isEnable{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHasChoose:)]) {
        [self.delegate userHasChoose:isEnable];
    }
}

-(CABasicAnimation *)coutomAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.2; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.1]; // 结束时的倍率
    animation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

-(void)resetAllOption{
    DLog(@"子类继承重置");
}



-(void)errorAndToNextTopic{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTestErrorDataNotification object:nil userInfo:nil];
}

#pragma mark - UI

-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topicTypeTitleLabel.bottom,self.width , self.height - self.topicTypeTitleLabel.bottom)];
        [self addSubview:_backScrollView];
    }
    return _backScrollView;
}


-(UILabel *)topicTypeTitleLabel{
    if (!_topicTypeTitleLabel) {
        _topicTypeTitleLabel = [[UILabel alloc] init];
        
        CGFloat left = 15;
        _topicTypeTitleLabel.left = left;
        _topicTypeTitleLabel.width = self.width - left*2;
        _topicTypeTitleLabel.top = 0;
        _topicTypeTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        _topicTypeTitleLabel.height = 40;
        
        _topicTypeTitleLabel.textColor = kColorWord;
        _topicTypeTitleLabel.numberOfLines = 2;
        [self addSubview:_topicTypeTitleLabel];
    }
    return _topicTypeTitleLabel;
}


-(void)savePracticeRecordWithTopicID:(NSString *)topicID result:(BOOL)result answer:(NSString *)answer
{
    NSInteger rightTime = result ? 1 : 0;
    NSInteger wrongTime = result ? 0 : 1;
    
    if ([NSString isNullString:topicID]) {
        return;
    }
    
    //保存记录
    [PracticeRecordStore savePracticeRecordWithUserID:kUserID courseCategoryID:HSAppDelegate.curCCID courseID:HSAppDelegate.curCID lessonID:HSAppDelegate.curLID topicID:topicID rightTimes:rightTime wrongTimes:wrongTime result:rightTime answer:answer completion:^(BOOL finished, id data, NSError *error) {
        
    }];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
