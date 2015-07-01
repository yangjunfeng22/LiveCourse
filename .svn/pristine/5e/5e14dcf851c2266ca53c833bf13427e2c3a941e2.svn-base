//
//  HSCommunityPlateListVC.m
//  LiveCourse
//
//  Created by Lu on 15/5/25.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCommunityPlateListVC.h"
#import "CommunityNet.h"
#import "MBProgressHUD.h"
#import "CommunityModel.h"
#import "HSCommunityListCell.h"
//#import "HSCommunityDetailViewController.h"
//#import "HSCreatePostTableViewController.h"
#import "CommunityDAL.h"
#import "HSCommunityCreatPostVC.h"

#import "HSCommunityDetailVC.h"

#define postsNum 10  //每次访问帖子个数

@interface HSCommunityPlateListVC ()<CommunityAudioBtnDelegate,CommunityCreatPostVCDelegate>

@property (nonatomic, strong) CommunityNet *communityNet;

@end

@implementation HSCommunityPlateListVC
{
    NSMutableArray *dataArrary;
    NSString *lastTopicID;//最后一条帖子的ID
    
    NSInteger currentAudioRow;

}

-(id)initWithPlateID:(NSInteger)plateID{
    self = [super init];
    
    if (self) {
        self.plateID = plateID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAction];
    
    [self performSelector:@selector(startReloadData) withObject:nil afterDelay:0.5f];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self stopAllAudio];
    
}

-(void)initAction{
    
    self.view.backgroundColor = kColorWhite;
    CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"ico_navigation_back"], @selector(back), self, YES);
    
    //发帖
    
    UIButton* buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 0, 80, 40);
    [buttonRight setTitle:MyLocal(@"发帖") forState:UIControlStateNormal];
    [buttonRight setTitleColor:kColorMain forState:UIControlStateNormal];
    buttonRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    buttonRight.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    buttonRight.titleEdgeInsets = kiOS7_OR_LATER ? UIEdgeInsetsMake(0, 0, 0, -10):UIEdgeInsetsZero;
    [buttonRight addTarget:self action:@selector(createPosts:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
    
    kAddObserverNotification(self, @selector(freshCommunityLikedAndReplyCount:), kRefreshCommunityLaudAndReplyCount, nil);
    
    
    self.baseContentView = self.tableView;
    
    self.isUsingHeadPullRefresh = YES;
    self.isUsingFootPullRefresh = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    currentAudioRow = -1;
    
    dataArrary = [NSMutableArray arrayWithCapacity:2];
    
    [self headLoadTableViewDataSource];
}


#pragma mark - action
-(void)startReloadData{
    if ([self headerIsRefreshing]) {
        DLog(@"正在刷新");
        return;
    }
    [self performSelectorOnMainThread:@selector(headerRefreshing) withObject:nil waitUntilDone:NO];
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


//发帖
-(void)createPosts:(id)sender{
    HSCommunityCreatPostVC *createPostVC = [[HSCommunityCreatPostVC alloc] initWithPlateID:self.plateID];
    createPostVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createPostVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


//createPostDelegate
-(void)backToListViewAndGoToDetailViewWithTopicID:(NSString *)topicID{
    
//    HSCommunityDetailViewController *detailVC = [[HSCommunityDetailViewController alloc] init];
    HSCommunityDetailVC *detailVC = [[HSCommunityDetailVC alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.topicID = [topicID copy];
    [self.navigationController pushViewController:detailVC animated:NO];
    
}

-(void)againToObtain{
    
    if ([self headerIsRefreshing]) {
        DLog(@"正在刷新");
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self headLoadTableViewDataSource];
}


#pragma mark - Notification Refresh
- (void)freshCommunityLikedAndReplyCount:(NSNotification *)notification
{
    NSDictionary *dicInfo = notification.userInfo;
    NSString *topicID = [dicInfo objectForKey:@"TopicID"];
    NSInteger liked = [[dicInfo objectForKey:@"Liked"] integerValue];
    NSInteger replied = [[dicInfo objectForKey:@"Replied"] integerValue];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updatePostsFromTopicID:topicID Liked:liked Replied:replied];
        });
    });
}

//更新某条数据
-(void)updatePostsFromTopicID:(NSString *)topicID Liked:(NSInteger)liked Replied:(NSInteger)replied
{
    if (!topicID/* || !liked || !replied*/) {
        return;
    }
    
    __block NSInteger index;
    __block BOOL isFind = NO;
    [dataArrary enumerateObjectsUsingBlock:^(CommunityModel *tempEntity, NSUInteger idx, BOOL *stop) {
        if ([tempEntity.topicID isEqualToString:topicID]) {
            index = idx;
            isFind = YES;
            *stop = YES;
        }
    }];
    
    if (isFind) {
        CommunityModel *oldModel = [dataArrary objectAtIndex:index];
        oldModel.liked = [NSNumber numberWithInteger:liked];
        oldModel.replied = [NSNumber numberWithInteger:replied];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


-(void)stopAllAudio{
    [[NSNotificationCenter defaultCenter] postNotificationName:KAudioShouldStopNotification object:nil];
}



#pragma mark - 刷新操作
-(void)headLoadTableViewDataSource{
    
    [self.communityNet requestCommunityListWithUserID:kUserID mID:@"" length:postsNum filter:CommunityAll version:kAPIVersion keyWords:@"" boardID:self.plateID requestType:CommunityListRequestTypeDataUnSave completion:^(BOOL finished, id result, NSError *error) {
        [self endHeadRefreshTableViewData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (error.code == 0) {
            [dataArrary removeAllObjects];
            [dataArrary setArray:result];
            
            lastTopicID = ((CommunityModel *)[dataArrary lastObject]).topicID;
            
            [self.tableView reloadData];
            
            [self addOrRemoveNoDataBackBtn:dataArrary.count];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

-(void)footLoadTableViewDataSource{

    DLog(@"%@---",lastTopicID);
    [self.communityNet requestCommunityListWithUserID:kUserID mID:lastTopicID length:postsNum filter:CommunityAll version:kAPIVersion keyWords:@"" boardID:self.plateID requestType:CommunityListRequestTypeDataUnSave completion:^(BOOL finished, id result, NSError *error) {
        
        [self endFootRefreshTableViewData];
        
        if (error.code == 0) {
            [dataArrary addObjectsFromArray:result];
            
            lastTopicID = ((CommunityModel *)[dataArrary lastObject]).topicID;
            
            [self.tableView reloadData];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}


#pragma mark - tableDelagte

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArrary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView configCellAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSCommunityListCell *cell = (HSCommunityListCell *)[self tableView:tableView configCellAtIndexPath:indexPath];
    return cell.requiredRowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self stopAllAudio];
    
    HSCommunityListCell *cell = (HSCommunityListCell *)[tableView cellForRowAtIndexPath:indexPath];
//    HSCommunityDetailViewController *detailVC = [[HSCommunityDetailViewController alloc] init];
    HSCommunityDetailVC *detailVC = [[HSCommunityDetailVC alloc] init];
    detailVC.topicID = [cell.entity.topicID copy];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView configCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"communityPlateListCell";
    
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


#pragma mark -

-(CommunityNet *)communityNet{
    if (!_communityNet) {
        _communityNet = [[CommunityNet alloc] init];
    }
    return _communityNet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
