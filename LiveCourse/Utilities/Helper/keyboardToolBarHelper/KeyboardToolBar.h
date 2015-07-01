//
//  keyboardToolBar.h
//  LiveCourse
//
//  Created by Lu on 15/6/1.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

#define kKeyboardToolBarDefaultHeight 49

#pragma mark - KeyboardToolBarDelegate
@protocol KeyboardToolBarDelegate <NSObject>


@optional
/**
 *  发送按钮的代理
 */
-(void)keyboardToolBarDelegateSendBtnClick;

/**
 *  选择图片的代理
 *
 *  @param isSelect <#isSelect description#>
 */
-(void)keyboardToolBarDelegateImageDataSelect:(BOOL)isSelect;

/**
 *  选择音频的代理
 *
 *  @param isSelect <#isSelect description#>
 */
-(void)keyboardToolBarDelegateAudioDataSelect:(BOOL)isSelect;

@end



#pragma mark - KeyboardToolBar
@interface KeyboardToolBar : UIView

//设置
@property (nonatomic, assign) BOOL isShowImgBtn;                    //是否显示图片按钮(默认显示)
@property (nonatomic, assign) BOOL isShowContentTextField;          //是否显示文本框(默认显示)
@property (nonatomic, assign) BOOL isShowSendBtn;                   //是否显示发表按钮(默认显示)


//属性

@property (nonatomic,weak) UIViewController *viewController;             //需传入当前控制器（必须）
@property (nonatomic,weak) UITableView *changeTableView;                       //传入当前表格，便于控制表格高度
@property (nonatomic,assign) BOOL isChangeViewFrame;                      //弹出键盘时是否改变当前页面布局 (默认不改变)

@property (nonatomic, assign) NSInteger maxRecodeTime;              //最大录音时长

@property (nonatomic, strong) HPGrowingTextView *contentTextField;        //内容

@property (nonatomic, copy) NSString *contentTextFieldPlaceholder;  //文本框文本

@property (nonatomic, strong) NSData *imageData;                     //图片数据
@property (nonatomic, strong) NSData *audioData;                     //音频数据
@property (nonatomic, assign) NSInteger duration;                  //音频时长

@property (nonatomic, weak) id <KeyboardToolBarDelegate> delegate;

-(void)KeyboardToolBarResignFirstResponder;                         //取消相应


-(void)renewStatus;         //恢复到初始状态

/**
 *  停止录音和播放
 */
-(void)stopRecordVoiceOrPlay;

@end