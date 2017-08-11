//
//  TodayinventoryViewController.m
//  project-x6
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TodayinventoryViewController.h"

#import "ShareViewController.h"

#import "KucunModel.h"
#import "KucunDeatilModel.h"

#import "TodayNoleaderTableViewCell.h"

#import "NoDataView.h"
#import "LibrarybitdistributionViewController.h"
@interface TodayinventoryViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{
    UITableView *_KucunTableview;
    NoDataView *_NotodayinventoryView;                     //没有数据
    UIView *_totaltodayinventoryView;                      //数据统计
}

@property(nonatomic,copy)NSMutableArray *todayinventorydatalist;                 //今日库存数据
@property(nonatomic,copy)NSMutableDictionary *todayinventorydic;                 //库存详情的数据
@property(nonatomic,copy)NSMutableArray *selecttodayinventorySection;            //显示的组的集合

@property(nonatomic,copy)NSMutableArray *goodsNames;                             //商品名的集合
@property(nonatomic,strong)NSMutableArray *goodsSearchNames;                     //商品名搜索后的集合
@property(nonatomic,copy)NSMutableArray *newtodayinventoryDatalist;              //新的库存数据
@property(nonatomic, strong)UISearchController *todayinventorySearchController;  //搜索

@end

@implementation TodayinventoryViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"今日库存"];
    
    _todayinventorydatalist = [NSMutableArray array];
    _todayinventorydic = [NSMutableDictionary dictionary];
    _selecttodayinventorySection = [NSMutableArray array];
    _goodsNames = [NSMutableArray array];
    _goodsSearchNames = [NSMutableArray array];
    _newtodayinventoryDatalist = [NSMutableArray array];

    [self initKucunUI];
    [self getMykucunData];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_todayinventorySearchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_todayinventorySearchController.searchBar setHidden:YES];
    [_todayinventorySearchController setActive:NO];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.todayinventorySearchController.active) {
        return _newtodayinventoryDatalist.count;
    } else {
        return _todayinventorydatalist.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selecttodayinventorySection containsObject:string]) {
        return 1;
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
    if (self.todayinventorySearchController.active) {
        view = [self creatTableviewWithMutableArray:_newtodayinventoryDatalist Section:section];
    } else {
        view = [self creatTableviewWithMutableArray:[_todayinventorydatalist mutableCopy] Section:section];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *todayinventoryIndet = @"todayinventoryIndet";
    TodayNoleaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todayinventoryIndet];
    if (cell == nil) {
        cell = [[TodayNoleaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayinventoryIndet];
    }
    if ([_selecttodayinventorySection containsObject:indexStr]) {
        NSDictionary *mukucundic = [_todayinventorydic objectForKey:indexStr];
        cell.dic = mukucundic;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 23, 21)];
    imageView.image = [UIImage imageNamed:@"y2_b"];
    [view addSubview:imageView];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(43, 12.5, KScreenWidth - 43 - 104, 20)];
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    companyTitle.font = MainFont;
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 24, 17.5, 14, 8)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    selectView.tag = 118940 + section;
    if ([_selecttodayinventorySection containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"jiantou_a"];
    } else {
        selectView.image = [UIImage imageNamed:@"jiantou_b"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 45);
    button.tag = 14100 + section;
    [button addTarget:self action:@selector(leadtodayinventorySectionData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 24 - 10 - 60, 12.5, 60, 20)];
    Label.text = [NSString stringWithFormat:@"%@台",[mutableArray[section] valueForKey:@"col2"]];
    Label.textAlignment = NSTextAlignmentRight;
    Label.font = MainFont;
    [view addSubview:Label];
    
//    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareButton.frame = CGRectMake(KScreenWidth - 24 - 87, 12, 67, 20);
//    shareButton.clipsToBounds = YES;
//    shareButton.layer.cornerRadius = 4;
//    [shareButton setBackgroundColor:ColorRGB(255, 175, 80)];
//    [shareButton setTitle:@"一键分享" forState:UIControlStateNormal];
//    shareButton.titleLabel.font = ExtitleFont;
//    [shareButton addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
//    shareButton.tag = 1421000 + section;
//    [view addSubview:shareButton];
    
    UIView *lowLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [view addSubview:lowLineView];
    return view;
}

#pragma mark - 标题栏按钮事件
- (void)leadtodayinventorySectionData:(UIButton *)button
{
    //获取数据
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 14100];
    NSMutableArray *array;
    if (self.todayinventorySearchController.active) {
        array = _newtodayinventoryDatalist;
    } else {
        array = _todayinventorydatalist;
    }
    if ([_selecttodayinventorySection containsObject:string]) {
        [_selecttodayinventorySection removeObject:string];
        [_todayinventorydic removeObjectForKey:string];
        [_KucunTableview reloadData];
    } else {
        [_selecttodayinventorySection addObject:string];
        [_todayinventorydic setObject:array[button.tag - 14100] forKey:string];
        [_KucunTableview reloadData];
    }
}

//- (void)shareGoods:(UIButton *)button
//{
//    NSDictionary *dic;
//    if (self.todayinventorySearchController.active) {
//        dic = _newtodayinventoryDatalist[button.tag - 1421000];
//    } else {
//        dic = _todayinventorydatalist[button.tag - 1421000];
//    }
//    
//    ShareViewController *shareVC =  [[ShareViewController alloc] init];
//    shareVC.col0 = [dic valueForKey:@"col0"];
//    [self.navigationController pushViewController:shareVC animated:YES];
//    
//}


#pragma mark - 绘制UI
- (void)initKucunUI
{
    _KucunTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 60) style:UITableViewStylePlain];
    _KucunTableview.delegate = self;
    _KucunTableview.dataSource = self;
    _KucunTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _KucunTableview.backgroundColor = GrayColor;
    _KucunTableview.hidden = YES;
    _KucunTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_KucunTableview];
    
    _NotodayinventoryView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 60)];
    _NotodayinventoryView.text = @"没有库存数据";
    _NotodayinventoryView.hidden = YES;
    [self.view addSubview:_NotodayinventoryView];
    
    _todayinventorySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _todayinventorySearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _todayinventorySearchController.searchResultsUpdater = self;
    _todayinventorySearchController.searchBar.delegate = self;
    _todayinventorySearchController.dimsBackgroundDuringPresentation = NO;
    _todayinventorySearchController.hidesNavigationBarDuringPresentation = NO;
    _todayinventorySearchController.searchBar.placeholder = @"搜索";
    [_todayinventorySearchController.searchBar sizeToFit];
    [self.view addSubview:_todayinventorySearchController.searchBar];
    
    //统计的分割线
    UIView *totalViewTopLine = [BasicControls drawLineWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, .5)];
    [self.view addSubview:totalViewTopLine];
    
    //统计按钮
    _totaltodayinventoryView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 123.5, KScreenWidth, 59.5)];
    _totaltodayinventoryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totaltodayinventoryView];
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
            Label.tag = 01413202;
        } else if (i == 3) {
            Label.text = @"总成本";
            Label.frame = CGRectMake(40 + totalWidth * 2, 7, totalWidth, 16);
        } else {
            Label.frame = CGRectMake(40 + totalWidth * 2, 37, totalWidth, 16);
            Label.textColor = PriceColor;
            Label.tag = 01413204;
        }
        [_totaltodayinventoryView addSubview:Label];
    }
}

#pragma mark - 获取数据
- (void)getMykucunData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_noleadertoday];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:mykucunURL params:nil success:^(id responseObject) {
        _todayinventorydatalist = [KucunModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todayinventorydatalist.count == 0) {
            _KucunTableview.hidden = YES;
            _NotodayinventoryView.hidden = NO;
        } else {
            _NotodayinventoryView.hidden = YES;
            _KucunTableview.hidden = NO;
            NSArray *sortkucunArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
            [_todayinventorydatalist sortUsingDescriptors:sortkucunArray];
            
            [_KucunTableview reloadData];
            //统计搜索名
            if (_goodsNames.count != 0) {
                [_goodsNames removeAllObjects];
                [_selecttodayinventorySection removeAllObjects];
                [_todayinventorydic removeAllObjects];
            }
            for (NSDictionary *dic in _todayinventorydatalist) {
                [_goodsNames addObject:[dic valueForKey:@"col1"]];
            }
            [self jisuanKuncunTotalDataWithDatalist:_todayinventorydatalist];
        }
        [self hideProgress];
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.goodsSearchNames removeAllObjects];
    [self.todayinventorydic removeAllObjects];
    [self.selecttodayinventorySection removeAllObjects];
    [self.newtodayinventoryDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.todayinventorySearchController.searchBar.text];
    self.goodsSearchNames = [[self.goodsNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.goodsSearchNames) {
        for (NSDictionary *dic in self.todayinventorydatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_newtodayinventoryDatalist addObject:dic];
            }
        }
    }
    [_KucunTableview reloadData];
    
    if (_newtodayinventoryDatalist.count != 0) {
        [self jisuanKuncunTotalDataWithDatalist:_newtodayinventoryDatalist];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self jisuanKuncunTotalDataWithDatalist:_todayinventorydatalist];
}


#pragma mark - 统计数据
- (void)jisuanKuncunTotalDataWithDatalist:(NSMutableArray *)datalist
{
    float totalNum = 0,totalMoney = 0;
    totalNum = [self leijiaNumDataList:datalist Code:@"col2"];
    totalMoney = [self leijiaNumDataList:datalist Code:@"col3"];
    UILabel *label1 = (UILabel *)[_totaltodayinventoryView viewWithTag:01413202];
    UILabel *label2 = (UILabel *)[_totaltodayinventoryView viewWithTag:01413204];
    label1.text = [NSString stringWithFormat:@"%.0f",totalNum];
    label2.text = [NSString stringWithFormat:@"%.2f",totalMoney];
}


@end
