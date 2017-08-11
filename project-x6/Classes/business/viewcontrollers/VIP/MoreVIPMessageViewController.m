//
//  MoreVIPMessageViewController.m
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MoreVIPMessageViewController.h"
#import "CustomertypeViewController.h"
#import "StoresViewController.h"
#import "DatePickerViewController.h"

@interface MoreVIPMessageViewController ()<UITextFieldDelegate>

{
    NSDictionary *_VIPMessage;      //会员信息
    
    UIScrollView *_MoreVipScrollView;
    UIView *_MoreVipBgView;
    
    UITextField *_nameTF;             //姓名
    UITextField *_VIPCardNumTF;       //会员卡号
    UITextField *_phoneTF;            //手机号
    UITextField *_IDnumberTF;         //身份证
    UITextField *_creatDateTF;        //注册时间
    UITextField *_InitialTF;          //初始积分
    UITextField *_nowInitialTF;       //当前积分
    UITextView *_beizhuTF;            //备注
    
    NSString *_ssgsid;
}
@end

@implementation MoreVIPMessageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(saveoldVIP)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customertype:) name:@"customertypeChange" object:nil
     ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ageGroup:) name:@"ageGroupChange" object:nil
     ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sexChoose:) name:@"sexChange" object:nil
     ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(belongcompany:) name:@"storeChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suredate:) name:@"suredate" object:nil];

    
    [self naviTitleWhiteColorWithText:@"详情"];
    _VIPMessage = [NSDictionary dictionary];
    //获取数据
    dispatch_group_t grouped = dispatch_group_create();
    [self getVIPMessageWithVIPid:_VIPid Group:grouped];
    dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
        //页面
        [self drawnewVIPmessageUI];
    });
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_phoneTF isFirstResponder] || [_nameTF isFirstResponder] || [_VIPCardNumTF isFirstResponder] || [_IDnumberTF isFirstResponder] || [_InitialTF isFirstResponder] || [_beizhuTF isFirstResponder]) {
        [_phoneTF resignFirstResponder];
        [_VIPCardNumTF resignFirstResponder];
        [_IDnumberTF resignFirstResponder];
        [_InitialTF resignFirstResponder];
        [_beizhuTF resignFirstResponder];
        [_nameTF resignFirstResponder];
    }
}


#pragma mark - 获取会员信息
- (void)getVIPMessageWithVIPid:(NSString *)vIPid Group:(dispatch_group_t)group
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *vipdetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_VIPDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.VIPid forKey:@"id"];
    if (group != nil) {
        dispatch_group_enter(group);
    }
    [XPHTTPRequestTool requestMothedWithPost:vipdetailURL params:params success:^(id responseObject) {
        _VIPMessage = responseObject[@"vo"];
        _ssgsid = [NSString stringWithFormat:@"%@",[_VIPMessage valueForKey:@"ssgsid"]];
        if (group != nil) {
            dispatch_group_leave(group);
        }
    } failure:^(NSError *error) {
        if (group != nil) {
            dispatch_group_leave(group);
        }
    }];
}



#pragma mark - 按钮
//保存
- (void)saveoldVIP
{
    UIButton *hylxbutton = [_MoreVipBgView viewWithTag:3091011];
    NSString *hylxString = hylxbutton.titleLabel.text;
    UIButton *sexbutton = [_MoreVipBgView viewWithTag:3091015];
    NSString *sexString = sexbutton.titleLabel.text;
    UIButton *agebutton = [_MoreVipBgView viewWithTag:3091017];
    NSString *ageString = agebutton.titleLabel.text;
    UIButton *birthbutton = [_MoreVipBgView viewWithTag:3091016];
    NSString *birthString = birthbutton.titleLabel.text;

    [self saveVIPWithName:_nameTF.text Hylx:hylxString Hykh:_VIPCardNumTF.text CompanyID:_ssgsid Iphone:_phoneTF.text Sex:sexString Birthday:birthString Agegroup:ageString IDNumber:_IDnumberTF.text Baseiniyjf:_InitialTF.text Nowjf:_nowInitialTF.text Comment:_beizhuTF.text Vipid:self.VIPid Initflag:[_VIPMessage valueForKey:@"initflag"]];
}

- (void)saveVIPWithName:(NSString *)name
                   Hylx:(NSString *)hylx
                   Hykh:(NSString *)hykh
              CompanyID:(NSString *)companyID
                 Iphone:(NSString *)iphone
                    Sex:(NSString *)sex
               Birthday:(NSString *)birthday
               Agegroup:(NSString *)agegroup
               IDNumber:(NSString *)iDNumber
             Baseiniyjf:(NSString *)baseiniyjf
                  Nowjf:(NSString *)nowjf
                Comment:(NSString *)comment
                  Vipid:(NSString *)vipid
               Initflag:(NSString *)initflag
{
    
    
    if (name == nil) {
        [BasicControls showAlertWithMsg:@"请输入姓名" addTarget:nil];
        return;
    } else if ([hylx isEqualToString:@"请选择会员类型"]) {
        [BasicControls showAlertWithMsg:@"请选择会员类型" addTarget:nil];
        return;
    } else if ([companyID isEqualToString:@"请选择所属门店"]) {
        [BasicControls showAlertWithMsg:@"请选择所属门店" addTarget:nil];
        return;
    } else if ([iphone isEqualToString:@"请输入手机号"]) {
        [BasicControls showAlertWithMsg:@"请输入手机号" addTarget:nil];
        return;
    } else if ([agegroup isEqualToString:@"请选择年龄段"]) {
        [BasicControls showAlertWithMsg:@"请选择年龄段" addTarget:nil];
        return;
    }
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *vipdetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_NewVIP];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //id
    [params setObject:vipid forKey:@"id"];
    //姓名
    [params setObject:name forKey:@"name"];
    //会员类型
    [params setObject:hylx forKey:@"hylx"];
    //所属门店
    [params setObject:companyID forKey:@"ssgsid"];
    //卡号
    [params setObject:hykh forKey:@"cardno"];
    //联系号码
    [params setObject:iphone forKey:@"lxhm"];
    //初始积分
    [params setObject:baseiniyjf forKey:@"initjf"];
    //年龄段
    [params setObject:agegroup forKey:@"nld"];
    //性别
    if ([sex isEqualToString:@"男"]) {
        [params setObject:@"0" forKey:@"sex"];
    } else {
        [params setObject:@"1" forKey:@"sex"];
    }
    //生日
    [params setObject:birthday forKey:@"csny"];
    //当前积分
    [params setObject:nowjf forKey:@"jf"];
    //初始是否完成
    [params setObject:initflag forKey:@"initflag"];
    
    [self showProgress];
    [XPHTTPRequestTool reloadMothedWithPost:vipdetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        [BasicControls showNDKNotifyWithMsg:@"保存成功" WithDuration:1 speed:1];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self hideProgress];
        [BasicControls showNDKNotifyWithMsg:@"提交失败！" WithDuration:1 speed:1];
    }];
    
}

//提示按钮
- (void)NewVIPplacerholder:(UIButton *)button
{
    if (button.tag - 3091010 == 1) {
        //用户类型
        CustomertypeViewController *supportInitVC = [[CustomertypeViewController alloc] init];
        supportInitVC.naviTitle = @"会员类型";
        [self.navigationController pushViewController:supportInitVC animated:YES];
    } else if (button.tag - 3091010 == 3) {
        StoresViewController *storesVC = [[StoresViewController alloc] init];
        storesVC.WhichChooseString = X6_storesList;
        [self.navigationController pushViewController:storesVC animated:YES];
    } else if (button.tag - 3091010 == 7) {
        CustomertypeViewController *supportInitVC = [[CustomertypeViewController alloc] init];
        supportInitVC.naviTitle = @"会员年龄段";
        [self.navigationController pushViewController:supportInitVC animated:YES];
    } else if (button.tag - 3091010 == 5) {
        CustomertypeViewController *supportInitVC = [[CustomertypeViewController alloc] init];
        supportInitVC.naviTitle = @"性别";
        [self.navigationController pushViewController:supportInitVC animated:YES];
    } else if (button.tag - 3091010 == 6) {
        DatePickerViewController *datePickerVC = [[DatePickerViewController alloc] init];
        datePickerVC.date = [_VIPMessage valueForKey:@"csny"];
        datePickerVC.LabelString = @"请选择出生日期";
        [self.navigationController pushViewController:datePickerVC animated:YES];
    }
}

#pragma mark - 通知事件
//用户类型
- (void)customertype:(NSNotification *)noti
{
    UIButton *hylxbutton = [_MoreVipBgView viewWithTag:3091011];
    [hylxbutton setTitle:noti.object forState:UIControlStateNormal];
    [hylxbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

//所属门店
- (void)belongcompany:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    UIButton *ssgsbutton = [_MoreVipBgView viewWithTag:3091013];
    [ssgsbutton setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
    [ssgsbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _ssgsid = [dic valueForKey:@"id"];
}

//年龄段
- (void)ageGroup:(NSNotification *)noti
{
    UIButton *agebutton = [_MoreVipBgView viewWithTag:3091017];
    [agebutton setTitle:noti.object forState:UIControlStateNormal];
    [agebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//性别
- (void)sexChoose:(NSNotification *)noti
{
    UIButton *sexbutton = [_MoreVipBgView viewWithTag:3091015];
    [sexbutton setTitle:noti.object forState:UIControlStateNormal];
    [sexbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//出生日期
- (void)suredate:(NSNotification *)noti
{
    UIButton *datebutton = [_MoreVipBgView viewWithTag:3091016];
    [datebutton setTitle:noti.object forState:UIControlStateNormal];
    [datebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma MARK - 绘制UI
- (void)drawnewVIPmessageUI
{
    //判断是新增还是详情
    NSArray *titles = @[@"姓名",@"会员类型",@"会员卡号",@"所属门店",@"手机号",@"性别",@"生日",@"年龄段",@"身份证号",@"注册日期",@"初始积分",@"当前积分",@"备注"];
    //提示的集合
    NSArray *newVIPplacerholders = @[@"请输入姓名",@"请选择会员类型",@"请输入会员卡号",@"请选择所属门店",@"请输入手机号",@"请选择性别",@"请选择出生日期",@"请选择年龄段",@"请输入身份证号",@"请输入初始积分",@"请输入备注内容"];
    
    //背景
    _MoreVipScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _MoreVipScrollView.showsVerticalScrollIndicator = NO;
    _MoreVipScrollView.contentSize = CGSizeMake(KScreenWidth, 20 + (titles.count - 1) * 45 + 85);
    [self.view addSubview:_MoreVipScrollView];
    
    _MoreVipBgView = [[UIView alloc] init];
    _MoreVipBgView.frame = CGRectMake(0, 10, KScreenWidth, (titles.count - 1) * 45 + 85);
    _MoreVipBgView.backgroundColor = [UIColor whiteColor];
    [_MoreVipScrollView addSubview:_MoreVipBgView];
    
    //姓名
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 10, KScreenWidth - 90, 21)];
    _nameTF.textAlignment = NSTextAlignmentRight;
    _nameTF.font = ExtitleFont;
    _nameTF.text = [_VIPMessage valueForKey:@"name"];
    _nameTF.borderStyle = UITextBorderStyleNone;
    _nameTF.placeholder = newVIPplacerholders[0];
    [_MoreVipBgView addSubview:_nameTF];
    
    //会员卡号
    _VIPCardNumTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 12 + 45 * 2, KScreenWidth - 90, 21)];
    _VIPCardNumTF.textAlignment = NSTextAlignmentRight;
    _VIPCardNumTF.font = ExtitleFont;
    _VIPCardNumTF.text = [_VIPMessage valueForKey:@"cardno"];
    _VIPCardNumTF.borderStyle = UITextBorderStyleNone;
    _VIPCardNumTF.placeholder = newVIPplacerholders[2];
    [_MoreVipBgView addSubview:_VIPCardNumTF];
    
    //手机号
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 12 + 45 * 4, KScreenWidth - 90, 21)];
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.textAlignment = NSTextAlignmentRight;
    _phoneTF.font = ExtitleFont;
    _phoneTF.text = [_VIPMessage valueForKey:@"lxhm"];
    _phoneTF.borderStyle = UITextBorderStyleNone;
    _phoneTF.placeholder = newVIPplacerholders[4];
    [_MoreVipBgView addSubview:_phoneTF];

    
    //身份证
    _IDnumberTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 12 + 45 * 8, KScreenWidth - 90, 21)];
    _IDnumberTF.textAlignment = NSTextAlignmentRight;
    _IDnumberTF.keyboardType = UIKeyboardTypeNumberPad;
    _IDnumberTF.font = ExtitleFont;
    _IDnumberTF.text = [_VIPMessage valueForKeyPath:@"sfzh"];
    _IDnumberTF.borderStyle = UITextBorderStyleNone;
    _IDnumberTF.placeholder = newVIPplacerholders[8];
    [_MoreVipBgView addSubview:_IDnumberTF];
    
    //注册时间
    _creatDateTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 12 + 45 * 9, KScreenWidth - 90, 21)];
    _creatDateTF.textAlignment = NSTextAlignmentRight;
    _creatDateTF.keyboardType = UIKeyboardTypeNumberPad;
    _creatDateTF.font = ExtitleFont;
    _creatDateTF.text = [_VIPMessage valueForKeyPath:@"fsrq"];
    _creatDateTF.borderStyle = UITextBorderStyleNone;
    _creatDateTF.enabled = NO;
    [_MoreVipBgView addSubview:_creatDateTF];
    
    //初始积分
    _InitialTF = [[UITextField alloc] init];
    _InitialTF.frame = CGRectMake(80, 12 + 45 * 10, KScreenWidth - 90, 21);
    _InitialTF.textAlignment = NSTextAlignmentRight;
    _InitialTF.keyboardType = UIKeyboardTypeNumberPad;
    _InitialTF.font = ExtitleFont;
    _InitialTF.text = [NSString stringWithFormat:@"%@",[_VIPMessage valueForKey:@"initjf"]];
    _InitialTF.borderStyle = UITextBorderStyleNone;
    _InitialTF.placeholder = newVIPplacerholders[9];
    if ([[_VIPMessage valueForKey:@"initflag"] intValue] == 1) {
        _InitialTF.userInteractionEnabled = NO;
    } else {
        _InitialTF.userInteractionEnabled = YES;
    }
    [_MoreVipBgView addSubview:_InitialTF];
    
    
    //当前积分
    _nowInitialTF = [[UITextField alloc] init];
    _nowInitialTF.frame = CGRectMake(80, 12 + 45 * 11, KScreenWidth - 90, 21);
    _nowInitialTF.textAlignment = NSTextAlignmentRight;
    _nowInitialTF.keyboardType = UIKeyboardTypeNumberPad;
    _nowInitialTF.font = ExtitleFont;
    _nowInitialTF.text = [NSString stringWithFormat:@"%@",[_VIPMessage valueForKey:@"jf"]];
    _nowInitialTF.borderStyle = UITextBorderStyleNone;
    _nowInitialTF.placeholder = newVIPplacerholders[9];
    [_MoreVipBgView addSubview:_nowInitialTF];
    
    
    //备注
    _beizhuTF = [[UITextView alloc] init];
    _beizhuTF.frame = CGRectMake(80, 10 + 45 * 12, KScreenWidth - 90, 65);
    _beizhuTF.backgroundColor = [UIColor whiteColor];
    _beizhuTF.tag = 3112120;
    _beizhuTF.font = MainFont;
    _beizhuTF.text = [_VIPMessage valueForKey:@"comments"];
    [_MoreVipBgView addSubview:_beizhuTF];
    
    //标题／下划线／提示文本
    for (int i = 0; i < titles.count; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + 45 * i, 70, 21)];
        title.text = titles[i];
        title.font = MainFont;
        [_MoreVipBgView addSubview:title];
        
        if (i < titles.count - 1) {
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [_MoreVipBgView addSubview:lineView];
            if (i == 1 || i == 3 || i == 5 || i == 6 || i == 7) {
                UIButton *placerholderButton = [UIButton buttonWithType:UIButtonTypeCustom];
                placerholderButton.frame = CGRectMake(80, 12 + 45 * i, KScreenWidth - 90 - 10, 21);
                [placerholderButton setBackgroundColor:[UIColor whiteColor]];
                [placerholderButton setTitle:newVIPplacerholders[i] forState:UIControlStateNormal];
                [placerholderButton setTitleColor:[UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1] forState:UIControlStateNormal];
                placerholderButton.titleLabel.font = ExtitleFont;
                placerholderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                placerholderButton.tag = 3091010 + i;
                [placerholderButton addTarget:self action:@selector(NewVIPplacerholder:) forControlEvents:UIControlEventTouchUpInside];
                [_MoreVipBgView addSubview:placerholderButton];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 16, 16.5 + 45 * i, 6, 12)];
                imageView.image = [UIImage imageNamed:@"y1_b"];
                [_MoreVipBgView addSubview:imageView];
                
                if (i == 1) {
                    NSString *hylx = [NSString stringWithFormat:@"%@",[_VIPMessage valueForKey:@"hylx"]];
                    if (hylx.length != 0) {
                        [placerholderButton setTitle:hylx forState:UIControlStateNormal];
                        [placerholderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                } else if (i == 3) {
                    NSString *ssgsname = [NSString stringWithFormat:@"%@",[_VIPMessage valueForKey:@"ssgsname"]];
                    if (ssgsname.length != 0) {
                        [placerholderButton setTitle:ssgsname forState:UIControlStateNormal];
                        [placerholderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                } else if (i == 5) {
                    NSString *sex = [NSString stringWithFormat:@"%@",[_VIPMessage valueForKey:@"sex"]];
                    if (sex.length != 0) {
                        if ([[_VIPMessage valueForKey:@"sex"] boolValue] == YES) {
                            [placerholderButton setTitle:@"女" forState:UIControlStateNormal];
                        } else {
                            [placerholderButton setTitle:@"男" forState:UIControlStateNormal];
                        }
                        [placerholderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                } else if (i == 6) {
                    NSString *csny = [NSString stringWithFormat:@"%@",[_VIPMessage valueForKey:@"csny"]];
                    if (csny.length != 0) {
                        [placerholderButton setTitle:csny forState:UIControlStateNormal];
                        [placerholderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                } else if (i == 7) {
                    NSString *fsrq = [NSString stringWithFormat:@"%@",[_VIPMessage valueForKey:@"nld"]];
                    if (fsrq.length != 0) {
                        [placerholderButton setTitle:fsrq forState:UIControlStateNormal];
                        [placerholderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }

}



@end
