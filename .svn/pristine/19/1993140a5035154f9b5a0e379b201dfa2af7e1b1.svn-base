//
//  HSCommunityDetailViewCell.m
//  LiveCourse
//
//  Created by Lu on 15/6/10.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCommunityDetailViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Extra.h"


@interface HSCommunityDetailViewCell ()

@property (strong, nonatomic) UIImageView *userHeadImgView; //用户头像
@property (strong, nonatomic) UILabel *userNameLabel;       //用户名
@property (strong, nonatomic) UILabel *floorLabel;          //楼层
@property (strong, nonatomic) UILabel *timeLabel;           //时间

@property (strong, nonatomic) UILabel *contentLabel;        //内容

@end

@implementation HSCommunityDetailViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;

}

- (void)awakeFromNib {
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


/**
 *  填充数据
 *
 *  @param communityReplyModel <#communityReplyModel description#>
 */
-(void)setCommunityReplyModel:(CommunityReplyModel *)communityReplyModel andFloor:(NSInteger)floor{
    
    _communityReplyModel = communityReplyModel;
    
    //头像
    NSURL *url = [NSURL URLWithString:communityReplyModel.avatars];
    [self.userHeadImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_community_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        self.userHeadImgView.image = [image thumbnailImage:200];
    }];
    
    
    //楼层
    NSString *lou = MyLocal(@"楼");
    NSString *floorStr = [[NSString alloc] initWithFormat:@"%d%@", floor+1,lou];
    self.floorLabel.text = floorStr;
    [self.floorLabel sizeToFit];
    self.floorLabel.right = self.width - 10;
    self.floorLabel.top = 10;
    
    
    //用户名
    CGFloat userNameWidth = self.floorLabel.left - self.userNameLabel.left - 10;
    self.userNameLabel.width = userNameWidth;
    self.userNameLabel.text = communityReplyModel.owner;
    
    
    //时间
    self.timeLabel.text = [HSBaseTool postDateFromTimeIntervalSince1970:communityReplyModel.posted];
    
    
    CGFloat contentLabelTop = self.timeLabel.bottom + 10;
    
    //音频
    if (![NSString isNullString:communityReplyModel.audio]) {
        //如果有音频
        self.audioBtn.audioUrl = communityReplyModel.audio;
        self.audioBtn.duration = communityReplyModel.duration;
        [self addSubview:self.audioBtn];
        contentLabelTop = self.audioBtn.bottom + 10;
    }else{
        [self.audioBtn removeFromSuperview];
        self.audioBtn = nil;
        
        contentLabelTop = self.timeLabel.bottom + 10;
    }
    
    //内容
    self.contentLabel.top = contentLabelTop;
    
    BOOL empReplyTo = [NSString isNullString:communityReplyModel.replyTo];
    NSString *content = empReplyTo ? [[NSString alloc] initWithFormat:@"%@", communityReplyModel.content]:[[NSString alloc] initWithFormat:@"%@:%@", communityReplyModel.replyTo, communityReplyModel.content];
    self.contentLabel.text = content;
    
    CGFloat width = self.width - self.userNameLabel.left - 10;
    self.contentLabel.width = width;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];

    //回复
    
    NSString *replied = [[NSString alloc] initWithFormat:@"  %d", communityReplyModel.replied];
    [self.btnReply setTitle:replied forState:UIControlStateNormal];
    
    [self.btnReply sizeToFit];
    self.btnReply.width += 10;
    self.btnReply.height += 6;
    self.btnReply.layer.cornerRadius = self.btnReply.height*0.5;
    self.btnReply.bottom = self.height - 10;
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.btnReply.bottom = self.height - 10;
    self.btnReply.right = self.width - 10;
}




#pragma mark - UI
-(UIImageView *)userHeadImgView{

    if (!_userHeadImgView) {
        _userHeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
        
        _userHeadImgView.layer.cornerRadius = 20;
        _userHeadImgView.layer.masksToBounds = YES;
        _userHeadImgView.backgroundColor = kColorClear;
        
        [self.contentView addSubview:_userHeadImgView];
    }
    return _userHeadImgView;
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        CGFloat left = self.userHeadImgView.right + 10;
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 10, 0, 20)];
        _userNameLabel.backgroundColor = kColorClear;
        _userNameLabel.textColor = kColorMain;
        _userNameLabel.font = [UIFont systemFontOfSize:16.0f];
        
        [self.contentView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

-(UILabel *)floorLabel{
    if (!_floorLabel) {
        _floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
        _floorLabel.backgroundColor = kColorClear;
        _floorLabel.font = [UIFont systemFontOfSize:12.0f];
        _floorLabel.textColor = kColorWord;
        [self.contentView addSubview:_floorLabel];
    }
    return _floorLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userNameLabel.left, self.userNameLabel.bottom, self.userNameLabel.width, 15)];
        _timeLabel.backgroundColor = kColorClear;
        _timeLabel.textColor = kColorWord;
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}


-(CommunityAudioBtn *)audioBtn{
    if (!_audioBtn) {
        CGFloat width = self.width - self.userNameLabel.left - 10;
        _audioBtn = [[CommunityAudioBtn alloc] initWithFrame:CGRectMake(self.userNameLabel.left, self.timeLabel.bottom + 10, width, 30)];
        _audioBtn.isCache = NO;
        
    }
    return _audioBtn;
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        CGFloat width = self.width - self.userNameLabel.left - 10;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userNameLabel.left, 0, width, 50)];
        
        _contentLabel.backgroundColor = kColorClear;
        _contentLabel.textColor = kColorWord;
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}


-(UIButton *)btnReply{
    if (!_btnReply) {
        _btnReply = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnReply.frame = CGRectMake(0, 0, 20, 30);
        _btnReply.backgroundColor = kColorClear;
        [_btnReply setTitleColor:kColorWord forState:UIControlStateNormal];
        [_btnReply setImage:[UIImage imageNamed:@"icon_community_replay"] forState:UIControlStateNormal];
        _btnReply.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _btnReply.layer.borderWidth = 0.5;
        _btnReply.layer.borderColor = kColorLine.CGColor;
        _btnReply.layer.cornerRadius = self.btnReply.height*0.5;
        _btnReply.layer.masksToBounds = YES;
        _btnReply.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_btnReply];
    }
    return _btnReply;
}

@end
