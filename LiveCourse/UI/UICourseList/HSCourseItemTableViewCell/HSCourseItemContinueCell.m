//
//  HSCourseItemContinueCell.m
//  HelloHSK
//
//  Created by Lu on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCourseItemContinueCell.h"
#import "HSContinueLearnHandle.h"



@implementation HSCourseItemContinueCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}


-(CGFloat)requiredRowHeight{
    CGFloat height = continueCellHeight;
    if (!kiPhone){
        height = 1.5 * continueCellHeight;
    }
    return height;
}

-(void)loadUI{
    self.backView.height = continueCellHeight;
    self.backView.backgroundColor = kColorMain;
    self.backView.layer.cornerRadius = 5;
}

-(void)editTextStatus{
    BOOL hasLearnRecord = [HSContinueLearnHandle hasContinueLearnRecords];
    if (!hasLearnRecord) {
        self.continueLabel.text = GDLocal(@"开始学习");
    }else{
        self.continueLabel.text = GDLocal(@"继续学习");
    }
}


-(UILabel *)continueLabel{
    if (!_continueLabel) {
        _continueLabel = [[UILabel alloc] init];
        _continueLabel.size = CGSizeMake(100, 44);
        _continueLabel.textColor = kColorWhite;
        _continueLabel.backgroundColor = kColorClear;
        _continueLabel.centerX = self.backView.width/2;
        _continueLabel.centerY = self.backView.height/2;
        _continueLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _continueLabel.textAlignment = NSTextAlignmentCenter;
        if (!kiPhone) {
            _continueLabel.font = [UIFont systemFontOfSize:20.0f];
        }
        [self.backView addSubview:_continueLabel];
    }
    return _continueLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //[self performSelectorOnMainThread:self.selector withObject:nil waitUntilDone:YES];
}

@end
