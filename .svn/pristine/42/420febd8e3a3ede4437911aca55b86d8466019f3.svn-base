//
//  HSRegisterAreaView.m
//  HelloHSK
//
//  Created by yang on 14-3-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSRegisterAreaView.h"

@implementation HSRegisterAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lbEmail.textColor = kColorMain;
        self.lbPassword.textColor = kColorMain;
        self.lbRepassword.textColor = kColorMain;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = kColorWhite;
    
    self.lbEmail.text = GDLocal(@"Email:");
    self.lbPassword.text = GDLocal(@"密码:");
    self.lbRepassword.text = GDLocal(@"确认密码");
    
    self.lbEmail.textColor = kColorMain;
    
    CGFloat backLabelWidth = self.width * 0.95f;
    CGFloat backLabelLeft = (self.width * 0.05f) / 2;
    
    if (kiPhone) {
        backLabelWidth = self.width * 0.95f;
        backLabelLeft = (self.width * 0.05f) / 2;
    }else{
        backLabelWidth = self.width * 0.99f;
        backLabelLeft = (self.width * 0.01f) / 2;
    }
    
    
    UILabel *lbEmailBackLabel = [[UILabel alloc] init];
    lbEmailBackLabel.layer.cornerRadius = 8.0f;
    lbEmailBackLabel.layer.borderWidth = 1.0f;
    lbEmailBackLabel.layer.borderColor = kColorMain.CGColor;
    lbEmailBackLabel.layer.masksToBounds = YES;
    
    lbEmailBackLabel.width = backLabelWidth;
    lbEmailBackLabel.height = self.lbEmail.height + 20;
    lbEmailBackLabel.left = backLabelLeft;
    lbEmailBackLabel.top = self.lbEmail.top - 10;
    lbEmailBackLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self insertSubview:lbEmailBackLabel belowSubview:self.lbEmail];
    
    self.lbPassword.textColor = kColorMain;
    UILabel *lbPasswordBackLabel = [[UILabel alloc] init];
    lbPasswordBackLabel.layer.cornerRadius = 8.0f;
    lbPasswordBackLabel.layer.borderWidth = 1.0f;
    lbPasswordBackLabel.layer.borderColor = kColorMain.CGColor;
    lbPasswordBackLabel.layer.masksToBounds = YES;
    
    lbPasswordBackLabel.width = backLabelWidth;
    lbPasswordBackLabel.height = self.lbPassword.height + 20;
    lbPasswordBackLabel.left = backLabelLeft;
    lbPasswordBackLabel.top = self.lbPassword.top - 10;
    lbPasswordBackLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self insertSubview:lbPasswordBackLabel belowSubview:self.lbEmail];
    
    self.lbRepassword.textColor = kColorMain;
    UILabel *lbRepasswordBackLabel = [[UILabel alloc] init];
    lbRepasswordBackLabel.layer.cornerRadius = 8.0f;
    lbRepasswordBackLabel.layer.borderWidth = 1.0f;
    lbRepasswordBackLabel.layer.borderColor = kColorMain.CGColor;
    lbRepasswordBackLabel.layer.masksToBounds = YES;
    
    lbRepasswordBackLabel.width = backLabelWidth;
    lbRepasswordBackLabel.height = self.lbRepassword.height + 20;
    lbRepasswordBackLabel.left = backLabelLeft;
    lbRepasswordBackLabel.top = self.lbRepassword.top - 10;
    lbRepasswordBackLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self insertSubview:lbRepasswordBackLabel belowSubview:self.lbEmail];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Memory Manager
- (void)dealloc
{
    [_lbEmail removeFromSuperview];
    [_lbPassword removeFromSuperview];
    [_lbRepassword removeFromSuperview];
    
    self.lbEmail = nil;
    self.lbPassword = nil;
    self.lbRepassword = nil;
    
    [_tfEmail removeFromSuperview];
    [_tfPassword removeFromSuperview];
    [_tfRepassword removeFromSuperview];
    
    self.tfEmail = nil;
    self.tfPassword = nil;
    self.tfRepassword = nil;
}

@end
