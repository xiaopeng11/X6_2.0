//
//  TodayPayViewController.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayPayViewController.h"

#import "TodayPayModel.h"

#import "TodayPayTableViewCell.h"

#import "XPDatePicker.h"
@interface TodayPayViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NoDataView *_notodayPayView;
    UITableView *_todayPayTableView;
    XPDatePicker *_datePicker;
    
    NSString *_dateString;
    NSMutableArray *_todayPayDatalist;
}

@property(nonatomic,copy)NSMutableArray *companyNames;         //门店名集合
@property(nonatomic,copy)NSMutableArray *newtodayPayDatalist;
@property(nonatomic,strong)NSMutableArray *companysearchNames;
@property(nonatomic,strong)UISearchController *todayPaySearchController;


@property(nonatomic,strong)UIView *totalTodayPayView;        //总计

@end

@implementation TodayPayViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _companyNames = nil;
    _companysearchNames = nil;
    _todayPayDatalist = nil;
    _newtodayPayDatalist = nil;
    
}

- (UIView *)totalTodayPayView
{
    if (!_totalTodayPayView) {
        _totalTodayPayView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
        _totalTodayPayView.backgroundColor = [UIColor whiteColor];
        _totalTodayPayView.hidden = YES;
        [self.view addSubview:_totalTodayPayView];
        
        for (int i = 0; i < 3; i++) {
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
                label.frame = CGRectMake(KScreenWidth - totalWidth, 7, totalWidth, 16);
                label.text = @"金额";
            } else {
                label.frame = CGRectMake(KScreenWidth - totalWidth, 37, totalWidth, 16);
                label.textColor = PriceColor;
                label.tag = 4511;
            }
            [_totalTodayPayView addSubview:label];
            
        }
        UIView *totalTodayLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
        [_totalTodayPayView addSubview:totalTodayLineView];
    }
    return _totalTodayPayView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.titletext isEqualToString:X6_todayPay]) {
        [self naviTitleWhiteColorWithText:@"今日付款"];
        if (!_ishow) {
            UIView *noTodayPayview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"今日付款"];
            [self.view addSubview:noTodayPayview];
        } else {
            _dateString = [BasicControls TurnTodayDate];
            
            //导航栏按钮
            [self creatRightNaviButton];
            
            _companyNames = [NSMutableArray array];
            _companysearchNames = [NSMutableArray array];
            _newtodayPayDatalist = [NSMutableArray array];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];
            
            //绘制UI
            [self initTodayPay];
            
            [self gettodayPayDataWithDate:_dateString LastURL:self.titletext];
        }
    } else {
        [self naviTitleWhiteColorWithText:@"今日收款"];
        
        if (!_ishow) {
            UIView *noTodayPayview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"今日付款"];
            [self.view addSubview:noTodayPayview];
        } else {
            _dateString = [BasicControls TurnTodayDate];
            
            //导航栏按钮
            [self creatRightNaviButton];
            
            _companyNames = [NSMutableArray array];
            _companysearchNames = [NSMutableArray array];
            _newtodayPayDatalist = [NSMutableArray array];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];
            
            //绘制UI
            [self initTodayPay];
            
            [self gettodayPayDataWithDate:_dateString LastURL:self.titletext];
        }

    }
    


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
    [self.todayPaySearchController.searchBar setHidden:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.todayPaySearchController.searchBar setHidden:YES];
    [_todayPaySearchController setActive:NO];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companysearchNames removeAllObjects];
    [_newtodayPayDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.todayPaySearchController.searchBar.text];
    self.companysearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.companysearchNames) {
        for (NSDictionary *dic in _todayPayDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col2"]]) {
                [_newtodayPayDatalist addObject:dic];
            }
        }
    }
    
    [_todayPayTableView reloadData];
    
    if (_newtodayPayDatalist.count != 0) {
        double totalMoney = 0;
        totalMoney = [self leijiaNumDataList:_newtodayPayDatalist Code:@"col3"];
        UILabel *label = (UILabel *)[_totalTodayPayView viewWithTag:4511];
        label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    double totalMoney = 0;
    totalMoney = [self leijiaNumDataList:_todayPayDatalist Code:@"col3"];
    UILabel *label = (UILabel *)[_totalTodayPayView viewWithTag:4511];
    label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.todayPaySearchController.active) {
        return _newtodayPayDatalist.count;
    } else {
        return _todayPayDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *todayPayCell = @"todayPayCell";
    TodayPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todayPayCell];
    if (cell == nil) {
        cell = [[TodayPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayPayCell];
    }
    if (self.todayPaySearchController.active) {
        cell.dic = _newtodayPayDatalist[indexPath.row];
    } else {
        cell.dic = _todayPayDatalist[indexPath.row];
    }
    cell.source = self.titletext;
    return cell;
}

#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
    _datePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:_dateString];
    _datePicker.delegate = self;
    _datePicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_datePicker];
}

#pragma mark - 日期选择响应事件
- (void)changeData
{
    [self gettodayPayDataWithDate:_datePicker.text LastURL:self.titletext];
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
- (void)initTodayPay
{
    //搜索框
    _todayPaySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _todayPaySearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _todayPaySearchController.searchResultsUpdater = self;
    _todayPaySearchController.searchBar.delegate = self;
    _todayPaySearchController.dimsBackgroundDuringPresentation = NO;
    _todayPaySearchController.hidesNavigationBarDuringPresentation = NO;
    _todayPaySearchController.searchBar.placeholder = @"搜索";
    [_todayPaySearchController.searchBar sizeToFit];
    [self.view addSubview:_todayPaySearchController.searchBar];
    
    _todayPayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 60) style:UITableViewStylePlain];
    _todayPayTableView.delegate = self;
    _todayPayTableView.dataSource = self;
    _todayPayTableView.hidden = YES;
    _todayPayTableView.allowsSelection = NO;
    _todayPayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _todayPayTableView.backgroundColor = GrayColor;
    _todayPayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_todayPayTableView];
    
    _notodayPayView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
    if ([self.titletext isEqualToString:X6_todayPay]) {
        _notodayPayView.text = @"您今日没有付款";
    } else {
        _notodayPayView.text = @"您今日没有收款";
    }
    _notodayPayView.hidden = YES;
    [self.view addSubview:_notodayPayView];
}

#pragma mark - 获取数据
- (void)gettodayPayDataWithDate:(NSString *)date
                        LastURL:(NSString *)lastURL
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todayPayURL = [NSString stringWithFormat:@"%@%@",baseURL,lastURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:todayPayURL params:params success:^(id responseObject) {
        [self hideProgress];
        _todayPayDatalist = [TodayPayModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todayPayDatalist.count == 0) {
            _todayPayTableView.hidden = YES;
            _notodayPayView.hidden = NO;
            if (_totalTodayPayView) {
                _totalTodayPayView.hidden = YES;
            }
        } else {
            _notodayPayView.hidden = YES;
            _todayPayTableView.hidden = NO;
            [self totalTodayPayView];
            _totalTodayPayView.hidden = NO;
            double totalMoney = 0;
            totalMoney = [self leijiaNumDataList:_todayPayDatalist Code:@"col3"];
            UILabel *label = (UILabel *)[_totalTodayPayView viewWithTag:4511];
            label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];

            NSArray *sorttodaypayArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col3" ascending:NO]];
            [_todayPayDatalist sortUsingDescriptors:sorttodaypayArray];
            
            [_todayPayTableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _todayPayDatalist) {
                    [_companyNames addObject:[dic valueForKey:@"col2"]];
                }
            });
        }

    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"我的今日付款为空");
    }];
    
}

@end
