//
//  HSMoneyEffectViewController.m
//  HelloHSK
//
//  Created by Lu on 14/11/18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMoneyEffectViewController.h"
#import "MBProgressHUD.h"
#import "UINavigationController+Extern.h"

@interface HSMoneyEffectViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HSMoneyEffectViewController
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = GDLocal(@"汉声币作用");
    self.view.backgroundColor = kColorWhite;
    
    NSString *urlStr = [kHostUrl stringByAppendingString:kHSCoinsIntro];
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - ui
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = kColorClear;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}

-(void)dealloc{
}

@end
