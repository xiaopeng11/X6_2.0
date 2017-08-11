//
//  DepositViewController.m
//  project-x6
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DepositViewController.h"

#import "AdddepositViewController.h"
#import "WhetherOrderViewController.h"

#import "DepositModel.h"
#import "DepositTableViewCell.h"

#import "XPDatePicker.h"

@interface DepositViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    NSMutableArray *_depositDatalist;
    
    double _page;
    double _pages;
    
}

@property(nonatomic,strong)UITableView *depositTableView;
@property(nonatomic,strong)NoDataView *nodepositTabelView;

@property(nonatomic,strong)XPDatePicker *datepicker;                           //日期选择


@end

@implementation DepositViewController

- (UITableView *)depositTableView
{
    if (_depositTableView == nil) {
        _depositTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
        _depositTableView.dataSource = self;
        _depositTableView.delegate = self;
        _depositTableView.hidden = YES;
        _depositTableView.allowsSelection = NO;
        _depositTableView.backgroundColor = GrayColor;
        _depositTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _depositTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        if (_isBusiness) {
            [_depositTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreDepositData)];
        }
        [self.view addSubview:_depositTableView];
    }
    return _depositTableView;
}

- (NoDataView *)nodepositTabelView
{
    if (_nodepositTabelView == nil) {
        _nodepositTabelView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        if (_isBusiness) {
            _nodepositTabelView.text = @"您还没有银行存款";
        } else {
            _nodepositTabelView.text = @"您还没有今日存款";
        }
        _nodepositTabelView.hidden = YES;
        [self.view addSubview:_nodepositTabelView];
    }
    return _nodepositTabelView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏右侧按钮
    if (_isBusiness) {
        if (!_isshow) {
            UIView *noTodayMoneyview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"银行存款"];
            [self.view addSubview:noTodayMoneyview];
        } else {
            [self naviTitleWhiteColorWithText:@"银行存款"];
            UIView *depositRightBarButtonItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60.5, 34)];
            UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftbutton.frame = CGRectMake(0, 0, 30, 34);
            [leftbutton setImage:[UIImage imageNamed:@"y1_c"] forState:UIControlStateNormal];
            [leftbutton setImage:[UIImage imageNamed:@"y1_c1"] forState:UIControlStateHighlighted];
            [leftbutton addTarget:self action:@selector(leftbutton:) forControlEvents:UIControlEventTouchUpInside];
            [depositRightBarButtonItem addSubview:leftbutton];
            
            UIView *lowView = [[UIView alloc] initWithFrame:CGRectMake(30, 5, .5, 24)];
            lowView.backgroundColor = [UIColor whiteColor];
            [depositRightBarButtonItem addSubview:lowView];
            
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"y1_a" highImageName:@"y1_a1" target:self action:@selector(rightbutton:)];
            [self depositTableView];
            [self nodepositTabelView];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDepositData:) name:@"deletedepostAction" object:nil];
            
            [self getdepositDataWithPage:1 DateString:nil];

        }
    } else {
        [self naviTitleWhiteColorWithText:@"今日存款"];
        if (!_isshow) {
            UIView *noTodayMoneyview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"今日存款"];
            [self.view addSubview:noTodayMoneyview];
        } else {
            NSString *dateString = [BasicControls TurnTodayDate];
            _datepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:dateString];
            _datepicker.delegate = self;
            _datepicker.labelString = @"选择查询日期:";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_datepicker];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changetodaydeposit) name:@"changeTodayData" object:nil];
            [self depositTableView];
            [self nodepositTabelView];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDepositData:) name:@"deletedepostAction" object:nil];
            
            [self getdepositDataWithPage:1 DateString:_datepicker.text];
        }

    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _depositDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[_depositDatalist[indexPath.row] valueForKey:@"rowheight"] floatValue];
    return height;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *depositCellID = @"depositCellID";
    DepositTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DepositTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:depositCellID];
    }
    cell.dic = _depositDatalist[indexPath.row];
    cell.isBusiness = _isBusiness;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isBusiness) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - 获取数据
- (void)getdepositDataWithPage:(NSInteger)page DateString:(NSString *)dateString
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *depositURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (dateString == nil) {
        depositURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_deposit];
        [params setObject:@(8) forKey:@"rows"];
        [params setObject:@(page) forKey:@"page"];
    } else {
        depositURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_todaydeposit];
        [params setObject:_datepicker.text forKey:@"fsrq"];
    }
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:depositURL params:params success:^(id responseObject) {
        [self hideProgress];
        if (dateString != nil) {
            _depositDatalist = [DepositModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        } else {
            if ([_depositTableView.footer isRefreshing]) {
                [_depositTableView.footer endRefreshing];
                NSArray *array = [DepositModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
                if (array.count < 8) {
                    [_depositTableView.footer noticeNoMoreData];
                }
                _depositDatalist = [[_depositDatalist arrayByAddingObjectsFromArray:array] mutableCopy];
            } else {
                _depositDatalist = [DepositModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
            }
            
            _page = [responseObject[@"page"] doubleValue];
            _pages = [responseObject[@"pages"] doubleValue];
        }
        
        
        if (_depositDatalist.count == 0) {
            _depositTableView.hidden = YES;
            _nodepositTabelView.hidden = NO;
        } else {
            _nodepositTabelView.hidden = YES;
            _depositTableView.hidden = NO;
            
            NSArray *depositArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"djh" ascending:NO]];
            [_depositDatalist sortUsingDescriptors:depositArray];
            
            //增加高度参数
            for (int i = 0; i < _depositDatalist.count; i++) {
                NSDictionary *dic = _depositDatalist[i];
                NSArray *acounts = [dic valueForKey:@"rows"];
                CGFloat rowhight;
                rowhight = 10 + 45 + 116 + acounts.count * 35;
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:dic];
                [diced setObject:@(rowhight) forKey:@"rowheight"];
                [_depositDatalist replaceObjectAtIndex:i withObject:diced];
            }
            [_depositTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"银行存款");
    }];
    
}


#pragma mark - 加载更多
- (void)getMoreDepositData
{
    if (_page < _pages) {
        [self getdepositDataWithPage:(_page + 1) DateString:nil];
    } else {
        [_depositTableView.footer noticeNoMoreData];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_datepicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _datepicker.subView.tag=1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_datepicker.subView];
    }
    
    return NO;
}

#pragma mark - 改变日期事件
- (void)changetodaydeposit
{
    [self getdepositDataWithPage:1 DateString:_datepicker.text];
}

- (void)deleteDepositData:(NSNotification *)noti
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [userDefaults objectForKey:X6_UseUrl];
        NSString *deleteString = [NSString stringWithFormat:@"%@%@",url,X6_deletedeposit];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *djh = noti.object;
        [params setObject:djh forKey:@"djh"];
        [XPHTTPRequestTool requestMothedWithPost:deleteString params:params success:^(id responseObject) {
            NSMutableArray *deleteArray = [NSMutableArray array];
            for (NSDictionary *dic in _depositDatalist) {
                NSString *reviewID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"djh"]];
                NSString *notiob = [NSString stringWithFormat:@"%@",noti.object];
                if ([reviewID isEqualToString:notiob]) {
                    [deleteArray addObject:dic];
                }
            }
            [_depositDatalist removeObjectsInArray:deleteArray];
            [_depositTableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"删除失败");
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });

    }];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertcontroller addAction:cancelaction];
    [alertcontroller addAction:okaction];
    [self presentViewController:alertcontroller animated:YES completion:nil];
}

#pragma mark - 导航栏按钮时间
- (void)leftbutton:(UIButton *)button
{
    WhetherOrderViewController *whetherOrderVC = [[WhetherOrderViewController alloc] init];
    [self.navigationController pushViewController:whetherOrderVC animated:YES];
}

- (void)rightbutton:(UIButton *)button
{
    AdddepositViewController *addepositVC = [[AdddepositViewController alloc] init];
    [self.navigationController pushViewController:addepositVC animated:YES];
}
@end
