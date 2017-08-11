//
//  AddCapitalControlViewController.m
//  project-x6
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AddCapitalControlViewController.h"
#import "DatePickerViewController.h"
#import "CompanyViewController.h"
#import "StoresViewController.h"
@interface AddCapitalControlViewController ()<UITextViewDelegate>

{
    UIScrollView *_NewCapitalControlScrollView;
    
    NSString *_dateString;
    NSDictionary *_ssgsDic;
    NSDictionary *_jbrDic;
    NSDictionary *_acountCallutDic;
    NSDictionary *_acountTransferredDic;
    
    UITextField *_priceTF;
    UITextView *_commentTV;
    
}
@end

@implementation AddCapitalControlViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (_lx == 0) {
        [self naviTitleWhiteColorWithText:@"新增资金收入"];
    } else if (_lx == 3) {
        [self naviTitleWhiteColorWithText:@"新增资金支出"];
    } else {
        [self naviTitleWhiteColorWithText:@"新增资金调配"];
    }
    
    _dateString = [NSString string];
    _ssgsDic = [NSDictionary dictionary];
    _jbrDic = [NSDictionary dictionary];
    _acountCallutDic = [NSDictionary dictionary];
    _acountTransferredDic = [NSDictionary dictionary];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(addNewCapitalControl)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CapitalControlsuredate:) name:@"suredate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CapitalControlChooseCompany:) name:@"ChooseCompanyssgs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CapitalControlChooseStaff:) name:@"StaffChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CapitalControlCallut:) name:@"CapitalControlCallutChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CapitalControlTransferred:) name:@"CapitalControlTransferredChange" object:nil];
    
    //绘制UI
    [self drawaddNewCapitalControlUI];
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
- (void)drawaddNewCapitalControlUI
{
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *placers = [NSMutableArray array];

    if (_lx == 0 || _lx == 3) {
        [titles addObjectsFromArray:@[@"日期",@"公司",@"经手人",@"账户",@"金额",@"备注"]];
        [placers addObjectsFromArray:@[@"请选择日期",@"请选择公司",@"请选择经手人",@"请选择账户",@"请输入金额",@"请输入备注内容"]];
    } else {
        [titles addObjectsFromArray:@[@"日期",@"调出账户",@"调入账户",@"经手人",@"金额",@"备注"]];
        [placers addObjectsFromArray:@[@"请选择日期",@"请选择调出账户",@"请选择调入账户",@"请选择经手人",@"请输入金额",@"请输入备注内容"]];
    }
    
    _NewCapitalControlScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenWidth - 64 - 20)];
    _NewCapitalControlScrollView.showsVerticalScrollIndicator = NO;
    _NewCapitalControlScrollView.contentSize = CGSizeMake(KScreenWidth, 20 + (titles.count - 1) * 45 + 85);
    _NewCapitalControlScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_NewCapitalControlScrollView];
    
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + 45 * i, 80, 21)];
        label.font = MainFont;
        label.text = titles[i];
        [_NewCapitalControlScrollView addSubview:label];
        
        if (i < titles.count - 1) {
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [_NewCapitalControlScrollView addSubview:lineView];
            if (i < titles.count - 2) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(90, 12 + 45 * i, KScreenWidth - 90 - 27.5, 21);
                button.titleLabel.font = MainFont;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                button.tag = 321000 + i;
                [button setTitleColor:ColorRGB(190, 190, 205) forState:UIControlStateNormal];
                [button setTitle:placers[i] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(AddNewCapitalControl:) forControlEvents:UIControlEventTouchUpInside];
                [_NewCapitalControlScrollView addSubview:button];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 17.5, 14 + 45 * i, 7.5, 15)];
                imageView.image = [UIImage imageNamed:@"y1_b"];
                [_NewCapitalControlScrollView addSubview:imageView];
            }
        }
    }
    
    _priceTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 180 + 12, KScreenWidth - 100, 21)];
    _priceTF.textAlignment = NSTextAlignmentRight;
    _priceTF.font = MainFont;
    _priceTF.borderStyle = UITextBorderStyleNone;
    _priceTF.placeholder = placers[4];
    _priceTF.keyboardType = UIKeyboardTypeNumberPad;
    [_NewCapitalControlScrollView addSubview:_priceTF];
    
    _commentTV = [[UITextView alloc] initWithFrame:CGRectMake(90, 225 + 6, KScreenWidth - 100, 60)];
    _commentTV.font = MainFont;
    _commentTV.delegate = self;
    [_NewCapitalControlScrollView addSubview:_commentTV];
}

#pragma mark - 保存数据
- (void)addNewCapitalControl
{
    if (_dateString.length == 0) {
        [BasicControls showAlertWithMsg:@"请选择日期" addTarget:nil];
        return;
    } else if (_jbrDic == nil) {
        [BasicControls showAlertWithMsg:@"请选择经手人" addTarget:nil];
        return;
    } else if (_priceTF.text == nil) {
        [BasicControls showAlertWithMsg:@"请填写金额" addTarget:nil];
        return;
    }
    
    if (_lx == 0 || _lx == 3) {
        if (_lx == 0 && _acountTransferredDic == nil) {
            [BasicControls showAlertWithMsg:@"请填写调入账户" addTarget:nil];
            return;
        } else if (_lx == 3 && _acountCallutDic == nil) {
            [BasicControls showAlertWithMsg:@"请填写调出账户" addTarget:nil];
            return;
        }
    } else {
        if (_acountTransferredDic == nil) {
            [BasicControls showAlertWithMsg:@"请填写调入账户" addTarget:nil];
            return;
        } else if (_acountCallutDic == nil) {
            [BasicControls showAlertWithMsg:@"请填写调出账户" addTarget:nil];
            return;
        }
    }
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *SaveCapitalControlURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(-1) forKey:@"id"];
    [params setObject:_dateString forKey:@"fsrq"];
    [params setObject:_priceTF.text forKey:@"je"];
    [params setObject:[NSString stringWithFormat:@"%@",[_jbrDic valueForKey:@"id"]] forKey:@"jsrdm"];
    [params setObject:_commentTV.text forKey:@"comments"];

    if (_lx == 0 || _lx == 3) {
        [params setObject:[NSString stringWithFormat:@"%@",[_ssgsDic valueForKey:@"id"]] forKey:@"ssgsid"];
        if (_lx == 0) {
            SaveCapitalControlURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AddCapitalIncome];
            [params setObject:[NSString stringWithFormat:@"%@",[_acountTransferredDic valueForKey:@"id"]] forKey:@"zh1id"];
        } else {
            SaveCapitalControlURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AddCapitalExpenditure];
            [params setObject:[NSString stringWithFormat:@"%@",[_acountCallutDic valueForKey:@"id"]] forKey:@"zhid"];
        }
    } else {
        SaveCapitalControlURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AddCapitalDeployment];
        [params setObject:[NSString stringWithFormat:@"%@",[_acountTransferredDic valueForKey:@"id"]] forKey:@"zh1id"];
        [params setObject:[NSString stringWithFormat:@"%@",[_acountCallutDic valueForKey:@"id"]] forKey:@"zhid"];

    }
    [XPHTTPRequestTool reloadMothedWithPost:SaveCapitalControlURL params:params success:^(id responseObject) {
        [BasicControls showNDKNotifyWithMsg:@"保存成功" WithDuration:1 speed:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCapitalControlSuccess" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"保存失败");
    }];
}

#pragma mark - 按钮事件
- (void)AddNewCapitalControl:(UIButton *)button
{
    if (_lx == 1) {
        if (button.tag == 321000) {
            DatePickerViewController *datePickerVC = [[DatePickerViewController alloc] init];
            datePickerVC.date = [BasicControls TurnTodayDate];
            datePickerVC.LabelString = @"请选择日期";
            [self.navigationController pushViewController:datePickerVC animated:YES];
        } else if (button.tag == 321001) {
            StoresViewController *BankAcountVC = [[StoresViewController alloc] init];
            BankAcountVC.WhichChooseString = X6_BankAcount;
            [self.navigationController pushViewController:BankAcountVC animated:YES];
        } else if (button.tag == 321002) {
            StoresViewController *BankAcountVC = [[StoresViewController alloc] init];
            BankAcountVC.WhichChooseString = X6_BankAcount;
            BankAcountVC.IsDeployment = YES;
            BankAcountVC.IsIncome = YES;
            [self.navigationController pushViewController:BankAcountVC animated:YES];
        } else if (button.tag == 321003) {
            StoresViewController *StaffVC = [[StoresViewController alloc] init];
            StaffVC.WhichChooseString = X6_Staff;
            [self.navigationController pushViewController:StaffVC animated:YES];
        }
    } else {
        if (button.tag == 321000) {
            DatePickerViewController *datePickerVC = [[DatePickerViewController alloc] init];
            datePickerVC.date = [BasicControls TurnTodayDate];
            datePickerVC.LabelString = @"请选择日期";
            [self.navigationController pushViewController:datePickerVC animated:YES];
        } else if (button.tag == 321001) {
            CompanyViewController *CompanyVC = [[CompanyViewController alloc] init];
            [self.navigationController pushViewController:CompanyVC animated:YES];
        } else if (button.tag == 321002) {
            StoresViewController *StaffVC = [[StoresViewController alloc] init];
            StaffVC.WhichChooseString = X6_Staff;
            [self.navigationController pushViewController:StaffVC animated:YES];
        } else if (button.tag == 321003) {
            StoresViewController *BankAcountVC = [[StoresViewController alloc] init];
            BankAcountVC.WhichChooseString = X6_BankAcount;
            if (_lx == 0) {
                BankAcountVC.IsIncome = YES;
            }
            [self.navigationController pushViewController:BankAcountVC animated:YES];
        }
    }
}

#pragma mark - 通知事件
//日期
- (void)CapitalControlsuredate:(NSNotification *)noti
{
    _dateString = noti.object;
    UIButton *dateButton = (UIButton *)[_NewCapitalControlScrollView viewWithTag:321000];
    [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateButton setTitle:noti.object forState:UIControlStateNormal];
}

//公司
- (void)CapitalControlChooseCompany:(NSNotification *)noti
{
    _ssgsDic = noti.object;
    UIButton *CompanyButton = (UIButton *)[_NewCapitalControlScrollView viewWithTag:321001];
    [CompanyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [CompanyButton setTitle:[_ssgsDic valueForKey:@"name"] forState:UIControlStateNormal];
}

//经办人
- (void)CapitalControlChooseStaff:(NSNotification *)noti
{
    _jbrDic = noti.object;
    UIButton *StaffButton;
    if (_lx == 1) {
        StaffButton = (UIButton *)[_NewCapitalControlScrollView viewWithTag:321003];;
    } else {
        StaffButton = (UIButton *)[_NewCapitalControlScrollView viewWithTag:321002];;
    }
    
    [StaffButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [StaffButton setTitle:[_jbrDic valueForKey:@"name"] forState:UIControlStateNormal];
}


//调出账户
- (void)CapitalControlCallut:(NSNotification *)noti
{
    _acountCallutDic = noti.object;
    UIButton *CallutButton;
    if (_lx == 1) {
        CallutButton = (UIButton *)[_NewCapitalControlScrollView viewWithTag:321001];
    } else {
        CallutButton = (UIButton *)[_NewCapitalControlScrollView viewWithTag:321003];
    }
    [CallutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [CallutButton setTitle:[_acountCallutDic valueForKey:@"name"] forState:UIControlStateNormal];
}

//调入账户
- (void)CapitalControlTransferred:(NSNotification *)noti
{
    _acountTransferredDic = noti.object;
    UIButton *TransferredButton;
    if (_lx == 1) {
        TransferredButton = (UIButton *)[_NewCapitalControlScrollView viewWithTag:321002];
    } else {
        TransferredButton = (UIButton *)[_NewCapitalControlScrollView viewWithTag:321003];
    }
    [TransferredButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TransferredButton setTitle:[_acountTransferredDic valueForKey:@"name"] forState:UIControlStateNormal];
}

@end
