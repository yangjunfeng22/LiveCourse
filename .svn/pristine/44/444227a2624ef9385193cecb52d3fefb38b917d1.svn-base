//
//  HSImageChoiceTopic.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSImageChoiceTopic.h"
#import "HSImageChoiceItem.h"
#import "WordModel.h"
#import "HSBaseTool.h"
#import "AudioPlayHelper.h"
#import "HSUIAnimateHelper.h"

@interface  HSImageChoiceTopic()
{
    NSString *rightAnswer;
    NSString *audioPath;
}

//@property (nonatomic, strong) HSAudioPlayerButton *playerButton;
@property (nonatomic, strong) UIButton *btnContinue;

@property (nonatomic, strong) NSMutableArray *arrItem;

@end

@implementation HSImageChoiceTopic

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrViews = [[NSBundle mainBundle] loadNibNamed:@"HSImageChoiceTopic" owner:nil options:nil];
        
        //DLog(@"views: %@", arrViews);
        if ([arrViews count] < 1){
            return nil;
        }
        
        if (![[arrViews objectAtIndex:0] isKindOfClass:[UIView class]]){
            return nil;
        }
        
        self = [arrViews objectAtIndex:0];
        self.frame = frame;
        
        self.btnAudioPlayer.currentButtonType = buttonAudioPlayType;
        self.btnAudioPlayer.currentButtonStyle = audioButtonRoundedStyle;
        self.btnAudioPlayer.roundBackgroundColor = kColorMain;
        [self.btnAudioPlayer addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btnContinue.enabled = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (UIButton *)btnContinue
{
    if (!_btnContinue)
    {
        _btnContinue = [[UIButton alloc] initWithFrame:CGRectMake(self.width*0.05, self.height*0.87, self.width*0.9, 44)];
        _btnContinue.backgroundColor = [UIColor lightGrayColor];
        _btnContinue.layer.cornerRadius = 5;
        _btnContinue.layer.masksToBounds = YES;
        [_btnContinue setTitle:MyLocal(@"继续") forState:UIControlStateNormal];
        [_btnContinue addTarget:self action:@selector(continueAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnContinue.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_btnContinue];
    }
    return _btnContinue;
}

- (NSMutableArray *)arrItem
{
    if (!_arrItem)
    {
        _arrItem = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _arrItem;
}

- (void)setChoiceItems:(NSArray *)choiceItems
{
    _choiceItems = choiceItems;
    
    
    NSInteger count = [choiceItems count];
    if (count > 0)
    {
        [self initChoiceItems];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //self.playerButton.center = self.btnAudioPlayer.center;
    self.lblTitle.bottom = self.btnAudioPlayer.top-16;
    self.lblTitle.height = 66;
    self.lblTitle.centerX = self.width*0.5;
}

#pragma mark - Init Interface
- (void)initChoiceItems
{
    CGFloat width = self.width*0.4f;
    CGFloat height = self.height*0.25f;
    CGFloat oX = 0;
    CGFloat oY = 0;
    
    self.lblTitle.top = self.height *0.05;
    
    NSInteger count = [self.choiceItems count];
    if (count >= 4){
        count = 4;
    }
    
    // 随机选出一个
    NSInteger index = arc4random() % count;
    
    WordModel *word = [self.choiceItems objectAtIndex:index];
    NSString *strWord = [[NSString alloc] initWithFormat:@"%@^%@", word.chinese, word.pinyin];
    self.lblTitle.text =strWord;
    [self.lblTitle sizeToFit];
    
    rightAnswer = word.wID;//word.tChinese;
    audioPath = word.audio;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        if (i % 2 == 0) {
            oX = self.width*0.5 - 8 - width;
        }else{
            oX = self.width*0.5 + 8;
        }
        oY = self.btnAudioPlayer.bottom+self.btnAudioPlayer.height*0.5 + (i < 2 ? 0:height*1.1f);
        WordModel *word = [self.choiceItems objectAtIndex:i];
        NSString *picPath = [HSBaseTool picturePathWithCheckPoinID:HSAppDelegate.curCpID picture:word.picture];
        //DLog(@"图片路径: %@", picPath);
        HSImageChoiceItem *item  = [[HSImageChoiceItem alloc] initWithFrame:CGRectMake(oX, oY, width, height)];;
        item.layer.cornerRadius = 10;
        item.layer.masksToBounds = YES;
        item.backgroundColor = kColorLine;
        item.image = [UIImage imageWithContentsOfFile:picPath];
        item.text = word.tChinese;
        item.itemID = word.wID;
        [item addTarget:self action:@selector(itemSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        
        if (![self.arrItem containsObject:item])
        {
            [self.arrItem addObject:item];
        }
    }
}

#pragma mark - Button Action
- (void)playAudioAction:(id)sender
{
    if (self.btnAudioPlayer.isPlaying)
    {
        [self.btnAudioPlayer stopPlay];
    }
    else
    {
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:audioPath];
        [self.btnAudioPlayer playAudio:path completion:^(BOOL finished, NSError *error) {
            
        }];
    }
}

- (void)continueAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicFinishedToContinue)])
    {
        [self.delegate topicFinishedToContinue];
    }
}

- (void)itemSelectedAction:(id)sender
{
    self.btnContinue.enabled = YES;
    self.btnContinue.backgroundColor = kColorMain;
    HSImageChoiceItem *item = (HSImageChoiceItem *)sender;
    BOOL choiceRight = [item.itemID isEqualToString:rightAnswer];
    item.userInteractionEnabled = NO;
    if (choiceRight)
    {
        item.backgroundColor = kColorLightGreen;
        [HSUIAnimateHelper popUpAnimationWithView:item];
    }
    else
    {
        item.backgroundColor = kColorLightRed;
    }
    [self playCheckResult:choiceRight];
    
    [self.arrItem removeObject:item];
    for (HSImageChoiceItem *item in self.arrItem)
    {
        item.userInteractionEnabled = NO;
        if (!choiceRight)
        {
            if ([item.itemID isEqualToString:rightAnswer])
            {
                item.backgroundColor = kColorLightGreen;
                [HSUIAnimateHelper popUpAnimationWithView:item];
            }
        }
    }
}

- (void)playCheckResult:(BOOL)right
{
    NSString *audio = @"wrong.mp3";
    if (right){
        audio = @"right.mp3";
    }
    [AudioPlayHelper stopAndCleanAudioPlay];
    NSString *path = [[NSBundle mainBundle] pathForResource:audio ofType:nil];
    AudioPlayHelper *audioPlayer = [AudioPlayHelper initWithAudioName:path delegate:nil];
    [audioPlayer playAudio];
}

- (void)playMedia
{
    [self playAudioAction:nil];
}

@end
