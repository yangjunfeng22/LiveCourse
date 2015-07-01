//
//  HSCourseItemCourseCell.m
//  HelloHSK
//
//  Created by Lu on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCourseItemCourseCell.h"
#import "ZDProgressView.h"
#import "UserDAL.h"
#import "CourseDAL.h"
#import "LessonModel.h"
#import "LessonProgressModel.h"

#import "KeyChainHelper.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Extra.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "UIImageView+LBBlurredImage.h"
#import "FXBlurView.h"

#import "HSUIAnimateHelper.h"


NSString *const kRefreshOrganizationProgress = @"RefreshOrganizationProgress";

@interface HSCourseItemCourseCell ()
{
    NSString *curLID;
    UIImage *imgLessonLocked;
    UIImage *imgLessonNeedVip;
    NSInteger curStars;
    NSInteger allStars;
}

@property (nonatomic, strong) UIView *lucencyView;//蒙层
@property (nonatomic, strong) ZDProgressView *zdProgressView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *courseTypeLabel;
@property (nonatomic, strong) UIImageView *goldenCupImageView;
@property (nonatomic, strong) ASImageNode *imageNode;

@property (nonatomic, strong) UILabel *starNumLabel;//星星个数
@property (nonatomic, strong) UIImageView *starImageView;//星星图标

@end

@implementation HSCourseItemCourseCell{
    CGFloat progressValue;
    CGRect bottomViewFrame;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        kAddObserverNotification(self, @selector(refreshProgress:), kRefreshLessonProgressAndStatus, nil);
        kAddObserverNotification(self, @selector(nextLesson:), kNexLessonNotification, nil);
        
        [self loadData];
    }
    return self;
}

- (void)dealloc
{
    kRemoveObserverNotification(self, kRefreshLessonProgressAndStatus, nil);
    kRemoveObserverNotification(self, kNexLessonNotification, nil);
}


-(CGFloat)requiredRowHeight
{
    CGFloat height = courseCellHeight;
    if (!kiPhone){
        height = 311;
    }
    return height;
}

- (void)loadData
{
    curStars = 0;
    allStars = 0;
    imgLessonLocked = ImageNamed(@"ico_lesson_lock");
    imgLessonNeedVip = ImageNamed(@"ico_lesson_needVip");
    self.backView.height = courseCellHeight;
    if (kiOS7_OR_LATER) {
        self.backView.tintColor = [UIColor lightGrayColor];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backView.centerX       = self.width*0.5;
    _zdProgressView.centerX     = self.backView.width*0.5;
    _bottomView.bottom          = self.backView.height;
    _bottomView.width           = self.backView.width;
    _lucencyView.width          = self.backView.width;
    _goldenCupImageView.centerX = self.backView.width*0.5;
    _starImageView.left         = _bottomView.width-_starImageView.size.width-9;
    _starNumLabel.right         = _starImageView.left-6;
}

#pragma mark - 通知
- (void)refreshProgress:(NSNotification *)notification
{
    NSString *lID = [notification.userInfo objectForKey:@"LessonID"];
    if ([lID isEqualToString:curLID])
    {
        [self loadLessonStatusWithLessonID:lID];
        [self synchronouLessonProgress:lID];
    }
}

- (void)nextLesson:(NSNotification *)notification
{
    NSString *lID = [notification.userInfo objectForKey:@"LessonID"];
    if ([lID isEqualToString:curLID])
    {
        [self loadLessonStatusWithLessonID:lID];
        [self synchronouLessonProgress:lID];
        if (self.delegate && [self.delegate respondsToSelector:@selector(courseItem:nexLesson:)])
        {
            [self.delegate courseItem:self nexLesson:self.lesson];
        }
    }
}

#pragma mark - action
-(void)loadProgressData
{
    self.goldenCupImageView.hidden = YES;
    self.zdProgressView.hidden = NO;
    self.lucencyView.hidden = YES;
    //计算进度
    if (self.courseItemStatusType == HSCourseItemStatusTypeLock)
    {
        if (kiPhone) {
            self.zdProgressView.width = 100;
        }else{
            self.zdProgressView.width = 200;
        }
        self.zdProgressView.prsColor = kColorMain;//HEXCOLOR(0xAB2B9B4);
        [self.zdProgressView setProgress:1];
        self.zdProgressView.textColor = kColorWhite;
        //self.zdProgressView.text = MyLocal(@"未解锁");
        self.lucencyView.hidden = NO;
        
        UIImage *imgNode = [UserDAL userVipRoleEnable] ? imgLessonLocked:imgLessonNeedVip;
        self.imageNode.image = imgNode;
        self.imageNode.frame = CGRectMake((self.zdProgressView.width - imgNode.size.width)*0.5, (self.zdProgressView.height - imgNode.size.height)*0.5, imgNode.size.width, imgNode.size.height);
        
    }
    else if (self.courseItemStatusType == HSCourseItemStatusTypeNotStart)
    {
        if (kiPhone) {
            self.zdProgressView.width = 100;
        }else{
            self.zdProgressView.width = 200;
        }
        self.zdProgressView.prsColor = kColorMainWithA(0.9);
        [self.zdProgressView setProgress:1];
        self.zdProgressView.textColor = kColorWhite;
        
        self.lucencyView.hidden = YES;
        
        if (self.unitIndex <= 0 && self.lessonIndex <= 0)
        {
            self.zdProgressView.text = MyLocal(@"开始");
        }
        else
        {
            if (![UserDAL userVipRoleEnable])
            {
                self.imageNode.image = nil;
                self.imageNode.image = imgLessonNeedVip;
                self.imageNode.frame = CGRectMake((self.zdProgressView.width - imgLessonNeedVip.size.width)*0.5, (self.zdProgressView.height - imgLessonNeedVip.size.height)*0.5, imgLessonNeedVip.size.width, imgLessonNeedVip.size.height);
                self.zdProgressView.text = @"";
                
                self.lucencyView.hidden = NO;
            }
            else
            {
                self.imageNode.image = nil;
                [_imageNode.view removeFromSuperview];
                _imageNode = nil;
                self.zdProgressView.text = MyLocal(@"开始");
            }
        }
        
    }
    else if (self.courseItemStatusType == HSCourseItemStatusTypeHasRecord)
    {
        self.zdProgressView.width = kiPhone ? self.backView.width*0.6 : 400;
        
        self.zdProgressView.prsColor = kColorMain;
        [self.zdProgressView setProgress:progressValue];
        self.zdProgressView.textColor = kColorBlack;//kColorWord;
        CGFloat progress = progressValue*100;
        progress = ((progress > 0 && progress < 1.0) ? 1.0:(progress > 99 && progress < 100) ? 99:progress);
        NSString *progressStr = [NSString stringWithFormat:@"%.0f%%" , progress];
        self.zdProgressView.text = progressStr;
        self.lucencyView.hidden = YES;
        
        self.imageNode.image = nil;
    }
    else if (self.courseItemStatusType == HSCourseItemStatusTypeFinish)
    {
        self.zdProgressView.hidden = YES;
        self.goldenCupImageView.hidden = NO;
        self.lucencyView.hidden = YES;
    }
    
    self.backView.centerX = self.width*0.5;
    self.zdProgressView.centerX = self.backView.width*0.5;
    self.bottomView.width = self.backView.width;
    self.lucencyView.width = self.backView.width;
    self.goldenCupImageView.centerX = self.backView.width*0.5;
}

- (void)setProgress:(CGFloat)aProgress
{
    //progressValue = aProgress;
    //[self loadProgressData];
}

- (void)setLesson:(LessonModel *)lesson
{
    _lesson = lesson;
    
    curLID = [lesson.lID copy];
    
    [self loadLessonStatusWithLessonID:curLID];
    [self synchronouLessonProgress:curLID];
    
    self.lessonTitle = lesson.tTitle;
    
    UIImage *imgPlaceHold = [[UIImage imageNamed:@"img_lesson_placehold"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];

    NSURL *url = [NSURL URLWithString:lesson.picture];
    [self.backView sd_setImageWithURL:url placeholderImage:imgPlaceHold completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //DLog(@"课时界面获取图标信息: %@: url: %@", error.description, url);
        if (error.code == 0 || error.code == 200) {
            [self.backView showClipImageWithImage:image];
        }
    }];
}

- (void)loadLessonStatusWithLessonID:(NSString *)lessonID
{
    //DLog(@"用户ID： %@", kUserID);
    LessonProgressModel *lProgress = [CourseDAL queryLessonProgressDataWithLessonID:lessonID userID:kUserID];
    if ([lProgress.lID isEqualToString:lessonID])
    {
        if (lProgress)
        {
            if (lProgress.progressValue > 0){
                if (lProgress.statusValue == LessonLearnedStatusFinished){
                    // status为2表示已经完成这一课了。
                    _courseItemStatusType = HSCourseItemStatusTypeFinish;
                }else{
                    _courseItemStatusType = HSCourseItemStatusTypeHasRecord;
                }
            }else{
                _courseItemStatusType = HSCourseItemStatusTypeNotStart;
            }
        }
        else
        {
            if (self.unitIndex <= 0 && self.lessonIndex <= 0){
                _courseItemStatusType = HSCourseItemStatusTypeNotStart;
            }else{
                _courseItemStatusType = HSCourseItemStatusTypeLock;
            }
        }
        
        CGFloat percent = lProgress.progressValue >= 0 ? lProgress.progressValue : 0;
        progressValue = percent;
    }

    if (self.courseItemStatusType != HSCourseItemStatusTypeLock && lProgress.allStarsValue > 0)
    {
        NSString *starNum = [[NSString alloc] initWithFormat:@"%@/%@", lProgress.curStars, lProgress.allStars];
        self.starNumLabel.text = starNum;
        self.starImageView.hidden = NO;
    }

    //[self setProgress:percent];
    [self loadProgressData];
}

- (void)setLessonTitle:(NSString *)lessonTitle
{
    _lessonTitle = lessonTitle;
    self.courseTypeLabel.text = lessonTitle;
}

- (void)refreshLessonStatus
{
    [self loadLessonStatusWithLessonID:curLID];
}

#pragma mark - 同步数据
// 同步课程学习进度的数据
- (void)synchronouLessonProgress:(NSString *)lID
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(courseItem:loadLesson:)]){
        //[self.delegate courseItem:self loadLesson:lID];
    }
}

#pragma mark - ui
- (ASImageNode *)imageNode
{
    if (!_imageNode)
    {
        _imageNode = [[ASImageNode alloc] init];
        [self.zdProgressView addSubview:_imageNode.view];
    }
    return _imageNode;
}

- (UIView *)lucencyView{
    if (!_lucencyView) {
        _lucencyView = [[UIView alloc] initWithFrame:self.backView.bounds];
        _lucencyView.backgroundColor = kColorWhite;//HEXCOLORA(0xffff, 0.3);
        [self.backView insertSubview:_lucencyView atIndex:0];
        _lucencyView.alpha = 0.8;
        /*
        _lucencyView.dynamic = NO;
        _lucencyView.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];
        _lucencyView.contentMode = UIViewContentModeBottom;
        _lucencyView.blurRadius = 10;
        
        //take snapshot, then move off screen once complete
        [_lucencyView updateAsynchronously:YES completion:^{}];
        */
    }
    return _lucencyView;
}

-(ZDProgressView *)zdProgressView{
    if (!_zdProgressView) {
        _zdProgressView = [[ZDProgressView alloc] init];
        _zdProgressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        if (kiPhone) {
            _zdProgressView.height = 20;
        }else{
            _zdProgressView.height = 36;
        }
        
        _zdProgressView.centerY = (self.backView.height-self.bottomView.height)*0.5;
        _zdProgressView.centerX = self.backView.width*0.5;
        _zdProgressView.noColor = kColorWhite;
        _zdProgressView.textColor = kColorWord;
        _zdProgressView.borderColor = kColorWhite;
        _zdProgressView.prsColor = kColorMain;
        _zdProgressView.textFont = [UIFont systemFontOfSize:14.0f];
        [self.backView addSubview:_zdProgressView];
    }
    return _zdProgressView;
}


-(UIView *)bottomView{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] init];
        _bottomView.width = self.backView.width;
        _bottomView.height = 22.0f;
        _bottomView.bottom = self.backView.height;
        _bottomView.backgroundColor = kColorWhite;
        [self.backView addSubview:_bottomView];
    }
    return _bottomView;
}


-(UILabel *)courseTypeLabel
{
    if (!_courseTypeLabel) {
        _courseTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, self.bottomView.width*2/3, self.bottomView.height)];
        _courseTypeLabel.textColor = kColorWhite;
        _courseTypeLabel.backgroundColor = kColorClear;
        _courseTypeLabel.textColor = kColorMain;
        _courseTypeLabel.font = kFontHel(14);
        _courseTypeLabel.adjustsFontSizeToFitWidth = YES;
        [self.bottomView addSubview:_courseTypeLabel];
    }
    return _courseTypeLabel;
}


-(UIImageView *)goldenCupImageView{
    if (!_goldenCupImageView) {
        UIImage *cupImg = [UIImage imageNamed:@"image_home_passCup"];
        _goldenCupImageView = [[UIImageView alloc] initWithImage:cupImg];
        _goldenCupImageView.size = cupImg.size;
        
        _goldenCupImageView.centerY = (self.backView.height - self.bottomView.height)/2;
        [self.backView addSubview:_goldenCupImageView];
    }
    return _goldenCupImageView;
}

-(UILabel *)starNumLabel{
    if (!_starNumLabel) {
        _starNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.starImageView.left, 0, self.bottomView.width*0.3, self.bottomView.height)];
        _starNumLabel.right = self.starImageView.left-6;
        _starNumLabel.textColor = kColorWord;
        _starNumLabel.font = kFontHel(15);
        _starNumLabel.textAlignment = NSTextAlignmentRight;
        [self.bottomView addSubview:_starNumLabel];
    }
    return _starNumLabel;
}

-(UIImageView *)starImageView{
    
    if (!_starImageView) {
        UIImage *starImg = [UIImage imageNamed:@"icon_finalTest_star"];
        _starImageView = [[UIImageView alloc] initWithImage:starImg];
        _starImageView.size = starImg.size;
        _starImageView.centerY = self.bottomView.height*0.5;
        _starImageView.left = self.bottomView.width-starImg.size.width-9;
        [self.bottomView addSubview:_starImageView];
    }
    
    return _starImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)prepareForReuse
{
    [super prepareForReuse];
    curLID = @"";
    progressValue = 0;
    curStars = 0;
    allStars = 0;
    _unitIndex = 0;
    _lessonIndex = 0;
    _courseItemStatusType = HSCourseItemStatusTypeLock;
    
    self.zdProgressView.text = @"";
    self.imageNode.image = nil;
    self.starImageView.hidden = YES;
    self.starNumLabel.text = @"";
}

@end
