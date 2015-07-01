//
//  HSCourseItemBaseCell.m
//  HelloHSK
//
//  Created by Lu on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCourseItemBaseCell.h"

#define borderSpace 5.0f

@implementation HSCourseItemBaseCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kColorClear;
//        self.layer.shouldRasterize = YES;
//        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(CGFloat)requiredRowHeight{
    CGFloat height = 44.0f;
    
    return height;
}

-(UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] init];
        _backView.width = self.width - 2*borderSpace;
        _backView.height = [self requiredRowHeight];
        
        _backView.layer.cornerRadius = 3.0f;
        _backView.layer.masksToBounds = YES;
        [self addSubview:_backView];
    }
    return _backView;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backView.width = self.width - 2*borderSpace;
    self.backView.height = [self requiredRowHeight];
    self.backView.centerX = self.width/2;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.backgroundColor = kColorClear;
//    self.selectedBackgroundView = [[UIView alloc] init];
}

@end
