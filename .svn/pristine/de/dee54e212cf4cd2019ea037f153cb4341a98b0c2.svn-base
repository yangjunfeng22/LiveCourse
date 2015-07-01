//
//  UIPayHSMoneyViewController.m
//  HelloHSK
//
//  Created by Lu on 14/11/10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UIPayHSMoneyViewController.h"
#import "RageIAPHelper.h"
#import "HSMoneyEffectViewController.h"
#import "MBProgressHUD.h"

#import "InAppPurchaseNet.h"
#import "KeyChainHelper.h"
#import "SKProductExtension.h"

#import "UserModel.h"
#import "UserDAL.h"
#import "InAppPurchaseDAL.h"
#import "FailOrderModel.h"
#import "UIFailOrderTableViewController.h"
#import "MessageHelper.h"
#import "UserNet.h"

#import "UINavigationController+Extern.h"

#define oneLineNum 2    //一行展示几个
#define verticalSpace 10 //垂直向间隔
#define horizontalSpace 10 //横向间隔
#define borderSapce 20 //距离边界的距离
#define btnHeight 50.0f //按钮的高度



#pragma mark - HSMoneyButton
@interface HSMoneyButton()

@property (nonatomic, strong) UILabel *purchaseTitleLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation HSMoneyButton
{
    CGSize btnSize;
}

-(id)initWithFrame:(CGRect)frame andSKProduct:(SKProduct *)SKProduct{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        btnSize = frame.size;
        _skProduct = SKProduct;
        //加载数据
        [self loadData];
    }
    return self;
}

-(void)loadData{
    self.purchaseTitleLabel.frame = CGRectMake(0, 0, btnSize.width, btnSize.height * 0.47);
    self.purchaseTitleLabel.text = GDLocal(_skProduct.localizedTitle);
    
    self.priceLabel.frame = CGRectMake(0, self.purchaseTitleLabel.bottom, btnSize.width, btnSize.height * 0.53);
    
    NSString *price = [SKProductExtension localizedPrice:_skProduct];
    self.priceLabel.text = price;
    
}

#pragma mark ui

-(UILabel *)purchaseTitleLabel{
    if (!_purchaseTitleLabel) {
        _purchaseTitleLabel = [[UILabel alloc] init];
        _purchaseTitleLabel.backgroundColor = kColorMain;
        _purchaseTitleLabel.textAlignment = NSTextAlignmentCenter;
        _purchaseTitleLabel.textColor = kColorWhite;
        _purchaseTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_purchaseTitleLabel];
    }
    return _purchaseTitleLabel;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.backgroundColor = kColorWhite;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = HEXCOLOR(0xF79204);
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}


-(void)dealloc{
    btnSize = CGSizeZero;
    _skProduct = nil;
}


@end



//排序算法
NSInteger productSort(SKProduct *obj1, SKProduct *obj2, void *context)
{
    float price1 = [obj1.price floatValue];
    float price2 = [obj2.price floatValue];
    
    if (price1 > price2) {
        return (NSComparisonResult)NSOrderedDescending;
    }else if (price1 < price2){
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame; ;
}


#pragma mark - UIPayHSMoneyViewController

@interface UIPayHSMoneyViewController ()
{
    InAppPurchaseManager *iap;
    InAppPurchaseNet *inAppPurchaseNet;
    NSInteger purchaseNum;  //购买产品的个数
    MBProgressHUD *hud;
    
    NSDictionary *dicProducts;
    CGFloat commonProblemsLabelTop;
    SKProduct *useChoiceProduct;
    NSMutableArray *productIdentifiersArray;
    NSString *orderID;  //订单id
    NSString *orderUserID;   //用户id
    
    UserNet *userNet;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIButton *hsMoneyEffectBtn;  //汉声币作用
@property (nonatomic, strong) UILabel *commonProblemsLabel;//常见问题


@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userCoinLabel;
@property (nonatomic, strong) UIImageView *coinIconImgView;


@end

@implementation UIPayHSMoneyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //如果有更新失败的订单 则显示失败订单按钮
    NSArray *arr = [InAppPurchaseDAL searchAllFailOrder];
    
    if (arr && arr.count > 0) {
        [self showRight];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [inAppPurchaseNet cancelRequest];
    
    iap = nil;
    hud = nil;
    orderUserID = nil;
    orderID = nil;
}

-(void)showRight{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 40);
    
    [button setTitle:MyLocal(@"问题订单") forState:UIControlStateNormal];
    [button setTitleColor:kColorMain forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    button.titleEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, -20);
    [button addTarget:self action:@selector(toFailOrderViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = GDLocal(@"充值");
    
    self.view.backgroundColor = kColorWhite;
    
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    inAppPurchaseNet = [[InAppPurchaseNet alloc] init];
    
    [self initDataAndUI];
    
    [self initPurchaseNotification];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    userNet = [[UserNet alloc] init];
    
    self.userNameLabel.backgroundColor = kColorClear;
    self.coinIconImgView.backgroundColor = kColorClear;
    self.userCoinLabel.backgroundColor = kColorClear;
    
    [self requestUserInfo];
    [self requestPurchaseData];
}

-(void)toFailOrderViewController{
    UIFailOrderTableViewController *failOrderVC = [[UIFailOrderTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:failOrderVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


-(void)initDataAndUI{
    iap = [[InAppPurchaseManager alloc] init];
    
    dicProducts = [[NSDictionary alloc] init];
    
    commonProblemsLabelTop = self.hsMoneyEffectBtn.bottom + 10;
    self.commonProblemsLabel.height = 200;
    self.commonProblemsLabel.text = MyLocal(@"充值常见问题\n1.充值成功后,我怎么查看这笔充值记录？\n充值成功后，请及时查收。您可以登陆到个人账户——交易中心里查看充值明细。一旦充值成功，汉声币余额不可转账或退款\n\n2.充值成功后何时可以支付\n一旦您的充值操作完成，您充值的余额会即可注入您的汉声币账号，并可以立刻支付\n\n3.为什么我无法完成支付？\n为了保障用户权益，会对每笔交易进行判断。如果认为存在风险，您将无法完成支付也不会对您进行扣款。请您改用官方渠道购买汉声币");
    [self.commonProblemsLabel sizeToFit];
    [self setMainscrollViewContentSize];
    
}

-(void)setMainscrollViewContentSize{
    CGSize scrollContentSize = self.mainScrollView.contentSize;
    scrollContentSize.height = self.commonProblemsLabel.bottom + 20;
    self.mainScrollView.contentSize = scrollContentSize;
}

-(void)requestUserInfo
{
    [self loadUserInfo];
    // 处理耗时操作的代码块...
    [userNet requestUserInfoWithUserID:kUserID completion:^(BOOL finished, id result, NSError *error) {
        [self loadUserInfo];
    }];
}

- (void)loadUserInfo
{
    UserModel *model = [UserDAL queryUserInfoWithUserID:kUserID];
    if (!model) {
        return;
    }
    NSString *hsMoney = GDLocal(@"汉声币");
    NSString *coinStr = [NSString stringWithFormat:@"%@: %@",hsMoney,[model.coin stringValue]];
    self.userCoinLabel.text = coinStr;
    [self.userCoinLabel sizeToFit];
    self.userCoinLabel.centerX = self.mainScrollView.width/2;
    NSString *userTitle = MyLocal(@"用户名");
    self.userNameLabel.text = [NSString stringWithFormat:@"%@: %@",userTitle,model.name];
    [self.userNameLabel sizeToFit];
    self.userNameLabel.centerX = self.mainScrollView.width/2;
    self.coinIconImgView.left = self.userCoinLabel.right + 5;
}


//访问接口获取购买的产品数据并 访问ituns connect 有代理处理 返回详细的价格数据
-(void)requestPurchaseData{
    
    __weak UIPayHSMoneyViewController *weakSelf = self;
    [inAppPurchaseNet requestInAppPurchaseCompletion:^(BOOL finished, id result, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (error.code == 0) {
            NSArray *productsArray = [NSArray arrayWithArray:result];
        
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *bundleID = [[infoDictionary objectForKey:@"CFBundleIdentifier"] stringByAppendingString:@"."];
            DLog(@"%@====",bundleID);
            
            NSMutableArray *identifierArray = [[NSMutableArray alloc] initWithCapacity:2];
            for (id obj in productsArray)
            {
                NSDictionary *dic = obj;
                NSString *productIdentifier = [bundleID stringByAppendingString:[dic objectForKey:@"CardID"]];
                [identifierArray addObject:productIdentifier];
            }
            
            [weakSelf requestPorductInfo:identifierArray];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];

}

- (void)requestPorductInfo:(NSArray *)identifiers
{
    DLog(@"标示: %@", identifiers);
    // 取得所有需要购买的产品的标示。
    if ([iap canMakePayments])
    {
        // 所有需要购买的产品的表示。
        //NSArray *arrIdentifier = [NSArray array];
        //        RageIAPHelper *iapHelper = [[RageIAPHelper alloc] init];
        //        [iap requestProductData:iapHelper.productIdentifiers];
        [iap requestProductData:identifiers];
    }
    else
    {
        // 有设置的情况下
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:GDLocal(@"访问限制") message: GDLocal(@"您的设备不允许在app store内购买东西") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 建立应用内购买的通知。
- (void)initPurchaseNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseProductFetched:) name:InAppPurchaseManagerProductsFetchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseProductSuccessed:) name:InAppPurchaseManagerTransactionSucceededNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseProductFailed:) name:InAppPurchaseManagerTransactionFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseProductRequestFailed:) name:InAppPurchaseManagerRequestFailedNotification object:nil];
}


#pragma mark - Purchase Manager
// 查询产品信息成功
- (void)purchaseProductFetched:(NSNotification *)notification
{
    
    
    // 获取查询到的产品的信息。
    dicProducts = notification.userInfo;
    
    DLog(@"产品信息: %@", dicProducts);
    purchaseNum = dicProducts.count;
    
    NSArray *dicProductArray = [NSArray arrayWithArray:[dicProducts allValues]];
    
    //排序
    NSArray *sortDicProductArray = [dicProductArray sortedArrayUsingFunction:productSort context:nil];
    
    //作用的底端
    CGFloat beginTop = self.hsMoneyEffectBtn.bottom + verticalSpace;
    CGFloat moneyBtnHeight = kiPhone ? btnHeight : btnHeight + 30;
    CGFloat moneyBtnWidth = (self.mainScrollView.width - borderSapce*2 - horizontalSpace*(oneLineNum-1))/oneLineNum;
    NSUInteger idx = 0;
    for (id obj in sortDicProductArray)
    {
        NSInteger lineNum = idx/oneLineNum;
        NSInteger columnNum = idx%oneLineNum;
        
        CGFloat tempTop = beginTop + moneyBtnHeight * lineNum + verticalSpace*lineNum;
        CGFloat tempLeft = borderSapce + moneyBtnWidth * columnNum + horizontalSpace*columnNum;
        
        commonProblemsLabelTop = tempTop + btnHeight + 20;
        
        //生成按钮 并添加数据
        HSMoneyButton *moneyBtn = [[HSMoneyButton alloc] initWithFrame:CGRectMake(tempLeft, tempTop , moneyBtnWidth, moneyBtnHeight) andSKProduct:obj];
        
        [moneyBtn addTarget:self action:@selector(purchaseHSMoney:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainScrollView addSubview:moneyBtn];
        
        idx++;
    }
    [hud hide:YES];
    
    self.commonProblemsLabel.top = kiPhone ? commonProblemsLabelTop : commonProblemsLabelTop + 20;
    [self setMainscrollViewContentSize];
}


//点击购买
-(void)purchaseHSMoney:(id)sender{
    if (isJailBreak()) {
        [MessageHelper showMessage:MyLocal(@"越狱状态, 不能进行应用内购买!") view:self.view];
        return;
    }
    
    //生成订单接口
    [hud show:YES];
    HSMoneyButton *btn = (HSMoneyButton *)sender;
    useChoiceProduct = btn.skProduct;
    
    NSString *productIdentifier = useChoiceProduct.productIdentifier;
    NSArray *tempArray = [productIdentifier componentsSeparatedByString:@"."];
    NSString *cardID = [tempArray lastObject];
    __weak UIPayHSMoneyViewController *weakSelf = self;
    [inAppPurchaseNet requestInAppPurchaseOrderWithCardID:cardID Completion:^(BOOL finished, id result, NSError *error) {
        if (error.code == 0) {
            [weakSelf shouldPurchaseProduct:result];
        }else{
            //[hud hide:YES];
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSString *message = error.domain;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocal(@"生成订单失败!") message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)shouldPurchaseProduct:(NSDictionary *)result
{
    orderID = [NSString stringWithFormat:@"%@", [result objectForKey:@"OrderID"]];
    orderUserID = [NSString stringWithFormat:@"%@", [result objectForKey:@"UserID"]];
    [iap purchaseProduct:useChoiceProduct];
}

// 查询产品信息失败
- (void)purchaseProductRequestFailed:(NSNotification *)notification
{
    DLog(@"失败%@", NSStringFromSelector(_cmd));
    
    [hud hide:YES];
}


// 购买成功
- (void)purchaseProductSuccessed:(NSNotification *)notification
{
    DLog(@"%@", NSStringFromSelector(_cmd));
    
    //NSDictionary *dicInfo = notification.userInfo;
    //SKPaymentTransaction *transaction = [dicInfo objectForKey:@"transaction"];

    //DLog(@"transaction Identifier: %@", transaction.payment.productIdentifier);
    //DLog(@"购买成功-------------");
    // 通知服务器购买成功。
    [self updatePurchasedInfo];
}

// 购买失败
- (void)purchaseProductFailed:(NSNotification *)notification
{
    DLog(@"%@", NSStringFromSelector(_cmd));
    [hud hide:YES];
}


- (void)pushToHSMoneyEffectViewController:(id)sender{
    HSMoneyEffectViewController *HSMoneyEffectVC = [[HSMoneyEffectViewController alloc] init];
    [self.navigationController pushViewController:HSMoneyEffectVC animated:YES];
}

#pragma mark -  Update Server Purchase
- (void)updatePurchasedInfo
{
    NSString *price = [NSString stringWithFormat:@"%f",[useChoiceProduct.price floatValue]] ;
    NSString *currency = [NSString stringWithFormat:@"%@",useChoiceProduct.priceLocale.localeIdentifier] ;
    NSString *newCurrency = [NSString stringWithFormat:@"%@",[[currency componentsSeparatedByString:@"="] lastObject]] ;
    __weak UIPayHSMoneyViewController *weakSelf = self;
    
    [inAppPurchaseNet requestInAppPurchaseSuccessWithOrderID:orderID Currency:newCurrency Money:price Completion:^(BOOL finished, id result, NSError *error) {
        if (error.code == 0) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSInteger allHSMoney = [[result objectForKey:@"Balance"] integerValue];
            
            
            NSString *hsMoney = GDLocal(@"汉声币");
            NSString *coinStr = [NSString stringWithFormat:@"%@: %i",hsMoney,allHSMoney];
            self.userCoinLabel.text = coinStr;
            [self.userCoinLabel sizeToFit];
            
            self.userCoinLabel.centerX = self.mainScrollView.width/2;
            self.coinIconImgView.left = self.userCoinLabel.right + 5;
            
            
            
            [weakSelf saveHSMoney:allHSMoney];
            
            [MessageHelper showMessage:MyLocal(@"充值成功") view:weakSelf.view];
            
            if (self.isAutoBack) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
//    #warning 临时测试问题订单 测试完需注释
//            [self saveFailOrderWithOrderID:orderID price:price currency:newCurrency];
//            [self showRight];
            
        }else{
            //[hud hide:YES];
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [weakSelf showRight];
            
            //支付成功 但是更新失败 则需要保存到数据库
            [weakSelf saveFailOrderWithPrice:price currency:newCurrency];
            
            NSString *errorMessage = error.domain;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GDLocal(@"充值失败") message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}


//保存更新失败订单
-(void)saveFailOrderWithPrice:(NSString *)price currency:(NSString *)currency
{
    NSString *email = [KeyChainHelper getUserNameWithService:KEY_USERNAME];
    [InAppPurchaseDAL saveFailOrderWithUserEmail:email orderID:orderID price:price currency:currency showPrice:GDLocal(useChoiceProduct.localizedTitle)];
}


-(void)saveHSMoney:(NSInteger)allHSmoney{
    
    UserModel *model = [UserDAL queryUserInfoWithUserID:kUserID];
    if (!model) {
        return;
    }
    model.userCoin = allHSmoney;
}


#pragma mark - ui

-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollView.backgroundColor = kColorClear;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}


-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = kColorClear;
        _userNameLabel.textColor = kColorMain;
        _userNameLabel.font = [UIFont systemFontOfSize:16.0f];
        _userNameLabel.top = 15;
        _userNameLabel.width = 200;
        _userNameLabel.height = 20.0f;
        _userNameLabel.centerX = self.mainScrollView.width/2;
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        _userNameLabel.text = [NSString stringWithFormat:@"%@:",MyLocal(@"用户名")];
        [self.mainScrollView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}


-(UILabel *)userCoinLabel{
    if (!_userCoinLabel) {
        _userCoinLabel = [[UILabel alloc] init];
        _userCoinLabel.backgroundColor = kColorClear;
        _userCoinLabel.textColor = kColorMain;
        _userCoinLabel.font = [UIFont systemFontOfSize:16.0f];
        _userCoinLabel.height = 20.0f;
        _userCoinLabel.top = self.userNameLabel.bottom + 10;
        _userCoinLabel.width = 200;
        _userCoinLabel.text = [NSString stringWithFormat:@"%@:",MyLocal(@"汉声币")];
        [_userCoinLabel sizeToFit];
        _userCoinLabel.centerX = self.mainScrollView.width/2;
        [self.mainScrollView addSubview:_userCoinLabel];
    }
    return _userCoinLabel;
}

-(UIImageView *)coinIconImgView{
    if (!_coinIconImgView) {
        UIImage *image = [UIImage imageNamed:@"icon_global_HSMoney"];
        _coinIconImgView = [[UIImageView alloc] initWithImage:image];
        _coinIconImgView.size = image.size;
        _coinIconImgView.centerY = self.userCoinLabel.centerY;
        _coinIconImgView.left = self.userCoinLabel.right + 10;
        _coinIconImgView.backgroundColor = kColorClear;
        [self.mainScrollView addSubview:_coinIconImgView];
    }
    return _coinIconImgView;
}






-(UIButton *)hsMoneyEffectBtn{
    if (!_hsMoneyEffectBtn) {
        _hsMoneyEffectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hsMoneyEffectBtn.backgroundColor = kColorClear;
        _hsMoneyEffectBtn.frame = CGRectMake(20, self.userCoinLabel.bottom + 10, self.mainScrollView.width - 20, 20);
        [_hsMoneyEffectBtn setTitleColor:kColorMain forState:UIControlStateNormal];
        [_hsMoneyEffectBtn setTitle:GDLocal(@"汉声币作用")  forState:UIControlStateNormal];
        [_hsMoneyEffectBtn addTarget:self action:@selector(pushToHSMoneyEffectViewController:) forControlEvents:UIControlEventTouchUpInside];
        [_hsMoneyEffectBtn sizeToFit];
        _hsMoneyEffectBtn.left = 20;
        [_mainScrollView addSubview:_hsMoneyEffectBtn];
        
        
        UIImage *img = [UIImage imageNamed:@"icon_hsMoney_effect"];
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setBackgroundImage:img forState:UIControlStateNormal];
        iconBtn.backgroundColor = kColorClear;
        iconBtn.size = img.size;
        iconBtn.left = _hsMoneyEffectBtn.right + 10;
        iconBtn.centerY = _hsMoneyEffectBtn.centerY;
        [iconBtn addTarget:self action:@selector(pushToHSMoneyEffectViewController:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:iconBtn];
    }
    return _hsMoneyEffectBtn;
}


-(UILabel *)commonProblemsLabel{
    if (!_commonProblemsLabel) {
        _commonProblemsLabel = [[UILabel alloc] init];
        _commonProblemsLabel.backgroundColor = kColorClear;
        _commonProblemsLabel.width = self.mainScrollView.width - borderSapce*2;
        _commonProblemsLabel.left = borderSapce;
        _commonProblemsLabel.top = commonProblemsLabelTop;
        _commonProblemsLabel.numberOfLines = 0;
        _commonProblemsLabel.textColor = kColorWord;
        _commonProblemsLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.mainScrollView addSubview:_commonProblemsLabel];
    }
    return _commonProblemsLabel;
}





- (void)dealloc
{
    iap = nil;
    hud = nil;
    orderUserID = nil;
    orderID = nil;
}

@end
