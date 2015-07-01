//
//  HSLoginAndOutHandle.m
//  LiveCourse
//
//  Created by Lu on 15/1/8.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSLoginAndOutHandle.h"
#import "SoftwareVerisonDAL.h"
#import "UIGuidViewController.h"
#import "UserModel.h"
#import "UserDAL.h"
#import "HSMoreViewController.h"
#import "HSHomeViewController.h"
#import "HSCommunityListViewController.h"

#import "HSLaunchAdViewController.h"

@interface HSLoginAndOutHandle ()<HSLoginViewControllerDelegate,UITabBarControllerDelegate,UIGuidViewControllerDelegate,HSLaunchAdViewControllerDelegate>


@property (nonatomic, strong) HSCommunityListViewController *communityViewController;

@property (nonatomic, strong) HSLaunchAdViewController *adVC;

@end

@implementation HSLoginAndOutHandle

hsSharedInstanceImpClass(HSLoginAndOutHandle)

-(BOOL)islogin{
    UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
    return user.isLogined;
}

-(void)setLoginStatus:(BOOL)loginStatus{
    UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
    user.isLogined = loginStatus;
}

#pragma mark - 处理是否是第一次打开程序/是更新后的第一次打开程序
- (void)dealFirstLaunch:(BOOL)isReset
{
    
    if (isReset) {
        [self launchToGuidOrLogin];
        return;
    }
    
    //显示广告
    //访问广告网络数据
    NSString *imageUrl = @"http://e.hiphotos.baidu.com/image/pic/item/d52a2834349b033bbf03a6db17ce36d3d539bd2c.jpg";
    
    if (NO) {
        [self doADViewWithImageUrl:imageUrl];
    }else{
        [self launchToGuidOrLogin];
    }
}

-(void)launchToGuidOrLogin{
    
    //[UIApplication sharedApplication].statusBarHidden = NO;
    if (kiOS7_OR_LATER){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
#ifdef DEBUG
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
#endif
    BOOL isLaunched = [SoftwareVerisonDAL isLaunchedWithVersion:kSoftwareVersion];
#ifdef DEBUG
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
#endif
    DLog(@"查询用时: %f", end-start);
    
    if (isLaunched){
        [self dealUserLogin];
    }else{
        [self guidUserToUse];
    }
}

/**
 *  处理广告
 */
-(void)doADViewWithImageUrl:(NSString *)url{
    self.adVC = [[HSLaunchAdViewController alloc] init];
    [_adVC setImageUrl:url];
    _adVC.delegate = self;
    [HSAppDelegate.window setRootViewController:_adVC];
}

-(void)launchAdViewControllerDelegateCloseAdBtnClick{
    DLog(@"关闭---------广告");
    _adVC = nil;
    [self launchToGuidOrLogin];
}

- (void)dealUserLogin
{
    if (self.islogin){
        [self startToLearn:NO];
    }else{
        [self startToLogin:NO];
    }
}

#pragma mark - Login ViewController
- (void)loginFinish
{
    [self startToLearn:YES];
}

- (void)startToLogin:(BOOL)animated
{
    [HSAppDelegate.window setRootViewController:self.loginViewController];
    
    if (animated) {
        HSAppDelegate.window.rootViewController.view.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            HSAppDelegate.window.rootViewController.view.alpha = 1.0f;
        }];
    }
}

- (void)startToLearn:(BOOL)animated
{
    if (_tabBarController) {
        [_tabBarController setViewControllers:nil];
        _tabBarController = nil;
    }
    
    if (kiOS7_OR_LATER)
    {
        self.tabBarController.tabBar.translucent = NO;
    }
    else
    {
        UIImage *img = [[UIImage alloc] init];
        // 用一张透明背景的图片作为选中的背景。
        self.tabBarController.tabBar.selectionIndicatorImage = img;
        self.tabBarController.tabBar.backgroundImage = img;
    }
    
    UIImage *imgHome = [UIImage imageNamed:@"ico_tabbar_item_home"];
    HSHomeViewController *_itemListViewController = [[HSHomeViewController alloc] init];
    _itemListViewController.title = MyLocal(@"学习");
    _itemListViewController.tabBarItem.image = kiOS7_OR_LATER ? [imgHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:imgHome;
    _itemListViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ico_tabbar_item_home_sel"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:_itemListViewController];
    
    UIImage *imgCommunity = [UIImage imageNamed:@"ico_tabbar_item_community"];
    _communityViewController = [[HSCommunityListViewController alloc] initWithStyle:UITableViewStylePlain];
    _communityViewController.title = MyLocal(@"社区");
    _communityViewController.tabBarItem.image = kiOS7_OR_LATER ? [imgCommunity imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:imgCommunity;
    _communityViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ico_tabbar_item_community_sel"];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:_communityViewController];
    
    UIImage *imgMore = [UIImage imageNamed:@"ico_tabbar_item_more"];
    HSMoreViewController *_moreViewController = [[HSMoreViewController alloc] init];
    _moreViewController.title = MyLocal(@"更多");
    _moreViewController.tabBarItem.image = kiOS7_OR_LATER ? [imgMore imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:imgMore;
    _moreViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ico_tabbar_item_more_sel"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:_moreViewController];
    
    [self.tabBarController setViewControllers:@[nav1,nav2,nav3] animated:animated];
    [HSAppDelegate.window setRootViewController:self.tabBarController];
    
    HSAppDelegate.window.rootViewController.view.alpha = 0.0f;
    [UIView animateWithDuration:0.6f animations:^{
        HSAppDelegate.window.rootViewController.view.alpha = 1.0f;
    }];
    _loginViewController = nil;
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        if ([tabBarController.selectedViewController isEqual:self.communityViewController.navigationController] && [nav isEqual:self.communityViewController.navigationController]) {
            BOOL isEqual = [self.communityViewController.baseContentView isEqual:self.communityViewController.tableView];
            if (isEqual) {
                //选中社区的时候下拉刷新
                [self.communityViewController startReloadData];
            }
        }
    }
    return YES;
}


//HSMoreViewControllerDelegate 退出
-(void)logOut{
    [self setLoginStatus:NO];
    kSetUDTempUser(NO);
    
    [HSAppDelegate.window setRootViewController:self.loginViewController];
    HSAppDelegate.window.rootViewController.view.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        HSAppDelegate.window.rootViewController.view.alpha = 1.0f;
    }];
    self.loginViewController = nil;
}

#pragma mark - init
- (HSLoginViewController *)loginViewController
{
    if (!_loginViewController){
        _loginViewController = [[HSLoginViewController alloc] initWithNibName:@"HSLoginViewController" bundle:nil];
        _loginViewController.delegate = self;
    }
    return _loginViewController;
}


-(UITabBarController *)tabBarController{
    if (!_tabBarController)
    {
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.delegate = self;
        _tabBarController.view.backgroundColor = kColorWhite;
    }
    return _tabBarController;
}


#pragma mark - Custom Guid ViewController
- (void)guidUserToUse
{
    NSArray *arrImages = @[@"img_UG1", @"img_UG2", @"img_UG3", @"img_UG4", @"img_UG5"];
    UIGuidViewController *guidViewController = [[UIGuidViewController alloc] initWithNibName:nil bundle:nil guidPages:arrImages];
    guidViewController.delegate = self;
    
    HSAppDelegate.window.rootViewController = guidViewController;
    [UIApplication sharedApplication].statusBarHidden = YES;
}

#pragma mark - UIGuidViewController Delegate
- (void)guidViewController:(UIGuidViewController *)controller experienceAction:(id)sender
{
    [SoftwareVerisonDAL saveSoftwareVersionWithVersion:kSoftwareVersion dbVersion:kSoftwareVersion launched:YES completion:^(BOOL finished, id result, NSError *error) {}];
    [self startToLogin:YES];
    [UIApplication sharedApplication].statusBarHidden = NO;
}


@end
