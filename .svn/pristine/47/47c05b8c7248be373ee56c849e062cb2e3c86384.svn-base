//
//  HSRegisterViewController.m
//  HelloHSK
//
//  Created by yang on 14-2-20.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSRegisterViewController.h"
#import "HSRegisterAreaView.h"
#import "PredicateHelper.h"
#import "KeyChainHelper.h"
#import "MBProgressHUD.h"
#import "UserNet.h"
#import "NFSinaWeiboHelper.h"
#import "NFFaceBookHelper.h"
#import "HSTwitterHelper.h"

#import "HSBaseTool.h"
#import "MessageHelper.h"
#import "GAIDictionaryBuilder.h"
#import "MessageHelper.h"

#import "FileHelper.h"

#import "HSLoginAndOutHandle.h"

NSString *const kUserRegisterNotification = @"UserRegisterNotification";

@interface HSRegisterViewController ()<MBProgressHUDDelegate>
{
    UITextField *tfEmail;
    UITextField *tfPassword;
    UITextField *tfRepassword;
    
    UIImage *imgBtnReg;
    UIButton *btnRegister;
    
    UIView *registAreaView;
    
    MBProgressHUD *HUD;
    HSRegisterAreaView *regAreaView;
    
    UserNet *userNet;
    
    UIButton *sinaBtn;
    UIButton *twitterBtn;
    UIButton *facebookBtn;
    
    CGFloat footerHeight;
}

@property (nonatomic, strong) UILabel *lblTextContent;

@end

@implementation HSRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        if (kIsTempUser) {
            self.title = MyLocal(@"创建个人档案");
        }else{
            self.title = MyLocal(@"注册");
        }
        
        [self loadImage];
        userNet = [[UserNet alloc] init];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideKeyBoard];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self unLoadImage];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    CreatViewControllerImageBarButtonItem(ImageNamed(@"ico_navigation_back"), @selector(back), self, YES);
    [self.tbvRegister setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    footerHeight = 160;
    
    NSString *path = [FileHelper FullPathInDocumentWithFilename:@"textContent.txt"];
    NSString *text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self refreshTextContent:text];
    
    __weak HSRegisterViewController *weakSelf = self;
    [userNet requestRegistTempContentWithType:@"1" completion:^(BOOL finished, id obj, NSError *error) {
        if (finished)
        {
            DLog(@"简单文本的内容: %@", obj);
            NSError *error;
            NSString *content = [[NSString alloc] initWithFormat:@"%@", obj];
            NSString *path = [FileHelper FullPathInDocumentWithFilename:@"textContent.txt"];
            // 写入文件
            [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
            NSString *text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            [weakSelf refreshTextContent:text];
        }
    }];
}

- (void)refreshTextContent:(NSString *)content
{
    self.lblTextContent.text = content;
    CGSize size = [content sizeWithFont:self.lblTextContent.font forWidth:self.lblTextContent.width lineBreakMode:self.lblTextContent.lineBreakMode];
    //CGSize size = CGSizeMake(84, 200);
    if (size.height > footerHeight)
    {
        footerHeight = size.height;
        self.lblTextContent.height = size.height;
    }
}

- (UILabel *)lblTextContent
{
    if (!_lblTextContent)
    {
        _lblTextContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tbvRegister.width, footerHeight)];
        _lblTextContent.font = kFontHel(14);
        _lblTextContent.textAlignment = NSTextAlignmentCenter;
        _lblTextContent.textColor = kColorWord;
        _lblTextContent.numberOfLines = 0;
    }
    return _lblTextContent;
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载/卸载图片
- (void)loadImage
{
    imgBtnReg = kiPhone ? ImageNamed(@"img_btn_blue") : ImageNamed(@"img_btn_Login");
}

- (void)unLoadImage
{
    imgBtnReg = nil;
}

#pragma mark - UIButton Action Manager
// 注册操作
- (void)registerAction:(id)sender
{
    if (![PredicateHelper validateEmail:tfEmail.text])
    {
        [MessageHelper makeToastWithMessage:GDLocal(@"请输入正确的邮箱地址") view:self.view];
        return;
    }
    if (![PredicateHelper validatePassword:tfPassword.text])
    {
        [MessageHelper makeToastWithMessage:GDLocal(@"请输入正确的密码") view:self.view];
        return;
    }
    if (![self isPasswordSameWithConfirm])
    {
        [MessageHelper makeToastWithMessage:GDLocal(@"两次输入密码不一致") view:self.view];
        return;
    }
    
    [HSBaseTool googleAnalyticsLogCategory:@"用户注册" action:@"账号操作" event:@"注册中" pageView:NSStringFromClass([self class])];
    
    [self hideKeyBoard];
    
    if (!HUD)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
	
	HUD.delegate = self;
	HUD.labelText = GDLocal(@"注册中");
	
	[HUD showWhileExecuting:@selector(registerRequest) onTarget:self withObject:nil animated:YES];
}

- (BOOL)isPasswordSameWithConfirm
{
    if (tfPassword && tfRepassword && [tfPassword.text isEqualToString:tfRepassword.text])
    {
        return YES;
    }
    return NO;
}

- (void)hideKeyBoard
{
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfRepassword resignFirstResponder];
}

#pragma mark - 网络请求管理
- (void)registerRequest
{
    __weak HSRegisterViewController *weakSelf = self;
    if (!kIsTempUser)
    {
        [userNet startRegistWithUserEmail:tfEmail.text password:tfPassword.text completion:^(BOOL finished, id result, NSError *error) {
            if (error.code == 0)
            {
                [KeyChainHelper saveUserName:tfEmail.text userNameService:KEY_USERNAME password:tfPassword.text passwordService:KEY_PASSWORD];
                if (kIsTempUser) {
                    kSetUDTempUser(NO);
                }
                // 注册成功之后直接登陆
                [weakSelf signIn];
            }
            
            if (error.domain && error.domain.length > 0)
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
    }else{
        [userNet startRegistTempUserWithUserEmail:tfEmail.text password:tfPassword.text completion:^(BOOL finished, id result, NSError *error) {
            if (error.code == 0)
            {
                [KeyChainHelper saveUserName:tfEmail.text userNameService:KEY_USERNAME password:tfPassword.text passwordService:KEY_PASSWORD];
                if (kIsTempUser) {
                    kSetUDTempUser(NO);
                }
                // 注册成功之后直接登陆
                [weakSelf signIn];
            }
            //[MessageHelper showMessage:error.domain view:self.view];
            if (error.domain && error.domain.length > 0)
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
}

- (void)registSuccess
{
    [KeyChainHelper saveUserName:tfEmail.text userNameService:KEY_USERNAME password:tfPassword.text passwordService:KEY_PASSWORD];
    if (kIsTempUser) {
        kSetUDTempUser(NO);
    }
}

- (void)signIn
{
    //HSAppDelegate.loginViewController.tfEmail.text = tfEmail.text;
    //HSAppDelegate.loginViewController.tfPassword.text = tfRepassword.text;
//    [self dismissViewControllerAnimated:YES completion:^{
//        [HSAppDelegate.loginViewController signIn];
//    }];
    [self dismissViewControllerAnimated:YES completion:^{
        [hsGetSharedInstanceClass(HSLoginAndOutHandle) loginFinish];
    }];
    
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (kIsTempUser) {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
        cell.backgroundView = [[UIView alloc] init];
        //cell.backgroundColor = [UIColor clearColor];
    }

    NSInteger row = [indexPath row];
    
    switch (row)
    {
        case 0:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HSRegisterAreaView" owner:nil options:nil];
            regAreaView = [nibs lastObject];
            regAreaView.frame = CGRectMake(0, 0, cell.contentView.width, 148.0f);
//            regAreaView.layer.cornerRadius = 8.0f;
//            regAreaView.layer.borderWidth = 0.16f;
            [cell.contentView addSubview:regAreaView];
            
            tfEmail = regAreaView.tfEmail;
            tfEmail.placeholder = @"example@mail.com";
            tfPassword = regAreaView.tfPassword;
            tfPassword.placeholder = GDLocal(@"6-16个字符");
            tfRepassword = regAreaView.tfRepassword;
            tfRepassword.placeholder = GDLocal(@"再次输入您的密码");
            tfEmail.delegate = self;
            tfPassword.delegate = self;
            tfRepassword.delegate = self;
            break;
        }
        case 1:
        {
            btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
            btnRegister.frame = CGRectMake(cell.width*0.05f*0.5f, 0.0f, cell.width*0.95f, 41.0f);
            btnRegister.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            UIImage *image = [imgBtnReg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
            [btnRegister setBackgroundImage:image forState:UIControlStateNormal];
            if (kIsTempUser) {
                [btnRegister setTitle:GDLocal(@"创建") forState:UIControlStateNormal];
            }else{
                [btnRegister setTitle:GDLocal(@"注册") forState:UIControlStateNormal];
            }

            [btnRegister addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnRegister];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
        if (kIsTempUser) {
            case 2:
            {
                if (!facebookBtn) {
                    UIImage *facebookIconImg = [UIImage imageNamed:@"facebook_a"];
                    facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    facebookBtn.size = facebookIconImg.size;
                    facebookBtn.centerX = cell.width/2;
                    facebookBtn.centerY = cell.height/2;
                    facebookBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                    [facebookBtn setImage:facebookIconImg forState:UIControlStateNormal];
                    [facebookBtn addTarget:self action:@selector(btnFaceBookClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.contentView addSubview:facebookBtn];
                }
                
                if (!twitterBtn) {
                    UIImage *twitterIconImg = [UIImage imageNamed:@"twitter_a"];
                    twitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    twitterBtn.size = twitterIconImg.size;
                    twitterBtn.right = cell.width - 10;
                    twitterBtn.centerY = cell.height/2;
                    twitterBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    [twitterBtn setImage:twitterIconImg forState:UIControlStateNormal];
                    [twitterBtn addTarget:self action:@selector(btnTwitterClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:twitterBtn];
                }
                
                if (!sinaBtn) {
                    UIImage *sinaIconImg = [UIImage imageNamed:@"weibo_a"];
                    sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    sinaBtn.size = sinaIconImg.size;
                    sinaBtn.right = cell.width - 70;
                    sinaBtn.centerY = cell.height/2;
                    sinaBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    [sinaBtn setImage:sinaIconImg forState:UIControlStateNormal];
                    [sinaBtn addTarget:self action:@selector(btnSinaClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:sinaBtn];
                }
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                break;
            }
        }
        
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!tableView.tableHeaderView)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        NSString *title = [[NSString alloc] initWithFormat:@"  %@", MyLocal(@"注册汉声账号")];
        UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, tableView.width, 22)];
        lblHeader.font = kFontHel(16);
        lblHeader.textColor = kColorWord;
        lblHeader.text = title;
        [view addSubview:lblHeader];
        return view;
    }
    return tableView.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.lblTextContent;
}

#pragma mark - 第三方注册
- (void)btnSinaClick:(id)sender{
    [NFSinaWeiboHelper startLoginWitnVC:self andfinished:^(NSString *userID, NSString *name, NSString *userEmail, NSString *img, NSString *token) {
        [self thridRegisterActionWithUserID:userID Email:userEmail name:name token:token img:img identifier:@"Weibo"];
    }];
}


- (void)btnTwitterClick:(id)sender{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hsGetSharedInstanceClass(HSTwitterHelper) startLogin:self finished:^(NSString *userID, NSString *name, NSString *imageUrl, NSString *token) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self thridRegisterActionWithUserID:userID Email:@"" name:name token:token img:imageUrl identifier:@"Twitter"];
    }];
    
}

- (void)btnFaceBookClick:(id)sender{
    [NFFaceBookHelper startLogin:^(NSString *userID, NSString *name, NSString *userEmail, NSString *img, NSString *token) {
        [self thridRegisterActionWithUserID:userID Email:userEmail name:name token:token img:img identifier:@"Facebook"];
    }];
}

- (void)thridRegisterActionWithUserID:(NSString *)userID Email:(NSString *)userEmail name:(NSString *)name token:(NSString *)token img:img identifier:(NSString *)identifier
{
    __weak HSRegisterViewController *weakSelf = self;
    [userNet startThirdRegistWithUserID:userID name:name identifier:identifier completion:^(BOOL finished, id result, NSError *error) {
        
        if (error.code == 0)
        {
            if (kIsTempUser) {
                kSetUDTempUser(NO);
            }
            // 注册成功之后直接登陆
            [weakSelf signIn];
        }
        else
        {
            // 显示信息
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocal(@"创建失败!") message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = kTableViewRowHeight;
    NSInteger row = [indexPath row];
    if (0 == row)
    {
        rowHeight = 165.0f;
    }
    return rowHeight;
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ((textField == tfPassword) && range.location >= 16)
    {
        return NO;
    }
    if ((textField == tfRepassword) && range.location >= 16)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:tfEmail])
    {
        [tfPassword becomeFirstResponder];
    }
    else if ([textField isEqual:tfPassword])
    {
        [tfRepassword becomeFirstResponder];
    }
    else
    {
        [self registerAction:btnRegister];
    }
    return YES;
}


#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	if (HUD)
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [_tbvRegister removeFromSuperview];
    self.tbvRegister = nil;
    
    [regAreaView removeFromSuperview];
    regAreaView = nil;
    
    [tfEmail removeFromSuperview];
    tfEmail = nil;
    
    [tfPassword removeFromSuperview];
    tfPassword = nil;
    
    [tfRepassword removeFromSuperview];
    tfRepassword = nil;
    
    imgBtnReg = nil;;
    [btnRegister removeFromSuperview];
    btnRegister = nil;
    
    [registAreaView removeFromSuperview];
    registAreaView = nil;
}

@end
