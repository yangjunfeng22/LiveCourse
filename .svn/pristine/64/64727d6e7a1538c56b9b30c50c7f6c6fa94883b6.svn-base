//
//  HSAudioPlayerButton.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/23.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSAudioPlayerButton.h"
#import "CircleView.h"
#import "HSUIAnimateHelper.h"
#import "AudioPlayHelper.h"
#import "PlayerLayer.h"

#import "UIView+RoundedCorners.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>

void (^ playCompletion)(BOOL finished, NSError *error);

@interface HSAudioPlayerButton ()<AudioPlayHelperDelegate>
{
    NSMutableDictionary *_tintColors;
    AudioPlayHelper *audioPlayer;
}

@property (nonatomic, readwrite) BOOL isPlaying;

@property (nonatomic, strong) CALayer *bckgLayer;
@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) UIImageView *voiceAnimationImgView;//发音动画
//@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, strong) UIImageView *imageNode;

@end

@implementation HSAudioPlayerButton

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame buttonType:buttonAudioDefaultType buttonStyle:audioButtonPlainStyle];
}

- (instancetype)initWithFrame:(CGRect)frame buttonType:(HSAudioPlayerButtonType)initType buttonStyle:(HSAudioPlayerButtonStyle)bStyle {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentButtonType = initType;
        self.currentButtonStyle = bStyle;
        
        //self.tintColor = [UIColor whiteColor];
        [self commonSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.currentButtonType = buttonAudioDefaultType;
        self.currentButtonStyle = audioButtonRoundedStyle;
        
        //self.tintColor = [UIColor whiteColor];
        [self commonSetup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)commonSetup
{
    if (self.currentButtonStyle == audioButtonRoundedStyle)
    {
        self.bckgLayer = [CALayer layer];
        //CGFloat amount = self.frame.size.width / 3;
        self.bckgLayer.frame = self.bounds;//CGRectInset(self.bounds, -amount, -amount);
        self.bckgLayer.cornerRadius = self.bckgLayer.bounds.size.width/2;
        self.bckgLayer.backgroundColor = self.roundBackgroundColor.CGColor;
        
        [self.layer addSublayer:self.bckgLayer];
        
        /*
        PlayerLayer *layer = [PlayerLayer layer];
        // 设置层的宽高
        layer.bounds = CGRectMake(0, 0, self.width*0.3, self.height*0.3);
        layer.position = CGPointMake(self.width*0.5, self.height*0.5);
        //layer.backgroundColor = kColorWhite.CGColor;
        // 设置层的位置
        // 开始绘制图层
        [layer setNeedsDisplay];
        [self.layer addSublayer:layer];
        */
        
        //[self imageNode];
        
        [self.circleView setStrokeEnd:0 animated:NO];
    }
    
    [self animateToType:self.currentButtonType];
}

- (void)setRoundBackgroundColor:(UIColor *)roundBackgroundColor {
    if (_currentButtonStyle == audioButtonRoundedStyle) {
        if (self.bckgLayer) {
            self.bckgLayer.backgroundColor = roundBackgroundColor.CGColor;
        }
    }
}

- (void)setRoundBackgroundBorderWidth:(CGFloat)roundBackgroundBorderWidth
{
    if (_currentButtonStyle == audioButtonRoundedStyle) {
        if (self.bckgLayer) {
            self.bckgLayer.borderWidth = roundBackgroundBorderWidth;
        }
    }
}

- (void)setRoundBackgroundBorderColor:(UIColor *)roundBackgroundBorderColor
{
    if (_currentButtonStyle == audioButtonRoundedStyle) {
        if (self.bckgLayer) {
            self.bckgLayer.borderColor = roundBackgroundBorderColor.CGColor;
        }
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
}

- (void)setTintColor:(UIColor *)tintColor forState:(UIControlState)state {
    if (!_tintColors) {
        _tintColors = [NSMutableDictionary dictionary];
    }
    
    if (!tintColor) {
        [_tintColors removeObjectForKey:@(state)];
    }
    else {
        _tintColors[@(state)] = tintColor;
    }
    
    [self updateState];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateState];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateState];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateState];
}

- (void)updateState {
    self.tintColor = [self tintColorForState:self.state];
}

- (UIColor *)tintColorForState:(UIControlState)state {
    UIColor *tint = _tintColors[@(self.state)];
    
    if (!tint) {
        //Fall back to UIControlStateNormal
        tint = _tintColors[@(UIControlStateNormal)];
    }
    
    if (!tint) {
        //Use current tint color
        tint = self.tintColor;
    }
    
    if (!tint && kiOS7_OR_LATER) {
        //Fall back to window color
        tint = self.window.tintColor;
    }
    
    if (!tint) {
        //Fall back to default color
        tint = [UIColor whiteColor];
    }
    
    return tint;
}

- (void)animateToType:(HSAudioPlayerButtonType)finalType
{
    self.currentButtonType = finalType;
}

- (void)playAudio:(NSString *)audio completion:(void (^)(BOOL finished, NSError *error))completion
{
    playCompletion = completion;
    [HSUIAnimateHelper popUpAnimationWithView:self];
    [AudioPlayHelper stopAndCleanAudioPlay];
    audioPlayer = [AudioPlayHelper initWithAudioName:audio delegate:self];
    audioPlayer.loops = self.loops;
    if (_currentButtonStyle == audioButtonRoundedStyle){
        [self.circleView setAnimatedStrokeEnd:1 duration:audioPlayer.duration*(audioPlayer.loops+1)];
    }
    
    [audioPlayer playAudio];
    _isPlaying = audioPlayer.isPlaying;
    
    [self startAnimating];
}

- (void)stopPlay
{
    [audioPlayer stopAudio];
    
    [self stopAnimating];
}

#pragma mark - Touches Delegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

#pragma mark -
- (CircleView *)circleView
{
    if (!_circleView)
    {
        _circleView = [[CircleView alloc] initWithFrame:self.bounds];
        _circleView.strokeColor = kColorMainHalf;
        _circleView.lineWidth = 3;
        _circleView.backgroundCircleColor = kColorLine;
        _circleView.userInteractionEnabled = NO;
        [self addSubview:_circleView];
        
    }
    return _circleView;
}

-(UIImageView *)voiceAnimationImgView
{
    if (!_voiceAnimationImgView)
    {
        UIImage *lImgAP = ImageNamed(@"ico_audioPlay_2");
        CGFloat width = self.width > self.height ? self.height:self.width;
        width = width > lImgAP.size.width ? lImgAP.size.width:width;
        _voiceAnimationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, width)];
        _voiceAnimationImgView.image = lImgAP;
        _voiceAnimationImgView.animationDuration = 1.2;
        _voiceAnimationImgView.animationImages = [NSArray arrayWithObjects:ImageNamed(@"ico_audioPlay_1"), ImageNamed(@"ico_audioPlay_2"), ImageNamed(@"ico_audioPlay_3"), nil];
        [self insertSubview:_voiceAnimationImgView belowSubview:self.circleView];
        //[self addSubview:_voiceAnimationImgView];
    }
    return _voiceAnimationImgView;
}

/*
- (ASImageNode *)imageNode
{
    if (!_imageNode)
    {
        _imageNode = [[ASImageNode alloc] init];
        
        UIImage *img = ImageNamed(@"ico_audioPlay_2");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            CGFloat width = self.width > self.height ? self.height:self.width;
            width = width > img.size.width ? img.size.width:width;
            _imageNode.image = img;
            CGPoint center = self.circleView.center;
            _imageNode.frame = CGRectMake(center.x-width*0.5, center.y-width*0.5, width, width);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addSubview:_imageNode.view];
            });
        });
    }
    return _imageNode;
}
 */
- (UIImageView *)imageNode
{
    if (!_imageNode)
    {
        _imageNode = [[UIImageView alloc] init];
        
        UIImage *img = ImageNamed(@"ico_audioPlay_2");
        CGFloat width = self.width > self.height ? self.height:self.width;
        width = width > img.size.width ? img.size.width:width;
        _imageNode.image = img;
        CGPoint center = self.circleView.center;
        _imageNode.frame = CGRectMake(center.x-width*0.5, center.y-width*0.5, width, width);
        [self insertSubview:_imageNode belowSubview:self.circleView];
    }
    return _imageNode;
}

- (void)startAnimating
{
    [self.voiceAnimationImgView startAnimating];
    //self.imageNode.hidden = YES;
}

- (void)stopAnimating
{
    if ([self isAnimating])
    {
        [self.voiceAnimationImgView stopAnimating];
        //self.imageNode.hidden = NO;
    }
}

- (BOOL)isAnimating{
    return self.voiceAnimationImgView.isAnimating;
}
/*
- (void)setLoops:(NSInteger)loops
{
    _loops = loops;
    [AudioPlayHelper instance].loops = loops;
}
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.voiceAnimationImgView.center = self.circleView.center;
    
}

#pragma mark - AudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _isPlaying = NO;
    if (_currentButtonStyle == audioButtonRoundedStyle){
        [self.circleView cleanAnimation];
    }
    if (playCompletion)
    {
        NSError *error = [NSError errorWithDomain:@"Success" code:0 userInfo:nil];
        playCompletion(flag, error);
    }
    
    [self stopAnimating];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    _isPlaying = NO;
    if (_currentButtonStyle == audioButtonRoundedStyle){
        [self.circleView cleanAnimation];
    }
    
    if (playCompletion)
    {
        NSError *error = [NSError errorWithDomain:@"failed" code:-1 userInfo:nil];
        playCompletion(NO, error);
    }
    
    [self stopAnimating];
}

@end
