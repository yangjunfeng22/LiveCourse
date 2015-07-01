//
//  UICourseItemLessonCell.m
//  LiveCourse
//
//  Created by Lu on 15/1/22.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseItemLessonCell.h"
#import "TopicLabel.h"
#import "SentenceLabel.h"

@interface UICourseItemLessonCell ()

@property (nonatomic, strong) SentenceLabel *textContentLabel;
@property (nonatomic, strong) TopicLabel *textUserNameLabel;
@property (nonatomic, strong) UIImageView *personIcon;
@property (nonatomic, strong) UILabel *colonlabel;

@property (nonatomic, strong) UILabel *translateLabel;//翻译

@end

@implementation UICourseItemLessonCell
{
    CGFloat cellHeight;
    NSString *translateStr;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = kColorMain;
        self.textContentLabel.highlightedTextColor = kColorWhite;
//        self.textUserNameLabel.highlightedTextColor = kColorWhite;
        self.translateLabel.highlightedTextColor = kColorWhite;
    }
    return self;
}



-(void)setTextStr:(NSString *)textStr andTranslate:(NSString *)translate
{
    translateStr = translate;
    
    NSArray *textContentArray = [NSArray arrayWithArray:[textStr componentsSeparatedByString:@"^"]];
    NSArray *chArray = [NSArray arrayWithArray:[[textContentArray objectAtIndex:0] componentsSeparatedByString:@":"]] ;
    NSArray *pinyinArray = [NSArray arrayWithArray:[[textContentArray objectAtIndex:1] componentsSeparatedByString:@":"]];
    
    NSMutableArray *userNameArray = [NSMutableArray arrayWithObjects:[chArray objectAtIndex:0],[pinyinArray objectAtIndex:0], nil];
    
    NSString *chStr = [[chArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pinYinStr = [[pinyinArray objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:chStr,pinYinStr, nil];
    
//    NSString *userNameStr = [[userNameArray componentsJoinedByString:@":^"] stringByAppendingString:@":"];
    NSString *userNameStr = [[userNameArray objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];;
    
    NSString *contentStr = [contentArray componentsJoinedByString:@"^"];
    
    //用户名
    
//    self.textUserNameLabel.numberOfLines = 1;
//    self.textUserNameLabel.left = 10;
//    self.textUserNameLabel.height = 44;
//    self.textUserNameLabel.top = 0;
//    self.textUserNameLabel.width = 300;
//    self.textUserNameLabel.text = userNameStr;
//    [self.textUserNameLabel sizeToFit];
    
    UIImage *personImage = [self inputPesonNameAndBackIcon:userNameStr];
    self.personIcon.image = personImage;
    self.personIcon.size = personImage.size;
    self.personIcon.left = 10;
    self.personIcon.top = 10;
    
    
//    self.colonlabel.text = @":";
//    [_colonlabel sizeToFit];
//    _colonlabel.centerY = self.personIcon.centerY;
    
    //内容
    self.textContentLabel.numberOfLines = 0;
    self.textContentLabel.frame = CGRectMake(40, 6, self.width - 40- 15, 0);
    self.textContentLabel.text = contentStr;
    [self.textContentLabel sizeToFit];
    
    self.translateLabel.text = [translateStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    self.translateLabel.numberOfLines = 0;
    self.translateLabel.top = self.textContentLabel.bottom + 3;
    self.translateLabel.left = self.textContentLabel.left;
    self.translateLabel.width = self.width - self.textContentLabel.left - 15;
    [self.translateLabel sizeToFit];
//    self.translateLabel.alpha = 0;
    
    
    cellHeight = self.textContentLabel.height + 12;
}

-(CGFloat)requiredRowHeight{
    return cellHeight;
}

-(void)showTranslate:(BOOL)isShow{
    if (isShow) {

        cellHeight = self.translateLabel.bottom + 8;
        self.translateLabel.alpha = 0;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.translateLabel.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    if (!isShow) {

        cellHeight = self.textContentLabel.height + 12;
//        self.translateLabel.alpha = 1;
        [UIView animateWithDuration:0.2f animations:^{
            self.translateLabel.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(UIImage *)inputPesonNameAndBackIcon:(NSString *)name{
    NSString *imageName = @"";
    
    if ([name isEqualToString:@"李沪生"])
    {
        imageName = @"icon_peson_hs";
    }else if ([name isEqualToString:@"约翰"])
    {
        imageName = @"icon_peson_jhon";
    }else if ([name isEqualToString:@"丽莎"])
    {
        imageName = @"icon_peson_ls";
    }else if ([name isEqualToString:@"迈克"])
    {
        imageName = @"icon_peson_mk";
    }else if ([name isEqualToString:@"珍妮"])
    {
        imageName = @"icon_peson_zn";
    }else if ([name isEqualToString:@"王佳"])
    {
        imageName = @"icon_peson_wj";
    }else if ([name isEqualToString:@"李想"])
    {
        imageName = @"icon_peson_lx";
    }else if ([name isEqualToString:@"小安"])
    {
        imageName = @"icon_peson_ms";
    }else if ([name isEqualToString:@"服务员"])
    {
        imageName = @"icon_peson_fwy";
    }else if ([name isEqualToString:@"同事A"])
    {
        imageName = @"icon_peson_tsa";
    }else if ([name isEqualToString:@"同事B"])
    {
        imageName = @"icon_peson_tsb";
    }else if ([name isEqualToString:@"同事C"])
    {
        imageName = @"icon_peson_tsc";
    }else if ([name isEqualToString:@"同事D"])
    {
        imageName = @"icon_peson_tsd";
    }else{
        imageName = @"icon_peson_mr";
    }
    
    UIImage *icon = [UIImage imageNamed:imageName];
    
    return icon;
}


#pragma mark - UI

-(UIImageView *)personIcon{
    if (!_personIcon) {
        _personIcon = [[UIImageView alloc] init];
        _personIcon.backgroundColor = kColorClear;
        [self.contentView addSubview:_personIcon];
    }
    return _personIcon;
}

-(TopicLabel *)textUserNameLabel{
    if (!_textUserNameLabel) {
        _textUserNameLabel = [[TopicLabel alloc] init];
        _textUserNameLabel.backgroundColor = kColorClear;
        _textUserNameLabel.font = [UIFont systemFontOfSize:13.0f];
        [_textUserNameLabel isPinyinHighlight:YES andColor:kColorMain];
        [self.contentView addSubview:_textUserNameLabel];
    }
    return _textUserNameLabel;
}

-(SentenceLabel *)textContentLabel{
    if (!_textContentLabel) {
        _textContentLabel = [[SentenceLabel alloc] init];
        _textContentLabel.backgroundColor = kColorClear;
        _textContentLabel.font = kFontHel(16);
        [_textContentLabel isPinyinHighlight:YES andColor:kColorMain];
        [self.contentView addSubview:_textContentLabel];
    }
    return _textContentLabel;
}


-(UILabel *)colonlabel{
    if (!_colonlabel) {
        _colonlabel = [[UILabel alloc] initWithFrame:CGRectMake(self.personIcon.right + 5, 0, 5, self.personIcon.height)];
        _colonlabel.textColor = kColorWord;
        [self.contentView addSubview:_colonlabel];
    }
    
    return _colonlabel;
}


-(UILabel *)translateLabel{
    if (!_translateLabel) {
        _translateLabel = [[UILabel alloc] init];
        _translateLabel.font = kFontHel(15);
        _translateLabel.alpha = 0;
        [self.contentView addSubview:_translateLabel];
    }
    return _translateLabel;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    cellHeight = 0;
}

@end
