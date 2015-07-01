//
//  HSMessageViewController.m
//  HelloHSK
//
//  Created by yang on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMessageViewController.h"
#import "HSMessageListView.h"
#import "HSSystemMessageDetailViewController.h"
// 消息列表
#import "HSMessageListCell.h"
#import "MessageModel.h"
#import "MessageNet.h"
#import "HSMessageFilterView.h"
#import "KeyChainHelper.h"
#import "UIView+Toast.h"

#import "UIImageView+WebCache.h"
#import "HSCommunityDetailVC.h"

@interface HSMessageViewController ()<HSMessageListViewDelegate, HSMessageFilterViewDelegate>
{
    HSMessageFilterView *filterView;
    HSMessageListView *msgListView;
}

@end

@implementation HSMessageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = MyLocal(@"消息");
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CreatViewControllerImageBarButtonItem(ImageNamed(@"ico_navigation_back"), @selector(iacQuit:), self, YES);
    
    CreatViewControllerImageBarButtonItem(ImageNamed(@"ico_navigation_filter"), @selector(iacFilterMessageType:), self, NO);
    
    CGFloat fTop = kiOS7_OR_LATER ? 0 : -52;
    
    filterView = [[HSMessageFilterView alloc] initWithFrame:CGRectMake(0, fTop, self.view.width, 52)];
    filterView.delegate = self;
    filterView.backgroundColor = kColorWhite;
    [self.view addSubview:filterView];
    
    msgListView = [[HSMessageListView alloc] initWithFrame:CGRectMake(0, filterView.bottom+10, self.view.width, self.view.height-filterView.bottom-10)];
    msgListView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    msgListView.delegate = self;
    msgListView.backgroundColor = kColorWhite;
    [self.view addSubview:msgListView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)iacQuit:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        #if NS_BLOCKS_AVAILABLE
        if(quitBlock){
            quitBlock();
        }
        #endif
    }];
}

- (void)iacFilterMessageType:(id)sender
{
    //DLog(@"bottom: %f", self.navigationController.navigationBar.bottom);
    BOOL shoudShow = filterView.top < (kiOS7_OR_LATER ? self.navigationController.navigationBar.bottom:0);
    
    [UIView animateWithDuration:0.3 animations:^{
        filterView.top = shoudShow ? (kiOS7_OR_LATER ? self.navigationController.navigationBar.bottom:0) : (kiOS7_OR_LATER ? 0:-filterView.height);
        msgListView.frame = CGRectMake(0, filterView.bottom+10, self.view.width, self.view.height-filterView.bottom-10);
    }];
}

#pragma mark - Blocks
#if NS_BLOCKS_AVAILABLE
- (void)setQuitBlock:(MSGBasicBlock)aQuitBlock
{
    quitBlock = [aQuitBlock copy];
}
#endif

#pragma mark - MessageListView Delegate
- (void)messageListView:(HSMessageListView *)msgListView messageID:(NSInteger)messageID messageType:(MessageType)messageType link:(NSString *)link linkEnabled:(BOOL)flag shareTitle:(NSString *)shareTitle targetID:(NSString *)targetID
{
    NSString *msgTitle = MyLocal(@"系统消息");
    DLog(@"消息类型: %ld", messageType);
    if (messageType == kMessageTypeSystem) {
        msgTitle = MyLocal(@"系统消息");
    }else if (messageType == kMessageTypeReplay){
        // 教师回复的消息
        msgTitle = MyLocal(@"教师回复");
    }else if (messageType == kMessageTypeFriend){
        // 好友回复的消息
        msgTitle = MyLocal(@"好友回复");
    }else if (messageType == kMessageTypeBBS){
        msgTitle = MyLocal(@"社区回复");
    }else{
        msgTitle = MyLocal(@"其他消息");
    }
    
    if (messageType == kMessageTypeBBS)
    {
        HSCommunityDetailVC *detailVC = [[HSCommunityDetailVC alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.topicID = [targetID copy];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        HSSystemMessageDetailViewController *sysMsgDetailVctrl = [[HSSystemMessageDetailViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:sysMsgDetailVctrl animated:YES];
        
        sysMsgDetailVctrl.link = link;//@"http://www.baidu.com";
        sysMsgDetailVctrl.messageID = messageID;
        sysMsgDetailVctrl.title = msgTitle;
        sysMsgDetailVctrl.shareTitle = shareTitle;
    }
}

#pragma mark - 筛选结果 delegate

- (void)messageFiltered:(NSString *)messageType
{
    [self iacFilterMessageType:nil];
    if (msgListView) {
        [msgListView filterMessageWithType:messageType];
    }
}

@end
