//
//  HSMessageViewController.h
//  HelloHSK
//
//  Created by yang on 14/11/6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^MSGBasicBlock)(void);
typedef void (^MSGDataBlock)(NSData *data);
#endif

@interface HSMessageViewController : UIViewController//UITableViewController
{
    #if NS_BLOCKS_AVAILABLE
    MSGBasicBlock quitBlock;
    #endif
}

#if NS_BLOCKS_AVAILABLE
- (void)setQuitBlock:(MSGBasicBlock)aQuitBlock;
#endif

@end
