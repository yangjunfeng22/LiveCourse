//
//  HSVipShopViewController.m
//  LiveCourse
//
//  Created by Lu on 15/1/17.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSVipShopViewController.h"
#import "UIPayHSMoneyViewController.h"
#import "UserModel.h"
#import "UserNet.h"
#import "UserDAL.h"
#import "VipModel.h"
#import "MBProgressHUD.h"
#import "MessageHelper.h"

#pragma mark - vipShopItem
@interface vipShopItemButton ()

@property (nonatomic, strong) UIImageView *coinImageView;


@end


@implementation vipShopItemButton

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorClear;
        
        self.layer.cornerRadius = 7.0f;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [kColorMain CGColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}



//Ui

-(UIImageView *)coinImageView{
    if (!_coinImageView) {
        UIImage *coinImage = [UIImage imageNamed:@"icon_global_HSMoney"];
        _coinImageView = [[UIImageView alloc] initWithImage:coinImage];
        _coinImageView.backgroundColor = kColorClear;
        _coinImageView.size = coinImage.size;
        _coinImageView.center = CGPointMake(self.width/2, self.height/2);
        [self addSubview:_coinImageView];
    }
    return _coinImageView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        _timeLabel.width = self.coinImageView.left - 20;
        _timeLabel.backgroundColor = kColorClear;
        _timeLabel.textColor = kColorWord;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        CGFloat left = self.coinImageView.right + 20;
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 0, self.height)];
        _moneyLabel.width = self.width - left;
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.backgroundColor = kColorClear;
        _moneyLabel.textColor = HEXCOLOR(0xFF7B24);
        [self addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

@end



#pragma mark - HSVipShopViewController

@interface HSVipShopViewController ()<UIAlertViewDelegate>
{
    // 要购买的那个vip的ID。
    NSString *vipID;
    
    vipShopItemButton *vipBtn;
}

@property (nonatomic, strong) UIScrollView *mainScroll;

@property (nonatomic, strong) UIImageView *vipImageView; // VIP图标
@property (nonatomic, strong) UILabel *balanceLabel;//余额
@property (nonatomic, strong) UILabel *lblVipTip;
@property (nonatomic, strong) UILabel *lblVipEndTime;
@property (nonatomic, strong) UIImageView *hsMoneyImageView;//金额图标

@property (nonatomic, strong) UILabel *privilegeTitleLabel;//特权标题
@property (nonatomic, strong) UILabel *privilegeDescriptionLabel;//特权描述


@property (nonatomic, strong) UserNet *userNet;

@end

@implementation HSVipShopViewController
{
    NSInteger hsMoneyNum;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadHSMoney];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    
    CreatViewControllerImageBarButtonItem(ImageNamed(@"ico_navigation_back"), @selector(quit:), self, YES);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 28);
    [button setTitle:MyLocal(@"充值") forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0xFF7B24) forState:UIControlStateNormal];
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = HEXCOLOR(0xFF7B24).CGColor;
    button.layer.cornerRadius = 5.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(toPayHSMoney) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];

    self.title = MyLocal(@"VIP购买");
    
    [self loadData];
}

- (UserNet *)userNet
{
    if (!_userNet)
    {
        _userNet = [[UserNet alloc] init];
    }
    return _userNet;
}

static NSDateFormatter *dateFormatter;
- (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = kCFDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return dateFormatter;
}

-(void)loadData
{
    self.mainScroll.backgroundColor = kColorClear;
    
    self.vipImageView.backgroundColor = kColorClear;
    
    [self loadHSMoney];
    
    __weak HSVipShopViewController *weakSelf = self;
    
    __block CGFloat itemViewBottom = self.vipImageView.bottom + 20;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [[NSString alloc] initWithFormat:@"%@...", MyLocal(@"加载数据")];
    [self.userNet requestUserVipProductListWithUserID:kUserID completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        [weakSelf showVipItemList:result];
        
    }];
    
    self.privilegeTitleLabel.top = itemViewBottom + 20;
    self.privilegeDescriptionLabel.top = self.privilegeTitleLabel.bottom;
    NSString *str = @"";//@"普通会员可以享受考试点提供的高清付费学习资料和贴心服务，而Vip会员则可以在原基础上享受更多的专属服务和优惠特权。首先要再考试点注册，您注册的用户名。";
    self.privilegeDescriptionLabel.attributedText = [hsGetSharedInstanceClass(HSBaseTool) paragraphStyleAndString:str font:self.privilegeDescriptionLabel.font space:5];
    [self.privilegeDescriptionLabel sizeToFit];
    
    self.mainScroll.contentSize = CGSizeMake(0, self.privilegeDescriptionLabel.bottom + 40);
}

- (void)showVipItemList:(NSArray *)arrVips
{
    CGFloat itemViewBottom = self.vipImageView.bottom + 20;
    NSInteger itemFirstTop = self.balanceLabel.bottom + 20;
    NSInteger itemHeight = 40;
    NSInteger itemSpace = 15;
    NSInteger itemTop = 0;
    NSInteger i = 0;
    for (VipModel *vipModel in arrVips)
    {
        itemTop = itemFirstTop + i*(itemHeight + itemSpace);
        
        NSString *price = [[NSString alloc] initWithFormat:@"%@", vipModel.price];
        vipShopItemButton *itemView = [[vipShopItemButton alloc] initWithFrame:CGRectMake(25, itemTop, self.mainScroll.width - 50, itemHeight)];
        [itemView addTarget:self action:@selector(vipBuy:) forControlEvents:UIControlEventTouchUpInside];
        itemView.timeLabel.text = vipModel.duration;//[NSString stringWithFormat:@"%li个月",i+1];
        itemView.moneyLabel.text = price;
        itemView.vipID = vipModel.vID;
        [self.mainScroll addSubview:itemView];
        
        itemViewBottom = itemView.bottom;
        i++;
    }
    
    self.privilegeTitleLabel.top = itemViewBottom + 20;
    
    self.privilegeDescriptionLabel.top = self.privilegeTitleLabel.bottom;
    
    self.mainScroll.contentSize = CGSizeMake(0, self.privilegeDescriptionLabel.bottom + 40);
}

-(void)loadHSMoney
{
    UserModel *model = [UserDAL queryUserInfoWithUserID:kUserID];
    
    hsMoneyNum = [model.coin integerValue];
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%@%li",MyLocal(@"账户余额: "),(long)hsMoneyNum ];
    [self.balanceLabel sizeToFit];
    self.balanceLabel.centerX = self.mainScroll.width/2;
    
    if ([UserDAL userVipRoleEnable])
    {
        self.lblVipTip.left = _vipImageView.right+2;
        
        NSString *vipEnd = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.roleEndDateValue]];
        NSString *vipEndFormat = [[NSString alloc] initWithFormat:MyLocal(@"VIP到期时间:%@"), vipEnd];
        self.lblVipEndTime.text = vipEndFormat;
        [self.lblVipEndTime sizeToFit];
        
        self.lblVipEndTime.centerX = self.mainScroll.width*0.5;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.balanceLabel.top = self.vipImageView.bottom+28;
            self.lblVipEndTime.bottom = self.balanceLabel.top-5;
        }];
    }
    else
    {
        self.balanceLabel.top = self.vipImageView.bottom+15;
        
        [_lblVipTip removeFromSuperview];
        _lblVipTip = nil;
        
        [_lblVipEndTime removeFromSuperview];
        _lblVipEndTime = nil;
    }
    self.hsMoneyImageView.left = self.balanceLabel.right + 10;
    self.hsMoneyImageView.centerY = self.balanceLabel.centerY;
}

-(void)toPayHSMoney{
    UIPayHSMoneyViewController *payHSMoneyVC = [[UIPayHSMoneyViewController alloc] init];
    payHSMoneyVC.isAutoBack = YES;
    [self.navigationController pushViewController:payHSMoneyVC animated:YES];
}

#pragma mark - Action
- (void)quit:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)vipBuy:(id)sender
{
    //__weak HSVipShopViewController *weakSelf = self;
    vipBtn = (vipShopItemButton *)sender;
    
    // 进行购买
    vipID = [vipBtn.vipID copy];
    NSString *title = [[NSString alloc] initWithFormat:MyLocal(@"是否确认购买%@的VIP"), vipBtn.timeLabel.text];
    //NSString *title = [[NSString alloc] initWithFormat:@"%@%@%@%@VIP?", MyLocal(@"您确定花费"),vipBtn.moneyLabel.text,MyLocal(@"汉声币购买"), vipBtn.timeLabel.text];
//    if (kiOS8_OR_LATER)
//    {
//        __weak NSString *weakVipID = vipID;
//        __block UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:MyLocal(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            [controller dismissViewControllerAnimated:YES completion:^{}];
//        }];
//        [controller addAction:action];
//        
//        UIAlertAction *confirm = [UIAlertAction actionWithTitle:MyLocal(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            [weakSelf buyVip:weakVipID];
//            [controller dismissViewControllerAnimated:YES completion:^{}];
//        }];
//        [controller addAction:confirm];
//        [self presentViewController:controller animated:YES completion:^{}];
//    }
//    else
//    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:self cancelButtonTitle:MyLocal(@"取消") otherButtonTitles:MyLocal(@"确定"), nil];
        alert.tag = kAlertTag;
        [alert show];
//    }
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kAlertTag)
    {
        if (buttonIndex == 1) {
            /*
            if ([vipBtn.moneyLabel.text integerValue] > hsMoneyNum) {
                NSString *balanceStr = [NSString stringWithFormat:@"%@%li",MyLocal(@"账户余额: "),(long)hsMoneyNum ];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocal(@"汉声币余额不足") message:balanceStr delegate:self cancelButtonTitle:MyLocal(@"取消") otherButtonTitles:MyLocal(@"立即充值"), nil];
                [alert show];
            }else{
                [self buyVip:vipID];
            }
             */
            [self buyVip:vipID];
        }
    }else if (alertView.tag == kAlertTag + 1)
    {
        [self toPayHSMoney];
    }
    else
    {
        if (buttonIndex == 1) {
            [self toPayHSMoney];
        }
    }
}

- (void)buyVip:(NSString *)aVipID
{
    __weak HSVipShopViewController *weakSelf = self;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [[NSString alloc] initWithFormat:@"%@...", MyLocal(@"支付结果确认中")];
    [self.userNet requestUserVipBuyWithUserID:kUserID vipID:aVipID completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        if (finished)
        {
            // 购买成功
            [weakSelf loadHSMoney];
            
            NSString *message = MyLocal(@"恭喜你, VIP购买成功!");
            [MessageHelper showMessage:message view:weakSelf.view];
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(vipShop:finishedBuy:)]) {
                [weakSelf.delegate vipShop:weakSelf finishedBuy:finished];
            }
        }
        else
        {
            NSString *message = ![NSString isNullString:error.domain] ? error.domain:@"";
//            [MessageHelper showMessage:MyLocal(message) view:weakSelf.view];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alertView.tag = kAlertTag + 1;
            [alertView show];
        }
    }];
}

#pragma mark - UI
-(UIScrollView *)mainScroll{
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScroll.backgroundColor = kColorClear;
        [self.view addSubview:_mainScroll];
    }
    return _mainScroll;
}


-(UIImageView *)vipImageView{
    if (!_vipImageView) {
        UIImage *vipImg = [UIImage imageNamed:@"image_user_placeholder"];
        _vipImageView = [[UIImageView alloc] initWithImage:vipImg];
        _vipImageView.size = vipImg.size;
        _vipImageView.backgroundColor = kColorClear;
        _vipImageView.top = 10;
        _vipImageView.centerX = self.mainScroll.width/2;
        
        [self.mainScroll addSubview:_vipImageView];
        
        if ([UserDAL userVipRoleEnable]) {
            self.lblVipTip.left = _vipImageView.right+2;
        }else{
            [_lblVipTip removeFromSuperview];
            _lblVipTip = nil;
        }
        
    }
    return _vipImageView;
}


-(UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.font = [UIFont systemFontOfSize:16.0f];
        _balanceLabel.textColor = kColorMain;
        _balanceLabel.top = self.vipImageView.bottom + 25;
        _balanceLabel.centerX = self.mainScroll.width/2;
        [self.mainScroll addSubview:_balanceLabel];
    }
    return _balanceLabel;
}

-(UILabel *)lblVipTip
{
    if (!_lblVipTip)
    {
        _lblVipTip = [[UILabel alloc] initWithFrame:CGRectMake(self.vipImageView.right+2, 0, 60, 44)];
        _lblVipTip.text = @"(VIP)";
        _lblVipTip.font = [UIFont systemFontOfSize:16.0f];
        _lblVipTip.textColor =  HEXCOLOR(0xFB5100);
        [self.mainScroll addSubview:_lblVipTip];
        [_lblVipTip sizeToFit];
        _lblVipTip.bottom = self.vipImageView.bottom;
    }
    return _lblVipTip;
}

-(UIImageView *)hsMoneyImageView{
    if (!_hsMoneyImageView) {
        UIImage *moneyIcon = [UIImage imageNamed:@"icon_global_HSMoney"];
        _hsMoneyImageView = [[UIImageView alloc] initWithImage:moneyIcon];
        _hsMoneyImageView.size = moneyIcon.size;
        [self.mainScroll addSubview:_hsMoneyImageView];
    }
    return _hsMoneyImageView;
}

-(UILabel *)privilegeTitleLabel{
    if (!_privilegeTitleLabel) {
        _privilegeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.width - 30, 30)];
        _privilegeTitleLabel.backgroundColor = kColorClear;
        _privilegeTitleLabel.text = @"";//MyLocal(@"VIP特权");
        _privilegeTitleLabel.font = [UIFont systemFontOfSize:17.0f];
        _privilegeTitleLabel.textColor = kColorBlack;
        [self.mainScroll addSubview:_privilegeTitleLabel];
    }
    return _privilegeTitleLabel;
}

-(UILabel *)privilegeDescriptionLabel{
    if (!_privilegeDescriptionLabel) {
        _privilegeDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.width - 30, 0)];
        _privilegeDescriptionLabel.numberOfLines = 0;
        _privilegeDescriptionLabel.font = [UIFont systemFontOfSize:14.0f];
        _privilegeDescriptionLabel.textColor = kColorWord;
        
        [self.mainScroll addSubview:_privilegeDescriptionLabel];
    }
    return _privilegeDescriptionLabel;
}

- (UILabel *)lblVipEndTime
{
    if (!_lblVipEndTime)
    {
        _lblVipEndTime = [[UILabel alloc] init];
        _lblVipEndTime.backgroundColor = kColorClear;
        _lblVipEndTime.height = 44;
        _lblVipEndTime.font = [UIFont systemFontOfSize:16.0f];
        _lblVipEndTime.textColor = kColorMain;
        [self.mainScroll addSubview:_lblVipEndTime];
    }
    return _lblVipEndTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    dateFormatter = nil;
}

@end
