//
//  ViewController.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/5.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "ViewController.h"

#import "HSLoginViewController.h"

#import "SoftwareVerisonDAL.h"
#import "UIGuidViewController.h"

#import "UserModel.h"
#import "UserDAL.h"
#import "HSMoreViewController.h"

@interface ViewController ()<UIGuidViewControllerDelegate, HSLoginViewControllerDelegate, UITabBarControllerDelegate,HSMoreViewControllerDelegate>
@property (strong, nonatomic) HSLoginViewController *loginViewController;
@property (strong, nonatomic) UIViewController *homeViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation ViewController

- (HSLoginViewController *)loginViewController
{
    if (!_loginViewController){
        _loginViewController = [[HSLoginViewController alloc] initWithNibName:nil bundle:nil];
        _loginViewController.delegate = self;
    }
    return _loginViewController;
}

- (UIViewController *)homeViewController
{
    if (!_homeViewController)
    {
        _homeViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _homeViewController;
}

- (UITabBarController *)tabBarController
{
    if (!_tabBarController)
    {
        _tabBarController = [[UITabBarController alloc]init];
        _tabBarController.delegate = self;
        _tabBarController.view.backgroundColor = kWhiteColor;
    }
    return _tabBarController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self dealFirstLaunch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 处理是否是第一次打开程序/是更新后的第一次打开程序
- (void)dealFirstLaunch
{
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

- (void)dealUserLogin
{
    UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
    if (user.loginedValue){
        [self startToLearn:NO];
    }else{
        [self startToLogin:NO];
    }
}

- (void)startToLogin:(BOOL)animated
{
    [self.navigationController pushViewController:self.loginViewController animated:animated];
}

- (void)startToLearn:(BOOL)animated
{
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
    UIViewController *_itemListViewController = [[UIViewController alloc] init];
    _itemListViewController.title = MyLocal(@"学习", @"");
    _itemListViewController.tabBarItem.image = kiOS7_OR_LATER ? [imgHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:imgHome;
    _itemListViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ico_tabbar_item_home_sel"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:_itemListViewController];
    
    UIImage *imgCommunity = [UIImage imageNamed:@"ico_tabbar_item_community"];
    UITableViewController *_communityViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    _communityViewController.title = MyLocal(@"社区", @"");
    _communityViewController.tabBarItem.image = kiOS7_OR_LATER ? [imgCommunity imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:imgCommunity;
    _communityViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ico_tabbar_item_community_sel"];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:_communityViewController];
    
    UIImage *imgMore = [UIImage imageNamed:@"ico_tabbar_item_more"];
    HSMoreViewController *_moreViewController = [[HSMoreViewController alloc] init];
//    _moreViewController.delegate = self;
    _moreViewController.title = MyLocal(@"更多", @"");
    _moreViewController.tabBarItem.image = kiOS7_OR_LATER ? [imgMore imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:imgMore;
    _moreViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ico_tabbar_item_more_sel"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:_moreViewController];
    
    [self.tabBarController setViewControllers:@[nav1,nav2,nav3] animated:animated];
    
    [self.navigationController pushViewController:self.tabBarController animated:animated];
}

#pragma mark - tabBarController Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    /*
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
     */
    return YES;
}

#pragma mark - Login ViewController
- (void)loginFinish
{
    [self startToLearn:YES];
}

//HSMoreViewControllerDelegate 退出
-(void)logOut{

    UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
    user.isLogined = NO;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:self.loginViewController animated:NO];
    self.loginViewController.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.loginViewController.view.alpha = 1.0f;
    }];
}


#pragma mark - Custom Guid ViewController
- (void)guidUserToUse
{
    NSArray *arrImages = @[@"img_UG1.png", @"img_UG2.png", @"img_UG3.png", @"img_UG4.png", @"img_UG5.png"];
    UIGuidViewController *guidViewController = [[UIGuidViewController alloc] initWithNibName:nil bundle:nil guidPages:arrImages];
    guidViewController.delegate = self;
    
    [self.navigationController pushViewController:guidViewController animated:NO];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

#pragma mark - UIGuidViewController Delegate
- (void)guidViewController:(UIGuidViewController *)controller experienceAction:(id)sender
{
    [SoftwareVerisonDAL saveSoftwareVersionWithVersion:kSoftwareVersion dbVersion:kSoftwareVersion launched:YES completion:^(BOOL finished, id result, NSError *error) {}];
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:self.loginViewController animated:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

@end
