//
//  UICourseItemLessonVC.m
//  LiveCourse
//
//  Created by Lu on 15/1/12.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "UICourseItemLessonVC.h"
#import "UICourseItemLessonVideoView.h"
#import "CheckPointDAL.h"
#import "UICourseItemLessonCell.h"
#import "AudioPlayHelper.h"
#import "CheckPointNet.h"
#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"
#import "MBProgressHUD.h"

#import "TextModel.h"
#import "HSCheckPointHandle.h"
#import "UINavigationController+Extern.h"



typedef enum {
    ATCurUp = 1,
    ATCurDown = 2
} animationType;

@interface UICourseItemLessonVC ()<UITableViewDataSource,UITableViewDelegate,AudioPlayHelperDelegate,UICourseItemLessonVideoViewDelegate>

@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UIView *themeView;//主题view
@property (nonatomic, strong) UILabel *themeLabel; // 主题label;
@property (nonatomic, strong) UITableView *contentTableView;//内容
@property (nonatomic, strong) UIButton *continueBtn;//继续按钮
@property (nonatomic, strong) UIButton *translateBtn;//翻译按钮
@property (nonatomic, strong) CheckPointNet *cpNet;
@property (nonatomic, strong) UICourseItemLessonVideoView * videoView;//视频

@end

@implementation UICourseItemLessonVC
{
    BOOL isOverturn;//是否正显示视频页面
    
    UIButton *navRightBtn;
    
    
    TextModel *textModel;
    
    NSMutableArray *textArray;
    NSMutableArray *audioArray;
    NSMutableArray *translateArray;
    AudioPlayHelper *audioPlayer;
    
    NSInteger cellIndex;
    NSInteger userTouchCellIndex;

    BOOL autoPlayAudio;
    
    BOOL showTranslate;
    
    CGFloat continueBtnWidth;
    CGFloat resetBtnWidth;
    
    BOOL isOut;
    
    CGPoint beginOffsetPoint;
    
    BOOL noTranslate;
    
    CGFloat themeViewHeight;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;

    if (kiOS7_OR_LATER)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 关卡名称
    CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithLessonID:HSAppDelegate.curLID checkPointID:HSAppDelegate.curCpID];
    self.title = checkPoint.tName;
    
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"ico_navigation_back"], @selector(back), self, YES);
    
    textArray = [NSMutableArray arrayWithCapacity:2];
    audioArray = [NSMutableArray arrayWithCapacity:2];
    
    autoPlayAudio = YES;
    userTouchCellIndex = -1;
    
    //预加载数据
    [self preload];
    
//    [self performSelector:@selector(queryLessonTextData) withObject:nil afterDelay:0.5f];
    //[self queryLessonTextData];
}


-(void)back{
    isOut = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isOut = YES;
    [audioPlayer stopAudio];
    [_videoView videoStop];
}

-(void)preload
{
    textModel = [CheckPointDAL queryLessonTextWithCheckPointID:[HSAppDelegate.curCpID copy]];
    if (![NSString isNullString:textModel.vedio] ) {
        UIBarButtonItem *rightBtnItem = CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"image_lesson_vedio"], @selector(editVideo:), self, NO);
        navRightBtn = (UIButton *)rightBtnItem.customView;

    }
    
    if (textModel) {
        [self loadDataWithTextModel];
    }
}

/*
-(void)queryLessonTextData
{
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [[NSString alloc] initWithFormat:@"%@", MyLocal(@"加载数据")];
    [lessonTextNet requestLessonTextDataWithCpID:[HSAppDelegate.curCpID copy] Completion:^(BOOL finished, id result, NSError *error) {
        [hud hide:YES];
        
        [self preload];
        
        if (!finished) {
            NSString *errorDomain = error.domain;
            [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:errorDomain isHide:YES position:HUDYOffSetPositionCenter];
        }
    }];
}

*/
-(void)loadDataWithTextModel{
    //背景
    NSString *backStr = textModel.tBackground;
    if (![NSString isNullString:backStr]) {
        self.themeLabel.text = backStr;
        [self.themeLabel sizeToFit];
        self.themeLabel.numberOfLines = 0;
        
        if (self.themeLabel.height + 20 > self.themeView.height) {
            self.themeView.height = self.themeLabel.height + 20;
        }
    }else{
        self.themeView.top = 0;
        self.themeView.height = 0;
        self.themeView.hidden = YES;
    }
    themeViewHeight = self.themeView.height;
    
    
    //中文及拼音
    NSMutableArray *chineseArray = [NSMutableArray arrayWithArray:[textModel.chinese componentsSeparatedByString:@"|"]];
    NSMutableArray *pinyinArray = [NSMutableArray arrayWithArray:[textModel.pinyin componentsSeparatedByString:@"|"]];
    
    [textArray removeAllObjects];
    for (NSInteger i = 0; i < chineseArray.count; i++) {
        
        NSString *chStr = [NSString stringWithFormat:@"%@",[chineseArray objectAtIndex:i]];
        NSString *pinyinStr = nil;
        if (i <= pinyinArray.count) {
            pinyinStr = [NSString stringWithFormat:@"%@",[pinyinArray objectAtIndex:i]];
        }
        NSString *textStr = [[chStr stringByAppendingString:@"^"] stringByAppendingString:[NSString safeString:pinyinStr]];
        [textArray insertObject:textStr atIndex:i];
    }
    
    
    
    CGFloat contentTableViewLeft = 0;
    CGFloat contentTableViewTop =  [NSString isNullString:backStr] ? 0:self.themeView.bottom + 10;
    CGRect contentTableViewFrame = CGRectMake(contentTableViewLeft,contentTableViewTop, self.contentBackView.width - contentTableViewLeft*2, self.contentBackView.height- contentTableViewTop - 5);
    
    self.contentTableView.frame = contentTableViewFrame;
    [self.contentTableView reloadData];
    
    [audioArray setArray:[textModel.audio componentsSeparatedByString:@"|"]];
    
    translateArray = [NSMutableArray arrayWithArray:[textModel.tChinese componentsSeparatedByString:@"|"]];
    if ([NSString isNullString:textModel.tChinese] || !translateArray || translateArray.count == 0) {
        noTranslate = YES;
        self.translateBtn.hidden = YES;
        self.continueBtn.left = 10;
        self.continueBtn.width = self.view.width - 20;
    }
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.contentTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self performSelector:@selector(playAudioWithIndex) withObject:nil afterDelay:1.5f];
}

#pragma mark - action

-(void)editVideo:(id)sender
{
    isOut = YES;
    
    [AudioPlayHelper stopAndCleanAudioPlay];
    
    if (isOverturn) {
        [self closeVideoView];
        isOverturn = NO;
        UIImage *image = [UIImage imageNamed:@"image_lesson_vedio"];
        [navRightBtn setImage:image forState:UIControlStateNormal];
        
        //打开翻译按钮
        if (noTranslate) {
            return;
        }
        self.translateBtn.width = 0;
        self.translateBtn.hidden = YES;
        [UIView animateWithDuration:0.2f animations:^{
            self.translateBtn.hidden = NO;
            self.translateBtn.width = resetBtnWidth;
            self.continueBtn.left = self.translateBtn.right + 10;
            self.continueBtn.width = self.translateBtn.width;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else{
        [self openVideoView];
        isOverturn = YES;
        UIImage *image = [UIImage imageNamed:@"image_lesson_lesson"];
        [navRightBtn setImage:image forState:UIControlStateNormal];
        
        //关闭翻译按钮
        if (noTranslate) {
            return;
        }
        self.translateBtn.hidden = NO;
        [UIView animateWithDuration:0.2f animations:^{
            self.translateBtn.width = 0;
            
            self.continueBtn.left = 10;
            self.continueBtn.width = self.view.width - 10*2;;
        } completion:^(BOOL finished) {
            self.translateBtn.hidden = YES;
        }];
    }
}

-(void)openVideoView{
    
    self.videoView.hidden = NO;
    [self animation:ATCurUp];
    NSString *vedioUrl = /*@"http://192.168.10.98/hsk/sites/default/files/life/video/3.mp4";//*/textModel.vedio;
    //NSLog(@"视频地址: %@", vedioUrl);
    if ([NSString isNullString:vedioUrl]) {
        [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:MyLocal(@"暂无视频") isHide:YES position:HUDYOffSetPositionCenter];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:vedioUrl];
    [self.videoView videoStartWithUrl:url];
}

-(void)closeVideoView{
    self.videoView.hidden = YES;
    [self animation:ATCurDown];
    [self.videoView videoStop];
}

- (void)animation:(animationType)animationType
{
    
    [UIView beginAnimations:@"slideAnimation" context:nil];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (ATCurUp == animationType) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.contentBackView cache:YES];
    }else{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.contentBackView cache:YES];
    }
    [UIView commitAnimations];
}

-(void)continueBtnClick:(id)sender
{
    DLog(@"继续");
    if (!(self.videoView.hidden)) {
        [self closeVideoView];
    }

    __weak UICourseItemLessonVC *weakSelf = self;
    NSString *curCpID = [HSAppDelegate.curCpID copy];
    NSString *nexCpID = [HSAppDelegate.nexCpID copy];
    // 1、将当前关卡置为完成状态。
    [HSCheckPointHandle createCheckPointLearnedInfoWithUserID:kUserID lessonID:HSAppDelegate.curLID checkPointID:curCpID status:CheckPointLearnedStatusFinished version:nil completion:^(BOOL finished, id obj, NSError *error) {
        // 发送本地通知
        kPostNotification(kRefreshCheckPointStatus, nil, @{@"CheckPointID":curCpID});
        
        // 同步关卡进度
        NSString *record = [[NSString alloc] initWithFormat:@"%@|%ld|%f", curCpID, CheckPointLearnedStatusFinished, 1.0];
        
        [weakSelf.cpNet requestCheckPointSynchronousProgressDataWithUserID:kUserID lessonID:HSAppDelegate.curLID records:record completion:^(BOOL finished, id obj, NSError *error) {}];
    }];
    
    // 2、将下一关置为解锁状态。发送本地通知。
    [HSCheckPointHandle createCheckPointLearnedInfoWithUserID:kUserID lessonID:HSAppDelegate.curLID checkPointID:nexCpID status:CheckPointLearnedStatusUnLocked version:nil completion:^(BOOL finished, id obj, NSError *error) {
        // 发送本地通知
        kPostNotification(kRefreshCheckPointStatus, nil, @{@"CheckPointID":nexCpID});
        
        // 同步关卡进度
        CheckPointProgressModel *cpProgress = [CheckPointDAL queryCheckPointProgressWithUserID:kUserID lessonID:HSAppDelegate.curLID checkPointID:HSAppDelegate.nexCpID];
        
        NSString *record = [[NSString alloc] initWithFormat:@"%@|%d|%f", nexCpID, cpProgress.statusValue, cpProgress.progressValue];
        
        [weakSelf.cpNet requestCheckPointSynchronousProgressDataWithUserID:kUserID lessonID:HSAppDelegate.curLID records:record completion:^(BOOL finished, id obj, NSError *error) {}];
    }];
    
    // 3、进入下一关
    CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithLessonID:HSAppDelegate.curLID checkPointID:nexCpID];
    [HSCheckPointHandle requestCheckPointContentDataWithView:self.view net:self.cpNet checkPoint:checkPoint completion:^(BOOL finished, id obj, NSError *error) {
        [self.navigationController popViewControllerAnimated:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(continueToLearnWithCheckPointType:)])
        {
            [self.delegate continueToLearnWithCheckPointType:[obj integerValue]];
        }
    }];
}


-(void)translateBtnClick:(id)sender
{
    autoPlayAudio = NO;
    if ([audioPlayer isPlaying]) {
        [audioPlayer stopAudio];
    }
    
    showTranslate = !showTranslate;
    if (showTranslate) {
        [self.translateBtn setTitle:MyLocal(@"隐藏翻译") forState:UIControlStateNormal];
    }else{
        [self.translateBtn setTitle:MyLocal(@"显示翻译") forState:UIControlStateNormal];
    }
    
    [self.contentTableView reloadData];
}

#pragma mark - ui
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
}

-(UIView *)contentBackView{
    if (!_contentBackView) {
        //CGFloat top = StatuBar_HEIGHT + NavigationBar_HEIGHT;
        CGFloat top = 0;
        if (kiOS7_OR_LATER){
            top = self.navigationController.navigationBar.bottom;
        }
        if (!kiOS7_OR_LATER) {
            top = 0;
        }
        CGRect frame = CGRectMake(0, top, self.view.width, self.continueBtn.top - top - 5);
        _contentBackView = [[UIView alloc] initWithFrame:frame];
        _contentBackView.backgroundColor = kColorWhite;
        [self.view addSubview:_contentBackView];
    }
    return _contentBackView;
}

-(UIView *)themeView{
    if (!_themeView) {
        CGRect frame = CGRectMake(10, 10, self.view.width - 20, 50);
        _themeView = [[UIView alloc] initWithFrame:frame];
        _themeView.backgroundColor = HEXCOLOR(0xD4FBE4);
        _themeView.layer.borderWidth = 0.5f;
        _themeView.layer.cornerRadius = 3.0f;
        _themeView.layer.borderColor = [HEXCOLOR(0x2BBB5B) CGColor];
        _themeView.layer.masksToBounds = YES;
        [self.contentBackView addSubview:_themeView];
        
        UIImage *image = [UIImage imageNamed:@"image_global_sun"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.size = image.size;
        imageView.left = 10;
        imageView.top = 10;
        [_themeView addSubview:imageView];
    }
    return _themeView;
}

-(UILabel *)themeLabel{
    if (!_themeLabel) {
        CGFloat left = 35;
        CGRect frame = CGRectMake(left, 10, self.themeView.width - left - 10, 0);
        _themeLabel = [[UILabel alloc] initWithFrame:frame];
        _themeLabel.backgroundColor = kColorClear;
        _themeLabel.font = kFontHel(15);
        _themeLabel.numberOfLines = 0;
        [self.themeView addSubview:_themeLabel];
    }
    return _themeLabel;
}


-(UIButton *)translateBtn{
    if (!_translateBtn) {
        CGFloat left = 10;
        CGFloat height = 44;
        
        resetBtnWidth = (self.view.width - left*3)/2;
        
        CGRect frame = CGRectMake(left, 0, resetBtnWidth, height);
        _translateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _translateBtn.frame = frame;
        _translateBtn.backgroundColor = kColorMain;
        if (kiOS7_OR_LATER) {
            _translateBtn.bottom = self.view.height - 15;
        }else{
            _translateBtn.bottom = self.view.height - 50;
        }
        
        _translateBtn.layer.cornerRadius = 5.0f;
        _translateBtn.layer.masksToBounds = YES;
        _translateBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_translateBtn setTitle:MyLocal(@"显示翻译") forState:UIControlStateNormal];
        [_translateBtn addTarget:self action:@selector(translateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_translateBtn];
    }
    return _translateBtn;
}

-(UIButton *)continueBtn{
    if (!_continueBtn) {
        CGFloat left = self.translateBtn.right + 10;
        CGFloat height = 44;
        continueBtnWidth = self.view.width - left - 10;
        CGRect frame = CGRectMake(left, 0, continueBtnWidth, height);
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.frame = frame;
        _continueBtn.backgroundColor = kColorMain;
        if (kiOS7_OR_LATER) {
            _continueBtn.bottom = self.view.height - 15;
        }else{
            _continueBtn.bottom = self.view.height - 50;
        }
        
        _continueBtn.layer.cornerRadius = 5.0f;
        _continueBtn.layer.masksToBounds = YES;
        _continueBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_continueBtn setTitle:MyLocal(@"继续") forState:UIControlStateNormal];
        [_continueBtn addTarget:self action:@selector(continueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_continueBtn];
    }
    return _continueBtn;
}



-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] init];
        _contentTableView.backgroundColor = kColorWhite;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        _contentTableView.tableFooterView = view;
        [self.contentBackView addSubview:_contentTableView];
    }
    return _contentTableView;
}


-(UICourseItemLessonVideoView *)videoView{
    if (!_videoView) {
        _videoView = [[UICourseItemLessonVideoView alloc] initWithFrame:CGRectMake(0, 0, self.contentBackView.width, self.contentBackView.height)];
        _videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _videoView.hidden = YES;
        _videoView.delegate = self;
        [self.contentBackView addSubview:_videoView];
    }
    return _videoView;
}

-(void)playerFullscreenStatusChange:(BOOL)isFull{
    if (isFull) {
        self.continueBtn.hidden = YES;
        
        CGFloat top = 0;
        if (kiOS7_OR_LATER){
            top = self.navigationController.navigationBar.bottom;
        }
        if (!kiOS7_OR_LATER) {
            top = 0;
        }
        CGRect frame = CGRectMake(0, top, self.view.width, self.view.height - top);
        self.contentBackView.frame = frame;
        
    }else{
        self.continueBtn.hidden = NO;
        
        
        CGFloat top = 0;
        if (kiOS7_OR_LATER){
            top = self.navigationController.navigationBar.bottom;
        }
        if (!kiOS7_OR_LATER) {
            top = 0;
        }
        CGRect frame = CGRectMake(0, top, self.view.width, self.continueBtn.top - top - 5);
        self.contentBackView.frame = frame;
        
    }
}


- (CheckPointNet *)cpNet
{
    if (!_cpNet)
    {
        _cpNet = [[CheckPointNet alloc] init];
    }
    return _cpNet;
}

#pragma mark - tableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return textArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView configCellAtIndexPath:indexPath];
}



-(UICourseItemLessonCell *)tableView:(UITableView *)tableView configCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textCellIdentifier = @"textCellIdentifier";
    UICourseItemLessonCell *cell = (UICourseItemLessonCell *)[tableView dequeueReusableCellWithIdentifier:textCellIdentifier];
    if (!cell) {
        cell = [[UICourseItemLessonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIdentifier];
        cell.backgroundColor = kColorClear;
    }
    
    
    [cell setTextStr:[textArray objectAtIndex:indexPath.row] andTranslate:[self returnTranslate:indexPath.row]];
    [cell showTranslate:showTranslate];
    
//    if (indexPath.row == 0 && autoPlayAudio) {
//        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        [self performSelector:@selector(playAudioWithIndex) withObject:nil afterDelay:1.0f];
//    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textCellIdentifier = @"textCellIdentifier";
    UICourseItemLessonCell *cell = (UICourseItemLessonCell *)[tableView dequeueReusableCellWithIdentifier:textCellIdentifier];
    if (!cell) {
        cell = [[UICourseItemLessonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIdentifier];
        cell.backgroundColor = kColorClear;
    }
    
    [cell setTextStr:[textArray objectAtIndex:indexPath.row] andTranslate:[self returnTranslate:indexPath.row]];
    [cell showTranslate:showTranslate];
    return  [cell requiredRowHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    autoPlayAudio = NO;
    userTouchCellIndex = indexPath.row;
    [self performSelector:@selector(playAudioWithIndex) withObject:nil afterDelay:0.5f];
}

#pragma mark - scroll delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.contentTableView]) {
        beginOffsetPoint  = self.contentTableView.contentOffset;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    CGFloat minus = scrollView.contentOffset.y - beginOffsetPoint.y;
    
    if (self.themeView.hidden) {
        return;
    }
    
    
    if (minus < -20) {
//                DLog(@"下拉----%f",minus);
        CGRect sortToolViewframe = CGRectMake(10,10, CGRectGetWidth(frame) - 20, themeViewHeight);
        [UIView animateWithDuration:0.2f animations:^{
            [self.themeView setFrame:sortToolViewframe];
            CGFloat top = self.themeView.bottom + 10;
            [self.contentTableView setFrame:CGRectMake(0, top, self.contentBackView.width, self.contentBackView.height- top - 5)];
        }];
    }
    if (minus > 20) {
//                DLog(@"上推+++%f",minus);
        CGRect sortToolViewframe = CGRectMake(10, -10, CGRectGetWidth(frame) - 20, themeViewHeight);
        [UIView animateWithDuration:0.2f animations:^{
            [self.themeView setFrame:sortToolViewframe];

            CGFloat height = self.contentBackView.height - 5;
            
            [self.contentTableView setFrame:CGRectMake(0, 0, self.contentBackView.width, height)];
        }];
    }
    //[super scrollViewDidScroll:scrollView];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.themeView setUserInteractionEnabled:NO];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.themeView setUserInteractionEnabled:YES];
}





#pragma mark - action

-(NSString *)returnTranslate:(NSInteger)index{
    
    if (index >= translateArray.count) {
        return @" ";
    }
    
    NSString *translate = [translateArray objectAtIndex:index];
    translate = [NSString safeString:translate];
    
    NSArray *tempTranslateArray = [NSArray arrayWithArray:[translate componentsSeparatedByString:@":"]];
    if (tempTranslateArray.count < 2) {
        return @" ";
    }
    return [tempTranslateArray objectAtIndex:1];
}



-(void)playAudioWithIndex
{
    if (isOut) {
        return;
    }
    //用户点击相同位置时 如在播放 则停止
    if (cellIndex != userTouchCellIndex) {
        cellIndex = (userTouchCellIndex == -1) ? cellIndex : userTouchCellIndex;
        
        [AudioPlayHelper stopAndCleanAudioPlay];
        
        if (cellIndex >= audioArray.count) {
            return;
        }
        NSString *audio = [audioArray objectAtIndex:cellIndex];
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:audio];
        audioPlayer = [AudioPlayHelper initWithAudioName:path delegate:self];
        [audioPlayer playAudio];

    }else{
        
        if (cellIndex >= audioArray.count) {
            return;
        }
        NSString *audio = [audioArray objectAtIndex:cellIndex];
        NSString *path = [HSBaseTool audioPathWithCheckPoinID:HSAppDelegate.curCpID audio:audio];
        audioPlayer = [AudioPlayHelper initWithAudioName:path delegate:self];
        if ([audioPlayer isPlaying]) {
            [audioPlayer stopAudio];
        }else{
            [audioPlayer playAudio];
        }
    }
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (autoPlayAudio) {
        cellIndex ++;
        if (cellIndex < [textArray count]) {
            
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
            [self.contentTableView selectRowAtIndexPath:nextIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self performSelector:@selector(playAudioWithIndex) withObject:nil afterDelay:1.0f];
        }else{
            cellIndex = textArray.count - 1;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
