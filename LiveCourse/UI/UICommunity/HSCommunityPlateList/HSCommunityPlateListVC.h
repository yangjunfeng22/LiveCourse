//
//  HSCommunityPlateListVC.h
//  LiveCourse
//
//  Created by Lu on 15/5/25.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSBaseTableViewController.h"

@interface HSCommunityPlateListVC : HSBaseTableViewController

@property (nonatomic) NSInteger plateID;

-(id)initWithPlateID:(NSInteger)plateID;

@end
