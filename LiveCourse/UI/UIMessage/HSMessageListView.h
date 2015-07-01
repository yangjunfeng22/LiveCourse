//
//  HSMessageListView.h
//  HelloHSK
//
//  Created by yang on 14-7-2.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MessageType) {
    kMessageTypeSystem = 0,
    kMessageTypeReplay,
    kMessageTypeFriend,
    kMessageTypeBBS,
};
@protocol HSMessageListViewDelegate;

@interface HSMessageListView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)id<HSMessageListViewDelegate>delegate;

- (void)filterMessageWithType:(NSString *)aType;

@end

@protocol HSMessageListViewDelegate <NSObject>

@optional
- (void)messageListView:(HSMessageListView *)msgListView messageID:(NSInteger)messageID messageType:(MessageType)messageType link:(NSString *)link linkEnabled:(BOOL)flag shareTitle:(NSString *)shareTitle targetID:(NSString *)targetID;

@end
