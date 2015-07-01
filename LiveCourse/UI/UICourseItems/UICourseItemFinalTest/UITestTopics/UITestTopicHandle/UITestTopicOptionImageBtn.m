//
//  UITestTopicOptionImageBtn.m
//  LiveCourse
//
//  Created by Lu on 15/1/27.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UITestTopicOptionImageBtn.h"
#import "UIImageView+Extra.h"
#import "UIImageView+UIImageView_FaceAwareFill.h"

@interface UITestTopicOptionImageBtn ()

@property (nonatomic, strong) UIImageView *optionImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation UITestTopicOptionImageBtn


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
    }
    return self;
}

-(void)loadData{
    self.layer.cornerRadius = 9.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = kColorLine2.CGColor;
    self.layer.masksToBounds = YES;
    
    [self setBackgroundImage:[UIImage imageWithColor:kColorWhite andSize:self.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:kColorMain andSize:self.size] forState:UIControlStateSelected];
}


-(void)setImage:(UIImage *)image andTitleText:(NSString *)titleText{
    //self.optionImageView.image = [image thumbnailImage:200];
    [self.optionImageView showClipImageWithImage:image];
    //self.optionImageView.image = image;
    //[self.optionImageView faceAwareFill];
    self.textLabel.text = titleText;
    //暂时没数据
    self.textLabel.hidden = YES;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
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


#pragma mark - UI
-(UIImageView *)optionImageView{
    if (!_optionImageView) {
        CGFloat left = 5;
        CGFloat top = 5;
        _optionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, self.width - 2*left, self.height - 2*top)];
        _optionImageView.layer.cornerRadius = 7.0f;
        _optionImageView.layer.masksToBounds = YES;
        [self addSubview:_optionImageView];
    }
    return _optionImageView;
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.optionImageView.width, 20)];
        _textLabel.backgroundColor = kColorClear;//HEXCOLORA(0xFFFFFF, 0.7);
        _textLabel.bottom = self.optionImageView.height;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = kColorWord;
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.optionImageView addSubview:_textLabel];
    }
    return _textLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
