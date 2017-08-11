//
//  LotBankAccountViewController.m
//  project-x6
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LotBankAccountViewController.h"
#import "XPDatePicker.h"

#import "LotBankAccountDetailViewController.h"

#import "LotBankAccountModel.h"
#import "LotBankAccountTableViewCell.h"
@interface LotBankAccountViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITextFieldDelegate>

{
    //时间选择
    XPDatePicker *_FirstDatePicker;
    XPDatePicker *_SecondDatePicker;
    
    //UI
    NoDataView *_NoLotBankAccountdataView;
    UITableView *_LotBankAccounttableView;
    UIView *_totalLotBankAccountViews;       //总计
    
    //数据
    NSMutableArray *_LotBankAccountDatalist;
    NSMutableArray *_NewLotBankAccountDatalist;
    
    //顶部按钮背景，下划线，值
    UIView *_topBgView;
    UIView *_topLineView;
    long _topIndex;
    
    //查询背景
    UIView *_headerView;

    //底部按钮背景，下划线，值
    UIView *_bottomBgView;
    UIView *_BottomLineView;
    long _bottomIndex;
    
}

@property(nonatomic,copy)NSMutableArray *KeyNames;
@property(nonatomic,strong)NSMutableArray *searchKeyNames;
@property(nonatomic, strong)UISearchController *LotBankAccountSearchController;


@end

@implementation LotBankAccountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_LotBankAccountSearchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _LotBankAccountSearchController.searchBar.hidden = YES;
    [_LotBankAccountSearchController setActive:NO];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshLotBankAccountData" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"银行到账"];
    
    if (!_isshow) {
        UIView *noLotBankAccountview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"批量银行到账"];
        [self.view addSubview:noLotBankAccountview];
    } else {
        _KeyNames = [NSMutableArray array];
        _searchKeyNames = [NSMutableArray array];
        _NewLotBankAccountDatalist = [NSMutableArray array];
        _LotBankAccountDatalist = [NSMutableArray array];
        
        [self drawLotBankAccountUI];
        
        [self getLotBankAccountData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLotBankAccountData) name:@"refreshLotBankAccountData" object:nil];
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

#pragma mark - 绘制UI
- (void)drawLotBankAccountUI
{
    //顶部按钮
    {
        _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _topBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topBgView];
        
        NSArray *toptitles = @[@"全部",@"刷卡消费",@"人工打款"];
        for (int i  = 0; i < toptitles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((((KScreenWidth - 1) / 3) * i), 0, (KScreenWidth - 1) / 3, 38);
            button.titleLabel.font = MainFont;
            [button setTitle:toptitles[i] forState:UIControlStateNormal];
            if (i == _topIndex) {
                [button setTitleColor:Mycolor forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = 324100 + i;
            [button addTarget:self action:@selector(LotBankAccountTopButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topBgView addSubview:button];
            
            if (i < toptitles.count - 1) {
                UIView *topVerticalSplitLine = [BasicControls drawLineWithFrame:CGRectMake(((KScreenWidth - 1) / 3) + (((KScreenWidth - 1) / 3) + .5) * i, 0, .5, 40)];
                [_topBgView addSubview:topVerticalSplitLine];
            }

        }
        
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 240) / 6.0, 38, 80, 2)];
        _topLineView.backgroundColor = Mycolor;
        [_topBgView addSubview:_topLineView];
        
        UIView *topHorizontalSplitLine = [BasicControls drawLineWithFrame:CGRectMake(0, 39.5, KScreenWidth, .5)];
        [_topBgView addSubview:topHorizontalSplitLine];
    }
    
    //按日期查询
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 40)];
        _headerView.backgroundColor = GrayColor;
        _headerView.userInteractionEnabled = YES;
        _headerView.hidden = YES;
        [self.view addSubview:_headerView];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
        dateLabel.text = @"日期:";
        dateLabel.font = MainFont;
        [_headerView addSubview:dateLabel];
        
        //获取当前的年月
        NSString *todayString = [BasicControls TurnTodayDate];
        //当前月份的第一天
        NSMutableString *monthFirstString = [NSMutableString stringWithString:todayString];
        [monthFirstString replaceCharactersInRange:NSMakeRange(todayString.length - 2, 2) withString:@"01"];
        monthFirstString = [monthFirstString mutableCopy];
        
        _FirstDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(50, 5, 90, 30) Date:monthFirstString];
        _FirstDatePicker.delegate = self;
        _FirstDatePicker.font = ExtitleFont;
        _FirstDatePicker.backgroundColor = [UIColor whiteColor];
        _FirstDatePicker.textColor = [UIColor blackColor];
        _FirstDatePicker.labelString = @"  起始日期:";
        [_headerView addSubview:_FirstDatePicker];
        
        UILabel *leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(148, 5, 20, 30)];
        leadLabel.text = @"至";
        leadLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:leadLabel];
        
        _SecondDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(168 + 8, 5, 90, 30) Date:todayString];
        _SecondDatePicker.delegate = self;
        _SecondDatePicker.font = ExtitleFont;
        _SecondDatePicker.backgroundColor = [UIColor whiteColor];
        _SecondDatePicker.textColor = [UIColor blackColor];
        _SecondDatePicker.labelString = @"  结束日期:";
        [_headerView addSubview:_SecondDatePicker];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(268 + 8, 6, KScreenWidth - 268 - 16, 28);
        button.backgroundColor = Mycolor;
        button.layer.cornerRadius = 4;
        [button setTitle:@"查询" forState:UIControlStateNormal];
        button.titleLabel.font = ExtitleFont;
        [button addTarget:self action:@selector(LotBankAccountDateSearch) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:button];
        
    }
    
    
    //搜索框
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, 44)];
        [self.view addSubview:view];
        _LotBankAccountSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _LotBankAccountSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
        _LotBankAccountSearchController.searchResultsUpdater = self;
        _LotBankAccountSearchController.searchBar.delegate = self;
        _LotBankAccountSearchController.dimsBackgroundDuringPresentation = NO;
        _LotBankAccountSearchController.hidesNavigationBarDuringPresentation = NO;
        _LotBankAccountSearchController.searchBar.placeholder = @"搜索";
        [_LotBankAccountSearchController.searchBar sizeToFit];
        _LotBankAccountSearchController.searchBar.hidden = YES;
        [view addSubview:_LotBankAccountSearchController.searchBar];
    }

    //主体UI
    {
        _LotBankAccounttableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 124, KScreenWidth, KScreenHeight - 64 - 124 - 100) style:UITableViewStylePlain];
        _LotBankAccounttableView.dataSource = self;
        _LotBankAccounttableView.delegate = self;
        _LotBankAccounttableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _LotBankAccounttableView.backgroundColor = GrayColor;
        _LotBankAccounttableView.hidden = YES;
        _LotBankAccounttableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_LotBankAccounttableView];
        
        _NoLotBankAccountdataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 40, KScreenHeight, KScreenHeight - 64 - 40 - 100)];
        _NoLotBankAccountdataView.text = @"没有数据";
        _NoLotBankAccountdataView.hidden = YES;
        [self.view addSubview:_NoLotBankAccountdataView];
    }
    
    //底部按钮
    {
        _bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 164, KScreenWidth, 40)];
        _bottomBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomBgView];
        
        NSArray *bottomtitles = @[@"全部",@"已结",@"未结"];
        for (int i  = 0; i < bottomtitles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((((KScreenWidth - 1) / 3) * i), 0, (KScreenWidth - 1) / 3, 38);
            button.titleLabel.font = MainFont;
            [button setTitle:bottomtitles[i] forState:UIControlStateNormal];
            if (i == _topIndex) {
                [button setTitleColor:Mycolor forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = 324110 + i;
            [button addTarget:self action:@selector(LotBankAccountBottomButton:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomBgView addSubview:button];
            
            if (i < bottomtitles.count - 1) {
                UIView *topVerticalSplitLine = [BasicControls drawLineWithFrame:CGRectMake(((KScreenWidth - 1) / 3) + (((KScreenWidth - 1) / 3) + .5) * i, 0, .5, 40)];
                [_bottomBgView addSubview:topVerticalSplitLine];
            }
            
        }
        
        _BottomLineView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 240) / 6.0, 38, 80, 2)];
        _BottomLineView.backgroundColor = Mycolor;
        [_bottomBgView addSubview:_BottomLineView];
        
        UIView *topHorizontalSplitLine = [BasicControls drawLineWithFrame:CGRectMake(0, 39.5, KScreenWidth, .5)];
        [_bottomBgView addSubview:topHorizontalSplitLine];
    }
    
    //统计
    {
        _totalLotBankAccountViews = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
        _totalLotBankAccountViews.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_totalLotBankAccountViews];
        
        UIView *totalHorizontalSplitLine = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
        [_bottomBgView addSubview:totalHorizontalSplitLine];
        
        for (int i = 0; i < 5; i++) {
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
                Label.frame = CGRectMake(60 + totalWidth, 7, totalWidth, 16);
                Label.text = @"应到账金额";
            } else if (i == 2) {
                Label.frame = CGRectMake(60 + totalWidth, 37, totalWidth, 16);
                Label.textColor = PriceColor;
                Label.tag = 324202;
            } else if (i == 3) {
                Label.frame = CGRectMake(60 + (totalWidth * 2), 7, totalWidth, 16);
                Label.text = @"实际到账金额";
            } else if (i == 4) {
                Label.frame = CGRectMake(60 + (totalWidth * 2), 37, totalWidth, 16);
                Label.textColor = PriceColor;
                Label.tag = 324204;
            }
            [_totalLotBankAccountViews addSubview:Label];
        }
    }
}

#pragma mark - 获取数据
- (void)getLotBankAccountData
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *LotBankAccountURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_LotBankAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //日期
    [params setObject:_FirstDatePicker.text forKey:@"fsrqq"];
    [params setObject:_SecondDatePicker.text forKey:@"fsrqz"];
    //消费类型，资金类型
    NSArray *ywlxArray = @[@(2),@(0),@(1)];
    NSArray *jsbzArray = @[@(2),@(1),@(0)];
    [params setObject:ywlxArray[_topIndex] forKey:@"ywlx"];
    [params setObject:jsbzArray[_bottomIndex] forKey:@"jsbz"];
    
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:LotBankAccountURL params:params success:^(id responseObject) {
        [self hideProgress];
        
        _LotBankAccountDatalist = [LotBankAccountModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        
        if (_LotBankAccountDatalist.count == 0) {
            _LotBankAccounttableView.hidden = YES;
            _LotBankAccountSearchController.searchBar.hidden = YES;
            _headerView.hidden = YES;
            _NoLotBankAccountdataView.hidden = NO;
        } else {
            _NoLotBankAccountdataView.hidden = YES;
            _headerView.hidden = NO;
            _LotBankAccounttableView.hidden = NO;
            _LotBankAccountSearchController.searchBar.hidden = NO;

            //获取查询参数
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _LotBankAccountDatalist) {
                    [_KeyNames addObject:[dic valueForKey:@"col1"]];
                    [_KeyNames addObject:[dic valueForKey:@"col3"]];
                    [_KeyNames addObject:[dic valueForKey:@"col4"]];
                }
            });
            [_LotBankAccounttableView reloadData];
        }
        //统计
        [self insertLotBankAccountWithdatalist:_LotBankAccountDatalist];
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"获取银行到账失败%@",error);
    }];
}

#pragma mark - 按钮
//顶部按钮
- (void)LotBankAccountTopButton:(UIButton *)button
{
    if (_topIndex != button.tag - 324100) {
        //按钮字体颜色
        UIButton *topbutton = [_topBgView viewWithTag:324100 + _topIndex];
        [topbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _topIndex = button.tag - 324100;
        [button setTitleColor:Mycolor forState:UIControlStateNormal];
        //划动
        [self changeTopLine:_topIndex];
        
        if (_LotBankAccountSearchController.active) {
            [_LotBankAccountSearchController.searchBar endEditing:YES];
        }
        
        //刷新数据
        [self getLotBankAccountData];
    }
}

//查询按钮
- (void)LotBankAccountDateSearch
{
    [self getLotBankAccountData];
}

//顶部按钮
- (void)LotBankAccountBottomButton:(UIButton *)button
{
    if (_bottomIndex != button.tag - 324110) {
        //按钮字体颜色
        UIButton *topbutton = [_bottomBgView viewWithTag:324110 + _bottomIndex];
        [topbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bottomIndex = button.tag - 324110;
        [button setTitleColor:Mycolor forState:UIControlStateNormal];
        //划动
        [self changeBottomLine:_bottomIndex];
        
        //刷新数据
        [self getLotBankAccountData];
    }
}

#pragma mark - 统计
- (void)insertLotBankAccountWithdatalist:(NSMutableArray *)datalist
{
    UILabel *AccountReceivablEamountLabel = (UILabel *)[_totalLotBankAccountViews viewWithTag:324202];
    float AccountReceivablEamount = 0;
    AccountReceivablEamount = [self leijiaNumDataList:datalist Code:@"col6"];
    AccountReceivablEamountLabel.text = [NSString stringWithFormat:@"￥%.2f",AccountReceivablEamount];
    
    UILabel *ActualArrivalAmountLabel = (UILabel *)[_totalLotBankAccountViews viewWithTag:324204];
    float ActualArrivalAmount = 0;
    ActualArrivalAmount = [self leijiaNumDataList:datalist Code:@"col7"];
    ActualArrivalAmountLabel.text = [NSString stringWithFormat:@"￥%.2f",ActualArrivalAmount];
}
     

#pragma mark - 线条移动
//改变顶部线条位置
-(void)changeTopLine:(long)index
{
    CGRect rect = _topLineView.frame;
    rect.origin.x = ((KScreenWidth - 240) / 6.0) + ((((KScreenWidth - 240) / 3.0) + 80) * index);
    _topLineView.frame = rect;
}

//改变顶部线条位置
-(void)changeBottomLine:(long)index
{
    CGRect rect = _BottomLineView.frame;
    rect.origin.x = ((KScreenWidth - 240) / 6.0) + ((((KScreenWidth - 240) / 3.0) + 80) * index);
    _BottomLineView.frame = rect;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchKeyNames removeAllObjects];
    [_NewLotBankAccountDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.LotBankAccountSearchController.searchBar.text];
    self.searchKeyNames = [[self.KeyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    NSMutableSet *LotBankAccountSet = [NSMutableSet set];
    for (NSString *title in self.searchKeyNames) {
        for (NSDictionary *dic in _LotBankAccountDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col3"]] || [title isEqualToString:[dic valueForKey:@"col4"]]) {
                [LotBankAccountSet addObject:dic];
            }
        }
    }
    _NewLotBankAccountDatalist = [[LotBankAccountSet allObjects] mutableCopy];
    [_LotBankAccounttableView reloadData];
    if (_NewLotBankAccountDatalist.count != 0) {
        [self insertLotBankAccountWithdatalist:_NewLotBankAccountDatalist];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self insertLotBankAccountWithdatalist:_LotBankAccountDatalist];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _FirstDatePicker) {
        _FirstDatePicker.maxdateString = _SecondDatePicker.text;
        if (_FirstDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _FirstDatePicker.subView.tag = 1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_FirstDatePicker.subView];
        }
    } else {
        _SecondDatePicker.mindateString = _FirstDatePicker.text;
        if (_SecondDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _SecondDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_SecondDatePicker.subView];
        }
    }
    return NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_LotBankAccountSearchController.active) {
        return _NewLotBankAccountDatalist.count;
    } else {
        return _LotBankAccountDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LotBankAccountIdent = @"LotBankAccountIdent";
    LotBankAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LotBankAccountIdent];
    if (cell == nil) {
        cell = [[LotBankAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LotBankAccountIdent];
    }
    if (_LotBankAccountSearchController.active) {
        cell.dic = _NewLotBankAccountDatalist[indexPath.row];
    } else {
        cell.dic = _LotBankAccountDatalist[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LotBankAccountDetailViewController *LotBankAccountDetailVC = [[LotBankAccountDetailViewController alloc] init];
    if (_LotBankAccountSearchController.active) {
        LotBankAccountDetailVC.dic = _NewLotBankAccountDatalist[indexPath.row];
    } else {
        LotBankAccountDetailVC.dic = _LotBankAccountDatalist[indexPath.row];
    }
    [self.navigationController pushViewController:LotBankAccountDetailVC animated:YES];
}
@end
