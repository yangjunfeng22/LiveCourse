//
//  HSCommunityCreatPostVC.m
//  LiveCourse
//
//  Created by Lu on 15/6/1.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCommunityCreatPostVC.h"
#import "UIPlaceHolderTextView.h"
#import "KeyboardToolBar.h"
#import "MBProgressHUD.h"
#import "CommunityNet.h"
#import "CommunityModel.h"

@interface HSCommunityCreatPostVC ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,KeyboardToolBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UIPlaceHolderTextView *contentTextView;

@property (nonatomic, strong) KeyboardToolBar *keyboardToolBar;

@property (nonatomic, strong) UIBarButtonItem *rightBtnItem;

@property (nonatomic, strong) CommunityNet *communityNet;

@end

@implementation HSCommunityCreatPostVC{
    
    NSInteger plateID;
    
    NSMutableArray *cellArray;

    CGFloat tableViewHeight;//
}

-(id)initWithPlateID:(NSInteger)plateIDStr{
    self = [super init];
    
    if (self) {
        plateID = plateIDStr;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAction];
    
    if (kiOS7_OR_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    
    if ([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
    }
    if ([self.contentTextView isFirstResponder]) {
        [self.contentTextView resignFirstResponder];
    }
    
    [self.keyboardToolBar KeyboardToolBarResignFirstResponder];
    
    [super viewWillDisappear:animated];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _contentTextView.height = self.tableView.height - self.titleTextField.height;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if (kiOS8_OR_LATER) {
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
}


#pragma mark - Action
//初始化操作
-(void)initAction{
    cellArray = [NSMutableArray arrayWithCapacity:2];
    
    self.title = MyLocal(@"发帖");
    self.view.backgroundColor = kColorWhite;
    
    CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"ico_navigation_back"], @selector(back), self, YES);
    
    self.navigationItem.rightBarButtonItem = self.rightBtnItem;
    self.titleTextField.backgroundColor = kColorClear;
    kAddObserverNotification(self, @selector(textFieldDidChange:), UITextFieldTextDidChangeNotification, self.titleTextField);
    
    //键盘和表哥的初始化不允许交叉
    self.keyboardToolBar.backgroundColor = kColorFABackground;
    
    [self.view bringSubviewToFront:self.keyboardToolBar];
    
    tableViewHeight = self.keyboardToolBar.top - (kiOS7_OR_LATER ? 64 : 0);
    self.tableView.backgroundColor = kColorWhite;
    self.keyboardToolBar.changeTableView = self.tableView;
    
    NSInteger postLimit = [USER_DEFAULT integerForKey:@"PostLimit"];
    self.keyboardToolBar.maxRecodeTime = postLimit;
    
    
    self.contentTextView.backgroundColor = kColorClear;
    
    
    UITableViewCell *titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"00"];
    [titleCell.contentView addSubview:self.titleTextField];
    titleCell.height = self.titleTextField.height;
    [cellArray addObject:titleCell];
    
    UITableViewCell *contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"01"];
    [contentCell.contentView addSubview:self.contentTextView];
    contentCell.height = self.contentTextView.height;
    [cellArray addObject:contentCell];

    [self.tableView reloadData];
}




-(void)back{
    
    //判断有无输入数据
    
    if (![NSString isNullString:self.titleTextField.text] || ![NSString isNullString:self.contentTextView.text] || self.keyboardToolBar.imageData || self.keyboardToolBar.audioData) {
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:MyLocal(@"确定放弃当前输入吗?")];
        
        [alert bk_setCancelButtonWithTitle:MyLocal(@"取消") handler:nil];
        
        [alert bk_addButtonWithTitle:MyLocal(@"放弃输入") handler:^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        
        [alert show];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


//发送帖子
-(void)createPost:(id)sender{
    [self.view endEditing:YES];
    
    //停止音频播放等等
    [self.keyboardToolBar KeyboardToolBarResignFirstResponder];
    [self.keyboardToolBar stopRecordVoiceOrPlay];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //图片
    NSData *imageData = [NSData dataWithData:self.keyboardToolBar.imageData];
    
    NSString *picDataString = imageData ? [imageData base64Encoding] : @"";
    
    NSString *picSafeString = [NSString safeString:picDataString];
    
    NSString *borderIDStr = [NSString stringWithFormat:@"%i",plateID];
    
    //音频
    NSData *audioData = [NSData dataWithData:self.keyboardToolBar.audioData];
    NSString *audioDataString = audioData ? [audioData base64Encoding] : @"";
    NSString *audioSafeString = [NSString safeString:audioDataString];
    NSInteger duration = self.keyboardToolBar.duration;
    
    
    [self.communityNet requestCommunityPostWithUserID:kUserID borderID:borderIDStr title:self.titleTextField.text content:self.contentTextView.text audio:audioSafeString duration:duration picture:picSafeString thumbnail:@"" posted:[timeStamp() integerValue] completion:^(BOOL finished, id result, NSError *error) {
        if (finished) {
            
            CommunityModel *entity = result;
            
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(backToListViewAndGoToDetailViewWithTopicID:)]) {
                [self.delegate backToListViewAndGoToDetailViewWithTopicID:[entity.topicID copy]];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocal(@"发帖失败") message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)dealloc{
    kRemoveObserverNotification(self, UITextFieldTextDidChangeNotification, nil);
}



-(void)editSubmitBtnStatus{
    NSString *titleStr = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *contentStr = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL titleIsNotNull = ![NSString isNullString:titleStr];
    
    //内容不全为空
    BOOL contentIsNotNull = ![NSString isNullString:contentStr] || self.keyboardToolBar.audioData || self.keyboardToolBar.imageData;
    
    
    if (titleIsNotNull && contentIsNotNull ) {
        self.rightBtnItem.enabled = YES;
    }else{
        self.rightBtnItem.enabled = NO;
    }
}

#pragma mark - keyboardToolBarDelegate
-(void)keyboardToolBarDelegateImageDataSelect:(BOOL)isSelect{
    [self editSubmitBtnStatus];
}

-(void)keyboardToolBarDelegateAudioDataSelect:(BOOL)isSelect{
    [self editSubmitBtnStatus];
}


#pragma mark - delegate
-(void)textFieldDidChange:(NSNotification *)notification{
    [self editSubmitBtnStatus];
}


-(void)textViewDidChange:(UITextView *)textView{
    [self editSubmitBtnStatus];
}




#pragma mark - table delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [cellArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [cellArray objectAtIndex:indexPath.row];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if (kiOS8_OR_LATER) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - UI

-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat top = kiOS7_OR_LATER ? 64 : 0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.width,tableViewHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kColorWhite;
        
        if (kiOS7_OR_LATER) {
            _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            _tableView.separatorInset = UIEdgeInsetsZero;
        }
//        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UITextField *)titleTextField{
    if (!_titleTextField) {
        CGFloat left = 15;
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(left, 0, self.view.width - left * 2, 50)];
        _titleTextField.placeholder = MyLocal(@"标题 (必填)") ;
        _titleTextField.textColor = kColorWord;
        _titleTextField.font = [UIFont systemFontOfSize:18.0f];
        _titleTextField.delegate = self;
        _titleTextField.backgroundColor = kColorClear;
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _titleTextField;
}


-(KeyboardToolBar *)keyboardToolBar{
    if (!_keyboardToolBar) {
        
        _keyboardToolBar = [[KeyboardToolBar alloc] init];
        
        CGFloat bottom = self.view.height - (kiOS7_OR_LATER ? 0 : 44);
        _keyboardToolBar.bottom = bottom;
        _keyboardToolBar.viewController = self;
        
        _keyboardToolBar.isShowContentTextField = NO;
        _keyboardToolBar.isShowSendBtn = NO;
        _keyboardToolBar.isChangeViewFrame = YES;
        _keyboardToolBar.delegate = self;
        
        [self.view addSubview:_keyboardToolBar];
    }
    return _keyboardToolBar;
}


-(UIPlaceHolderTextView *)contentTextView{
    if (!_contentTextView) {
        CGFloat left = 10;
        _contentTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(left, 0, self.view.width - left * 2, 0)];
        _contentTextView.height = tableViewHeight - self.titleTextField.height;
        _contentTextView.placeholder = MyLocal(@"内容:");
        _contentTextView.delegate = self;
        _contentTextView.font = [UIFont systemFontOfSize:18.0f];
        _contentTextView.textColor = kColorWord;
        _contentTextView.backgroundColor = kColorClear;
    }
    return _contentTextView;
}


-(UIBarButtonItem *)rightBtnItem{
    if (!_rightBtnItem) {
        
        UIButton* buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonRight.frame = CGRectMake(0, 0, 80, 40);
        [buttonRight setTitle:MyLocal(@"发表") forState:UIControlStateNormal];
        [buttonRight setTitleColor:kColorMain forState:UIControlStateNormal];
        [buttonRight setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        buttonRight.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        buttonRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (kiOS7_OR_LATER) {
            buttonRight.titleEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, -10);
        }else{
            buttonRight.titleEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        [buttonRight addTarget:self action:@selector(createPost:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
        _rightBtnItem.enabled = NO;
    }
    return _rightBtnItem;
}


-(CommunityNet *)communityNet{
    if (!_communityNet) {
        _communityNet = [[CommunityNet alloc] init];
    }
    return _communityNet;
}

@end
