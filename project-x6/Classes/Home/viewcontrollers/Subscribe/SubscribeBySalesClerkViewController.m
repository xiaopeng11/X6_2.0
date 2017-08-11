//
//  SubscribeBySalesClerkViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SubscribeBySalesClerkViewController.h"

#import "SubscribeModel.h"
#import "SubscribeBySaleClerkTableViewCell.h"

#import "ChangePositionLabelView.h"

@interface SubscribeBySalesClerkViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    ChangePositionLabelView *_naviTitleLabel;

    UITableView *_SubscribeBySalesClerkTableView;
    NSMutableArray *_SubscribeBySalesClerkDatalist;
}

@end

@implementation SubscribeBySalesClerkViewController

- (void)dealloc{
    if ([_naviTitleLabel.timer isValid]) {
        [_naviTitleLabel.timer invalidate];
        _naviTitleLabel.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"营业员详情"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SubscribeBySalesClerkChangeData) name:@"changeTodayData" object:nil];
    
    [self drawSubscribeBySalesClerkUI];
    
    [self getSubscribeBySalesClerkData];
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

#pragma mark - 绘制UI
- (void)drawSubscribeBySalesClerkUI
{
    _naviTitleLabel = [[ChangePositionLabelView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _naviTitleLabel.LabelString = self.dateString;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_naviTitleLabel];
    
    _SubscribeBySalesClerkTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _SubscribeBySalesClerkTableView.delegate = self;
    _SubscribeBySalesClerkTableView.dataSource = self;
    _SubscribeBySalesClerkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _SubscribeBySalesClerkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _SubscribeBySalesClerkTableView.allowsSelection = NO;
    [self.view addSubview:_SubscribeBySalesClerkTableView];
}

#pragma mark - 通知事件
- (void)SubscribeBySalesClerkChangeData
{
    [self getSubscribeBySalesClerkData];
}

#pragma mark - 获取数据
- (void)getSubscribeBySalesClerkData
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefalut objectForKey:X6_UseUrl];
    NSString *SubscribeDetailURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_type == 1) {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeDayBySalesClerk];
        [params setObject:_dateString forKey:@"fsrq"];
    } else if (_type == 2) {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeWeekBySalesClerk];
        [params setObject:_dateString forKey:@"wd"];
    } else {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeMonthBySalesClerk];
        [params setObject:_dateString forKey:@"wd"];
    }
    
    [params setObject:_ssgs forKey:@"ssgs"];

    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:SubscribeDetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        NSMutableArray *responseArray = [SubscribeModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        
        NSMutableArray *SubscribeDetaildata = [NSMutableArray arrayWithArray:responseArray];
        //添加类型
        NSMutableDictionary *leixingDic = [NSMutableDictionary dictionary];
        leixingDic[@"col0"] = @"营业员";
        leixingDic[@"col1"] = @"数量";
        leixingDic[@"col2"] = @"金额";
        leixingDic[@"col3"] = @"毛利";
        [SubscribeDetaildata insertObject:leixingDic atIndex:0];
        
        //构建数据
        NSMutableDictionary *datadic = [NSMutableDictionary dictionary];
        datadic[@"data"] = SubscribeDetaildata;
        datadic[@"height"] = [NSValue valueWithCGRect:CGRectMake(0, 0, KScreenWidth, 10 + 45 + SubscribeDetaildata.count * 47.5)];
        datadic[@"ssmd"] = _ssgsString;
        datadic[@"date"] = _dateString;
        
        _SubscribeBySalesClerkDatalist = [NSMutableArray array];
        [_SubscribeBySalesClerkDatalist addObject:datadic];
        
        [_SubscribeBySalesClerkTableView reloadData];
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _SubscribeBySalesClerkDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _SubscribeBySalesClerkDatalist[indexPath.row];
    float height = [dict[@"height"] CGRectValue].size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SubscribeBySalesClerkident = @"SubscribeBySalesClerkident";
    SubscribeBySaleClerkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubscribeBySalesClerkident];
    if (cell == nil) {
        cell = [[SubscribeBySaleClerkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SubscribeBySalesClerkident];
    }
    cell.dic = _SubscribeBySalesClerkDatalist[indexPath.row];
    cell.type = self.type;
    return cell;
}


@end
