//
//  HSMoreViewController.m
//  HelloHSK
//
//  Created by yang on 14-2-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMoreViewController.h"
#import "HSLoginViewController.h"
#import "HSAboutUsViewController.h"
#import <MessageUI/MessageUI.h>
#import "HSAppRecommendTableViewController.h"
#import "SDImageCache.h"
#import "UIView+Toast.h"
//#import "HSLoginHandle.h"

#import "HSAppSetTableViewCell.h"
//#import "UIPayHSMoneyViewController.h"
#import "HSMoreHeaderView.h"
#import "MBProgressHUD.h"

#import "KeyChainHelper.h"
#import "NFSinaWeiboHelper.h"
#import "NFFaceBookHelper.h"

#import "HSCleanCachViewController.h"

#import "HSLoginAndOutHandle.h"
#import "MFMailComposeViewController+BlocksKit.h"

@interface HSMoreViewController ()
{
    
}

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NFSinaWeiboHelper *weibo;

@end

@implementation HSMoreViewController
{
    HSMoreHeaderView *headView;
    NSString *aUserEmail;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [HSBaseTool googleAnalyticsPageView:NSStringFromClass([self class])];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if (kiOS8_OR_LATER) {
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = MyLocal(@"更多");
    
    aUserEmail = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    
    self.cellArray = [NSMutableArray arrayWithCapacity:2];
    
    [self dataInitialization];
    
    if (kiOS7_OR_LATER) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self initLogOutView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [headView loadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (NFSinaWeiboHelper *)weibo
{
    if (!_weibo)
    {
        _weibo = [[NFSinaWeiboHelper alloc] init];
    }
    return _weibo;
}

#pragma mark - 初始化cell
- (void)dataInitialization{
    headView = [[HSMoreHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 160)];
    if (!kiPhone) {
        headView.height = 200;
    }
    self.tableView.tableHeaderView = headView;

    
    //cell
    HSAppSetTableViewCell *cell00 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell00"];
    cell00.textLabel.text = GDLocal(@"关于我们");
    cell00.imageView.image = [UIImage imageNamed:@"icon_more_adoutUs"];
    cell00.subClass = [HSAboutUsViewController class];
    
    
    HSAppSetTableViewCell *cell01 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell01"];
    cell01.textLabel.text = GDLocal(@"分享");
    cell01.imageView.image = [UIImage imageNamed:@"icon_more_share"];
    cell01.selector = @selector(shareAction);
    
    HSAppSetTableViewCell *cell02 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell02"];
    cell02.textLabel.text = GDLocal(@"意见反馈");
    cell02.imageView.image = [UIImage imageNamed:@"icon_more_feedBack"];
    cell02.selector = @selector(feedbackAction);
    
    HSAppSetTableViewCell *cell03 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell03"];
    cell03.textLabel.text = GDLocal(@"评价我们");
    cell03.imageView.image = [UIImage imageNamed:@"icon_more_rateUs"];
    cell03.selector = @selector(rateUs);
    
    HSAppSetTableViewCell *cell04 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell04"];
    cell04.textLabel.text = GDLocal(@"应用推荐");
    cell04.imageView.image = [UIImage imageNamed:@"icon_more_featured_app"];
    cell04.subClass = [HSAppRecommendTableViewController class];
    
    
    HSAppSetTableViewCell *cleanCacheCell = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell05"];
    cleanCacheCell.textLabel.text = GDLocal(@"清除缓存");
    cleanCacheCell.imageView.image = [UIImage imageNamed:@"ico_more_clearn"];
    cleanCacheCell.subClass = [HSCleanCachViewController class];
    
    
    HSAppSetTableViewCell *cell06 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell06"];
    cell06.textLabel.text = GDLocal(@"语言");
    cell06.imageView.image = [UIImage imageNamed:@"icon_more_lan"];
    cell06.selector = @selector(changeLanguage);
    
    [self.cellArray setArray:@[cell00,cell06,cell01,cell02,cell04,cell03,cleanCacheCell]];
}


-(void)initLogOutView{
    
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 54)];
    sectionFooterView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 7, 300, 45);
    button.width = self.view.width*0.95f;
    button.center = CGPointMake(sectionFooterView.width/2.0f, sectionFooterView.height/2.0f);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [button setBackgroundColor:kColorMain];
    [button setTitle:GDLocal(@"退出") forState:UIControlStateNormal];
    [button setTitleColor:kColorWhite forState:UIControlStateNormal];
    [button.titleLabel setFont:[button.titleLabel.font fontWithSize:18.0f]];
    [button addTarget:self action:@selector(logOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionFooterView addSubview:button];
    
    self.tableView.tableFooterView = sectionFooterView;
    self.tableView.showsVerticalScrollIndicator = NO;
}


-(void)logOutBtnClick:(id)sender{
    [hsGetSharedInstanceClass(HSLoginAndOutHandle) logOut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
*/

#pragma mark - action
- (void)feedbackAction{
    
    BOOL canSend = [MFMailComposeViewController canSendMail];
    if (canSend)
    {
        //NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenStringKey];;
        NSString *info = [[NSString alloc] initWithFormat:@"App Name: %@;\nApp Version: %@;\nDevice Name: %@;\nOS Version: %@\nLanguage: %@", kSoftwareName, kSoftwareVersion, device(), CurrentSystemVersion, currentLanguage()];
        
        NSString *msgBody = [[NSString alloc] initWithFormat:@"Please fill in the content\n\n\n\n\n%@", info];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        
        [mc bk_setCompletionBlock:^(MFMailComposeViewController *mailComposeViewController, MFMailComposeResult result, NSError *error) {
           
            switch (result)
            {
                case MFMailComposeResultCancelled:
                    NSLog(@"Mail send canceled...");
                    break;
                case MFMailComposeResultSaved:
                    NSLog(@"Mail saved...");
                    break;
                case MFMailComposeResultSent:
                    NSLog(@"Mail sent...");
                    break;
                case MFMailComposeResultFailed:
                    NSLog(@"Mail send errored: %@...", [error localizedDescription]);
                    break;
                default:
                    break;
            }
            [self dismissViewControllerAnimated:YES completion:^{}];
        }];
        
        [mc setSubject:MyLocal(@"意见反馈")];
        
        [mc setToRecipients:[NSArray arrayWithObject:@"feedback@hschinese.com"]];
        [mc setMessageBody:msgBody isHTML:NO];
        mc.hidesBottomBarWhenPushed = YES;
        
        [self presentViewController:mc animated:YES completion:^{}];
    }
    else
    {
        NSValue *value = [NSValue valueWithCGPoint:self.view.center];
        [self.view makeToast:@"Please set your mail" duration:0.5f position:value];
    }
}


-(void)changeLanguage
{
    NSString *nowLan = [GDLocalizableController userLanguage];
    
    UIActionSheet *changeLanguageActionSheet = [UIActionSheet bk_actionSheetWithTitle:MyLocal(@"语言")];
    
    [changeLanguageActionSheet bk_setCancelButtonWithTitle:MyLocal(@"取消") handler:nil];
    
    [changeLanguageActionSheet bk_addButtonWithTitle:@"简体中文" handler:^{
        if ([CHINESE isEqualToString:nowLan]) {
            return;
        }else{
            [GDLocalizableController setUserLanguage:CHINESE];
            kPostNotification(kChangeLanguageNotification, nil, nil);
        }
    }];
    
    [changeLanguageActionSheet bk_addButtonWithTitle:@"English" handler:^{
        if ([ENGLISH isEqualToString:nowLan]) {
            return;
        }else{
            [GDLocalizableController setUserLanguage:ENGLISH];
            kPostNotification(kChangeLanguageNotification, nil, nil);
        }
    }];
    
    [changeLanguageActionSheet bk_addButtonWithTitle:@"한국어" handler:^{
        if ([KOREA isEqualToString:nowLan]) {
            return;
        }else{
            [GDLocalizableController setUserLanguage:KOREA];
            kPostNotification(kChangeLanguageNotification, nil, nil);
        }
    }];
    
    [changeLanguageActionSheet bk_addButtonWithTitle:@"日本語" handler:^{
        if ([JAPAN isEqualToString:nowLan]) {
            return;
        }else{
            [GDLocalizableController setUserLanguage:JAPAN];
            kPostNotification(kChangeLanguageNotification, nil, nil);
        }
    }];
    
    [changeLanguageActionSheet showInView:self.view];
}

-(void)resetApp{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://api.hellohsk.com/hellohsk/test/jump?url=appLive://"]];
    // 调用Safari之后，就退出本应用。
    [self exitApplication];
}

- (void)exitApplication
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[UIApplication sharedApplication].delegate.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIApplication sharedApplication].delegate.window.alpha = 0;
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

- (void)rateUs{
    
    NSString *appUrl = [[NSString alloc] initWithFormat:@"itms-apps://itunes.apple.com/us/app/id%d?mt=8", [kApplicationID integerValue]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
}

-(void)shareAction{

    UIActionSheet *shareAction = [UIActionSheet bk_actionSheetWithTitle:MyLocal(@"分享")];
    
    [shareAction bk_addButtonWithTitle:MyLocal(@"新浪微博") handler:^{
         [self shareToSina];
    }];
    
    [shareAction bk_addButtonWithTitle:@"Facebook" handler:^{
        [self shareToFacebook];
    }];
    [shareAction bk_setCancelButtonWithTitle:MyLocal(@"取消") handler:nil];
    
    [shareAction showInView:self.view];
}


-(void)shareToSina{
    [HSBaseTool googleAnalyticsLogCategory:aUserEmail action:@"分享" event:@"新浪" pageView:NSStringFromClass([self class])];
    
    NSString *imageName = kiPhone ? @"imgIphoneShare" : @"imgIpadShare";
    NSString *image = [NSString stringWithFormat:@"%@@2x",GDLocal(imageName)] ;
    
    //NSString *content = [NSString stringWithFormat:@"I find an extremely useful App which help me learn the chinese, come and try it."];
    NSString *content = MyLocal(@"想知道我是怎么学汉语的吗？去汉声中文，用Hello Daily");
    
    [self.weibo startShareWithMessage:content andImage:image refresh:^(NSString *returnMessage) {
        DLog(@"%@----",returnMessage);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:returnMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)shareToFacebook{
//    [NFFaceBookHelper startShare:^(NSString *screen_name) {
//        
//    }];
    
    NSString *content = [NSString stringWithFormat:@"I find an extremely useful App which help me learn the chinese, come and try it. "];
    
    [NFFaceBookHelper facebookShareWithView:self.view title:content link:@"http://www.hschinese.com"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellArray objectAtIndex:indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kiPhone) {
        return 55;
    }else{
        return 80;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HSAppSetTableViewCell *tempCell = (HSAppSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (tempCell.subClass && [tempCell.subClass isSubclassOfClass:[UIViewController class]]) {
        UIViewController *viewController = [[tempCell.subClass alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.title = tempCell.textLabel.text;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (tempCell.selector) {
        [self performSelectorOnMainThread:tempCell.selector withObject:nil waitUntilDone:YES];
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if (kiOS8_OR_LATER) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


@end
