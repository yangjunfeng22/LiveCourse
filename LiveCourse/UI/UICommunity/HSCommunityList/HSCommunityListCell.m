//
//  HSCommunityListCell.m
//  HelloHSK
//
//  Created by Lu on 14/12/1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCommunityListCell.h"
#import "UIImageView+WebCache.h"

@interface HSCommunityListCell()

@property (nonatomic, strong) UIView *topGrayView;              //顶部灰色部分
@property (nonatomic, strong) UILabel *typeIconLabel;           //活动或者热门类型label
@property (nonatomic, strong) UILabel *titleLabel;              //标题
@property (nonatomic, strong) UIImageView *postsImageView;      //帖子的图片

@property (nonatomic, strong) UILabel *detailLabel;             //详情
@property (nonatomic, strong) UILabel *userNameLabel;           //用户名
@property (nonatomic, strong) UILabel *timeLabel;               //时间

@property (nonatomic, strong) UILabel *replyLabel;              //回复个数
@property (nonatomic, strong) UIImageView *replyImageView;      //回复图标
@property (nonatomic, strong) UILabel *zanLabel;                //赞的个数
@property (nonatomic, strong) UIImageView *zanImageView;        //赞的图标

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation HSCommunityListCell
{
    CGFloat viewTop;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kColorWhite;
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    //判断有无图片
    if (_entity.picture && ![_entity.picture isEqualToString:@""]) {
        //设置标题宽度
        self.titleLabel.width = self.postsImageView.left - self.typeIconLabel.right - 10;
        
        self.detailLabel.width = self.postsImageView.left - 10;
    }else{
        //设置标题宽度
        self.postsImageView.image = nil;
        
        self.titleLabel.width = self.width - self.typeIconLabel.right - 20;
        
        self.detailLabel.width = self.width - 20;
    }
    
    self.bottomLineView.bottom = self.height;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.typeIconLabel.text = @"";
    self.typeIconLabel.width = 0;
    
    self.postsImageView.image = nil;
}


-(void)setEntity:(CommunityModel *)entity{
    _entity = entity;

    self.topGrayView.top = 0;
    
    if(entity.tagName && ![entity.tagName isEqualToString:@""]){
        self.typeIconLabel.text = entity.tagName;
        [self.typeIconLabel sizeToFit];
        
        self.typeIconLabel.width += 10;
        self.typeIconLabel.layer.cornerRadius = self.typeIconLabel.height/2;
        self.typeIconLabel.layer.masksToBounds = YES;
        //设置标题左边
        self.titleLabel.left = self.typeIconLabel.right + 5;
    }else{
        self.typeIconLabel.text = @"";
        self.typeIconLabel.width = 0;
        
        self.titleLabel.left = 10;
    }
    
    
    //判断有无图片
    if (entity.picture && ![entity.picture isEqualToString:@""]) {

        NSURL *imageUrl = [NSURL URLWithString:entity.picture];
        UIImage *placeholderImage = [UIImage imageNamed:@"img_community_placeholder"];
        [self.postsImageView sd_setImageWithURL:imageUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.postsImageView setImage:[image thumbnailImage:250]];
        }];
        
    }else{
        self.postsImageView.image = nil;
    }
    
    self.titleLabel.text = entity.title;
    
    viewTop = self.titleLabel.bottom + 10;
    if (![NSString isNullString:entity.audio]) {
        
        NSInteger duration = entity.durationValue;
        
        //有音频
        self.communityAudioBtn.top = viewTop;
        
        self.communityAudioBtn.duration = duration;
        self.communityAudioBtn.audioUrl = entity.audio;
        
        viewTop = self.communityAudioBtn.bottom;
        self.communityAudioBtn.alpha = 1;
    }else{
        self.communityAudioBtn.alpha = 0;
        viewTop = self.titleLabel.bottom + 10;
    }
    
    self.detailLabel.top = viewTop;
    
    self.detailLabel.attributedText = [hsGetSharedInstanceClass(HSBaseTool) paragraphStyleAndString:entity.summary font:self.detailLabel.font space:5];
    
    self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    viewTop = self.detailLabel.bottom + 15;
    
    //用户名
    self.userNameLabel.top = viewTop;
    
    self.userNameLabel.text = entity.owner;
    [self.userNameLabel sizeToFit];
    
    //时间
    self.timeLabel.text = [HSBaseTool dateFromTimeIntervalSince1970:[entity.posted integerValue]];
    [self.timeLabel sizeToFit];
    self.timeLabel.left = self.userNameLabel.right + 10;
    self.timeLabel.centerY = self.userNameLabel.centerY;
    
    //回复数
    self.replyLabel.text = [NSString stringWithFormat:@"%@", entity.replied];
    [self.replyLabel sizeToFit];
    self.replyLabel.centerY = self.timeLabel.centerY;
    self.replyLabel.right = self.width - 10;
    
    //回复图片
    self.replyImageView.right = self.replyLabel.left - 5;
    self.replyImageView.centerY = self.replyLabel.centerY;
    
    //点赞数
    self.zanLabel.text = [NSString stringWithFormat:@"%@", entity.liked];
    [self.zanLabel sizeToFit];
    self.zanLabel.centerY = self.replyLabel.centerY;
    self.zanLabel.right = self.replyImageView.left -5;
    
    //点赞图片
    self.zanImageView.right = self.zanLabel.left - 5;
    self.zanImageView.centerY = self.zanLabel.centerY;
    
    
    self.requiredRowHeight = self.userNameLabel.bottom + 10;
    self.height = self.requiredRowHeight;
    self.bottomLineView.bottom = self.height;
    [self setNeedsLayout];
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - action


#pragma mark - ui

-(UIView *)topGrayView{
    if (!_topGrayView) {
        _topGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width,12.0f)];
        _topGrayView.backgroundColor = kColorLine;
        _topGrayView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_topGrayView];
        
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _topGrayView.width, 0.5f)];
        topLineView.backgroundColor = kColorLine2;
        topLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_topGrayView addSubview:topLineView];
        
        UIView *topGrayViewBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _topGrayView.width, 0.5f)];
        topGrayViewBottomLineView.bottom = _topGrayView.height;
        topGrayViewBottomLineView.backgroundColor = kColorLine2;
        topGrayViewBottomLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_topGrayView addSubview:topGrayViewBottomLineView];
    }
    return _topGrayView;
}

-(UILabel *)typeIconLabel{
    if (!_typeIconLabel) {
        _typeIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.topGrayView.bottom + 12, 0, 20)];
        _typeIconLabel.backgroundColor = HEXCOLOR(0xE8582E);
        _typeIconLabel.textColor = kColorWhite;
        _typeIconLabel.textAlignment = NSTextAlignmentCenter;
        _typeIconLabel.contentMode = UIViewContentModeCenter;
        if (!kiPhone) {
            _typeIconLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        }else{
            _typeIconLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        }
        
        [self.contentView addSubview:_typeIconLabel];
    }
    return _typeIconLabel;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.size = CGSizeMake(10, 20);
        _titleLabel.textColor = kColorMain;
        if (kiPhone) {
            _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        }else{
            _titleLabel.font = [UIFont systemFontOfSize:19.0f];
        }
        
        _titleLabel.backgroundColor = kColorClear;
        _titleLabel.centerY = self.typeIconLabel.centerY;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


-(UIImageView *)postsImageView{
    if (!_postsImageView) {
        _postsImageView = [[UIImageView alloc] init];
        if (kiPhone) {
            _postsImageView.size = CGSizeMake(80, 80);
        }else{
            _postsImageView.size = CGSizeMake(100, 100);
        }
        
        _postsImageView.top = self.topGrayView.bottom + 10;
        _postsImageView.right = self.width - 10;
        _postsImageView.backgroundColor = kColorClear;
        _postsImageView.layer.cornerRadius = 5;
        _postsImageView.layer.masksToBounds = YES;
        _postsImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_postsImageView];
    }
    return _postsImageView;
}


-(CommunityAudioBtn *)communityAudioBtn{
    if (!_communityAudioBtn) {
        _communityAudioBtn = [[CommunityAudioBtn alloc] initWithFrame:CGRectMake(10, 0, 200, 35)];
        _communityAudioBtn.isCache = YES;//缓存
        
        [self.contentView addSubview:_communityAudioBtn];
    }
    return _communityAudioBtn;
}


-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.left = self.typeIconLabel.left;
        if (kiPhone) {
            _detailLabel.height = 50;
        }else{
            _detailLabel.height = 90;
        }
       
        
        _detailLabel.backgroundColor = kColorClear;
        _detailLabel.textColor = kColorWord;
        if (kiPhone) {
            _detailLabel.font = [UIFont systemFontOfSize:15.0f];
            _detailLabel.numberOfLines = 2;
        }else{
            _detailLabel.font = [UIFont systemFontOfSize:17.0f];
            _detailLabel.numberOfLines = 3;
        }
        
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}


-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.left = self.typeIconLabel.left;
        _userNameLabel.backgroundColor = kColorClear;
        _userNameLabel.textColor = kColorWord;
        if (kiPhone) {
            _userNameLabel.font = [UIFont systemFontOfSize:13.0f];
        }else{
            _userNameLabel.font = [UIFont systemFontOfSize:15.0f];
        }
        [self.contentView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = self.userNameLabel.font;
        _timeLabel.textColor = kColorWord;
        _timeLabel.backgroundColor = kColorClear;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)replyLabel{
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.backgroundColor = kColorClear;
        _replyLabel.textColor = kColorWord;
        _replyLabel.font = self.timeLabel.font;
        _replyLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_replyLabel];
    }
    return _replyLabel;
}

-(UIImageView *)replyImageView{
    if (!_replyImageView) {
        UIImage *image = [UIImage imageNamed:@"icon_community_replay"];
        _replyImageView = [[UIImageView alloc] initWithImage:image];
        _replyImageView.centerY = self.replyLabel.centerY;
        _replyImageView.backgroundColor = kColorClear;
        _replyImageView.size = image.size;
        _replyImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_replyImageView];
    }
    return _replyImageView;
}

-(UILabel *)zanLabel{
    if (!_zanLabel) {
        _zanLabel = [[UILabel alloc] init];
        _zanLabel.textColor = kColorWord;
        _zanLabel.backgroundColor = kColorClear;
        _zanLabel.font = self.replyLabel.font;
        _zanLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_zanLabel];
    }
    return _zanLabel;
}

-(UIImageView *)zanImageView{
    if (!_zanImageView) {
        UIImage *image = [UIImage imageNamed:@"icon_community_zan"];
        _zanImageView = [[UIImageView alloc] initWithImage:image];
        _zanImageView.size = image.size;
        _zanImageView.centerY = self.zanLabel.centerY;
        _zanImageView.backgroundColor = kColorClear;
        _zanImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_zanImageView];
    }
    return _zanImageView;
}


-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.5f)];
        _bottomLineView.backgroundColor = kColorLine2;
        _bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

-(void)dealloc{
    [self.postsImageView removeFromSuperview];
}


@end
