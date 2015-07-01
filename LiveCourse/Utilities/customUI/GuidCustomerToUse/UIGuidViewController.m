//
//  UIGuidViewController.m
//  DicisionMaking
//
//  Created by yang on 13-4-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UIGuidViewController.h"
#import "UIImageView+Extra.h"

#define SCROLL_WIDTH self.view.frame.size.width
#define SCROLL_HEIGHT self.view.frame.size.height
#define EXPERIENCE_BUTTON_FRAME CGRectMake(SCROLL_WIDTH - 120.0f, SCROLL_HEIGHT - 80.0f, 100.0f, 36.0f)

@interface UIGuidViewController ()
{
    UIPageControl *pageControl;
}

@end

@implementation UIGuidViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil guidPages:(NSArray *)aPages
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        arrGuidPages = [[NSMutableArray alloc] init];
        [arrGuidPages setArray:aPages];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIScrollView *scrGuid = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCROLL_WIDTH, SCROLL_HEIGHT)];
    scrGuid.delegate = self;
    scrGuid.pagingEnabled = YES;
    scrGuid.bounces = NO;
    scrGuid.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrGuid];
    [self updateScrollViewBackgroundColor:scrGuid];
    
    NSArray *arrTitle = @[@"你知道吗？中文其实很简单很有趣",
                          @"全新的学习模式，让你循序渐进 ",
                          @"生动的Flash视频，让你学习不枯燥",
                          @"时尚的口语学习，更让你爱不释手",
                          @"轻松愉悦学汉语，就从这里开始~"];
    
//    NSArray *arrPlace = @[@"0.8f", @"0.65f", @"0.65f", @"0.62f", @"0.59f"];
    
    NSInteger guidCount = [arrGuidPages count];
    
    [arrGuidPages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *strImageName = (NSString *)obj;
        UIImage *img = [UIImage imageNamed:strImageName];
        CGSize imgSize = [img size];
        
        CGFloat imgWidth = imgSize.width * (kiPhone ? 0.5f : 1.0f);
        CGFloat imgHeight = imgSize.height * (kiPhone ? 0.5f : 1.0f);
        UIImageView *imgvGuid = [[UIImageView alloc] init];
        if (kiPhone4) {
            imgvGuid.bounds = CGRectMake(0.0f, 0.0f, imgWidth * 0.8f, imgHeight * 0.8f);
        }else{
            imgvGuid.bounds = CGRectMake(0.0f, 0.0f, imgWidth, imgHeight);
        }
        
        imgvGuid.center = CGPointMake(idx*SCROLL_WIDTH+SCROLL_WIDTH*0.5f, SCROLL_HEIGHT*0.55f);
        //imgvGuid.image = img;
        [imgvGuid showClipImageWithImage:img];
        [scrGuid addSubview:imgvGuid];
        
        NSString *title = GDLocal([arrTitle objectAtIndex:idx]);
        UILabel *lblTitle = [[UILabel alloc] init];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.bounds = CGRectMake(0.0f, 0.0f, SCROLL_WIDTH*0.8f, 40.0f);
        lblTitle.numberOfLines = 0;
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = [UIColor whiteColor];
        lblTitle.text = title;
        [scrGuid addSubview:lblTitle];
        [lblTitle sizeToFit];
        //CGFloat yPlace = [[arrPlace objectAtIndex:idx] floatValue];
        //lblTitle.center = CGPointMake(imgvGuid.center.x, imgvGuid.center.y + imgvGuid.bounds.size.height*yPlace + lblTitle.bounds.size.height*0.5f);
        lblTitle.centerX = imgvGuid.centerX;
        lblTitle.bottom = self.view.bottom - 30;
        
        if (idx == guidCount-1)
        {
            lblTitle.bottom = self.view.bottom - 80;
            
            UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            experienceBtn.bounds = CGRectMake(0.0f, 0.0f, 178, 56);
            experienceBtn.center = CGPointMake(idx*SCROLL_WIDTH + SCROLL_WIDTH*0.5f, scrGuid.bounds.size.height - 19-56+25);
            [experienceBtn setBackgroundImage:[UIImage imageNamed:@"img_btn_BeginExprence.png"] forState:UIControlStateNormal];
            [experienceBtn setTitleColor:[UIColor colorWithRed:115.0f/255.0f green:122.0f/255.0f blue:135.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [experienceBtn setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
            [experienceBtn setTitle:GDLocal(@"立即体验") forState:UIControlStateNormal];
            
            [experienceBtn addTarget:self action:@selector(experienceAction:) forControlEvents:UIControlEventTouchUpInside];
            [scrGuid addSubview:experienceBtn];
        }
    }];
    
    CGFloat scrContentWidth = SCROLL_WIDTH * [arrGuidPages count];
    [scrGuid setContentSize:CGSizeMake(scrContentWidth, SCROLL_HEIGHT)];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, SCROLL_HEIGHT - 36.0f, SCROLL_WIDTH, 36.0f)];
    pageControl.numberOfPages = [arrGuidPages count];
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    [pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [self pageChanged:pageControl];
}

-(void)pageChanged:(UIPageControl*)pc
{
    NSArray *subViews = pc.subviews;
    for (int i = 0; i < [subViews count]; i++)
    {
        UIView* subView = [subViews objectAtIndex:i];
        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIImageView class])]) {
            ((UIImageView*)subView).image = (pc.currentPage == i ? [UIImage imageNamed:@"ico_pageControlSelected.png"] : [UIImage imageNamed:@"ico_pageControlUnSelected.png"]);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScrollViewBackgroundColor:(UIScrollView *)scrollView
{
    scrollView.backgroundColor = kColorMain;
}

#pragma mark - 
#pragma mark UIButton Action
- (void)experienceAction:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(UIGuidViewControllerDelegate)]
        && [self.delegate respondsToSelector:@selector(guidViewController:experienceAction:)])
    {
        [self.delegate guidViewController:self experienceAction:sender];
    }
}

#pragma mark -
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self pageChanged:pageControl];
}

@end
