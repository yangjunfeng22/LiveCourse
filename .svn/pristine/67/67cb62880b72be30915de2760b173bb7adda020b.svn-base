//
//  HSAppRecommendTableViewController.m
//  HelloHSK
//
//  Created by yang on 14-4-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAppRecommendTableViewController.h"
//#import "ResponseModel.h"
#import "AppRecommendNet.h"
#import "RecommendModel.h"
#import "HSAppRecommendCell.h"
#import "MessageHelper.h"
#import "UINavigationController+Extern.h"

@interface HSAppRecommendTableViewController ()
{
    NSInteger level;
    
    NSMutableArray *arrApp;
    AppRecommendNet *appRecommendNet;
}


@end

@implementation HSAppRecommendTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = GDLocal(@"应用推荐");
        
        arrApp = [[NSMutableArray alloc] initWithCapacity:2];
        
        appRecommendNet = [[AppRecommendNet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadData
{
    
    [appRecommendNet requestAppRecommendCompletion:^(BOOL finished, id result, NSError *error) {
        if (error.code == 0) {
            [arrApp setArray:result];
            [self.tableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)refreshInterface
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [arrApp count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HSAppRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HSAppRecommendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSInteger row = [indexPath row];
    
    RecommendModel *recommend = [arrApp objectAtIndex:row];

    cell.recommendModel = recommend;
    
    return cell;
}

#pragma mark - Table view delegate
/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIImage *img = cell.imageView.image;
    
    cell.imageView.image = [UIImage originImage:img scaleToSize:imgPSize];
    
    return indexPath;
}
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    RecommendModel *recommend = [arrApp objectAtIndex:row];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:recommend.appURL]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewRowHeight * 2.0f;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [arrApp removeAllObjects];
    arrApp = nil;
}

@end
