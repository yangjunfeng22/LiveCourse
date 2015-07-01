//
//  HSCourseItemUnitTestCell.m
//  LiveCourse
//
//  Created by Lu on 15/1/23.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCourseItemUnitTestCell.h"

@interface HSCourseItemUnitTestCell ()

@property (nonatomic, strong) UIImageView *unitTestImageView;//单元测试图标
@property (nonatomic, strong) UILabel *unitTestLabel;//单元测试的label

@end

@implementation HSCourseItemUnitTestCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}


-(void)loadUI{
    self.backView.height = unitCellHeight;
    self.backView.backgroundColor = HEXCOLOR(0x5ACA72);
    self.unitTestImageView.backgroundColor = kColorClear;
    self.unitTestLabel.backgroundColor = kColorClear;
}


-(UIImageView *)unitTestImageView{
    if (!_unitTestImageView) {
        UIImage *image = [UIImage imageNamed:@"img_community_placeholder"];
        _unitTestImageView = [[UIImageView alloc] initWithImage:image];
//        _unitTestImageView.size = image.size;
        _unitTestImageView.size = CGSizeMake(45, 45);
        _unitTestImageView.top = 10;
        _unitTestImageView.centerX = self.backView.width/2;
        [self.backView addSubview:_unitTestImageView];
    }
    return _unitTestImageView;
}

-(UILabel *)unitTestLabel{
    if (!_unitTestLabel) {
        _unitTestLabel = [[UILabel alloc] init];
        _unitTestLabel.text = MyLocal(@"单元测试");
        _unitTestLabel.top = self.unitTestImageView.bottom + 5;
        _unitTestLabel.width = 150;
        _unitTestLabel.centerX = self.backView.width/2;
        _unitTestLabel.height = 15;
        _unitTestLabel.textAlignment = NSTextAlignmentCenter;
        _unitTestLabel.font = [UIFont systemFontOfSize:14.0f];
        _unitTestLabel.textColor = kColorWhite;
        [self.backView addSubview:_unitTestLabel];
    }
    return _unitTestLabel;
}

-(CGFloat)requiredRowHeight{
    return unitCellHeight;
}



@end
