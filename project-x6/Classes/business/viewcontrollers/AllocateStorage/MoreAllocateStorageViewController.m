//
//  MoreAllocateStorageViewController.m
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MoreAllocateStorageViewController.h"

#import "MoreAllocateStorageModel.h"
#import "MoreAllocateStorageTableViewCell.h"

#import "AllocateStoryMessageViewController.h"
@interface MoreAllocateStorageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_MoreAllocateStorageGoodsDatalist;
    UITableView *_MoreAllocateStorageGoodsTableView;
    UIView *_totalMoreAllocateStorageGoodsView;
}
@end

@implementation MoreAllocateStorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"详情列表"];
    
    _MoreAllocateStorageGoodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 60) style:UITableViewStylePlain];
    _MoreAllocateStorageGoodsTableView.delegate = self;
    _MoreAllocateStorageGoodsTableView.dataSource = self;
    _MoreAllocateStorageGoodsTableView.backgroundColor = GrayColor;
    _MoreAllocateStorageGoodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _MoreAllocateStorageGoodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_MoreAllocateStorageGoodsTableView];
    
    //统计的分割线
    UIView *totalViewTopLine = [BasicControls drawLineWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, .5)];
    [self.view addSubview:totalViewTopLine];
    
    //统计按钮
    _totalMoreAllocateStorageGoodsView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 123.5, KScreenWidth, 59.5)];
    _totalMoreAllocateStorageGoodsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totalMoreAllocateStorageGoodsView];
    for (int i = 0; i < 5; i++) {
        UILabel *Label = [[UILabel alloc] init];
        Label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            Label.font = MainFont;
        } else {
            Label.font = ExtitleFont;
        }
        if (i == 0) {
            Label.frame = CGRectMake(10, 20, 40, 20);
            Label.text = @"合计";
        } else if (i == 1) {
            Label.frame = CGRectMake(40 + totalWidth, 7, totalWidth, 20);
            Label.text = @"数量";
        } else if (i == 2) {
            Label.frame = CGRectMake(40 + totalWidth, 37, totalWidth, 16);
            Label.textColor = PriceColor;
            Label.tag = 313202;
        } else if (i == 3) {
            Label.text = @"金额";
            Label.frame = CGRectMake(40 + totalWidth * 2, 7, totalWidth, 16);
        } else {
            Label.frame = CGRectMake(40 + totalWidth * 2, 37, totalWidth, 16);
            Label.textColor = PriceColor;
            Label.tag = 313204;
        }
        [_totalMoreAllocateStorageGoodsView addSubview:Label];
    }
    
    [self getMoreAllocateStorageGoodsDataWithDjh:self.djh];
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

- (void)getMoreAllocateStorageGoodsDataWithDjh:(NSString *)djh
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *examOrderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AllocationOfGoods];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.djh forKey:@"djh"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:examOrderURL params:params success:^(id responseObject) {
        [self hideProgress];
        _MoreAllocateStorageGoodsDatalist = [MoreAllocateStorageModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        [_MoreAllocateStorageGoodsTableView reloadData];
        
        float totalNum = 0,totalMoney = 0;
        totalNum = [self leijiaNumDataList:_MoreAllocateStorageGoodsDatalist Code:@"col2"];
        totalMoney = [self leijiaNumDataList:_MoreAllocateStorageGoodsDatalist Code:@"col3"];
        UILabel *label1 = (UILabel *)[_totalMoreAllocateStorageGoodsView viewWithTag:313202];
        UILabel *label2 = (UILabel *)[_totalMoreAllocateStorageGoodsView viewWithTag:313204];
        label1.text = [NSString stringWithFormat:@"%.0f",totalNum];
        label2.text = [NSString stringWithFormat:@"%.2f",totalMoney];
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"数据获取失败");
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _MoreAllocateStorageGoodsDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MoreAllocateStorageTableViewCellid = @"MoreAllocateStorageTableViewCellid";
    MoreAllocateStorageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreAllocateStorageTableViewCellid];
    if (cell == nil) {
        cell = [[MoreAllocateStorageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreAllocateStorageTableViewCellid];
    }
    cell.dic = _MoreAllocateStorageGoodsDatalist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _MoreAllocateStorageGoodsDatalist[indexPath.row];
    AllocateStoryMessageViewController *goodAllocateStorageVC = [[AllocateStoryMessageViewController alloc] init];
    goodAllocateStorageVC.dic = dic;
    [self.navigationController pushViewController:goodAllocateStorageVC animated:YES];
}

@end
