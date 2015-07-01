//
//  UICourseLevelCell.m
//  LiveCourse
//
//  Created by Lu on 15/1/19.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseLevelCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Extra.h"
#import "CourseModel.h"
#import "HSContinueLearnHandle.h"

#define oneLineNum 3    //一行展示几个
#define verticalSpace 15 //垂直向间隔
#define horizontalSpace 20 //横向间隔
#define topSapce 20 //第一行距离顶部距离
#define borderSapce 10 //距离边界的距离
#define itemHeight 80
#define itemWidth 95


#pragma mark - UICourseLevelCellItem

@interface UICourseLevelCellItem ()

@property (nonatomic, strong) UIImageView *courseLevelImageView;
@property (nonatomic, strong) UILabel *courseLevelTitleLabel;

@end


@implementation UICourseLevelCellItem

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)loadDataWithImageUrl:(NSURL *)imgUrl andTitle:(NSString *)title{
    UIImage *placeholderImage = [UIImage imageNamed:@"ico_default_placehold"];
    [self.courseLevelImageView sd_setImageWithURL:imgUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _courseLevelImageView.size = placeholderImage.size;
        _courseLevelImageView.centerX = self.width/2;
        _courseLevelImageView.top = 0;
    }];
    
    self.courseLevelTitleLabel.text = title;
}

-(UIImageView *)courseLevelImageView{
    if (!_courseLevelImageView) {
        _courseLevelImageView = [[UIImageView alloc] init];
        _courseLevelImageView.backgroundColor = kColorClear;
        [self addSubview:_courseLevelImageView];
    }
    return _courseLevelImageView;
}


-(UILabel *)courseLevelTitleLabel{
    if (!_courseLevelTitleLabel) {
        _courseLevelTitleLabel = [[UILabel alloc] init];
        
        _courseLevelTitleLabel.backgroundColor = kColorClear;
        
        _courseLevelTitleLabel.left = 0;
        _courseLevelTitleLabel.height = 15;
        _courseLevelTitleLabel.width = self.width;
        _courseLevelTitleLabel.bottom = self.height;
        _courseLevelTitleLabel.textColor = kColorBlack;
        
        _courseLevelTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        _courseLevelTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_courseLevelTitleLabel];
    }
    return _courseLevelTitleLabel;
}


@end

#pragma mark - UICourseLevelCell
@interface UICourseLevelCell ()



@end


@implementation UICourseLevelCell
{
    NSInteger dataNum;//数据个数
    NSArray *courseModelArray;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

- (void)setModelArray:(NSArray *)modelArray{
    courseModelArray = [NSArray arrayWithArray:modelArray];
    dataNum = courseModelArray.count;
    [self loadData];
}

- (void)prepareForReuse{
    [self removeAllSubviews];
}

- (void)loadData
{
    CGFloat itemSpace = (self.width - 2 * borderSapce - oneLineNum * itemWidth)/(oneLineNum-1);
    NSUInteger idx = 0;
    for (CourseModel *model in courseModelArray)
    {
        UICourseLevelCellItem *item = (UICourseLevelCellItem *)[self viewWithTag:KUICourseLevelCellItemTag + idx];
        if (!item) {
            
            NSInteger lineNum = idx/oneLineNum; // 第几行
            NSInteger columnNum = idx%oneLineNum;// 第几列
            
            CGFloat tempTop = topSapce + itemHeight * lineNum + verticalSpace*lineNum;
            CGFloat tempLeft = borderSapce + columnNum * (itemWidth + itemSpace);
            
            item = [[UICourseLevelCellItem alloc] initWithFrame:CGRectMake(tempLeft, tempTop, itemWidth, itemHeight)];
            item.courseModel = model;
            [item loadDataWithImageUrl:[NSURL URLWithString:model.picture] andTitle:model.tName];
            [item addTarget:self action:@selector(choseOneCourseAction:) forControlEvents:UIControlEventTouchUpInside];
            item.backgroundColor = kColorClear;
            item.tag = KUICourseLevelCellItemTag + idx;
            [self addSubview:item];
        }
        idx++;
    }
}

-(void)choseOneCourseAction:(id)sender
{
    UICourseLevelCellItem *tempCellItem = sender;
    NSString *courseCID = tempCellItem.courseModel.cID;
    NSString *ccID = tempCellItem.courseModel.parentID;
    // !!! 保存种类ID和课程ID
    kSetUDCourseCategoryID(ccID);
    HSAppDelegate.curCCID = [ccID copy];
    HSAppDelegate.curCID = [courseCID copy];
    NSString *name = [tempCellItem.courseModel.tName copy];
    
    [HSContinueLearnHandle setContinueWithCategoryID:ccID];
    [HSContinueLearnHandle setContinueWithCourseID:courseCID];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseOneCourseAndCourseCID:courseName:)]) {
        
        [self.delegate choseOneCourseAndCourseCID:courseCID courseName:name];
    }
}

-(CGFloat)requiredRowHeight{
    
    NSInteger lineNum = (dataNum-1)/oneLineNum;// 多少行
    
    CGFloat cellHeight = topSapce*2 + itemHeight * (lineNum + 1) + lineNum * verticalSpace;
    
    return cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
