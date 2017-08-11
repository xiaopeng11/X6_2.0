//
//  TakeInventoryViewController.m
//  project-x6
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TakeInventoryViewController.h"
#import "TakeInventoryModel.h"
#import "TakeInventoryTableViewCell.h"

#import "BeginExameViewController.h"
@interface TakeInventoryViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_TakeInventoryDatalist;
    UITableView *_TakeInventoryTabelView;
    NoDataView *_noTakeInventoryView;
}
@end

@implementation TakeInventoryViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"库存盘点"];
    
    [self drawTakeInventoryUI];
    
    [self getTakeInventoryData];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"开始盘库" target:self action:@selector(beginexamine)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TakeInventoryheaderAction) name:@"addnewexameData" object:nil];
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
- (void)drawTakeInventoryUI
{
    _TakeInventoryTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight -64) style:UITableViewStylePlain];
    _TakeInventoryTabelView.backgroundColor = GrayColor;
    _TakeInventoryTabelView.delegate = self;
    _TakeInventoryTabelView.dataSource = self;
    _TakeInventoryTabelView.hidden = YES;
    _TakeInventoryTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_TakeInventoryTabelView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(TakeInventoryheaderAction)];
    [self.view addSubview:_TakeInventoryTabelView];
    
    _noTakeInventoryView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _noTakeInventoryView.text = @"没有数据";
    _noTakeInventoryView.hidden = YES;
    [self.view addSubview:_noTakeInventoryView];
}

#pragma mark - 获取数据
- (void)getTakeInventoryData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *TakeInventoryURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_CheckList];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:TakeInventoryURL params:nil success:^(id responseObject) {
        [self hideProgress];
        if (_TakeInventoryTabelView.header.isRefreshing) {
            [_TakeInventoryTabelView.header endRefreshing];
        }
        _TakeInventoryDatalist = [TakeInventoryModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_TakeInventoryDatalist.count == 0) {
            _TakeInventoryTabelView.hidden = YES;
            _noTakeInventoryView.hidden = NO;
        } else {
            _noTakeInventoryView.hidden = YES;
            _TakeInventoryTabelView.hidden = NO;
            [_TakeInventoryTabelView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取盘库失败");
        [self hideProgress];
    }];
}

#pragma mark - 开始盘库
- (void)beginexamine
{
    BeginExameViewController *BeginExameVC = [[BeginExameViewController alloc] init];
    [self.navigationController pushViewController:BeginExameVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _TakeInventoryDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 330;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TakeInventoryid = @"TakeInventoryid";
    TakeInventoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TakeInventoryid];
    if (cell == nil) {
        cell = [[TakeInventoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TakeInventoryid];
    }
    cell.dic = _TakeInventoryDatalist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"确定删除?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *url = [userDefaults objectForKey:X6_UseUrl];
            NSString *deleteString = [NSString stringWithFormat:@"%@%@",url,X6_CheckSingleCancle];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSDictionary *dic = _TakeInventoryDatalist[indexPath.row];
            [params setObject:[dic valueForKey:@"id"] forKey:@"id"];
            [XPHTTPRequestTool requestMothedWithPost:deleteString params:params success:^(id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                        [_TakeInventoryDatalist removeObjectAtIndex:indexPath.row];
                        [tableView reloadData];
                });
            } failure:^(NSError *error) {
                NSLog(@"删除失败");
                
            }];
        });
    }];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertcontroller addAction:okaction];
    [alertcontroller addAction:cancelaction];
    [self presentViewController:alertcontroller animated:YES completion:nil];
}

#pragma mark - 刷新
- (void)TakeInventoryheaderAction
{
    [self getTakeInventoryData];
}

@end
