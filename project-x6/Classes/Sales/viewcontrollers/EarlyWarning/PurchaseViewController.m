//
//  PurchaseViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PurchaseViewController.h"

#import "XPItemsControlView.h"
#import "KucunTitle.h"

#import "NoDataView.h"

#import "PurchaseModel.h"
#import "PurchaseTableViewCell.h"
@interface PurchaseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UIScrollViewDelegate,UITextFieldDelegate>

{
    XPItemsControlView *_SplxitemsControlView;   //眉头
    UIScrollView *_PurchasescrollView;               //首页滑动式图
    int _SplxIndex;
   
    NSMutableArray *_PurchaseDatalist;
}

@property(nonatomic,copy)NSMutableArray *Splxdatalist;                   //库存数据
@property(nonatomic,copy)NSMutableArray *Splxtitles;

@property(nonatomic,copy)NSMutableArray *PurchaseNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *PurchaseSearchNames;
@property(nonatomic,copy)NSMutableArray *NewPurchaseDatalist;
@property(nonatomic, strong)UISearchController *PurchaseSearchController;
@end

@implementation PurchaseViewController

- (void)dealloc
{
    _PurchaseNames = nil;
    _PurchaseSearchNames = nil;
    _PurchaseDatalist = nil;
    _NewPurchaseDatalist = nil;
    _Splxdatalist = nil;
    _Splxtitles = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"采购异常"];
    
    if (!_ishow) {
        UIView *noPurchaseview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"采购异常"];
        [self.view addSubview:noPurchaseview];
    } else {
        _PurchaseNames = [NSMutableArray array];
        _PurchaseSearchNames = [NSMutableArray array];
        _NewPurchaseDatalist = [NSMutableArray array];
        _Splxdatalist = [NSMutableArray array];
        _Splxtitles = [NSMutableArray array];
        _SplxIndex = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ignorePurchasedataList:) name:@"ignorePurchaseData" object:nil];
        
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
            [self initPurchaseUI];
            [self getPurchaseDatalistWithSplx:_Splxdatalist[_SplxIndex]];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_PurchaseSearchController.searchBar setHidden:NO];
    [self cleanPurchaseWarningNumber];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_PurchaseSearchController.searchBar setHidden:YES];
    [_PurchaseSearchController setActive:NO];
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


#pragma mark - 绘制采购异常UI
- (void)initPurchaseUI
{
    //scrollview
    _PurchasescrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 64 - 84)];
    _PurchasescrollView.delegate = self;
    _PurchasescrollView.pagingEnabled = YES;
    _PurchasescrollView.showsHorizontalScrollIndicator = NO;
    _PurchasescrollView.showsVerticalScrollIndicator = NO;
    _PurchasescrollView.contentSize = CGSizeMake(KScreenWidth * _Splxtitles.count, KScreenHeight - 64 - 84);
    _PurchasescrollView.bounces = NO;
    for (int i = 0; i < _Splxtitles.count; i++) {
        UITableView *PurchaseTableview = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 84) style:UITableViewStylePlain];
        PurchaseTableview.delegate = self;
        PurchaseTableview.dataSource = self;
        PurchaseTableview.tag = 411000 + i;
        PurchaseTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        PurchaseTableview.backgroundColor = GrayColor;
        PurchaseTableview.hidden = YES;
        PurchaseTableview.separatorStyle = UITableViewCellAccessoryNone;
        [_PurchasescrollView addSubview:PurchaseTableview];
        
        NoDataView *noPurchaseView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 84)];
        noPurchaseView.text = @"没有异常数据";
        noPurchaseView.tag = 411100 + i;
        noPurchaseView.hidden = YES;
        [_PurchasescrollView addSubview:noPurchaseView];
        
    }
    [self.view addSubview:_PurchasescrollView];
    
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
    
    __weak typeof (_PurchasescrollView)weakScrollView = _PurchasescrollView;
    [_SplxitemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_SplxitemsControlView];
    
    //搜索框
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 44)];
    [self.view addSubview:view];
    _PurchaseSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _PurchaseSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _PurchaseSearchController.searchResultsUpdater = self;
    _PurchaseSearchController.searchBar.delegate = self;
    _PurchaseSearchController.dimsBackgroundDuringPresentation = NO;
    _PurchaseSearchController.hidesNavigationBarDuringPresentation = NO;
    _PurchaseSearchController.searchBar.placeholder = @"搜索";
    [_PurchaseSearchController.searchBar sizeToFit];
    [view addSubview:_PurchaseSearchController.searchBar];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.PurchaseSearchController.active) {
        return _NewPurchaseDatalist.count;
    } else {
        return _PurchaseDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 266;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Purchaseident = @"Purchaseident";
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Purchaseident];
    if (cell == nil) {
        cell = [[PurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Purchaseident];
    }
    if (self.PurchaseSearchController.active) {
        cell.dic = _NewPurchaseDatalist[indexPath.row];
    } else {
        cell.dic = _PurchaseDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.PurchaseSearchNames removeAllObjects];
    [self.NewPurchaseDatalist removeAllObjects];
    
    NSPredicate *PurchasePredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.PurchaseSearchController.searchBar.text];
    self.PurchaseSearchNames = [[self.PurchaseNames filteredArrayUsingPredicate:PurchasePredicate] mutableCopy];
    NSMutableSet *purchaseSet = [NSMutableSet set];
    for (NSString *title in self.PurchaseSearchNames) {
        for (NSDictionary *dic in _PurchaseDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col3"]]) {
                [purchaseSet addObject:dic];
            }
        }
    }
    _NewPurchaseDatalist = [[purchaseSet allObjects] mutableCopy];
    [self refreshPurchaseTableView];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_PurchasescrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_SplxitemsControlView moveToIndex:offset];
        if (offset != _SplxIndex) {
            _SplxIndex = offset;
            [self getPurchaseDatalistWithSplx:[_Splxdatalist[offset] valueForKey:@"bm"]];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_PurchasescrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_SplxitemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - 获取数据
/**
 *  获取采购异常数据
 *
 *  @param splx  商品类型
 */
- (void)getPurchaseDatalistWithSplx:(NSString *)splx
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *PurchaseURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Purchase];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:splx forKey:@"splx"];
    //获取表示图
    UITableView *PurchaseTableView = (UITableView *)[_PurchasescrollView viewWithTag:411000 + _SplxIndex];
    NoDataView *NoPurchaseView = (NoDataView *)[_PurchasescrollView viewWithTag:411100 + _SplxIndex];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:PurchaseURL params:params success:^(id responseObject) {
        [self hideProgress];
        _PurchaseDatalist = [PurchaseModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_PurchaseDatalist.count == 0) {
            PurchaseTableView.hidden = YES;
            _PurchaseSearchController.searchBar.hidden = YES;
            NoPurchaseView.hidden = NO;
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _PurchaseDatalist) {
                if ([[dic valueForKey:@"col9"] boolValue] == 1) {
                    [array addObject:dic];
                }
            }
            [_PurchaseDatalist removeObjectsInArray:array];
            
            if (_PurchaseDatalist.count != 0) {
                NoPurchaseView.hidden = YES;
                PurchaseTableView.hidden = NO;
                _PurchaseSearchController.searchBar.hidden = NO;
                NSArray *PurchaseArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
                [_PurchaseDatalist sortUsingDescriptors:PurchaseArray];
                [PurchaseTableView reloadData];
                
                if (_PurchaseNames.count != 0) {
                    [_PurchaseNames removeAllObjects];
                }
                for (NSDictionary *dic in _PurchaseDatalist) {
                    [_PurchaseNames addObject:[dic valueForKey:@"col1"]];
                    [_PurchaseNames addObject:[dic valueForKey:@"col3"]];
                }
            } else {
                PurchaseTableView.hidden = YES;
                _PurchaseSearchController.searchBar.hidden = YES;
                NoPurchaseView.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"获取采购异常失败");
        [self hideProgress];
    }];
}

/**
 *  清除采购异常条数
 */
- (void)cleanPurchaseWarningNumber
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *removeWarningNumberURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_removeWarningNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"CGYC" forKey:@"txlx"];
    [XPHTTPRequestTool requestMothedWithPost:removeWarningNumberURL params:params success:^(id responseObject) {
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark - 刷新表示图
- (void)refreshPurchaseTableView
{
    UITableView *PurchaseTableView = (UITableView *)[_PurchasescrollView viewWithTag:411000 + _SplxIndex];
    [PurchaseTableView reloadData];
}

#pragma mark - 通知事件: 忽略
- (void)ignorePurchasedataList:(NSNotification *)noti
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
        [params setObject:@"CGYC" forKey:@"txlx"];
        [XPHTTPRequestTool requestMothedWithPost:ignoreURL params:params success:^(id responseObject) {
            NSLog(@"采购异常忽略成功");
            if (_PurchaseSearchController.active) {
                [_NewPurchaseDatalist removeObject:dic];
            } else {
                [_PurchaseDatalist removeObject:dic];
            }
            [self refreshPurchaseTableView];
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
