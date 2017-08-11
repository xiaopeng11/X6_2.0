//
//  NoleadPersonViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NoleadPersonViewController.h"
#import "FirstPersonTableViewCell.h"
#import "SecondPersonTableViewCell.h"
#import "ThirdPersonTableViewCell.h"

#import "AllDynamicViewController.h"

#import "MyDynamicViewController.h"
#import "MyFocusViewController.h"
#import "MyCollectionViewController.h"
#import "ChangePasswordViewController.h"
#import "SetSubscriptionViewController.h"
#import "KnowledgesViewController.h"
#import "SettingsViewController.h"
@interface NoleadPersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,copy)NSArray *datalist;


@end

@implementation NoleadPersonViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"个人中心"];
    
    [self initWithSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderView) name:@"changeHeaderView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"我的页面内存泄漏");
}

- (void)changeHeaderView
{
    [_personTableView reloadData];;
}

//初始化子视图
- (void)initWithSubViews
{
    _personTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49)];
    _personTableView.delegate = self;
    _personTableView.dataSource = self;
    _personTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _personTableView.backgroundColor = GrayColor;
    _personTableView.sectionHeaderHeight = 15;
    _personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_personTableView];
    
    _datalist = @[@{},
                  @{@"Title":@"我的动态",@"ImageName":@"w1_a"},
                  @{@"Title":@"我的关注",@"ImageName":@"g4_d"},
                  @{@"Title":@"我的收藏",@"ImageName":@"g3_b"},
                  @{@"Title":@"我的知识库",@"ImageName":@"w1_b"},
                  @{},
                  @{@"Title":@"修改密码",@"ImageName":@"w1_c"},
                  @{@"Title":@"设置",@"ImageName":@"w1_d"}];
    
    for (int i = 0; i < 4; i++) {
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectZero];
        if (i < 3) {
            lineView.frame = CGRectMake(0, 139.5 + 45 * i, KScreenWidth, .5);
        } else {
            lineView.frame = CGRectMake(0, 139.5 + 45 * i + 60, KScreenWidth, .5);
        }
        [_personTableView addSubview:lineView];
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datalist.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 95;
    } else if (indexPath.row == 5) {
        return 15;
    } else if (indexPath.row == 8){
        return 20;
    } else {
        return 45;
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FirstPersonTableViewCell *firstcell = [[FirstPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstcell"];
        firstcell.selectionStyle = NO;
        return firstcell;
    } else if (indexPath.row == 5 || indexPath.row == 8) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondcell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = NO;
        return cell;
    } else if (indexPath.row == 9){
        ThirdPersonTableViewCell *thirdcell = [[ThirdPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"thirdcell"];
        return thirdcell;
    } else {
        static NSString *secondidented = @"secondidented";
        SecondPersonTableViewCell *secondcell = [tableView dequeueReusableCellWithIdentifier:secondidented];
        if (secondcell == nil) {
            secondcell = [[SecondPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondidented];
        }
        secondcell.dic = _datalist[indexPath.row];
        secondcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return secondcell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        MyDynamicViewController *MyDynamicVC = [[MyDynamicViewController alloc] init];
        [self.navigationController pushViewController:MyDynamicVC animated:YES];
    } else if (indexPath.row == 2) {
        MyFocusViewController *MyFocusVC = [[MyFocusViewController alloc] init];
        [self.navigationController pushViewController:MyFocusVC animated:YES];
    } else if (indexPath.row == 3) {
        MyCollectionViewController *MyColloctionVC = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:MyColloctionVC animated:YES];
    } else if (indexPath.row == 4) {
        KnowledgesViewController *knowledgeVC = [[KnowledgesViewController alloc] init];
        [self.navigationController pushViewController:knowledgeVC animated:YES];
    } else if (indexPath.row == 6){
        ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    } else if (indexPath.row == 7){
        SettingsViewController *setttingVC = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:setttingVC animated:YES];
    }
}


@end
