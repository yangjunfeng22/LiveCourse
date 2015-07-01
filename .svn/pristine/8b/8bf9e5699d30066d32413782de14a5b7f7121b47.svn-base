//
//  HSCourseItemWordView.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/15.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCourseItemWordView.h"
#import "UIView+RoundedCorners.h"
#import "WordModel.h"

#import "UIImageView+WebCache.h"
#import "UIImageView+Extra.h"
#import "UIImageView+UIImageView_FaceAwareFill.h"

@interface HSCourseItemWordView ()
{
    NSInteger index;
    
}

@property (nonatomic, strong) HSPinyinLabel *lblContent;
@property (nonatomic, strong) UILabel *lblProperty;

@end

@implementation HSCourseItemWordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrViews = [[NSBundle mainBundle] loadNibNamed:@"HSCourseItemWordView" owner:nil options:nil];
        
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
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.btnShowSentence setTitle:MyLocal(@"点击查看例句") forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lblWord sizeToFit];
    self.lblWord.centerX = self.width*0.5;
    
    [self.lblTranslation sizeToFit];
    self.lblTranslation.centerX = self.width*0.5;
    self.lblTranslation.top = self.lblWord.bottom+6;
    
//    [self.lblProperty sizeToFit];
//    self.lblProperty.right = self.lblTranslation.left;
//    self.lblProperty.top = self.lblTranslation.top+2;
}

- (UILabel *)lblProperty
{
    if (!_lblProperty)
    {
        _lblProperty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _lblProperty.font = kFontHel(13);
        _lblProperty.textColor = kColorWord;
        [self addSubview:_lblProperty];
    }
    return _lblProperty;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setWordData:(id)wordData
{
    _wordData = wordData;
    WordModel *word = (WordModel *)wordData;
    NSString *chinese = [[NSString alloc] initWithFormat:@"%@^%@", word.chinese, word.pinyin];
    self.lblWord.text = chinese;

    /*
    // 如果翻译数据过短，那么另外设置一个控件显示。如果翻译数据比词本身长很多，那么合并到一起。
    NSString *tText = [word.tChinese copy];
    NSString *wText = [word.chinese copy];
    CGSize tSize = kiOS7_OR_LATER ? [tText sizeWithAttributes:@{NSFontAttributeName:self.lblTranslation.font}]: [tText sizeWithFont:self.lblTranslation.font];
    CGSize wSize = kiOS7_OR_LATER ? [wText sizeWithAttributes:@{NSFontAttributeName:self.lblWord.font}]: [wText sizeWithFont:self.lblWord.font];
    
    if (tSize.width >= wSize.width*2)
    {
        NSString *strFormat = [word.tProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0?[[NSString alloc] initWithFormat:@"%@.  %@", word.tProperty, tText]:[[NSString alloc] initWithFormat:@"%@", tText];
        self.lblTranslation.text = strFormat;
        self.lblProperty.text = @"";
    }
    else
    {
        NSString *strProperty = [word.tProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0?[[NSString alloc] initWithFormat:@"%@.  ", word.tProperty]:@"";
        self.lblProperty.text = strProperty;
        self.lblTranslation.text = tText;
    }
     */
    NSString *tText = [word.tChinese copy];
    NSString *strFormat = [word.tProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0?[[NSString alloc] initWithFormat:@"%@  %@", word.tProperty, tText]:[[NSString alloc] initWithFormat:@"%@", tText];
    // 给词性部分设置不同的颜色
    NSRange range = [strFormat rangeOfString:word.tProperty];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strFormat];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : self.lblTranslation.textColor,NSFontAttributeName : kFontHel(13)} range:range];
     
    //self.lblTranslation.text = strFormat;
    self.lblTranslation.attributedText = attributeString;
    
    NSString *picPath = [HSBaseTool picturePathWithCheckPoinID:HSAppDelegate.curCpID picture:word.picture];
    if (![NSString isNullString:picPath])
    {
        NSURL *picUrl = [NSURL fileURLWithPath:picPath];
        __weak HSCourseItemWordView *weakSelf = self;
        [self.imgvPicture sd_setImageWithURL:picUrl placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.imgvPicture showClipImageWithImage:image];
        }];
    }
}

- (IBAction)showSentenceAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wordView:shouldShowOther:)])
    {
        [self.delegate wordView:self shouldShowOther:YES];
    }
}

- (void)playAudioAction:(id)sender
{
    if (self.btnAudioPlayer.isPlaying)
    {
        [self.btnAudioPlayer stopPlay];
    }
    else
    {
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:((WordModel *)_wordData).audio];
        [self.btnAudioPlayer playAudio:path completion:^(BOOL finished, NSError *error) {}];
    }
}

- (void)playMedia
{
    [self playAudioAction:nil];
}

- (void)dealloc
{
    
}

@end
