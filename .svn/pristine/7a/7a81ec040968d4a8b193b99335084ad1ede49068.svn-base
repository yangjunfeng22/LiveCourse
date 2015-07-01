//
//  HSCommunityView.m
//  HelloHSK
//
//  Created by junfengyang on 14/12/9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCommunityView.h"
#import "UIImageView+WebCache.h"

#import "CommunityDetaiModel.h"

#import "HSVALabel.h"

#import "CommunityNet.h"

#import "KeyChainHelper.h"

#import <AVFoundation/AVFoundation.h>
#import "CommunityAudioBtn.h"

#define kLaudWidth 80
#define kLaudHeight 30
@interface HSCommunityView ()<UIWebViewDelegate>
{
    UIImage *imgPlacehold;
    NSInteger totalLaud;
}

@property (nonatomic, strong) CommunityAudioBtn *audioBtn;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIImageView *imgHeader;     // 头像
@property (nonatomic, strong) HSVALabel *lblTitle;        // 标题
@property (nonatomic, strong) HSVALabel *lblType;         // 类型标签
@property (nonatomic, strong) HSVALabel *lblTimeStamp;    // 时间戳
@property (nonatomic, strong) HSVALabel *lblFloor;        // 楼层
@property (nonatomic, strong) UIButton *btnLaud;          // 赞
@property (nonatomic, strong) UIButton *btnReply;         // 回复

@property (nonatomic, readwrite) CGFloat headerHeight;
@property (nonatomic, readwrite) CGFloat footerHeight;

@property (nonatomic, strong) CommunityNet *communityNet;

@end

@implementation HSCommunityView


- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        imgPlacehold = [UIImage imageNamed:@"image_user_placeholder"];
        NSString *laud = [[NSString alloc] initWithFormat:@"  %@(%d)", MyLocal(@"赞"), totalLaud];
        [self.btnLaud setTitle:laud forState:UIControlStateNormal];;
        [self.btnReply setTitle:MyLocal(@"回复") forState:UIControlStateNormal];;
    }
    
    return self;
}

- (void)dealloc
{
    DLOG_CMETHOD;
    _audioBtn = nil;
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:NULL];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


-(CommunityAudioBtn *)audioBtn{
    if (!_audioBtn) {
        CGFloat left = 15;
        _audioBtn = [[CommunityAudioBtn alloc] initWithFrame:CGRectMake(left, self.headerView.bottom + 10, self.width - left * 2, 35)];
        _audioBtn.isCache = YES;//缓存
        [self addSubview:_audioBtn];
    }
    return _audioBtn;
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.width, self.height-self.headerView.height)];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
        //_webView.allowsInlineMediaPlayback = YES;
        _webView.scalesPageToFit = YES;
        _webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self addSubview:_webView];
    }
    
    return _webView;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        CGFloat height = kiPhone ? 50:80;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, height)];
        //_headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _headerView.backgroundColor = kColorMainWithA(0.05);
        [self addSubview:_headerView];
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        CGFloat height = kiPhone ? 50:80;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.webView.bottom, self.width, height)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _footerView.backgroundColor = kColorWhite;
        _footerView.layer.borderWidth = 0.5;
        _footerView.layer.borderColor = kColorLine.CGColor;
        [self addSubview:_footerView];
    }
    return _footerView;
}

- (UIImageView *)imgHeader
{
    if (!_imgHeader)
    {
        CGFloat height = self.headerView.height;
        _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(10, height*0.1f, height*0.8, height*0.8)];
        _imgHeader.layer.cornerRadius = height*0.4;
        _imgHeader.layer.masksToBounds = YES;
        [_imgHeader sd_setImageWithURL:nil placeholderImage:imgPlacehold];
        
        [self.headerView addSubview:_imgHeader];
    }
    
    return _imgHeader;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        CGFloat height = self.headerView.height;
        CGFloat fontSize = kiPhone ? 18:22;
        _lblTitle = [[HSVALabel alloc] initWithFrame:CGRectMake(self.imgHeader.right+self.imgHeader.left, 0, self.width*0.3, height*0.5f)];
        _lblTitle.backgroundColor = kColorClear;
        _lblTitle.textColor = kColorMain;
        _lblTitle.font = [UIFont systemFontOfSize:fontSize];
        _lblTitle.verticalAlignment = VerticalAlignmentBottom;
        [self.headerView addSubview:_lblTitle];
    }
    return _lblTitle;
}

- (UILabel *)lblType
{
    if (!_lblType)
    {
        CGFloat height = kiPhone ? 14:16;
        CGFloat fontSize = kiPhone ? 10:15;
        _lblType = [[HSVALabel alloc] initWithFrame:CGRectMake(self.lblTitle.right, 0, 38, height)];
        _lblType.textColor = kColorWhite;
        _lblType.backgroundColor = [UIColor redColor];
        _lblType.layer.cornerRadius = height*0.5f;
        _lblType.layer.shouldRasterize = YES;
        _lblType.layer.masksToBounds = YES;
        _lblType.textAlignment = NSTextAlignmentCenter;
        _lblType.font = [UIFont systemFontOfSize:fontSize];
        _lblType.centerY = self.lblTitle.centerY;
        [self.headerView addSubview:_lblType];
    }
    return _lblType;
}

- (HSVALabel *)lblTimeStamp
{
    if (!_lblTimeStamp)
    {
        CGFloat fontSize = kiPhone ? 12:16;
        _lblTimeStamp = [[HSVALabel alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom+6, self.width*0.8, 14)];
        _lblTimeStamp.verticalAlignment = VerticalAlignmentBottom;
        _lblTimeStamp.backgroundColor = kColorClear;
        _lblTimeStamp.textColor = [UIColor lightGrayColor];
        _lblTimeStamp.font = [UIFont systemFontOfSize:fontSize];
        [self.headerView addSubview:_lblTimeStamp];
    }
    return _lblTimeStamp;
}

- (HSVALabel *)lblFloor
{
    if (!_lblFloor)
    {
        CGFloat fontSize = kiPhone ? 10:16;
        _lblFloor = [[HSVALabel alloc] initWithFrame:CGRectMake(self.headerView.width-self.width*0.12, 0, self.width*0.1, 12)];
        _lblFloor.verticalAlignment = VerticalAlignmentBottom;
        _lblFloor.backgroundColor = kColorClear;
        _lblFloor.textAlignment = NSTextAlignmentRight;
        _lblFloor.textColor = [UIColor darkGrayColor];
        _lblFloor.font = [UIFont systemFontOfSize:fontSize];
        _lblFloor.text = MyLocal(@"楼主");
        [self.headerView addSubview:_lblFloor];
        [_lblFloor sizeToFit];
        _lblFloor.centerX = self.headerView.width - _lblFloor.width*0.6;
    }
    return _lblFloor;
}

- (UIButton *)btnLaud
{
    if (!_btnLaud)
    {
        CGFloat height = kLaudHeight * (kiPhone ? 1:1.3);
        CGFloat width = kLaudWidth * (kiPhone ? 1:1.3);
        CGFloat fontSize = kiPhone ? 13:16;
        _btnLaud = [[UIButton alloc] initWithFrame:CGRectMake(self.footerView.width*0.5-width*1.4, (self.footerView.height-height)*0.5, width, height)];
        _btnLaud.layer.borderWidth = 0.5;
        _btnLaud.layer.borderColor = kColorBoardWithA(0.5).CGColor;
        _btnLaud.layer.cornerRadius = height*0.5;
        _btnLaud.layer.masksToBounds = YES;
        _btnLaud.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [_btnLaud setTitleColor:kColorWord forState:UIControlStateNormal];
        [_btnLaud setTitleColor:kColorWhite forState:UIControlStateHighlighted];
        [_btnLaud setImage:[UIImage imageNamed:@"icon_community_zan"] forState:UIControlStateNormal];
        [_btnLaud addTarget:self action:@selector(laudAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:_btnLaud];
    }
    return _btnLaud;
}

- (UIButton *)btnReply
{
    if (!_btnReply)
    {
        CGFloat height = kLaudHeight * (kiPhone ? 1:1.3);
        CGFloat width = kLaudWidth * (kiPhone ? 1:1.3);
        CGFloat fontSize = kiPhone ? 13:16;
        _btnReply = [[UIButton alloc] initWithFrame:CGRectMake(self.footerView.width*0.5+width*0.4, (self.footerView.height-height)*0.5, width, height)];
        _btnReply.backgroundColor = kColorMain;
        _btnReply.layer.borderWidth = 0.5;
        _btnReply.layer.borderColor = kColorLine.CGColor;
        _btnReply.layer.cornerRadius = height*0.5;
        _btnReply.layer.masksToBounds = YES;
        _btnReply.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [_btnReply setTitleColor:kColorWhite forState:UIControlStateNormal];
        //[_btnReply setImage:[UIImage imageNamed:@"community_icon"] forState:UIControlStateNormal];
        //[_btnReply setTitle:MyLocal(@"回复楼主") forState:UIControlStateNormal];
        [_btnReply addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:_btnReply];
    }
    return _btnReply;
}

- (CGFloat)headerHeight
{
    _headerHeight = self.headerView.height;
    return _headerHeight;
}

- (CGFloat)footerHeight
{
    _footerHeight = self.footerView.height;
    return _footerHeight;
}

- (CommunityNet *)communityNet
{
    if (!_communityNet) _communityNet = [[CommunityNet alloc] init];
    return _communityNet;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lblFloor.centerY = self.lblTitle.centerY;
    self.footerView.top = self.webView.bottom;
}

- (void)laudAction:(id)sender
{
    if (!self.communityDetail.praised)
    {
        // 立即就加上这个赞的数量
        self.communityDetail.liked++;
        self.communityDetail.praised = YES;
        
        CGFloat oldWidth = self.btnLaud.titleLabel.width;
        CGFloat oldCX = self.btnLaud.centerX;
        
        NSString *laud = [[NSString alloc] initWithFormat:@"  %@(%d)", MyLocal(@"赞"), self.communityDetail.liked];
        [self.btnLaud setTitle:laud forState:UIControlStateNormal];
        [self.btnLaud.titleLabel sizeToFit];
        
        CGFloat newWidth = self.btnLaud.titleLabel.width;
        CGFloat widthFactor = newWidth - oldWidth;
        self.btnLaud.width += widthFactor;
        self.btnLaud.centerX = oldCX;
        // 刷新赞的按钮的状态
        [self refreshLikeButtonStatusPraised:YES];
        // 发送赞的请求
        [self sendLaudRequest];
    }
}

- (void)sendLaudRequest
{
    __weak HSCommunityView *weakSelf = self;
    
    [self.communityNet requestCommunityLaudWithUserID:kUserID topicID:self.communityDetail.topicID targetID:self.communityDetail.topicID targetType:0 action:1 completion:^(BOOL finished, id result, NSError *error) {
        if (finished){
            // 更新赞的信息成功
            [weakSelf addLaud];
        }else{
            // 更新赞的信息失败，重新更新。
            //[weakSelf sendLaudRequest];
        }
    }];
}

- (void)replyAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityView:replyAction:)])
    {
        [self.delegate communityView:self replyAction:sender];
    }
}

- (void)addLaud
{
    totalLaud ++;
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityView:finishedLaud:)])
    {
        [self.delegate communityView:self finishedLaud:totalLaud];
    }
}

#pragma mark - 设置
- (void)setCommunityDetail:(CommunityDetaiModel *)communityDetail
{
    DLOG_CMETHOD;
    _communityDetail = communityDetail;
    
    NSURL *url = [NSURL URLWithString:communityDetail.avatars];
    [self.imgHeader sd_setImageWithURL:url placeholderImage:imgPlacehold completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    self.lblTitle.text = communityDetail.owner;
    [self.lblTitle sizeToFit];
    self.lblTitle.centerY = (self.headerView.height-self.lblTitle.height)*0.5;
    
    self.lblTimeStamp.text = [HSBaseTool postDateFromTimeIntervalSince1970:communityDetail.posted];
    self.lblType.text = communityDetail.tagName;
    [self.lblType sizeToFit];
    self.lblType.left = self.lblTitle.right+6;
    self.lblType.width = self.lblType.width*1.5;
    self.lblType.height = self.lblType.height*1.1;
    self.lblType.centerY = self.lblTitle.centerY;
    
    totalLaud = communityDetail.liked;
    NSString *laud = [[NSString alloc] initWithFormat:@"  %@(%@)", MyLocal(@"赞"), @(totalLaud)];
    [self.btnLaud setTitle:laud forState:UIControlStateNormal];
    [self refreshLikeButtonStatusPraised:communityDetail.praised];
    //NSString *reply = [[NSString alloc] initWithFormat:@"  %d", communityDetail.replied];
    
    //NSString *content = @"<html><head><link href=\"index.css\" rel=\"stylesheet\" type=\"text/css\"><script type=\"text/javascript\"language=\"javascript\"src=\"index.js\"></head><body><p>This is local Image</p><img src=\"Smiley.png\" width=\"50\" height=\"50\" /><hr/><p>this is local image from CSS.</p><div id=\"myimage\"> </div><hr/><p>this is external image.</p><img src=\"http://imglf9.ph.126.net/F37NyhuzmvHJChMARbFmHA==/1010495166409149719.jpg\" width=\"300\" height=\"200\" /></body></html>";
    
    
    DLog(@"content: %@", communityDetail.content);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.webView loadHTMLString:communityDetail.content baseURL:[NSURL URLWithString:@"http://hellohsk.com"]];
    });
    
    if (![NSString isNullString:communityDetail.audio]) {
        self.audioBtn.duration = communityDetail.duration;
        self.audioBtn.audioUrl = communityDetail.audio;
        
        self.webView.top = self.audioBtn.bottom;
        
    }else{
        [self.audioBtn removeFromSuperview];
        self.webView.top = self.headerView.bottom;
    }
}

#pragma mark - 刷新
- (void)refreshLikeButtonStatusPraised:(BOOL)praised
{
    if (praised)
    {
        self.btnLaud.backgroundColor = [UIColor orangeColor];
        //self.btnLaud.highlighted = YES;
        [_btnLaud setTitleColor:kColorWhite forState:UIControlStateNormal];
        [_btnLaud setImage:[UIImage imageNamed:@"ico_like_white"] forState:UIControlStateNormal];
        //self.btnLaud.userInteractionEnabled = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        //DLog(@"change: %@", change);
        NSValue *oValue = [change objectForKey:@"old"];
        NSValue *nValue = [change objectForKey:@"new"];
        CGFloat oHeight = [oValue CGSizeValue].height;
        CGFloat nHeight = [nValue CGSizeValue].height;
        if (oHeight != nHeight)
        {
            self.webView.scrollView.height = nHeight;
            self.webView.height = nHeight;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(communityView:didFinishLoad:)])
            {
                [self.delegate communityView:self didFinishLoad:nHeight];
            }
        }
    }
}

#pragma mark - UIWebview Delegate
/*
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    CGFloat height = webView.scrollView.contentSize.height;
    [UIView animateWithDuration:0.3f animations:^{
        webView.scrollView.height = height;
        webView.height = height;
    }];
}
*/
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityView:didFinishLoad:)])
    {
        [self.delegate communityView:self didFinishLoad:self.webView.height];
    }
}

@end
