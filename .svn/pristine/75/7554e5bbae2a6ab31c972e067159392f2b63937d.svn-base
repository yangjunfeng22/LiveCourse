//
//  HSLessonInfoView.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/21.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSLessonInfoView.h"
#import "CircleView.h"
#import "DACircularProgressView.h"
#import "TTTAttributedLabel.h"
#import "LessonModel.h"
#import "LessonProgressModel.h"

#import <pop/POP.h>

#import "HSUIAnimateHelper.h"
#import "HSPinyinLabel.h"

@interface HSLessonInfoView ()

@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) UILabel *lblObtain;
@property (nonatomic, strong) UILabel *lblProgress;

@end

@implementation HSLessonInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}


- (void)dealloc
{
    [_circleView removeFromSuperview];
    _circleView = nil;
    
    [_lblObtain removeFromSuperview];
    _lblObtain = nil;
}

- (CircleView *)circleView
{
    if (!_circleView)
    {
        CGFloat width  = self.height * 0.7f;
        CGRect frame = CGRectMake(self.width-width*1.36f, (self.height-width)*0.5, width, width);
        _circleView = [[CircleView alloc] initWithFrame:frame];
        _circleView.alwaysShowProgress = YES;
        _circleView.strokeColor = kColorMain;
        _circleView.lineWidth = 4;
        _circleView.backgroundCircleColor = kColorLine;
        _circleView.userInteractionEnabled = NO;
        [self addSubview:_circleView];
        
        [_circleView setStrokeEnd:0 animated:NO];
    }
    return _circleView;
}

- (UILabel *)lblObtain
{
    if (!_lblObtain)
    {
        CGFloat width  = self.height * 0.7f;
        _lblObtain = [[UILabel alloc] initWithFrame:CGRectMake(width*0.4, 0, self.circleView.left-width*0.4f, self.height)];
        _lblObtain.numberOfLines = 0;
        _lblObtain.font = kFontHel(15);
        _lblObtain.textColor = kColorHintGray;
        _lblObtain.adjustsFontSizeToFitWidth = YES;
        _lblObtain.minimumScaleFactor = 6;
        [self addSubview:_lblObtain];
    }
    return _lblObtain;
}

- (UILabel *)lblProgress
{
    if (!_lblProgress)
    {
        
        _lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.circleView.width*0.8, self.circleView.width*0.8)];
        _lblProgress.font = kFontHel(15);
        _lblProgress.textAlignment = NSTextAlignmentCenter;
        _lblProgress.backgroundColor = kColorClear;
        _lblProgress.center = self.circleView.center;
        _lblProgress.text = @"0%";
        _lblProgress.adjustsFontSizeToFitWidth = YES;
        [self insertSubview:_lblProgress belowSubview:self.circleView];
    }
    return _lblProgress;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setLessonProgress:(CGFloat)lessonProgress
{
    [self.circleView setAnimatedStrokeEnd:lessonProgress from:self.lessonProgress duration:0.3f delay:0.0f];
    [HSUIAnimateHelper percentCountingAnimationWithLabel:self.lblProgress fromValue:self.lessonProgress*100 toValue:lessonProgress*100 delay:0.0f];
    
    _lessonProgress = lessonProgress;
}

- (void)setObtain:(NSString *)obtain
{
    _obtain = obtain;
    NSString *fObtain = obtain ? [obtain stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]:@"";
    NSString *lObtain = [MyLocal(@"学完这一课，你可以:") stringByAppendingFormat:@"\n%@", fObtain];
    self.lblObtain.text = lObtain;
    [self.lblObtain sizeToFit];
    //self.lblObtain.centerY = self.height*0.5;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.height = self.height < self.lblObtain.height ? self.lblObtain.height+6:self.height;
    self.lblObtain.centerY = self.height*0.5;
}

#pragma mark - 刷新

- (void)refreshLessonInfoWithLessonData:(id)data progress:(id)progress
{
    LessonModel *lesson = (LessonModel *)data;
    DLog(@"obtain: %@", lesson.obtain);
    self.lblObtain.text = lesson.obtain;
    
    LessonProgressModel *lProgress = (LessonProgressModel *)progress;
    DLog(@"progress: %@", lProgress);
    self.lessonProgress = lProgress.progressValue;
}

@end
