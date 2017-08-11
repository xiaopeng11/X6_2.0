//
//  VIPViewController.m
//  project-x6
//
//  Created by Apple on 16/9/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VIPViewController.h"

#import "VIPModel.h"
#import "VIPTableViewCell.h"

#import "NewOrMoreMessageVIPViewController.h"
@interface VIPViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{
    NSArray *_VIPDatalist;
    
    UITableView *_VIPTableView;
}

@property(nonatomic,assign)double page;
@property(nonatomic,assign)double pages;

@property(nonatomic,strong)NoDataView *noVIPView;

@property(nonatomic,copy)NSMutableArray *searchKeys;                     //门店名集合
@property(nonatomic,copy)NSMutableArray *NewVIPDatalist;
@property(nonatomic,strong)NSMutableArray *NewsearchKeys;
@property(nonatomic,strong)UISearchController *MyVIPSearchController;
@end

@implementation VIPViewController

- (NoDataView *)noVIPView
{
    if (!_noVIPView) {
        _noVIPView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
        _noVIPView.text = @"您还没有会员";
        _noVIPView.hidden = YES;
        [self.view addSubview:_noVIPView];
    }
    return _noVIPView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"会员信息"];
    
    if (!_isshow) {
        UIView *noTodayMoneyview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"会员信息"];
        [self.view addSubview:noTodayMoneyview];
    } else {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"新增" target:self action:@selector(AddNewVIP)];
        
        _searchKeys = [NSMutableArray array];
        _NewVIPDatalist = [NSMutableArray array];
        _NewsearchKeys = [NSMutableArray array];
        
        //绘制UI
        [self initWithVIPView];
        
        [self getMyVIPDataWithPage:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VIPheaderAction) name:@"addNewVipSuccess" object:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.MyVIPSearchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.MyVIPSearchController.searchBar setHidden:YES];
    [_MyVIPSearchController setActive:NO];
}

#pragma mark - 绘制UI
- (void)initWithVIPView
{
    //搜索框
    _MyVIPSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _MyVIPSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _MyVIPSearchController.searchResultsUpdater = self;
    _MyVIPSearchController.searchBar.delegate = self;
    _MyVIPSearchController.dimsBackgroundDuringPresentation = NO;
    _MyVIPSearchController.hidesNavigationBarDuringPresentation = NO;
    _MyVIPSearchController.searchBar.placeholder = @"搜索";
    [_MyVIPSearchController.searchBar sizeToFit];
    [self.view addSubview:_MyVIPSearchController.searchBar];    
    
    _VIPTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _VIPTableView.delegate = self;
    _VIPTableView.dataSource = self;
    _VIPTableView.backgroundColor = GrayColor;
    _VIPTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _VIPTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加上拉加载更多，下拉刷新
    [_VIPTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(VIPfooterAction)];
    [_VIPTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(VIPheaderAction)];
    [self.view addSubview:_VIPTableView];
}

#pragma mark - 获取数据
- (void)getMyVIPDataWithPage:(double)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *myacountURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_VIPList];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(8) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:myacountURL params:params success:^(id responseObject) {
        [self hideProgress];
        if (_VIPTableView.header.isRefreshing || _VIPTableView.footer.isRefreshing) {
            [self endrefreshWithTableView:_VIPTableView];
        }
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [_VIPTableView.footer noticeNoMoreData];
        }
        
        _page = [[responseObject valueForKey:@"page"] doubleValue];
        _pages = [[responseObject valueForKey:@"pages"] doubleValue];
        
        if (_VIPDatalist.count == 0 || _VIPTableView.header.isRefreshing) {
            _VIPDatalist = [VIPModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        } else {
            _VIPDatalist = [_VIPDatalist arrayByAddingObjectsFromArray:[VIPModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]]];
        }
        if (_VIPDatalist.count == 0) {
            _noVIPView.hidden = NO;
            _VIPTableView.hidden = YES;
        } else {
            _noVIPView.hidden = YES;
            _VIPTableView.hidden = NO;
            NSArray *sorttodaysalesArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col0" ascending:NO]];
            NSMutableArray *array  = [NSMutableArray arrayWithArray:_VIPDatalist];
            [array sortUsingDescriptors:sorttodaysalesArray];
            _VIPDatalist = [array mutableCopy];
            [_VIPTableView reloadData];
            for (NSDictionary *dic in _VIPDatalist) {
                [_searchKeys addObject:[dic valueForKey:@"col1"]];
                [_searchKeys addObject:[dic valueForKey:@"col2"]];
                [_searchKeys addObject:[dic valueForKey:@"col7"]];
            } 
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"Vip数据失败");
    }];

}

#pragma mark - 按钮事件
- (void)AddNewVIP
{
    NewOrMoreMessageVIPViewController *newVIPVC = [[NewOrMoreMessageVIPViewController alloc] init];
    [self.navigationController pushViewController:newVIPVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.MyVIPSearchController.active) {
        return _NewVIPDatalist.count;
    } else {
        return _VIPDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 212;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *VIPidnet = @"VIPidnet";
    VIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VIPidnet];
    if (cell == nil) {
        cell = [[VIPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VIPidnet];
    }
    if (self.MyVIPSearchController.active) {
        cell.dic = _NewVIPDatalist[indexPath.row];
    } else {
        cell.dic = _VIPDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"确定删除该会员信息吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *url = [userDefaults objectForKey:X6_UseUrl];
            NSString *deleteString = [NSString stringWithFormat:@"%@%@",url,X6_VIPDelete];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSNumber *messgeid;
            if (self.MyVIPSearchController.active) {
                messgeid = [_NewVIPDatalist[indexPath.row] valueForKey:@"col0"];
            } else {
                messgeid = [_VIPDatalist[indexPath.row] valueForKey:@"col0"];
            }
            
            [params setObject:messgeid forKey:@"msgId"];
            [XPHTTPRequestTool requestMothedWithPost:deleteString params:params success:^(id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.MyVIPSearchController.active) {
                        [_NewVIPDatalist removeObjectAtIndex:indexPath.row];
                    } else {
                        NSMutableArray *array = [NSMutableArray arrayWithArray:_VIPDatalist];
                        [array removeObjectAtIndex:indexPath.row];
                        _VIPDatalist = [array mutableCopy];
                    }
                    [tableView reloadData];
                });
            } failure:^(NSError *error) {
                NSLog(@"删除失败");
                
            }];
        });
    }];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertcontroller addAction:okaction];
    [alertcontroller addAction:cancelaction];
    [self presentViewController:alertcontroller animated:YES completion:nil]; 
}



#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.NewsearchKeys removeAllObjects];
    [self.NewVIPDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.MyVIPSearchController.searchBar.text];
    self.NewsearchKeys = [[self.searchKeys filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    NSMutableSet *newVIPSet = [NSMutableSet set];
    for (NSString *title in self.NewsearchKeys) {
        for (NSDictionary *dic in _VIPDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col2"]] || [title isEqualToString:[dic valueForKey:@"col7"]]) {
                [newVIPSet addObject:dic];
            }
        }
    }
    _NewVIPDatalist = [[newVIPSet allObjects] mutableCopy];
    
    [_VIPTableView reloadData];
    
}

#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head
{
    if (head == YES) {
        //是下拉刷新
        [self getMyVIPDataWithPage:1];
    } else {
        //上拉加载更多
        if (_page <= _pages - 1) {
            [self getMyVIPDataWithPage:_page + 1];
        } else {
            [_VIPTableView.footer noticeNoMoreData];
        }
    }
}

#pragma mark - 下拉刷新，上拉加载更多
- (void)VIPfooterAction
{
    [self getrefreshdataWithHead:NO];
}

- (void)VIPheaderAction
{
    [self getrefreshdataWithHead:YES];
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(UITableView *)hometableview
{
    if (_VIPTableView.header.isRefreshing) {
        //正在下拉刷新
        [_VIPTableView.header endRefreshing];
        [_VIPTableView.footer resetNoMoreData];
    } else {
        [_VIPTableView.footer endRefreshing];
    }
}
    
@end
