//
//  HSTwitterHelper.m
//  HSWordsPass
//
//  Created by Lu on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSTwitterHelper.h"
#import "STTwitter.h"
#import "HSTwitterViewController.h"

#ifdef LEVEL_1
#define strTwitterAppKey          @"s5lccRyCbhHsuRDYz9txc0k9n"
#define strTwitterSecret       @"iLZKJzjfytQIXQPQY0v5U57oOj7hKEVPxTXESKceZ1L21o9q2X"

#elif LEVEL_2
#define strTwitterAppKey          @"aRHEvMb2dNSAQ64dACUhtoLqj"
#define strTwitterSecret       @"ZJmpCQDFxmlExm73Ac7BNJdikJwFB4wAJPb3UmZFkOLltyQUBd"

#elif LEVEL_3
#define strTwitterAppKey          @"R3hMnxiMfQNbNFqzB32Wa0B85"
#define strTwitterSecret       @"8DpP5IefyYq6Tjlq3FnqSXsLRbYsay4hP4faz9xWR9E28CQAqS"

#elif LEVEL_4
#define strTwitterAppKey          @"8Ax8D68x4fGUSvTWPqBCfHDgh"
#define strTwitterSecret       @"H1QskvwzEYx7Wk3zbLCpHuA5gOqM21MN5LwPeAdnijXUTwob7N"

#elif LEVEL_5
#define strTwitterAppKey          @"TuBHy0r2qXjR1FJBaudUDAT47"
#define strTwitterSecret       @"JWsQIXPnVGRf3yfGr81TmllvSavmjP465IweltZQvLo4YPDrKk"

#elif LEVEL_6
#define strTwitterAppKey          @"lnkIK1gwD5LJwV6SrcZ659C05"
#define strTwitterSecret       @"s5qn7U8vvClCmXi9OW8mJORfu68UWI7g5MR1y52Xhicg3OGjSJ"

#else

#define strTwitterAppKey          @"8Ax8D68x4fGUSvTWPqBCfHDgh"
#define strTwitterSecret       @"H1QskvwzEYx7Wk3zbLCpHuA5gOqM21MN5LwPeAdnijXUTwob7N"

#endif


void (^loginFinished)(NSString *userID, NSString *name, NSString *imageUrl, NSString *token);

void (^refreshShow)(NSString *);


@interface HSTwitterHelper ()

@property (nonatomic, strong) STTwitterAPI *twitter;

@end


@implementation HSTwitterHelper
{
    NSString *strToken;
    NSString *urlSchemesStr;
    NSString *oauthCallbackStr;
    
    UIViewController *parentViewController;
}

hsSharedInstanceImpClass(HSTwitterHelper)


-(void)startLogin:(UIViewController *)con finished:(void (^)(NSString *, NSString *, NSString *, NSString *))finished
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    urlSchemesStr = [[[[infoDictionary objectForKey:@"CFBundleURLTypes"] objectAtIndex:2] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
    
    oauthCallbackStr = [NSString stringWithFormat:@"%@://twitter_access_tokens/",urlSchemesStr];
    
    loginFinished = finished;
    
    //设置默认存储
    [self registerUserDefaults];
    
    _twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];

    
    //先通过是否安装app登陆,如果无法打开已安装app登陆  则打开浏览器登陆
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        DLog(@"打开客户端username%@",username);

        STTwitterAPI *tempApi = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strTwitterAppKey
                                                 consumerSecret:strTwitterSecret];
//        DLog(@"%@-----",tempApi.oauthAccessToken);
        
        [tempApi postTokenRequest:^(NSURL *url, NSString *oauthToken) {
            
            DLog(@"%@---------",url);
            NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
            strToken = d[@"oauth_token"];
            //保存信息并登陆
            [self getDetailInfo];
            
        } oauthCallback:oauthCallbackStr errorBlock:^(NSError *error) {
            DLog(@"%@",[error localizedDescription]);
        }];
        
    } errorBlock:^(NSError *error) {
        [hsGetSharedInstanceClass(HSBaseTool) HUDForView:con.view Title:MyLocal(@"登录", @"") isHide:YES position:HUDYOffSetPositionCenter];
        [self loginInWithController:(UIViewController *)con];
    }];

}

- (void)loginInWithController:(UIViewController *)controller
{
    _twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strTwitterAppKey
                                             consumerSecret:strTwitterSecret];
    DLog(@"appKey: %@", strTwitterAppKey);
    
    parentViewController = controller;
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        DLog(@"-- url: %@; oauthToken: %@",url, oauthToken);
        
        HSTwitterViewController *twitterViewController = [[HSTwitterViewController alloc] initwithTwitterType:kTwitterTypeLogin url:url];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:twitterViewController];
        [controller presentViewController:nav animated:YES completion:^{}];
        
        
    } authenticateInsteadOfAuthorize:NO
                    forceLogin:@(YES)
                    screenName:nil
                 oauthCallback:oauthCallbackStr
                    errorBlock:^(NSError *error) {
                        DLog(@"-- error: %@", error);
                    }];
}

//浏览器登陆
- (void)loginInSafariAction
{
    _twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strTwitterAppKey
                                                 consumerSecret:strTwitterSecret];
    DLog(@"appKey: %@", strTwitterAppKey);
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        DLog(@"-- url: %@; oauthToken: %@",url, oauthToken);
        //[[UIApplication sharedApplication] openURL:url];
        
        
        
    } authenticateInsteadOfAuthorize:NO
                    forceLogin:@(YES)
                    screenName:nil
                 oauthCallback:oauthCallbackStr
                    errorBlock:^(NSError *error) {
                        DLog(@"-- error: %@", error);
                    }];
}




- (BOOL)handleTwitterOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    
    if ([[url scheme] isEqualToString:urlSchemesStr] == NO)
    {
        return NO;
    }
    
    DLog(@"url=====%@",url);
    
    [parentViewController dismissViewControllerAnimated:YES completion:^{}];
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    strToken = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        
        DLog(@"-- screenName: %@", screenName);
        [self getDetailInfo];
        
    } errorBlock:^(NSError *error) {
        DLog(@"-- %@", [error localizedDescription]);
        
    }];
    
    return YES;
}


//处理接口返回数据
- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}



//获得用户详细信息
- (void)getDetailInfo
{
    [_twitter getAccountVerifyCredentialsWithSuccessBlock:^(NSDictionary *account) {
        
//        DLog(@"%@",account);
        NSString *userID = [account objectForKey:@"id_str"];
        NSString *name = [account objectForKey:@"screen_name"];
        NSString *imageUrl = [account objectForKey:@"profile_image_url"];
        NSString *token = strToken;
        
        [self refreshUserDefaultsWithTwitterToken:token TwitterUid:userID TwitterUName:name];
        
        //登陆验证
        loginFinished(userID,name,imageUrl,token);
    
    } errorBlock:^(NSError *error) {
        DLog(@"-- %@", [error localizedDescription]);
    }];
}



- (void)registerUserDefaults{
    NSDictionary *dicWbToken = [NSDictionary dictionaryWithObject:@"" forKey:@"TwitterToken"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbToken];
    
    NSDictionary *dicWbUid   = [NSDictionary dictionaryWithObject:@"" forKey:@"TwitterUid"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbUid];
    
    NSDictionary *dicWbName   = [NSDictionary dictionaryWithObject:@"Twitter" forKey:@"TwitterName"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbName];
}


- (void)refreshUserDefaultsWithTwitterToken:(NSString *)token TwitterUid:(NSString *)uid TwitterUName:(NSString *)name
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:@"TwitterName"];
    [userDefaults setObject:uid forKey:@"TwitterUid"];
    [userDefaults setObject:token forKey:@"TwitterToken"];
    [userDefaults synchronize];
}

- (NSString *)getScreenName
{
    NSString *screenName = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterName"];
    return screenName;
}


- (void)logOut:(void (^)(NSString *))refresh
{
    refreshShow = refresh;
    
    refresh(@"退出成功");
    
    _twitter = nil;

}




@end
