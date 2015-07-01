//
//  HSLoginViewController.m
//  HelloHSK
//
//  Created by yang on 14-2-20.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSLoginViewController.h"
#import "HSRegisterViewController.h"
#import "PredicateHelper.h"
#import "KeyChainHelper.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "UserNet.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "NFSinaWeiboHelper.h"
#import "NFFaceBookHelper.h"
#import "HSTwitterHelper.h"
#import "HSBaseTool.h"
#import "MessageHelper.h"
#import "HSLoginAndOutHandle.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "GDLocalizableController.h"

@interface HSLoginViewController ()<MBProgressHUDDelegate>
{
    CGPoint center;
    MBProgressHUD *HUD;
    UserNet *userNet;
    
    UIImage *imgBtnLogin;
    
    NSString *email;
    NSString *pwd;
}

@property (nonatomic, strong) UIButton *btnSina;
@property (nonatomic, strong) UIButton *btnTwitter;
@property (nonatomic, strong) UIButton *btnFaceBook;
@property (nonatomic, strong) UIButton *tempUserBtn;//随便看看按钮
@property (weak, nonatomic) IBOutlet UIImageView *imgvTopArea;

@property (nonatomic, strong) ASImageNode *imageNode;

@end

@implementation HSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self loadImage];
        userNet = [[UserNet alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    [self initKeyBorderNotification];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    DLOG_CMETHOD;
    [super viewDidAppear:animated];
    [HSBaseTool googleAnalyticsPageView:NSStringFromClass([self class])];

    center = self.view.center;
    [self refreshUserEmailContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideKeyBoard];
    [self removeKeyBorderNotification];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self unLoadImage];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    DLOG_CMETHOD;
    [super viewDidLoad];
    
    self.lblEmail.text = GDLocal(@"Email:");
    self.lblPassword.text = GDLocal(@"密码:");
    self.tfEmail.placeholder = GDLocal(@"汉声账号");
    self.tfPassword.placeholder = GDLocal(@"6-16个字符");
    self.btnSignIn.titleLabel.font = kiPhone ? kFontHel(18):kFontHel(22);
    [self.btnSignIn setTitle:GDLocal(@"登录") forState:UIControlStateNormal];
    [self.btnSignIn setBackgroundImage:nil forState:UIControlStateNormal];
    self.btnSignIn.backgroundColor = kColorMain;
    // 对登录按钮的宽度添加约束
    CGFloat width = [[UIScreen mainScreen] bounds].size.width*(kiPhone ?  0.9:0.67);
    DLog(@"width: %f", width);
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.btnSignIn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:width];
    if (![self.btnSignIn.constraints containsObject:constraint]) {
        [self.btnSignIn addConstraint:constraint];
    }
    CGFloat height = kiPhone ? 44 : 72;
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:self.btnSignIn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    if (![self.btnSignIn.constraints containsObject:constraintHeight]) {
        [self.btnSignIn addConstraint:constraintHeight];
    }
    self.btnSignIn.layer.cornerRadius = height*0.5;
    self.btnRegister.layer.cornerRadius = height*0.5;
    
    height = kiPhone ? self.loginAreaView.height : 160;
    NSLayoutConstraint *consLoginAreaHeight = [NSLayoutConstraint constraintWithItem:self.loginAreaView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    if (![self.loginAreaView.constraints containsObject:consLoginAreaHeight]) {
        [self.loginAreaView addConstraint:consLoginAreaHeight];
    }
    
    CGFloat centerY = kiPhone ? -self.loginAreaView.height*0.25:-160*0.25;
    NSLayoutConstraint *consEmailCenterY = [NSLayoutConstraint constraintWithItem:self.tfEmail attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.loginAreaView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:centerY];
    if (![self.loginAreaView.constraints containsObject:consEmailCenterY]) {
        [self.loginAreaView addConstraint:consEmailCenterY];
    }
    
    centerY = kiPhone ? self.loginAreaView.height*0.25:160*0.25;
    NSLayoutConstraint *consPwdCenterY = [NSLayoutConstraint constraintWithItem:self.tfPassword attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.loginAreaView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:centerY];
    if (![self.loginAreaView.constraints containsObject:consPwdCenterY]) {
        [self.loginAreaView addConstraint:consPwdCenterY];
    }
    
    self.btnRegister.titleLabel.font = kiPhone ? kFontHel(18):kFontHel(22);
    [self.btnRegister setTitle:MyLocal(@"注册") forState:UIControlStateNormal];
    [self.btnRegister setBackgroundImage:nil forState:UIControlStateNormal];
    self.btnRegister.backgroundColor = kColorWhite;
    /*
    height = kiPhone ? 44 : 72;
    NSLayoutConstraint *consBtnReigstHeight = [NSLayoutConstraint constraintWithItem:self.btnRegister attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    if (![self.btnRegister.constraints containsObject:consBtnReigstHeight]) {
        [self.btnRegister addConstraint:consBtnReigstHeight];
    }
     */
    //self.btnRegister.layer.cornerRadius = self.btnRegister.height*0.5;
    
    [self.btnTempUser setTitle:MyLocal(@"游客登录") forState:UIControlStateNormal];
    
    UIFont *findPwdFont = kiPhone ? kFontHel(12):kFontHel(15);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:MyLocal(@"忘记密码?")];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSFontAttributeName value:findPwdFont range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:strRange];
    [self.btnFindPwd setAttributedTitle:str forState:UIControlStateNormal];
    [self.btnFindPwd sizeToFit];
    self.btnFindPwd.centerX = self.loginAreaView.centerX;
    
    [self refreshUserEmailContent];

    //self.btnSina.backgroundColor = [UIColor clearColor];
    //self.btnTwitter.backgroundColor = [UIColor clearColor];
    //self.btnFaceBook.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.imageNode.position = CGPointMake(self.imgvTopArea.width*0.5f, self.imgvTopArea.height*0.5);
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载/卸载图片
- (void)loadImage
{
    
}

- (void)unLoadImage
{

}

#pragma mark - 消息监听中心
// 添加监听键盘的弹出与关闭
- (void)initKeyBorderNotification
{
    //加入键盘事件的通知
    
    kAddObserverNotification(self, @selector(keyboardWillShow:), UIKeyboardWillShowNotification, nil);
    kAddObserverNotification(self, @selector(keyboardWillHide:), UIKeyboardWillHideNotification, nil);
}

// 移除键盘事件的监听
- (void)removeKeyBorderNotification
{
    kRemoveObserverNotification(self, UIKeyboardWillShowNotification, nil);
    kRemoveObserverNotification(self, UIKeyboardWillHideNotification, nil);
}

#pragma mark - 监听响应
// 用户注册
- (void)userRegisterSuccess:(NSNotification *)notification
{
    [self performSelectorOnMainThread:@selector(signIn) withObject:nil waitUntilDone:YES];
}

//-------------> 响应键盘显示事件 <------------------------
//    【主要思想是:将整体的view随键盘往上移动】
//------------------------------------------------------
- (void)keyboardWillShow:(NSNotification *)notification
{
    //先设定一个低于键盘顶部的阈值.
    CGFloat startOriginY   = self.btnSignIn.frame.origin.y + self.btnSignIn.frame.size.height+2.0f;
    NSDictionary *userInfo = [notification userInfo];

    //在键盘出现时,获取键盘的顶部坐标
    NSValue *aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect    = [aValue CGRectValue];
    keyboardRect           = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop    = keyboardRect.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    CGFloat distanceY = kiPhone ? keyboardTop - startOriginY : 0.0f;
    //根据键盘出现时的动画动态地改变输入区域的显示位置.(即把整个view上下移动)
    CGFloat newCenterY = self.view.center.y + distanceY;
    if (distanceY <= 0)
    {
        [UIView animateWithDuration:animationDuration animations:^{
            //将视图整体往上移动
            //根据键盘的顶部坐标,使输入框自适应,从而不被键盘遮挡.
            self.view.center = CGPointMake(self.view.center.x, newCenterY);
        }];
    }
}

//-------------> 响应键盘关闭事件 <------------------------
//    【主要思想是:将整体的view随键盘移动到正常位置】
//------------------------------------------------------
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    //获取键盘上下移动时动画的时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //将视图向下恢复到正常位置,并使用动画
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.center = center;
    }];
}

// 关闭键盘
- (void)hideKeyBoard
{
    [self.tfEmail resignFirstResponder];
    [self.tfPassword resignFirstResponder];
}

#pragma mark - UI 刷新管理
// 刷新用户的邮箱内容
- (void)refreshUserEmailContent
{
    NSString *aUserEmail = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    
    //第三方登陆的话 不显示邮箱
    if (_tfEmail && ![aUserEmail hasSuffix:@"Weibo.com"] && ![aUserEmail hasSuffix:@"Twitter.com"] && ![aUserEmail hasSuffix:@"Facebook.com"] && !kIsTempUser && ![aUserEmail hasSuffix:@"hschinese.anonymous"])
    {
        self.tfEmail.text = aUserEmail ? aUserEmail : @"";
    }
}

#pragma mark - UITouch Manager
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyBoard];
}

#pragma mark - UITextField Delegate Manager
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.tfPassword] && range.location >= 16)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_tfEmail])
    {
        [self.tfPassword becomeFirstResponder];
    }
    else if ([textField isEqual:self.tfPassword])
    {
        [self signInAction:self.btnSignIn];
    }
    return YES;
}

#pragma mark - UIButton Action Manager
// 登陆操作
- (IBAction)signInAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (![PredicateHelper validateEmail:self.tfEmail.text])
    {
        [MessageHelper makeToastWithMessage:MyLocal(@"请输入正确的邮箱地址", @"") view:self.view.window];
        return;
    }
    
    if (![PredicateHelper validatePassword:self.tfPassword.text])
    {
        [MessageHelper makeToastWithMessage:MyLocal(@"请输入正确的密码", @"") view:self.view.window];
        return;
    }
    
    [HSBaseTool googleAnalyticsLogCategory:@"用户登陆" action:@"账号操作" event:@"登陆" pageView:NSStringFromClass([self class])];
    
    email = self.tfEmail.text;
    pwd = self.tfPassword.text;
    
    [self hideKeyBoard];
    
    __weak HSLoginViewController *weakSelf = self;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [[NSString alloc] initWithFormat:@"%@...", MyLocal(@"登录")];
	
    NSString *strEmail = [self.tfEmail.text copy];
    NSString *strPwd = [self.tfPassword.text copy];
    [userNet startLoginWithUserEmail:email password:pwd completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        // 正确请求之后, 才登陆。
        if (error.code == 0)
        {
            //设置为真实用户
            kSetUDTempUser(NO);
            [KeyChainHelper saveUserName:strEmail userNameService:KEY_USERNAME password:strPwd passwordService:KEY_PASSWORD];
            [weakSelf signIn];
            
        }
        else
        {
            NSString *errorDomain = error.domain;
            if (![errorDomain isEqualToString:@"ASIHTTPRequestErrorDomain"])
            {
                [MessageHelper makeToastWithMessage:errorDomain view:weakSelf.view];
            }
            else
            {
                [MessageHelper makeToastWithMessage:MyLocal(@"网络不可用，请检查网络设置") view:weakSelf.view];
            }
        }
    }];
}

// 注册操作
- (IBAction)registerAction:(id)sender
{
    NSString *nibName = kiPhone ? @"HSRegisterViewController" : @"HSRegisterViewController";
    HSRegisterViewController *registerViewController = [[HSRegisterViewController alloc] initWithNibName:nibName bundle:nil];
//    [self.navigationController pushViewController:registerViewController animated:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    [self presentViewController:nav animated:YES completion:^{}];
}

- (IBAction)findPasswordAction:(id)sender
{
    if (![PredicateHelper validateEmail:self.tfEmail.text])
    {
        [MessageHelper makeToastWithMessage:GDLocal(@"请输入邮件地址") view:self.view.window];
        return;
    }
	
    NSString *lEmail = [self.tfEmail.text copy];
    __weak HSLoginViewController *weakSelf = self;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = MyLocal(@"正在发送消息...", @"");
    [userNet startFindBackUserPasswordWithEmail:lEmail completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        // 显示信息
        NSString *errorDomain = error.domain;
        if (![errorDomain isEqualToString:@"ASIHTTPRequestErrorDomain"])
        {
            [MessageHelper makeToastWithMessage:errorDomain view:weakSelf.view];
        }
        else
        {
            [MessageHelper makeToastWithMessage:MyLocal(@"网络不可用，请检查网络设置") view:weakSelf.view];
        }
    }];
}

#pragma mark - 网络请求管理

- (void)showMessage:(NSString *)message
{
    [MessageHelper makeToastWithMessage:message view:self.view.window];
}

- (void)signIn
{
    [hsGetSharedInstanceClass(HSLoginAndOutHandle) setLoginStatus:YES];
    
    self.tfPassword.text = @"";

    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFinish)]) {
        [self.delegate performSelector:@selector(loginFinish)];
    }
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    if (HUD)
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

#pragma mark - ui
- (ASImageNode *)imageNode
{
    if (!_imageNode)
    {
        _imageNode = [[ASImageNode alloc] init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIImage *img = ImageNamed(@"ico_app_tip");
            _imageNode.image = img;
            _imageNode.frame = CGRectMake(0.0f, 0.0f, img.size.width, img.size.height);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view addSubview:_imageNode.view];
            });
        });
    }
    return _imageNode;
}


-(UIButton *)btnSina{
    if (!_btnSina) {
        UIImage *sinaIconImg = ImageNamed(@"ico_sina");
        _btnSina        = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSina.size   = sinaIconImg.size;
        _btnSina.left   = self.btnSignIn.left + 110;
        _btnSina.bottom = self.view.bottom - 50;
        _btnSina.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _btnSina.backgroundColor = [UIColor clearColor];
        [_btnSina setImage:sinaIconImg forState:UIControlStateNormal];
        [_btnSina addTarget:self action:@selector(btnSinaClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnSina];
    }
    return _btnSina;
}

-(UIButton *)btnTwitter{
    if (!_btnTwitter) {
        UIImage *twitterIconImg = ImageNamed(@"ico_twitter");
        _btnTwitter      = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTwitter.size = twitterIconImg.size;
        _btnTwitter.left = self.btnSina.right + 20;
        _btnTwitter.top  = self.btnSina.top;
        _btnTwitter.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _btnTwitter.backgroundColor = [UIColor clearColor];
        [_btnTwitter setImage:twitterIconImg forState:UIControlStateNormal];
        [_btnTwitter addTarget:self action:@selector(btnTwitterClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnTwitter];
    }
    return _btnTwitter;
}

-(UIButton *)btnFaceBook{
    if (!_btnFaceBook) {
        UIImage *facebookIconImg = ImageNamed(@"ico_facebook");
        _btnFaceBook = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFaceBook.size = facebookIconImg.size;
        _btnFaceBook.left = self.btnTwitter.right + 30;
        _btnFaceBook.top = self.btnTwitter.top;
        _btnFaceBook.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _btnFaceBook.backgroundColor = [UIColor clearColor];
        [_btnFaceBook setImage:facebookIconImg forState:UIControlStateNormal];
        [_btnFaceBook addTarget:self action:@selector(btnFaceBookClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_btnFaceBook];
    }
    return _btnFaceBook;
}


//游登陆
-(UIButton *)tempUserBtn{
    if (!_tempUserBtn) {
        _tempUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tempUserBtn setTitle:MyLocal(@"游客登录", @"") forState:UIControlStateNormal];
        [_tempUserBtn setTitleColor:kColorWord forState:UIControlStateNormal];
        _tempUserBtn.size = CGSizeMake(100, 20);
        _tempUserBtn.centerY = self.btnSina.centerY;
        _tempUserBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _tempUserBtn.right = self.btnSignIn.right;
        _tempUserBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_tempUserBtn addTarget:self action:@selector(tempUserLoginAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_tempUserBtn];
    }
    return _tempUserBtn;
}

//临时用户登陆
- (IBAction)tempUserLoginAction:(id)sender
{
    __weak HSLoginViewController *weakSelf = self;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [userNet tempUserLoginWithCompletion:^(BOOL finished, id result, NSError *error) {
        [HUD hide:YES];
        if (error.code == 0) {
            
            [weakSelf signIn];
            //设置当前用户为临时用户
            kSetUDTempUser(YES);
            
        }else{
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GDLocal(@"登陆失败") message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //[alert show];
            NSString *errorDomain = [error.domain copy];
            if (![errorDomain isEqualToString:@"ASIHTTPRequestErrorDomain"])
            {
                [MessageHelper makeToastWithMessage:errorDomain view:weakSelf.view];
            }
            else
            {
                [MessageHelper makeToastWithMessage:MyLocal(@"网络不可用，请检查网络设置") view:weakSelf.view];
            }
        }
    }];
}

#pragma mark - 第三方登录
- (void)btnSinaClick:(id)sender{
    [NFSinaWeiboHelper startLoginWitnVC:self andfinished:^(NSString *userID, NSString *name, NSString *userEmail, NSString *img, NSString *token) {
        [self thridLoginActionWithUserID:userID Email:userEmail name:name token:token img:img identifier:@"Weibo"];
    }];
}

- (void)btnTwitterClick:(id)sender{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hsGetSharedInstanceClass(HSTwitterHelper) startLogin:self finished:^(NSString *userID, NSString *name, NSString *imageUrl, NSString *token) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self thridLoginActionWithUserID:userID Email:@"" name:name token:token img:imageUrl identifier:@"Twitter"];
    }];
    
}

- (void)btnFaceBookClick:(id)sender{
    [NFFaceBookHelper startLogin:^(NSString *userID, NSString *name, NSString *userEmail, NSString *img, NSString *token) {
        [self thridLoginActionWithUserID:userID Email:userEmail name:name token:token img:img identifier:@"Facebook"];
    }];
}


- (void)thridLoginActionWithUserID:(NSString *)userID Email:(NSString *)userEmail name:(NSString *)name token:(NSString *)token img:img identifier:(NSString *)identifier
{
    __weak HSLoginViewController *weakSelf = self;
    [userNet startThirdLoginWithUserID:userID Email:userEmail name:name token:token img:img identifier:identifier completion:^(BOOL finished, id result, NSError *error) {
        // 正确请求之后, 才登陆。
        if (error.code == 0)
        {
            [weakSelf signIn];
            [HUD hide:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocal(@"登陆失败", @"") message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];

}

#pragma mark - Memory Manager
- (void)dealloc
{
    [userNet cancelLogin];
    userNet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_lblEmail removeFromSuperview];
    [_lblPassword removeFromSuperview];
    
    _lblEmail = nil;
    _lblPassword = nil;
    
    [_tfEmail removeFromSuperview];
    [_tfPassword removeFromSuperview];
    
    _tfEmail = nil;
    _tfPassword = nil;
    
    [_btnSignIn removeFromSuperview];
    [_btnRegister removeFromSuperview];
    
    _btnSignIn = nil;
    _btnRegister = nil;
    
    [_loginAreaView removeFromSuperview];
    _loginAreaView = nil;

    email = nil;
    pwd = nil;
    
    imgBtnLogin = nil;
    
    [self hudWasHidden:HUD];
}

@end
