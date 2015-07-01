//
//  HSCommunityDetailViewController.m
//  HelloHSK
//
//  Created by Lu on 14/12/3.
//  Copyright (c) 2014年 yang. All rights reserved.
//
#import "HSCommunityDetailVC.h"
#import "CommunityNet.h"
#import "HSCommunityView.h"

#import "CommunityDetaiModel.h"
#import "CommunityReplyModel.h"

#import "KeyChainHelper.h"

#import "MBProgressHUD.h"

#import "UIImageView+WebCache.h"
//#import "HSCommunityDetailCell.h"
#import "HSCommunityDetailViewCell.h"

#import "VBFPopFlatButton.h"

#import "MJRefresh.h"

#import "HSPlaceHolderTextView.h"
#include "UINavigationController+Extern.h"
#import "MessageHelper.h"
#import "KeyboardToolBar.h"

#define kMoreRepliesCount 5

@interface HSCommunityDetailVC ()<HSCommunityViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate,KeyboardToolBarDelegate,CommunityAudioBtnDelegate>
{
    NSInteger curReplies;
    // 回复的总数
    NSInteger totalReplies;
    // 赞的总数
    NSInteger totalLaud;
    UIImage *imgPlacehold;
    CommunityDetaiModel *communityDetail;
    
    // 回复的类型
    NSInteger replyType;
    
    // 回复的目标ID
    NSString *replyTargetID;
    
    CGPoint center;
    
    CGRect scrollFrame;
}

@property (nonatomic, strong) CommunityNet *communityNet;
@property (nonatomic, strong) HSCommunityView *headerView;
@property (nonatomic, strong) NSMutableArray *arrReplies;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KeyboardToolBar *keyboardToolBar;


@end

@implementation HSCommunityDetailVC
{
    CGFloat tableViewHeight;
    NSInteger currentAudioRow;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if (self.topicID)
    {
        NSDictionary *dicUserInfo = @{@"TopicID":self.topicID, @"Liked":[NSNumber numberWithInteger:totalLaud], @"Replied":[NSNumber numberWithInteger:totalReplies]};
        kPostNotification(kRefreshCommunityLaudAndReplyCount, nil, dicUserInfo);
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorWhite;
    
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    if (kiOS7_OR_LATER) {
        self.navigationController.toolbar.barTintColor = kColorWhite;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
        self.navigationController.toolbar.tintColor = kColorWhite;
    }
    
    self.navigationController.toolbar.backgroundColor = kColorWhite;
    
    self.title = MyLocal(@"详情");
    
    imgPlacehold = [UIImage imageNamed:@"image_user_placeholder"];
    // 默认为回复主帖
    replyType = 0;

    currentAudioRow = -1;
    
    //初始化table和键盘 注意初始化先后顺序 不能交叉
    self.keyboardToolBar.backgroundColor = kColorFABackground;
    
    tableViewHeight = self.keyboardToolBar.top - (kiOS7_OR_LATER ? 64 : -40);
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    DLOG_CMETHOD;
    self.tableView.tableHeaderView = self.headerView;
    
    self.keyboardToolBar.changeTableView = self.tableView;
    
    NSInteger replyLimit = [USER_DEFAULT integerForKey:@"ReplyLimit"];
    
    self.keyboardToolBar.maxRecodeTime = replyLimit;
    
    
    __weak HSCommunityDetailVC *weakSelf = self;
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self.communityNet requestCommunityDetailWithUserID:kUserID topicID:self.topicID completion:^(BOOL finished, id result, NSError *error) {
        
        [weakSelf refreshCommmunityDetail:result];
        
        [hud hide:YES];
        if (!finished)
        {
            [weakSelf showMessage:error.domain];
        }
    }];
}

- (void)dealloc
{
    DLOG_CMETHOD;
    [_communityNet cancel];
    _communityNet = nil;
    
    [_headerView removeFromSuperview];
    _headerView = nil;
    
    _tableView.tableHeaderView = nil;
}

#pragma mark - get
- (CommunityNet *)communityNet
{
    if (!_communityNet) _communityNet = [[CommunityNet alloc] init];
    return _communityNet;
}

- (HSCommunityView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[HSCommunityView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 100)];
        _headerView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth;
        _headerView.backgroundColor = kColorWhite;
        _headerView.delegate = self;
        _headerView.height += _headerView.footerHeight;
    }
    return _headerView;
}

- (NSMutableArray *)arrReplies
{
    if (!_arrReplies) _arrReplies = [[NSMutableArray alloc] initWithCapacity:2];
    return _arrReplies;
    
}


-(KeyboardToolBar *)keyboardToolBar{
    if (!_keyboardToolBar) {
        
        _keyboardToolBar = [[KeyboardToolBar alloc] init];
        
        _keyboardToolBar.backgroundColor = kColorFABackground;
        
        CGFloat bottom = self.view.height - (kiOS7_OR_LATER ? 0 : 44);
        _keyboardToolBar.bottom = bottom;
        _keyboardToolBar.viewController = self;
        _keyboardToolBar.isChangeViewFrame = NO;
        _keyboardToolBar.isShowImgBtn = NO;
        _keyboardToolBar.delegate = self;
        
        [self.view addSubview:_keyboardToolBar];
    }
    [self.view bringSubviewToFront:_keyboardToolBar];
    return _keyboardToolBar;
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat oY = kiOS7_OR_LATER ? 64:0;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, oY, self.view.width,tableViewHeight) style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kColorWhite;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - set
- (void)setTopicID:(NSString *)topicID
{
    _topicID = topicID;
    /*
     __weak HSCommunityDetailViewController *weakSelf = self;
     
     __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.mode = MBProgressHUDModeIndeterminate;
     //hud.labelText = [[NSString alloc] initWithFormat:@"%@...", MyLocal(@"加载")];
     [self.communityNet requestCommunityDetailWithUserID:kUserID topicID:topicID completion:^(BOOL finished, id result, NSError *error) {
     
     [weakSelf refreshCommmunityDetail:result];
     
     [hud hide:YES];
     if (!finished)
     {
     [weakSelf showMessage:error.domain];
     }
     }];
     */
}

#pragma mark - 显示消息
- (void)showMessage:(NSString *)message
{
    [MessageHelper makeToastWithMessage:message view:self.view];
}

#pragma mark - 刷新
- (void)refreshCommmunityDetail:(id)detail
{
    communityDetail = [detail copy];
    self.headerView.communityDetail = communityDetail;
    [self.arrReplies setArray:communityDetail.replies];
    curReplies = [self.arrReplies count];
    totalReplies = communityDetail.replied;
    totalLaud = communityDetail.liked;
    [self.tableView reloadData];
    
    if (curReplies > 0)
    {
        [self.tableView addFooterWithTarget:self action:@selector(loadMoreReplies:)];
        self.tableView.footerPullToRefreshText = GDLocal(@"更多..");
        self.tableView.footerReleaseToRefreshText = GDLocal(@"松开即可刷新");
        self.tableView.footerRefreshingText = GDLocal(@"正在加载数据");
    }
    [self reInitTextInputStatu];
}

// 回到原始的输入框的状态
- (void)reInitTextInputStatu
{
    replyType = 0;
    replyTargetID = @"";

    self.keyboardToolBar.contentTextField.text = @"";
    [self.keyboardToolBar renewStatus];

    self.keyboardToolBar.contentTextFieldPlaceholder = [[NSString alloc] initWithFormat:@"@ %@", communityDetail.owner];
    if ([self.keyboardToolBar.contentTextField isFirstResponder]) {
        [self.keyboardToolBar.contentTextField resignFirstResponder];
    }
    
    
    [self resetToolViewStatus];
}

- (void)resetToolViewStatus
{
//    CGFloat height = kiPhone ? 30:40;
//    self.textReply.height = height;
//    height = kiPhone ? 45:65;
//    CGFloat oldHeight = self.toolView.height;
//    self.toolView.height = height;
//    CGFloat factor = height - oldHeight;
//    self.toolView.centerY -= factor;
//    //self.toolView.center = center;
//    self.textReply.centerY = height*0.5;
//    self.textReply.centerX = self.textReply.width*0.5+12;
//    self.tableView.height = self.toolView.top;
}

- (void)replyToMainCommunity
{
    replyType = 0;
    replyTargetID = @"";
    self.keyboardToolBar.contentTextField.text = @"";

    self.keyboardToolBar.contentTextFieldPlaceholder = [[NSString alloc] initWithFormat:@"@ %@", communityDetail.owner];

    if (![self.keyboardToolBar.contentTextField isFirstResponder]) {
        [self.keyboardToolBar.contentTextField becomeFirstResponder];
    }
    
    [self resetToolViewStatus];
}

- (void)refreshCommunityReply:(CommunityReplyModel *)communityReply
{
    [self.arrReplies insertObject:[communityReply copy] atIndex:0];
    curReplies = [self.arrReplies count];
    totalReplies++;
    
    UITableViewHeaderFooterView *headerView = [self.tableView headerViewForSection:0];
    NSString *replied = [[NSString alloc] initWithFormat:@"%@(%d)", MyLocal(@"跟帖"), totalReplies];
    headerView.textLabel.text = replied;
    
    if (1 == replyType) {
        // 如果回复的是回复的内容。
        // 那么需要刷新回复里面的回复数量
        for (CommunityReplyModel *communityReply in self.arrReplies)
        {
            if ([communityReply.replyID isEqualToString:replyTargetID])
            {
                communityReply.replied++;
                break;
            }
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
    if (self.tableView.height < self.tableView.contentSize.height) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)refreshCommunityMoreReplies:(NSArray *)arrCommunityReply
{
    [self.arrReplies addObjectsFromArray:arrCommunityReply];
    curReplies = [self.arrReplies count];
    [self.tableView reloadData];
}

#pragma mark - Button Action
- (void)replySomeBodyAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    replyType = 1;
    [self.keyboardToolBar.contentTextField becomeFirstResponder];
    
    // 滚动到指定地点
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    CommunityReplyModel *communityReply = (CommunityReplyModel *)[self.arrReplies objectAtIndex:index];
    replyTargetID = [communityReply.replyID copy];

    self.keyboardToolBar.contentTextField.text = @"";
    self.keyboardToolBar.contentTextFieldPlaceholder = [[NSString alloc] initWithFormat:@"@ %@", communityReply.owner];
    // 重置toolview的状态。
//    [self resetToolViewStatus];
}


-(void)keyboardToolBarDelegateSendBtnClick{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    NSString *textStr = self.keyboardToolBar.contentTextField.text;
    
    //音频
    NSData *audioData = [NSData dataWithData:self.keyboardToolBar.audioData];
    NSString *audioDataString = audioData ? [audioData base64Encoding] : @"";
    NSString *audioSafeString = [NSString safeString:audioDataString];
    NSInteger duration = self.keyboardToolBar.duration;
    
    
    if ([NSString isNullString:textStr] && [NSString isNullString:audioSafeString]) {
        
        [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:MyLocal(@"内容不能为空") isHide:YES position:HUDYOffSetPositionCenter];
        return;
    }
    
    __weak HSCommunityDetailVC *weakSelf = self;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = GDLocal(@"发表...");
    
    
    [self.communityNet requestCommunityReplyWithUserID:kUserID topicID:self.topicID targetID:replyTargetID targetType:replyType content:textStr audio:audioSafeString duration:duration picture:@"" thumbnail:@"" posted:[timeStamp() integerValue] completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        if (finished)
        {
            [weakSelf refreshCommunityReply:result];
            [weakSelf reInitTextInputStatu];
        }
        else
        {
            [weakSelf showMessage:error.domain];
        }
    }];
}

- (void)addPictureAction:(id)sender
{
    VBFPopFlatButton *btn = (VBFPopFlatButton *)sender;
    
    if (btn.currentButtonType == buttonAddType) {
        [btn animateToType:buttonCloseType];
    }else{
        [btn animateToType:buttonAddType];
    }
}

- (void)loadMoreReplies:(id)sender
{
    __weak HSCommunityDetailVC *weakSelf = self;
    NSString *mID = ((CommunityReplyModel *)self.arrReplies.lastObject).replyID;
    [self.communityNet requestCommunityMoreRepliesWithUserID:kUserID topicID:self.topicID mID:mID length:kMoreRepliesCount completion:^(BOOL finished, id result, NSError *error) {
        if (finished) {
            [weakSelf refreshCommunityMoreReplies:result];
        }
        
        [weakSelf.tableView footerEndRefreshing];
    }];
}

// 关闭键盘
- (void)hideKeyBoard
{
    [self.keyboardToolBar KeyboardToolBarResignFirstResponder];
}

#pragma mark - communityAudioBtnDelegateDidStartPlaying

-(void)communityAudioBtnDelegateDidStartPlaying:(CommunityAudioBtn *)voiceBubble{
    currentAudioRow = voiceBubble.tag;
}

-(void)communityAudioBtnDelegateDidEndPlaying:(CommunityAudioBtn *)voiceBubble{
    currentAudioRow = -1;
}



#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideKeyBoard];
        });
    });
}

#pragma mark - UITableview Datasource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return curReplies;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageListCell";
    HSCommunityDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
    {
        cell = [[HSCommunityDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell.btnReply addTarget:self action:@selector(replySomeBodyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CommunityReplyModel *communityReply = [self.arrReplies objectAtIndex:indexPath.row];
    
    [cell setCommunityReplyModel:communityReply andFloor:indexPath.row];
    cell.btnReply.tag = indexPath.row;
    
    
    if (![NSString isNullString:communityReply.audio]) {
        cell.audioBtn.delegate = self;
        cell.audioBtn.tag = indexPath.row;
        
        if (indexPath.row == currentAudioRow) {
            [cell.audioBtn startAnimating];
        } else {
            [cell.audioBtn stopAnimating];
        }
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = tableView.width - 72;
    CommunityReplyModel *communityReply = [self.arrReplies objectAtIndex:indexPath.row];
    
    CGFloat fontSize = kiPhone ? 14:17;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = [communityReply.content sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = 108 + size.height;
    
    if (![NSString isNullString:communityReply.audio] ) {
        height += 40;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kiPhone ? 30:38;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView headerViewForSection:section];
    if (!headerView)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"Header"];
        headerView.frame = CGRectMake(0, 0, tableView.width, kiPhone ? 30:38);
        headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        headerView.contentView.backgroundColor = kColorMainWithA(0.1);
        headerView.tintColor = kColorMainWithA(0.1);
        headerView.textLabel.textColor = kColorWord;
        headerView.textLabel.font = [UIFont systemFontOfSize:10];
    }
    NSString *replied = [[NSString alloc] initWithFormat:@"%@(%d)", MyLocal(@"跟帖"), totalReplies];
    headerView.textLabel.text = replied;
    return headerView;
}

#pragma mark - CommunityView Delegate
- (void)communityView:(HSCommunityView *)view didFinishLoad:(CGFloat)height
{
    self.tableView.tableHeaderView = nil;
    [UIView animateWithDuration:0.3f animations:^{
        
        CGFloat audioHeight = 0;
        if (![NSString isNullString:communityDetail.audio]) {
            audioHeight = 45;
        }
        
        self.headerView.height = height + audioHeight +self.headerView.headerHeight+self.headerView.footerHeight;
        self.tableView.tableHeaderView = self.headerView;
        [self.tableView reloadData];
    }];
}

- (void)communityView:(HSCommunityView *)view replyAction:(id)sender
{
    scrollFrame = [self.view convertRect:view.frame fromView:view];
    [self replyToMainCommunity];
    
}

- (void)communityView:(HSCommunityView *)view finishedLaud:(NSInteger)laud
{
    totalLaud = laud;
    
}

@end
