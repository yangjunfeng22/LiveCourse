//
//  HSCourseItemSentenceView.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/15.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSAudioPlayerButton.h"
#import "SentenceLabel.h"


@protocol HSCourseItemSentenceViewDelegate;

@interface HSCourseItemSentenceView : UIView
@property (weak, nonatomic) id<HSCourseItemSentenceViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblSeparator;
@property (weak, nonatomic) IBOutlet UILabel *lblTranslation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet HSAudioPlayerButton *btnAudioPlayer;
@property (weak, nonatomic) IBOutlet SentenceLabel *lblSentence;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) id sentenceData;

@property (nonatomic, copy) NSString *highlightStrig;

- (void)playMedia;

@end


@protocol HSCourseItemSentenceViewDelegate <NSObject>

@optional
- (void)sentenceView:(HSCourseItemSentenceView *)view shouldShowOther:(BOOL)flag;

@end