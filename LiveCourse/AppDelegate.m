//
//  AppDelegate.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/5.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "AppDelegate.h"
#import "HSAppearanceSet.h"

#import "KeyChainHelper.h"
#import "UserDAL.h"
#import "UserModel.h"

#import "NotificationNet.h"
#import "UpdateAppNet.h"

#import "UserLaterStatuModel.h"
#import "NSString+expand.h"
#import "SystemInfoHelper.h"

#import "NFFaceBookHelper.h"
#import "NFSinaWeiboHelper.h"

#import "HSLoginAndOutHandle.h"

// 谷歌转化分析
#import "ACTReporter.h"

#import "WeiboSDK.h"

#import "XGPush.h"
#import "XGSetting.h"
#import "HpnsNet.h"

@interface AppDelegate ()<UIAlertViewDelegate, WeiboSDKDelegate>
{
    BOOL isNotificationSetBadge;
    BOOL isNeedUpdateApp;
}

@property (strong, nonatomic) NotificationNet *notificationNet;
@property (strong, nonatomic) UpdateAppNet    *updateAppNet;

@property (nonatomic, strong) HpnsNet *hpnsNet;


@end

@implementation AppDelegate
- (NotificationNet *)notificationNet
{
    if (!_notificationNet)
    {
        _notificationNet = [[NotificationNet alloc] init];
    }
    return _notificationNet;
}

- (UpdateAppNet *)updateAppNet
{
    if (!_updateAppNet)
    {
        _updateAppNet = [[UpdateAppNet alloc] init];
    }
    return _updateAppNet;
}


/********************************** 注册消息推送 *******************************/
- (void)registerPushForIOS8
{
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}
/********************************** 注册消息推送 *******************************/



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    DLog(@"沙盒路径: %@", kDownloadedPath);
    DLog(@"当前语言: %@", currentLanguage());
    
    
    /******************************* APNS ****************************/
    dispatch_async(dispatch_get_main_queue(), ^{
        // 信鸽推送
//        DLog(@"id: %@; key: %@", @([XGID() unsignedIntValue]), XGKEY());
        [XGPush startApp:2200094765 appKey:@"IDL91D5H53WK"];
        // 注册账号
        [XGPush setAccount:kEmail];
        
        // 注销之后需要再次注册前的准备
        void (^successCallback)(void) = ^(void){
            // 如果变成需要注册状态
            if (![XGPush isUnRegisterStatus]) {
                if (kiOS8_OR_LATER) {
                    [self registerPushForIOS8];
                }else{
                    [self registerPush];
                }
            }
        };
        [XGPush initForReregister:successCallback];
        
        // 推送反馈回调版本示例
        void (^successBlock)(void) = ^(void){
            // 成功之后的处理
            DLog(@"[XGPush]handleLaunching's successBlock");
        };
        
        void (^errorBlock)(void) = ^(void){
            // 失败之后的处理
            DLog(@"[XGPush]handleLaunching's errorBlock");
        };
        
        // 角标清零
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    });
    /******************************* APNS ****************************/
    
    
    
    
    
    
//    NSString *null = @"(null)";
//    DLog(@"%@转化为数字: %ld; NULL: %@", null, (long)[null integerValue], NULL);
//    if (null == NULL) {
//        DLog(@"123");
//    }
//    NSUInteger time = [timeStamp() integerValue];
//    DLog(@"时间戳: %d; %@", time, timeStamp());
//    NSUInteger curTime = [timeStamp() integerValue];
    
    // Override point for customization after application launch.
    //MagicalRecord管理数据库
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    // 初始化用户语言，作为应用内切换语言时的依据。
    [GDLocalizableController initUserLanguage];
    
    /*
    UserModel *userModel = [UserDAL queryUserInfoWithUserID:kUserID];
    NSUInteger vipEndTime = userModel.roleEndDateValue;
    DLog(@"两个时间的比较: curTime: %ld, vipEneTime: %ld", curTime, vipEndTime);
     */
    //设置app外观
    [HSAppearanceSet setupGlobalAppearance];
    
    // 注册常用的数据
    [self registerKeyValueToUserDefaults];
    // 注册第三方的app管理
    [self registerThirdAppKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //UIViewController *controller = [[UIViewController alloc] init];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    //self.window.rootViewController = nav;
    [hsGetSharedInstanceClass(HSLoginAndOutHandle) dealFirstLaunch:NO];
    [self.window makeKeyAndVisible];
    
    kAddObserverNotification(self, @selector(changeLanguage:), kChangeLanguageNotification, nil);
    
    return YES;
}

-(void)changeLanguage:(NSNotification *)notification{
    self.window.rootViewController = nil;
    [hsGetSharedInstanceClass(HSLoginAndOutHandle) dealFirstLaunch:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 现在是因为继续学习是按照不同的用户，且按照不同的课程总类区分的。
    // 所以有必要保存一个用户上次退出时的课程种类ID。
    kSetUDCourseCategoryID(self.curCCID);
    // 保存用户最近的学习记录。
    [UserDAL saveUserLaterStatusWithUserID:[kUserID copy] categoryID:[self.curCCID copy] courseID:[self.curCID copy] unitID:[self.curUnitID copy] lessonID:[self.curLID copy] checkPointID:[self.curCpID copy] nexCheckPointID:[self.nexCpID copy] timeStamp:[timeStamp() integerValue] completion:^(BOOL finished, id result, NSError *error) {}];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 每次醒来都需要去判断是否得到device token
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
    // hide the badge
    application.applicationIconBadgeNumber = 0;
    
    
    // 检查当前app是否有更新信息
    //[self checkAppUpdateInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [NFFaceBookHelper close];
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DLog(@"sourceApplication: %@", sourceApplication);
    if ([sourceApplication isEqualToString:@"com.sina.weibo"])
    {
        BOOL sina = [WeiboSDK handleOpenURL:url delegate:self];
        return sina;
    }
    else
    {
        [NFFaceBookHelper handleStateChange];
        BOOL facebook = [NFFaceBookHelper handleFBOpenURL:url sourceApplication:sourceApplication];
        return facebook;
    }
    
    
    //BOOL tw = [hsGetSharedInstanceClass(HSTwitterHelper) handleTwitterOpenURL:url sourceApplication:sourceApplication];
    return NO;
}

#pragma mark - Weibo Delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    DLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    //DLog(@"%@", NSStringFromSelector(_cmd));
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]])
    {
        [NFSinaWeiboHelper sendMessageWithResponse:response];
    }
    else if ([response isKindOfClass:[WBAuthorizeResponse class]])
    {
        [NFSinaWeiboHelper authorizeWithResponse:response];
    }
}


#pragma mark -  注册一些常用数据
- (void)registerKeyValueToUserDefaults
{
    // 用户当前的ID
    NSDictionary *dicUserID  = [NSDictionary dictionaryWithObjectsAndKeys:@"0", kUDKEY_UserID, nil];
    [USER_DEFAULT registerDefaults:dicUserID];
    
    NSDictionary *dicEmail = [NSDictionary dictionaryWithObjectsAndKeys:@"", kUDKEY_Email, nil];
    [USER_DEFAULT registerDefaults:dicEmail];
    
    // 选择的词书种类的ID
    NSDictionary *dicCID  = [NSDictionary dictionaryWithObjectsAndKeys:@"0", kUDKEY_CourseCategoryID, nil];
    [USER_DEFAULT registerDefaults:dicCID];
    
    // 选择的词书的ID
    NSDictionary *dicBID  = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], isTempUser, nil];
    [USER_DEFAULT registerDefaults:dicBID];
    
    // 设备令牌是否已注册。
    NSDictionary *dicDevToken  = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kDeviceTokenRegisteredKey, nil];
    
    [USER_DEFAULT registerDefaults:dicDevToken];
    [USER_DEFAULT synchronize];
}

#pragma mark - 注册第三方的追踪信息。
- (void)registerThirdAppKey
{
    NSString *version = kSoftwareVersion;
    //新浪
    [NFSinaWeiboHelper registerApp];
    
    //facebook
    [NFFaceBookHelper registerApp];
    // 谷歌分析
    // 1
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // 2
#ifdef DEBUG
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelNone];
#else
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
#endif
    
    // 3
    [GAI sharedInstance].dispatchInterval = 20;
    id tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-59674146-1"];
    [tracker set:kGAIAppVersion value:version];
    [tracker set:kGAISampleRate value:@"50.0"];
    
    // 谷歌广告转化
    // hello daily-iOS
    // Google iOS Download tracking snippet
    // To track downloads of your app, add this snippet to your
    // application delegate's application:didFinishLaunchingWithOptions: method.
    [ACTConversionReporter reportWithConversionID:@"971962044" label:@"ggzsCJfQwFkQvO27zwM" value:@"0.00" isRepeatable:NO];
    
}

#pragma mark - 消息服务的注册与接收
// 消息通知服务
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    void (^successBlock)(void) = ^(void){
        // 成功之后的处理
        DLog(@"[XGPlush]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        DLog(@"[XGPlush]register errorBlock");
    };
    
    // 注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    //[[XGSetting getInstance] setGameServer:@""];
    
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //打印获取的deviceToken的字符串
    DLog(@"deviceTokenStr is %@, 长度: %@", deviceTokenStr, @([deviceTokenStr length]));
    
    //注册hpns设备
    [self.hpnsNet hpnsDeviceRegister:deviceTokenStr completion:^(BOOL finished, id result, NSError *error) {}];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    // 推送反馈(app运行时)
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        DLog(@"[XGPush]handleReceiveNotification successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        DLog(@"[XGPush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //失败之后的处理
        DLog(@"[xg push completion]userInfo is %@",userInfo);
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"regist failed: %@", error);
    /*
     NSString *msg = [[NSString alloc] initWithFormat:@"%@", error];
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"failed" message:msg delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:@"no", nil];
     [alert show];
     */
}

#ifdef kiOS8_OR_LATER
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //NSLog(@"注册成功");
//    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        DLog(@"ACCEPT_IDENTIFIER IS CLICKED");
    }
    
    completionHandler();
}

#endif

#pragma mark - 消息服务的注册与token的发送

- (void)registerForRemoteNotificationToGetToken
{
    //NSLog(@"Registering for push notifications...");
    
    // 注册device token， 需要注册remote notification
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 如果没有注册到令牌，则重新发送注册请求
    if (![userDefaults boolForKey:kDeviceTokenRegisteredKey])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            /*
             [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
             */
#ifdef kiOS8_OR_LATER
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            }  else {
                UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
            }
#else
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
        });
    }
    
    // 将远程通知的数量清零
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1、hide the local badge
        if ([[UIApplication sharedApplication] applicationIconBadgeNumber] == 0) {
            return;
        }
        
        // 2、ask the provider to set the BadgeNumber to zero
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *strDeviceToken = [userDefaults objectForKey:kDeviceTokenStringKey];
        [self resetBadgeNumberOnProviderWithDeviceToken:strDeviceToken];
    });
}

// 发送token
- (void)sendProviderDeviceToken:(NSString *)deviceTokenString
{
    // Establish the request
    //NSLog(@"sendProviderDeviceToken = %@", deviceTokenString);
    [self.notificationNet sendNotificationDeviceTokenWithUserID:kUserID token:deviceTokenString completion:^(BOOL finished, id obj, NSError *error) {}];
}

#pragma mark - 服务器消息数量的设置
- (void)resetBadgeNumberOnProviderWithDeviceToken:(NSString *)deviceTokenString
{
    isNotificationSetBadge = YES;
    
    [self.notificationNet resetNotificationBadgeWithUserID:kUserID token:deviceTokenString completion:^(BOOL finished, id obj, NSError *error) {
        if (isNotificationSetBadge == NO)
        {
            [USER_DEFAULT setBool:YES forKey:kDeviceTokenRegisteredKey];
            [USER_DEFAULT synchronize];
        }
        else
        {
            isNotificationSetBadge = NO;
        }
    }];
}

#pragma mark - 检查版本更新
- (void)checkAppUpdateInfo
{
    [self.updateAppNet checkAppUpdateInfoCompletion:^(BOOL finished, id obj, NSError *error) {
        if (finished)
        {
            isNeedUpdateApp = [obj boolValue];
            NSString *strIgnor = isNeedUpdateApp ? @"退出应用" : @"忽略";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocal(@"提示") message:error.domain delegate:self cancelButtonTitle:MyLocal(strIgnor) otherButtonTitles:MyLocal(@"立即更新"), nil];
            
            [alert show];
        }
    }];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        //NSString *appUrl = [[NSString alloc] initWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d", appID];
        NSString *appUrl = [[NSString alloc] initWithFormat:@"itms-apps://itunes.apple.com/us/app/id%ld?mt=8", (long)[kApplicationID integerValue]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        
        [HSBaseTool googleAnalyticsLogCategory:@"应用更新" action:@"应用ID" event:kApplicationID pageView:NSStringFromClass([self class])];
    }
    else
    {
        [HSBaseTool googleAnalyticsLogCategory:@"忽略更新" action:@"应用ID" event:kApplicationID pageView:NSStringFromClass([self class])];
    }
    
    if (isNeedUpdateApp){
        [self exitApplication];
    }
}

- (void)exitApplication
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.window.alpha = 0;
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

#pragma mark - 属性数据

//------------------ 属性 ------------------------
- (NSString *)curCCID
{
    if (!_curCCID)
    {
        _curCCID = [NSString isNullString:kCourseCategoryID] ? @"":kCourseCategoryID;
    }
    return _curCCID;
}

- (NSString *)curCID
{
    if (!_curCID)
    {
        UserLaterStatuModel *userLaterStatu = [UserDAL userLaterStatuWithUserID:kUserID courseCategoryID:kCourseCategoryID];
        _curCID = [NSString isNullString:userLaterStatu.cID] ? @"":userLaterStatu.cID;;
    }
    return _curCID;
}
 

- (NSString *)curUnitID
{
    if (!_curUnitID)
    {
        UserLaterStatuModel *userLaterStatu = [UserDAL userLaterStatuWithUserID:kUserID courseCategoryID:kCourseCategoryID];
        _curUnitID = [NSString isNullString:userLaterStatu.unitID] ? @"":userLaterStatu.unitID;
    }
    return _curUnitID;
}

- (NSString *)curLID
{
    if (!_curLID)
    {
        UserLaterStatuModel *userLaterStatu = [UserDAL userLaterStatuWithUserID:kUserID courseCategoryID:kCourseCategoryID];
        _curLID = [NSString isNullString:userLaterStatu.lID] ? @"":userLaterStatu.lID;
    }
    return _curLID;
}

- (HpnsNet *)hpnsNet
{
    if (!_hpnsNet) {
        _hpnsNet = [[HpnsNet alloc] init];
    }
    return _hpnsNet;
}


-(void)dealloc{
    kRemoveObserverNotification(self, kChangeLanguageNotification, nil);
}

@end
