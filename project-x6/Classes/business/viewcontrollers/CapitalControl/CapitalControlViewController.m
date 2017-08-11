//
//  CapitalControlViewController.m
//  project-x6
//
//  Created by Apple on 2016/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CapitalControlViewController.h"
#import "XPDatePicker.h"

#import "AddCapitalControlViewController.h"
#import "MoreCapitalControlViewController.h"

#import "CapitalControlModel.h"
#import "CapitalControlTableViewCell.h"

@interface CapitalControlViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITextFieldDelegate>

{
    XPDatePicker *_FirstDatePicker;         //第一个textfield
    XPDatePicker *_SecondDatePicker;        //第二个textfield
    
    NoDataView *_NoCapitalControldataView;
    UITableView *_CapitalControltableView;
    UIView *_totalCapitalControlViews;       //总计
    
    NSMutableArray *_CapitalControlDatalist;
    NSMutableArray *_NewCapitalControlDatalist;
    
}

@property(nonatomic,copy)NSMutableArray *KeyNames;
@property(nonatomic,strong)NSMutableArray *searchKeyNames;
@property(nonatomic, strong)UISearchController *CapitalControlSearchController;

@end

@implementation CapitalControlViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_CapitalControlSearchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _CapitalControlSearchController.searchBar.hidden = YES;
    [_CapitalControlSearchController setActive:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_lx == 0) {
        [self naviTitleWhiteColorWithText:@"资金收入"];
    } else if (_lx == 3) {
        [self naviTitleWhiteColorWithText:@"资金支出"];
    } else if (_lx == 1) {
        [self naviTitleWhiteColorWithText:@"资金调配"];
    }
    
    if (!_isshow) {
        if (_lx == 0) {
            UIView *noCapitalControlview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"资金收入"];
            [self.view addSubview:noCapitalControlview];
        } else if (_lx == 3) {
            UIView *noCapitalControlview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"资金支出"];
            [self.view addSubview:noCapitalControlview];
        } else if (_lx == 1) {
            UIView *noCapitalControlview = [BasicControls noshowBusinessOrSalesUIWithDefaultImagename:@"资金调配"];
            [self.view addSubview:noCapitalControlview];
        }

    } else {
        _CapitalControlDatalist = [NSMutableArray array];
        _NewCapitalControlDatalist = [NSMutableArray array];
        _KeyNames = [NSMutableArray array];
        _searchKeyNames = [NSMutableArray array];
        
        //导航栏右侧按钮
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"y1_a" highImageName:nil target:self action:@selector(addCapitalControl)];
        
        //绘制UI
        [self drawCapitalControlUI];
        
        //获取数据
        [self getCapitalControlData];
        
        //删除
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCapitalControl:) name:@"deleteCapitalControl" object:nil];
        
        //新增
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCapitalControlData) name:@"addNewCapitalControlSuccess" object:nil];
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

#pragma mark - 绘制UI
- (void)drawCapitalControlUI
{
    //按日期查询
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, 40)];
        headerView.backgroundColor = GrayColor;
        headerView.userInteractionEnabled = YES;
        [self.view addSubview:headerView];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
        dateLabel.text = @"日期:";
        dateLabel.font = MainFont;
        [headerView addSubview:dateLabel];
        
        //获取当前的年月
        NSString *todayString = [BasicControls TurnTodayDate];
        //当前月份的第一天
        NSMutableString *monthFirstString = [NSMutableString stringWithString:todayString];
        [monthFirstString replaceCharactersInRange:NSMakeRange(todayString.length - 2, 2) withString:@"01"];
        monthFirstString = [monthFirstString mutableCopy];
        
        _FirstDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(50, 5, 90, 30) Date:monthFirstString];
        _FirstDatePicker.delegate = self;
        _FirstDatePicker.backgroundColor = [UIColor whiteColor];
        _FirstDatePicker.textColor = [UIColor blackColor];
        _FirstDatePicker.font = ExtitleFont;
        _FirstDatePicker.labelString = @"  起始日期:";
        [headerView addSubview:_FirstDatePicker];
        
        UILabel *leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(148, 5, 20, 30)];
        leadLabel.text = @"至";
        leadLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:leadLabel];
        
        _SecondDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(168 + 8, 5, 90, 30) Date:todayString];
        _SecondDatePicker.delegate = self;
        _SecondDatePicker.backgroundColor = [UIColor whiteColor];
        _SecondDatePicker.textColor = [UIColor blackColor];
        _SecondDatePicker.font = ExtitleFont;
        _SecondDatePicker.labelString = @"  结束日期:";
        [headerView addSubview:_SecondDatePicker];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(268 + 8, 6, KScreenWidth - 268 - 16, 28);
        button.backgroundColor = Mycolor;
        button.layer.cornerRadius = 4;
        [button setTitle:@"查询" forState:UIControlStateNormal];
        button.titleLabel.font = ExtitleFont;
        [button addTarget:self action:@selector(getCapitalControlData) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
    }
    
    //搜索框
    {
        UIView *Searchview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        [self.view addSubview:Searchview];
        _CapitalControlSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _CapitalControlSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
        _CapitalControlSearchController.searchResultsUpdater = self;
        _CapitalControlSearchController.searchBar.delegate = self;
        _CapitalControlSearchController.dimsBackgroundDuringPresentation = NO;
        _CapitalControlSearchController.hidesNavigationBarDuringPresentation = NO;
        _CapitalControlSearchController.searchBar.placeholder = @"搜索";
        [_CapitalControlSearchController.searchBar sizeToFit];
        [Searchview addSubview:_CapitalControlSearchController.searchBar];
    }
    
    //表示图
    _CapitalControltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 84 - 60 - 64) style:UITableViewStylePlain];
    _CapitalControltableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _CapitalControltableView.delegate = self;
    _CapitalControltableView.dataSource = self;
    _CapitalControltableView.hidden = YES;
    _CapitalControltableView.backgroundColor = GrayColor;
    _CapitalControltableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_CapitalControltableView];
    
    //没有数据
    _NoCapitalControldataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 84 - 64)];
    _NoCapitalControldataView.hidden = YES;
    _NoCapitalControldataView.backgroundColor = [UIColor whiteColor];
    _NoCapitalControldataView.text = @"当前没有纪录";
    [self.view addSubview:_NoCapitalControldataView];
    
    //统计总金额
    {
        _totalCapitalControlViews = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, 60)];
        _totalCapitalControlViews.backgroundColor = [UIColor whiteColor];
        _totalCapitalControlViews.hidden = YES;
        [self.view addSubview:_totalCapitalControlViews];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
        [_totalCapitalControlViews addSubview:lineView];
        
        for (int i = 0; i < 3; i++)
        {
            UILabel *Label = [[UILabel alloc] init];
            Label.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                Label.font = MainFont;
            } else {
                Label.font = ExtitleFont;
            }
            if (i == 0) {
                Label.text = @"合计";
                Label.frame = CGRectMake(10, 20, 40, 20);
            } else if (i == 1) {
                Label.frame = CGRectMake(60 + (totalWidth * 2), 7, totalWidth, 16);
                Label.text = @"总金额";
            } else if (i == 2) {
                Label.frame = CGRectMake(60 + (totalWidth * 2), 37, totalWidth, 16);
                Label.textColor = PriceColor;
                Label.tag = 32103;
            }
            [_totalCapitalControlViews addSubview:Label];
        }
    }

}

#pragma mark - 获取数据
- (void)getCapitalControlData
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *CapitalControlTypeURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_CapitalControl];
    [self showProgress];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_FirstDatePicker.text forKey:@"fsrqq"];
    [params setObject:_SecondDatePicker.text forKey:@"fsrqz"];
    [params setObject:@(_lx) forKey:@"lx"];
    [XPHTTPRequestTool requestMothedWithPost:CapitalControlTypeURL params:params success:^(id responseObject) {
        [self hideProgress];
        
        _CapitalControlDatalist = [CapitalControlModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        
        if (_CapitalControlDatalist.count == 0) {
            _CapitalControltableView.hidden = YES;
            _totalCapitalControlViews.hidden = YES;
            _NoCapitalControldataView.hidden = NO;
        } else {
            _NoCapitalControldataView.hidden = YES;
            _CapitalControltableView.hidden = NO;
            _totalCapitalControlViews.hidden = NO;
            
            //获取查询参数
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (_lx == 0) {
                    for (NSDictionary *dic in _CapitalControlDatalist) {
                        [_KeyNames addObject:[dic valueForKey:@"djh"]];
                        [_KeyNames addObject:[dic valueForKey:@"zh1name"]];
                        [_KeyNames addObject:[dic valueForKey:@"ssgsname"]];
                    }
                } else if (_lx == 3) {
                    for (NSDictionary *dic in _CapitalControlDatalist) {
                        [_KeyNames addObject:[dic valueForKey:@"djh"]];
                        [_KeyNames addObject:[dic valueForKey:@"ssgsname"]];
                        [_KeyNames addObject:[dic valueForKey:@"zhname"]];
                    }
                } else if (_lx == 1) {
                    for (NSDictionary *dic in _CapitalControlDatalist) {
                        [_KeyNames addObject:[dic valueForKey:@"djh"]];
                        [_KeyNames addObject:[dic valueForKey:@"zh1name"]];
                        [_KeyNames addObject:[dic valueForKey:@"zhname"]];
                    }
                }
            });
            
            //添加参数
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _CapitalControlDatalist) {
                NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
                NSString *comment = [dic valueForKey:@"comments"];
                float height = 135 + 60;
                float commentheight = 0;
                if (comment.length == 0) {
                    height += 21 + 6;
                    commentheight += 21;
                } else {
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = 6;
                    NSDictionary *attributes = @{NSFontAttributeName:MainFont,NSParagraphStyleAttributeName:paragraphStyle};
                    CGSize size = [comment boundingRectWithSize:CGSizeMake(KScreenWidth - 77.5, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
                    height += size.height + 6;
                    commentheight += size.height;
                }

                data[@"frame"] = [NSValue valueWithCGRect:CGRectMake(0, 0, KScreenWidth, height)];
                data[@"commentframe"] = [NSValue valueWithCGRect:CGRectMake(50, 45 + 60 - 1.5, KScreenWidth - 77.5, commentheight)];
                [array addObject:data];
            }
            _CapitalControlDatalist = [array mutableCopy];

            [_CapitalControltableView reloadData];
            
            //总计的数据
            [self insertCapitalControlMoneyWithdatalist:_CapitalControlDatalist];
            
            
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}

#pragma mark - 通知事件
//删除
- (void)deleteCapitalControl:(NSNotification *)noti
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:noti.object];
    
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"确定删除吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
            NSString *deleteCapitalControlURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_deleteCapitalControl];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[dic valueForKey:@"id"] forKey:@"id"];
            [XPHTTPRequestTool requestMothedWithPost:deleteCapitalControlURL params:params success:^(id responseObject) {
                if (_CapitalControlSearchController.active) {
                    [_NewCapitalControlDatalist removeObject:dic];
                } else {
                    [_CapitalControlDatalist removeObject:dic];
                }
                [_CapitalControltableView reloadData];
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

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchKeyNames removeAllObjects];
    [_NewCapitalControlDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.CapitalControlSearchController.searchBar.text];
    self.searchKeyNames = [[self.KeyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    NSMutableSet *newdata = [NSMutableSet set];
    if (_lx == 1) {
        for (NSString *title in self.searchKeyNames) {
            for (NSDictionary *dic in _CapitalControlDatalist) {
                if ([title isEqualToString:[dic valueForKey:@"djh"]] || [title isEqualToString:[dic valueForKey:@"zh1name"]] || [title isEqualToString:[dic valueForKey:@"zhname"]]) {
                    [newdata addObject:dic];
                }
            }
        }
    } else if (_lx == 0) {
        for (NSString *title in self.searchKeyNames) {
            for (NSDictionary *dic in _CapitalControlDatalist) {
                if ([title isEqualToString:[dic valueForKey:@"djh"]] || [title isEqualToString:[dic valueForKey:@"zh1name"]] || [title isEqualToString:[dic valueForKey:@"ssgsname"]]) {
                    [newdata addObject:dic];
                }
            }
        }
    } else if (_lx == 3) {
        for (NSString *title in self.searchKeyNames) {
            for (NSDictionary *dic in _CapitalControlDatalist) {
                if ([title isEqualToString:[dic valueForKey:@"djh"]] || [title isEqualToString:[dic valueForKey:@"zhname"]] || [title isEqualToString:[dic valueForKey:@"ssgsname"]]) {
                    [newdata addObject:dic];
                }
            }
        }
    }
    _NewCapitalControlDatalist = [[newdata allObjects] mutableCopy];
    [_CapitalControltableView reloadData];
    if (_NewCapitalControlDatalist.count != 0) {
        [self insertCapitalControlMoneyWithdatalist:_NewCapitalControlDatalist];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self insertCapitalControlMoneyWithdatalist:_CapitalControlDatalist];
}

#pragma mark - 统计
- (void)insertCapitalControlMoneyWithdatalist:(NSMutableArray *)datalist
{
    UILabel *totalMoneyLabel = (UILabel *)[_totalCapitalControlViews viewWithTag:32103];
    float totalMoney = 0;
    totalMoney = [self leijiaNumDataList:datalist Code:@"je"];
    totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
}

#pragma mark - 新增资金控制
- (void)addCapitalControl
{
    AddCapitalControlViewController *AddCapitalCV = [[AddCapitalControlViewController alloc] init];
    AddCapitalCV.lx = self.lx;
    [self.navigationController pushViewController:AddCapitalCV animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _FirstDatePicker) {
        _FirstDatePicker.maxdateString = _SecondDatePicker.text;
        if (_FirstDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _FirstDatePicker.subView.tag = 1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_FirstDatePicker.subView];
        }
    } else {
        _SecondDatePicker.mindateString = _FirstDatePicker.text;
        if (_SecondDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _SecondDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_SecondDatePicker.subView];
        }
    }
    return NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_CapitalControlSearchController.active) {
        return _NewCapitalControlDatalist.count;
    } else {
        return _CapitalControlDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic;
    if (_CapitalControlSearchController.active) {
        dic = _NewCapitalControlDatalist[indexPath.row];
    } else {
        dic = _CapitalControlDatalist[indexPath.row];
    }
    CGRect rect = [[dic valueForKey:@"frame"] CGRectValue];
    return rect.size.height + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CapitalControlIdent = @"CapitalControlIdent";
    CapitalControlTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CapitalControlTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CapitalControlIdent];
    }
    if (_CapitalControlSearchController.active) {
        cell.dic = _NewCapitalControlDatalist[indexPath.row];
    } else {
        cell.dic = _CapitalControlDatalist[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoreCapitalControlViewController *MoreCapitalControlVC = [[MoreCapitalControlViewController alloc] init];
    if (_CapitalControlSearchController.active) {
        MoreCapitalControlVC.dic = _NewCapitalControlDatalist[indexPath.row];
    } else {
        MoreCapitalControlVC.dic = _CapitalControlDatalist[indexPath.row];
    }
    MoreCapitalControlVC.lx = self.lx;
    [self.navigationController pushViewController:MoreCapitalControlVC animated:YES];
}
@end
