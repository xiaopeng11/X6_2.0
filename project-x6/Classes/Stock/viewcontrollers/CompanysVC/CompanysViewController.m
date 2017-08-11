//
//  CompanysViewController.m
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CompanysViewController.h"
#import "CompanyPersonsViewController.h"
#import "SelectTableViewCell.h"
#import "WriteViewController.h"
#import "MianDynamicViewController.h"

@interface CompanysViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_companysTableview;

}

@property(nonatomic,copy)NSMutableArray *nameArray;    //组名
@property(nonatomic,copy)NSMutableArray *selectcompanys;
@property(nonatomic,copy)NSMutableArray *arrays;

@property(nonatomic,copy)NSArray *sectionNames;

@end

@implementation CompanysViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"按公司框架"];
    
    self.view.backgroundColor = GrayColor;
    _selectcompanys = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    _sectionNames = [NSArray array];
    //处理数据
    [self selectCompanys];
    
    //绘制UI
    _companysTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _companysTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _companysTableview.dataSource = self;
    _companysTableview.delegate = self;
    [self.view addSubview:_companysTableview];
    
    if (_type == YES) {
        if (!_BusinessSCDetailType) {
            //确定按钮
            [self addsurebutton];
        }
    }
}

- (void)dealloc
{
    _selectcompanys = nil;
    _nameArray = nil;
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

#pragma mark - 处理数据
- (void)selectCompanys
{
    //创建组中组
    NSMutableSet *sectionSet = [NSMutableSet set];
    for (NSDictionary *dic in _kuangjiadatalist) {
        [sectionSet addObject:[dic valueForKey:@"lx"]];
    }
    
    //排序
    NSMutableArray *sections = [[sectionSet allObjects] mutableCopy];
    [sections sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
    
    [sections removeLastObject];
    
    for (int i = 0; i < sections.count; i++) {
        NSMutableArray *section = [NSMutableArray array];
        for (NSDictionary *dic in _kuangjiadatalist) {
            int lx = [sections[i] intValue];
            if ([[dic valueForKey:@"lx"] intValue] == lx) {
                [section addObject:dic];
            }
        }
        [sections replaceObjectAtIndex:i withObject:section];
    }
    
    //获得
    NSMutableArray *NewSections = [NSMutableArray array];
    for (NSMutableArray *sectionName in sections) {
        NSMutableArray *names = [NSMutableArray array];
        NSMutableArray *NewSection = [NSMutableArray array];
        for (NSDictionary *sectiondic in sectionName) {
            for (NSDictionary *dic in _datalist) {
                if ([[sectiondic valueForKey:@"bm"] isEqualToString:[dic valueForKey:@"ssgs"]]) {
                    [NewSection addObject:dic];
                }
            }
            [names addObject:[sectiondic valueForKey:@"name"]];
        }
        [_nameArray addObject:names];
        [NewSections addObject:NewSection];
    }
    
    if (_nameArray.count > 1) {
        [_nameArray exchangeObjectAtIndex:1 withObjectAtIndex:2];
    }
    
    //将岗位数组转换成模型对象数组
    NSMutableArray *newarrays = [NSMutableArray array];
    for (NSArray *array in _nameArray) {
        NSMutableArray *newarray = [NSMutableArray array];
        for (NSString *name in array) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"name"] = name;
            dic[@"check"] = @NO;
            [newarray addObject:dic];
        }
        [newarrays addObject:newarray];
    }
 
    _arrays = [NSMutableArray arrayWithArray:newarrays];

    _sectionNames = @[@"总部",@"分公司",@"区域",@"门店"];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrays[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionNames[section];
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
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companysID];
    if (cell == nil) {
        cell = [[SelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companysID];
        cell.iscompany = YES;
    }
    cell.type = _type;
    cell.BusinessSCDetailType = _BusinessSCDetailType;
    if (cell.type == YES) {
        [cell.button addTarget:self action:@selector(companycellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.button.tag = ((indexPath.section + 1) * 1000) + indexPath.row;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = [_arrays[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    CompanyPersonsViewController *companyPersonVC = [[CompanyPersonsViewController alloc] init];
    companyPersonVC.datalist = _datalist;
    companyPersonVC.kuangjiadatalist = _kuangjiadatalist;
    companyPersonVC.titleName = [_nameArray[indexPath.section] objectAtIndex:indexPath.row];
    companyPersonVC.type = _type;
    companyPersonVC.replytype = _replytype;
    companyPersonVC.BusinessSCDetailType = _BusinessSCDetailType;
    [self.navigationController pushViewController:companyPersonVC animated:YES];
}


#pragma mark - 单元格按钮点击事件
- (void)companycellButtonAction:(UIButton *)button
{
    NSInteger cellsection = (button.tag / 1000) - 1;
    NSInteger cellrow = button.tag % 1000;
    NSMutableArray *data = _arrays[cellsection];
    NSMutableDictionary *cellmodel = [data objectAtIndex:cellrow];
    if (![[cellmodel valueForKey:@"check"] boolValue]) {
        cellmodel[@"check"] = @YES;
        [_selectcompanys addObject:[_nameArray[cellsection] objectAtIndex:cellrow]];
    } else {
        cellmodel[@"check"] = @NO;
        [_selectcompanys removeObject:[_nameArray[cellsection] objectAtIndex:cellrow]];
    }
    [data replaceObjectAtIndex:cellrow withObject:cellmodel];
    [_arrays replaceObjectAtIndex:cellsection withObject:data];
    [_companysTableview reloadData];
}

#pragma mark - 重写确定联系人按钮事件
- (void)sureAction:(UIButton *)button
{
    [button removeFromSuperview];
    NSLog(@"确定返回公司信息%@",[_selectcompanys description]);
    NSMutableArray *personList = [NSMutableArray array];
    NSMutableArray *compans = [NSMutableArray array];
    for (NSDictionary *dic in _kuangjiadatalist) {
        for (NSString *name in _selectcompanys) {
            if ([[dic valueForKey:@"name"] isEqualToString:name]) {
                [compans addObject:[dic valueForKey:@"bm"]];
            }
        }
    }
    
    if (_replytype == YES) {
        for (NSString *bm in compans) {
            for (NSDictionary *dic in _datalist) {
                if ([[dic valueForKey:@"ssgs"] isEqualToString:bm]) {
                    [personList addObject:[dic valueForKey:@"name"]];
                }
            }
        }
    } else {
        for (NSString *bm in compans) {
            for (NSDictionary *dic in _datalist) {
                if ([[dic valueForKey:@"ssgs"] isEqualToString:bm]) {
                    NSMutableDictionary *diced = [NSMutableDictionary dictionary];
                    [diced setObject:[dic valueForKey:@"name"] forKey:@"name"];
                    [diced setObject:[dic valueForKey:@"id"] forKey:@"id"];
                    [diced setObject:[dic valueForKey:@"usertype"] forKey:@"usertype"];
                    [personList addObject:diced];
                }
            }
        }
    }
    
    if (personList.count != 0) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"companysList" object:personList];
    }
    
    if (_replytype == YES) {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[MianDynamicViewController class]]) {
                [self.navigationController popToViewController:VC animated:NO];
            }
        }
    } else {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[WriteViewController class]]) {
                [self.navigationController popToViewController:VC animated:NO];
            }
        }
    }
    
}


@end
