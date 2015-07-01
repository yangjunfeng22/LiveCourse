//
//  NFSinaWeiboHelper.m
//  WalkMan
//
//  Created by yang on 14-8-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "NFSinaWeiboHelper.h"

#import "WeiboSDK.h"

#import "HSSinaWeiboViewController.h"
#import "AppDelegate.h"

//新浪微博
#define kWB_OAuth_URL       @"https://api.weibo.com/oauth2/authorize"
#define kWB_AccessToken_URL @"https://api.weibo.com/oauth2/access_token"
#define kWB_RedirectURL     @"https://api.weibo.com/oauth2/default.html"
#define kWB_UserInfoURL     @"https://api.weibo.com/2/users/show.json"

#define kWB_AppKey          @"3313929011"
#define kWB_AppSecret       @"51333ed2496901e4cbcf7ecd6507b8a4"



void (^loginFinished)(NSString *userID, NSString *name,NSString *userEmail, NSString *img, NSString *token);

void (^refreshShow)(NSString *);

void (^authoWithUrlFinished)(NSString *);

void (^authoFinished)(NSString *);

@interface NFSinaWeiboHelper ()<WBHttpRequestDelegate>
{
    id instance;
}

@end

NSString *userMessage;
NSString *userImage;
@implementation NFSinaWeiboHelper
{
    
}
+ (void)registerApp
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWB_AppKey];
    
    [self registerUserDefaults];
}

+ (void)registerUserDefaults
{
    NSDictionary *dicWbToken = [NSDictionary dictionaryWithObject:@"" forKey:@"WBToken"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbToken];
    
    NSDictionary *dicWbUid   = [NSDictionary dictionaryWithObject:@"" forKey:@"WBUid"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbUid];
    
    NSDictionary *dicWbName   = [NSDictionary dictionaryWithObject:@"新浪微博" forKey:@"WBName"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbName];
}

+ (void)refreshUserDefaultsWithWBToken:(NSString *)token WBUid:(NSString *)uid WBUName:(NSString *)name
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:@"WBName"];
    [userDefaults setObject:uid forKey:@"WBUid"];
    [userDefaults setObject:token forKey:@"WBToken"];
    [userDefaults synchronize];
}

+(void)startLoginWitnVC:(UIViewController *)controller andfinished:(void (^)(NSString *, NSString *, NSString *, NSString *, NSString *))finished
{
    //refreshShow = refresh;
    loginFinished = finished;
    if ([WeiboSDK isWeiboAppInstalled])
    {
        // 客户端请求的方式登陆
        [self sendAuthorizeRequest];
    }
    else
    {
        HSSinaWeiboViewController *weiboViewController = [[HSSinaWeiboViewController alloc] initwithWeiboType:kWeiboTypeLogin];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:weiboViewController];
        [controller presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

#pragma mark - Authorize

+ (void)sendAuthorizeRequest
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWB_RedirectURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From":@"User",
                         @"Other_Info_1":[NSNumber numberWithInt:1],
                         @"Other_Info_2":@[@"obj1", @"obj2"],
                         @"Other_Info_3":@{@"key1":@"obj1", @"key2":@"obj2"}};
    
    [WeiboSDK sendRequest:request];
}

+ (void)authorizeWithResponse:(WBAuthorizeResponse *)response
{
    @autoreleasepool
    {
        DLog(@"%@", NSStringFromSelector(_cmd));
        //NSLog(@"%@, %ld", response, response.statusCode);
        if (response.statusCode == 0)
        {
            __block NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
            __block NSString *uid = [(WBAuthorizeResponse *)response userID];
            
            NSString * oathString = [NSString stringWithFormat:@"%@?uid=%@&access_token=%@", kWB_UserInfoURL, uid, accessToken];
            
            dispatch_queue_t queue = dispatch_queue_create("com.hschinese.hsk", nil);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:oathString]];
                NSDictionary *dicUser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSString *uname = [dicUser objectForKey:@"screen_name"];
                NSString *img = [dicUser objectForKey:@"avatar_large"];
                DLog(@"uname: %@", uname);
                [self refreshUserDefaultsWithWBToken:accessToken WBUid:uid WBUName:uname];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (loginFinished){
                        loginFinished(uid, uname, @"",img, accessToken);
                    }
//                    dispatch_release(queue);
                });
            });
        }
        else
        {
            // 具体的错误信息。
            /*
            WeiboSDKResponseStatusCodeSuccess               = 0,//成功
            WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
            WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
            WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
            WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
            WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
            WeiboSDKResponseStatusCodeUnknown               = -100,
             */
        }
    }
}

#pragma mark - Share Manager

-(void)startShareWithMessage:(NSString *)message andImage:(NSString *)image refresh:(void (^)(NSString *))refresh
{
    refreshShow = refresh;
    
    userMessage = message;
    userImage = image;
    
    // 客户端请求的方式分享

    if ([WeiboSDK isWeiboAppInstalled])
    {
        // 客户端请求的方式分享
        [self sendShareRequest];
    }
    else
    {
    
        HSSinaWeiboViewController *weiboViewController = [[HSSinaWeiboViewController alloc] initwithWeiboType:kWeiboTypeShare];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:weiboViewController];
        [HSAppDelegate.window.rootViewController presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

- (void)sendShareRequest
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"ShareMessageFrom":@"User",
                         @"Other_Info_1":[NSNumber numberWithInt:123],
                         @"Other_Info_2":@[@"obj1", @"obj2"],
                         @"Other_Info_3":@{@"key1":@"obj1", @"key2":@"obj2"}};
    [WeiboSDK sendRequest:request];
    
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = userMessage;
    if (userImage) {
        WBImageObject *image = [WBImageObject object];
        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:userImage ofType:@"png"]];
        message.imageObject = image;
    }
    return message;
}

+ (void)sendMessageWithResponse:(WBSendMessageToWeiboResponse *)response
{
    @autoreleasepool
    {
        if (response.statusCode == 0)
        {
            DLog(@"response userInfo: %@ requestUserInfo: %@", response.userInfo, response.requestUserInfo);
            refreshShow(@"分享成功");
        }
        else
        {
            switch (response.statusCode) {
                case WeiboSDKResponseStatusCodeUserCancel:
                    refreshShow(MyLocal(@"取消分享"));
                    break;
                    
                case WeiboSDKResponseStatusCodeAuthDeny:
                    refreshShow(MyLocal(@"授权失败"));
                    break;
                    
                default:
                    refreshShow(MyLocal(@"分享失败"));
                    break;
            }
            
            // 具体的错误信息。
            /*
             WeiboSDKResponseStatusCodeSuccess               = 0,//成功
             WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
             WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
             WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
             WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
             WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
             WeiboSDKResponseStatusCodeUnknown               = -100,
             */
        }
    }
}

#pragma mark - AuthorizedWithURL
+ (BOOL)startAuthorizeWithURL:(NSURL *)url finished:(void (^)(NSString *))refresh
{
    authoWithUrlFinished = refresh;
    NSString *backURLString = [url absoluteString];
    
    //判断是否是授权调用返回的url
    
    if ([backURLString hasPrefix:kWB_RedirectURL])
    {
        DLog(@"回调地址");
        // 找到”code＝“的range。
        NSRange range = [backURLString rangeOfString:@"code="];
        
        // 根据”code＝“的range确定code的参数值的range。
        NSRange codeRange = NSMakeRange(range.location+range.length, backURLString.length-(range.location+range.length));
        
        // 获取 code的值
        NSString *strCode = [backURLString substringWithRange:codeRange];
        [self getWidboAccessTokenWithCode:strCode];
        
        return NO;
    }
    return YES;
}

+ (void)getWidboAccessTokenWithCode:(NSString *)code
{
    //access token调用URL的string
    NSMutableString *accessTokenUrlString = [[NSMutableString alloc] initWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@", kWB_AccessToken_URL, kWB_AppKey, kWB_AppSecret, kWB_RedirectURL, code];
    //[accessTokenUrlString appendString:code];
    
    //同步POST请求
    NSURL *urlstring = [NSURL URLWithString:accessTokenUrlString];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlstring cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    //第三步，连接服务器
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         
         __block NSString *accesstoken = [dictionary objectForKey:@"access_token"];
         __block NSString *uid = [dictionary objectForKey:@"uid"];
         
         NSString * oathString = [NSString stringWithFormat:@"%@?uid=%@&access_token=%@", kWB_UserInfoURL, uid, accesstoken];
         
         dispatch_queue_t queue = dispatch_queue_create("com.yjf.walkman", nil);
         dispatch_async(queue, ^{
             NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:oathString]];
             
             NSDictionary *dicUser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             DLog(@"user: %@", dicUser);
             
             NSString *screenName = [dicUser objectForKey:@"screen_name"];
             NSString *img = [dicUser objectForKey:@"avatar_large"];
             dispatch_async(dispatch_get_main_queue(), ^{
                
                 [self refreshUserDefaultsWithWBToken:accesstoken WBUid:uid WBUName:screenName];
                 
                 if (loginFinished){
                     loginFinished(uid, screenName, @"",img, accesstoken);
                 }
                 
                 if (authoWithUrlFinished){
                     authoWithUrlFinished(screenName);
                 }
                 
//                 dispatch_release(queue);
             });
         });
         
     }];
    
}

#pragma mark -
+ (NSString *)oauthUrlString
{
    NSString *oauthUrlString = [[NSString alloc] initWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&display=mobile&state=authorize", kWB_OAuth_URL, kWB_AppKey, kWB_RedirectURL];
    return oauthUrlString;
}

+ (NSString *)shareUrlString
{
    //NSString *UrlString = @"http://service.weibo.com/share/share.php?appkey=3313929011&url=www.baidu.com&location&title=123&source=&sourceUrl=&content=gb2312&pic=www.bidu.com";//@"http://service.weibo.com/share/share.php?appkey=3313929011&url=%E5%86%85%E5%AE%B9%E9%93%BE%E6%8E%A5%7C%E9%BB%98%E8%AE%A4%E5%BD%93%E5%89%8D%E9%A1%B5location&title=%E6%88%91%E6%98%AF%E4%B8%80%E4%B8%AA%E5%A5%BD%E5%AD%A9%E5%AD%90&source=&sourceUrl=&content=%E9%A1%B5%E9%9D%A2%E7%BC%96%E7%A0%81gb2312|utf-8%E9%BB%98%E8%AE%A4gb2312&pic=%E5%9B%BE%E7%89%87%E9%93%BE%E6%8E%A5%7C%E9%BB%98%E8%AE%A4%E4%B8%BA%E7%A9%BA";//@"http://v.t.sina.com.cn/share/share.php?appkey=3313929011";//[[NSString alloc] initWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&display=mobile&state=authorize", kWB_OAuth_URL, kWB_AppKey, kWB_RedirectURL];
    NSString *UrlString = [[NSString alloc] initWithFormat:@"http://service.weibo.com/share/share.php?appkey=3313929011&url=%@&location=&title=%@&source=&sourceUrl=&content=gb2312", @"www.hschinese.com", @""];
    
    
    return UrlString;
}

+ (NSString *)accessToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"WBToken"];
}

+ (NSString *)getScreenName;
{
    NSString *screenName = [[NSUserDefaults standardUserDefaults] objectForKey:@"WBName"];
    return screenName;
}

+ (void)logOut:(void (^)(NSString *))refresh
{
    refreshShow = refresh;
    
    NFSinaWeiboHelper *weiboHelper = [[NFSinaWeiboHelper alloc] init];
    [weiboHelper logOutCurrentUser];
}

- (void)logOutCurrentUser
{
    if (!instance)
    {
        instance = self;
        NSString *wbToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"WBToken"];
        DLog(@"token: %@", wbToken);
        [WeiboSDK logOutWithToken:wbToken delegate:self withTag:@"User"];
    }
}

#pragma mark - WBHttpRequest Delegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    //instance = nil;
    NSString *strInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    DLog(@"%@: %@; strInfo: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), strInfo);
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    DLog(@"%@: %@; result: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), result);
    
    [NFSinaWeiboHelper refreshUserDefaultsWithWBToken:@"" WBUid:@"" WBUName:@"新浪微博"];
    
    // block回调
    refreshShow(@"新浪微博");
    
    instance = nil;
}

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    //instance = nil;
    DLog(@"%@: %@; response: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), response);
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    instance = nil;
    DLog(@"%@: %@; error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
}

#pragma mark - Handle OpenURL
+ (BOOL)handleWBOpenURL:(NSURL *)url delegate:(id)delegate
{
    return [WeiboSDK handleOpenURL:url delegate:delegate];
}

#pragma mark -
- (void)dealloc
{
    instance = nil;
}

@end
