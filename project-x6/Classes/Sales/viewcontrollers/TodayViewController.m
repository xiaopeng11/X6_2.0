//
//  TodayViewController.m
//  project-x6
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayViewController.h"

#import "XPDatePicker.h"

#import "TodayModel.h"
#import "TodaydetailModel.h"

#import "TodayTableViewCell.h"

#define todaywidth ((KScreenWidth - 140) / 3.0)

@interface TodayViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NSMutableArray *_selectSectionArray;                         //标题被选中数组
    XPDatePicker *_datepicker;                                   //日期选择
}

@property(nonatomic,copy)NSMutableArray *todayDatalist;          //今日战报门店数据
@property(nonatomic,copy)NSMutableDictionary *detailDic;
@property(nonatomic,copy)NSMutableArray *todayDetailDatalist;    //今日战报门店详情数据

@property(nonatomic,strong)NoDataView *NotodayView;              //今日战报为空
@property(nonatomic,strong)UITableView *TodayTableView;          //今日战报
@property(nonatomic,strong)UIView *totalView;

//搜索事件
@property(nonatomic,copy)NSMutableArray *companyNames;           //门店名数组
@property(nonatomic,strong)NSMutableArray *companSearchNames;    //搜索的门店名
@property(nonatomic,strong)UISearchController *companySearchController;
@property(nonatomic,copy)NSMutableArray *newtodayDatlist;


@end

@implementation TodayViewController

- (NoDataView *)NotodayView
{
    if (!_NotodayView) {
        _NotodayView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
        _NotodayView.text = @"没有数据";
        _NotodayView.hidden = YES;
        [self.view addSubview:_NotodayView];
    }
    return _NotodayView;
}

- (UITableView *)TodayTableView
{
    if (!_TodayTableView) {
        _TodayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 60) style:UITableViewStylePlain];
        _TodayTableView.hidden = YES;
        _TodayTableView.delegate = self;
        _TodayTableView.dataSource = self;
        _TodayTableView.allowsSelection = NO;
        _TodayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _TodayTableView.backgroundColor = GrayColor;
        [self.view addSubview:_TodayTableView];
    }
    return _TodayTableView;
}

- (UIView *)totalView
{
    if (_totalView == nil) {
        _totalView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
        _totalView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_totalView];

        for (int i = 0; i < 7; i++)
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
                Label.frame = CGRectMake(60, 7, totalWidth, 16);
                Label.text = @"数量";
            } else if (i == 2) {
                Label.frame = CGRectMake(60, 37, totalWidth, 16);
                Label.textColor = PriceColor;
            } else if (i == 3) {
                Label.frame = CGRectMake(60 + totalWidth, 7, totalWidth, 16);
                Label.text = @"金额";
            } else if (i == 4) {
                Label.frame = CGRectMake(60 + totalWidth, 37, totalWidth, 16);
                Label.textColor = PriceColor;
            } else if (i == 5) {
                Label.frame = CGRectMake(60 + totalWidth * 2, 7, totalWidth, 16);
                Label.text = @"毛利";
            } else if (i == 6) {
                Label.frame = CGRectMake(60 + totalWidth * 2, 37, totalWidth, 16);
                Label.textColor = PriceColor;
            }
            Label.tag = 4210 + i;
            [_totalView addSubview:Label];
        }
        
        UIView *totalLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
        [_totalView addSubview:totalLineView];
    }
    return _totalView;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTodayData" object:nil];
    _selectSectionArray = nil;
    _todayDetailDatalist = nil;
    _detailDic = nil;
    _companyNames = nil;
    _companSearchNames = nil;
    _newtodayDatlist = nil;
    _todayDatalist = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"今日战报"];
    
    
    //导航栏按钮
    [self creatRightNaviButton];
    
    _selectSectionArray = [NSMutableArray array];
    _todayDetailDatalist = [NSMutableArray array];
    _detailDic = [NSMutableDictionary dictionary];
    
    _companyNames = [NSMutableArray array];
    _companSearchNames = [NSMutableArray array];
    
    _newtodayDatlist = [NSMutableArray array];
    
    //搜索框
    _companySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _companySearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _companySearchController.searchResultsUpdater = self;
    _companySearchController.searchBar.delegate = self;
    _companySearchController.dimsBackgroundDuringPresentation = NO;
    _companySearchController.hidesNavigationBarDuringPresentation = NO;
    _companySearchController.searchBar.placeholder = @"搜索";
    [_companySearchController.searchBar sizeToFit];
    [self.view addSubview:_companySearchController.searchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTodayData) name:@"changeTodayData" object:nil];
    
    
    [self NotodayView];
    [self TodayTableView];
    
    //获取数据
    [self getTodayData];
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
    
    [_companySearchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_companySearchController.searchBar setHidden:YES];
    [_companySearchController setActive:NO];
}

#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
    _datepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:[BasicControls TurnTodayDate]];
    _datepicker.delegate = self;
    _datepicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_datepicker];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companSearchNames removeAllObjects];
    [self.detailDic removeAllObjects];
    [_selectSectionArray removeAllObjects];
    [_newtodayDatlist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.companySearchController.searchBar.text];
    self.companSearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.companSearchNames) {
        for (NSDictionary *dic in self.todayDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_newtodayDatlist addObject:dic];
            }
        }
    }
    
    [_TodayTableView reloadData];
    
    if (_newtodayDatlist.count != 0) {        
        float totalNum = 0,totalMoney = 0,totalProfit = 0;
        totalNum = [self leijiaNumDataList:_newtodayDatlist Code:@"col2"];
        totalMoney = [self leijiaNumDataList:_newtodayDatlist Code:@"col3"];
        totalProfit = [self leijiaNumDataList:_newtodayDatlist Code:@"col4"];
        
        UILabel *numlabel = (UILabel *)[_totalView viewWithTag:4212];
        UILabel *jinelabel = (UILabel *)[_totalView viewWithTag:4214];
        UILabel *maolilabel = (UILabel *)[_totalView viewWithTag:4216];
        numlabel.text = [NSString stringWithFormat:@"%.0f个",totalNum];
        jinelabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
        for (NSDictionary *dic in qxList) {
            if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jrzb"]) {
                if ([[dic valueForKey:@"pcb"] integerValue] == 1) {
                    maolilabel.text = [NSString stringWithFormat:@"￥****"];
                } else {
                    maolilabel.text = [NSString stringWithFormat:@"￥%.2f",totalProfit];
                }
            }
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    float totalNum = 0,totalMoney = 0,totalProfit = 0;
    totalNum = [self leijiaNumDataList:_todayDatalist Code:@"col2"];
    totalMoney = [self leijiaNumDataList:_todayDatalist Code:@"col3"];
    totalProfit = [self leijiaNumDataList:_todayDatalist Code:@"col4"];
    
    UILabel *numlabel = (UILabel *)[_totalView viewWithTag:4212];
    UILabel *jinelabel = (UILabel *)[_totalView viewWithTag:4214];
    UILabel *maolilabel = (UILabel *)[_totalView viewWithTag:4216];
    numlabel.text = [NSString stringWithFormat:@"%.0f个",totalNum];
    jinelabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    for (NSDictionary *dic in qxList) {
        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jrzb"]) {
            if ([[dic valueForKey:@"pcb"] integerValue] == 1) {
                maolilabel.text = [NSString stringWithFormat:@"￥****"];
            } else {
                maolilabel.text = [NSString stringWithFormat:@"￥%.2f",totalProfit];
            }
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_companySearchController.active) {
        return _companSearchNames.count;
    } else {
        return _todayDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectSectionArray containsObject:string]) {
        NSArray *sectionArray = [_detailDic objectForKey:string];
        return sectionArray.count;
    } else {
        return 0;
    }
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (self.companySearchController.active) {
        view = [self creatTableviewWithMutableArray:_newtodayDatlist Section:section];
    } else {
        view = [self creatTableviewWithMutableArray:[_todayDatalist mutableCopy] Section:section];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *todayIndet = @"todayIndet";
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todayIndet];
    if (cell == nil) {
        cell = [[TodayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayIndet];
    }
    if ([_selectSectionArray containsObject:indexStr]) {
        NSArray *array = [_detailDic objectForKey:indexStr];
        cell.dic = array[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark - 获取数据
/**
 *  门店数据
*/
- (void)getTodayData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todayURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_today];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_datepicker.text forKey:@"fsrqq"];
    [params setObject:_datepicker.text forKey:@"fsrqz"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:todayURL params:params success:^(id responseObject) {
        [self hideProgress];
        _todayDatalist = [TodayModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todayDatalist.count == 0) {
            
            _TodayTableView.hidden = YES;
            _NotodayView.hidden = NO;
            if (_totalView != nil) {
                [_totalView removeFromSuperview];
                _totalView = nil;
            }
        } else {
            _NotodayView.hidden = YES;
            _TodayTableView.hidden = NO;
            NSArray *sorttodayArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col4" ascending:NO]];
            [_todayDatalist sortUsingDescriptors:sorttodayArray];
            
            [self passwordTodayDatalistWithDataList:_todayDatalist Key:@"col4" Jmdx:@"bb_jrzb"];
            
            [_TodayTableView reloadData];
            [self totalView];
            
            float totalNum = 0,totalMoney = 0,totalProfit = 0;
            totalNum = [self leijiaNumDataList:_todayDatalist Code:@"col2"];
            totalMoney = [self leijiaNumDataList:_todayDatalist Code:@"col3"];
            totalProfit = [self leijiaNumDataList:_todayDatalist Code:@"col4"];
            
            UILabel *numlabel = (UILabel *)[_totalView viewWithTag:4212];
            UILabel *jinelabel = (UILabel *)[_totalView viewWithTag:4214];
            UILabel *maolilabel = (UILabel *)[_totalView viewWithTag:4216];
            numlabel.text = [NSString stringWithFormat:@"%.0f个",totalNum];
            jinelabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
            for (NSDictionary *dic in qxList) {
                if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jrzb"]) {
                    if ([[dic valueForKey:@"pcb"] integerValue] == 1) {
                        maolilabel.text = [NSString stringWithFormat:@"￥****"];
                    } else {
                        maolilabel.text = [NSString stringWithFormat:@"￥%.2f",totalProfit];
                    }
                }
            }      
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _todayDatalist) {
                [array addObject:[dic valueForKey:@"col1"]];
            }
            _companyNames = array;
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"今日战报数据获取失败");
    }];
}

/**
 *  门店员工数据
 *
 *  @param date      日期
 *  @param storeCode 门店代码
 */
- (void)getYuanGongDataWithDate:(NSString *)date
                      StoreCode:(NSNumber *)storeCode
                        Section:(long)section
                          group:(dispatch_group_t)group
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todaydetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_todayDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [params setObject:storeCode forKey:@"ssgs"];
    [self showProgress];
    dispatch_group_enter(group);

    [XPHTTPRequestTool requestMothedWithPost:todaydetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        _todayDetailDatalist = [TodaydetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
    
        NSArray *sorttodayArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col3" ascending:NO]];
        [_todayDetailDatalist sortUsingDescriptors:sorttodayArray];
        
        [self passwordTodayDatalistWithDataList:_todayDetailDatalist Key:@"col5" Jmdx:@"bb_jrzb"];

        NSString *idnex = [NSString stringWithFormat:@"%ld",section];
        [_detailDic setObject:_todayDetailDatalist forKey:idnex];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"今日战报数据获取失败");
        dispatch_group_leave(group);
    }];
    
}

#pragma mark - 日期选择响应事件
- (void)changeTodayData
{
    if (_selectSectionArray.count != 0) {
        [_selectSectionArray removeAllObjects];
        [_detailDic removeAllObjects];
    }
    [self getTodayData];
}


#pragma mark - 标题栏按钮事件
- (void)leadSectionData:(UIButton *)button
{
    //获取数据
   
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 4220];
    NSNumber *comStore = 0;
    if (_companySearchController.active) {
        comStore = [[_newtodayDatlist objectAtIndex:[string integerValue]] objectForKey:@"col0"];
    } else {
        comStore = [[_todayDatalist objectAtIndex:[string integerValue]] objectForKey:@"col0"];
    }
    
    
   
    if ([_selectSectionArray containsObject:string]) {
        [_selectSectionArray removeObject:string];
        [_detailDic removeObjectForKey:string];
        [_TodayTableView reloadData];

    } else {
        dispatch_group_t grouped = dispatch_group_create();

        [_selectSectionArray addObject:string];
        
        [self getYuanGongDataWithDate:_datepicker.text StoreCode:comStore Section:[string longLongValue] group:grouped];

        dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
            [_TodayTableView reloadData];

        });
   
    }

}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_datepicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _datepicker.subView.tag=1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_datepicker.subView];
    }
    
    return NO;
}

#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"y2_d"];
    [view addSubview:imageView];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 7.5, KScreenWidth - 50, 25)];
    companyTitle.font = MainFont;
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 24, 30, 14, 8)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectSectionArray containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"jiantou_a"];
    } else {
        selectView.image = [UIImage imageNamed:@"jiantou_b"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 70);
    button.tag = 4220 + section;
    [button addTarget:self action:@selector(leadSectionData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    
    for (int i = 0; i < 3; i++) {
        UILabel *nameLabel = [[UILabel alloc] init];
        UILabel *label = [[UILabel alloc] init];
        nameLabel.font = ExtitleFont;
        label.font = ExtitleFont;
        label.textColor = PriceColor;
        NSDictionary *mutabledic = mutableArray[section];
        if (i == 0) {
            nameLabel.frame = CGRectMake(10, 40, 40, 20);
            nameLabel.text = @"数量:";
            label.frame = CGRectMake(50, 40, todaywidth, 20);
            label.text = [NSString stringWithFormat:@"%@",[mutableArray[section] valueForKey:@"col2"]];
        } else if (i == 1) {
            nameLabel.frame = CGRectMake(50 + todaywidth, 40, 40, 20);
            nameLabel.text = @"金额:";
            label.frame = CGRectMake(90 + todaywidth, 40, todaywidth, 20);
            label.text = [NSString stringWithFormat:@"￥%@",[mutableArray[section] valueForKey:@"col3"]];
        } else {
            nameLabel.frame = CGRectMake(90 + todaywidth * 2, 40, 40, 20);
            nameLabel.text = @"毛利:";
            label.frame = CGRectMake(130 + todaywidth * 2, 40, todaywidth, 20);
            if ([[mutabledic allKeys] containsObject:@"col4"]) {
                label.text = [NSString stringWithFormat:@"￥%@",[mutableArray[section] valueForKey:@"col4"]];
            } else {
                label.text = [NSString stringWithFormat:@"￥****"];
            }
        }
        [view addSubview:label];
        [view addSubview:nameLabel];
    }
    
    UIView *lowLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 69.5, KScreenWidth, .5)];
    [view addSubview:lowLineView];

    return view;
}


@end
