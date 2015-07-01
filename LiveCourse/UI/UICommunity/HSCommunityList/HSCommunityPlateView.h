//
//  HSCommunityPlateView.h
//  LiveCourse
//
//  Created by Lu on 15/5/22.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityPlateModel.h"


#pragma mark -  plateBtn

@interface PlateBtn : UIButton

@property (nonatomic, strong)CommunityPlateModel *communityPlateModel;

-(void)loadUIWithPlateModel:(CommunityPlateModel *)plateModel;

@end





#pragma mark - HSCommunityPlateView


@protocol HSCommunityPlateViewDelegate <NSObject>

-(void)communityPlateViewChoosePlateDelegate:(NSInteger)plateID andTitle:(NSString *)title;

@end





@interface HSCommunityPlateView : UIView

@property (nonatomic, weak) id<HSCommunityPlateViewDelegate> delegate;

-(void)setPlateDataArray:(NSArray *)dataArray;

@end
