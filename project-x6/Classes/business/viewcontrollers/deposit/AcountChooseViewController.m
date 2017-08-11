//
//  AcountChooseViewController.m
//  project-x6
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AcountChooseViewController.h"


#import "StoreModel.h"
#import "AcountChooseTableViewCell.h"

#import "MoneyView.h"
@interface AcountChooseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NoDataView *_noAcountChooseView;
    UITableView *_AcountChooseTableView;
    NSMutableArray *_AcountChoosesdatalist;
    NSMutableArray *_newAcountChoosesdatalist;
    
    NSString *_amountmoney;
    
    NSInteger _selectRow;
}

@property(nonatomic,copy)NSMutableArray *AcountChoosesNames;
@property(nonatomic,strong)NSMutableArray *searchAcountChoosesNames;
@property(nonatomic,strong)UISearchController *AcountChooseSearchViewcontroller;

@end

@implementation AcountChooseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _AcountChoosesNames = nil;
    _searchAcountChoosesNames = nil;
    _AcountChoosesdatalist = nil;
    _newAcountChoosesdatalist = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"账户选择"];
    
    _AcountChoosesNames = [NSMutableArray array];
    _searchAcountChoosesNames = [NSMutableArray array];
    
    [self initWithAcountVC];
    
    [self getAcountChooseDataWithIsAcountChoose];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAcountMoney:) name:@"addMoneyData" object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.AcountChooseSearchViewcontroller.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.AcountChooseSearchViewcontroller.searchBar setHidden:YES];
    [_AcountChooseSearchViewcontroller setActive:NO];
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

- (void)initWithAcountVC
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"确定" target:self action:@selector(sureAcountsNum)];

    //搜索框
    _AcountChooseSearchViewcontroller = [[UISearchController alloc] initWithSearchResultsController:nil];
    _AcountChooseSearchViewcontroller.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _AcountChooseSearchViewcontroller.searchResultsUpdater = self;
    _AcountChooseSearchViewcontroller.searchBar.delegate = self;
    _AcountChooseSearchViewcontroller.dimsBackgroundDuringPresentation = NO;
    _AcountChooseSearchViewcontroller.hidesNavigationBarDuringPresentation = NO;
    _AcountChooseSearchViewcontroller.searchBar.placeholder = @"搜索";
    [_AcountChooseSearchViewcontroller.searchBar sizeToFit];
    _AcountChooseSearchViewcontroller.searchBar.hidden = YES;
    [self.view addSubview:_AcountChooseSearchViewcontroller.searchBar];
    
    _AcountChooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _AcountChooseTableView.delegate = self;
    _AcountChooseTableView.dataSource = self;
    _AcountChooseTableView.hidden = YES;
    _AcountChooseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_AcountChooseTableView];
    
    _noAcountChooseView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _noAcountChooseView.text = @"没有帐户数据";
    _noAcountChooseView.hidden = YES;
    [self.view addSubview:_noAcountChooseView];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_AcountChooseSearchViewcontroller.active) {
        return _newAcountChoosesdatalist.count;
    } else {
        return _AcountChoosesdatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AcountChoosecellID = @"AcountChoosecellID";
    AcountChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AcountChoosecellID];
    if (cell == nil) {
        cell = [[AcountChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AcountChoosecellID];
        
    }
    
    if (_AcountChooseSearchViewcontroller.active) {
        cell.dic = _newAcountChoosesdatalist[indexPath.row];
    } else {
        cell.dic = _AcountChoosesdatalist[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [MoneyView show];

    _selectRow = indexPath.row;
    
}


#pragma mark - 输入金额

- (void)addAcountMoney:(NSNotification *)noti
{
    _amountmoney = noti.object;
    NSDictionary *dic;
    
    if (_AcountChooseSearchViewcontroller.active) {
        dic = _newAcountChoosesdatalist[_selectRow];
    } else {
        dic = _AcountChoosesdatalist[_selectRow];
    }
    for (NSDictionary *diced in _AcountChoosesdatalist) {
        if (dic == diced) {
            [dic setValue:_amountmoney forKey:@"choose"];
        }
    }
    [_AcountChooseTableView reloadData];
    
}





#pragma mark - 导航栏按钮事件
- (void)sureAcountsNum
{
    NSMutableArray *sureAcounts = [NSMutableArray array];
    for (NSDictionary *dic in _AcountChoosesdatalist) {
        if (![[dic valueForKey:@"choose"]  isEqual: @""]) {
            [sureAcounts addObject:dic];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sureAcounts" object:sureAcounts];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchAcountChoosesNames removeAllObjects];
    [_newAcountChoosesdatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.AcountChooseSearchViewcontroller.searchBar.text];
    self.searchAcountChoosesNames = [[self.AcountChoosesNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.searchAcountChoosesNames) {
        for (NSDictionary *dic in _AcountChoosesdatalist) {
            if ([title isEqualToString:[dic valueForKey:@"name"]]) {
                [_newAcountChoosesdatalist addObject:dic];
            }
        }
    }
    
    [_AcountChooseTableView reloadData];
    
}

#pragma mark - 获取数据
- (void)getAcountChooseDataWithIsAcountChoose
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *AcountChooseURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_banksList];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_storeID forKey:@"mdid"];

    [XPHTTPRequestTool requestMothedWithPost:AcountChooseURL params:params success:^(id responseObject) {
        
        _AcountChoosesdatalist = [StoreModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        
        if (_AcountChoosesdatalist.count == 0) {
            _AcountChooseTableView.hidden = YES;
            _AcountChooseSearchViewcontroller.searchBar.hidden = YES;
            _noAcountChooseView.hidden = NO;
        } else {
            _noAcountChooseView.hidden = YES;
            _AcountChooseTableView.hidden = NO;
            _AcountChooseSearchViewcontroller.searchBar.hidden = NO;
            
            NSMutableArray *addmoneyArray = [NSMutableArray array];
            for (int i = 0; i < _AcountChoosesdatalist.count; i++) {
                NSDictionary *dic = _AcountChoosesdatalist[i];
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:dic];
                [diced setObject:@"" forKey:@"choose"];
                [addmoneyArray addObject:diced];
                [_AcountChoosesNames addObject:[dic valueForKey:@"name"]];
                
            }
            _AcountChoosesdatalist = addmoneyArray;
            
            [_AcountChooseTableView reloadData];
        }

        
    } failure:^(NSError *error) {

    }];
}

@end
