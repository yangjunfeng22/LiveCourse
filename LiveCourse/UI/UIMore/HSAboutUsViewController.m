//
//  HSAboutUsViewController.m
//  HelloHSK
//
//  Created by yang on 14-2-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAboutUsViewController.h"
#import "UINavigationController+Extern.h"


@interface HSAboutUsViewController ()

@end

@implementation HSAboutUsViewController
{
    UIImage *imgLevelTip;
    
    NSString *strLevelTip;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = GDLocal(@"关于我们");
        
        imgLevelTip = [UIImage imageNamed:@"ico_app_tip_blue"];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [HSBaseTool googleAnalyticsPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    self.lbHSKLevel4.text = strLevelTip;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *strVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *version = [[NSString alloc] initWithFormat:@"v %@", strVersion];
    
    self.lbVersion.text = version;
    self.imgvHSK4.size = imgLevelTip.size;
    self.imgvHSK4.image = imgLevelTip;
    self.lbHelloHSK.text = @"Hello Daily";
    
    if (kiOS7_OR_LATER)
    {
        self.imgvHSK4.center = CGPointMake(self.view.width/2, self.imgvHSK4.center.y+NavigationBar_HEIGHT + 20);
        self.lbHelloHSK.center = CGPointMake(self.lbHelloHSK.center.x, self.lbHelloHSK.center.y+NavigationBar_HEIGHT);
        self.lbHSKLevel4.center = CGPointMake(self.lbHSKLevel4.center.x, self.lbHSKLevel4.center.y+NavigationBar_HEIGHT);
        self.lbVersion.center = CGPointMake(self.lbVersion.center.x, self.lbVersion.center.y+NavigationBar_HEIGHT);
    }
}

- (IBAction)linkToHelloHskWebsite:(id)sender
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.hschinese.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    imgLevelTip = nil;
    strLevelTip = nil;
    
    [_lbHelloHSK removeFromSuperview];
    [_lbHSKLevel4 removeFromSuperview];
    [_lbVersion removeFromSuperview];
    
    self.lbHelloHSK = nil;
    self.lbHSKLevel4 = nil;
    self.lbVersion = nil;
    
    [_imgvHSK4 removeFromSuperview];
    self.imgvHSK4 = nil;
    
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
