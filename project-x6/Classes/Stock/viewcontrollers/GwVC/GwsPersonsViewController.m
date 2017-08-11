//
//  GwsPersonsViewController.m
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GwsPersonsViewController.h"
#import "PersonsTableViewCell.h"
#import "HeaderViewController.h"
#import "WriteViewController.h"
#import "MianDynamicViewController.h"
#import "BusinessSCDetailViewController.h"
@interface GwsPersonsViewController ()
{
    UITableView *_gwsPersonTableview;
}

@property(nonatomic,copy)NSMutableArray *gwPersons;
@property(nonatomic,copy)NSArray *selectgwPersons;


@end

@implementation GwsPersonsViewController

- (void)dealloc
{
    _gwPersons = nil;
    _selectgwPersons = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:_titleName];
    
    //处理数据
    [self selectgwsPersonsData];
    
    //绘制UI
    _gwsPersonTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _gwsPersonTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _gwsPersonTableview.dataSource = self;
    _gwsPersonTableview.delegate = self;
    [self.view addSubview:_gwsPersonTableview];
    
    if (_type == YES) {
        if (!_BusinessSCDetailType) {
            //导航栏右侧确定按钮
            [self addsurebutton];
            
            _gwsPersonTableview.allowsMultipleSelectionDuringEditing = YES;
            [_gwsPersonTableview setEditing:YES];
        }
    }
    
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

#pragma mark - sureAction
- (void)sureAction:(UIButton *)button
{
    
    [button removeFromSuperview];

    _selectgwPersons = [NSArray array];
    _selectgwPersons = [_gwsPersonTableview indexPathsForSelectedRows];
    
    //处理数据
    NSMutableArray *personsList = [NSMutableArray array];
    if (_replytype == YES) {
        for (NSIndexPath *indec in _selectgwPersons) {
            NSDictionary *gwdic = [_gwPersons objectAtIndex:indec.row];
            [personsList addObject:[gwdic valueForKey:@"name"]];
        }
    } else {
        for (NSIndexPath *indec in _selectgwPersons) {
            NSDictionary *gwdic = [_gwPersons objectAtIndex:indec.row];
            NSMutableDictionary *diced = [NSMutableDictionary dictionary];
            [diced setObject:[gwdic valueForKey:@"name"] forKey:@"name"];
            [diced setObject:[gwdic valueForKey:@"id"] forKey:@"id"];
            [diced setObject:[gwdic valueForKey:@"usertype"] forKey:@"usertype"];
            [personsList addObject:diced];

        }
    }
    
    if (personsList != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gwPersonList" object:personsList];
    }
    
    if (_replytype == YES) {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[MianDynamicViewController class]]) {
                [self.navigationController popToViewController:VC animated:YES];
            }
        }

    } else {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[WriteViewController class]]) {
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }
}

#pragma mark - 处理数据
- (void)selectgwsPersonsData
{
    _gwPersons = [NSMutableArray array];
    
    for (NSDictionary *dic in _datalist) {
        if ([[dic valueForKey:@"gw"] isEqualToString:_titleName]) {
            [_gwPersons addObject:dic];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gwPersons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gwsPersonsID = @"gwsPersonsID";
    PersonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gwsPersonsID];
    if (cell == nil) {
        cell = [[PersonsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gwsPersonsID];
        if (_type == YES) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }

    cell.dic = _gwPersons[indexPath.row];
    cell.comdatalist = _comdatalist;
    cell.gwdatalist = _gwdatalist;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == NO){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HeaderViewController *headerVC = [[HeaderViewController alloc] init];
        headerVC.type = YES;
        headerVC.dic = _gwPersons[indexPath.row];
        [self.navigationController pushViewController:headerVC animated:YES];
    } else if (_BusinessSCDetailType == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"businessSCDdic" object:_gwPersons[indexPath.row]];
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[BusinessSCDetailViewController class]]) {
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }
}
@end
