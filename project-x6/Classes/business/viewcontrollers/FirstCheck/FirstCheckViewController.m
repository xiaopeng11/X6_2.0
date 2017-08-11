//
//  FirstCheckViewController.m
//  project-x6
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FirstCheckViewController.h"

#import "FirstCheckModel.h"
#import "FirstCheckTableViewCell.h"

#import "AddFirstCheckViewController.h"
@interface FirstCheckViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UIView *_FirstCheckbottomBgview;
    NSArray *_FirstCheckDatalist;
    UITableView *_FirstCheckTabelView;
    NoDataView *_noFirstCheckView;
    double _page;
    double _pages;
}

@end

@implementation FirstCheckViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"期初盘库"];
    
    [self drawFirstCheckUI];
    
    [self getFirstCheckDataWithPage:1];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"新增" target:self action:@selector(addnewCheck)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FirstCheckheaderAction) name:@"successAddFirstCheck" object:nil];
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

#pragma mark - 绘制UI
- (void)drawFirstCheckUI
{
    _FirstCheckTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 60) style:UITableViewStylePlain];
    _FirstCheckTabelView.backgroundColor = GrayColor;
    _FirstCheckTabelView.delegate = self;
    _FirstCheckTabelView.dataSource = self;
    _FirstCheckTabelView.hidden = YES;
    //添加上拉加载更多，下拉刷新
    [_FirstCheckTabelView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(FirstCheckfooterAction)];
    [_FirstCheckTabelView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(FirstCheckheaderAction)];
    _FirstCheckTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_FirstCheckTabelView];
    
    _noFirstCheckView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 60)];
    _noFirstCheckView.text = @"没有数据";
    _noFirstCheckView.hidden = YES;
    [self.view addSubview:_noFirstCheckView];
    
    _FirstCheckbottomBgview = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
    _FirstCheckbottomBgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_FirstCheckbottomBgview];
    
    UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
    [_FirstCheckbottomBgview addSubview:lineView];
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.font = MainFont;
            label.frame = CGRectMake(10, 20, 40, 20);
            label.text = @"合计";
        } else if (i == 1) {
            label.font = ExtitleFont;
            label.frame = CGRectMake(KScreenWidth - totalWidth - 50, 7, totalWidth + 20, 16);
            label.text = @"数量";
        } else {
            label.font = ExtitleFont;
            label.frame = CGRectMake(KScreenWidth - totalWidth - 50, 37, totalWidth + 20, 16);
            label.textColor = PriceColor;
            label.tag = 380010;
        }
        [_FirstCheckbottomBgview addSubview:label];
    }
}

#pragma mark - 获取期初盘库数据
- (void)getFirstCheckDataWithPage:(double)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *FirstCheckURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_FirstCheck];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(15) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];

    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:FirstCheckURL params:params success:^(id responseObject) {
        [self hideProgress];
        if (_FirstCheckTabelView.header.isRefreshing || _FirstCheckTabelView.footer.isRefreshing) {
            [self endrefreshWithTableView:_FirstCheckTabelView];
        }
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [_FirstCheckTabelView.footer noticeNoMoreData];
        }
        
        _page = [[responseObject valueForKey:@"page"] doubleValue];
        _pages = [[responseObject valueForKey:@"pages"] doubleValue];
        
        if (_FirstCheckDatalist.count == 0 || _FirstCheckTabelView.header.isRefreshing) {
            _FirstCheckDatalist = [FirstCheckModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        } else {
            _FirstCheckDatalist = [_FirstCheckDatalist arrayByAddingObjectsFromArray:[FirstCheckModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]]];
        }
        if (_FirstCheckDatalist.count == 0) {
            _FirstCheckTabelView.hidden = YES;
            _noFirstCheckView.hidden = NO;
        } else {
            _noFirstCheckView.hidden = YES;
            _FirstCheckTabelView.hidden = NO;
            [_FirstCheckTabelView reloadData];
            
            NSArray *sortFirstCheck = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col2" ascending:NO]];
            NSMutableArray *array  = [NSMutableArray arrayWithArray:_FirstCheckDatalist];
            [array sortUsingDescriptors:sortFirstCheck];
            _FirstCheckDatalist = [array mutableCopy];

            //数量
            UILabel *label = (UILabel *)[_FirstCheckbottomBgview viewWithTag:380010];
            label.text = [NSString stringWithFormat:@"%@",responseObject[@"sumsl"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取期初盘库失败");
        [self hideProgress];
    }];
}

#pragma mark - 新增期初盘库
- (void)addnewCheck
{
    AddFirstCheckViewController *AddFirstCheckVC = [[AddFirstCheckViewController alloc] init];
    [self.navigationController pushViewController:AddFirstCheckVC animated:YES];
}

#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head
{
    if (head == YES) {
        //是下拉刷新
        [self getFirstCheckDataWithPage:1];
    } else {
        //上拉加载更多
        if (_page <= _pages - 1) {
            [self getFirstCheckDataWithPage:_page + 1];
        } else {
            [_FirstCheckTabelView.footer noticeNoMoreData];
        }
    }
}

#pragma mark - 下拉刷新，上拉加载更多
- (void)FirstCheckfooterAction
{
    [self getrefreshdataWithHead:NO];
}

- (void)FirstCheckheaderAction
{
    [self getrefreshdataWithHead:YES];
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(UITableView *)hometableview
{
    if (_FirstCheckTabelView.header.isRefreshing) {
        //正在下拉刷新
        [_FirstCheckTabelView.header endRefreshing];
        [_FirstCheckTabelView.footer resetNoMoreData];
    } else {
        [_FirstCheckTabelView.footer endRefreshing];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _FirstCheckDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *firstcheckid = @"firstcheckid";
    FirstCheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstcheckid];
    if (cell == nil) {
        cell = [[FirstCheckTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstcheckid];
    }
    cell.dic = _FirstCheckDatalist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
