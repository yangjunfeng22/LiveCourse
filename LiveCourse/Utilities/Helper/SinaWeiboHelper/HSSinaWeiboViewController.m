//
//  HSSinaWeiboViewController.m
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSSinaWeiboViewController.h"
#import "NFSinaWeiboHelper.h"

@interface HSSinaWeiboViewController ()<UIWebViewDelegate>
{
    WeiboType weiboType;
}

@end

@implementation HSSinaWeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initwithWeiboType:(WeiboType)type
{
    id obj = [self init];
    if (obj)
    {
        weiboType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = MyLocal(@"分享");
    if (self.navigationController)
    {
        [self.navigationController.navigationBar setHidden:NO];
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back:)];
        leftBar.tintColor = kColorMain;
        [self.navigationItem setLeftBarButtonItem:leftBar animated:YES];
    }
    else
    {
        // 其他的方式

    }
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *strUrl = @"";
    if (weiboType == kWeiboTypeLogin){
        strUrl = [NFSinaWeiboHelper oauthUrlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
        
        [webView loadRequest:request];
    }else
    {
        strUrl = [NFSinaWeiboHelper shareUrlString];
        //NSString *html = @"<a href=\"javascript:void((function(s,d,e,r,l,p,t,z,c){var%20f='http://v.t.sina.com.cn/share/share.php?appkey=3313929011',u=z||d.location,p=['&url=',e(u),'&title=',e(t||d.title),'&source=',e(r),'&sourceUrl=',e(l),'&content=',c||'gb2312','&pic=',e(p||'')].join('');function%20a(){if(!window.open([f,p].join(''),'mb',['toolbar=0,status=0,resizable=1,width=440,height=430,left=',(s.width-440)/2,',top=',(s.height-430)/2].join('')))u.href=[f,p].join('');};if(/Firefox/.test(navigator.userAgent))setTimeout(a,0);else%20a();})(screen,document,encodeURIComponent,'','','图片链接|默认为空','我是一个好孩子','内容链接|默认当前页location','页面编码gb2312|utf-8默认gb2312'));\">分享至微博</a>";
        
        //[webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://v.t.sina.com.cn/share/share.php"]];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
        
        [webView loadRequest:request];
    }
    
    [webView setDelegate:self];

    

    [self.view addSubview:webView];
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
    NSURL *backURL = [request URL];  //接受重定向的URL
    return [NFSinaWeiboHelper startAuthorizeWithURL:backURL finished:^(NSString *screen_name) {
        [self back:nil];
    }];
}

#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
