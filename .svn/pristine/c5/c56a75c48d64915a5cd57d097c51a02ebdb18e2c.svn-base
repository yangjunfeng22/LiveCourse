//
//  UICourseLevelViewController.m
//  LiveCourse
//
//  Created by Lu on 15/1/9.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseLevelViewController.h"
#import "UICourseLevelCell.h"

#import "CourseNet.h"
#import "CourseDAL.h"
#import "CourseModel.h"

#import "MBProgressHUD.h"
#import "UINavigationController+Extern.h"
#import "MessageHelper.h"

#define headerHeight 60


NSInteger courseArraySort(CourseModel *obj1, CourseModel *obj2, void *context)
{
    float price1 = [obj1.weight floatValue];
    float price2 = [obj2.weight floatValue];
    
    if (price1 > price2) {
        return (NSComparisonResult)NSOrderedDescending;
    }else if (price1 < price2){
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame; ;
}

@interface UICourseLevelViewController ()<UICourseLevelCellDelegate>

@end

@implementation UICourseLevelViewController
{
    CourseNet *courseNet;
    NSMutableArray *courseListDataArray;
    NSMutableArray *courseListParentArray;
    NSMutableDictionary *couseListSonDic;
}

-(id)initWithStyle:(UITableViewStyle)style{
    self =  [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    self.title = MyLocal(@"选择课程");
    [self.navigationController setPresentNavigationBarBackItemWihtTarget:self image:nil];
    //CreatViewControllerImageBarButtonItem(ImageNamed(@"ico_navigation_back"), @selector(back:), self, YES);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    courseNet = [[CourseNet alloc] init];
    courseListDataArray = [[NSMutableArray alloc] init];
    courseListParentArray = [[NSMutableArray alloc] init];
    couseListSonDic = [[NSMutableDictionary alloc] init];
    
    __block MBProgressHUD *hud;
    NSArray *arrCourse = [CourseDAL queryCourseList];
    if ([arrCourse count] > 0)
    {
        [self loadCourseWithData:arrCourse];
    }
    else
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载")];
    }
    __weak UICourseLevelViewController *weakSelf = self;
    [courseNet requestCourseListDataWithUserID:kUserID Completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        
        if (!finished) {
            //NSString *errorDomain = error.domain;
            //[hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:errorDomain isHide:YES position:HUDYOffSetPositionCenter];
            
            NSString *errorDomain = error.domain;
            if (![errorDomain isEqualToString:@"ASIHTTPRequestErrorDomain"])
            {
                [MessageHelper makeToastWithMessage:errorDomain view:weakSelf.view];
            }
            else
            {
                [MessageHelper makeToastWithMessage:MyLocal(@"网络不可用，请检查网络设置") view:weakSelf.view];
            }
        }
        
        [self queryCourseListData];
        
    }];
}

#pragma mark - 数据处理
-(void)queryCourseListData
{
    NSArray *arrCourse = [CourseDAL queryCourseList];
    [self loadCourseWithData:arrCourse];
}

- (void)loadCourseWithData:(NSArray *)data
{
    [courseListDataArray setArray:data];
    
    NSMutableArray *tempParentArray = [NSMutableArray arrayWithCapacity:2];
    [courseListDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CourseModel *courseModel = obj;
        if ([courseModel.parentID isEqualToString:@"0"]) {
            [tempParentArray addObject:courseModel];
        }
    }];
    
    [courseListDataArray removeObjectsInArray:courseListParentArray];
    
    [courseListParentArray setArray:[tempParentArray sortedArrayUsingFunction:courseArraySort context:nil]];
    
    [courseListParentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CourseModel *parentModel = obj;
        
        NSMutableArray *tempSonArray = [[NSMutableArray alloc] init];
        
        [courseListDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CourseModel *courseModel = obj;
            
            if ([courseModel.parentID isEqualToString: parentModel.cID]) {
                [tempSonArray addObject:courseModel];
            }
        }];
        
        [couseListSonDic setObject:[tempSonArray sortedArrayUsingFunction:courseArraySort context:nil] forKey:parentModel.cID];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - UItableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return courseListParentArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self tableView:tableView configCellAtIndexPath:indexPath];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UICourseLevelCell *cell = [self tableView:tableView configCellAtIndexPath:indexPath];
    return [cell requiredRowHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}

-(UICourseLevelCell *)tableView:(UITableView *)tableView configCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *courseLevelCellIdentifier = @"courseLevelCellIdentifier";
    UICourseLevelCell *cell = (UICourseLevelCell *)[tableView dequeueReusableCellWithIdentifier:courseLevelCellIdentifier];
    if (!cell) {
        cell = [[UICourseLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:courseLevelCellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CourseModel *parentModel = [courseListParentArray objectAtIndex:indexPath.section];
    NSString *parentCID = parentModel.cID;
    NSArray *sonArray =  [NSArray arrayWithArray:[couseListSonDic objectForKey:parentCID]];
    
    cell.categoryID = parentCID;
    [cell setModelArray:sonArray];
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CourseModel *parentModel = [courseListParentArray objectAtIndex:section];
    
    UILabel *headLabel = (UILabel *)[tableView headerViewForSection:section];
    if (!headLabel) {
        headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, headerHeight)];
        
        headLabel.backgroundColor = kColorWhite;
        headLabel.textColor = kColorMain;
        headLabel.font = [UIFont systemFontOfSize:16.0f];
        headLabel.layer.borderWidth = 0.5f;
        headLabel.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2f].CGColor;
        NSString *text = parentModel.tName ? parentModel.tName:@"";
        headLabel.attributedText = [self resetContentWithText:text];
    }
    return headLabel;
}

- (NSMutableAttributedString *)resetContentWithText:(NSString *)text{
    
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    paragraphStyle.firstLineHeadIndent = 15;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString:text attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    
    return attributedString;
}


#pragma mark -UICourseLevelCellDelegate
-(void)choseOneCourseAndCourseCID:(NSString *)cID
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(choseOneCourseWithCourseCID: courseName:)]) {
            [self.delegate choseOneCourseWithCourseCID:cID courseName:@""];
        }
    }];
}

- (void)choseOneCourseAndCourseCID:(NSString *)cID courseName:(NSString *)name
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseOneCourseWithCourseCID:courseName:)]) {
        [self.delegate choseOneCourseWithCourseCID:cID courseName:name];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
