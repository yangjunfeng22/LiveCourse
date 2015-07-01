//
//  HSMessageFilterView.m
//  HelloHSK
//
//  Created by junfengyang on 14/11/19.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSMessageFilterView.h"

@implementation HSMessageFilterView
{
    UIButton *btnSystem;
    UIButton *btnTeacher;
    UIButton *btnFriend;
    UIButton *btnBBS;
    UIButton *btnAll;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initInterface];
    }
    return self;
}

- (void)initInterface
{
    CGFloat fontSize = kiPhone ? 12:18;
    CGFloat widthFactor = 0.2f;
    NSString *strSys = [[NSString alloc] initWithFormat:@"  %@", MyLocal(@"系统")];
    btnSystem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width*widthFactor, self.height-1)];
    btnSystem.backgroundColor = [UIColor whiteColor];
    [btnSystem setTitle:strSys forState:UIControlStateNormal];
    [btnSystem setTitleColor:kColorMain forState:UIControlStateNormal];
    [btnSystem setImage:[UIImage imageNamed:@"ico_message_system"] forState:UIControlStateNormal];
    btnSystem.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btnSystem addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    btnSystem.layer.borderWidth = 0.5;
    btnSystem.layer.borderColor = kColorLine.CGColor;
    [self addSubview:btnSystem];
    
    NSString *strTeach = [[NSString alloc] initWithFormat:@"  %@", MyLocal(@"教师")];
    btnTeacher = [[UIButton alloc] initWithFrame:CGRectMake(btnSystem.right, 0, self.width*widthFactor, self.height-1)];
    btnTeacher.backgroundColor = [UIColor whiteColor];
    [btnTeacher setTitle:strTeach forState:UIControlStateNormal];
    [btnTeacher setTitleColor:kColorMain forState:UIControlStateNormal];
    [btnTeacher setImage:[UIImage imageNamed:@"ico_message_teacher"] forState:UIControlStateNormal];
    btnTeacher.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btnTeacher.layer.borderWidth = 0.5;
    btnTeacher.layer.borderColor = kColorLine.CGColor;
    [btnTeacher addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnTeacher];
    
    NSString *strFriend = [[NSString alloc] initWithFormat:@"  %@", MyLocal(@"好友")];
    btnFriend = [[UIButton alloc] initWithFrame:CGRectMake(btnTeacher.right, 0, self.width*widthFactor, self.height-1)];
    btnFriend.backgroundColor = [UIColor whiteColor];
    [btnFriend setTitle:strFriend forState:UIControlStateNormal];
    [btnFriend setTitleColor:kColorMain forState:UIControlStateNormal];
    [btnFriend setImage:[UIImage imageNamed:@"ico_message_friend"] forState:UIControlStateNormal];
    btnFriend.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btnFriend.layer.borderWidth = 0.5;
    btnFriend.layer.borderColor = kColorLine.CGColor;
    [btnFriend addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnFriend];
    
    NSString *strBBS = [[NSString alloc] initWithFormat:@"  %@", MyLocal(@"社区")];
    btnBBS = [[UIButton alloc] initWithFrame:CGRectMake(btnFriend.right, 0, self.width*widthFactor, self.height-1)];
    btnBBS.backgroundColor = [UIColor whiteColor];
    [btnBBS setTitle:strBBS forState:UIControlStateNormal];
    [btnBBS setTitleColor:kColorMain forState:UIControlStateNormal];
    [btnBBS setImage:[UIImage imageNamed:@"ico_message_friend"] forState:UIControlStateNormal];
    btnBBS.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btnBBS.layer.borderWidth = 0.5;
    btnBBS.layer.borderColor = kColorLine.CGColor;
    [btnBBS addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBBS];
    
    NSString *strAll = [[NSString alloc] initWithFormat:@"  %@", MyLocal(@"全部")];
    btnAll = [[UIButton alloc] initWithFrame:CGRectMake(btnBBS.right, 0, self.width*widthFactor, self.height-1)];
    btnAll.backgroundColor = [UIColor whiteColor];
    [btnAll setTitle:strAll forState:UIControlStateNormal];
    [btnAll setTitleColor:kColorMain forState:UIControlStateNormal];
    [btnAll setImage:[UIImage imageNamed:@"ico_message_all"] forState:UIControlStateNormal];
    btnAll.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btnAll.layer.borderWidth = 0.5;
    btnAll.layer.borderColor = kColorLine.CGColor;
    [btnAll addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAll];
}

- (void)filterAction:(id)sender
{
    NSString *filterType = kMessageAll;
    if ([sender isEqual:btnSystem]) {
        filterType = kMessageSystem;
    }else if ([sender isEqual:btnTeacher]){
        filterType = kMessageTeacher;
    }else if ([sender isEqual:btnFriend]){
        filterType = kMessageFriend;
    }else if ([sender isEqual:btnBBS]){
        filterType = kMessageBBS;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageFiltered:)])
    {
        [self.delegate messageFiltered:filterType];
    }
}

@end
