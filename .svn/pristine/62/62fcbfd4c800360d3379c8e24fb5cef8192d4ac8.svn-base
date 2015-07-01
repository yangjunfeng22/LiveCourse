//
//  HSCourseItemWordView.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/15.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSAudioPlayerButton.h"
#import "HSPinyinLabel.h"

@protocol HSCourseItemWordViewDelegate;

@interface HSCourseItemWordView : UIView
@property (weak, nonatomic) id<HSCourseItemWordViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgvPicture;
@property (weak, nonatomic) IBOutlet HSPinyinLabel *lblWord;
@property (weak, nonatomic) IBOutlet UILabel *lblTranslation;
@property (weak, nonatomic) IBOutlet UILabel *lblSeparator;
@property (weak, nonatomic) IBOutlet UIButton *btnShowSentence;
@property (weak, nonatomic) IBOutlet HSAudioPlayerButton *btnAudioPlayer;

@property (nonatomic, strong) id wordData;

- (void)playMedia;

@end


@protocol HSCourseItemWordViewDelegate <NSObject>

@optional
- (void)wordView:(HSCourseItemWordView *)view shouldShowOther:(BOOL)flag;

@end