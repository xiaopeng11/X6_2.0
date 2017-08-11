//
//  LibrarybitdistributionViewController.m
//  project-x6
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LibrarybitdistributionViewController.h"

#import "LibrarybitModel.h"
#import "LibrarybitTableViewCell.h"
@interface LibrarybitdistributionViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_LibrarybitdistributionDatalist;
}
@property(nonatomic,strong)UITableView *LibrarybitdistributionTabelView;
@property(nonatomic,strong)NoDataView *NoLibrarybitdistributionView;
@property(nonatomic,strong)UIView *totalLibrarybitdistributionView;


@end

@implementation LibrarybitdistributionViewController


- (UITableView *)LibrarybitdistributionTabelView
{
    if (!_LibrarybitdistributionTabelView) {
        _LibrarybitdistributionTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight - 64 - 60 - 10) style:UITableViewStylePlain];
        _LibrarybitdistributionTabelView.delegate = self;
        _LibrarybitdistributionTabelView.dataSource = self;
        _LibrarybitdistributionTabelView.backgroundColor = GrayColor;
        _LibrarybitdistributionTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _LibrarybitdistributionTabelView.hidden = YES;
        [self.view addSubview:_LibrarybitdistributionTabelView];
    }
    return _LibrarybitdistributionTabelView;
}

- (NoDataView *)NoLibrarybitdistributionView
{
    if (!_NoLibrarybitdistributionView) {
        _NoLibrarybitdistributionView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        _NoLibrarybitdistributionView.text = @"没有数据";
        _NoLibrarybitdistributionView.hidden = YES;
        [self.view addSubview:_NoLibrarybitdistributionView];
    }
    return _NoLibrarybitdistributionView;
}

- (UIView *)totalLibrarybitdistributionView
{
    if (!_totalLibrarybitdistributionView) {
        _totalLibrarybitdistributionView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 60, KScreenWidth, 60)];
        _totalLibrarybitdistributionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_totalLibrarybitdistributionView];
        for (int i = 0; i < 5; i++) {
            UILabel *label = [[UILabel alloc] init];
            if (i == 0) {
                label.font = MainFont;
                label.frame = CGRectMake(10, 20, 40, 20);
                label.text = @"合计";
            } else if (i == 1) {
                label.font = ExtitleFont;
                label.frame = CGRectMake(KScreenWidth - totalWidth - 10, 7, totalWidth, 16);
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"数量";
            } else {
                label.font = ExtitleFont;
                label.frame = CGRectMake(KScreenWidth - totalWidth - 10, 37, totalWidth, 16);
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = PriceColor;
                label.tag = 0144110;
            }
            [_totalLibrarybitdistributionView addSubview:label];
        }
    }
    return _totalLibrarybitdistributionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"库位分布"];
    
    [self LibrarybitdistributionTabelView];
    [self NoLibrarybitdistributionView];
    [self totalLibrarybitdistributionView];
    
    [self getLibrarybitdistributiondatalist];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _LibrarybitdistributionDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Librarybitdistributionidnet = @"Librarybitdistributionidnet";
    LibrarybitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Librarybitdistributionidnet];
    if (cell == nil) {
        cell = [[LibrarybitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Librarybitdistributionidnet];
    }
    cell.dic = _LibrarybitdistributionDatalist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 获取数据
- (void)getLibrarybitdistributiondatalist
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Librarybitdistribution];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_spdm forKey:@"spdm"];
    [self showProgress];
    //获取表示图
    [XPHTTPRequestTool requestMothedWithPost:mykucunURL params:params success:^(id responseObject) {
        _LibrarybitdistributionDatalist = [LibrarybitModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_LibrarybitdistributionDatalist.count == 0) {
            _LibrarybitdistributionTabelView.hidden = YES;
            _NoLibrarybitdistributionView.hidden = NO;
        } else {
            _NoLibrarybitdistributionView.hidden = YES;
            _LibrarybitdistributionTabelView.hidden = NO;
            [_LibrarybitdistributionTabelView reloadData];
            float totalnum = 0;
            for (NSDictionary *dic in _LibrarybitdistributionDatalist) {
                totalnum += [[dic valueForKey:@"col1"] floatValue];
            }
            UILabel *numLabel = (UILabel *)[_totalLibrarybitdistributionView viewWithTag:0144110];
            numLabel.text = [NSString stringWithFormat:@"%.0f台",totalnum];
        }
        [self hideProgress];
    } failure:^(NSError *error) {
        NSLog(@"库位分布获取失败");
        [self hideProgress];
    }];
}

@end
