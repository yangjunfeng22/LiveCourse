//
//  UITestTopicOptionCustomBtn.m
//  LiveCourse
//
//  Created by Lu on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicOptionCustomBtn.h"

@interface UITestTopicOptionCustomBtn ()




@end



@implementation UITestTopicOptionCustomBtn

-(id)init{
    
    self = [super init];
    if (self) {
        [self loadUI];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadUI];
    }
    return self;
}

-(void)isShowBoard:(BOOL)isShow{
    if (isShow) {
        
    }else{
        self.layer.borderWidth = 0;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.abcLabel.textColor = kColorWhite;
        self.detailLabel.textColor = kColorWhite;
        [_detailLabel isPinyinHighlight:NO andColor:kColorMain];
    }else{
        self.abcLabel.textColor = kColorMain;
        self.detailLabel.textColor = kColorWord;
        [_detailLabel isPinyinHighlight:YES andColor:kColorMain];
    }
}


-(void)setAbcLabelText:(NSString *)abcText andDetailLabelText:(NSString *)detailText{
    self.abcLabel.text = abcText;
    
    CGFloat detailLabelLeft = abcText ? self.abcLabel.right : 10;
    
    
    self.detailLabel.left =detailLabelLeft;
    self.detailLabel.width = self.width - detailLabelLeft*2;
    self.detailLabel.height = self.height;
    self.detailLabel.text = detailText;
    [self.detailLabel sizeToFit];
    self.detailLabel.centerX = self.width/2;
    self.detailLabel.centerY = self.height/2;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setIfUserChooseRight{
    [self.layer addAnimation:[self coutomAnimation] forKey:@"scale-layer"];
    self.layer.borderColor = kColorGreen.CGColor;
    [self setBackgroundImage:[UIImage imageWithColor:kColorGreen andSize:self.size] forState:UIControlStateSelected];
}

-(void)setIfUserChooseWrong{
    self.layer.borderColor = HEXCOLOR(0xE37976).CGColor;
    [self setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xE37976) andSize:self.size] forState:UIControlStateSelected];
}

-(void)setIfIsRightButUserNotChoose{
    [self.layer addAnimation:[self coutomAnimation] forKey:@"scale-layer"];
    [self setTitleColor:kColorWhite forState:UIControlStateNormal];
    self.layer.borderColor = kColorGreen.CGColor;
    [self setBackgroundImage:[UIImage imageWithColor:kColorGreen andSize:self.size] forState:UIControlStateNormal];
    
    self.abcLabel.textColor = kColorWhite;
    self.detailLabel.textColor = kColorWhite;
    [_detailLabel isPinyinHighlight:NO andColor:kColorMain];
}


-(void)editBtnEnable{
    self.enabled = YES;
    self.layer.borderColor = kColorMain.CGColor;
    self.abcLabel.textColor = kColorWord;
    self.detailLabel.textColor = kColorWord;
    [self.detailLabel isPinyinHighlight:YES andColor:kColorMain];
}

-(void)editBtnUnEnable{
    self.enabled = NO;
    self.layer.borderColor = kColorWord.CGColor;
    self.abcLabel.textColor = kColorWord;
    self.detailLabel.textColor = kColorWord;
    [self.detailLabel isPinyinHighlight:NO andColor:nil];
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


-(void)loadUI{
    
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = kColorMain.CGColor;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    [self setBackgroundImage:[UIImage imageWithColor:kColorWhite andSize:self.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:kColorMain andSize:self.size] forState:UIControlStateSelected];
    [self setTitleColor:kColorMain forState:UIControlStateNormal];
    [self setTitleColor:kColorWhite forState:UIControlStateSelected];
}


#pragma mark - UI

-(UILabel *)abcLabel{
    if (!_abcLabel) {
        _abcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, self.height)];
        _abcLabel.textAlignment = NSTextAlignmentCenter;
        _abcLabel.textColor = kColorMain;
        _abcLabel.backgroundColor = kColorClear;
        _abcLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:_abcLabel];
    }
    return _abcLabel;
}


-(TopicLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[TopicLabel alloc] init];
        [_detailLabel isPinyinHighlight:YES andColor:kColorMain];
        _detailLabel.textColor = kColorWord;
        _detailLabel.backgroundColor = kColorClear;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.backgroundColor = kColorClear;
        _detailLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}


@end
