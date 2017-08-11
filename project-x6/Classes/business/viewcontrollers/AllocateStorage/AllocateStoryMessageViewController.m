//
//  AllocateStoryMessageViewController.m
//  project-x6
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AllocateStoryMessageViewController.h"
#import "SerialNumAllocateStorayeModel.h"
#import "SerialAllocateStorageTableViewCell.h"

@interface AllocateStoryMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *_serialAllocateStorageDatalist;
    double _serialAllocateStoragePage;
    double _serialAllocateStoragePages;
    
    NoDataView *_nogoodsAllocateStorageView;
    UITableView *_goodsAllocateTableView;
}

@end

@implementation AllocateStoryMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"详情"];
    
    [self drawmySerialAllocateStorageUI];
    
    [self getSerialAllcateStorageDatalistWithDjh:[self.dic valueForKey:@"col4"] Spdm:[self.dic valueForKey:@"col0"] Page:1];
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


- (void)getSerialAllcateStorageDatalistWithDjh:(NSString *)djh Spdm:(NSString *)spdm Page:(double)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *AllocationOfSerialNumberListURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AllocationOfSerialNumberList];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_dic valueForKey:@"col4"] forKey:@"djh"];
    [params setObject:spdm forKey:@"spdm"];
    [params setObject:@(15) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:AllocationOfSerialNumberListURL params:params success:^(id responseObject) {
        [self hideProgress];
        
        if (_goodsAllocateTableView.header.isRefreshing || _goodsAllocateTableView.footer.isRefreshing) {
            [self endgetgoodsAllocateStoragerefresh];
        }
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [_goodsAllocateTableView.footer noticeNoMoreData];
        }
        
        _serialAllocateStoragePage = [[responseObject valueForKey:@"page"] doubleValue];
        _serialAllocateStoragePages = [[responseObject valueForKey:@"pages"] doubleValue];
        
        if (_serialAllocateStorageDatalist.count == 0 || _goodsAllocateTableView.header.isRefreshing) {
            _serialAllocateStorageDatalist = [SerialNumAllocateStorayeModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        } else {
            _serialAllocateStorageDatalist = [_serialAllocateStorageDatalist arrayByAddingObjectsFromArray:[SerialNumAllocateStorayeModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]]];
        }

        _serialAllocateStoragePage = [responseObject[@"page"] doubleValue];
        _serialAllocateStoragePages = [responseObject[@"pages"] doubleValue];
        if (_serialAllocateStorageDatalist.count == 0) {
            _nogoodsAllocateStorageView.hidden = NO;
            _goodsAllocateTableView.hidden = YES;
        } else {
            _nogoodsAllocateStorageView.hidden = YES;
            _goodsAllocateTableView.hidden = NO;
            [_goodsAllocateTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"数据获取失败");
    }];
}

- (void)drawmySerialAllocateStorageUI
{
    UIView *SerialAllocateStorageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 134)];
    SerialAllocateStorageBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SerialAllocateStorageBgView];
    
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 23, 21)];
    phoneView.image = [UIImage imageNamed:@"y2_b"];
    [SerialAllocateStorageBgView addSubview:phoneView];
    
    UILabel *goodName = [[UILabel alloc] initWithFrame:CGRectMake(43, 11, KScreenWidth - 53, 21)];
    goodName.font = MainFont;
    goodName.text = [self.dic valueForKey:@"col1"];
    [SerialAllocateStorageBgView addSubview:goodName];
    
    for (int i = 0; i < 4; i++) {
        int wid = i / 2;
        int low = i % 2;
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ((KScreenWidth / 2) * low), 57 + 45 * wid, 40, 20)];
        detailLabel.font = MainFont;
        [SerialAllocateStorageBgView addSubview:detailLabel];
        UILabel *detailmoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 + ((KScreenWidth / 2) * low), 57 + 45 * wid, (KScreenWidth - 100) / 2.0, 20)];
        detailmoreLabel.font = MainFont;
        detailmoreLabel.textColor = PriceColor;
        [SerialAllocateStorageBgView addSubview:detailmoreLabel];
        
        if (i == 0) {
            detailLabel.text = @"数量:";
            detailmoreLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col2"]];
        } else if (i == 1) {
            detailLabel.text = @"单价:";
            float danjia = [[self.dic valueForKey:@"col3"] floatValue] / [[self.dic valueForKey:@"col2"] floatValue];
            detailmoreLabel.text = [NSString stringWithFormat:@"￥%.2f",danjia];
        } else if (i == 2) {
            detailLabel.text = @"金额:";
            detailmoreLabel.text = [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"col3"]];
        } else if (i == 3) {
            detailLabel.text = @"备注:";
            detailmoreLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col5"]];
        }
        
        if (i < 2) {
            UIView *lianeView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 *i, KScreenWidth, .5)];
            [SerialAllocateStorageBgView addSubview:lianeView];
        }
    }
    
    UIView *lowView = [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - .5) / 2.0, 45, .5, 89)];
    [SerialAllocateStorageBgView addSubview:lowView];
    
    
    [self drawMainUI];

}

- (void)drawMainUI
{
    _goodsAllocateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 154, KScreenWidth, KScreenHeight - 154 - 64) style:UITableViewStylePlain];
    _goodsAllocateTableView.backgroundColor = GrayColor;
    _goodsAllocateTableView.hidden = YES;
    _goodsAllocateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _goodsAllocateTableView.delegate = self;
    _goodsAllocateTableView.dataSource = self;
    [_goodsAllocateTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(goodsAllocateStorageheaderAction)];
    [_goodsAllocateTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(goodsAllocateStoragefooterAction)];
    [self.view addSubview:_goodsAllocateTableView];
    
    _nogoodsAllocateStorageView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 154, KScreenWidth, KScreenHeight - 154 - 64)];
    _nogoodsAllocateStorageView.text = @"没有数据";
    _nogoodsAllocateStorageView.hidden = YES;
    [self.view addSubview:_nogoodsAllocateStorageView];
}

#pragma mark - 加载更多和刷新
- (void)goodsAllocateStorageheaderAction
{
    [self getgoodsAllocateStoragerefreshdataWithHead:YES];
}

- (void)goodsAllocateStoragefooterAction
{
    [self getgoodsAllocateStoragerefreshdataWithHead:NO];
}

- (void)getgoodsAllocateStoragerefreshdataWithHead:(BOOL)head
{
    if (head == YES) {
        [self getSerialAllcateStorageDatalistWithDjh:[self.dic valueForKey:@"col4"] Spdm:[self.dic valueForKey:@"col0"] Page:1];
    } else {
        if (_serialAllocateStoragePage < _serialAllocateStoragePages) {
            [self getSerialAllcateStorageDatalistWithDjh:[self.dic valueForKey:@"col4"] Spdm:[self.dic valueForKey:@"col0"] Page:(_serialAllocateStoragePage + 1)];
        } else {
            [_goodsAllocateTableView.footer noticeNoMoreData];
        }
    }
}

- (void)endgetgoodsAllocateStoragerefresh
{
    if (_goodsAllocateTableView.header.isRefreshing) {
        [_goodsAllocateTableView.header endRefreshing];
        [_goodsAllocateTableView.footer resetNoMoreData];
    } else {
        [_goodsAllocateTableView.footer endRefreshing];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _serialAllocateStorageDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SerialAllocateStorageid = @"SerialAllocateStorageTableViewCellid";
    SerialAllocateStorageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SerialAllocateStorageid];
    if (cell == nil) {
        cell = [[SerialAllocateStorageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SerialAllocateStorageid];
    }
    cell.dic = _serialAllocateStorageDatalist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    headerview.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, KScreenWidth, 20)];
    label.font = MainFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"串号";
    [headerview addSubview:label];
    UIView *headerlineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [headerview addSubview:headerlineView];
    return headerview;
}


@end
