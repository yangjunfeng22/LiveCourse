//
//  UICourseLevelCell.h
//  LiveCourse
//
//  Created by Lu on 15/1/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

#pragma mark - UICourseLevelCellItem
@interface UICourseLevelCellItem : UIButton

-(void)loadDataWithImageUrl:(NSURL *)imgUrl andTitle:(NSString *)title;


@property (nonatomic, strong) CourseModel *courseModel;

@end



@protocol UICourseLevelCellDelegate <NSObject>

-(void)choseOneCourseAndCourseCID:(NSString *)cID;
-(void)choseOneCourseAndCourseCID:(NSString *)cID courseName:(NSString *)name;

@end


#pragma mark - UICourseLevelCell
@interface UICourseLevelCell : UITableViewCell

@property (nonatomic, weak) id<UICourseLevelCellDelegate> delegate;

@property (nonatomic, copy) NSString *categoryID;

- (void)setModelArray:(NSArray *)modelArray;//测试数据 改为NSInteger 后期改为数组

- (CGFloat)requiredRowHeight;


@end
