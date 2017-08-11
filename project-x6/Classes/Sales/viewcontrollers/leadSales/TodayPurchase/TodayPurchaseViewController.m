//
//  TodayPurchaseViewController.m
//  project-x6
//
//  Created by Apple on 2016/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayPurchaseViewController.h"

#import "XPDatePicker.h"

#import "TodayPurchaseModel.h"
#import "TodayPurchaseTableViewCell.h"

@interface TodayPurchaseViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    XPDatePicker *_datePicker;

    NoDataView *_notodayPurchaseView;
    UITableView *_todayPurchaseTableView;
    UIView *_totaltodayPurchaseView;
    
    NSMutableArray *_todayPurchaseDatalist;
}

@property(nonatomic,copy)NSMutableArray *companyNames;         //门店名集合
@property(nonatomic,copy)NSMutableArray *newtodayPurchaseDatalist;
@property(nonatomic,strong)NSMutableArray *companysearchNames;
@property(nonatomic,strong)UISearchController *todayPurchaseSearchController;

@end

@implementation TodayPurchaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _companyNames = nil;
    _companysearchNames = nil;
    _todayPurchaseDatalist = nil;
    _newtodayPurchaseDatalist = nil;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"今日采购"];
    
    //导航栏按钮
    [self creatRightNaviButton];
    
    _companyNames = [NSMutableArray array];
    _companysearchNames = [NSMutableArray array];
    _newtodayPurchaseDatalist = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changetodayPurchaseData) name:@"changeTodayData" object:nil];
    
    //绘制UI
    [self inittodayPurchase];
    
    [self gettodayPurchaseData];
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
    [self.todayPurchaseSearchController.searchBar setHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.todayPurchaseSearchController.searchBar setHidden:YES];
    [_todayPurchaseSearchController setActive:NO];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companysearchNames removeAllObjects];
    [_newtodayPurchaseDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.todayPurchaseSearchController.searchBar.text];
    self.companysearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    NSMutableSet *set = [NSMutableSet set];
    for (NSString *title in self.companysearchNames) {
        for (NSDictionary *dic in _todayPurchaseDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col0"]] || [title isEqualToString:[dic valueForKey:@"col1"]]) {
                [set addObject:dic];
            }
        }
    }
    _newtodayPurchaseDatalist = [[set allObjects] mutableCopy];
    [_todayPurchaseTableView reloadData];
    
    if (_newtodayPurchaseDatalist.count != 0) {
        [self jisuanTodayPurchaseTotalDataWithDatalist:_newtodayPurchaseDatalist];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self jisuanTodayPurchaseTotalDataWithDatalist:_todayPurchaseDatalist];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.todayPurchaseSearchController.active) {
        return _newtodayPurchaseDatalist.count;
    } else {
        return _todayPurchaseDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *todayPurchaseCell = @"todayPurchaseCell";
    TodayPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todayPurchaseCell];
    if (cell == nil) {
        cell = [[TodayPurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayPurchaseCell];
    }
    if (self.todayPurchaseSearchController.active) {
        cell.dic = _newtodayPurchaseDatalist[indexPath.row];
    } else {
        cell.dic = _todayPurchaseDatalist[indexPath.row];
    }
    return cell;
}

#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
    
    _datePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:[BasicControls TurnTodayDate]];
    _datePicker.delegate = self;
    _datePicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_datePicker];
}

#pragma mark - 日期选择响应事件
- (void)changetodayPurchaseData
{
    [self gettodayPurchaseData];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_datePicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _datePicker.subView.tag=1;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:_datePicker.subView];
    }
    
    return NO;
}

#pragma mark - 绘制UI
- (void)inittodayPurchase
{
    //搜索框
    _todayPurchaseSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _todayPurchaseSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _todayPurchaseSearchController.searchResultsUpdater = self;
    _todayPurchaseSearchController.searchBar.delegate = self;
    _todayPurchaseSearchController.dimsBackgroundDuringPresentation = NO;
    _todayPurchaseSearchController.hidesNavigationBarDuringPresentation = NO;
    _todayPurchaseSearchController.searchBar.placeholder = @"搜索";
    [_todayPurchaseSearchController.searchBar sizeToFit];
    [self.view addSubview:_todayPurchaseSearchController.searchBar];
    
    _todayPurchaseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 60) style:UITableViewStylePlain];
    _todayPurchaseTableView.delegate = self;
    _todayPurchaseTableView.dataSource = self;
    _todayPurchaseTableView.hidden = YES;
    _todayPurchaseTableView.allowsSelection = NO;
    _todayPurchaseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _todayPurchaseTableView.backgroundColor = GrayColor;
    _todayPurchaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_todayPurchaseTableView];
    
    _notodayPurchaseView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
    _notodayPurchaseView.text = @"没有数据";
    _notodayPurchaseView.hidden = YES;
    [self.view addSubview:_notodayPurchaseView];
    
    _totaltodayPurchaseView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
    _totaltodayPurchaseView.backgroundColor = [UIColor whiteColor];
    _totaltodayPurchaseView.hidden = YES;
    [self.view addSubview:_totaltodayPurchaseView];
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.font = MainFont;
        } else {
            label.font = ExtitleFont;
        }
        if (i == 0) {
            label.frame = CGRectMake(10, 20, 40, 20);
            label.text = @"合计";
        } else if (i == 1) {
            label.frame = CGRectMake(70 + totalWidth, 7, totalWidth, 16);
            label.text = @"数量";
        } else if (i == 2) {
            label.frame = CGRectMake(70 + totalWidth, 37, totalWidth, 16);
            label.tag = 421002;
            label.textColor = PriceColor;
        } else if (i == 3) {
            label.frame = CGRectMake(70 + (totalWidth * 2), 7, totalWidth, 16);
            label.text = @"总金额";
        } else {
            label.frame = CGRectMake(70 + (totalWidth * 2), 37, totalWidth, 16);
            label.textColor = PriceColor;
            label.tag = 421004;
        }
        [_totaltodayPurchaseView addSubview:label];
        
    }
    UIView *totalTodayLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
    [_totaltodayPurchaseView addSubview:totalTodayLineView];

}

#pragma mark - 获取数据
- (void)gettodayPurchaseData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todayPurchaseURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_todayPurchase];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_datePicker.text forKey:@"fsrqq"];
    [params setObject:_datePicker.text forKey:@"fsrqz"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:todayPurchaseURL params:params success:^(id responseObject) {
        [self hideProgress];
        _todayPurchaseDatalist = [TodayPurchaseModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todayPurchaseDatalist.count == 0) {
            _todayPurchaseTableView.hidden = YES;
            _notodayPurchaseView.hidden = NO;
            _totaltodayPurchaseView.hidden = YES;
        } else {
            _notodayPurchaseView.hidden = YES;
            _todayPurchaseTableView.hidden = NO;
            _totaltodayPurchaseView.hidden = NO;
            
            [self jisuanTodayPurchaseTotalDataWithDatalist:_todayPurchaseDatalist];
            
            [_todayPurchaseTableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _todayPurchaseDatalist) {
                    [_companyNames addObject:[dic valueForKey:@"col0"]];
                    [_companyNames addObject:[dic valueForKey:@"col1"]];
                }
            });
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"我的今日采购");
    }];
    
}

#pragma mark - 总计
- (void)jisuanTodayPurchaseTotalDataWithDatalist:(NSMutableArray *)datalist
{
    if (datalist.count != 0) {
        float totalNum = 0,totalMoney = 0;
        totalNum = [self leijiaNumDataList:datalist Code:@"col2"];
        totalMoney = [self leijiaNumDataList:datalist Code:@"col3"];
        UILabel *label1 = (UILabel *)[_totaltodayPurchaseView viewWithTag:421002];
        UILabel *label2 = (UILabel *)[_totaltodayPurchaseView viewWithTag:421004];
        label1.text = [NSString stringWithFormat:@"%.0f",totalNum];
        label2.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    }
}
@end
