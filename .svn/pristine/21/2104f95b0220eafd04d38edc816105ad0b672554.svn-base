//
//  keyboardImgManageView.h
//  LiveCourse
//
//  Created by Lu on 15/6/2.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - KeyboardImgManageViewDelegate
@protocol KeyboardImgManageViewDelegate <NSObject>

@optional

/**
 *  选择好图片的处理
 */
-(void)keyboardImgManageImageSelectedDelegate:(NSData *)imageData;;

/**
 *  删除掉图片的处理
 */
-(void)keyboardImgManageImageDeleteDelegate;

@end



#pragma mark - KeyboardImgManageView
@interface KeyboardImgManageView : UIView

@property (nonatomic,weak) UIViewController *viewController; 

@property (nonatomic, weak) id <KeyboardImgManageViewDelegate> delegate;

@end
