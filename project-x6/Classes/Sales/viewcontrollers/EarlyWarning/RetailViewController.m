//
//  RetailViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RetailViewController.h"
#import "XPItemsControlView.h"
#import "KucunTitle.h"

#import "NoDataView.h"

#import "RetailModel.h"
#import "RetailTableViewCell.h"

@interface RetailViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UIScrollViewDelegate,UITextFieldDelegate>

{
    XPItemsControlView *_SplxitemsControlView;   //眉头
    UIScrollView *_RetailscrollView;               //首页滑动式图
    int _SplxIndex;
    
    NSMutableArray *_ReatilDatalist;
}
@property(nonatomic,copy)NSMutableArray *Splxdatalist;                   //库存数据
@property(nonatomic,copy)NSMutableArray *Splxtitles;

@property(nonatomic,copy)NSMutableArray *ReatilNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *ReatilSearchNames;
@property(nonatomic,copy)NSMutableArray *NewReatilDatalist;
@property(nonatomic, strong)UISearchController *ReatilSearchController;

@end

@implementation RetailViewController

- (void)dealloc
{
    _ReatilNames = nil;
    _ReatilSearchNames = nil;
    _NewReatilDatalist = nil;
    _ReatilDatalist = nil;
    _Splxdatalist = nil;
    _Splxtitles = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"售价异常"];

    if (!_ishow) {
        UIView *noRetailview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"售价异常"];
        [self.view addSubview:noRetailview];
    } else {
        _ReatilNames = [NSMutableArray array];
        _ReatilSearchNames = [NSMutableArray array];
        _NewReatilDatalist = [NSMutableArray array];
        _Splxdatalist = [NSMutableArray array];
        _Splxtitles = [NSMutableArray array];
        _SplxIndex = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ignoreRetaildataList:) name:@"ignoreRetailData" object:nil];

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
            [self initRetailUI];
            //获取数据
            [self getRetailDatalistWithSplx:_Splxdatalist[_SplxIndex]];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_ReatilSearchController.searchBar setHidden:NO];
    [self cleanRetailWarningNumber];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_ReatilSearchController.searchBar setHidden:YES];
    [_ReatilSearchController setActive:NO];
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

#pragma mark - 绘制售价异常lUI
- (void)initRetailUI
{
    //scrollview
    _RetailscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 64 - 84)];
    _RetailscrollView.delegate = self;
    _RetailscrollView.pagingEnabled = YES;
    _RetailscrollView.showsHorizontalScrollIndicator = NO;
    _RetailscrollView.showsVerticalScrollIndicator = NO;
    _RetailscrollView.contentSize = CGSizeMake(KScreenWidth * _Splxtitles.count, KScreenHeight - 64 - 84);
    _RetailscrollView.bounces = NO;
    for (int i = 0; i < _Splxtitles.count; i++) {
        UITableView *RetailTableview = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 84) style:UITableViewStylePlain];
        RetailTableview.delegate = self;
        RetailTableview.dataSource = self;
        RetailTableview.tag = 431000 + i;
        RetailTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        RetailTableview.backgroundColor = GrayColor;
        RetailTableview.hidden = YES;
        RetailTableview.separatorStyle = UITableViewCellAccessoryNone;
        [_RetailscrollView addSubview:RetailTableview];
        
        NoDataView *noRetailView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 84)];
        noRetailView.text = @"没有异常数据";
        noRetailView.tag = 431100 + i;
        noRetailView.hidden = YES;
        [_RetailscrollView addSubview:noRetailView];
        
    }
    [self.view addSubview:_RetailscrollView];
    
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
    
    __weak typeof (_RetailscrollView)weakScrollView = _RetailscrollView;
    [_SplxitemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_SplxitemsControlView];
    
    //搜索框
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 44)];
    [self.view addSubview:view];
    _ReatilSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _ReatilSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _ReatilSearchController.searchResultsUpdater = self;
    _ReatilSearchController.searchBar.delegate = self;
    _ReatilSearchController.dimsBackgroundDuringPresentation = NO;
    _ReatilSearchController.hidesNavigationBarDuringPresentation = NO;
    _ReatilSearchController.searchBar.placeholder = @"搜索";
    [_ReatilSearchController.searchBar sizeToFit];
    [view addSubview:_ReatilSearchController.searchBar];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.ReatilSearchController.active) {
        return _NewReatilDatalist.count;
    } else {
        return _ReatilDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 305;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Reatilident = @"Reatilident";
    RetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Reatilident];
    if (cell == nil) {
        cell = [[RetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Reatilident];
    }
    if (self.ReatilSearchController.active) {
        cell.dic = _NewReatilDatalist[indexPath.row];
    } else {
        cell.dic = _ReatilDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.ReatilSearchNames removeAllObjects];
    [self.NewReatilDatalist removeAllObjects];
    NSPredicate *ReatilPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.ReatilSearchController.searchBar.text];
    self.ReatilSearchNames = [[self.ReatilNames filteredArrayUsingPredicate:ReatilPredicate] mutableCopy];
    NSMutableSet *reatilSet = [NSMutableSet set];
    for (NSString *title in self.ReatilSearchNames) {
        for (NSDictionary *dic in _ReatilDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col3"]] || [title isEqualToString:[dic valueForKey:@"col4"]]) {
                [reatilSet addObject:dic];
            }
        }
    }
    _NewReatilDatalist = [[reatilSet allObjects] mutableCopy];
    [self refreshRetailTableView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_RetailscrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_SplxitemsControlView moveToIndex:offset];
        if (offset != _SplxIndex) {
            _SplxIndex = offset;
            [self getRetailDatalistWithSplx:[_Splxdatalist[offset] valueForKey:@"bm"]];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_RetailscrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_SplxitemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - 获取数据
/**
 *  获取零售异常数据
 *
 *  @param splx  商品类型
 */
- (void)getRetailDatalistWithSplx:(NSString *)splx
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *RetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Retail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:splx forKey:@"splx"];
    //获取表示图
    UITableView *RetailTableView = (UITableView *)[_RetailscrollView viewWithTag:431000 + _SplxIndex];
    NoDataView *NoRetailView = (NoDataView *)[_RetailscrollView viewWithTag:431100 + _SplxIndex];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:RetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        _ReatilDatalist = [RetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_ReatilDatalist.count == 0) {
            RetailTableView.hidden = YES;
            _ReatilSearchController.searchBar.hidden = YES;
            NoRetailView.hidden = NO;
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _ReatilDatalist) {
                if ([[dic valueForKey:@"col10"] boolValue] == 1) {
                    [array addObject:dic];
                }
            }
            [_ReatilDatalist removeObjectsInArray:array];
            
            if (_ReatilDatalist.count != 0) {
                NoRetailView.hidden = YES;
                RetailTableView.hidden = NO;
                _ReatilSearchController.searchBar.hidden = NO;
                NSArray *ReatilArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
                [_ReatilDatalist sortUsingDescriptors:ReatilArray];
                [RetailTableView reloadData];
                
                if (_ReatilNames.count != 0) {
                    [_ReatilNames removeAllObjects];
                }
                for (NSDictionary *dic in _ReatilDatalist) {
                    [_ReatilNames addObject:[dic valueForKey:@"col1"]];
                    [_ReatilNames addObject:[dic valueForKey:@"col3"]];
                    [_ReatilNames addObject:[dic valueForKey:@"col4"]];
                }
            } else {
                RetailTableView.hidden = YES;
                _ReatilSearchController.searchBar.hidden = YES;
                NoRetailView.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"获取零售异常失败");
    }];
}

/**
 *  清除零售异常条数
 */
- (void)cleanRetailWarningNumber
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *removeWarningNumberURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_removeWarningNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"LSYC" forKey:@"txlx"];
    [XPHTTPRequestTool requestMothedWithPost:removeWarningNumberURL params:params success:^(id responseObject) {
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark - 刷新表示图
- (void)refreshRetailTableView
{
    UITableView *retailTableView = (UITableView *)[_RetailscrollView viewWithTag:431000 + _SplxIndex];
    [retailTableView reloadData];
}

#pragma mark - 通知事件: 忽略
- (void)ignoreRetaildataList:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    
    UIAlertController *ignoreAction = [UIAlertController alertControllerWithTitle:@"是否忽略？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
        NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
        NSString *ignoreURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_ignore];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSNumber *djid = [dic valueForKey:@"col0"];
        NSNumber *djh = [dic valueForKey:@"col1"];
        [params setObject:djid forKey:@"djid"];
        [params setObject:djh forKey:@"djh"];
        [params setObject:@"LSYC" forKey:@"txlx"];
        [XPHTTPRequestTool requestMothedWithPost:ignoreURL params:params success:^(id responseObject) {
            NSLog(@"采购异常忽略成功");
            if (_ReatilSearchController.active) {
                [_NewReatilDatalist removeObject:dic];
            } else {
                [_ReatilDatalist removeObject:dic];
            }
            [self refreshRetailTableView];
        } failure:^(NSError *error) {
            NSLog(@"采购异常忽略失败");
        }];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ignoreAction addAction:cancleAction];
    [ignoreAction addAction:okAction];
    [self presentViewController:ignoreAction animated:YES completion:nil];
}

@end
