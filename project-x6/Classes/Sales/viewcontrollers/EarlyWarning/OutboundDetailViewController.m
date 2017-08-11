
//
//  OutboundDetailViewController.m
//  project-x6
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OutboundDetailViewController.h"

#import "XPItemsControlView.h"
#import "KucunTitle.h"

#import "NoDataView.h"

#import "OutboundDetailTableViewCell.h"
#import "OutboundMoredetailModel.h"
#import "OutboundViewController.h"
@interface OutboundDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UIScrollViewDelegate,UITextFieldDelegate>

{
    XPItemsControlView *_SplxitemsControlView;   //眉头
    UIScrollView *_OutboundDetailscrollView;               //首页滑动式图
    int _SplxIndex;
    
    NSMutableArray *_OutboundDetaildatalist;
}


@property(nonatomic,copy)NSMutableArray *Splxdatalist;                   //库存数据
@property(nonatomic,copy)NSMutableArray *Splxtitles;

@property(nonatomic,copy)NSMutableArray *OutboundDetailNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *OutboundDetailSearchNames;
@property(nonatomic,copy)NSMutableArray *NewOutboundDetailDatalist;
@property(nonatomic, strong)UISearchController *OutboundDetailSearchController;

@end

@implementation OutboundDetailViewController

- (void)dealloc
{
    _OutboundDetailNames = nil;
    _OutboundDetailSearchNames = nil;
    _NewOutboundDetailDatalist = nil;
    _OutboundDetaildatalist = nil;
    _Splxdatalist = nil;
    _Splxtitles = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"出库异常"];
    
    if (!_ishow) {
        UIView *noPurchaseview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"出库异常"];
        [self.view addSubview:noPurchaseview];
    } else {
        _OutboundDetailNames = [NSMutableArray array];
        _OutboundDetailSearchNames = [NSMutableArray array];
        _NewOutboundDetailDatalist = [NSMutableArray array];
        _Splxdatalist = [NSMutableArray array];
        _Splxtitles = [NSMutableArray array];
        _SplxIndex = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ignoreOutboundDetail:) name:@"ignoreOutboundDetail" object:nil];
        
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
            [self initWithOutboundDetailView];
            
            [self addRightNaviItem];
            
            [self getTabelViewDataSplx:_Splxdatalist[_SplxIndex]];
        });
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
    [_OutboundDetailSearchController.searchBar setHidden:NO];
    [self cleanOutboundWarningNumber];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_OutboundDetailSearchController.searchBar setHidden:YES];
    [_OutboundDetailSearchController setActive:NO];
}


#pragma mark - 绘制出库异常UI
- (void)initWithOutboundDetailView
{
    //scrollview
    _OutboundDetailscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 64 - 84)];
    _OutboundDetailscrollView.delegate = self;
    _OutboundDetailscrollView.pagingEnabled = YES;
    _OutboundDetailscrollView.showsHorizontalScrollIndicator = NO;
    _OutboundDetailscrollView.showsVerticalScrollIndicator = NO;
    _OutboundDetailscrollView.contentSize = CGSizeMake(KScreenWidth * _Splxtitles.count, KScreenHeight - 64 - 84);
    _OutboundDetailscrollView.bounces = NO;
    for (int i = 0; i < _Splxtitles.count; i++) {
        UITableView *OutboundDetailTableview = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 84) style:UITableViewStylePlain];
        OutboundDetailTableview.delegate = self;
        OutboundDetailTableview.dataSource = self;
        OutboundDetailTableview.tag = 421000 + i;
        OutboundDetailTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        OutboundDetailTableview.backgroundColor = GrayColor;
        OutboundDetailTableview.hidden = YES;
        OutboundDetailTableview.separatorStyle = UITableViewCellAccessoryNone;
        [_OutboundDetailscrollView addSubview:OutboundDetailTableview];
        
        NoDataView *noOutboundView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 84)];
        noOutboundView.text = @"没有异常数据";
        noOutboundView.tag = 421100 + i;
        noOutboundView.hidden = YES;
        [_OutboundDetailscrollView addSubview:noOutboundView];
        
    }
    [self.view addSubview:_OutboundDetailscrollView];
    
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
    
    __weak typeof (_OutboundDetailscrollView)weakScrollView = _OutboundDetailscrollView;
    [_SplxitemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_SplxitemsControlView];
    
    //搜索框
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 44)];
    [self.view addSubview:view];
    _OutboundDetailSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _OutboundDetailSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _OutboundDetailSearchController.searchResultsUpdater = self;
    _OutboundDetailSearchController.searchBar.delegate = self;
    _OutboundDetailSearchController.dimsBackgroundDuringPresentation = NO;
    _OutboundDetailSearchController.hidesNavigationBarDuringPresentation = NO;
    _OutboundDetailSearchController.searchBar.placeholder = @"搜索";
    [_OutboundDetailSearchController.searchBar sizeToFit];
    [view addSubview:_OutboundDetailSearchController.searchBar];

}

#pragma mark - addRightNaviItem
- (void)addRightNaviItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"统计" target:self action:@selector(moreOutboundData)];
}

- (void)moreOutboundData
{
    OutboundViewController *outboundView = [[OutboundViewController alloc] init];
    [self.navigationController pushViewController:outboundView animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.OutboundDetailSearchController.active) {
        return _NewOutboundDetailDatalist.count;
    } else {
        return _OutboundDetaildatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 182 + 45;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OutboundDetailidnet = @"OutboundDetailidnet";
    OutboundDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OutboundDetailidnet];
    if (cell == nil) {
        cell = [[OutboundDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OutboundDetailidnet];
    }
    if (self.OutboundDetailSearchController.active) {
        cell.dic = _NewOutboundDetailDatalist[indexPath.row];
    } else {
        cell.dic = _OutboundDetaildatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.OutboundDetailSearchNames removeAllObjects];
    [self.NewOutboundDetailDatalist removeAllObjects];
    NSPredicate *ReatilPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.OutboundDetailSearchController.searchBar.text];
    self.OutboundDetailSearchNames = [[self.OutboundDetailNames filteredArrayUsingPredicate:ReatilPredicate] mutableCopy];
    NSMutableSet *OutboundDetailSet = [NSMutableSet set];
    for (NSString *title in self.OutboundDetailSearchNames) {
        for (NSDictionary *dic in _OutboundDetaildatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col7"]] || [title isEqualToString:[dic valueForKey:@"col4"]]) {
                [OutboundDetailSet addObject:dic];
            }
        }
    }
    _NewOutboundDetailDatalist = [[OutboundDetailSet allObjects] mutableCopy];
    [self refreshOutboundTableView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_OutboundDetailscrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_SplxitemsControlView moveToIndex:offset];
        if (offset != _SplxIndex) {
            _SplxIndex = offset;
            [self getTabelViewDataSplx:[_Splxdatalist[offset] valueForKey:@"bm"]];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_OutboundDetailscrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_SplxitemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - 获取数据
/**
 *  获取出库异常数据
 *
 *  @param splx  商品类型
 */
- (void)getTabelViewDataSplx:(NSString *)splx
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *myOutboundDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_OutboundMoredetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDate *date = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%@",date];
    NSString *uyear = [dateString substringToIndex:4];
    NSString *umonth = [dateString substringWithRange:NSMakeRange(5, 2)];
    [params setObject:uyear forKey:@"uyear"];
    [params setObject:umonth forKey:@"accper"];
    [params setObject:splx forKey:@"splx"];
    //获取表示图
    UITableView *OutboundDetailTableView = (UITableView *)[_OutboundDetailscrollView viewWithTag:421000 + _SplxIndex];
    NoDataView *NoOutboundDetailView = (NoDataView *)[_OutboundDetailscrollView viewWithTag:421100 + _SplxIndex];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:myOutboundDetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        _OutboundDetaildatalist = [OutboundMoredetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_OutboundDetaildatalist.count == 0) {
            OutboundDetailTableView.hidden = YES;
            _OutboundDetailSearchController.searchBar.hidden = YES;
            NoOutboundDetailView.hidden = NO;
        } else {            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _OutboundDetaildatalist) {
                if ([[dic valueForKey:@"col8"] boolValue] == 1) {
                    [array addObject:dic];
                }
            }
            [_OutboundDetaildatalist removeObjectsInArray:array];
            
            if (_OutboundDetaildatalist.count != 0) {
                NoOutboundDetailView.hidden = YES;
                OutboundDetailTableView.hidden = NO;
                _OutboundDetailSearchController.searchBar.hidden = NO;
                NSArray *OutboundDetailArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
                [_OutboundDetaildatalist sortUsingDescriptors:OutboundDetailArray];
                [OutboundDetailTableView reloadData];
                
                if (_OutboundDetailNames.count != 0) {
                    [_OutboundDetailNames removeAllObjects];
                }
                for (NSDictionary *dic in _OutboundDetaildatalist) {
                    [_OutboundDetailNames addObject:[dic valueForKey:@"col1"]];
                    [_OutboundDetailNames addObject:[dic valueForKey:@"col4"]];
                    [_OutboundDetailNames addObject:[dic valueForKey:@"col7"]];
                }

            } else {
                OutboundDetailTableView.hidden = YES;
                _OutboundDetailSearchController.searchBar.hidden = YES;
                NoOutboundDetailView.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"出库异常明细获取失败");
    }];
}

/**
 *  清除出库异常条数
 */
- (void)cleanOutboundWarningNumber
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *removeWarningNumberURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_removeWarningNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"CKYC" forKey:@"txlx"];
    [XPHTTPRequestTool requestMothedWithPost:removeWarningNumberURL params:params success:^(id responseObject) {
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
    
}

#pragma mark - 刷新表示图
- (void)refreshOutboundTableView
{
    UITableView *OutboundTableView = (UITableView *)[_OutboundDetailscrollView viewWithTag:421000 + _SplxIndex];
    [OutboundTableView reloadData];
}

#pragma mark - 通知事件：忽略
- (void)ignoreOutboundDetail:(NSNotification *)noti
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
        [params setObject:@"CKYC" forKey:@"txlx"];
        [XPHTTPRequestTool requestMothedWithPost:ignoreURL params:params success:^(id responseObject) {
            NSLog(@"出库异常忽略成功");
            if (_OutboundDetailSearchController.active) {
                [_NewOutboundDetailDatalist removeObject:dic];
            } else {
                [_OutboundDetaildatalist removeObject:dic];
            }
            [self refreshOutboundTableView];
        } failure:^(NSError *error) {
            NSLog(@"出库异常忽略失败");
        }];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ignoreAction addAction:cancleAction];
    [ignoreAction addAction:okAction];
    [self presentViewController:ignoreAction animated:YES completion:nil];
}
@end
