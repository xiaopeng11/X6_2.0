//
//  MyDynamicViewController.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyDynamicViewController.h"
#import "HomeModel.h"
@interface MyDynamicViewController ()

{
    double _page;            //页码
    double _pages;           //一共的页码
}
@property(nonatomic,strong)NoDataView *nomyView;
@property(nonatomic,strong)NSArray *datalist;
@end

@implementation MyDynamicViewController

- (void)dealloc
{
     self.view = nil;
     _datalist = nil;
}

- (NoDataView *)nomyView
{
    if (!_nomyView) {
        _nomyView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        _nomyView.text = @"您还未发布动态";
        [self.view addSubview:_nomyView];
    }
    return _nomyView;
}

- (HomeTableView *)tableview
{
    if (!_tableview) {
        _tableview = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        _tableview.isMyDynamic = YES;
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableview.backgroundColor = GrayColor;
        [_tableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(myfooterAction)];
        [_tableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(myheaderAction)];
        [self.view addSubview:_tableview];
    }
    return _tableview;
}

- (NSArray *)datalist
{
    if (_datalist == nil) {
        _datalist = [NSArray array];
    }
    return _datalist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"我的动态"];

    [self getdatawithPage:1];
    
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

#pragma mark - 获取数据
- (void)getdatawithPage:(double)page
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:X6_UseUrl];
    NSString *MydynamicURL = [NSString stringWithFormat:@"%@%@",url,X6_Dynamiclist];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(8) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(3) forKey:@"searchType"];
    
    if ( !_tableview.header.isRefreshing && !_tableview.footer.isRefreshing) {
        [self showProgress];
    }
    [XPHTTPRequestTool requestMothedWithPost:MydynamicURL params:params success:^(id responseObject) {
        [self hideProgress];
        if (_tableview.header.isRefreshing || _tableview.footer.isRefreshing) {
            [self endrefreshWithTableView:_tableview];
        }
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [_tableview.footer noticeNoMoreData];
        }
        
        _page = [[responseObject valueForKey:@"page"] doubleValue];
        _pages = [[responseObject valueForKey:@"pages"] doubleValue];
        
        //判断是否为上拉刷新
        if (_datalist.count == 0 || _tableview.header.isRefreshing) {
            _datalist = [HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        } else {
            _datalist = [_datalist arrayByAddingObjectsFromArray:[HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
        }
        
        //判断是否有数据
        if (_datalist.count == 0) {
            [self nomyView];
            if (_tableview) {
                _tableview.hidden = YES;
            }
        } else {
            [self tableview];
            if (_nomyView) {
                _nomyView.hidden = YES;
            }
            NSMutableArray *array = nil;
            array = [[_datalist mutableCopy] loadframeKeyWithDatalist];
            _tableview.datalist = array;
            [_tableview reloadData];
        }
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}

#pragma mark - 下拉刷新，上拉加载更多
- (void)myfooterAction
{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [self getrefreshdataWithHead:NO];
}

- (void)myheaderAction
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
        [self getdatawithPage:1];
        
    } else {
        //上拉加载更多
        if (_page <= _pages - 1) {
            [self getdatawithPage:_page + 1];
        } else {
            NSLog(@"没有数据了");
            [_tableview.footer noticeNoMoreData];
        }
        
    }
}

//#pragma mark - 删除了最后一条动态
//- (void)nomydynamic
//{
//    _tableview.hidden = YES;
//    if (_nomyView) {
//        [self nomyView];
//    }
//    _nomyView.hidden = NO;
//}


@end
