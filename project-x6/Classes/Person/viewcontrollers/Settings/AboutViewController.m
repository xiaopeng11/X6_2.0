//
//  AboutViewController.m
//  project-x6
//
//  Created by Apple on 16/8/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AboutViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"关于"];
    
    [self drawAboutUI];
    
}

- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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

- (void)drawAboutUI
{
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 72) / 2.0, 33, 72, 73)];
    logoView.image = [UIImage imageNamed:@"p1_a"];
    [self.view addSubview:logoView];
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoView.bottom + 23, KScreenWidth, 25)];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = @"欢迎使用X6阅阅";
    welcomeLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:welcomeLabel];
    
    NSArray *headerArray = @[@"版本",@"售前电话",@"售后电话",@"QQ"];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = [userdefault valueForKey:X6_releases];
    NSArray *lastArray = @[currentVersion,@"0512-67671677",@"0512-67671131",@"800073723"];
    for (int i = 0; i < 5; i++) {
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, welcomeLabel.bottom + 30 + 45 * i, KScreenWidth, .5)];
        [self.view addSubview:lineView];
        if (i < 4) {
            UILabel *headerlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lineView.bottom + 12 , 100, 20)];
            headerlabel.text = headerArray[i];
            headerlabel.font = [UIFont systemFontOfSize:15];
            [self.view addSubview:headerlabel];
            
            UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 130, lineView.bottom + 12, 120, 20)];
            lastLabel.textAlignment = NSTextAlignmentRight;
            lastLabel.font = [UIFont systemFontOfSize:15];
            lastLabel.userInteractionEnabled = YES;
            lastLabel.text = lastArray[i];
            [self.view addSubview:lastLabel];
            
            if (i == 1) {
                UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FirsttapAction:)];
                [lastLabel addGestureRecognizer:tapAction];
            } else if (i == 2) {
                UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SecondtapAction:)];
                [lastLabel addGestureRecognizer:tapAction];
            }
            
        }
    }
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight - 25 - 15 - 64, KScreenWidth, 15)];
    bottomLabel.font = [UIFont systemFontOfSize:10];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"Copyright@2010-2016 YingJian Information Technology";
    [self.view addSubview:bottomLabel];
    
}

- (void)FirsttapAction:(UITapGestureRecognizer *)tap
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:0512-67671677"]]];
    [self.view addSubview:callWebView];
}

- (void)SecondtapAction:(UITapGestureRecognizer *)tap
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:0512-67671131"]]];
    [self.view addSubview:callWebView];
}



@end
