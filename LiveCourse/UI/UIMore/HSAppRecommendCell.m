//
//  HSAppRecommendCell.m
//  HelloHSK
//
//  Created by yang on 14-4-17.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAppRecommendCell.h"
#import "UIImage+Extra.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"

@interface HSAppRecommendCell ()<SDWebImageManagerDelegate>
@property (nonatomic, strong) UIImageView *appImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation HSAppRecommendCell
{
    UIActivityIndicatorView *activityIndicatorView;
    UIImage *imgPlacehold;
    CGSize imgPSize;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        imgPlacehold = [UIImage imageNamed:@"img_community_placeholder"];
        imgPSize = [imgPlacehold size];
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)prepareForReuse{
    self.appImageView.image = nil;
}


-(void)setRecommendModel:(RecommendModel *)recommendModel{
    
    NSURL *imgUrl = [NSURL URLWithString:recommendModel.appIcoURL];
    [self.appImageView sd_setImageWithURL:imgUrl placeholderImage:imgPlacehold completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    self.titleLabel.text = recommendModel.appName;
    self.detailLabel.text = recommendModel.appDescription;
}

-(UIImageView *)appImageView{
    if (!_appImageView) {
        _appImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kTableViewRowHeight*2 - 20, kTableViewRowHeight*2 - 20)];
        [self.contentView addSubview:_appImageView];
    }
    return _appImageView;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        CGFloat left = self.appImageView.right + 10;
        _titleLabel.left = left;
        _titleLabel.top = 20;
        _titleLabel.width = self.width - left - 10;
        _titleLabel.height = 25;
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.backgroundColor = kColorClear;
        
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.left = self.titleLabel.left;
        _detailLabel.top = self.titleLabel.bottom;
        _detailLabel.width = self.titleLabel.width;
        _detailLabel.height = 20;
        _detailLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}


-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)dealloc
{
    imgPlacehold = nil;
    _appImageView = nil;
    _titleLabel = nil;
    _detailLabel = nil;
    
    
}

@end
