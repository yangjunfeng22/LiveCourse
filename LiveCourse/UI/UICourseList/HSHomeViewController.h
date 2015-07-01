//
//  HSHomeViewController.h
//  HelloHSK
//
//  Created by junfengyang on 14/12/19.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tbvItemList;


@end
