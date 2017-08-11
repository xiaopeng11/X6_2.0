//
//  OldlibraryViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibraryViewController.h"

#import "XPItemsControlView.h"
#import "KucunTitle.h"

#import "NoDataView.h"

#import "OldlibraryModel.h"
#import "OldlibraryDetailModel.h"
#import "OldlibraryTabelView.h"

@interface OldlibraryViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UIScrollViewDelegate,UITextFieldDelegate>

{
    XPItemsControlView *_SplxitemsControlView;   //眉头
    UIScrollView *_OldlibraryscrollView;               //首页滑动式图
    int _SplxIndex;
    

    UIView *_totalOldlibraryView;
    NSMutableArray *_OldlibraryDatalist;
}

@property(nonatomic,copy)NSMutableArray *Splxdatalist;                   //库存数据
@property(nonatomic,copy)NSMutableArray *Splxtitles;

@property(nonatomic,copy)NSMutableArray *OldlibraryNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *OldlibrarySearchNames;
@property(nonatomic,copy)NSMutableArray *NewOldlibraryDatalist;
@property(nonatomic, strong)UISearchController *OldlibrarySearchController;
@end

@implementation OldlibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"库龄逾期"];
    
    _OldlibraryNames = [NSMutableArray array];
    _OldlibrarySearchNames = [NSMutableArray array];
    _NewOldlibraryDatalist = [NSMutableArray array];
    _Splxdatalist = [NSMutableArray array];
    _Splxtitles = [NSMutableArray array];
    _SplxIndex = 0;

    
    //获取库存头数据
    dispatch_group_t maingroup = dispatch_group_create();
    dispatch_group_enter(maingroup);
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucuntitleURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunTitle];
    [XPHTTPRequestTool requestMothedWithPost:mykucuntitleURL params:nil success:^(id responseObject) {
        _Splxdatalist = [KucunTitle mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        NSDictionary *dic = @{@"bm":@"",@"name":@"全部"};
        [_Splxdatalist insertObject:dic atIndex:0];
        for (NSDictionary *dic in _Splxdatalist) {
            [_Splxtitles addObject:[dic valueForKey:@"name"]];
        }
        dispatch_group_leave(maingroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(maingroup);
    }];
    
    dispatch_group_notify(maingroup, dispatch_get_main_queue(), ^{
        //绘制UI
        [self initOldlibraryUI];
        //获取数据
        [self getOldlibraryDataWithSplx:_Splxdatalist[_SplxIndex]];
    });

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
    [_OldlibrarySearchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_OldlibrarySearchController.searchBar setHidden:YES];
    [_OldlibrarySearchController setActive:NO];
}

#pragma mark - 绘制库龄逾期UI
- (void)initOldlibraryUI
{
    //scrollview
    _OldlibraryscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 60 - 64 - 84)];
    _OldlibraryscrollView.delegate = self;
    _OldlibraryscrollView.pagingEnabled = YES;
    _OldlibraryscrollView.showsHorizontalScrollIndicator = NO;
    _OldlibraryscrollView.showsVerticalScrollIndicator = NO;
    _OldlibraryscrollView.contentSize = CGSizeMake(KScreenWidth * _Splxtitles.count, KScreenHeight - 60 - 64 - 84);
    _OldlibraryscrollView.bounces = NO;
    for (int i = 0; i < _Splxtitles.count; i++) {
        UITableView *OldlibraryTableview = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 60 - 84) style:UITableViewStylePlain];
        OldlibraryTableview.delegate = self;
        OldlibraryTableview.dataSource = self;
        OldlibraryTableview.tag = 441000 + i;
        OldlibraryTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        OldlibraryTableview.backgroundColor = GrayColor;
        OldlibraryTableview.hidden = YES;
        OldlibraryTableview.separatorStyle = UITableViewCellAccessoryNone;
        [_OldlibraryscrollView addSubview:OldlibraryTableview];
        
        NoDataView *noOldlibraryView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 60 - 84)];
        noOldlibraryView.text = @"没有异常数据";
        noOldlibraryView.tag = 441100 + i;
        noOldlibraryView.hidden = YES;
        [_OldlibraryscrollView addSubview:noOldlibraryView];
        
    }
    [self.view addSubview:_OldlibraryscrollView];
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    if (KScreenWidth / _Splxtitles.count > 57) {
        config.itemWidth = KScreenWidth / _Splxtitles.count;
    } else {
        config.itemWidth = 57;
    }
    _SplxitemsControlView = [[XPItemsControlView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    _SplxitemsControlView.tapAnimation = NO;
    _SplxitemsControlView.backgroundColor = [UIColor whiteColor];
    _SplxitemsControlView.config = config;
    _SplxitemsControlView.titleArray = _Splxtitles;
    
    __weak typeof (_OldlibraryscrollView)weakScrollView = _OldlibraryscrollView;
    [_SplxitemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_SplxitemsControlView];
    
    //搜索框
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 44)];
    [self.view addSubview:view];
    _OldlibrarySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _OldlibrarySearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _OldlibrarySearchController.searchResultsUpdater = self;
    _OldlibrarySearchController.searchBar.delegate = self;
    _OldlibrarySearchController.dimsBackgroundDuringPresentation = NO;
    _OldlibrarySearchController.hidesNavigationBarDuringPresentation = NO;
    _OldlibrarySearchController.searchBar.placeholder = @"搜索";
    [_OldlibrarySearchController.searchBar sizeToFit];
    [view addSubview:_OldlibrarySearchController.searchBar];
    
    //统计的分割线
    UIView *totalViewTopLine = [BasicControls drawLineWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, .5)];
    [self.view addSubview:totalViewTopLine];
    
    //统计按钮
    _totalOldlibraryView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
    _totalOldlibraryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totalOldlibraryView];
    
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
            Label.text = @"总金额";
        } else if (i == 4) {
            Label.frame = CGRectMake(60 + totalWidth * 2, 37, totalWidth, 16);
            Label.textColor = PriceColor;
        }
        Label.tag = 46010 + i;
        [_totalOldlibraryView addSubview:Label];
    }
    
    UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
    [_totalOldlibraryView addSubview:lineView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.OldlibrarySearchController.active) {
        return _NewOldlibraryDatalist.count;
    } else {
        return _OldlibraryDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 229;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Oldlibraryindet = @"Oldlibraryindet";
    OldlibraryTabelView *cell = [tableView dequeueReusableCellWithIdentifier:Oldlibraryindet];
    if (cell == nil) {
        cell = [[OldlibraryTabelView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Oldlibraryindet];
    }
    if (self.OldlibrarySearchController.active) {
        cell.dic = _NewOldlibraryDatalist[indexPath.row];
    } else {
        cell.dic = _OldlibraryDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.OldlibrarySearchNames removeAllObjects];
    [self.NewOldlibraryDatalist removeAllObjects];
    NSPredicate *ReatilPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.OldlibrarySearchController.searchBar.text];
    self.OldlibrarySearchNames = [[self.OldlibraryNames filteredArrayUsingPredicate:ReatilPredicate] mutableCopy];
    NSMutableSet *reatilSet = [NSMutableSet set];
    for (NSString *title in self.OldlibrarySearchNames) {
        for (NSDictionary *dic in _OldlibraryDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col3"]]) {
                [reatilSet addObject:dic];
            }
        }
    }
    _NewOldlibraryDatalist = [[reatilSet allObjects] mutableCopy];
    
    [self refreshOldLibraryTabelView];
    if (_NewOldlibraryDatalist.count != 0) {
        [self totalOldlibraryViewWithDatalist:_NewOldlibraryDatalist];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self totalOldlibraryViewWithDatalist:_OldlibraryDatalist];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_OldlibraryscrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_SplxitemsControlView moveToIndex:offset];
        if (offset != _SplxIndex) {
            _SplxIndex = offset;
            [self getOldlibraryDataWithSplx:[_Splxdatalist[offset] valueForKey:@"bm"]];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_OldlibraryscrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_SplxitemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - 获取数据
/**
 *  获取库龄预警数据
 *
 *  @param splx  商品类型
 */
- (void)getOldlibraryDataWithSplx:(NSString *)splx
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *OldlibraryURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Oldlibrary];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:splx forKey:@"splx"];
    //获取表示图
    UITableView *OldlibraryTableView = (UITableView *)[_OldlibraryscrollView viewWithTag:441000 + _SplxIndex];
    NoDataView *NoOldlibraryView = (NoDataView *)[_OldlibraryscrollView viewWithTag:441100 + _SplxIndex];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:OldlibraryURL params:params success:^(id responseObject) {
        [self hideProgress];
        _OldlibraryDatalist = [OldlibraryModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_OldlibraryDatalist.count == 0) {
            OldlibraryTableView.hidden = YES;
            _OldlibrarySearchController.searchBar.hidden = YES;
            NoOldlibraryView.hidden = NO;
        } else {
            NoOldlibraryView.hidden = YES;
            OldlibraryTableView.hidden = NO;
            _OldlibrarySearchController.searchBar.hidden = NO;
            
            NSArray *arrayDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"col5" ascending:NO], nil];
            [_OldlibraryDatalist sortUsingDescriptors:arrayDescriptors];
            
            if (_OldlibraryNames.count != 0) {
                [_OldlibraryNames removeAllObjects];
            }
            for (NSDictionary *dic in _OldlibraryDatalist) {
                [_OldlibraryNames addObject:[dic valueForKey:@"col1"]];
                [_OldlibraryNames addObject:[dic valueForKey:@"col3"]];
            }
            
            [OldlibraryTableView reloadData];
            [self totalOldlibraryViewWithDatalist:_OldlibraryDatalist];
            
        }
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}


#pragma mark - 刷新表示图
- (void)refreshOldLibraryTabelView
{
    UITableView *OldlibraryTableView = (UITableView *)[_OldlibraryscrollView viewWithTag:441000 + _SplxIndex];
    [OldlibraryTableView reloadData];
}

#pragma mark - 统计
- (void)totalOldlibraryViewWithDatalist:(NSMutableArray *)datalist
{
    if (datalist.count != 0) {
        float totalMoney = 0,totalnum = 0;
        totalMoney = [self leijiaNumDataList:datalist Code:@"col7"];
        totalnum = [self leijiaNumDataList:datalist Code:@"col6"];
        UILabel *label1 = (UILabel *)[_totalOldlibraryView viewWithTag:46012];
        UILabel *label2 = (UILabel *)[_totalOldlibraryView viewWithTag:46014];
        label1.text = [NSString stringWithFormat:@"%.0f台",totalnum];
        label2.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    }
}

@end
