//
//  FingerLinkAcountViewController.m
//  project-x6
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FingerLinkAcountViewController.h"

@interface FingerLinkAcountViewController ()<UITextFieldDelegate>

{
    int _index;
    int _identity;
    UIButton *_linkAcountButton;
}
@end

@implementation FingerLinkAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *usedic;
    if ([userdefaults objectForKey:X6_newUserMessage] != nil) {
        usedic = [userdefaults objectForKey:X6_newUserMessage];
    } else {
        usedic = [userdefaults objectForKey:X6_UserMessage];
    }
    
    //人员选择
    NSArray *identitys = @[@"营业员",@"操作员"];
    for (int i = 0; i < 2; i++) {
        UIButton *ensureidentityLabel = [[UIButton alloc] initWithFrame:CGRectMake(10 + ((KScreenWidth - 20) / 2.0) * i, 10, (KScreenWidth - 20) / 2.0, 45)];
        [ensureidentityLabel setTitle:identitys[i] forState:UIControlStateNormal];
        if ([[usedic allKeys] containsObject:@"pwd"]) {
            _identity = 1;
            if (i == 1) {
                [ensureidentityLabel setBackgroundColor:Mycolor];
                [ensureidentityLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [ensureidentityLabel setBackgroundColor:[UIColor whiteColor]];
                [ensureidentityLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        } else {
            _identity = 0;
            if (i == 1) {
                [ensureidentityLabel setBackgroundColor:[UIColor whiteColor]];
                [ensureidentityLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else {
                [ensureidentityLabel setBackgroundColor:Mycolor];
                [ensureidentityLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        ensureidentityLabel.tag = 56210 + i;
        [ensureidentityLabel addTarget:self action:@selector(changeidentiy:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:ensureidentityLabel];
        
    }

    
    //第一个页面
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, KScreenWidth, 134)];
    firstView.userInteractionEnabled = YES;
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    //输入框
    NSArray *placeholders = @[@" 请输入公司代码",@" 请输入用户名",@" 请输入密码"];
    NSArray *textfieldImageNames = @[@"p1_b",@"p1_c",@"p1_d"];
    for (int i = 0; i < placeholders.count; i++) {
        UIImageView *textfieldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13 + 45 * i, 19, 19)];
        textfieldImageView.image = [UIImage imageNamed:textfieldImageNames[i]];
        [firstView addSubview:textfieldImageView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textfieldImageView.right + 10, 45 * i, KScreenWidth - 49, 44)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.delegate = self;
        if (i == 0) {
            textField.text = [usedic valueForKey:@"gsdm"];
            textField.keyboardType = UIKeyboardTypeNumberPad;
        } else if (i == 1) {
            textField.text = [usedic valueForKey:@"phone"];
        } else if (i == 2) {
            if ([[usedic allKeys] containsObject:@"pwd"]) {
                textField.text = [usedic valueForKey:@"pwd"];
            } else {
                textField.text = [usedic valueForKey:@"apppwd"];
            }
        }
        textField.placeholder = placeholders[i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.tag = 56110 + i;
        if (i == placeholders.count - 1) {
            textField.secureTextEntry = YES;
        }
        [firstView addSubview:textField];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(10, 44 + 45 * i, KScreenWidth - 10, .5)];
        [firstView addSubview:lineView];
    }
    
    
    _linkAcountButton = [[UIButton alloc] initWithFrame:CGRectMake(10, firstView.bottom + 21, KScreenWidth - 20, 45)];
    _linkAcountButton.backgroundColor = Mycolor;
    _linkAcountButton.clipsToBounds = YES;
    _linkAcountButton.layer.cornerRadius = 4;
    [_linkAcountButton setTitle:@"取消指纹绑定" forState:UIControlStateNormal];
    _linkAcountButton.titleLabel.font = TitleFont;
    [_linkAcountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_linkAcountButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [_linkAcountButton addTarget:self action:@selector(cancleOrsurefingerlink:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_linkAcountButton];

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

#pragma MARK - 动作
- (void)cancleOrsurefingerlink:(UIButton *)button
{
    UITextField *company = (UITextField *)[self.view viewWithTag:56110];
    UITextField *userid = (UITextField *)[self.view viewWithTag:56111];
    UITextField *password = (UITextField *)[self.view viewWithTag:56112];
    if (_index == 0) {
        company.text = nil;
        userid.text = nil;
        password.text = nil;
        [_linkAcountButton setTitle:@"新的账户绑定" forState:UIControlStateNormal];
        _index++;
    } else {
        //网络请求
        if (company.text.length == 0) {
            [BasicControls showAlertWithMsg:@"公司代码不能为空" addTarget:nil];
        } else if (userid.text.length == 0) {
            [BasicControls showAlertWithMsg:@"用户名不能为空" addTarget:nil];
        } else if (password.text.length == 0) {
            [BasicControls showAlertWithMsg:@"密码不能为空" addTarget:nil];
        } else {
            [self checkMessageWithCompany:company.text Userid:userid.text Pwd:password.text];
        }
    }
}

- (void)changeidentiy:(UIButton *)button
{
    if (_index != 0) {
        if (button.tag - 56210 != _identity)
        {
            [button setBackgroundColor:Mycolor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton *exbutton = [self.view viewWithTag:56210 + _identity];
            [exbutton setBackgroundColor:[UIColor whiteColor]];
            [exbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _identity = (int)(button.tag - 56210);
        }
    }
}

- (void)checkMessageWithCompany:(NSString *)company Userid:(NSString *)userid Pwd:(NSString *)pwd
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:company forKey:@"gsdm"];
    NSString *xlstring = @"电信";
    NSData *data = [xlstring dataUsingEncoding:NSUTF8StringEncoding];
    [params setObject:data forKey:@"xl"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    [self showProgress];
    [manager POST:X6_API_loadmain parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //继续网络请求
        if ([[responseObject objectForKey:@"type"] isEqualToString:@"error"]) {
            [BasicControls showAlertWithMsg:@"该公司未开通" addTarget:nil];
        } else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *leaderurl = [responseObject objectForKey:@"message"];
                NSString *mainURL;

                if (_identity == 1) {
                    mainURL = [NSString stringWithFormat:@"%@%@",leaderurl,X6_API_load];
                } else {
                    mainURL = [NSString stringWithFormat:@"%@/ygLogin.action",leaderurl];
                }
                
                NSMutableDictionary *paramsload = [NSMutableDictionary dictionary];
                [paramsload setObject:company forKey:@"gsdm"];
                [paramsload setObject:userid forKey:@"uname"];
                [paramsload setObject:pwd forKey:@"pwd"];
                AFHTTPRequestOperationManager *managerload = [AFHTTPRequestOperationManager manager];
//                [managerload setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
                [managerload POST:mainURL parameters:paramsload success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self hideProgress];
                    //登陆成功
                    if ([[responseObject objectForKey:@"type"] isEqualToString:@"error"]) {
                        [BasicControls showAlertWithMsg:[responseObject objectForKey:@"message"] addTarget:nil];
                    } else {
                        [BasicControls showNDKNotifyWithMsg:@"绑定成功" WithDuration:1 speed:1];
                        [_linkAcountButton setTitle:@"取消账户绑定" forState:UIControlStateNormal];
                        _index--;
                        //保存新的用户信息
                        NSMutableDictionary *loaddictionary = [responseObject valueForKey:@"vo"];
                        NSUserDefaults *userdefalust = [NSUserDefaults standardUserDefaults];
                        [userdefalust setObject:loaddictionary forKey:X6_newUserMessage];
                        [userdefalust synchronize];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self hideProgress];
                }];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideProgress];
        
    }];

}
@end
