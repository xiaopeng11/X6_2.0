//
//  HelpViewController.m
//  project-x6
//
//  Created by Apple on 16/8/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

{
    UIWebView *_helpView;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_ispresent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
        naviView.backgroundColor = Mycolor;
        naviView.userInteractionEnabled = YES;
        [self.view addSubview:naviView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2.0, 20, 200, 44)];
        title.text = @"帮助";
        title.font = TitleFont;
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [naviView addSubview:title];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(15, 25, 34, 34);
        [backButton setImage:[UIImage imageNamed:@"g3_a"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(helpbackVC:) forControlEvents:UIControlEventTouchUpInside];
        [naviView addSubview:backButton];
        
        _helpView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
        NSString *helpString = [NSString stringWithFormat:@"%@%@",X6basemain_API,X6_help];
        [_helpView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:helpString]]];
        [self.view addSubview:_helpView];
    } else {
        [self naviTitleWhiteColorWithText:@"帮助"];
        
        _helpView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        NSString *helpString = [NSString stringWithFormat:@"%@%@",X6basemain_API,X6_help];
        [_helpView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:helpString]]];
        [self.view addSubview:_helpView];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)helpbackVC:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
