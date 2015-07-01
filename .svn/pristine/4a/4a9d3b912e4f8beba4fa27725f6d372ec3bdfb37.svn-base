//
//  HSMoreHeaderView.m
//  HelloHSK
//
//  Created by Lu on 14/11/18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMoreHeaderView.h"
//#import "DMDataManager.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UserDAL.h"
#import "UserNet.h"
#import "KeyChainHelper.h"
#import "HSRegisterViewController.h"

@interface HSMoreHeaderView ()
{
    UserNet *userNet;
}

@property (nonatomic, strong) UIImageView *userImgView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userCoinLabel;
@property (nonatomic, strong) UIImageView *coinIconImgView;
@property (nonatomic, strong) UIButton *createAccountBtn;
@property (nonatomic, strong) UILabel *lblVipTip;
@property (nonatomic, strong) UILabel *lblVipEndTime;

@end

@implementation HSMoreHeaderView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorMain;
        userNet = [[UserNet alloc] init];
        
        [self loadUI];
        [self loadData];
    }
    return self;
}

static NSDateFormatter *dateFormatter;
- (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = kCFDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setLocale: [NSLocale localeWithLocaleIdentifier:[GDLocalizableController userLanguage]]];
    }
    return dateFormatter;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.coinIconImgView.centerY = self.userCoinLabel.centerY;
    if (kIsTempUser) {
        if (kiPhone) {
            _createAccountBtn.top = 40;
        }else{
            _createAccountBtn.top = 60;
        }
        
    }
}

-(void)loadUI{
    UserModel *model = [UserDAL queryUserInfoWithUserID:kUserID];

    NSString *hsMoney = GDLocal(@"汉声币");
    NSString *coinStr = [NSString stringWithFormat:@"%@: %@",hsMoney,[model.coin stringValue]];
    self.userCoinLabel.text = coinStr;
    [self.userCoinLabel sizeToFit];
    
    self.userCoinLabel.centerX = self.width/2;
    self.userCoinLabel.bottom = self.height - 15;
    
    NSString *userTitle = MyLocal(@"用户名");
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@: %@",userTitle,model.name];
    
    [self.userNameLabel sizeToFit];
    self.userNameLabel.centerX = self.width/2;
    self.userNameLabel.bottom = self.userCoinLabel.top - 26;
    
    if ([UserDAL userVipRoleEnable])
    {
        NSString *vipEnd = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.roleEndDateValue]];
        NSString *vipEndFormat = [[NSString alloc] initWithFormat:MyLocal(@"VIP到期时间:%@"), vipEnd];
        self.lblVipEndTime.text = vipEndFormat;
        [self.lblVipEndTime sizeToFit];
        self.lblVipEndTime.centerX = self.width*0.5;
        self.lblVipEndTime.bottom = self.userCoinLabel.top - 6;
        
        self.lblVipTip.left = self.userNameLabel.right+2;
    }
    else
    {
        [_lblVipTip removeFromSuperview];
        _lblVipTip = nil;
        
        [_lblVipEndTime removeFromSuperview];
        _lblVipEndTime = nil;
        
        self.userImgView.top = 20;
        self.userNameLabel.bottom = self.userCoinLabel.top-8;
    }
    
    self.coinIconImgView.left = self.userCoinLabel.right + 5;
    
    //如果是游客 则显示创建账户按钮
    if (!kIsTempUser) {
        if (_createAccountBtn) {
            [_createAccountBtn removeFromSuperview];
            [_createAccountBtn removeAllSubviews];
            _createAccountBtn = nil;
        }
        UIImage *placeholderImage = [UIImage imageNamed:@"image_user_placeholder"];
        NSURL *url = [NSURL URLWithString:model.image];
        [self.userImgView sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.userImgView.image = image;
        }];
    }else{
        self.createAccountBtn.backgroundColor = kColorClear;
        self.createAccountBtn.centerX = self.width/2;
    }
}

-(void)loadData{
    
    [userNet requestUserInfoWithUserID:kUserID completion:^(BOOL finished, id result, NSError *error) {
        [self loadUI];
    }];
    
    /*
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...

        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新
        });
    });
     */
}


#pragma mark - ui
-(UILabel *)userCoinLabel{
    if (!_userCoinLabel) {
        _userCoinLabel = [[UILabel alloc] init];
        _userCoinLabel.backgroundColor = kColorClear;
        _userCoinLabel.textColor = kColorWhite;
        _userCoinLabel.font = [UIFont systemFontOfSize:14.0f];
        _userCoinLabel.height = 20.0f;
        [self addSubview:_userCoinLabel];
    }
    return _userCoinLabel;
}

-(UIImageView *)coinIconImgView{
    if (!_coinIconImgView) {
        UIImage *image = [UIImage imageNamed:@"icon_global_HSMoney"];
        _coinIconImgView = [[UIImageView alloc] initWithImage:image];
        _coinIconImgView.size = image.size;
        _coinIconImgView.centerY = self.userCoinLabel.centerY;
        _coinIconImgView.backgroundColor = kColorClear;
        [self addSubview:_coinIconImgView];
    }
    return _coinIconImgView;
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = kColorClear;
        _userNameLabel.textColor = kColorWhite;
        _userNameLabel.font = [UIFont systemFontOfSize:14.0f];
        _userNameLabel.height = 20.0f;
        [self addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

-(UIImageView *)userImgView{
    if (!_userImgView) {
        _userImgView = [[UIImageView alloc] init];
        if (kiPhone) {
            _userImgView.size = CGSizeMake(70, 70);
            _userImgView.layer.cornerRadius = 35.0f;
        }else{
            _userImgView.size = CGSizeMake(90, 90);
            _userImgView.layer.cornerRadius = 45.0f;
            
        }
        _userImgView.layer.masksToBounds = YES;
        
        _userImgView.centerX = self.width/2;
        _userImgView.top = 8;
        _userImgView.backgroundColor = kColorClear;
        
        _userImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_userImgView];
    }
    return _userImgView;
}

-(UILabel *)lblVipTip
{
    if (!_lblVipTip)
    {
        _lblVipTip = [[UILabel alloc] initWithFrame:CGRectMake(self.userNameLabel.right+2, self.userNameLabel.top, 60, 44)];
        _lblVipTip.text = @"(VIP)";
        _lblVipTip.font = kFontHel(14);
        _lblVipTip.textColor =  HEXCOLOR(0xFB5100);
        _lblVipTip.backgroundColor = kColorClear;
        [self addSubview:_lblVipTip];
        [_lblVipTip sizeToFit];
        
    }
    return _lblVipTip;
}

- (UILabel *)lblVipEndTime
{
    if (!_lblVipEndTime)
    {
        _lblVipEndTime = [[UILabel alloc] init];
        _lblVipEndTime.backgroundColor = kColorClear;
        _lblVipEndTime.height = 44;
        _lblVipEndTime.font = kFontHel(14);
        _lblVipEndTime.textColor = kColorWhite;
        [self addSubview:_lblVipEndTime];
    }
    return _lblVipEndTime;
}


-(UIButton *)createAccountBtn{
    if (!_createAccountBtn) {
        _createAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _createAccountBtn.size = CGSizeMake(150, 35);

        _createAccountBtn.top = 40;
        
//        _createAccountBtn.backgroundColor = kColorWhite;
        [_createAccountBtn setBackgroundImage:[UIImage imageNamed:@"image_more_tempUser_back"] forState:UIControlStateNormal];
        [_createAccountBtn addTarget:self action:@selector(createAccount:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //添加图标
        UIImage *iconImg = [UIImage imageNamed:@"more_tempUser_icon"];
        UIImageView *iconImgView = [[UIImageView alloc] initWithImage:iconImg];
        iconImgView.size = iconImg.size;
        iconImgView.centerY = _createAccountBtn.height/2;
        iconImgView.left = 10;
        iconImgView.backgroundColor = kColorClear;
        [_createAccountBtn addSubview:iconImgView];
        
        UILabel *createLabel = [[UILabel alloc] init];
        createLabel.height = _createAccountBtn.height;
        createLabel.backgroundColor = kColorClear;
        createLabel.text = MyLocal(@"创建个人档案");
        createLabel.font = [UIFont systemFontOfSize:15.0f];
        createLabel.textColor = kColorMain;
        [createLabel sizeToFit];
        createLabel.left = iconImgView.right + 10;
        createLabel.centerY = _createAccountBtn.height/2;
        [_createAccountBtn addSubview:createLabel];
        
        _createAccountBtn.width = iconImgView.width + createLabel.width + 30;
        _createAccountBtn.centerX = self.width/2;
        [self addSubview:_createAccountBtn];
        
    }
    return _createAccountBtn;
}


-(void)createAccount:(id)sender
{
    HSRegisterViewController *regist = [[HSRegisterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regist];
    [self.firstViewController presentViewController:nav animated:YES completion:^{
        
    }];
}


- (void)dealloc
{
    [userNet cancelLogin];
    userNet = nil;
    //DLOG_CMETHOD;
    dateFormatter = nil;
}

@end
