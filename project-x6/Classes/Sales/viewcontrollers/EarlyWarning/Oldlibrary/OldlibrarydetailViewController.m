//
//  OldlibrarydetailViewController.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibrarydetailViewController.h"

#import "OldlibraryDetailModel.h"
#import "NoDataView.h"

#import "OldlibrarydetailTableViewCell.h"
@interface OldlibrarydetailViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *_OldlibrarydetailDatalist;
    
    UITableView *_OldlibrarydetailTableview;
    NoDataView *_noOldlibrarydetailView;
    double _OldlibrarydetailPage;
    double _OldlibrarydetailPages;

}

@end

@implementation OldlibrarydetailViewController

- (void)dealloc
{
    _OldlibrarydetailDatalist = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"逾期明细"];
    
    [self initOldlibrarydetailUI];
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
    
    [self getOldlibrarydetailDataWithPage:1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _OldlibrarydetailDatalist = nil;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _OldlibrarydetailDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Oldlibrarydetailidnet = @"Oldlibrarydetailidnet";
    OldlibrarydetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Oldlibrarydetailidnet];
    if (cell == nil) {
        cell = [[OldlibrarydetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Oldlibrarydetailidnet];
    }
    cell.dic = _OldlibrarydetailDatalist[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(((KScreenWidth - 2) / 3.0) * i, 12, (KScreenWidth - 2) / 3.0, 20)];
        label.font = MainFont;
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.text = @"串号";
        } else if (i == 1) {
            label.text = @"仓库";
        } else {
            label.text = @"逾期";
        }
        [view addSubview:label];
        
        if (i < 2) {
            UIView *firstView = [BasicControls drawLineWithFrame:CGRectMake(((KScreenWidth - 1) / 3.0) * (i + 1), 0, .5, 45)];
            [view addSubview:firstView];
            
            UIView *secondView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
            [view addSubview:secondView];
        }
    }
    return view;
}

#pragma mark - 绘制ui
- (void)initOldlibrarydetailUI
{
    UIView *headerbgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 70)];
    headerbgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerbgView];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 + 30 * i, 20, 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10 + 30 * i, KScreenWidth - 50, 20)];
        label.font = MainFont;
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"y2_a"];
            label.text = [NSString stringWithFormat:@"供应商:%@",[self.dic valueForKey:@"gysName"]];
        } else {
            imageView.image = [UIImage imageNamed:@"y2_b"];
            label.text = [NSString stringWithFormat:@"货  品:%@",[self.dic valueForKey:@"hpName"]];
        }
        [headerbgView addSubview:imageView];
        [headerbgView addSubview:label];
    }
    
    
    _OldlibrarydetailTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, KScreenWidth, KScreenHeight - 90 - 64) style:UITableViewStylePlain];
    _OldlibrarydetailTableview.delegate = self;
    _OldlibrarydetailTableview.dataSource = self;
    _OldlibrarydetailTableview.hidden = YES;
    _OldlibrarydetailTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _OldlibrarydetailTableview.backgroundColor = GrayColor;
    [_OldlibrarydetailTableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(OldlibrarydetailheaderAction)];
    [_OldlibrarydetailTableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(OldlibrarydetailfooterAction)];
    [self.view addSubview:_OldlibrarydetailTableview];
    
    
    
    _noOldlibrarydetailView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 90, KScreenWidth, KScreenHeight - 90 - 64)];
    _noOldlibrarydetailView.text = @"没有数据";
    _noOldlibrarydetailView.hidden = YES;
    [self.view addSubview:_noOldlibrarydetailView];
}

#pragma mark - 加载更多和刷新
- (void)OldlibrarydetailheaderAction
{
    [self getOldlibrarydetailrefreshdataWithHead:YES];
}

- (void)OldlibrarydetailfooterAction
{
    [self getOldlibrarydetailrefreshdataWithHead:NO];
}

- (void)getOldlibrarydetailrefreshdataWithHead:(BOOL)head
{
    if (head == YES) {
        [self getOldlibrarydetailDataWithPage:1];
    } else {
        if (_OldlibrarydetailPage < _OldlibrarydetailPages) {
            [self getOldlibrarydetailDataWithPage:(_OldlibrarydetailPage + 1)];
        } else {
            [_OldlibrarydetailTableview.footer noticeNoMoreData];
        }
    }
}

- (void)endgetOldlibrarydetailrefresh
{
    if (_OldlibrarydetailTableview.header.isRefreshing) {
        [_OldlibrarydetailTableview.header endRefreshing];
        [_OldlibrarydetailTableview.footer resetNoMoreData];
    } else {
        [_OldlibrarydetailTableview.footer endRefreshing];
    }
}

#pragma mark - 获取数据
- (void)getOldlibrarydetailDataWithPage:(NSInteger)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *OldlibrarydetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Oldlibrarydetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.dic valueForKey:@"gysdm"] forKey:@"gysdm"];
    [params setObject:[self.dic valueForKey:@"spdm"] forKey:@"spdm"];
    [params setObject:[self.dic valueForKey:@"kl"] forKey:@"kl"];
    [params setObject:@(50) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"col0" forKey:@"sidx"];
    [params setObject:@"asc" forKey:@"sord"];
    if (!_OldlibrarydetailTableview.header.isRefreshing && !_OldlibrarydetailTableview.footer.isRefreshing) {
        [self showProgress];
    }
    [XPHTTPRequestTool requestMothedWithPost:OldlibrarydetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        if (_OldlibrarydetailDatalist.count == 0 || _OldlibrarydetailTableview.header.isRefreshing) {
            _OldlibrarydetailDatalist = [OldlibraryDetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        } else {
            _OldlibrarydetailDatalist = [_OldlibrarydetailDatalist arrayByAddingObjectsFromArray:[OldlibraryDetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]]];
        }
        
        if (_OldlibrarydetailTableview.header.isRefreshing || _OldlibrarydetailTableview.footer.isRefreshing) {
            [self endgetOldlibrarydetailrefresh];
        }
        if ([responseObject[@"rows"] count] < 50) {
            [_OldlibrarydetailTableview.footer noticeNoMoreData];
        }
        
        
        if (_OldlibrarydetailDatalist.count == 0) {
            _OldlibrarydetailTableview.hidden = YES;
            _noOldlibrarydetailView.hidden = NO;
        } else {
            _noOldlibrarydetailView.hidden = YES;
            _OldlibrarydetailTableview.hidden = NO;
            [_OldlibrarydetailTableview reloadData];
            _OldlibrarydetailPages = [responseObject[@"pages"] doubleValue];
            _OldlibrarydetailPage = [responseObject[@"page"] doubleValue];
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"库龄预警失败");
    }];
}


@end
