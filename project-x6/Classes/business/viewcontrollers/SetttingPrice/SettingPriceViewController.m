//
//  SettingPriceViewController.m
//  project-x6
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingPriceViewController.h"

@interface SettingPriceViewController ()

{
    UILabel *dateLabel;
}
@end

@implementation SettingPriceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"设置考核价"];
    
    [self initSettingPriceUI];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getLastSettingDate];
}

- (void)initSettingPriceUI
{
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 72) / 2.0, 52, 72, 73)];
    headerView.image = [UIImage imageNamed:@"p1_a"];
    [self.view addSubview:headerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 150) / 2.0, 150, 150, 40)];
    label.font = [UIFont systemFontOfSize:17];
    label.text = @"上次设置日期";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 150) / 2.0, 240 + 36 * i, 24, 24)];
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 150) / 2.0 + 40, 240 + 36 * i, 150, 24)];
        dateLabel.font = MainFont;
        dateLabel.tag = 3710 + i;
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"y3_a"];
        } else {
            imageView.image = [UIImage imageNamed:@"y3_b"];
        }
        
        [self.view addSubview:imageView];
        [self.view addSubview:dateLabel];
    }
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(33, 326, KScreenWidth - 66, 45);
    setButton.clipsToBounds = YES;
    setButton.layer.cornerRadius = 4;
    [setButton setBackgroundColor:Mycolor];
    [setButton setTitle:@"一键设置" forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setPrice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
  
}

#pragma mark - 一键设置
- (void)setPrice
{
    
    UIAlertController *sureSetPrice = [UIAlertController alertControllerWithTitle:@"您当前设置的考核价是基于库存均价的考核" message:@"是否继续？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UILabel *label = (UILabel *)[self.view viewWithTag:3710];
        NSString *dateString = [BasicControls TurnTodayDate];
        label.text = dateString;
        
        dateLabel = (UILabel *)[self.view viewWithTag:3711];
        
        NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
        NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
        NSString *setPriceURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_resetPrice];
        [self showProgress];
        [XPHTTPRequestTool requestMothedWithPost:setPriceURL params:nil success:^(id responseObject) {
            [self hideProgress];
            [BasicControls showAlertWithMsg:@"设置成功" addTarget:nil];
            dateLabel.text = @"0天没有设置";
        } failure:^(NSError *error) {
            [self hideProgress];
        }];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [sureSetPrice addAction:sureAction];
    [sureSetPrice addAction:cancleAction];
    [self presentViewController:sureSetPrice animated:YES completion:nil];
 
}

#pragma mark - 获取上一次设置日期
- (void)getLastSettingDate
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *lastsetURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_lastsetPrice];
    [XPHTTPRequestTool requestMothedWithPost:lastsetURL params:nil success:^(id responseObject) {
        NSDictionary *vo = responseObject[@"vo"];
        dateLabel = (UILabel *)[self.view viewWithTag:3710];
        dateLabel.text = [vo valueForKey:@"lastdate"];
        
        dateLabel = (UILabel *)[self.view viewWithTag:3711];
        dateLabel.text = @"0天没有设置";
        dateLabel.text = [NSString stringWithFormat:@"%@天没有设置",[vo valueForKey:@"days"]];
        
    } failure:^(NSError *error) {
        NSLog(@"获取上一次的失败");
    }];
}

@end
