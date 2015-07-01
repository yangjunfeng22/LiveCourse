//
//  UIPlaceHolderTextView.h
//  cat_ios

//  Created by Lu on 14/11/7.
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end