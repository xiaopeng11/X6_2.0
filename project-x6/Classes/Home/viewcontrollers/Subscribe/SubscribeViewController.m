
//
//  SubscribeViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SubscribeViewController.h"

#import "SubscribeModel.h"
#import "SubscribeTableViewCell.h"

#import "WJItemsControlView.h"
@interface SubscribeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{
    WJItemsControlView *_SubscribeItemsControlView;
    UIScrollView *_SubscribeScrollView;
    NSMutableArray *_SubscribeDatalist;
}
@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"通知消息"];
    
    [self drawSubscribeUI];

    [_SubscribeItemsControlView moveToIndex:self.subscribeType - 1];
    [_SubscribeScrollView setContentOffset:CGPointMake(KScreenWidth * (self.subscribeType - 1), 0) animated:YES];
    [self getSubscribeDataWithIndex:self.subscribeType - 1];
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

}

#pragma mark - 绘制UI
- (void)drawSubscribeUI
{
    //scrollview
    _SubscribeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 40)];
    _SubscribeScrollView.delegate = self;
    _SubscribeScrollView.pagingEnabled = YES;
    _SubscribeScrollView.showsHorizontalScrollIndicator = NO;
    _SubscribeScrollView.showsVerticalScrollIndicator = NO;
    _SubscribeScrollView.contentSize = CGSizeMake(KScreenWidth * 3, KScreenHeight - 64 - 40);
    _SubscribeScrollView.bounces = NO;
    NSArray *noSubscribe = @[@"没有日报数据／未订阅",@"没有周报数据／未订阅",@"没有月报数据／未订阅"];
    for (int i = 0; i < 3; i++) {
        UITableView *SubscribeTableView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 40) style:UITableViewStylePlain];
        SubscribeTableView.delegate = self;
        SubscribeTableView.dataSource = self;
        SubscribeTableView.tag = 10100 + i;
        SubscribeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        SubscribeTableView.backgroundColor = GrayColor;
        SubscribeTableView.hidden = YES;
        [_SubscribeScrollView addSubview:SubscribeTableView];
        
        NoDataView *NOSubscribeView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 40)];
        NOSubscribeView.text = noSubscribe[i];
        NOSubscribeView.hidden = YES;
        NOSubscribeView.tag = 10200 + i;
        [_SubscribeScrollView addSubview:NOSubscribeView];
    }
    [self.view addSubview:_SubscribeScrollView];
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    config.itemWidth = KScreenWidth / 3;
    _SubscribeItemsControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    _SubscribeItemsControlView.tapAnimation = NO;
    _SubscribeItemsControlView.backgroundColor = [UIColor whiteColor];
    _SubscribeItemsControlView.config = config;
    _SubscribeItemsControlView.titleArray = @[@"日报",@"周报",@"月报"];
    
    __weak typeof (_SubscribeScrollView)weakScrollView = _SubscribeScrollView;
    [_SubscribeItemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_SubscribeItemsControlView];
}

#pragma mark - 作滑返回
- (void)popSubscribeView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取数据
- (void)getSubscribeDataWithIndex:(NSInteger)index
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefalut objectForKey:X6_UseUrl];
    NSString *SubscribeURL;
    if (index == 0) {
        SubscribeURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeDay];
    } else if (index == 1) {
        SubscribeURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeWeek];
    } else if (index == 2) {
        SubscribeURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeMonth];
    }
    [self showProgress];
    UITableView *SubscribeTableView = (UITableView *)[_SubscribeScrollView viewWithTag:10100 + index];
    NoDataView *NOSubscribeView = (NoDataView *)[_SubscribeScrollView viewWithTag:10200 + index];
    [XPHTTPRequestTool requestMothedWithPost:SubscribeURL params:nil success:^(id responseObject) {
        [self hideProgress];
        _SubscribeDatalist = [SubscribeModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        NSArray *SubscribesortArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col0" ascending:NO]];
        [_SubscribeDatalist sortUsingDescriptors:SubscribesortArray];
        if (_SubscribeDatalist.count == 0) {
            NOSubscribeView.hidden = NO;
            SubscribeTableView.hidden = YES;
        } else {
            SubscribeTableView.hidden = NO;
            NOSubscribeView.hidden = YES;
            [SubscribeTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        if (index == 0) {
            NSLog(@"日报失败");
        } else if (index == 1) {
            NSLog(@"周报失败");
        } else if (index == 2) {
            NSLog(@"月报失败");
        }
    }];

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _SubscribeDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 10100) {
        static NSString *Subscribeidentfirst = @"Subscribeidentfirst";
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Subscribeidentfirst];
        if (cell == nil) {
            cell = [[SubscribeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Subscribeidentfirst];
        }
        cell.dic = _SubscribeDatalist[indexPath.row];
        cell.type = 1;
        return cell;
    } else if (tableView.tag == 10101) {
        static NSString *Subscribeidentsecond = @"Subscribeidentsecond";
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Subscribeidentsecond];
        if (cell == nil) {
            cell = [[SubscribeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Subscribeidentsecond];
        }
        cell.dic = _SubscribeDatalist[indexPath.row];
        cell.type = 2;
        return cell;
    } else {
        static NSString *Subscribeidentthird = @"Subscribeidentthird";
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Subscribeidentthird];
        if (cell == nil) {
            cell = [[SubscribeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Subscribeidentthird];
        }
        cell.dic = _SubscribeDatalist[indexPath.row];
        cell.type = 3;
        return cell;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_SubscribeScrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_SubscribeItemsControlView moveToIndex:offset];
        [self getSubscribeDataWithIndex:offset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_SubscribeScrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_SubscribeItemsControlView endMoveToIndex:offset];
    }
}
@end
