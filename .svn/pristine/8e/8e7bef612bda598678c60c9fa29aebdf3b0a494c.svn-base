//
//  HSVipShopViewController.h
//  LiveCourse
//
//  Created by Lu on 15/1/17.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSBaseViewController.h"

@interface vipShopItemButton : UIButton

@property (nonatomic, strong) UILabel *timeLabel;//标题
@property (nonatomic, strong) UILabel *moneyLabel;//金额
@property (nonatomic, copy) NSString *vipID;


@end

@protocol HSVipShopDelegate;

@interface HSVipShopViewController : HSBaseViewController
@property (nonatomic, weak)id<HSVipShopDelegate>delegate;

@end


@protocol HSVipShopDelegate <NSObject>

@optional
- (void)vipShop:(HSVipShopViewController *)vipShopController finishedBuy:(BOOL)flag;

@end