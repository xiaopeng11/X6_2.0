//
//  StartCarouselViewController.m
//  shopProject
//
//  Created by diudiu on 15/9/1.
//  Copyright (c) 2015年 diudiu. All rights reserved.
//
#define HMNewfeatureImageCount 4

#import "StartCarouselViewController.h"
#import "AppDelegate.h"
#import "FirstViewController.h"

@interface StartCarouselViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain) UIPageControl *pageControl;

@end

@implementation StartCarouselViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
    [self setupPageControl];
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    for (int i = 0; i<HMNewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * KScreenWidth, 0, KScreenWidth, KScreenHeight)];
        NSString *name = [NSString stringWithFormat:@"feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 给最后一个imageView添加按钮
        if (i == HMNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(HMNewfeatureImageCount * KScreenWidth, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = HMNewfeatureImageCount;
    pageControl.center_X = self.view.width * 0.5;
    pageControl.center_Y = self.view.height - 30;
    [self.view addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor]; // 当前页的小圆点颜色
    pageControl.pageIndicatorTintColor = ColorRGB(189, 189, 189); // 非当前页的小圆点颜色
    self.pageControl = pageControl;
}

/**
 设置最后一个UIImageView中的内容
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    [self setupStartButton:imageView];
}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageView addSubview:startButton];
    
    startButton.center_X = self.view.width * 0.3;
    startButton.center_Y = self.view.height * 0.86;
    startButton.width = 140;
    startButton.height = 40;
    
    // 4.设置文字
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_anniu_h"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  开始
 */
- (void)start
{
    // 切换控制器
    FirstViewController *vc = [[FirstViewController alloc] init];
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
    // 设置页码
    self.pageControl.currentPage = intPage;
}

@end
