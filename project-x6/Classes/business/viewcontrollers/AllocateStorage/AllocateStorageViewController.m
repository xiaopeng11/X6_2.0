//
//  AllocateStorageViewController.m
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AllocateStorageViewController.h"

#import "AllocateStorageModel.h"
#import "AllocateStorageTableViewCell.h"
@interface AllocateStorageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NSMutableArray *_AllocateStorageDatalist;
    NSInteger _number;

    UIButton *_button;
    
    double _unsureDataPage;
    double _unsureDataPages;

}

@property(nonatomic,strong)UITableView *AllocateStorageTableView;
@property(nonatomic,strong)NoDataView *noAllocateStorageView;

@property(nonatomic,copy)NSMutableArray *AllocateStorageNames;                    //供应商名的集合
@property(nonatomic,strong)NSMutableArray *AllocateStorageSearchNames;
@property(nonatomic,copy)NSMutableArray *NewAllocateStorageDatalist;
@property(nonatomic, strong)UISearchController *AllocateStorageSearchController;
@end

@implementation AllocateStorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"调拨入库"];
    
    [self initAllocateStorageUI];
    
    _number = 0;
    _AllocateStorageNames = [NSMutableArray array];
    _AllocateStorageSearchNames = [NSMutableArray array];
    _NewAllocateStorageDatalist = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllocateStorageSure:) name:@"AllocateStorageSure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllocateStorageSure:) name:@"deleteAllocateStorageSure" object:nil];
    
    [self getAllocateStorageDataWithAllocateStorage:YES Page:0];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _AllocateStorageSearchNames = nil;
    _AllocateStorageNames = nil;
    _NewAllocateStorageDatalist = nil;
    _AllocateStorageDatalist = nil;
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
    
    _AllocateStorageSearchController.searchBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_AllocateStorageSearchController.active) {
        [_AllocateStorageSearchController resignFirstResponder];
    }
    _AllocateStorageSearchController.searchBar.hidden = YES;
    [_AllocateStorageSearchController setActive:NO];
}


#pragma mark - 绘制UI
- (void)initAllocateStorageUI
{
    //导航栏右侧按钮
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 60, 30);
    _button.titleLabel.font = RightTitleFont;
    [_button setTitle:@"取消确认" forState:UIControlStateNormal];
    _button.clipsToBounds = YES;
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(getAllocateStoragedata) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
    
    //搜索框
    _AllocateStorageSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _AllocateStorageSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _AllocateStorageSearchController.searchResultsUpdater = self;
    _AllocateStorageSearchController.searchBar.delegate = self;
    _AllocateStorageSearchController.dimsBackgroundDuringPresentation = NO;
    _AllocateStorageSearchController.hidesNavigationBarDuringPresentation = NO;
    _AllocateStorageSearchController.searchBar.placeholder = @"搜索";
    [_AllocateStorageSearchController.searchBar sizeToFit];
    _AllocateStorageSearchController.searchBar.hidden = YES;
    [self.view addSubview:_AllocateStorageSearchController.searchBar];
    
    //表示图
    [self AllocateStorageTableView];
    [self noAllocateStorageView];
    
}

- (UITableView *)AllocateStorageTableView
{
    if (_AllocateStorageTableView == nil) {
        _AllocateStorageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
        _AllocateStorageTableView.hidden = YES;
        _AllocateStorageTableView.delegate = self;
        _AllocateStorageTableView.dataSource = self;
        _AllocateStorageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _AllocateStorageTableView.backgroundColor = GrayColor;
        //添加上拉加载更多，下拉刷新
        [_AllocateStorageTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(AllocateStoragefooterAction)];
        [_AllocateStorageTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(AllocateStorageheaderAction)];
        [self.view addSubview:_AllocateStorageTableView];
    }
    return _AllocateStorageTableView;
}

- (NoDataView *)noAllocateStorageView
{
    if (_noAllocateStorageView == nil) {
        _noAllocateStorageView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _noAllocateStorageView.hidden = YES;
        [self.view addSubview:_noAllocateStorageView];
    }
    return _noAllocateStorageView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_AllocateStorageSearchController.active) {
        return _NewAllocateStorageDatalist.count;
    } else {
        return _AllocateStorageDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 + 79 + 90 + 10 + 44;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AllocateStoragecellid = @"AllocateStoragecellid";
    AllocateStorageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllocateStoragecellid];
    if (cell == nil) {
        cell = [[AllocateStorageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllocateStoragecellid];
    }
    if (_AllocateStorageSearchController.active) {
        cell.dic = _NewAllocateStorageDatalist[indexPath.row];
    } else {
        cell.dic = _AllocateStorageDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.AllocateStorageSearchNames removeAllObjects];
    [_NewAllocateStorageDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.AllocateStorageSearchController.searchBar.text];
    self.AllocateStorageSearchNames = [[self.AllocateStorageNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    NSMutableSet *AllocateStorageSet = [NSMutableSet set];
    for (NSString *title in self.AllocateStorageSearchNames) {
        for (NSDictionary *dic in _AllocateStorageDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col0"]] || [title isEqualToString:[dic valueForKey:@"col2"]] || [title isEqualToString:[dic valueForKey:@"col3"]]) {
                [AllocateStorageSet addObject:dic];
            }
        }
    }
    _NewAllocateStorageDatalist = [[AllocateStorageSet allObjects] mutableCopy];
    [_AllocateStorageTableView reloadData];
    
}

#pragma mark - 导航栏点击事件
- (void)getAllocateStoragedata
{
    if (_number == 0) {
        [_button setTitle:@"确认" forState:UIControlStateNormal];
        _number++;
        [self getAllocateStorageDataWithAllocateStorage:NO Page:1];
    } else {
        [_button setTitle:@"取消确认" forState:UIControlStateNormal];
        _number--;
        [self getAllocateStorageDataWithAllocateStorage:YES Page:0];
    }
}

#pragma mark - 通知时间
/**
 *  确认
 */
- (void)AllocateStorageSure:(NSNotification *)noti
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *AllocateStorageSureURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AllocateStorageConfirmation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:noti.object forKey:@"djh"];
    [XPHTTPRequestTool requestMothedWithPost:AllocateStorageSureURL params:params success:^(id responseObject) {
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (NSDictionary *dic in _AllocateStorageDatalist) {
            NSString *reviewID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col0"]];
            NSString *notiob = [NSString stringWithFormat:@"%@",noti.object];
            if ([reviewID isEqualToString:notiob]) {
                [deleteArray addObject:dic];
            }
        }
        [_AllocateStorageDatalist removeObjectsInArray:deleteArray];
        [_AllocateStorageTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"审核失败");
    }];
}

/**
 *  取消确认
 */
- (void)deleteAllocateStorageSure:(NSNotification *)noti
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *deleteAllocateStorageSureURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AllocateStorageCancle];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *shenheid = [NSString stringWithFormat:@"%@",noti.object];
    [params setObject:shenheid forKey:@"djh"];
    [XPHTTPRequestTool requestMothedWithPost:deleteAllocateStorageSureURL params:params success:^(id responseObject) {
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (NSDictionary *dic in _AllocateStorageDatalist) {
            NSString *reviewID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col0"]];
            NSString *notiob = [NSString stringWithFormat:@"%@",noti.object];
            if ([reviewID isEqualToString:notiob]) {
                [deleteArray addObject:dic];
            }
        }
        [_AllocateStorageDatalist removeObjectsInArray:deleteArray];
        [_AllocateStorageTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"审核失败");
    }];
}

#pragma mark - 获取数据
/**
 *  获取确认／取消确认数据
 *
 *  @param Orderreview 是确认
 */
- (void)getAllocateStorageDataWithAllocateStorage:(BOOL)allocateStorage Page:(double)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *examOrderURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (allocateStorage == YES) {
        examOrderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AllocateStorageNoSure];
    } else {
        examOrderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AllocateStorageSured];
        [params setObject:@(8) forKey:@"rows"];
        [params setObject:@(page) forKey:@"page"];
    }
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:examOrderURL params:params success:^(id responseObject) {
        [self hideProgress];

        _AllocateStorageDatalist = [AllocateStorageModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        
        if (_AllocateStorageDatalist.count == 0) {
            _noAllocateStorageView.hidden = NO;
            _noAllocateStorageView.text = @"没有数据";
            _AllocateStorageTableView.hidden = YES;
            _AllocateStorageSearchController.searchBar.hidden = YES;
        } else {
            _AllocateStorageTableView.hidden = NO;
            _AllocateStorageSearchController.searchBar.hidden = NO;
            _noAllocateStorageView.hidden = YES;
            if (allocateStorage) {
                _unsureDataPage = [responseObject[@"page"] doubleValue];
                _unsureDataPages = [responseObject[@"pages"] doubleValue];
            }
            for (int i = 0; i < _AllocateStorageDatalist.count; i++) {
                NSDictionary *dic = _AllocateStorageDatalist[i];
                NSMutableDictionary *adddic = [NSMutableDictionary dictionaryWithDictionary:dic];
                NSNumber *isexam = [NSNumber numberWithBool:allocateStorage];
                [adddic setObject:isexam forKey:@"isexam"];
                [_AllocateStorageDatalist replaceObjectAtIndex:i withObject:adddic];
            }
            //日期排序
            NSArray *salesdepositArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
            [_AllocateStorageDatalist sortUsingDescriptors:salesdepositArray];
            [_AllocateStorageTableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _AllocateStorageDatalist) {
                    [_AllocateStorageNames addObject:[dic valueForKey:@"col0"]];
                    [_AllocateStorageNames addObject:[dic valueForKey:@"col2"]];
                    [_AllocateStorageNames addObject:[dic valueForKey:@"col3"]];
                    
                }
            });
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"数据获取失败");
    }];
}



#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head
{
    if (head == YES) {
        //是下拉刷新
        if (_number == 0) {
            [self getAllocateStorageDataWithAllocateStorage:YES Page:0];
        } else {
            [self getAllocateStorageDataWithAllocateStorage:NO Page:1];
        }
    } else {
        //上拉加载更多
        if (_number == 0) {
            if (_unsureDataPage <= _unsureDataPages - 1) {
                [self getAllocateStorageDataWithAllocateStorage:YES Page:0];
            } else {
                [_AllocateStorageTableView.footer noticeNoMoreData];
            }
        } else {
            if (_unsureDataPage <= _unsureDataPages - 1) {
                [self getAllocateStorageDataWithAllocateStorage:NO Page:1];
            } else {
                [_AllocateStorageTableView.footer noticeNoMoreData];
            }
        }

    }
}

#pragma mark - 下拉刷新，上拉加载更多
- (void)AllocateStoragefooterAction
{
    [self getrefreshdataWithHead:NO];
}

- (void)AllocateStorageheaderAction
{
    [self getrefreshdataWithHead:YES];
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(UITableView *)hometableview
{
    if (_AllocateStorageTableView.header.isRefreshing) {
        //正在下拉刷新
        [_AllocateStorageTableView.header endRefreshing];
        [_AllocateStorageTableView.footer resetNoMoreData];
    } else {
        [_AllocateStorageTableView.footer endRefreshing];
    }
}

@end
