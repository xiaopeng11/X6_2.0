//
//  WhetherOrderViewController.m
//  project-x6
//
//  Created by Apple on 16/8/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "WhetherOrderViewController.h"
#import "DepositModel.h"
#import "DepositWhetherOrderTableViewCell.h"
@interface WhetherOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>


{
    NSInteger _number;
    
    UIButton *_button;
    
    double _page;
    double _pages;
}

@property(nonatomic,strong)UITableView *WhetherOrderTableview;                 //供应商表示图
@property(nonatomic,strong)NoDataView *NoWhetherOrderView;                     //没有供应商


@property(nonatomic,copy)NSMutableArray *WhetherOrderDatalist;                  //供应商的集合


@property(nonatomic,copy)NSMutableArray *WhetherOrderNames;                    //供应商名的集合
@property(nonatomic,strong)NSMutableArray *WhetherOrderSearchNames;
@property(nonatomic,copy)NSMutableArray *NewWhetherOrderDatalist;
@property(nonatomic, strong)UISearchController *WhetherOrderSearchController;
@end

@implementation WhetherOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self naviTitleWhiteColorWithText:@"到账处理"];
    
    [self initWhetherOrderUI];
    
    _WhetherOrderNames = [NSMutableArray array];
    _WhetherOrderSearchNames = [NSMutableArray array];
    _NewWhetherOrderDatalist = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(depositrevokeAction:) name:@"depositrevokeAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(depositorderAction:) name:@"depositorderAction" object:nil];
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
    
    _WhetherOrderSearchController.searchBar.hidden = NO;
    
    _number = 0;
    
    [self getdepositOrderreviewDataWithOrderreview:YES Page:1];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_WhetherOrderSearchController.searchBar isFirstResponder]) {
        [_WhetherOrderSearchController.searchBar resignFirstResponder];
    }
    _WhetherOrderSearchController.searchBar.hidden = YES;
    [_WhetherOrderSearchController setActive:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _WhetherOrderDatalist = nil;
    _WhetherOrderNames = nil;
    _WhetherOrderSearchNames = nil;
    _NewWhetherOrderDatalist = nil;
}

#pragma mark - 绘制UI
- (void)initWhetherOrderUI
{
    //导航栏右侧按钮
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 60, 30);
    [_button setTitle:@"取消到账" forState:UIControlStateNormal];
    _button.titleLabel.font = RightTitleFont;
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(getdepositrevokeorderdata) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
    
    
    //搜索框
    _WhetherOrderSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _WhetherOrderSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _WhetherOrderSearchController.searchResultsUpdater = self;
    _WhetherOrderSearchController.searchBar.delegate = self;
    _WhetherOrderSearchController.dimsBackgroundDuringPresentation = NO;
    _WhetherOrderSearchController.hidesNavigationBarDuringPresentation = NO;
    _WhetherOrderSearchController.searchBar.placeholder = @"搜索";
    [_WhetherOrderSearchController.searchBar sizeToFit];
    _WhetherOrderSearchController.searchBar.hidden = YES;
    [self.view addSubview:_WhetherOrderSearchController.searchBar];
    
    //表示图
    [self WhetherOrderTableview];
    [self NoWhetherOrderView];
    
}

- (UITableView *)WhetherOrderTableview
{
    if (_WhetherOrderTableview== nil) {
        _WhetherOrderTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
        _WhetherOrderTableview.hidden = YES;
        _WhetherOrderTableview.delegate = self;
        _WhetherOrderTableview.dataSource = self;
        _WhetherOrderTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_WhetherOrderTableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getmoreOrderDatalist)];
        
        [self.view addSubview:_WhetherOrderTableview];
    }
    return _WhetherOrderTableview;
}

- (NoDataView *)NoWhetherOrderView

{
    if (_NoWhetherOrderView == nil) {
        _NoWhetherOrderView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 44)];
        _NoWhetherOrderView.hidden = YES;
        [self.view addSubview:_NoWhetherOrderView];
    }
    
    return _NoWhetherOrderView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_WhetherOrderSearchController.active) {
        return _NewWhetherOrderDatalist.count;
    } else {
        return _WhetherOrderDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[_WhetherOrderDatalist[indexPath.row] valueForKey:@"rowheight"] floatValue];
    return height;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *depositOrderreviewcellid = @"depositOrderreviewcellid";
    DepositWhetherOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DepositWhetherOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:depositOrderreviewcellid];
    }
    if (_number % 2 == 0) {
        cell.orderDeposit = @"到账处理";
    } else {
        cell.orderDeposit = @"取消到账";
    }
    if (_WhetherOrderSearchController.active) {
        cell.dic = _NewWhetherOrderDatalist[indexPath.row];
    } else {
        cell.dic = _WhetherOrderDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.WhetherOrderSearchNames removeAllObjects];
    [_NewWhetherOrderDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.WhetherOrderSearchController.searchBar.text];
    self.WhetherOrderSearchNames = [[self.WhetherOrderNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    NSMutableSet *orderreviewSet = [NSMutableSet set];
    for (NSString *title in self.WhetherOrderSearchNames) {        
        for (NSDictionary *dic in _WhetherOrderDatalist)
        {
            if ([title isEqualToString:[dic valueForKey:@"ssgsname"]]) {
                [orderreviewSet addObject:dic];
            } else {
                NSArray *array = [dic valueForKey:@"rows"];
                for (NSDictionary *diced in array) {
                    if ([title isEqualToString:[diced valueForKey:@"zhname"]]) {
                        [orderreviewSet addObject:dic];
                    }
                }
            }

        }
    }
    _NewWhetherOrderDatalist = [[orderreviewSet allObjects] mutableCopy];
    [_WhetherOrderTableview reloadData];
    
}

#pragma mark - 导航栏点击事件
- (void)getdepositrevokeorderdata
{
    if (_number % 2 == 0) {
        [self naviTitleWhiteColorWithText:@"取消到账"];
        [_button setTitle:@"到账处理" forState:UIControlStateNormal];
        _number++;
        [self getdepositOrderreviewDataWithOrderreview:YES Page:1];
    } else {
        [self naviTitleWhiteColorWithText:@"到账处理"];
        [_button setTitle:@"取消到账" forState:UIControlStateNormal];
        _number--;
        [self getdepositOrderreviewDataWithOrderreview:NO Page:1];
        
    }
}

#pragma mark - 通知时间
/**
 *  审核
 */
- (void)depositorderAction:(NSNotification *)noti
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *orderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_depositexamineOrder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:noti.object forKey:@"djh"];
    [XPHTTPRequestTool requestMothedWithPost:orderURL params:params success:^(id responseObject) {
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (NSDictionary *dic in _WhetherOrderDatalist) {
            NSString *reviewID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"djh"]];
            NSString *notiob = [NSString stringWithFormat:@"%@",noti.object];
            if ([reviewID isEqualToString:notiob]) {
                [deleteArray addObject:dic];
            }
        }
        [_WhetherOrderDatalist removeObjectsInArray:deleteArray];
        [_WhetherOrderTableview reloadData];
    
    } failure:^(NSError *error) {
        NSLog(@"审核失败");
    }];
}

/**
 *  撤审
 */
- (void)depositrevokeAction:(NSNotification *)noti
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *orderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_depositrevokeOrder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *shenheid = [NSString stringWithFormat:@"%@",noti.object];
    [params setObject:shenheid forKey:@"djh"];
    [XPHTTPRequestTool requestMothedWithPost:orderURL params:params success:^(id responseObject) {
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (NSDictionary *dic in _WhetherOrderDatalist) {
            NSString *reviewID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"djh"]];
            NSString *notiob = [NSString stringWithFormat:@"%@",noti.object];
            if ([reviewID isEqualToString:notiob]) {
                [deleteArray addObject:dic];
            }
        }
        [_WhetherOrderDatalist removeObjectsInArray:deleteArray];
        [_WhetherOrderTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"审核失败");
    }];
}

#pragma mark - 获取数据
/**
 *  获取审核／撤审数据
 *
 *  @param Orderreview 是审核
 */
- (void)getdepositOrderreviewDataWithOrderreview:(BOOL)Orderreview
                                            Page:(NSInteger)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *examOrderURL;
    if (Orderreview == YES) {
        examOrderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_depositnoOrder];
    } else {
        examOrderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_depositOrder];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(8) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:examOrderURL params:params success:^(id responseObject) {
        [self hideProgress];
        if ([_WhetherOrderTableview.footer isRefreshing]) {
            [_WhetherOrderTableview.footer endRefreshing];
            NSArray *array = [DepositModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
            _WhetherOrderDatalist = [[_WhetherOrderDatalist arrayByAddingObjectsFromArray:array] mutableCopy];
            if ([[responseObject valueForKey:@"rows"] count] < 8 || [[responseObject valueForKey:@"page"] doubleValue] == [[responseObject valueForKey:@"pages"] doubleValue]) {
                [_WhetherOrderTableview.footer noticeNoMoreData];
            }
        } else {
            _WhetherOrderDatalist = [DepositModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        }
        if (_WhetherOrderDatalist.count == 0) {
            _NoWhetherOrderView.hidden = NO;
            if (_number % 2 == 0) {
                _NoWhetherOrderView.text = @"没有需要确认到账的数据";
            } else {
                _NoWhetherOrderView.text = @"没有需要取消到账的数据";
            }
            _WhetherOrderTableview.hidden = YES;
            _WhetherOrderSearchController.searchBar.hidden = YES;
        } else {
            _WhetherOrderTableview.hidden = NO;
            _WhetherOrderSearchController.searchBar.hidden = NO;
            _NoWhetherOrderView.hidden = YES;
            
            _page = [responseObject[@"page"] doubleValue];
            _pages = [responseObject[@"pages"] doubleValue];
            
            
            NSArray *depositArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"djh" ascending:NO]];
            [_WhetherOrderDatalist sortUsingDescriptors:depositArray];
            
            //增加高度参数
            for (int i = 0; i < _WhetherOrderDatalist.count; i++) {
                NSDictionary *dic = _WhetherOrderDatalist[i];
                NSArray *acounts = [dic valueForKey:@"rows"];
                CGFloat rowhight;
                rowhight = 10 + 45 + 116 + acounts.count * 35;
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:dic];
                [diced setObject:@(rowhight) forKey:@"rowheight"];
                [_WhetherOrderDatalist replaceObjectAtIndex:i withObject:diced];
            }
            
            [_WhetherOrderTableview reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _WhetherOrderDatalist) {
                    [_WhetherOrderNames addObject:[dic valueForKey:@"ssgsname"]];
                    NSArray *array = [dic valueForKey:@"rows"];
                    for (NSDictionary *diced in array) {
                        [_WhetherOrderNames addObject:[diced valueForKey:@"zhname"]];
                    }
                }
            });
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"数据获取失败");
    }];
}

#pragma mark - 加载更多
- (void)getmoreOrderDatalist
{
    if (_page < _pages) {
        [self getdepositOrderreviewDataWithOrderreview:NO Page:(_page + 1)];
    } else {
        [_WhetherOrderTableview.footer noticeNoMoreData];
    }
}

@end
