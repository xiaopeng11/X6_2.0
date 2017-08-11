//
//  MyCollectionViewController.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "HomeTableView.h"
#import "HomeModel.h"
@interface MyCollectionViewController ()

{
    double _page;
    double _pages;
}

@property(nonatomic,strong)NoDataView *noColloctionView;
@property(nonatomic,strong)HomeTableView *MycollectionTableview;
@property(nonatomic,strong)NSArray *datalist;

@end

@implementation MyCollectionViewController

- (NoDataView *)noColloctionView
{
    if (!_noColloctionView) {
        _noColloctionView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        _noColloctionView.text = @"没有收藏动态";
        [self.view addSubview:_noColloctionView];
    }
    return _noColloctionView;
}

- (HomeTableView *)MycollectionTableview
{
    if (!_MycollectionTableview) {
        _MycollectionTableview = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
        _MycollectionTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _MycollectionTableview.backgroundColor = GrayColor;
        [_MycollectionTableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(MycollectionHeaderAction)];
        [_MycollectionTableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(MycollectionFooterAction)];
        _MycollectionTableview.hidden = YES;
        [self.view addSubview:_MycollectionTableview];
    }
    return _MycollectionTableview;
}

- (NSArray *)datalist
{
    if (_datalist == nil) {
        _datalist = [NSArray array];
    }
    return _datalist;
}
- (void)dealloc
{
    NSLog(@"我的收藏页面内存计数为0");
    self.view = nil;
    _datalist = nil;
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"我的收藏"];
    
    [self getMycollectionDatalistWithPage:1];
    
    [self MycollectionTableview];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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



#pragma mark - 下拉刷新，上拉加载更多
- (void)MycollectionFooterAction
{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [self getrefreshdataWithHead:NO];
}

- (void)MycollectionHeaderAction
{
    [self getrefreshdataWithHead:YES];
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(HomeTableView *)hometableview
{
    if (hometableview.header.isRefreshing) {
        //正在下拉刷新
        //关闭
        [hometableview.header endRefreshing];
        [hometableview.footer resetNoMoreData];
    } else {
        [hometableview.footer endRefreshing];
    }
}

#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head
{
    
    if (head == YES) {
        //是下拉刷新
        [self getMycollectionDatalistWithPage:1];
        
    } else {
        //上拉加载更多
        if (_page <= _pages - 1) {
            [self getMycollectionDatalistWithPage:_page + 1];
        } else {
            [_MycollectionTableview.footer noticeNoMoreData];
        }
        
    }
}




#pragma mark - 获取数据
- (void)getMycollectionDatalistWithPage:(double)page
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:X6_UseUrl];
    NSString *MydynamicURL = [NSString stringWithFormat:@"%@%@",url,X6_Dynamiclist];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(8) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(2) forKey:@"searchType"];
    
    if (!_MycollectionTableview.footer.isRefreshing && !_MycollectionTableview.header.isRefreshing) {
        [self showProgress];
    }
    
    [XPHTTPRequestTool requestMothedWithPost:MydynamicURL params:params success:^(id responseObject) {
        [self hideProgress];
        if (_MycollectionTableview.header.isRefreshing || _MycollectionTableview.footer.isRefreshing) {
            [self endrefreshWithTableView:_MycollectionTableview];
        }
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [_MycollectionTableview.footer noticeNoMoreData];
        }
        
        _page = [[responseObject valueForKey:@"page"] doubleValue];
        _pages = [[responseObject valueForKey:@"pages"] doubleValue];
          
        //判断是否为上拉刷新
        if (_datalist.count == 0 || _MycollectionTableview.header.isRefreshing) {
            _datalist = [HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        } else {
            _datalist = [_datalist arrayByAddingObjectsFromArray:[HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
        }
        _MycollectionTableview.datalist = [_datalist mutableCopy];
        
        //判断是否有数据
        if (_datalist.count == 0) {
            [self noColloctionView];
            _MycollectionTableview.hidden = YES;
        } else {
            _MycollectionTableview.hidden = NO;
            if (_noColloctionView) {
                _noColloctionView.hidden = YES;
            }
            NSMutableArray *array = nil;
            array = [[_datalist mutableCopy] loadframeKeyWithDatalist];
            _MycollectionTableview.datalist = array;
            [_MycollectionTableview reloadData];
        }
 
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
    
}

@end
