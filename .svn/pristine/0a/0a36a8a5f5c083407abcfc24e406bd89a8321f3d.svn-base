//
//  HSBaseTableViewController.h
//  HelloHSK
//
//  Created by Lu on 14/12/10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBaseTableViewController : UITableViewController

-(id)initWithStyle:(UITableViewStyle)style;

/*!
 *  指向VC的内容View
 */
@property (nonatomic, strong) UIView *baseContentView;

//添加一个没有数据的背景图片
- (void)addOrRemoveNoDataBackBtn:(NSInteger)count;

//点击屏幕重新加载数据  子类需要继承
-(void)againToObtain;



/*!
 *  确定是否使用下拉刷新，设定后立即生效
 */
@property (nonatomic) BOOL isUsingHeadPullRefresh;


/*
 *  是否正在刷新
 */
-(BOOL)headerIsRefreshing;


/*!
 *  子类覆盖该方法，下拉时更新数据
 */
- (void)headLoadTableViewDataSource;


/*!
 *  在刷新数据完成后调用该方法
 */
- (void)endHeadRefreshTableViewData;




/*!
 *  确定是否使用加载更多，设定后立即生效
 */
@property (nonatomic) BOOL isUsingFootPullRefresh;

/*!
 *  子类覆盖该方法，开始加载更多时，会调用该方法
 */
- (void)footLoadTableViewDataSource;

/*!
 *  在刷新数据完成后调用该方法
 */
- (void)endFootRefreshTableViewData;


/*!
 *  手动控制下拉刷新
 */
- (void)headerRefreshing;


@end
