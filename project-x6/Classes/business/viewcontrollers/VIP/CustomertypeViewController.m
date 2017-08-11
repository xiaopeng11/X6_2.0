//
//  CustomertypeViewController.m
//  project-x6
//
//  Created by Apple on 16/9/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CustomertypeViewController.h"
#import "StoresTableViewCell.h"

@interface CustomertypeViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_yonghuleixing;
    UITableView *_supprotTableView;
}

@end

@implementation CustomertypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    [self naviTitleWhiteColorWithText:self.naviTitle];
    
    _supprotTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _supprotTableView.delegate = self;
    _supprotTableView.dataSource = self;
    _supprotTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _supprotTableView.backgroundColor = GrayColor;
    _supprotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_supprotTableView];
    
    if (![_naviTitle isEqualToString:@"性别"]) {
        NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
        NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
        NSString *vipdetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Supplementaryinformation];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.naviTitle forKey:@"fzlx"];
        [XPHTTPRequestTool requestMothedWithPost:vipdetailURL params:params success:^(id responseObject) {
            _yonghuleixing = responseObject[@"rows"];
            [_supprotTableView reloadData];
        } failure:^(NSError *error) {
        }];
    } else {
        NSArray *array = @[@{@"name":@"男"},@{@"name":@"女"}];
        _yonghuleixing = [NSMutableArray arrayWithArray:array];
    }
 
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _yonghuleixing.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *supportIdent = @"supportIdent";
    StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:supportIdent];
    if (cell == nil) {
        cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:supportIdent];
    }
    cell.dic = _yonghuleixing[indexPath.row];
    cell.key = @"name";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_naviTitle isEqualToString:@"会员类型"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"customertypeChange" object:[_yonghuleixing[indexPath.row] valueForKey:@"name"]];
    } else if ([_naviTitle isEqualToString:@"会员年龄段"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ageGroupChange" object:[_yonghuleixing[indexPath.row] valueForKey:@"name"]];
    } else if ([_naviTitle isEqualToString:@"性别"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sexChange" object:[_yonghuleixing[indexPath.row] valueForKey:@"name"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
