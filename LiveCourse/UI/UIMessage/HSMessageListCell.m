//
//  HSMessageListCell.m
//  HelloHSK
//
//  Created by yang on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMessageListCell.h"
#import "MessageModel.h"
#import "UIImageView+WebCache.h"
#import "HSBaseTool.h"
#define distanceFactor 9

@interface HSMessageListCell ()
@property (nonatomic, strong) UILabel *lblMsgType;

@end

@implementation HSMessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.imageView.backgroundColor = kColorClear;
        //self.headerImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.imageView.layer.cornerRadius = self.imageView.height*0.5;
        self.imageView.layer.masksToBounds = YES;
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

- (UILabel *)lblMsgType
{
    if (!_lblMsgType)
    {
        _lblMsgType = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.right+12, 0, 30, 14)];
        _lblMsgType.backgroundColor = kColorClear;
        _lblMsgType.textAlignment = NSTextAlignmentCenter;
        _lblMsgType.textColor = kColorWhite;
        _lblMsgType.font = [UIFont systemFontOfSize:10];
        _lblMsgType.layer.cornerRadius = _lblMsgType.height*0.5;
        //self.typeLabel.layer.shouldRasterize = YES;
        _lblMsgType.clipsToBounds = YES;
        [self.contentView addSubview:_lblMsgType];
    }
    return  _lblMsgType;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 30.0f)];
        _timeLabel.backgroundColor = kColorClear;
        _timeLabel.textColor = kColorBlack;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        _timeLabel.highlightedTextColor = kColorWhite;
        _timeLabel.font = kFontHel(12);
        self.accessoryView = _timeLabel;
    }
    return _timeLabel;
}

- (void)awakeFromNib
{
    // Initialization code
    self.imageView.width = 49;
    self.imageView.height = 49;
    
    self.imageView.backgroundColor = kColorClear;
    self.imageView.layer.cornerRadius = self.imageView.height*0.5;
    self.imageView.layer.masksToBounds = YES;
    
    CGFloat fontSize = kiPhone ? 15:18;
    self.textLabel.font = kFontHel(fontSize);
    self.textLabel.textColor = kColorBlack;
    self.textLabel.highlightedTextColor = kColorWhite;
    self.textLabel.backgroundColor = kColorClear;
    
    self.detailTextLabel.font = kFontHel(13);
    self.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    self.detailTextLabel.highlightedTextColor = kColorWhite;
    self.detailTextLabel.backgroundColor = kColorClear;
}

- (void)setMessage:(MessageModel *)message
{
    _message = message;
    //BOOL isTeacher = [message.type isEqualToString:kMessageTeacher];
    //BOOL isFriend = [message.type isEqualToString:kMessageFriend];
    NSURL *url = [NSURL URLWithString:message.icon];
    
    UIImage *imgPlacehold = ImageNamed(@"img_community_placeholder");
    [self.imageView sd_setImageWithURL:url placeholderImage:imgPlacehold completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //DLog(@"消息列表获取图片信息: %@", error.localizedDescription);
    }];
    

    self.lblMsgType.backgroundColor = [HSBaseTool getHexColor:message.typeColor];
    self.lblMsgType.text = message.typeName;
    CGFloat oldHeight = self.lblMsgType.height;
    [self.lblMsgType sizeToFit];
    self.lblMsgType.height = oldHeight;
    self.lblMsgType.width += 6;

    self.timeLabel.text = [HSBaseTool dateFromTimeIntervalSince1970:[message.timeStamp integerValue]];
    self.timeLabel.textColor = message.isReaded ? [UIColor grayColor]:kColorBlack;
    [self.timeLabel sizeToFit];
    
    NSString *title = message.title;
    self.textLabel.text = title;
    self.textLabel.textColor = message.isReaded ? [UIColor grayColor]:kColorBlack;
    self.detailTextLabel.text = message.summary;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.timeLabel.highlighted = selected;
    self.textLabel.highlighted = selected;
    self.textLabel.highlighted = selected;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = 49;
    self.imageView.height = 49;
    self.imageView.centerY = self.contentView.height * 0.5;

    self.lblMsgType.centerY = self.imageView.centerY - 13.5;
    self.textLabel.left = self.lblMsgType.right + 6;
    self.textLabel.centerY = self.lblMsgType.centerY;
    self.textLabel.width = self.timeLabel.left - self.textLabel.left;
    self.detailTextLabel.left = self.lblMsgType.left;
    if (kiOS7_OR_LATER)
    {
        self.lblMsgType.left = self.separatorInset.left;
        self.separatorInset = UIEdgeInsetsMake(0, self.lblMsgType.left, 0, 0);
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

@end
