//
//  MoreCapitalControlViewController.m
//  project-x6
//
//  Created by Apple on 2016/11/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MoreCapitalControlViewController.h"
#import "DatePickerViewController.h"
#import "CompanyViewController.h"
#import "StoresViewController.h"

@interface MoreCapitalControlViewController ()<UITextViewDelegate>

{
    UIScrollView *_MoreCapitalControlScrollView;
    
    NSString *_dateString;
    NSDictionary *_ssgsDic;
    NSDictionary *_jbrDic;
    NSDictionary *_acountCallutDic;
    NSDictionary *_acountTransferredDic;
    
    UITextField *_priceTF;
    UITextView *_commentTV;
}

@end

@implementation MoreCapitalControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dateString = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"fsrq"]];
    _ssgsDic = [NSDictionary dictionaryWithObjectsAndKeys:[_dic valueForKey:@"ssgsid"],@"id",[_dic valueForKey:@"ssgsname"],@"name", nil];
    _jbrDic = [NSDictionary dictionaryWithObjectsAndKeys:[_dic valueForKey:@"jsrdm"],@"id",[_dic valueForKey:@"jsrname"],@"name", nil];
    if (_lx == 0) {
        [self naviTitleWhiteColorWithText:@"修改资金收入"];
        _acountTransferredDic = [NSDictionary dictionaryWithObjectsAndKeys:[_dic valueForKey:@"zh1id"],@"id",[_dic valueForKey:@"zh1name"],@"name", nil];
    } else if (_lx == 3) {
        [self naviTitleWhiteColorWithText:@"修改资金支出"];
        _acountCallutDic = [NSDictionary dictionaryWithObjectsAndKeys:[_dic valueForKey:@"zhid"],@"id",[_dic valueForKey:@"zhname"],@"name", nil];

    } else {
        [self naviTitleWhiteColorWithText:@"修改资金调配"];
        _acountTransferredDic = [NSDictionary dictionaryWithObjectsAndKeys:[_dic valueForKey:@"zh1id"],@"id",[_dic valueForKey:@"zh1name"],@"name", nil];
        _acountCallutDic = [NSDictionary dictionaryWithObjectsAndKeys:[_dic valueForKey:@"zhid"],@"id",[_dic valueForKey:@"zhname"],@"name", nil];

    }
    

    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(SaveMoreCapitalControl)];
    
    //绘制UI
    [self drawMoreNewCapitalControlUI];
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
- (void)drawMoreNewCapitalControlUI
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
    
    _MoreCapitalControlScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenWidth - 64 - 20)];
    _MoreCapitalControlScrollView.showsVerticalScrollIndicator = NO;
    _MoreCapitalControlScrollView.contentSize = CGSizeMake(KScreenWidth, 20 + (titles.count - 1) * 45 + 85);
    _MoreCapitalControlScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_MoreCapitalControlScrollView];
    
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + 45 * i, 80, 21)];
        label.font = MainFont;
        label.text = titles[i];
        [_MoreCapitalControlScrollView addSubview:label];
        
        if (i < titles.count - 1) {
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [_MoreCapitalControlScrollView addSubview:lineView];
            if (i < titles.count - 2) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(90, 12 + 45 * i, KScreenWidth - 90 - 27.5, 21);
                button.titleLabel.font = MainFont;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                button.tag = 321010 + i;
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(ChooseMoreCapitalControlDetail:) forControlEvents:UIControlEventTouchUpInside];
                [_MoreCapitalControlScrollView addSubview:button];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 17.5, 14 + 45 * i, 7.5, 15)];
                imageView.image = [UIImage imageNamed:@"y1_b"];
                [_MoreCapitalControlScrollView addSubview:imageView];
            }
            
        }
    }    
    _priceTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 180 + 12, KScreenWidth - 100, 21)];
    _priceTF.textAlignment = NSTextAlignmentRight;
    _priceTF.font = MainFont;
    _priceTF.borderStyle = UITextBorderStyleNone;
    _priceTF.placeholder = placers[4];
    _priceTF.keyboardType = UIKeyboardTypeNumberPad;
    [_MoreCapitalControlScrollView addSubview:_priceTF];
    
    _commentTV = [[UITextView alloc] initWithFrame:CGRectMake(90, 225 + 6, KScreenWidth - 100, 60)];
    _commentTV.font = MainFont;
    _commentTV.delegate = self;
    [_MoreCapitalControlScrollView addSubview:_commentTV];
    
    [self showCapitalControlData];
}

#pragma mark - 展示数据
- (void)showCapitalControlData
{
    UIButton *datebutton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321010];
    [datebutton setTitle:[_dic valueForKey:@"fsrq"] forState:UIControlStateNormal];
    if (_lx == 0 || _lx == 3) {
        UIButton *ssgsbutton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321011];
        UIButton *jbrbutton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321012];
        UIButton *acountbutton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321013];

        [ssgsbutton setTitle:[_dic valueForKey:@"ssgsname"] forState:UIControlStateNormal];
        [jbrbutton setTitle:[_dic valueForKey:@"jsrname"] forState:UIControlStateNormal];
        if (_lx == 0) {
            [acountbutton setTitle:[_dic valueForKey:@"zh1name"] forState:UIControlStateNormal];
        } else {
            [acountbutton setTitle:[_dic valueForKey:@"zhname"] forState:UIControlStateNormal];
        }
    } else {
        UIButton *Callutbutton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321011];
        UIButton *Transferredbutton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321012];
        UIButton *jsrbutton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321013];
        [Callutbutton setTitle:[_dic valueForKey:@"zhname"] forState:UIControlStateNormal];
        [Transferredbutton setTitle:[_dic valueForKey:@"zh1name"] forState:UIControlStateNormal];
        [jsrbutton setTitle:[_dic valueForKey:@"jsrname"] forState:UIControlStateNormal];
    }
    
    _priceTF.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"je"]];
    _commentTV.text = [_dic valueForKey:@"comments"];
}

#pragma mark - 保存数据
- (void)SaveMoreCapitalControl
{
    if (![self WhetherSaveDataIsClearOrNot]) {
        return;
    }
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *SaveCapitalControlURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@",[_dic valueForKey:@"id"]] forKey:@"id"];

    //日期
    if (_dateString.length == 0) {
        [params setObject:[self.dic valueForKey:@"fsrq"] forKey:@"fsrq"];
    } else {
        [params setObject:_dateString forKey:@"fsrq"];
    }
    
    //经手人
    if (_jbrDic == nil) {
        [params setObject:[self.dic valueForKey:@"jsrdm"] forKey:@"jsrdm"];
    } else {
        [params setObject:[NSString stringWithFormat:@"%@",[_jbrDic valueForKey:@"id"]] forKey:@"jsrdm"];
    }
    
    //金额
    if (_priceTF.text.length == 0) {
        [params setObject:[NSString stringWithFormat:@"%@",[self.dic valueForKey:@"je"]] forKey:@"je"];
    } else {
        [params setObject:_priceTF.text forKey:@"je"];
    }
    
    //备注
    if (_commentTV.text.length == 0) {
        [params setObject:[self.dic valueForKey:@"comments"] forKey:@"comments"];
    } else {
        [params setObject:_commentTV.text forKey:@"comments"];
    }


    if (_lx == 0 || _lx == 3) {
        //公司代码
        if (_ssgsDic == nil) {
            [params setObject:[NSString stringWithFormat:@"%@",[self.dic valueForKey:@"ssgsid"]] forKey:@"ssgsid"];
        } else {
            [params setObject:[NSString stringWithFormat:@"%@",[_ssgsDic valueForKey:@"id"]] forKey:@"ssgsid"];
        }
        
        if (_lx == 0) {
            SaveCapitalControlURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AddCapitalIncome];
            if (_acountTransferredDic == nil) {
                [params setObject:[NSString stringWithFormat:@"%@",[self.dic valueForKey:@"zh1id"]] forKey:@"zh1id"];
            } else {
                [params setObject:[NSString stringWithFormat:@"%@",[_acountTransferredDic valueForKey:@"id"]] forKey:@"zh1id"];
            }
        } else {
            SaveCapitalControlURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AddCapitalExpenditure];
            if (_acountCallutDic == nil) {
                [params setObject:[NSString stringWithFormat:@"%@",[self.dic valueForKey:@"zhid"]] forKey:@"zhid"];
            } else {
                [params setObject:[NSString stringWithFormat:@"%@",[_acountCallutDic valueForKey:@"id"]] forKey:@"zhid"];
            }
        }
        
    } else {
        SaveCapitalControlURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AddCapitalDeployment];
        if (_acountTransferredDic == nil) {
            [params setObject:[NSString stringWithFormat:@"%@",[self.dic valueForKey:@"zh1id"]] forKey:@"zh1id"];
        } else {
            [params setObject:[NSString stringWithFormat:@"%@",[_acountTransferredDic valueForKey:@"id"]] forKey:@"zh1id"];
        }
        SaveCapitalControlURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_AddCapitalExpenditure];
        if (_acountCallutDic == nil) {
            [params setObject:[NSString stringWithFormat:@"%@",[self.dic valueForKey:@"zhid"]] forKey:@"zhid"];
        } else {
            [params setObject:[NSString stringWithFormat:@"%@",[_acountCallutDic valueForKey:@"id"]] forKey:@"zhid"];
        }
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
- (void)ChooseMoreCapitalControlDetail:(UIButton *)button
{
    if (button.tag == 321010) {
        DatePickerViewController *datePickerVC = [[DatePickerViewController alloc] init];
        datePickerVC.date = _dateString;
        datePickerVC.LabelString = @"请选择日期";
        [self.navigationController pushViewController:datePickerVC animated:YES];
    }
    if (_lx == 1) {
        if (button.tag == 321011) {
            StoresViewController *BankAcountVC = [[StoresViewController alloc] init];
            BankAcountVC.WhichChooseString = X6_BankAcount;
            [self.navigationController pushViewController:BankAcountVC animated:YES];
        } else if (button.tag == 321012) {
            StoresViewController *BankAcountVC = [[StoresViewController alloc] init];
            BankAcountVC.WhichChooseString = X6_BankAcount;
            BankAcountVC.IsDeployment = YES;
            BankAcountVC.IsIncome = YES;
            [self.navigationController pushViewController:BankAcountVC animated:YES];
        } else if (button.tag == 321013) {
            StoresViewController *StaffVC = [[StoresViewController alloc] init];
            StaffVC.WhichChooseString = X6_Staff;
            [self.navigationController pushViewController:StaffVC animated:YES];
        }
    } else {
        if (button.tag == 321011) {
            CompanyViewController *CompanyVC = [[CompanyViewController alloc] init];
            [self.navigationController pushViewController:CompanyVC animated:YES];
        } else if (button.tag == 321012) {
            StoresViewController *StaffVC = [[StoresViewController alloc] init];
            StaffVC.WhichChooseString = X6_Staff;
            [self.navigationController pushViewController:StaffVC animated:YES];
        } else if (button.tag == 321013) {
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
    UIButton *dateButton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321000];
    [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateButton setTitle:noti.object forState:UIControlStateNormal];
}

//公司
- (void)CapitalControlChooseCompany:(NSNotification *)noti
{
    _ssgsDic = noti.object;
    UIButton *CompanyButton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321001];
    [CompanyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [CompanyButton setTitle:[_ssgsDic valueForKey:@"name"] forState:UIControlStateNormal];
}

//经办人
- (void)CapitalControlChooseStaff:(NSNotification *)noti
{
    _jbrDic = noti.object;
    UIButton *StaffButton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321002];
    [StaffButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [StaffButton setTitle:[_jbrDic valueForKey:@"name"] forState:UIControlStateNormal];
}


//调出账户
- (void)CapitalControlCallut:(NSNotification *)noti
{
    _acountCallutDic = noti.object;
    UIButton *CallutButton;
    if (_lx == 1) {
        CallutButton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321001];
    } else {
        CallutButton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321003];
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
        TransferredButton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321002];
    } else {
        TransferredButton = (UIButton *)[_MoreCapitalControlScrollView viewWithTag:321003];
    }
    [TransferredButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TransferredButton setTitle:[_acountTransferredDic valueForKey:@"name"] forState:UIControlStateNormal];
}

#pragma mark - 判断保存的数据是否为空
- (BOOL)WhetherSaveDataIsClearOrNot
{
    NSString *fsrq = [self.dic valueForKey:@"fsrq"];
    if (fsrq.length == 0 && _dateString.length == 0) {
        [BasicControls showAlertWithMsg:@"请选择日期" addTarget:nil];
        return NO;
    }
    
     if (_lx == 0 || _lx == 3) {
        NSString *ssgsname = [self.dic valueForKey:@"ssgsname"];
         if (ssgsname.length == 0 && _ssgsDic == nil) {
             [BasicControls showAlertWithMsg:@"请选择公司" addTarget:nil];
             return NO;
         }
         NSString *jsrname = [self.dic valueForKey:@"jsrname"];
         if (jsrname.length == 0 && _jbrDic == nil) {
             [BasicControls showAlertWithMsg:@"请选择经手人" addTarget:nil];
             return NO;
         }
         NSString *je = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"je"]];
         if (je.length == 0 && _priceTF.text == nil) {
             [BasicControls showAlertWithMsg:@"请填写金额" addTarget:nil];
             return NO;
         }
         
         if (_lx == 0) {
             NSString *zh1name = [self.dic valueForKey:@"zh1name"];
             if (zh1name.length == 0 && _acountTransferredDic == nil) {
                 [BasicControls showAlertWithMsg:@"请选择调入账户" addTarget:nil];
                 return NO;
             }
         } else {
             NSString *zhname = [self.dic valueForKey:@"zhname"];
             if (zhname.length == 0 && _acountCallutDic == nil) {
                 [BasicControls showAlertWithMsg:@"请选择调出账户" addTarget:nil];
                 return NO;
             }
         }

     } else {
         NSString *zh1name = [self.dic valueForKey:@"zh1name"];
         NSString *zhname = [self.dic valueForKey:@"zhname"];

         if (zh1name.length == 0 && _acountTransferredDic == nil) {
             [BasicControls showAlertWithMsg:@"请选择调入账户" addTarget:nil];
             return NO;
         }
         if (zhname.length == 0 && _acountCallutDic == nil) {
             [BasicControls showAlertWithMsg:@"请选择调出账户" addTarget:nil];
             return NO;
         }
     }
    return YES;
}

@end
