//
//  CompanyViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CompanyViewController.h"
#import "StoresTableViewCell.h"
#import "kuangjiaModel.h"
@interface CompanyViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NoDataView *_nocompanyTableView;
    UITableView *_companyTableView;
    NSMutableArray *_companyDatalist;
}

@property(nonatomic,copy)NSMutableArray *companyLX;        //公司类型
@property(nonatomic,copy)NSMutableArray *companySection;   //最终数据
@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"选择公司"];
    
    [self drawChooseCompanyUI];
    
    [self getCompanyData];
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

#pragma mark - 获取公司数据
- (void)getCompanyData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *companysURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_ChooseCompany];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:companysURL params:nil success:^(id responseObject) {
        [self hideProgress];
        _companyDatalist = [kuangjiaModel mj_keyValuesArrayWithObjectArray:responseObject[@"gsList"]];
        //处理数据
        if (_companyDatalist.count == 0) {
            _companyTableView.hidden = YES;
            _nocompanyTableView.hidden = NO;
        } else {
            _companyTableView.hidden = NO;
            _nocompanyTableView.hidden = YES;
            [self ProcessingCompanydata];
        }
    } failure:^(NSError *error) {
        [self hideProgress];
    }];

}

- (void)ProcessingCompanydata
{
    
    //创建组中组
    NSMutableSet *sectionSet = [NSMutableSet set];
    for (NSDictionary *dic in _companyDatalist) {
        [sectionSet addObject:[dic valueForKey:@"lx"]];
    }
    
    //类型排序
    NSMutableArray *sections = [[sectionSet allObjects] mutableCopy];
    [sections sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
    
    [sections removeObjectsInArray:@[@(4),@(5)]];
    
    //标题集合
    NSMutableArray *lexingArray = [NSMutableArray arrayWithArray:@[@{@"lx":@"0",@"title":@"总部"},
                                                                   @{@"lx":@"1",@"title":@"分公司"},
                                                                   @{@"lx":@"2",@"title":@"区域"},
                                                                   @{@"lx":@"3",@"title":@"门店"}]];
    NSMutableArray *newleiingArray = [NSMutableArray array];
    for (int i = 0; i < sections.count; i++) {
        for (NSDictionary *dic in lexingArray) {
            if ([[dic valueForKey:@"lx"] intValue] == [sections[i] intValue]) {
                [newleiingArray addObject:dic];
            }
        }
    }

    _companyLX = [NSMutableArray array];
    for (NSDictionary *dic in newleiingArray) {
        [_companyLX addObject:[dic valueForKey:@"title"]];
    }
    
    //数据排序
    for (int i = 0; i < sections.count; i++) {
        NSMutableArray *section = [NSMutableArray array];
        for (NSDictionary *dic in _companyDatalist) {
            int lx = [sections[i] intValue];
            if ([[dic valueForKey:@"lx"] intValue] == lx) {
                [section addObject:dic];
            }
        }
        [sections replaceObjectAtIndex:i withObject:section];
    }

    _companySection = [NSMutableArray arrayWithArray:sections];
    
    [_companyTableView reloadData];

}

#pragma mark - 绘制公司选择UI
- (void)drawChooseCompanyUI
{
    _companyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _companyTableView.delegate = self;
    _companyTableView.dataSource = self;
    _companyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _companyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _companyTableView.hidden = YES;
    [self.view addSubview:_companyTableView];
    
    _nocompanyTableView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _nocompanyTableView.text = @"您没有下属公司";
    _nocompanyTableView.hidden = YES;
    [self.view addSubview:_nocompanyTableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _companySection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_companySection[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _companyLX[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *companysID = @"companysID";
    StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companysID];
    if (cell == nil) {
        cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companysID];
    }
    cell.key = @"name";
    cell.dic = [_companySection[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_companySection[indexPath.section] objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseCompanyssgs" object:dic];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
