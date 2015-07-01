//
//  UIFailOrderTableViewController.m
//  HelloHSK
//
//  Created by Lu on 14/12/3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UIFailOrderTableViewController.h"
#import "InAppPurchaseDAL.h"
#import "FailOrderModel.h"
#import "InAppPurchaseNet.h"
#import "MBProgressHUD.h"
#import "UserModel.h"
#import "UserDAL.h"
#import "UINavigationController+Extern.h"


#pragma mark - UIFailOrderCell

#define rowHeight 60

@interface UIFailOrderCell()

@property (nonatomic, strong) UIButton *retryBtn;   //重试

@end

@implementation UIFailOrderCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.retryBtn.backgroundColor = kColorMain;
    }
    return self;
}

-(void)setFailOrderModel:(FailOrderModel *)failOrderModel{
    _failOrderModel = failOrderModel;
    self.textLabel.text = failOrderModel.showPrice;
    NSString *orderTitle = MyLocal(@"订单号: ");
    self.detailTextLabel.text = [orderTitle stringByAppendingString:failOrderModel.orderID];
}


-(UIButton *)retryBtn{
    if (!_retryBtn) {
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryBtn.size = CGSizeMake(60, 40);
        _retryBtn.centerY = rowHeight/2;
        _retryBtn.right = self.width - 10;
        [_retryBtn addTarget:self action:@selector(reTry:) forControlEvents:UIControlEventTouchUpInside];
        [_retryBtn setTitle:MyLocal(@"重试") forState:UIControlStateNormal];
        [_retryBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [self addSubview:_retryBtn];
    }
    return _retryBtn;
}


-(void)reTry:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reTryWithFailOrderModel:)]) {
        [self.delegate reTryWithFailOrderModel:self.failOrderModel];
    }
}

@end


#pragma mark - tableViewFootView
@interface TableViewFootView()


@end

@implementation TableViewFootView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorWhite;
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineLabel];
        
        UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, frame.size.width - 40, 100)];
        telLabel.font = [UIFont systemFontOfSize:16.0f];
        telLabel.textColor = kColorWord;
        telLabel.numberOfLines = 0;
        NSString *contactUS = MyLocal(@"联系我们\n");
        NSString *telCH = MyLocal(@"电话: ");
        NSString *tel = @"+86 021-50470060(";
        NSString *beijin = MyLocal(@"北京时间");
        NSString *timeAndEmain = @"09:30-18:00)\nEmail:pay@hschinese.com";
        
        NSString *content = [[[[contactUS stringByAppendingString:telCH] stringByAppendingString:tel] stringByAppendingString:beijin] stringByAppendingString:timeAndEmain];
        telLabel.attributedText = [self paragraphStyleAndString:content font:telLabel.font];
        
        [self addSubview:telLabel];
    }
    return self;
}

-(NSMutableAttributedString *)paragraphStyleAndString:(NSString *)text font:(UIFont *)font{
    //设置段落类型
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    NSMutableAttributedString *summarizeString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    
    return summarizeString;
}
@end


#pragma mark - UIFailOrderTableViewController
@interface UIFailOrderTableViewController ()

@end

@implementation UIFailOrderTableViewController
{
    NSMutableArray *orderArray;
    InAppPurchaseNet *inAppPurchaseNet;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    self.title = MyLocal(@"问题订单");
    [self.navigationController setPresentNavigationBarBackItemWihtTarget:self image:nil];
    orderArray = [[NSMutableArray alloc] initWithCapacity:2];
    [orderArray setArray:[InAppPurchaseDAL searchAllFailOrder]];
    inAppPurchaseNet = [[InAppPurchaseNet alloc] init];
    
    [self.tableView reloadData];
    
    TableViewFootView  *footView = [[TableViewFootView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 140)];
    self.tableView.tableFooterView = footView;
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderArray.count;
}


- (UIFailOrderCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"reuseIdentifier";
    UIFailOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UIFailOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        FailOrderModel *model = [orderArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFailOrderModel:model];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}



#pragma mark - action
//UIFailOrderCellDelegate
-(void)reTryWithFailOrderModel:(FailOrderModel *)failOrderModel{
    DLog(@"%@====",failOrderModel.showPrice);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [inAppPurchaseNet requestInAppPurchaseSuccessWithOrderID:failOrderModel.orderID Currency:failOrderModel.currency Money:failOrderModel.price Completion:^(BOOL finished, id result, NSError *error) {
        
        if (error.code == 0) {
            [hud hide:YES];
            
            [self deleteFailOrder:failOrderModel];
            
            NSInteger allHSMoney = [[result objectForKey:@"Balance"] integerValue];
            
            [self saveHSMoney:allHSMoney];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GDLocal(@"充值成功") message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            [hud hide:YES];
            
            NSString *errorMessage = error.domain;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GDLocal(@"充值失败") message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

-(void)deleteFailOrder:(FailOrderModel *)failOrderModel{
    //删除数据库
    [failOrderModel deleteEntity];
    [[NSManagedObjectContext defaultContext] saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        DLog(@"删除本地订单成功");
    }];
    
    //删除该cell
    NSInteger index = [orderArray indexOfObject:failOrderModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [orderArray removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
}

-(void)saveHSMoney:(NSInteger)allHSmoney{
    
    UserModel *model = [UserDAL queryUserInfoWithUserID:kUserID];
    if (!model) {
        return;
    }
    model.userCoin = allHSmoney;
}

-(void)dealloc{
    [orderArray removeAllObjects];
    orderArray = nil;
    [inAppPurchaseNet cancelRequest];
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DLog(@"indexpath%@",indexPath);
//}
@end
