//
//  UIFailOrderTableViewController.h
//  HelloHSK
//
//  Created by Lu on 14/12/3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FailOrderModel.h"


//cell
@protocol UIFailOrderCellDelegate <NSObject>

-(void)reTryWithFailOrderModel:(FailOrderModel *)failOrderModel;

@end

@interface UIFailOrderCell : UITableViewCell

@property (nonatomic, assign) FailOrderModel *failOrderModel;
@property (nonatomic, weak) id <UIFailOrderCellDelegate> delegate;
@end


//底部提示view
@interface TableViewFootView : UIView


@end




//主页面
@interface UIFailOrderTableViewController : UITableViewController<UIFailOrderCellDelegate>

@end
