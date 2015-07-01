//
//  HSTwitterViewController.m
//  HelloHSK
//
//  Created by junfengyang on 15/1/16.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import "HSTwitterViewController.h"

@interface HSTwitterViewController ()<UIWebViewDelegate>
{
    TwitterType twitterType;
    NSURL *url;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation HSTwitterViewController

- (id)initwithTwitterType:(TwitterType)type url:(NSURL *)aUrl
{
    id obj = [self init];
    if (obj)
    {
        twitterType = type;
        url = aUrl;
    }
    return self;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.center = CGPointMake(self.view.width*0.5, self.view.height*0.5);
        [self.view addSubview:_activityIndicatorView];
    }
    [self.view bringSubviewToFront:_activityIndicatorView];
    return _activityIndicatorView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationController)
    {
        [self.navigationController.navigationBar setHidden:NO];
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back:)];
        [self.navigationItem setLeftBarButtonItem:leftBar animated:YES];
    }
    else
    {
        // 其他的方式
        
    }
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView setDelegate:self];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    [self.activityIndicatorView startAnimating];
}

- (void)back:(id)sender
{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

#pragma mark - WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSURL *backURL = [request URL];  //接受重定向的URL
    [self.activityIndicatorView startAnimating];
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
