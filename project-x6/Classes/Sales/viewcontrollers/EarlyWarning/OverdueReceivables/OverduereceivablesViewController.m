//
//  OverduereceivablesViewController.m
//  project-x6
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OverduereceivablesViewController.h"

#import "NoDataView.h"
#import "OverdueReivableModel.h"
#import "OverdueTableViewCell.h"
@interface OverduereceivablesViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>

{
    NSMutableArray *_OverduereceivablesDatalist;                                //应收款逾期数据
}
@property(nonatomic,strong)UITableView *OverduereceivablesTableView;            //应收款逾期试图
@property(nonatomic,strong)NoDataView *noOverduereceivablesView;                //没有应收款逾期
@property(nonatomic,strong)UIView *totalOverduereceivablesView;                 //当日应收款总计


@property(nonatomic,copy)NSMutableArray *customers;                             //客户集合
@property(nonatomic,strong)NSMutableArray *NewOverduereceivablesDatalist;       //搜索的数据
@property(nonatomic,strong)NSMutableArray *searchcustomers;                     //搜索客户名称
@property(nonatomic,strong)UISearchController *OverduereceivablesSearchController; //搜索


@end

@implementation OverduereceivablesViewController


- (UITableView *)OverduereceivablesTableView
{
    if (!_OverduereceivablesTableView)
    {
        _OverduereceivablesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 60) style:UITableViewStylePlain];
        _OverduereceivablesTableView.dataSource = self;
        _OverduereceivablesTableView.delegate = self;
        _OverduereceivablesTableView.allowsSelection = NO;
        _OverduereceivablesTableView.hidden = YES;
        _OverduereceivablesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _OverduereceivablesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _OverduereceivablesTableView.backgroundColor = GrayColor;
        [self.view addSubview:_OverduereceivablesTableView];
    }
    return _OverduereceivablesTableView;
}

- (NoDataView *)noOverduereceivablesView
{
    if (!_noOverduereceivablesView) {
        _noOverduereceivablesView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
        _noOverduereceivablesView.text = @"没有应收逾期";
        _noOverduereceivablesView.hidden = YES;
        [self.view addSubview:_noOverduereceivablesView];
    }
    return _noOverduereceivablesView;
}

- (UIView *)totalOverduereceivablesView
{
    if (!_totalOverduereceivablesView) {
        _totalOverduereceivablesView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
        _totalOverduereceivablesView.backgroundColor = [UIColor whiteColor];
        _totalOverduereceivablesView.hidden = YES;
        [self.view addSubview:_totalOverduereceivablesView];
        
        for (int i = 0; i < 3; i++)
        {
            UILabel *Label = [[UILabel alloc] init];
            Label.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                Label.font = MainFont;
            } else {
                Label.font = ExtitleFont;
            }
            if (i == 0) {
                Label.text = @"合计";
                Label.frame = CGRectMake(10, 20, 40, 20);
            } else if (i == 1) {
                Label.frame = CGRectMake(60 + totalWidth * 2, 7, totalWidth, 16);
                Label.text = @"总金额";
            } else if (i == 2) {
                Label.frame = CGRectMake(60 + totalWidth * 2, 37, totalWidth, 16);
                Label.textColor = PriceColor;
                Label.tag = 48611;
            }
            [_totalOverduereceivablesView addSubview:Label];
        }
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
        [_totalOverduereceivablesView addSubview:lineView];
    }
    return _totalOverduereceivablesView;
}


- (void)dealloc
{
    _customers = nil;
    _searchcustomers = nil;
    
    _OverduereceivablesDatalist = nil;
    _NewOverduereceivablesDatalist = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"应收逾期"];
    
    if (!_ishow) {
        UIView *noPurchaseview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"应收逾期"];
        [self.view addSubview:noPurchaseview];
    } else {
        [self intOverduereceivableUI];
        [self getOverdueData];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.OverduereceivablesSearchController.searchBar setHidden:NO];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.OverduereceivablesSearchController.searchBar setHidden:YES];
    [_OverduereceivablesSearchController setActive:NO];
    
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
- (void)intOverduereceivableUI
{
    
    _customers = [NSMutableArray array];
    _searchcustomers = [NSMutableArray array];
    
    _OverduereceivablesDatalist = [NSMutableArray array];
    _NewOverduereceivablesDatalist = [NSMutableArray array];
    //搜索框
    _OverduereceivablesSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _OverduereceivablesSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _OverduereceivablesSearchController.searchResultsUpdater = self;
    _OverduereceivablesSearchController.searchBar.delegate = self;
    _OverduereceivablesSearchController.dimsBackgroundDuringPresentation = NO;
    _OverduereceivablesSearchController.hidesNavigationBarDuringPresentation = NO;
    _OverduereceivablesSearchController.searchBar.placeholder = @"搜索";
    [_OverduereceivablesSearchController.searchBar sizeToFit];
    [self.view addSubview:_OverduereceivablesSearchController.searchBar];
    
    
    [self OverduereceivablesTableView];
    
    [self noOverduereceivablesView];
    
    [self totalOverduereceivablesView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_OverduereceivablesSearchController.active) {
        return _NewOverduereceivablesDatalist.count;
    } else {
        return _OverduereceivablesDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 161;
}

#pragma makr - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *overdueCell = @"overdueCELL";
    OverdueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:overdueCell];
    if (cell == nil) {
        cell = [[OverdueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:overdueCell];
        
    }
    if (_OverduereceivablesSearchController.active) {
        cell.dic = _NewOverduereceivablesDatalist[indexPath.row];
    } else {
        cell.dic = _OverduereceivablesDatalist[indexPath.row];
    }
    return cell;
}

#pragma mark - 获取应收款逾期数据
- (void)getOverdueData
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaults stringForKey:X6_UseUrl];
    NSString *overdueURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_OverdueRecieved];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:overdueURL params:nil success:^(id responseObject) {
        [self hideProgress];
        _OverduereceivablesDatalist = [OverdueReivableModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_OverduereceivablesDatalist.count == 0) {
            _OverduereceivablesTableView.hidden = YES;
            _noOverduereceivablesView.hidden = NO;
            _totalOverduereceivablesView.hidden = YES;
        } else {
            _noOverduereceivablesView.hidden = YES;
            _OverduereceivablesTableView.hidden = NO;
            _totalOverduereceivablesView.hidden = NO;
            
            float totalMoney = 0;
            for (NSDictionary *dic in _OverduereceivablesDatalist) {
                totalMoney += [[dic valueForKey:@"col5"] floatValue];
            }
            UILabel *label = (UILabel *)[_totalOverduereceivablesView viewWithTag:48611];
            label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];

            
            NSArray *arrayDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"col6" ascending:NO], nil];
            [_OverduereceivablesDatalist sortUsingDescriptors:arrayDescriptors];
            [_OverduereceivablesTableView reloadData];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [_customers removeAllObjects];
                for (NSDictionary *dic in _OverduereceivablesDatalist) {
                    [_customers addObject:[dic valueForKey:@"col4"]];
                }
            });
            
        }
    } failure:^(NSError *error) {
        NSLog(@"获取应收逾期失败");
        [self hideProgress];

    }];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchcustomers removeAllObjects];
    [self.NewOverduereceivablesDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.OverduereceivablesSearchController.searchBar.text];
    self.searchcustomers = [[self.customers filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    NSMutableSet *set = [NSMutableSet set];
    for (NSString *title in self.searchcustomers) {
        for (NSDictionary *dic in _OverduereceivablesDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col4"]]) {
                [set addObject:dic];
            }
        }
    }
    _NewOverduereceivablesDatalist = [[set allObjects] mutableCopy];
    [_OverduereceivablesTableView reloadData];
    
    if (_NewOverduereceivablesDatalist.count != 0) {
        float totalMoney = 0;
        for (NSDictionary *dic in _NewOverduereceivablesDatalist) {
            totalMoney += [[dic valueForKey:@"col5"] floatValue];
        }
        UILabel *label = (UILabel *)[_totalOverduereceivablesView viewWithTag:48611];
        label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    float totalMoney = 0;
    for (NSDictionary *dic in _OverduereceivablesDatalist) {
        totalMoney += [[dic valueForKey:@"col5"] floatValue];
    }
    UILabel *label = (UILabel *)[_totalOverduereceivablesView viewWithTag:48611];
    label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
}



@end
