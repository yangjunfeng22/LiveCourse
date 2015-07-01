//
//  HSBaseTableViewController.m
//  HelloHSK
//
//  Created by Lu on 14/12/10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSBaseTableViewController.h"
#import "MJRefresh.h"
#import "HSBaseTool.h"

@interface HSBaseTableViewController ()<UIGestureRecognizerDelegate>

@end

@implementation HSBaseTableViewController

-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if (kiOS8_OR_LATER) {
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)endEditing:(id)sender{
    [self.view endEditing:YES];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    UITableViewCell *cell = [HSBaseTool superviewFromView:touch.view superClass:[UITableViewCell class]];
    if (cell) {
        return NO;
    }
    
    if ([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    return YES;
}


-(void)addOrRemoveNoDataBackBtn:(NSInteger)count{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),dispatch_get_main_queue() , ^{
        if (count == 0) {
            UIView *oldImageView = [self.baseContentView viewWithTag:KBaseTableViewControllerImageViewTag];
            if (!oldImageView) {
                UIButton *backgroundBtn = [[UIButton alloc] initWithFrame:self.baseContentView.bounds];
                backgroundBtn.contentMode = UIViewContentModeTop;
                backgroundBtn.tag = KBaseTableViewControllerImageViewTag;
                backgroundBtn.backgroundColor = kColorWhite;
                [backgroundBtn addTarget:self action:@selector(againToObtain) forControlEvents:UIControlEventTouchUpInside];
                [self.baseContentView insertSubview:backgroundBtn atIndex:[[self.baseContentView subviews] count]];
                
                //添加logo图片 及提示语
                UIImage *img = [UIImage imageNamed:@"noDataImg"];
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.image = img;
                imgView.size = CGSizeMake(40, 40);
                imgView.centerY = 200;
                imgView.centerX = backgroundBtn.width/2;
                [backgroundBtn addSubview:imgView];
                
                
                UILabel *label = [[UILabel alloc] init];
                label.size = CGSizeMake(backgroundBtn.width, 30);
                label.top = imgView.bottom + 20;
                label.centerX = imgView.centerX;
                label.text = GDLocal(@"点击屏幕，重新加载");
                label.textColor = kColorWord;
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14.0f];
                [backgroundBtn addSubview:label];
            }
        }else{
            UIView *oldImageView = [self.baseContentView viewWithTag:KBaseTableViewControllerImageViewTag];
            if (oldImageView) {
                [oldImageView removeFromSuperview];
                oldImageView = nil;
            }
        }
    });
};


-(void)againToObtain{
    DLog(@"之类需继承这个方法");
}


#pragma mark - 刷新控件等
/**
 *  集成刷新控件
 */
- (void)setupHeaderRefresh{
    if (self.isUsingHeadPullRefresh) {
        [self.tableView addHeaderWithTarget:self action:@selector(headLoadTableViewDataSource)];
        
        self.tableView.headerPullToRefreshText = MyLocal(@"下拉刷新");
        self.tableView.headerReleaseToRefreshText = MyLocal(@"松开即可刷新");
        self.tableView.headerRefreshingText = MyLocal(@"正在加载数据");
    }
}
- (void)setupFooterRefresh{
    if (self.isUsingFootPullRefresh) {
        [self.tableView addFooterWithTarget:self action:@selector(footLoadTableViewDataSource)];
        
        self.tableView.footerPullToRefreshText = GDLocal(@"更多..");
        self.tableView.footerReleaseToRefreshText = GDLocal(@"松开即可刷新");
        self.tableView.footerRefreshingText = GDLocal(@"正在加载数据");

    }
}

-(void)setIsUsingHeadPullRefresh:(BOOL)isUsingHeadPullRefresh
{
    if (isUsingHeadPullRefresh != _isUsingHeadPullRefresh) {
        _isUsingHeadPullRefresh = isUsingHeadPullRefresh;
        if (!_isUsingHeadPullRefresh && self.tableView) {
            [self.tableView headerEndRefreshing];
            [self.tableView removeHeader];
        }else if (self.tableView){
            [self setupHeaderRefresh];
        }
    }
}

-(void)setIsUsingFootPullRefresh:(BOOL)isUsingFootPullRefresh{
    if (isUsingFootPullRefresh != _isUsingFootPullRefresh) {
        _isUsingFootPullRefresh = isUsingFootPullRefresh;
        if (!_isUsingFootPullRefresh && self.tableView) {
            [self.tableView footerEndRefreshing];
            [self.tableView removeFooter];
        }else if (self.tableView){
            [self setupFooterRefresh];
        }
    }
}


-(void)headerRefreshing{
    //下拉刷新
    [self.tableView headerBeginRefreshing];
}

-(void)endHeadRefreshTableViewData{
    [self.tableView headerEndRefreshing];
}

-(void)headLoadTableViewDataSource{
    DLog(@"子类重写下拉更新方法");
}


-(void)footLoadTableViewDataSource{
    DLog(@"之类重写加载更多方法");
}

-(void)endFootRefreshTableViewData{
    [self.tableView footerEndRefreshing];
}

-(BOOL)headerIsRefreshing
{
    return self.tableView.headerRefreshing;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if (kiOS8_OR_LATER) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

@end
