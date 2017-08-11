//
//  SettingsViewController.m
//  project-x6
//
//  Created by Apple on 16/8/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingsViewController.h"

#import "FingerLinkAcountViewController.h"
#import "HelpViewController.h"
#import "AdviceViewController.h"
#import "AboutViewController.h"
@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSArray *_settingDatalist;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.backgroundColor = GrayColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    for (int i = 0; i < 3; i++) {
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + i * 45, KScreenWidth, .5)];
        [tableView addSubview:lineView];
    }
    
    _settingDatalist = @[@"快捷登陆账号绑定",@"帮助",@"意见反馈",@"关于"];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingident = @"settingident";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingident];
    }
    cell.text = _settingDatalist[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        FingerLinkAcountViewController *fingerLinkAcountVC = [[FingerLinkAcountViewController alloc] init];
        [self.navigationController pushViewController:fingerLinkAcountVC animated:YES];
    } else if (indexPath.row == 1) {
        HelpViewController *helpVC = [[HelpViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    } else if (indexPath.row == 2) {
        AdviceViewController *adviceVC = [[AdviceViewController alloc] init];
        [self.navigationController pushViewController:adviceVC animated:YES];
    } else if (indexPath.row == 3) {
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

@end
