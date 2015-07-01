//
//  HSMyPostsViewController.m
//  HelloHSK
//
//  Created by Lu on 14/12/3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMyPostsViewController.h"
#import "MJRefresh.h"
#import "CommunityNet.h"
#import "HSCommunityListCell.h"
#import "KeyChainHelper.h"
#import "MBProgressHUD.h"
#import "HSCommunityDetailVC.h"
#import "UINavigationController+Extern.h"
#define segmentedControlHeight 44
#define postsNum 10  //每次访问帖子个数

@interface HSMyPostsViewController ()<UITableViewDataSource,UITableViewDelegate,CommunityAudioBtnDelegate>
{
    CGPoint beginOffsetPoint;
    CommunityCategoryType postType;//类型
    NSMutableArray *dataArrary;
    NSString *lastTopicID;//最后一条帖子的ID
    MBProgressHUD *hud;
    NSInteger currentAudioRow;
}

@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UITableView *postTableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation HSMyPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorWhite;
    self.title = MyLocal(@"我的帖子");
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    dataArrary = [[NSMutableArray alloc] initWithCapacity:1];
    
    self.postTableView.backgroundColor = kColorClear;
    self.postTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.baseContentView = self.postTableView;
    [self.postTableView addHeaderWithTarget:self action:@selector(pullDowm)];
    [self.postTableView addFooterWithTarget:self action:@selector(pullUp)];
    
    self.postTableView.headerPullToRefreshText = MyLocal(@"下拉刷新");
    self.postTableView.headerReleaseToRefreshText = MyLocal(@"松开即可刷新");
    self.postTableView.headerRefreshingText = MyLocal(@"正在加载数据");
    
    self.postTableView.footerPullToRefreshText = GDLocal(@"更多..");
    self.postTableView.footerReleaseToRefreshText = GDLocal(@"松开即可刷新");
    self.postTableView.footerRefreshingText = GDLocal(@"正在加载数据");
    
    currentAudioRow = -1;
    
    self.filterView.backgroundColor = kColorWhite;
    postType = CommunityMy;
    self.segmentedControl.selectedSegmentIndex = 0;
    
    [self performSelector:@selector(headRefresh) withObject:nil afterDelay:0.5f];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self stopAllAudio];
}

#pragma mark - action

-(void)headRefresh{
    [self.postTableView headerBeginRefreshing];
}

-(void)segmentedControlSelect:(id)sender{
    [self stopAllAudio];
    
    UISegmentedControl *con = sender;
    NSInteger index = [con selectedSegmentIndex];
    if (index == 0) {
        postType = CommunityMy;
    }else if (index == 1){
        postType = CommunityIreply;
    }
    
    [self pullDowm];
}


-(void)againToObtain{
    [super againToObtain];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self pullDowm];
}

-(void)pullDowm{
    [hsGetSharedInstanceClass(CommunityNet) requestCommunityListWithUserID:kUserID mID:@"" length:postsNum filter:postType version:kAPIVersion keyWords:@"" boardID:0 requestType:CommunityListRequestTypeDataUnSave completion:^(BOOL finished, id result, NSError *error) {
        
        [self.postTableView headerEndRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (error.code == 0) {
            [dataArrary removeAllObjects];
            [dataArrary setArray:result];
            
            lastTopicID = ((CommunityModel *)[dataArrary lastObject]).topicID;
            
            [self.postTableView reloadData];
            
            [self addOrRemoveNoDataBackBtn:dataArrary.count];
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    }];
    
}

-(void)pullUp{
    [hsGetSharedInstanceClass(CommunityNet) requestCommunityListWithUserID:kUserID mID:lastTopicID length:postsNum filter:postType version:kAPIVersion keyWords:@"" boardID:0 requestType:CommunityListRequestTypeDataUnSave completion:^(BOOL finished, id result, NSError *error) {
        
        [self.postTableView footerEndRefreshing];
        
        if (error.code == 0) {
            [dataArrary addObjectsFromArray:result];
            
            lastTopicID = ((CommunityModel *)[dataArrary lastObject]).topicID;
            
            [self.postTableView reloadData];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}


-(void)stopAllAudio{
    [[NSNotificationCenter defaultCenter] postNotificationName:KAudioShouldStopNotification object:nil];
}

#pragma mark - ui

-(UIView *)filterView{
    if (!_filterView) {
        CGFloat top = kiOS7_OR_LATER ? 64 : 0;
        _filterView = [[UIView alloc] initWithFrame:CGRectMake(0,top , self.view.width, segmentedControlHeight)];
        _filterView.backgroundColor = kColorLine;
        [self.view insertSubview:_filterView aboveSubview:self.postTableView];
        
        UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _filterView.height - 0.5, _filterView.width, 0.5)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [_filterView addSubview:bottomLine];
    }
    return _filterView;
}

-(UISegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        NSArray *items = @[MyLocal(@"我发表的"),MyLocal(@"我回复的")];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        _segmentedControl.tintColor = kColorMain;
        CGFloat hight = segmentedControlHeight * 0.7f;
        CGFloat top = (segmentedControlHeight - hight)/2;
        _segmentedControl.frame = CGRectMake(10, top, _filterView.width - 20, hight);
        [_segmentedControl addTarget:self action:@selector(segmentedControlSelect:) forControlEvents:UIControlEventValueChanged];
        [self.filterView addSubview:_segmentedControl];
    }
    return _segmentedControl;
}

-(UITableView *)postTableView{
    if (!_postTableView) {
         CGRect frame = [[UIScreen mainScreen] applicationFrame];
        CGFloat height = CGRectGetHeight(frame) - segmentedControlHeight;
        height += kiOS7_OR_LATER ? 20 : 0;
        _postTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, segmentedControlHeight, self.view.width, height) style:UITableViewStylePlain];

        _postTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _postTableView.delegate = self;
        _postTableView.rowHeight = 150.0f;
        _postTableView.decelerationRate = UIScrollViewDecelerationRateFast;
        _postTableView.dataSource = self;
        _postTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_postTableView];
    }
    return _postTableView;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArrary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView configCellAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HSCommunityListCell *cell = (HSCommunityListCell *)[self tableView:tableView configCellAtIndexPath:indexPath];
    return cell.requiredRowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stopAllAudio];
    
    CommunityModel *entity = [dataArrary objectAtIndex:indexPath.row];
    
    HSCommunityDetailVC *detailVC = [[HSCommunityDetailVC alloc] init];
    detailVC.topicID = [entity.topicID copy];
    [self.navigationController pushViewController:detailVC animated:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView configCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myPostsListCell";
    
    HSCommunityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[HSCommunityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.communityAudioBtn.delegate = self;
    cell.communityAudioBtn.tag = indexPath.row;
    
    CommunityModel *model = [dataArrary objectAtIndex:indexPath.row];
    [cell setEntity:model];
    
    if (![NSString isNullString:model.audio]) {
        cell.communityAudioBtn.delegate = self;
        cell.communityAudioBtn.tag = indexPath.row;
        
        if (indexPath.row == currentAudioRow) {
            [cell.communityAudioBtn startAnimating];
        } else {
            [cell.communityAudioBtn stopAnimating];
        }
    }
    return cell;
}


#pragma mark - communityAudioBtnDelegateDidStartPlaying

-(void)communityAudioBtnDelegateDidStartPlaying:(CommunityAudioBtn *)voiceBubble{
    currentAudioRow = voiceBubble.tag;
}

-(void)communityAudioBtnDelegateDidEndPlaying:(CommunityAudioBtn *)voiceBubble{
    currentAudioRow = -1;
}




#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.postTableView]) {
        beginOffsetPoint  = self.postTableView.contentOffset;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    CGFloat minus = scrollView.contentOffset.y - beginOffsetPoint.y;
    
    if (minus < -20) {
//        DLog(@"下拉----%f",minus);
        CGRect sortToolViewframe = CGRectMake(0,kiOS7_OR_LATER ? 64 : 0, CGRectGetWidth(frame), segmentedControlHeight);
        [UIView animateWithDuration:0.2f animations:^{
            [self.filterView setFrame:sortToolViewframe];
            CGFloat height = CGRectGetHeight(frame) - segmentedControlHeight + 20;
            [self.postTableView setFrame:CGRectMake(0, segmentedControlHeight, CGRectGetWidth(frame), height)];
        }];
    }
    if (minus > 20) {
//        DLog(@"上推+++%f",minus);
        CGRect sortToolViewframe = CGRectMake(0, kiOS7_OR_LATER ? 0 : -64, CGRectGetWidth(frame), segmentedControlHeight);
        [UIView animateWithDuration:0.2f animations:^{
            [self.filterView setFrame:sortToolViewframe];
            CGFloat height = CGRectGetHeight(frame);
            height += kiOS7_OR_LATER ? 20 : - 44;
            
            [self.postTableView setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), height)];
        }];
    }
    //[super scrollViewDidScroll:scrollView];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.filterView setUserInteractionEnabled:NO];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.filterView setUserInteractionEnabled:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    beginOffsetPoint = CGPointZero;
    [dataArrary removeAllObjects];
    lastTopicID = nil;
    hud = nil;
}

@end
