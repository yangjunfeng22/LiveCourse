//
//  HSLaunchAdViewController.m
//  LiveCourse
//
//  Created by Lu on 15/4/22.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSLaunchAdViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Extra.h"

@interface HSLaunchAdViewController ()

@property (nonatomic, strong) UIButton *closeAdBtn;//关闭广告

@property (nonatomic, strong) UIImageView *adImageView;//广告图片

@end

@implementation HSLaunchAdViewController
{
    
    NSTimer *timer;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorWhite;
    
    self.adImageView.backgroundColor = kColorClear;
    
    self.closeAdBtn.backgroundColor = kColorClear;

    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(closeAd) userInfo:nil repeats:NO];
}

#pragma mark - Action
-(void)setImageUrl:(NSString *)url{
    NSURL *imageUrl = [NSURL URLWithString:[NSString safeString:url]];
    
    [self.adImageView sd_setImageWithURL:imageUrl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.adImageView showClipImageWithImage:image];
        
    }];
    [self.view bringSubviewToFront:self.closeAdBtn];
}


-(void)closeAd{
    
    [timer invalidate];
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchAdViewControllerDelegateCloseAdBtnClick)]) {
        [self.delegate launchAdViewControllerDelegateCloseAdBtnClick];
    }
}


#pragma mark - UI
-(UIImageView *)adImageView{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        
        [self.view addSubview:_adImageView];
    }
    
    return _adImageView;
}

-(UIButton *)closeAdBtn{
    if (!_closeAdBtn) {
        _closeAdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *img = [UIImage imageNamed:@"icon_global_delete"];
        
        [_closeAdBtn setImage:img forState:UIControlStateNormal];
        _closeAdBtn.size = img.size;
        
        _closeAdBtn.top = 10;
        _closeAdBtn.right = self.view.width - 10;
        [_closeAdBtn addTarget:self action:@selector(closeAd) forControlEvents:UIControlEventTouchUpInside];

        [self.view insertSubview:_closeAdBtn aboveSubview:self.adImageView];
    }
    return _closeAdBtn;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)dealloc
{
    _closeAdBtn = nil;
    _adImageView = nil;
    timer = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
