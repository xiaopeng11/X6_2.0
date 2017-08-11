//
//  InventoryComparisonViewController.m
//  project-x6
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InventoryComparisonViewController.h"
#import "X6WebView.h"
@interface InventoryComparisonViewController ()

@end

@implementation InventoryComparisonViewController

- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"库存占比"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    X6WebView *InventoryComparisonwebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    InventoryComparisonwebView.webViewString = X6_InventoryAccounting;
    [InventoryComparisonwebView setTop:0];
    [self.view addSubview:InventoryComparisonwebView];
    [InventoryComparisonwebView loadRequestWithBody:nil];
    
    
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
