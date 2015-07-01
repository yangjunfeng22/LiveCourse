//
//  HSSystemMessageDetailViewController.m
//  HelloHSK
//
//  Created by yang on 14-7-2.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSSystemMessageDetailViewController.h"
#import "KeyChainHelper.h"
#import "MessageNet.h"

#import "UIColor+FlatColors.h"
#import "VBFPopFlatButton.h"
#import "NFSinaWeiboHelper.h"
#import "NFFaceBookHelper.h"

@interface HSSystemMessageDetailViewController ()<UIWebViewDelegate,UIActionSheetDelegate>
{
    UIImage *imgClose;
    UIWebView *webView;
    
    UIBarButtonItem *itemPre;
    UIBarButtonItem *itemNex;
    
    VBFPopFlatButton *preBtn;
    VBFPopFlatButton *forwardBtn;
    
    UIActivityIndicatorView *activityIndicatorView;
}


@end

@implementation HSSystemMessageDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = MyLocal(@"系统消息");
        imgClose = ImageNamed(@"ico_navigation_back");
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    if (kiOS7_OR_LATER) {
        self.navigationController.toolbar.barTintColor = kColorWhite;
    }else{
        self.navigationController.toolbar.tintColor = kColorWhite;
    }
    
    webView.frame = self.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController setToolbarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    preBtn = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonBackType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    preBtn.lineThickness = 2;
    preBtn.tintColor = kColorMain;
    [preBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    itemPre = [[UIBarButtonItem alloc] initWithCustomView:preBtn];

    UIBarButtonItem *itemFixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    itemFixed.width = self.view.width*0.1f;
    
    
    forwardBtn = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonForwardType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    forwardBtn.lineThickness = 2;
    forwardBtn.tintColor = kColorMain;
    [forwardBtn addTarget:self action:@selector(goForward:) forControlEvents:UIControlEventTouchUpInside];
    itemNex = [[UIBarButtonItem alloc] initWithCustomView:forwardBtn];

    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];

    [shareBtn setImage:[UIImage imageNamed:@"ico_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    UIBarButtonItem *itemFixed2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    itemFixed2.width = self.view.width*0.1f;
    
    UIBarButtonItem *itemReload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
    itemReload.tintColor = kColorMain;
    NSArray *arrIitems = [NSArray arrayWithObjects:itemPre, itemFixed, itemNex, itemSpace, itemShare, itemFixed2, itemReload, nil];
    self.toolbarItems = arrIitems;
    
    UIButton *btnClose = [[UIButton alloc] init];
    btnClose.frame = CGRectMake(0.0f, 0.0f, imgClose.size.width, imgClose.size.height);
    [btnClose addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
    btnClose.backgroundColor = [UIColor clearColor];
    [btnClose setImage:imgClose forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
}

- (void)goBack:(id)sender
{
    if (webView && [webView canGoBack]) {
        [webView goBack];
    }
}

- (void)goForward:(id)sender
{
    if (webView && [webView canGoForward]) {
        [webView goForward];
    }
}

- (void)reload:(id)sender
{
    if (webView && !webView.loading) {
        [webView reload];
    }
}

- (void)share: (id)sender
{
    DLog(@"分享: %@", webView.request.URL);
    UIActionSheet *shareAction = [[UIActionSheet alloc] initWithTitle:MyLocal(@"分享") delegate:self cancelButtonTitle:MyLocal(@"取消")destructiveButtonTitle:nil otherButtonTitles:MyLocal(@"新浪微博"),@"Facebook", nil];
    [shareAction showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self shareToSina];
    }else if (buttonIndex == 1){
        [self shareToFacebook];
    }
}

-(void)shareToSina{
    
    NFSinaWeiboHelper *weibo = [[NFSinaWeiboHelper alloc] init];
    NSString *title = self.shareTitle;
    NSString *content = [title stringByAppendingString:[webView.request.URL absoluteString]] ;
    [weibo startShareWithMessage:content andImage:nil refresh:^(NSString *returnMessage) {
        DLog(@"%@----",returnMessage);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:returnMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)shareToFacebook{
    [NFFaceBookHelper facebookShareWithView:self.view title:self.shareTitle link:[webView.request.URL absoluteString]];
}

- (void)reflashButtonState
{
    if (webView.canGoBack){
        preBtn.enabled = YES;
        preBtn.tintColor = kColorMain;
        //preBtn.hidden = NO;
    }
    else{
        preBtn.enabled = NO;
        preBtn.tintColor = [UIColor grayColor];
        //preBtn.hidden = YES;
    }
    
    if (webView.canGoForward){
        forwardBtn.enabled = YES;
        forwardBtn.tintColor = kColorMain;
        //forwardBtn.hidden = NO;
    }else{
        forwardBtn.enabled = NO;
        forwardBtn.tintColor = [UIColor grayColor];
        //forwardBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLink:(NSString *)link
{
    //NSLog(@"link: %@", link);
    [self addWebView];
    [self addActivityIndicatorView];
    NSURL *url =[NSURL URLWithString:link];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

/*
- (void)setMessageID:(NSInteger)messageID
{
    [self addWebView];
    [self addActivityIndicatorView];
    
    [NSThread detachNewThreadSelector:@selector(requestMessageContentWithMessageID:) toTarget:self withObject:[NSNumber numberWithInteger:messageID]];
}
 */

- (void)addWebView
{
    if (!webView)
    {
        CGRect frame = self.view.bounds;
        /*
        if (kIOS7) {
            frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, self.view.bounds.size.height);
        }
        */
        webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
    }
}

- (void)requestMessageContentWithMessageID:(NSNumber *)messageID
{
    @autoreleasepool
    {
        NSString *strEmail = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
        NSString *strMsgID = [[NSString alloc] initWithFormat:@"%ld", (long)[messageID integerValue]];

        /*
        ResponseModel *response = [MessageNet requestMessageContentWithEmail:strEmail messageID:strMsgID];
        if (response.error.code == 0)
        {
            NSString *strHtml = response.resultInfo;
            [self performSelectorOnMainThread:@selector(refreshWebViewWithHTMLString:) withObject:strHtml waitUntilDone:NO];
        }
         */
    }
}

- (void)refreshWebViewWithHTMLString:(NSString *)htmlString
{
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"www.baidu.com"]];
}

- (void)quitAction:(id)sender
{
    [webView stopLoading];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActivityIndicatorView
{
    if (!activityIndicatorView)
    {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [activityIndicatorView setCenter:CGPointMake(SCREEN_WIDTH*0.5f, SCREEN_HEIGHT*0.5f)];
        [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:activityIndicatorView];
    }
    [activityIndicatorView startAnimating];
}

#pragma mark - WebView Delegate manager
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    [self reflashButtonState];
    BOOL shouldReturn = YES;
    NSURL *requestURL = [request URL];
    DLog(@"scheme: %@", [requestURL scheme]);
    
    if (([[requestURL scheme] isEqualToString:@"mailto"] || [[requestURL scheme] isEqualToString:@"tel"]))
    {
        NSString *strUrl = [requestURL absoluteString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
        shouldReturn = NO;
    }
    
    return shouldReturn;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    if (!activityIndicatorView.isAnimating) {
        [activityIndicatorView startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self reflashButtonState];
    if (activityIndicatorView.isAnimating) {
        [activityIndicatorView stopAnimating];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self reflashButtonState];
    if (activityIndicatorView.isAnimating) {
        [activityIndicatorView stopAnimating];
    }
    
    if (error.code != -999)
    {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:GDLocal(@"加载失败") message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterview show];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [webView removeFromSuperview];
    webView = nil;
    
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
    activityIndicatorView = nil;
    
    imgClose = nil;
}

@end
