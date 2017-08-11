//
//  FirstViewController.m
//  project-x6
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FirstViewController.h"
#import "LoadViewController.h"
#import "HelpViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2.0, 144, 200, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"请选择您的身份";
    [bgView addSubview:label];
    
    NSArray *chioce = @[@"我是管理员",@"我是营业员"];
    NSArray *images = @[@"gly_1",@"yyu_1"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(69 + (((KScreenWidth - 205) / 2.0) + 67) * i, label.bottom + 60, (KScreenWidth - 205) / 2.0, ((KScreenWidth - 205) / 2.0) * 204 / 170);
        button.tag = 11110 + i;
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 25;
        [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.left - 20, button.bottom + 18, ((KScreenWidth - 205) / 2.0) + 40, 30)];
        textLabel.font = MainFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = chioce[i];
        [button addSubview:textLabel];
        [bgView addSubview:button];
        [bgView addSubview:textLabel];
    }
    
    UIButton *userHelp = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50, KScreenWidth, 25)];
    [userHelp setTitle:@"使用宝典" forState:UIControlStateNormal];
    userHelp.titleLabel.font = MainFont;
    [userHelp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [userHelp addTarget:self action:@selector(userhelp) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:userHelp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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

- (void)buttonAciton:(UIButton *)button
{
    LoadViewController *loadVC = [[LoadViewController alloc] init];
    if (button.tag == 11110) {
        loadVC.isLeader = YES;
    } else {
        loadVC.isLeader = NO;
    }
    [self presentViewController:loadVC animated:YES completion:nil];
}
- (void)userhelp
{
    HelpViewController *helpVC = [[HelpViewController alloc] init];
    helpVC.ispresent = YES;
    [self presentViewController:helpVC animated:YES completion:nil];
}

@end
