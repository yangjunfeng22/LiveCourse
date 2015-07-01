//
//  HSLoginViewController.h
//  HelloHSK
//
//  Created by yang on 14-2-20.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HSLoginViewControllerDelegate <NSObject>
@optional
- (void)loginFinish;
@end


@interface HSLoginViewController : UIViewController<UITextFieldDelegate,HSLoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel     *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel     *lblPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton    *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton    *btnRegister;
@property (weak, nonatomic) IBOutlet UIView      *loginAreaView;
@property (weak, nonatomic) IBOutlet UIButton    *btnFindPwd;
@property (weak, nonatomic) IBOutlet UIButton    *btnTempUser;

@property (weak, nonatomic) id <HSLoginViewControllerDelegate>delegate;

-(void)signIn;



@end
