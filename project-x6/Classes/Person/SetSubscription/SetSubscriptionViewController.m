//
//  SetSubscriptionViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SetSubscriptionViewController.h"
#import "TimeGroupChooseViewController.h"
#import "JPUSHService.h"

#import "SetSubscripModel.h"
#import "SetSubscriptionTableViewCell.h"
@interface SetSubscriptionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_SetSubscriptionTableView;
    NSMutableArray *_SetSubscriptionArray;
    
    NSMutableDictionary *_JPushSubscriTag;
}

@end

@implementation SetSubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"设置订阅"];
    
    _SetSubscriptionArray = [NSMutableArray arrayWithArray:@[@{@"title":@"日报订阅",@"timegroup":@"选择时间",@"timeselect":@""},
                                                             @{@"title":@"周报订阅",@"timegroup":@"选择时间",@"timeselect":@""},
                                                             @{@"title":@"月报订阅",@"timegroup":@"选择时间",@"timeselect":@""}]];
    
    [self drawSetSubscriptionUI];
    
    [self hadSetSubscriptionDateORnot];

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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _SetSubscriptionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SetSubscriptionident = @"SetSubscriptionident";
    SetSubscriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SetSubscriptionident];
    if (cell == nil) {
        cell = [[SetSubscriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SetSubscriptionident];
    }
    cell.dic = _SetSubscriptionArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TimeGroupChooseViewController *timeGroupVC = [[TimeGroupChooseViewController alloc] init];
    timeGroupVC.timeChooseType = indexPath.row;
    timeGroupVC.timeSelect = [_SetSubscriptionArray[indexPath.row] valueForKey:@"timegroup"];
    timeGroupVC.JPushTag = _JPushSubscriTag;
    [self.navigationController pushViewController:timeGroupVC animated:YES];
}

#pragma mark - 绘制设置订阅UI
- (void)drawSetSubscriptionUI
{
    _SetSubscriptionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight - 10 - 64) style:UITableViewStylePlain];
    _SetSubscriptionTableView.backgroundColor = GrayColor;
    _SetSubscriptionTableView.delegate = self;
    _SetSubscriptionTableView.dataSource = self;
    _SetSubscriptionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _SetSubscriptionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_SetSubscriptionTableView];
}

#pragma mark - 获取数据
//获取订阅列表
- (void)hadSetSubscriptionDateORnot
{
    _JPushSubscriTag = [NSMutableDictionary dictionary];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *SubscriptionstateURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Subscriptionstatelist];
    [XPHTTPRequestTool requestMothedWithPost:SubscriptionstateURL params:nil success:^(id responseObject) {
        NSMutableArray *rbArray = [SetSubscripModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        for (NSDictionary *dic in rbArray) {
            if ([[dic valueForKey:@"col0"] isEqualToString:@"xsrb"]) {
                //添加到数组
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:_SetSubscriptionArray[0]];
                NSString *subtime = [NSString stringWithFormat:@"%d:00",[[dic valueForKey:@"col1"] intValue]];
                [diced setObject:subtime forKey:@"timegroup"];
                [diced setObject:subtime forKey:@"timeselect"];
                
                [_SetSubscriptionArray replaceObjectAtIndex:0 withObject:diced];
                
                //添加到tag值数组
                NSString *sxrbTag = [NSString stringWithFormat:@"XSRB_%@",[dic valueForKey:@"col1"]];
                _JPushSubscriTag[@"xsrb"] = sxrbTag;
            } else if ([[dic valueForKey:@"col0"] isEqualToString:@"xszb"]) {
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:_SetSubscriptionArray[1]];
                NSArray *weekArray = [[dic valueForKey:@"col1"] componentsSeparatedByString:@","];
                
                NSString *weekStr = [BasicControls turnNumToChineseWithWeek:weekArray[0]];
                NSString *timeStr = [NSString stringWithFormat:@"%d:00",[weekArray[1] intValue]];
                
                NSString *weeksubtime = [NSString stringWithFormat:@"%@_%@",weekStr,timeStr];
                [diced setObject:weeksubtime forKey:@"timegroup"];
                NSString *weekselecttime = [NSString stringWithFormat:@"%@ %@",weekStr,timeStr];
                [diced setObject:weekselecttime forKey:@"timeselect"];
                
                [_SetSubscriptionArray replaceObjectAtIndex:1 withObject:diced];
                
                NSString *sxzbTag = [NSString stringWithFormat:@"XSZB_%@_%@",weekArray[0],weekArray[1]];
                _JPushSubscriTag[@"xszb"] = sxzbTag;
            } else if ([[dic valueForKey:@"col0"] isEqualToString:@"xsyb"]) {
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:_SetSubscriptionArray[2]];
                
                NSArray *monthArray = [[dic valueForKey:@"col1"] componentsSeparatedByString:@","];
                
                NSString *timeStr = [NSString stringWithFormat:@"%d:00",[monthArray[1] intValue]];
                
                NSString *monthsubtime = [NSString stringWithFormat:@"%@日_%@",monthArray[0],timeStr];
                [diced setObject:monthsubtime forKey:@"timegroup"];
                NSString *monthselecttime = [NSString stringWithFormat:@"%@日 %@",monthArray[0],timeStr];
                [diced setObject:monthselecttime forKey:@"timeselect"];
                
                [_SetSubscriptionArray replaceObjectAtIndex:2 withObject:diced];
                
                NSString *sxybTag = [NSString stringWithFormat:@"XSYB_%@_%@",monthArray[0],monthArray[1]];
                _JPushSubscriTag[@"xsyb"] = sxybTag;
            }
        }
        
        [_SetSubscriptionTableView reloadData];

    } failure:^(NSError *error) {
        
    }];
}


@end
