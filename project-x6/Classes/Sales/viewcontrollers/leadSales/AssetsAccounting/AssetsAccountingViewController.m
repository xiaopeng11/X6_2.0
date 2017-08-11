//
//  AssetsAccountingViewController.m
//  project-x6
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AssetsAccountingViewController.h"
#import "X6WebView.h"
@interface AssetsAccountingViewController ()

@end

@implementation AssetsAccountingViewController

- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"资产概要"];
    
    if (!_ishow) {
        UIView *noTodayMoneyview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"资产概要"];
        [self.view addSubview:noTodayMoneyview];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        
        X6WebView *AssetsAccountingWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        AssetsAccountingWebView.webViewString = X6_AssetsAccounting;
        [self.view addSubview:AssetsAccountingWebView];
        //加载
        [AssetsAccountingWebView loadRequestWithBody:nil];
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


@end
