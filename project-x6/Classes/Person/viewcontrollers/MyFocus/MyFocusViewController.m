//
//  MyFocusViewController.m
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyFocusViewController.h"
#import "HomeTableView.h"
#import "HomeModel.h"
@interface MyFocusViewController ()
{
    double _page;
    double _pages;
}

@property(nonatomic,strong)HomeTableView *MyFocusTableview;
@property(nonatomic,strong)NSArray *datalist;
@property(nonatomic,strong)NoDataView *noFocusView;

@end

@implementation MyFocusViewController

- (void)dealloc
{
     self.view = nil;
     _datalist = nil;
}

- (NoDataView *)noFocusView
{
    if (!_noFocusView) {
        _noFocusView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        _noFocusView.text = @"您无关注信息";
        [self.view addSubview:_noFocusView];
    }
    return _noFocusView;
}

- (HomeTableView *)MyFocusTableview
{
    if (!_MyFocusTableview) {
        _MyFocusTableview = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        _MyFocusTableview.isMyDynamic = YES;
        _MyFocusTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _MyFocusTableview.backgroundColor = GrayColor;
        [_MyFocusTableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(MyFocusHeaderAction)];
        [_MyFocusTableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(MyFocusFooterAction)];
        [self.view addSubview:_MyFocusTableview];
    }
    return _MyFocusTableview;
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
    [self naviTitleWhiteColorWithText:@"我的收藏"];
    
    [self getMyFocusDatalistWithPage:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"我的关注收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }

}

#pragma mark - 下拉刷新，上拉加载更多
- (void)MyFocusFooterAction
{
    [self getrefreshdataWithHead:NO];
    
}

- (void)MyFocusHeaderAction
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
        [self getMyFocusDatalistWithPage:1];
        
    } else {
        //上拉加载更多
        if (_page <= _pages - 1) {
            [self getMyFocusDatalistWithPage:_page + 1];
        } else {
            [_MyFocusTableview.footer noticeNoMoreData];
        }
        
    }
}




#pragma mark - 获取数据
- (void)getMyFocusDatalistWithPage:(double)page
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:X6_UseUrl];
    NSString *MydynamicURL = [NSString stringWithFormat:@"%@%@",url,X6_Dynamiclist];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(8) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(1) forKey:@"searchType"];
    
    if (!_MyFocusTableview.footer.isRefreshing || !_MyFocusTableview.header.isRefreshing) {
        [self showProgress];
        }
    [XPHTTPRequestTool requestMothedWithPost:MydynamicURL params:params success:^(id responseObject) {
        [self hideProgress];
           if (_MyFocusTableview.header.isRefreshing || _MyFocusTableview.footer.isRefreshing) {
               [self endrefreshWithTableView:_MyFocusTableview];
           }
           if ([[responseObject valueForKey:@"rows"] count] < 8) {
               [_MyFocusTableview.footer noticeNoMoreData];
           }

        _page = [[responseObject valueForKey:@"page"] doubleValue];
        _pages = [[responseObject valueForKey:@"pages"] doubleValue];
        
        //判断是否为上拉刷新
        if (_datalist.count == 0 || _MyFocusTableview.header.isRefreshing) {
            _datalist = [HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        
        } else {
            _datalist = [_datalist arrayByAddingObjectsFromArray:[HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
        }
        _MyFocusTableview.datalist = [_datalist mutableCopy];
        
        //判断是否有数据
        if (_datalist.count == 0) {
            [self noFocusView];
            if (_MyFocusTableview) {
                _MyFocusTableview.hidden = YES;
            }
        } else {
            [self MyFocusTableview];
            if (_noFocusView) {
                _noFocusView.hidden = YES;
            }
            NSMutableArray *array = nil;
            array = [[_datalist mutableCopy] loadframeKeyWithDatalist];
            _MyFocusTableview.datalist = array;
            [_MyFocusTableview reloadData];
        }
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
    
}


@end
