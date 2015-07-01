//
//  HSImageChoiceItem.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/26.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSImageChoiceItem : UIControl

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *itemID;
@property (nonatomic) BOOL isRightAnswer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgvPicture;

@end
