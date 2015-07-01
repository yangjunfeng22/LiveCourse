//
//  HSMessageListView.m
//  HelloHSK
//
//  Created by yang on 14-7-2.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMessageListView.h"
#import "HSMessageListCell.h"

#import "MessageModel.h"
#import "MessageNet.h"
#import "KeyChainHelper.h"
#import "UIView+Toast.h"

#import "UIImageView+WebCache.h"

#import "HSMessageListCell.h"
#import "HSMessageManager.h"

#import "MJRefresh.h"

#define kMessageRequestCount 100

@interface HSMessageListView ()
//@property (nonatomic, strong) MessageNet *messageNet;

@end

@implementation HSMessageListView
{
    UITableView *tbvMsgList;
    UIActivityIndicatorView *activityIndicatorView;
    UILabel *lblTip;
    NSInteger offset;
    NSInteger limit;
    NSString *messageType;
    UIImage *imgPlacehold;
    
    NSMutableArray *arrMessages;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        arrMessages = [[NSMutableArray alloc] initWithCapacity:0];
        offset = 0;
        limit = 30;
        messageType = kMessageAll;
        
        imgPlacehold = [UIImage imageNamed:@"image_default.png"];
        
        [self initInterface];
    }
    return self;
}

- (void)initInterface
{
    tbvMsgList = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tbvMsgList.dataSource = self;
    tbvMsgList.delegate = self;
    tbvMsgList.backgroundColor = kColorWhite;
    tbvMsgList.tableFooterView = [[UIView alloc] init];
    
    [tbvMsgList addHeaderWithTarget:self action:@selector(pullToRefresh:)];
    tbvMsgList.headerPullToRefreshText = MyLocal(@"下拉刷新");
    tbvMsgList.headerReleaseToRefreshText = MyLocal(@"松开即可刷新");
    tbvMsgList.headerRefreshingText = MyLocal(@"正在加载数据");
    
    [tbvMsgList addFooterWithTarget:self action:@selector(loadMoreMessage:)];
    tbvMsgList.footerPullToRefreshText = GDLocal(@"更多..");
    tbvMsgList.footerReleaseToRefreshText = GDLocal(@"松开即可刷新");
    tbvMsgList.footerRefreshingText = GDLocal(@"正在加载数据");
    
    [tbvMsgList headerBeginRefreshing];
    [self addSubview:tbvMsgList];
    
    
}

- (void)pullToRefresh:(id)sender
{
    //DLog(@"sender: %@", sender);
    [HSMessageManager messageRequestWithStartMessageID:@"" length:kMessageRequestCount messageType:messageType completion:^(BOOL finished, id obj, NSError *error) {
        
        NSNumber *num;
        if (finished)
        {
            offset = 0;
            NSArray *arrMsg = [HSMessageManager messageFilteredWithOffset:offset limit:limit messageType:messageType];
            offset = [arrMsg count];
            [self loadMessageList:arrMsg];
            
            NSInteger count = [arrMsg count];
            num = [NSNumber numberWithInteger:count];
        }
        [tbvMsgList headerEndRefreshing];
        
        [self showErrorMessage:num];
        
        
    }];
}

/*
// 刷新消息列表
- (void)requestMessageListWithMessageType:(NSString *)aMessageType
{
    // 加载指示器
    [self addActivityInddicatorViewToView:self];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL success = [HSMessageManager messageRequestWithStartMessageID:@"" length:100 messageType:aMessageType];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success)
            {
                offset = 0;
                NSArray *arrMsg = [HSMessageManager messageFilteredWithOffset:offset limit:limit messageType:aMessageType];
                offset = [arrMsg count];
                [self loadMessageList:arrMsg];
            }
            // 移除指示器
            [self removeActivityIndicatorView];
        });
    });
}
 */

- (void)loadMessageList:(NSArray *)msgList
{
    [arrMessages setArray:msgList];
    [tbvMsgList reloadData];
}

- (void)loadMoreMessage:(id)sender
{
    [self loadMoreMessageWithMessageType:messageType];
    [tbvMsgList footerEndRefreshing];
}

// 加载更多的消息
- (void)loadMoreMessageWithMessageType:(NSString *)aMessageType
{
    NSArray *arrMsg = [HSMessageManager messageFilteredWithOffset:offset limit:limit messageType:aMessageType];
    offset += [arrMsg count];
    [arrMessages addObjectsFromArray:arrMsg];
    [tbvMsgList reloadData];
}

// 过滤消息,
// 过滤消息的时候，都是从第一条开始显示。
- (void)filterMessageWithType:(NSString *)aMessageType
{
    offset = 0;
    messageType = aMessageType;
    NSArray *arrMsg = [HSMessageManager messageFilteredWithOffset:offset limit:limit messageType:aMessageType];
    offset = [arrMsg count];
    [self loadMessageList:arrMsg];
}


- (void)showErrorMessage:(NSNumber *)msgCount
{
    //DLog(@"消息的数量:%@", msgCount);
    if ([msgCount integerValue] <= 0)
    {
        // 弹出没有求助的信息
        if (!lblTip)
        {
            lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.center.y-20.0f, self.bounds.size.width, 40.0f)];
            lblTip.backgroundColor = [UIColor clearColor];
            lblTip.textAlignment = NSTextAlignmentCenter;
            lblTip.textColor = kColorBlack;
            
            [self addSubview:lblTip];
        }
        lblTip.alpha = 0;
        lblTip.text = GDLocal(@"没有最新消息");
        [self bringSubviewToFront:lblTip];
        [UIView animateWithDuration:0.3 animations:^{
            lblTip.alpha = 1;
        }];
        
        [self removeActivityIndicatorView];
    }
    else
    {
        lblTip.text = @"";
    }
}

#pragma mark - ActivityInddicatorView
- (void)addActivityInddicatorViewToView:(UIView *)view
{
    if (!activityIndicatorView)
    {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = CGPointMake(CGRectGetWidth(view.bounds)*0.5, CGRectGetHeight(view.bounds)*0.5);
        [view addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
    }
}

- (void)removeActivityIndicatorView
{
    if (activityIndicatorView)
    {
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        activityIndicatorView = nil;
    }
}

#pragma mark - UITableView DataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSInteger count = [arrMessages count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"MessageListCell";
    HSMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
    {
        NSArray *arrNib = [[NSBundle mainBundle] loadNibNamed:@"HSMessageListCell" owner:nil options:nil];
        for (id obj in arrNib)
        {
            if ([obj isKindOfClass:[HSMessageListCell class]])
            {
                cell = (HSMessageListCell *)obj;
            
                break;
            }
        }
    }
    
    NSInteger row = [indexPath row];
    
    MessageModel *msgModel = (MessageModel *)[arrMessages objectAtIndex:row];

    cell.message = msgModel;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    MessageModel *msgModel = (MessageModel *)[arrMessages objectAtIndex:row];
    //DLog(@"消息模型: %@", msgModel);
    if (self.delegate &&[self.delegate respondsToSelector:@selector(messageListView:messageID:messageType:link:linkEnabled:shareTitle:targetID:)])
    {
        NSString *tMsgTyp = [msgModel.type copy];
        MessageType msgType = [tMsgTyp isEqualToString:kMessageSystem] ? kMessageTypeSystem:([tMsgTyp isEqualToString:kMessageTeacher] ? kMessageTypeReplay:([tMsgTyp isEqualToString:kMessageFriend] ? kMessageTypeFriend:kMessageTypeBBS));
        [self.delegate messageListView:self messageID:msgModel.messageIDValue messageType:msgType link:msgModel.link linkEnabled:msgModel.isLink shareTitle:msgModel.title targetID:msgModel.targetID];
    }
    msgModel.isReaded = YES;
    NSString *msgID = [[NSString alloc] initWithFormat:@"%d", msgModel.messageIDValue];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self messageReaded:msgID];
    [HSMessageManager setMessageCount:[HSMessageManager messageCount]-1];
    kPostNotification(kRefreshMessageCountNotification, nil, nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSInteger row = [indexPath row];
    MessageModel *msgModel = [arrMessages objectAtIndex:row];
    NSString *title = msgModel.title;
    
    // 折行所需的真正高度。
    CGSize textSize = [title sizeWithFont:[UIFont fontWithName:kFontHelsize:16.0f] constrainedToSize:CGSizeMake(tableView.bounds.size.width*3/4.0f, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
   */
    CGFloat height = kiPhone ? 70:90;//textSize.height + kTableViewRowHeight*0.2f;
    
    return height; //> kTableViewRowHeight*1.5f ? height : kTableViewRowHeight*1.5f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSInteger row = indexPath.row;
        MessageModel *msgModel = [arrMessages objectAtIndex:row];
        [arrMessages removeObjectAtIndex:row];
        msgModel.isDeleted = YES;
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        
        tableView.editing = NO;
        
        [NSThread detachNewThreadSelector:@selector(messageDeleted:) toTarget:self withObject:msgModel.messageID];
    }
}

- (void)messageReaded:(NSString *)messageID
{
    [HSMessageManager messageReadedWithMessageID:messageID completion:^(BOOL finished, id obj, NSError *error) {}];
}

- (void)messageDeleted:(NSString *)messageID
{
    [HSMessageManager messageDeletedWithMessageID:messageID completion:^(BOOL finished, id obj, NSError *error) {}];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [tbvMsgList removeFromSuperview];
    tbvMsgList = nil;
    
    [arrMessages removeAllObjects];
    arrMessages = nil;
    
    [lblTip removeFromSuperview];
    lblTip = nil;
}

@end
