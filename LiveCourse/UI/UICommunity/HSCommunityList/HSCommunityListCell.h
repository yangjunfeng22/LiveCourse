//
//  HSCommunityListCell.h
//  HelloHSK
//
//  Created by Lu on 14/12/1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityModel.h"
#import "CommunityAudioBtn.h"

@protocol HSCommunityListCell <NSObject>



@end

@interface HSCommunityListCell : UITableViewCell

@property (nonatomic, strong) CommunityAudioBtn *communityAudioBtn;//音频按钮


@property (nonatomic) NSInteger requiredRowHeight;

@property (nonatomic, strong) CommunityModel *entity;

@end
