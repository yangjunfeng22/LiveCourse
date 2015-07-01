//
//  HSMoreViewController.h
//  HelloHSK
//
//  Created by yang on 14-2-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSMoreViewControllerDelegate <NSObject>
@optional
- (void)logOut;
@end


@interface HSMoreViewController : UITableViewController

//@property (weak, nonatomic) id <HSMoreViewControllerDelegate>delegate;

@end

