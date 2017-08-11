//
//  BusinessSCViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BusinessSCViewController.h"
#import "BusinessSCDetailViewController.h"
#import "BusinessSCTableViewCell.h"
@interface BusinessSCViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_BusinessSCTabelView;
    NoDataView *_noBusinessSCView;
}
@end

@implementation BusinessSCViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"待确认的日期"];
    
    [self drawgetBusinessSCUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBusinessSC:) name:@"sureBusinessSCViewDate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BusinessSCMoneyDefault:) name:@"BusinessSCViewDateMoneyDefault" object:nil];

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



#pragma mark - 刷新页面
- (void)refreshBusinessSCUI
{
    if (_datalist.count == 0) {
        _BusinessSCTabelView.hidden = YES;
        _noBusinessSCView.hidden = NO;
    } else {
        //排序
        NSArray *BusinessSCsort = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col0" ascending:NO]];
        [_datalist sortUsingDescriptors:BusinessSCsort];
        //替换
        for (int i = 0; i < _datalist.count; i++) {
            NSMutableDictionary *mutdic = [NSMutableDictionary dictionaryWithDictionary:_datalist[i]];
            if ([[mutdic valueForKey:@"col0"] isEqualToString:[BasicControls TurnTodayDate]]) {
                mutdic[@"col0"] = @"今天";
            }
            [_datalist replaceObjectAtIndex:i withObject:mutdic];
        }
        _noBusinessSCView.hidden = YES;
        _BusinessSCTabelView.hidden = NO;
        [_BusinessSCTabelView reloadData];
    }
}

#pragma mark - 通知事件
- (void)deleteBusinessSC:(NSNotification *)noti
{
    for (NSDictionary *dic in _datalist) {
        if ([[dic valueForKey:@"col0"] isEqualToString:noti.object]) {
            [_datalist removeObject:dic];
            break;
        }
    }
    [self refreshBusinessSCUI];
}

- (void)BusinessSCMoneyDefault:(NSNotification *)noti
{
    for (int i = 0; i < _datalist.count; i++) {
        NSMutableDictionary *mutdic = [NSMutableDictionary dictionaryWithDictionary:_datalist[i]];
        if ([[mutdic valueForKey:@"col0"] isEqualToString:noti.object]) {
            mutdic[@"col1"] = @(2);
            [_datalist replaceObjectAtIndex:i withObject:mutdic];
            break;
        }
    }
    [self refreshBusinessSCUI];
}

#pragma mark - 绘制UI
- (void)drawgetBusinessSCUI
{
    _BusinessSCTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight - 64 - 10) style:UITableViewStylePlain];
    _BusinessSCTabelView.dataSource = self;
    _BusinessSCTabelView.delegate = self;
    _BusinessSCTabelView.hidden = YES;
    _BusinessSCTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _BusinessSCTabelView.backgroundColor = GrayColor;
    _BusinessSCTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_BusinessSCTabelView];
    
    _noBusinessSCView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _noBusinessSCView.text = @"您的营业款已全部确认了！";
    _noBusinessSCView.hidden = YES;
    [self.view addSubview:_noBusinessSCView];
    
    [self refreshBusinessSCUI];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BusinessSCString = @"BusinessSCString";
    BusinessSCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BusinessSCString];
    if (cell == nil) {
        cell = [[BusinessSCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BusinessSCString];
    }
    cell.dic = _datalist[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BusinessSCDetailViewController *BusinessSCDetailVC = [[BusinessSCDetailViewController alloc] init];
    BusinessSCDetailVC.dateString = [_datalist[indexPath.row] valueForKey:@"col0"];
    [self.navigationController pushViewController:BusinessSCDetailVC animated:YES];
}

@end
