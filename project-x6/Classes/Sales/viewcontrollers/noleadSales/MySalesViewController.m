//
//  MySalesViewController.m
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MySalesViewController.h"
#import "MySalesModel.h"
#import "MyTodayTableViewCell.h"
#import "XPDatePicker.h"


@interface MySalesViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITextFieldDelegate>
{
    NSString *_dateString;        //当前的时间
    NSString *_firstDayString;    //当前月份的第一天
    
    XPDatePicker *_FirstDatePicker;      //第一个textfield
    XPDatePicker *_SecondDatePicker;     //第二个textfield
}

@property(nonatomic,strong)NoDataView *nomysalesdataView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *totalNumberViews;    //总计



@property(nonatomic,copy)NSMutableArray *datalist;   // 总的数据
@property(nonatomic,copy)NSMutableArray *mutableKeys;   // 需要展示的组名
@property(nonatomic,copy)NSMutableArray *mutableArray;  //制定key的数组
@property(nonatomic,copy)NSMutableArray *NameDatalist;         //名称集合

@property(nonatomic,strong)NSMutableArray *SearchDatalist;       //搜索的数据
@property(nonatomic,strong)NSMutableArray *NewSearchDatalist;       //搜索的数据
@property(nonatomic,strong)NSMutableArray *SearchdateDatalist;       //搜索的数据
@property(nonatomic, strong)UISearchController *MySalesSearchController;

@end

@implementation MySalesViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        //表示图
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45 + 44 + 40, KScreenWidth, KScreenHeight - 124 - 129) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.backgroundColor = GrayColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _tableView;
}

- (NoDataView *)nomysalesdataView
{
    if (!_nomysalesdataView) {
        _nomysalesdataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 64 - 84)];
        _nomysalesdataView.hidden = YES;
        _nomysalesdataView.backgroundColor = [UIColor whiteColor];
        _nomysalesdataView.text = @"当前没有纪录";
        [self.view addSubview:_nomysalesdataView];
    }
    return _nomysalesdataView;

}

- (UIView *)totalNumberViews
{
    if (!_totalNumberViews) {
        _totalNumberViews = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
        _totalNumberViews.backgroundColor = [UIColor whiteColor];
        _totalNumberViews.hidden = YES;
        [self.view addSubview:_totalNumberViews];
        
        for (int i = 0; i < 5; i++)
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
                Label.frame = CGRectMake(60 + totalWidth, 7, totalWidth, 16);
                Label.text = @"数量";
            } else if (i == 2) {
                Label.frame = CGRectMake(60 + totalWidth, 37, totalWidth, 16);
                Label.textColor = PriceColor;
            } else if (i == 3) {
                Label.frame = CGRectMake(60 + totalWidth * 2, 7, totalWidth, 16);
                Label.text = @"金额";
            } else if (i == 4) {
                Label.frame = CGRectMake(60 + totalWidth * 2, 37, totalWidth, 16);
                Label.textColor = PriceColor;
            }
            Label.tag = 39020 + i;
            [_totalNumberViews addSubview:Label];
        }
    }
    return _totalNumberViews;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _MySalesSearchController.searchBar.hidden = YES;
    if ([_MySalesSearchController.searchBar isFirstResponder]) {
        [_MySalesSearchController.searchBar resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_MySalesSearchController.searchBar setHidden:NO];
    //搜索框
    [self initHeaderViews];
    
    //获取当前月份的所有数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getMySalesDataWithFirstDay:_firstDayString LastDay:_dateString];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"我的销量"];

    //获取当前的年月
    _dateString = [BasicControls TurnTodayDate];
    //当前月份的第一天
    NSMutableString *monthFirstString = [NSMutableString stringWithString:_dateString];
    [monthFirstString replaceCharactersInRange:NSMakeRange(_dateString.length - 2, 2) withString:@"01"];
    _firstDayString = [monthFirstString mutableCopy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
    _MySalesSearchController.searchResultsUpdater = nil;
    _MySalesSearchController.searchBar.delegate = nil;

}

- (void)dealloc
{
    _MySalesSearchController.searchResultsUpdater = nil;
    _MySalesSearchController.searchBar.delegate = nil;
}


- (void)initHeaderViews
{
    //搜索框
    _MySalesSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _MySalesSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _MySalesSearchController.searchResultsUpdater = self;
    _MySalesSearchController.searchBar.delegate = self;
    _MySalesSearchController.dimsBackgroundDuringPresentation = NO;
    _MySalesSearchController.hidesNavigationBarDuringPresentation = NO;
    _MySalesSearchController.searchBar.placeholder = @"搜索";
    [_MySalesSearchController.searchBar sizeToFit];
    [self.view addSubview:_MySalesSearchController.searchBar];
    
    //按日期查询
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, 40)];
    headerView.backgroundColor = GrayColor;
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    dateLabel.text = @"日期:";
    dateLabel.font = MainFont;
    [headerView addSubview:dateLabel];
    
    _FirstDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(50, 5, 90, 30) Date:_firstDayString];
    _FirstDatePicker.delegate = self;
    _FirstDatePicker.font = ExtitleFont;
    _FirstDatePicker.backgroundColor = [UIColor whiteColor];
    _FirstDatePicker.textColor = [UIColor blackColor];
    _FirstDatePicker.labelString = @"  起始日期:";
    [headerView addSubview:_FirstDatePicker];
    
    UILabel *leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(148, 5, 20, 30)];
    leadLabel.text = @"至";
    leadLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:leadLabel];
    
    _SecondDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(168 + 8, 5, 90, 30) Date:_dateString];
    _SecondDatePicker.delegate = self;
    _SecondDatePicker.font = ExtitleFont;
    _SecondDatePicker.backgroundColor = [UIColor whiteColor];
    _SecondDatePicker.textColor = [UIColor blackColor];
    _SecondDatePicker.labelString = @"  结束日期:";
    [headerView addSubview:_SecondDatePicker];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(268 + 8, 6, KScreenWidth - 268 - 16, 28);
    button.backgroundColor = Mycolor;
    button.layer.cornerRadius = 4;
    [button setTitle:@"查询" forState:UIControlStateNormal];
    button.titleLabel.font = ExtitleFont;
    [button addTarget:self action:@selector(buttonActioned:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    //注释
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    NSArray *name = @[@"商品名称",@"数量",@"金额"];
    for (int i = 0; i < name.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(0, 10, (KScreenWidth / 9) * 5, 25);
        } else if (i == 1) {
            label.frame = CGRectMake((KScreenWidth / 9) * 5, 10, (KScreenWidth / 9) * 2, 25);
        } else {
            label.frame = CGRectMake((KScreenWidth / 9) * 7, 10, (KScreenWidth / 9) * 2, 25);
        }
        label.text = name[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = MainFont;
        [view addSubview:label];
    }
    UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [view addSubview:lineView];
    
    [self.view addSubview:view];
    
    [self tableView];
    [self nomysalesdataView];
    [self totalNumberViews];
    
}

#pragma mark - 获取数据
- (void)getMySalesDataWithFirstDay:(NSString *)firstDay LastDay:(NSString *)lastDay
{
    //获取今天的数据
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *MySalesURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_noleaderMySales];
    [self showProgress];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:firstDay forKey:@"fsrqq"];
    [params setObject:lastDay forKey:@"fsrqz"];
    
    [XPHTTPRequestTool requestMothedWithPost:MySalesURL params:params success:^(id responseObject) {
        [self hideProgress];

        _datalist = [MySalesModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        
        NSArray *sortkucunArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col0" ascending:YES]];
        [_datalist sortUsingDescriptors:sortkucunArray];
        
        if (_datalist.count == 0) {
            _tableView.hidden = YES;
            _nomysalesdataView.hidden = NO;
            _totalNumberViews.hidden = YES;
        } else {
            _tableView.hidden = NO;
            _nomysalesdataView.hidden = YES;
            _totalNumberViews.hidden = NO;
            //获取时间
            NSMutableSet *set = [NSMutableSet set];
            for (NSDictionary *dic in _datalist) {
                [set addObject:[dic valueForKey:@"col0"]];
            }
            _mutableKeys = [[set allObjects] mutableCopy];
            
            NSMutableArray *datekey = [[NSMutableArray alloc] init];
            for (NSString *dateString in _mutableKeys) {
                [datekey addObject:[dateString substringFromIndex:8]];
            }
            
            [datekey sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 intValue] > [obj2 intValue];
            }];
            
            NSMutableArray *dayarray = [[NSMutableArray alloc] init];
            for (NSString *dayString in datekey) {
                for (NSString *datedasString in _mutableKeys) {
                    NSString *day = [datedasString substringFromIndex:8];
                    if ([dayString isEqualToString:day]) {
                        [dayarray addObject:datedasString];
                    }
                }
            }
            _mutableKeys = dayarray;
            
            
            _NameDatalist = [NSMutableArray array];
            for (NSDictionary *dic in _datalist) {
                [_NameDatalist addObject:[dic valueForKey:@"col2"]];
            }
           
            //处理数据
            [self makedata];
            
            [_tableView reloadData];
            
            //总计的数据
            [self insertLabelWithdatalist:_datalist];
        }

    } failure:^(NSError *error) {
        [self hideProgress];
    }];
    
    
}

- (void)makedata
{
    _mutableArray = [NSMutableArray array];
    for (NSString *date in _mutableKeys) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"col0"] isEqualToString:date]) {
                [array addObject:dic];
            }
        }
        [_mutableArray addObject:array];
    }    
}


- (void)insertLabelWithdatalist:(NSArray *)datalist
{
    UILabel *label = [_totalNumberViews viewWithTag:39022];
    long numbers = 0;
    
    UILabel *label2 = [_totalNumberViews viewWithTag:39024];
    long double prices = 0;
    for (id dic in datalist) {
        if ([dic isKindOfClass:[NSArray class]]) {
            for (NSDictionary *diced in dic) {
                numbers += [[diced valueForKey:@"col3"] intValue];
                prices += [[diced valueForKey:@"col4"] doubleValue];
            }
        } else {
            numbers += [[dic valueForKey:@"col3"] intValue];
            prices += [[dic valueForKey:@"col4"] doubleValue];
        }
        
    }
    label.text = [NSString stringWithFormat:@"%.0ld台",numbers];
    label2.text = [NSString stringWithFormat:@"￥%.0Lf",prices];
    
    
}

#pragma mark - UITableViewDataSource
//组的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_MySalesSearchController.active) {
        return _mutableKeys.count;
    } else {
        return _NewSearchDatalist.count;
    }
}

//组的单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_MySalesSearchController.active) {
        return [_mutableArray[section] count];
    } else {
        return [_NewSearchDatalist[section] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!_MySalesSearchController.active) {
        return _mutableKeys[section];
    } else {
        return _SearchdateDatalist[section];
    }
}

//标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"MySalesident";
    MyTodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[MyTodayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    if (!_MySalesSearchController.active) {
        //默认情况下的数据
        cell.dic = [[_mutableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
        //搜索情况下的数据
        cell.dic = [_NewSearchDatalist[indexPath.section] objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    [self.SearchDatalist removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", _MySalesSearchController.searchBar.text];
    self.SearchDatalist = [[self.NameDatalist filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    //处理数据
    [self makeSearchDta];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [self insertLabelWithdatalist:_NewSearchDatalist];
    });
    
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self insertLabelWithdatalist:_datalist];
}


- (void)makeSearchDta
{
    NSMutableSet *array = [NSMutableSet set];
    for (NSString *name in _SearchDatalist) {
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"col2"] isEqualToString:name]) {
                [array addObject:dic];
            }
        }
    }
    
    NSMutableSet *set = [NSMutableSet set];
    for (NSDictionary *dic in array) {
        [set addObject:[dic valueForKey:@"col0"]];
    }
    _SearchdateDatalist = [[set allObjects] mutableCopy];
    NSMutableArray *datekey = [[NSMutableArray alloc] init];
    for (NSString *dateString in _SearchdateDatalist) {
        [datekey addObject:[dateString substringFromIndex:8]];
    }
    
    [datekey sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
    
    NSMutableArray *dayarray = [[NSMutableArray alloc] init];
    for (NSString *dayString in datekey) {
        for (NSString *datedasString in _SearchdateDatalist) {
            NSString *day = [datedasString substringFromIndex:8];
            if ([dayString isEqualToString:day]) {
                [dayarray addObject:datedasString];
            }
        }
    }
    _SearchdateDatalist = dayarray;
    
    
    _NewSearchDatalist = [NSMutableArray array];
    for (NSString *date in set) {
        NSMutableArray *dateArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            if ([[dic valueForKey:@"col0"] isEqualToString:date]) {
                [dateArray addObject:dic];
            }
        }
        [_NewSearchDatalist addObject:dateArray];
    }

}

#pragma mark - 查询按钮事件
- (void)buttonActioned:(UIButton *)button
{
    if (_MySalesSearchController.active) {
        [_MySalesSearchController resignFirstResponder];
    }
    
    [self getMySalesDataWithFirstDay:_FirstDatePicker.text LastDay:_SecondDatePicker.text];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _FirstDatePicker) {
        _FirstDatePicker.maxdateString = _SecondDatePicker.text;
        if (_FirstDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _FirstDatePicker.subView.tag=1;
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

@end
