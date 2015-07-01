//
//  HSCommunityDetailViewController.m
//  HelloHSK
//
//  Created by Lu on 14/12/3.
//  Copyright (c) 2014年 yang. All rights reserved.
//
#import "HSCommunityDetailViewController.h"
#import "CommunityNet.h"
#import "HSCommunityView.h"

#import "CommunityDetaiModel.h"
#import "CommunityReplyModel.h"

#import "KeyChainHelper.h"

#import "MBProgressHUD.h"

#import "UIImageView+WebCache.h"
#import "HSCommunityDetailCell.h"

#import "VBFPopFlatButton.h"

#import "MJRefresh.h"

#import "HSPlaceHolderTextView.h"
#include "UINavigationController+Extern.h"
#import "MessageHelper.h"

#define kMoreRepliesCount 5

@interface HSCommunityDetailViewController ()<HSCommunityViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate>
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

@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) VBFPopFlatButton *btnAddPicture;
@property (nonatomic, strong) UIButton *btnReply;
@property (nonatomic, strong) HSPlaceHolderTextView *textReply;

@end

@implementation HSCommunityDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyBorderNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    center = self.toolView.center;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeKeyBorderNotification];
    
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
    }else{
        self.navigationController.toolbar.tintColor = kColorWhite;
    }
    
    self.navigationController.toolbar.backgroundColor = kColorWhite;
    
    self.title = MyLocal(@"详情");
    
    imgPlacehold = [UIImage imageNamed:@"image_user_placeholder"];
    // 默认为回复主帖
    replyType = 0;
    self.tableView.tableFooterView = [[UIView alloc] init];
    DLOG_CMETHOD;
    self.tableView.tableHeaderView = self.headerView;
    self.btnReply.backgroundColor = kColorWhite;
    self.textReply.backgroundColor = kColorWhite;
    //self.btnAddPicture.backgroundColor = kColorWhite;
    
    __weak HSCommunityDetailViewController *weakSelf = self;
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    //hud.labelText = [[NSString alloc] initWithFormat:@"%@...", MyLocal(@"加载")];
    [self.communityNet requestCommunityDetailWithUserID:kUserID topicID:self.topicID completion:^(BOOL finished, id result, NSError *error) {
        
        [weakSelf refreshCommmunityDetail:result];
        
        [hud hide:YES];
        if (!finished)
        {
            [weakSelf showMessage:error.domain];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UIView *)toolView
{
    if (!_toolView)
    {
        CGFloat height = kiPhone ? 45:65;
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-height, self.view.width, height)];
        _toolView.backgroundColor = kColorWhite;
        _toolView.layer.borderColor = kColorLine.CGColor;
        _toolView.layer.borderWidth = 0.5;
        _toolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_toolView];
    }
    [self.view bringSubviewToFront:_toolView];
    return _toolView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat oY = kiOS7_OR_LATER ? 0:0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, oY, self.view.width, self.toolView.top-oY) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kColorWhite;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (VBFPopFlatButton *)btnAddPicture
{
    if (!_btnAddPicture)
    {
        _btnAddPicture = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        _btnAddPicture.centerY = self.toolView.height * 0.5;
        _btnAddPicture.centerX = self.toolView.width * 0.1;
        _btnAddPicture.lineThickness = 1;
        _btnAddPicture.roundBackgroundColor = kColorWhite;
        //_btnAddPicture.roundBackgroundBorderWidth = 1.0;
        //_btnAddPicture.roundBackgroundBorderColor = kColorMain;
        _btnAddPicture.lineRadius = 0.5;
        
        _btnAddPicture.tintColor = kColorMain;
        [_btnAddPicture addTarget:self action:@selector(addPictureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:_btnAddPicture];
    }
    return _btnAddPicture;
}

- (UIButton *)btnReply
{
    if (!_btnReply)
    {
        _btnReply = [[UIButton alloc] init];
        _btnReply.bounds = CGRectMake(0, 0, 46, 30);
        _btnReply.centerY = self.toolView.height * 0.5;
        _btnReply.centerX = self.toolView.width-36;
        [_btnReply setTitle:MyLocal(@"发表") forState:UIControlStateNormal];
        [_btnReply setTitleColor:kColorBlack forState:UIControlStateNormal];
        _btnReply.titleLabel.font = [UIFont systemFontOfSize:12];;
        [_btnReply addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnReply.layer.borderWidth = 1.0;
        _btnReply.layer.borderColor = kColorMain.CGColor;
        _btnReply.layer.cornerRadius = _btnReply.height*0.5;
        _btnReply.layer.masksToBounds = YES;
        [self.toolView addSubview:_btnReply];
    }
    return _btnReply;
}

- (HSPlaceHolderTextView *)textReply
{
    if (!_textReply)
    {
        CGFloat height = kiPhone ? 30:40;
        CGFloat fontSize = kiPhone ? 15:17;
        _textReply = [[HSPlaceHolderTextView alloc] init];
        _textReply.bounds = CGRectMake(0.0, 0, self.toolView.width - self.btnReply.width*2.0f, height);
        _textReply.centerY = self.toolView.height*0.5;
        _textReply.centerX = _textReply.width*0.5+12;//self.toolView.width*0.5;
        _textReply.layer.borderWidth = 1.0f;
        _textReply.layer.borderColor = kColorMain.CGColor;
        _textReply.layer.cornerRadius = _textReply.height*0.2;
        _textReply.layer.masksToBounds = YES;
        _textReply.font = [UIFont systemFontOfSize:fontSize];
        _textReply.delegate = self;
        //_textReply.inputAccessoryView = self.toolView;
        _textReply.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        [self.toolView addSubview:_textReply];
    }
    return _textReply;
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
    self.textReply.text = @"";
    
    self.textReply.placeholder = [[NSString alloc] initWithFormat:@"@ %@", communityDetail.owner];
    [self.textReply resignFirstResponder];
    [self resetToolViewStatus];
}

- (void)resetToolViewStatus
{
    CGFloat height = kiPhone ? 30:40;
    self.textReply.height = height;
    height = kiPhone ? 45:65;
    CGFloat oldHeight = self.toolView.height;
    self.toolView.height = height;
    CGFloat factor = height - oldHeight;
    self.toolView.centerY -= factor;
    //self.toolView.center = center;
    self.textReply.centerY = height*0.5;
    self.textReply.centerX = self.textReply.width*0.5+12;
    self.tableView.height = self.toolView.top;
}

- (void)replyToMainCommunity
{
    replyType = 0;
    replyTargetID = @"";
    self.textReply.text = @"";
    
    self.textReply.placeholder = [[NSString alloc] initWithFormat:@"@ %@", communityDetail.owner];
    [self.textReply becomeFirstResponder];
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
    [self.textReply becomeFirstResponder];
    // 滚动到指定地点
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    CommunityReplyModel *communityReply = (CommunityReplyModel *)[self.arrReplies objectAtIndex:index];
    replyTargetID = [communityReply.replyID copy];
    //DLog(@"owner: %@", communityReply.owner);
    
    self.textReply.text = @"";
    self.textReply.placeholder = [[NSString alloc] initWithFormat:@"@ %@", communityReply.owner];
    
    // 重置toolview的状态。
    [self resetToolViewStatus];
}

- (void)replyAction:(id)sender
{
    __weak HSCommunityDetailViewController *weakSelf = self;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = GDLocal(@"发表...");
    
    [self.communityNet requestCommunityReplyWithUserID:kUserID topicID:self.topicID targetID:replyTargetID targetType:replyType content:self.textReply.text audio:@"" duration:0 picture:@"" thumbnail:@"" posted:[timeStamp() integerValue] completion:^(BOOL finished, id result, NSError *error) {
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
    __weak HSCommunityDetailViewController *weakSelf = self;
    NSString *mID = ((CommunityReplyModel *)self.arrReplies.lastObject).replyID;
    [self.communityNet requestCommunityMoreRepliesWithUserID:kUserID topicID:self.topicID mID:mID length:kMoreRepliesCount completion:^(BOOL finished, id result, NSError *error) {
        if (finished) {
            [weakSelf refreshCommunityMoreReplies:result];
        }
        
        [weakSelf.tableView footerEndRefreshing];
    }];
    
}

#pragma mark - 消息监听中心
// 添加监听键盘的弹出与关闭
- (void)addKeyBorderNotification
{
    //加入键盘事件的通知
    kAddObserverNotification(self, @selector(keyboardWillShow:), UIKeyboardWillShowNotification, nil);
    kAddObserverNotification(self, @selector(keyboardWillHide:), UIKeyboardWillHideNotification, nil);
}

// 移除键盘事件的监听
- (void)removeKeyBorderNotification
{
    kRemoveObserverNotification(self, UIKeyboardWillShowNotification, nil);
    kRemoveObserverNotification(self, UIKeyboardWillHideNotification, nil);
}

#pragma mark - 监听响应
//-------------> 响应键盘显示事件 <------------------------
//    【主要思想是:将整体的view随键盘往上移动】
//------------------------------------------------------
- (void)keyboardWillShow:(NSNotification *)notification
{
    DLOG_CMETHOD;
    //先设定一个低于键盘顶部的阈值.
    CGFloat startOriginY = self.toolView.bottom;
    DLog(@"startOriginY: %f", startOriginY);
    NSDictionary *userInfo = [notification userInfo];
    
    //在键盘出现时,获取键盘的顶部坐标
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    DLog(@"keyboardTop: %f", keyboardTop);
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat distanceY = keyboardTop - startOriginY;
    DLog(@"distanceY: %f", distanceY);
    //根据键盘出现时的动画动态地改变输入区域的显示位置.(即把整个view上下移动)
    CGFloat newCenterY = self.toolView.center.y + distanceY;
    DLog(@"newCenterY: %f", newCenterY);
    [UIView animateWithDuration:animationDuration animations:^{
        //将视图整体往上移动
        //根据键盘的顶部坐标,使输入框自适应,从而不被键盘遮挡.
        self.toolView.center = CGPointMake(self.toolView.center.x, newCenterY);
        self.tableView.height = self.toolView.top;
    }];
    
    if (scrollFrame.origin.y+scrollFrame.size.height > keyboardTop)
    {
        [self.tableView scrollRectToVisible:scrollFrame animated:YES];
    }
}

//-------------> 响应键盘关闭事件 <------------------------
//    【主要思想是:将整体的view随键盘移动到正常位置】
//------------------------------------------------------
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    //获取键盘上下移动时动画的时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //将视图向下恢复到正常位置,并使用动画
    [UIView animateWithDuration:animationDuration animations:^{
        self.toolView.centerY = self.view.height- self.toolView.height*0.5;
        self.tableView.height = self.toolView.top;
    }];
}

// 关闭键盘
- (void)hideKeyBoard
{
    if ([self.textReply isFirstResponder]){
        [self.textReply resignFirstResponder];
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    DLOG_CMETHOD;
    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height - ( textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    
        /*
        textView.height = textView.contentSize.height;
        CGFloat oldHeight = self.toolView.height;
        CGFloat oldCenterY = self.toolView.centerY;
        self.toolView.height = textView.contentSize.height;
        self.toolView.centerY = oldCenterY - (self.toolView.height - oldHeight);
         */
    }
    
    CGSize size = [textView.text sizeWithFont:[textView font]];
    int length = size.height;
    int colomNumber = textView.contentSize.height/length;
    if (colomNumber < 6)
    {
        CGFloat textOldHeight = textView.height;
        textView.height = textView.contentSize.height;
        
        if (textOldHeight != textView.height)
        {
            CGFloat factor = textView.height - textOldHeight;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                self.toolView.height += factor;
                self.toolView.centerY -= factor;
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
}

/*
//限制UITextView的行数，
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //内容（滚动视图）高度大于一定数值时
    if ([textView.text length] > 260)
    {
        //删除最后一行的第一个字符，以便减少一行。
        textView.text = [textView.text substringToIndex:[textView.text length]-1];
        return NO;
    }
    
    return YES;
}
 */

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
    HSCommunityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
    {
        NSArray *arrNib = [[NSBundle mainBundle] loadNibNamed:@"HSCommunityDetailCell" owner:nil options:nil];
        for (id obj in arrNib)
        {
            if ([obj isKindOfClass:[HSCommunityDetailCell class]])
            {
                cell = (HSCommunityDetailCell *)obj;
                
                break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnReply addTarget:self action:@selector(replySomeBodyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CommunityReplyModel *communityReply = [self.arrReplies objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = communityReply.owner;
    BOOL empReplyTo = [communityReply.replyTo isEqualToString:@""];
    NSString *content = empReplyTo ? [[NSString alloc] initWithFormat:@"%@", communityReply.content]:[[NSString alloc] initWithFormat:@"%@:%@", communityReply.replyTo, communityReply.content];
    cell.lblContent.text = content;
    NSURL *url = [NSURL URLWithString:communityReply.avatars];
    [cell.imgvHeader sd_setImageWithURL:url placeholderImage:imgPlacehold completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    cell.lblTime.text = [HSBaseTool postDateFromTimeIntervalSince1970:communityReply.posted];
    NSString *lou = MyLocal(@"楼");
    NSString *floor = [[NSString alloc] initWithFormat:@"%d%@", indexPath.row+1,lou];
    cell.lblFloor.text = floor;
    NSString *replied = [[NSString alloc] initWithFormat:@"  %d", communityReply.replied];
    [cell.btnReply setTitle:replied forState:UIControlStateNormal];
    cell.btnReply.tag = indexPath.row;
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
        self.headerView.height = height+self.headerView.headerHeight+self.headerView.footerHeight;
        self.tableView.tableHeaderView = self.headerView;
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
