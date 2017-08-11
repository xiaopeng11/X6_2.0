//
//  PersonViewController.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PersonViewController.h"
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

@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,copy)NSArray *datalist;

@end

@implementation PersonViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"个人中心"];

    [self initWithSubViews];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changenoleadHeaderView) name:@"changeHeaderView" object:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"我的页面内存泄漏");
}

- (void)changenoleadHeaderView
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
                  @{@"Title":@"设置订阅",@"ImageName":@"w1_e"},
                  @{@"Title":@"修改密码",@"ImageName":@"w1_c"},
                  @{@"Title":@"设置",@"ImageName":@"w1_d"}];
    
    for (int i = 0; i < 5; i++) {
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
    } else if (indexPath.row == 9){
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
    } else if (indexPath.row == 5 || indexPath.row == 9) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondcell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = NO;
        return cell;
    } else if (indexPath.row == 10){
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
        NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
        NSArray *qxlist = [userdefalut objectForKey:X6_UserQXList];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in qxlist) {
            [array addObject:[dic valueForKey:@"qxid"]];
        }
        if ([array containsObject:@"bb_rbdy"]) {
            for (NSDictionary *dic in qxlist) {
                if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_rbdy"]) {
                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                        SetSubscriptionViewController *SetSubscriptionVC  = [[SetSubscriptionViewController alloc] init];
                        [self.navigationController pushViewController:SetSubscriptionVC animated:YES];
                    } else {
                        [BasicControls showAlertWithMsg:@"该功能未经授权，请与系统管理员联系授权" addTarget:nil];
                    }
                    break;
                }
            }
        } else {
            [BasicControls showAlertWithMsg:@"该功能未经授权，请与系统管理员联系授权" addTarget:nil];
        }
    } else if (indexPath.row == 7){
        ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    } else if (indexPath.row == 8){
        SettingsViewController *setttingVC = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:setttingVC animated:YES];
    }
}


@end
