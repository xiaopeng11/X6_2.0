//
//  LoadViewController.m
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LoadViewController.h"

#import "ZFTouchID.h"

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"

#import "JPUSHService.h"

#import "UserRegisterViewController.h"
#import "ForgetpasswordViewController.h"
#import "HelpViewController.h"
@interface LoadViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

{
    NSArray *_placeholders;
    
    UIScrollView *_loadscorllView;
}
@end

@implementation LoadViewController


- (void)dealloc
{
    self.view = nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GrayColor;
    
    
    [self drawViews];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *newUserMessage = [userdefaults objectForKey:X6_newUserMessage];
    NSDictionary *UserMessage = [userdefaults objectForKey:X6_UserMessage];

    if (newUserMessage != nil) {
        if (_isLeader == YES && [[newUserMessage allKeys] containsObject:@"pwd"]) {
            [_loadscorllView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
            [self clickyourhead];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            return;
        } else if (_isLeader == NO && [[newUserMessage allKeys] containsObject:@"apppwd"]) {
            [_loadscorllView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
            [self clickyourhead];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            return;
        }
    } else if (UserMessage != nil) {
        if (_isLeader == YES && [[UserMessage allKeys] containsObject:@"pwd"]) {
            [_loadscorllView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
            [self clickyourhead];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            return;
        } else if (_isLeader == NO && [[UserMessage allKeys] containsObject:@"apppwd"]) {
            [_loadscorllView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
            [self clickyourhead];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            return;
        }
    }
}

#pragma mark - view
- (void)drawViews
{
    //滑动式图
    _loadscorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadscorllView.delegate = self;
    _loadscorllView.pagingEnabled = YES;
    _loadscorllView.showsHorizontalScrollIndicator = NO;
    _loadscorllView.showsVerticalScrollIndicator = NO;
    _loadscorllView.contentSize = CGSizeMake(KScreenWidth * 2, 100);
    _loadscorllView.bounces = NO;
    _loadscorllView.scrollEnabled = NO;
    _loadscorllView.backgroundColor = GrayColor;
    [self.view addSubview:_loadscorllView];
    
    //导航栏
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    naviView.backgroundColor = Mycolor;
    naviView.userInteractionEnabled = YES;
    [_loadscorllView addSubview:naviView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2.0, 20, 200, 44)];
    if (_isLeader == YES) {
        title.text = @"管理员登录";
    } else {
        title.text = @"营业员登录";
    }
    title.font = TitleFont;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [naviView addSubview:title];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 25, 34, 34);
    [backButton setImage:[UIImage imageNamed:@"g3_a"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    

    //第一个页面
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 10, KScreenWidth, 134)];
    firstView.userInteractionEnabled = YES;
    firstView.backgroundColor = [UIColor whiteColor];
    [_loadscorllView addSubview:firstView];

    //输入框
    _placeholders = @[@" 请输入公司代码",@" 请输入用户名",@" 请输入密码"];
    NSArray *textfieldImageNames = @[@"p1_b",@"p1_c",@"p1_d"];
    for (int i = 0; i < _placeholders.count; i++) {
        UIImageView *textfieldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13 + 45 * i, 19, 19)];
        textfieldImageView.image = [UIImage imageNamed:textfieldImageNames[i]];
        [firstView addSubview:textfieldImageView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textfieldImageView.right + 10, 45 * i, KScreenWidth - 49, 44)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.delegate = self;
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *usedic = [userdefaults objectForKey:X6_UserMessage];
        if (usedic != nil) {
            if (_isLeader && [[usedic allKeys] containsObject:@"pwd"]) {
                if (i == 0) {
                    textField.text = [usedic valueForKey:@"gsdm"];
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                } else if (i == 1) {
                    textField.text = [usedic valueForKey:@"phone"];
                }
            } else if (!_isLeader && [[usedic allKeys] containsObject:@"apppwd"]) {
                if (i == 0) {
                    textField.text = [usedic valueForKey:@"gsdm"];
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                } else if (i == 1) {
                    textField.text = [usedic valueForKey:@"phone"];
                }
            }
        }
        textField.placeholder = _placeholders[i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.tag = 10 + i;
        if (i == _placeholders.count - 1) {
            textField.secureTextEntry = YES;
        }
        [firstView addSubview:textField];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(10, 44 + 45 * i, KScreenWidth - 10, .5)];
        [firstView addSubview:lineView];
    }
    
    
    UIButton *loadButton = [[UIButton alloc] initWithFrame:CGRectMake(10, firstView.bottom + 21, KScreenWidth - 20, 45)];
    loadButton.backgroundColor = Mycolor;
    loadButton.clipsToBounds = YES;
    loadButton.layer.cornerRadius = 4;
    [loadButton setTitle:@"登录" forState:UIControlStateNormal];
    loadButton.titleLabel.font = TitleFont;
    [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [loadButton addTarget:self action:@selector(loadtabAction) forControlEvents:UIControlEventTouchUpInside];
    loadButton.layer.cornerRadius = 5;
    [_loadscorllView addSubview:loadButton];
  
    UIButton *userRegisterButton = [[UIButton alloc] initWithFrame:CGRectMake(10, loadButton.bottom + 10, 70, 20)];
    userRegisterButton.backgroundColor = [UIColor clearColor];
    [userRegisterButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [userRegisterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    userRegisterButton.titleLabel.font = ExtitleFont;
    [userRegisterButton addTarget:self action:@selector(RegisterAction) forControlEvents:UIControlEventTouchUpInside];
    [_loadscorllView addSubview:userRegisterButton];
    
    UIButton *forgetPas = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 80, userRegisterButton.top, 70, 20)];
    forgetPas.backgroundColor = [UIColor clearColor];
    [forgetPas setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPas setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetPas.titleLabel.font = ExtitleFont;
    [forgetPas addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [_loadscorllView addSubview:forgetPas];
    
    
    UIButton *firstchangeloadway = [UIButton buttonWithType:UIButtonTypeCustom];
    firstchangeloadway.frame = CGRectMake((KScreenWidth - 100) / 2.0, KScreenHeight - 100 - 64, 100, 100);
    firstchangeloadway.tag = 10001100;
    [firstchangeloadway addTarget:self action:@selector(changeloadway:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *headimageView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 10, 34, 33)];
    headimageView.image = [UIImage imageNamed:@"zhiwen_1"];
    [firstchangeloadway addSubview:headimageView];
    
    UILabel *headlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 100, 25)];
    headlabel.text = @"切换指纹登陆";
    headlabel.textAlignment = NSTextAlignmentCenter;
    headlabel.font = ExtitleFont;
    headlabel.textColor = [UIColor colorWithRed:26/255.0 green:139/255.0 blue:224/255.0 alpha:1];
    [firstchangeloadway addSubview:headlabel];
    [_loadscorllView addSubview:firstchangeloadway];
    
    
    //第二页内容
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight)];
    secondView.backgroundColor = [UIColor whiteColor];
    [_loadscorllView addSubview:secondView];
    
    //头像
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 74) / 2.0, 82, 74, 74)];
    headerView.clipsToBounds = YES;
    headerView.layer.cornerRadius = 37;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    
    //公司代码
    NSString *gsdm = [userInformation objectForKey:@"gsdm"];
    
    //员工头像地址
    NSString *ygImageUrl = [userdefaults objectForKey:X6_UserHeaderView];
    NSString *info_imageURL = [userInformation objectForKey:@"userpic"];
    if ([userdefaults objectForKey:X6_UserHeaderView] != nil) {
        [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_czyURL,gsdm,ygImageUrl]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    } else {
        [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_czyURL,gsdm,info_imageURL]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    }
    
    [secondView addSubview:headerView];
    
    //指纹
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(((KScreenWidth - 140) / 2.0), 82 + 74 + 110.5, 140, 140);
    [clickButton addTarget:self action:@selector(clickyourhead) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *secondImageview = [[UIImageView alloc] initWithFrame:CGRectMake(33, 0, 74, 74)];
    secondImageview.image = [UIImage imageNamed:@"zhiwen_2"];
    [clickButton addSubview:secondImageview];
    
    UILabel *secondlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74 + 14, 140, 25)];
    secondlabel.textAlignment = NSTextAlignmentCenter;
    secondlabel.font = ExtitleFont;
    secondlabel.textColor = [UIColor colorWithRed:26/255.0 green:139/255.0 blue:224/255.0 alpha:1];
    secondlabel.text = @"点击进行指纹解锁";
    [clickButton addSubview:secondlabel];
    [secondView addSubview:clickButton];
    
    UIButton *secondchangeloadway = [UIButton buttonWithType:UIButtonTypeCustom];
    secondchangeloadway.frame = CGRectMake(((KScreenWidth - 100)/2.0), KScreenHeight - 55, 100, 25);
    [secondchangeloadway addTarget:self action:@selector(changeloadway:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *secondchangelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    secondchangelabel.font = ExtitleFont;
    secondchangelabel.textAlignment = NSTextAlignmentCenter;
    secondchangelabel.textColor = [UIColor colorWithRed:26/255.0 green:139/255.0 blue:224/255.0 alpha:1];
    secondchangelabel.text = @"切换账号登陆";
    [secondchangeloadway addSubview:secondchangelabel];
    
    [secondView addSubview:secondchangeloadway];
}

#pragma mark - loadAction：
- (void)loadtabAction
{
    [self.view endEditing:YES];
    
    UITextField *company = (UITextField *)[self.view viewWithTag:10];
    UITextField *userid = (UITextField *)[self.view viewWithTag:11];
    UITextField *password = (UITextField *)[self.view viewWithTag:12];

    //网络请求
    if (company.text.length == 0) {
        [BasicControls showAlertWithMsg:@"公司代码不能为空" addTarget:nil];
    } else if (userid.text.length == 0) {
        [BasicControls showAlertWithMsg:@"用户名不能为空" addTarget:nil];
    } else if (password.text.length == 0) {
        [BasicControls showAlertWithMsg:@"密码不能为空" addTarget:nil];
    } else {
        [self loadWithCompany:company.text Userid:userid.text Pwd:password.text IsAcountload:YES];
    }
}

- (void)loadWithCompany:(NSString *)company
                 Userid:(NSString *)userid
                    Pwd:(NSString *)pwd
           IsAcountload:(BOOL)isAcountload
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:company forKey:@"gsdm"];
    NSString *xlstring = @"电信";
    NSData *data = [xlstring dataUsingEncoding:NSUTF8StringEncoding];
    [params setObject:data forKey:@"xl"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 加上这行代码，https ssl 验证。
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    [self showProgress];
    [manager POST:X6_API_loadmain parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //继续网络请求
        if ([[responseObject objectForKey:@"type"] isEqualToString:@"error"]) {
            [self hideProgress];
            [BasicControls showAlertWithMsg:[responseObject objectForKey:@"message"] addTarget:nil];
        } else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *leaderurl = [responseObject objectForKey:@"message"];
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *userdic;
                if ([userdefaults objectForKey:X6_newUserMessage] != nil) {
                    userdic = [userdefaults objectForKey:X6_newUserMessage];
                } else {
                    userdic = [userdefaults objectForKey:X6_UserMessage];
                }
                NSString *mainURL;
                if (isAcountload) {
                    if (_isLeader) {
                        mainURL = [NSString stringWithFormat:@"%@%@",leaderurl,X6_API_load];
                    } else {
                        mainURL = [NSString stringWithFormat:@"%@/ygLogin.action",leaderurl];
                    }
                } else {
                    if ([[userdic allKeys] containsObject:@"pwd"]) {
                        mainURL = [NSString stringWithFormat:@"%@%@",leaderurl,X6_API_load];
                    } else {
                        mainURL = [NSString stringWithFormat:@"%@/ygLogin.action",leaderurl];
                    }
                }
                
                NSMutableDictionary *paramsload = [NSMutableDictionary dictionary];
                [paramsload setObject:company forKey:@"gsdm"];
                [paramsload setObject:userid forKey:@"uname"];
                [paramsload setObject:pwd forKey:@"pwd"];
                AFHTTPRequestOperationManager *managerload = [AFHTTPRequestOperationManager manager];
                // 加上这行代码，https ssl 验证。
//                [managerload setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
                [managerload POST:mainURL parameters:paramsload success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self hideProgress];
                    //登陆成功
                    if ([[responseObject objectForKey:@"type"] isEqualToString:@"error"]) {
                        [BasicControls showAlertWithMsg:[responseObject objectForKey:@"message"] addTarget:nil];
                    } else {
                        //保存cookie
                        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                        
                        NSMutableDictionary *loaddictionary = [responseObject valueForKey:@"vo"];
                        NSArray *userqxList = [NSArray arrayWithArray:[responseObject valueForKey:@"qxlist"]];
                        NSDictionary *subvo = [NSDictionary dictionaryWithDictionary:[responseObject valueForKey:@"subvo"]];
                        //保存本地
                        [userdefaults setObject:data forKey:X6_Cookie];
                        [userdefaults setObject:loaddictionary forKey:X6_UserMessage];
                        [userdefaults setObject:leaderurl forKey:X6_UseUrl];
                        [userdefaults setObject:[loaddictionary objectForKey:@"userpic"] forKey:X6_UserHeaderView];
                        [userdefaults setObject:@YES forKey:X6_isLoading];
                        [userdefaults setObject:@(0) forKey:X6_refresh];
  
                        //注册环信账号(后期添加参数判断是否已经登陆过)
                        NSString *EaseID;
                        NSString *phoneString = [[responseObject valueForKey:@"vo"] valueForKey:@"phone"];
                        if (phoneString.length == 11) {
                            if (isAcountload) {
                                if (_isLeader) {
                                    [userdefaults setObject:userqxList forKey:X6_UserQXList];
                                    [self setJPUSHDataWithDic:loaddictionary QxArray:userqxList Subvo:subvo];
                                    EaseID = [NSString stringWithFormat:@"%@0%@",company,[[responseObject valueForKey:@"vo"] valueForKey:@"phone"]];
                                } else {
                                    EaseID = [NSString stringWithFormat:@"%@1%@",company,[[responseObject valueForKey:@"vo"] valueForKey:@"phone"]];
                                }
                            } else {
                                if ([[userdic allKeys] containsObject:@"pwd"]) {
                                    [userdefaults setObject:userqxList forKey:X6_UserQXList];
                                    [self setJPUSHDataWithDic:loaddictionary QxArray:userqxList Subvo:subvo];
                                    EaseID = [NSString stringWithFormat:@"%@0%@",company,[[responseObject valueForKey:@"vo"] valueForKey:@"phone"]];
                                } else {
                                    EaseID = [NSString stringWithFormat:@"%@1%@",company,[[responseObject valueForKey:@"vo"] valueForKey:@"phone"]];
                                }
                            }
                            
                            NSString *password = @"yjxx&*()";
                            
                            if (![[EaseMob sharedInstance].chatManager loginWithUsername:EaseID password:password error:nil]) {
                                [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:EaseID password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
                                    NSLog(@"环信注册完成");
                                } onQueue:nil];
                            }
                            
                            //登录
                            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:EaseID password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                                //设置成自动登录
                                NSLog(@"自动登录成功");
                                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                
                                //获取数据库中数据
                                [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                
                                EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                                [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
                                    NSLog(@"全局设置完成");
                                } onQueue:nil];
                                
                                //单独设置昵称
                                [[EaseMob sharedInstance].chatManager setApnsNickname:[loaddictionary valueForKey:@"name"]];
                                
                            }onQueue:nil];
                        } else {
                            if (isAcountload) {
                                if (_isLeader) {
                                    [userdefaults setObject:userqxList forKey:X6_UserQXList];
                                    [self setJPUSHDataWithDic:loaddictionary QxArray:userqxList Subvo:subvo];
                                }
                            } else {
                                if ([[userdic allKeys] containsObject:@"pwd"]) {
                                    [userdefaults setObject:userqxList forKey:X6_UserQXList];
                                    [self setJPUSHDataWithDic:loaddictionary QxArray:userqxList Subvo:subvo];
                                }
                            }
                        }
                        
                        BaseTabBarViewController *baseVC = [[BaseTabBarViewController alloc] init];
                        if (isAcountload) {
                            if (_isLeader) {
                                [userdefaults setObject:@"isleader" forKey:X6_UserIdentity];
                            } else {
                                [userdefaults setObject:@"isuser" forKey:X6_UserIdentity];
                            }
                        } else {
                            if ([[userdic allKeys] containsObject:@"pwd"]) {
                                [userdefaults setObject:@"isleader" forKey:X6_UserIdentity];
                            } else {
                                [userdefaults setObject:@"isuser" forKey:X6_UserIdentity];
                            }
                        }
                        [userdefaults synchronize];
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                        window.rootViewController = baseVC;
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self hideProgress];
                    NSLog(@"登陆失败%@",error);
                }];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideProgress];
        NSLog(@"域名登录失败");
    }];
}

#pragma mark - 按钮事件
//用户注册
- (void)RegisterAction
{
    UserRegisterViewController *userRegisterVC = [[UserRegisterViewController alloc] init];
    userRegisterVC.isleader = _isLeader;
    [self presentViewController:userRegisterVC animated:YES completion:nil];
}

//忘记密码
- (void)forgetPassword
{
    ForgetpasswordViewController *forgetPSVC = [[ForgetpasswordViewController alloc] init];
    forgetPSVC.isleader = _isLeader;
    [self presentViewController:forgetPSVC animated:YES completion:nil];
}

//返回
- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//华东页面
- (void)changeloadway:(UIButton *)button
{
    if (button.tag == 10001100) {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *usedic = [userdefaults objectForKey:X6_UserMessage];
        if (usedic != nil) {
            [_loadscorllView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
            [self clickyourhead];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        } else {
            [BasicControls showAlertWithMsg:@"首次登陆只能通过账户名登陆！" addTarget:nil];
        }

    } else {
        [_loadscorllView setContentOffset:CGPointMake(0, 0) animated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

//点击指纹解锁
- (void)clickyourhead
{
    ZFTouchID *touchID = [[ZFTouchID alloc] init];
    [touchID TouchIDWithDetail:@"登陆已绑定的X6账号" Block:^(BOOL success, kErrorType type, NSError *error) {
        if (success) {
            // 识别成功
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *userdic;
            if ([userdefaults objectForKey:X6_newUserMessage] != nil) {
                userdic = [userdefaults objectForKey:X6_newUserMessage];
            } else {
                userdic = [userdefaults objectForKey:X6_UserMessage];
            }
            NSString *password;
            if ([[userdic allKeys] containsObject:@"pwd"]) {
                password = [userdic valueForKey:@"pwd"];
            } else {
                password = [userdic valueForKey:@"apppwd"];
            }
            
            [self loadWithCompany:[userdic valueForKey:@"gsdm"] Userid:[userdic valueForKey:@"name"] Pwd:password IsAcountload:NO];
        }else {
            // 识别失败
            NSLog(@"识别失败");
            // 如果验证失败，需要在这里判断各种不同的情况已进行不同的处理
            switch (type) {
                case kErrorTypeAuthenticationFailed:
                    [BasicControls showAlertWithMsg:@"您手机的指纹解锁功能当前不可用，无法使用指纹识别。\n请到iPhone的“设置”－“Touch ID与密码”中恢复指纹解锁功能" addTarget:nil];
                    break;
                case kErrorTypeUserCancel:
                    NSLog(@"kErrorTypeUserCancel");
                    break;
                case kErrorTypeUserFallback:
                    NSLog(@"kErrorTypeUserFallback");
                    break;
                    // ...
                default:
                    break;
            }
        }
    }];

}

- (void)setJPUSHDataWithDic:(NSDictionary *)dic QxArray:(NSArray *)qxArray Subvo:(NSDictionary *)subvo
{
    //设置极光tags
    NSString *ssgs = [NSString stringWithFormat:@"%@_%@",[dic valueForKey:@"gsdm"],[dic valueForKey:@"ssgs"]];
    NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:ssgs, nil];
    for (NSDictionary *dic in qxArray) {
        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                [set addObject:@"XJXC"];
            }
        } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]){
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                [set addObject:@"CGJJ"];
            }
        } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]){
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                [set addObject:@"LSXJ"];
            }
        }
    }
    for (NSString *tags in [subvo allValues]) {
        [set addObject:tags];
    }
    
    [JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"极光的tags：%@,返回的状态吗：%d",iTags,iResCode);
    }];
}

@end
