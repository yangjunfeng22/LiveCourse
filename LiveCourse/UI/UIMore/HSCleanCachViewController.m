//
//  HSCleanCachViewController.m
//  HelloHSK
//
//  Created by Lu on 14/12/5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCleanCachViewController.h"
#import "UINavigationController+Extern.h"

@interface HSCleanCachViewController ()

@end

@implementation HSCleanCachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    if (kiOS7_OR_LATER) {
        imageView.top = 64;
        imageView.height -= 64;
    }
    
    NSString *imageName = MyLocal(@"clearup-guide") ;
    
    imageView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
