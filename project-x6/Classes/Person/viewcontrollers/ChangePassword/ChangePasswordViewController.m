//
//  ChangePasswordViewController.m
//  project-x6
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@end

@implementation ChangePasswordViewController
- (void)dealloc
{
    self.view = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self naviTitleWhiteColorWithText:@"修改密码"];
    
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"改变密码收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }

}

- (void)creatUI
{
    UIView *changePasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 134)];
    changePasswordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:changePasswordView];
    
    NSArray *labelStrings = @[@"原密码",@"新密码", @"确认新密码"];
    NSArray *placeholders = @[@"请输入原密码",@"请输入新密码", @"请确认新密码"];
    for (int i = 0; i < placeholders.count; i++) {
        UILabel *headeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + 45 * i, 90, 20)];
        headeLabel.font = MainFont;
        headeLabel.text = labelStrings[i];
        [changePasswordView addSubview:headeLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12 + 45 * i, KScreenWidth - 110, 20)];
        textField.placeholder = placeholders[i];
        textField.secureTextEntry = YES;
        textField.tag = 800 + i;
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [changePasswordView addSubview:textField];
        
        if (i < 2) {
            UIView *imaline = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [changePasswordView addSubview:imaline];
        }
  
    }
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(10, 184, KScreenWidth - 20, 45);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 4;
    button.backgroundColor = Mycolor;
    [button setTitle:@"确认" forState:UIControlStateNormal];
    button.titleLabel.font = TitleFont;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changepassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)changepassword:(UIButton *)button
{
    
    [self.view endEditing:YES];
    
    UITextField *oldpassword = (UITextField *)[self.view viewWithTag:800];
    UITextField *newpassword = (UITextField *)[self.view viewWithTag:801];
    UITextField *tonewpassword = (UITextField *)[self.view viewWithTag:802];
    
    if (oldpassword.text.length == 0) {
        //请输入新密码
        [BasicControls showAlertWithMsg:@"请输入原密码" addTarget:nil];
    } else if (newpassword.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入新密码" addTarget:nil];
    } else if (tonewpassword.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请确定新密码" addTarget:nil];
    } else if (![newpassword.text isEqualToString:tonewpassword.text]) {
        [BasicControls showAlertWithMsg:@"您的新密码不一致，请重新输入" addTarget:nil];
    } else if (oldpassword.text.length != 0 && newpassword.text.length != 0 && [newpassword.text isEqualToString:tonewpassword.text]) {
        //更改密码
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
        NSString *userid = [dic objectForKey:@"id"];
        NSString *userURL = [userdefaults objectForKey:X6_UseUrl];
        NSString *changePassword = [NSString stringWithFormat:@"%@%@",userURL,X6_changePassword];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:userid forKey:@"id"];
        [params setObject:oldpassword.text forKey:@"old_pwd"];
        [params setObject:newpassword.text forKey:@"pwd"];
        
        [XPHTTPRequestTool requestMothedWithPost:changePassword params:params success:^(id responseObject) {
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"密码修改成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertcontroller addAction:cancelaction];
            [alertcontroller addAction:okaction];
            [self presentViewController:alertcontroller animated:YES completion:nil];
        } failure:^(NSError *error) {

        }];
        
    }
    
}


@end
