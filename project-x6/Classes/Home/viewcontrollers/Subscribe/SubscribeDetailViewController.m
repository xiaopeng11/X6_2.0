//
//  SubscribeDetailViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SubscribeDetailViewController.h"

#import "SubscribeByStoreViewController.h"

#import "SubscribeModel.h"
#import "SubscrbedetailTableViewCell.h"
@interface SubscribeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_SubscribeDetailTabelView;
    NSMutableArray *_SubscribeDetailDatalist;
}

@end

@implementation SubscribeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type == 1) {
        [self naviTitleWhiteColorWithText:@"日报详情"];
    } else if (self.type == 2) {
        [self naviTitleWhiteColorWithText:@"周报详情"];
    } else if (self.type == 3) {
        [self naviTitleWhiteColorWithText:@"月报详情"];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self drawSubscribeDetailUI];
    
    [self getSubscribeDetailData];
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
- (void)drawSubscribeDetailUI
{
    _SubscribeDetailTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _SubscribeDetailTabelView.delegate = self;
    _SubscribeDetailTabelView.dataSource = self;
    _SubscribeDetailTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _SubscribeDetailTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _SubscribeDetailTabelView.allowsSelection = NO;
    [self.view addSubview:_SubscribeDetailTabelView];
}

#pragma mark - 获取数据
- (void)getSubscribeDetailData
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefalut objectForKey:X6_UseUrl];
    NSString *SubscribeDetailURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_type == 1) {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeDayDetail];
        [params setObject:_dateString forKey:@"fsrq"];
    } else if (_type == 2) {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeWeekDetail];
        [params setObject:_dateString forKey:@"wd"];
    } else {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeMonthDetail];
        [params setObject:_dateString forKey:@"wd"];
    }
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:SubscribeDetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        NSMutableArray *responseArray = [SubscribeModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];

        NSMutableArray *SubscribeDetaildata = [NSMutableArray arrayWithArray:responseArray];
        float totalNum = 0,totalMoney = 0,totalProfit = 0;
        for (NSDictionary *dic in responseArray) {
            totalNum += [[dic valueForKey:@"col1"] floatValue];
            totalMoney += [[dic valueForKey:@"col2"] floatValue];
            totalProfit += [[dic valueForKey:@"col3"] floatValue];
        }
        
        //添加类型
        NSMutableDictionary *leixingDic = [NSMutableDictionary dictionary];
        leixingDic[@"col0"] = @"类型";
        leixingDic[@"col1"] = @"数量";
        leixingDic[@"col2"] = @"金额";
        leixingDic[@"col3"] = @"毛利";
        [SubscribeDetaildata insertObject:leixingDic atIndex:0];
        
        //添加总计
        NSMutableDictionary *totalDic = [NSMutableDictionary dictionary];
        totalDic[@"col0"] = @"总计";
        totalDic[@"col1"] = @(totalNum);
        totalDic[@"col2"] = @(totalMoney);
        totalDic[@"col3"] = @(totalProfit);
        [SubscribeDetaildata insertObject:totalDic atIndex:SubscribeDetaildata.count];
        
        //构建数据
        NSMutableDictionary *datadic = [NSMutableDictionary dictionary];
        datadic[@"data"] = SubscribeDetaildata;
        datadic[@"height"] = [NSValue valueWithCGRect:CGRectMake(0, 0, KScreenWidth, 10 + 45 + (SubscribeDetaildata.count + 1) * 47.5)];
        datadic[@"ssmd"] = @"今日战报";
        datadic[@"date"] = _dateString;
        
        _SubscribeDetailDatalist = [NSMutableArray array];
        [_SubscribeDetailDatalist addObject:datadic];

        [_SubscribeDetailTabelView reloadData];
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"周报获取失败");
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _SubscribeDetailDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _SubscribeDetailDatalist[indexPath.row];
    float height = [dict[@"height"] CGRectValue].size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SubscribeDetail = @"SubscribeDetail";
    SubscrbedetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubscribeDetail];
    if (cell == nil) {
        cell = [[SubscrbedetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SubscribeDetail];
    }
    cell.dic = _SubscribeDetailDatalist[indexPath.row];
    cell.type = self.type;
    return cell;
}

@end
