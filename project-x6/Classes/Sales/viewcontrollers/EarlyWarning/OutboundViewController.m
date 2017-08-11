//
//  OutboundViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OutboundViewController.h"

#import "CostumMoreDatePicker.h"

#import "OutboundModel.h"
#import "OutbounddetailModel.h"

#import "OutboundTableViewCell.h"

@interface OutboundViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITextFieldDelegate>
{
    NSMutableArray *_selectOutboundArray;                 //标题被选中数组
    CostumMoreDatePicker *_datepicker;                           //日期选择
}
@property(nonatomic,strong)UITableView *OutboundTableview;                 //库存表示图
@property(nonatomic,strong)NoDataView *NoOutboundView;                     //没有库存

@property(nonatomic,copy)NSMutableArray *Outbounddatalist;                 //库存数据
@property(nonatomic,copy)NSMutableDictionary *OutboundDic;             //表示图的数据
@property(nonatomic,copy)NSMutableArray *OutboundDetaildatalist;


@property(nonatomic,copy)NSMutableArray *OutboundNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *OutboundSearchNames;
@property(nonatomic,copy)NSMutableArray *NewOutboundDatalist;
@property(nonatomic, strong)UISearchController *OutboundSearchController;


@end

@implementation OutboundViewController

- (UITableView *)OutboundTableview
{
    if (!_OutboundTableview) {
        _OutboundTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
        _OutboundTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _OutboundTableview.delegate = self;
        _OutboundTableview.dataSource = self;
        _OutboundTableview.hidden = YES;
        _OutboundTableview.separatorStyle = UITableViewCellAccessoryNone;
        _OutboundTableview.backgroundColor = GrayColor;
        [self.view addSubview:_OutboundTableview];
    }
    return _OutboundTableview;
}

- (NoDataView *)NoOutboundView
{
    if (!_NoOutboundView) {
        _NoOutboundView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
        _NoOutboundView.text = @"当前月份没有出库异常";
        _NoOutboundView.hidden = YES;
        [self.view addSubview:_NoOutboundView];
    }
    return _NoOutboundView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTodayData" object:nil];
    _OutboundNames = nil;
    _OutboundSearchNames = nil;
    
    _OutboundDetaildatalist = nil;
    _OutboundDic = nil;
    
    _NewOutboundDatalist = nil;
    _Outbounddatalist = nil;
    
    _selectOutboundArray = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"出库异常统计"];
    
    //导航栏按钮

    [self drawRightBarButtonItem];
    
    _OutboundNames = [NSMutableArray array];
    _OutboundSearchNames = [NSMutableArray array];
    
    _OutboundDetaildatalist = [NSMutableArray array];
    _OutboundDic = [NSMutableDictionary dictionary];
    
    _NewOutboundDatalist = [NSMutableArray array];
    _Outbounddatalist = [[NSMutableArray alloc] initWithCapacity:0];
    
    _selectOutboundArray = [NSMutableArray array];
    //搜索框
    _OutboundSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _OutboundSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _OutboundSearchController.searchResultsUpdater = self;
    _OutboundSearchController.searchBar.delegate = self;
    _OutboundSearchController.dimsBackgroundDuringPresentation = NO;
    _OutboundSearchController.hidesNavigationBarDuringPresentation = NO;
    _OutboundSearchController.searchBar.placeholder = @"搜索";
    [_OutboundSearchController.searchBar sizeToFit];
    [self.view addSubview:_OutboundSearchController.searchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyOutboundData) name:@"changeTimeData" object:nil];

    [self NoOutboundView];
    
    [self OutboundTableview];
    
    [self getMyOutboundData];
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
    [_OutboundSearchController.searchBar setHidden:NO];
 
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_OutboundSearchController.searchBar setHidden:YES];
    [_OutboundSearchController setActive:NO];

}
#pragma mark - 绘制导航栏按钮
- (void)drawRightBarButtonItem
{
    NSDateFormatter *dateFor = [NSDateFormatter new];
    [dateFor setDateFormat:@"yyyy-MM"];
    NSString *year = [[dateFor stringFromDate:[NSDate date]] substringToIndex:4];
    NSMutableArray *years = [NSMutableArray array];
    for (NSInteger i = 2000; i <= [year integerValue]; i++) {
        NSString *year = [NSString stringWithFormat:@"%ld",(long)i];
        [years addObject:year];
    }
    
    NSMutableArray *months = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        NSString *month;
        if (i < 10) {
            month = [NSString stringWithFormat:@"0%d",i];
        } else {
            month = [NSString stringWithFormat:@"%d",i];
        }
        [months addObject:month];
    }
    NSMutableArray *datas = [NSMutableArray arrayWithObjects:years,months, nil];
    
    _datepicker = [[CostumMoreDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Data:datas IndexStr:[dateFor stringFromDate:[NSDate date]] Key:@"-"];
    _datepicker.delegate = self;
    _datepicker.MoretextColor = [UIColor whiteColor];
    _datepicker.MoretextFont = [UIFont systemFontOfSize:11];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_datepicker];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.OutboundSearchController.active) {
        return _OutboundSearchNames.count;
    } else {
        return _Outbounddatalist.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectOutboundArray containsObject:string]) {
        NSArray *sectionArray = [_OutboundDic objectForKey:string];
        return sectionArray.count;
    } else {
        
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (self.OutboundSearchController.active) {
        view = [self creatTableviewWithMutableArray:_NewOutboundDatalist Section:section];
    } else {
        view = [self creatTableviewWithMutableArray:[_Outbounddatalist mutableCopy] Section:section];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *OutboundIndet = @"OutboundIndet";
    OutboundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OutboundIndet];
    if (cell == nil) {
        cell = [[OutboundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OutboundIndet];
    }
    if ([_selectOutboundArray containsObject:indexStr]) {
        NSArray *array = [_OutboundDic objectForKey:indexStr];
        cell.dic = array[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}




#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 154, 20)];
    companyTitle.font = MainFont;
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 24, 17, 14, 8)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectOutboundArray containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"jiantou_a"];
    } else {
        selectView.image = [UIImage imageNamed:@"jiantou_b"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 45);
    button.tag = 4600 + section;
    [button addTarget:self action:@selector(leadmyOutboundSectionData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 134, 5, 100, 30)];
    Label.text = [NSString stringWithFormat:@"异常:%@次",[mutableArray[section] valueForKey:@"col2"]];
    Label.font = MainFont;
    Label.textAlignment = NSTextAlignmentRight;
    Label.textColor = PriceColor;
    [view addSubview:Label];
    
    
    UIView *lowLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [view addSubview:lowLineView];
    
    return view;
}

#pragma mark - 标题栏按钮事件
- (void)leadmyOutboundSectionData:(UIButton *)button
{
    //获取数据
    
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 4600];
    NSMutableArray *array;
    if (self.OutboundSearchController.active) {
        array = _NewOutboundDatalist;
    } else {
        array = _Outbounddatalist;
    }
    
    if ([_selectOutboundArray containsObject:string]) {
        [_selectOutboundArray removeObject:string];
        [_OutboundDic removeObjectForKey:string];
        [_OutboundTableview reloadData];
        
    } else {
        dispatch_group_t grouped = dispatch_group_create();
        
        [_selectOutboundArray addObject:string];
        
        [self getOutboundDataWithDate:_datepicker.text Array:array Section:string group:grouped];
        dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
            [_OutboundTableview reloadData];
            
        });
    }
}



#pragma mark - 获取数据
- (void)getMyOutboundData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *myOutboundURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Outbound];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *uyear = [_datepicker.text substringToIndex:4];
    NSString *umonth = [_datepicker.text substringWithRange:NSMakeRange(5, 2)];
    [params setObject:uyear forKey:@"uyear"];
    [params setObject:umonth forKey:@"accper"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:myOutboundURL params:params success:^(id responseObject) {
        [self hideProgress];
        _Outbounddatalist = [OutboundModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_Outbounddatalist.count == 0) {
            _OutboundTableview.hidden = YES;
            _NoOutboundView.hidden = NO;
        } else {
            _NoOutboundView.hidden = YES;
            _OutboundTableview.hidden = NO;
            NSArray *sortOutboundArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col2" ascending:NO]];
            [_Outbounddatalist sortUsingDescriptors:sortOutboundArray];
            [_OutboundTableview reloadData];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _Outbounddatalist) {
                    [_OutboundNames addObject:[dic valueForKey:@"col1"]];
                    
                }
            });
            
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"我的库存请求失败");
    }];
    
}

- (void)getOutboundDataWithDate:(NSString *)date
                      Array:(NSMutableArray *)array
                        Section:(NSString *)section
                          group:(dispatch_group_t)group
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *myOutboundDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Outbounddetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uyear = [date substringToIndex:4];
    NSString *umonth = [date substringWithRange:NSMakeRange(5, 2)];
    [params setObject:uyear forKey:@"uyear"];
    [params setObject:umonth forKey:@"accper"];
    NSNumber *ssgs = [[array objectAtIndex:[section integerValue]] valueForKey:@"col0"];
    [params setObject:ssgs forKey:@"ssgs"];
    dispatch_group_enter(group);
    
    [XPHTTPRequestTool requestMothedWithPost:myOutboundDetailURL params:params success:^(id responseObject) {
        _OutboundDetaildatalist = [OutbounddetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        [_OutboundDic setObject:_OutboundDetaildatalist forKey:section];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        NSLog(@"行的");
        dispatch_group_leave(group);
        
    }];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.OutboundSearchNames removeAllObjects];
    [self.OutboundDic removeAllObjects];
    [_selectOutboundArray removeAllObjects];
    [_NewOutboundDatalist removeAllObjects];
    
    NSPredicate *OutboundPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.OutboundSearchController.searchBar.text];
    self.OutboundSearchNames = [[self.OutboundNames filteredArrayUsingPredicate:OutboundPredicate] mutableCopy];
    
    for (NSString *title in self.OutboundSearchNames) {
        for (NSDictionary *dic in self.Outbounddatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_NewOutboundDatalist addObject:dic];
            }
        }
    }
    
    [_OutboundTableview reloadData];
    
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

@end
