//
//  UserRegisterViewController.m
//  project-x6
//
//  Created by Apple on 16/4/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UserRegisterViewController.h"


@interface UserRegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

{
    //滑动试图
    UIScrollView *_mainScrollView;
    
    //公司代码
    UITextField *_gdsmTF;
    
    //手机号码
    UITextField *_phoneTF;
    
    //短信验证码
    UIButton *_acquireButton;
    
    //验证码
    UITextField *_smsCodeTF;
    
    //是否显示获取验证码按钮
    UIButton *_isOrshowButton;
    
    //下一步按钮
    UIButton *_nextButton;
    
    //用户名(汉字)
    UITextField *_userNameTF;
    
    //密码
    UITextField *_passwordTF;
    
    //注册
    UIButton *_registerButton;
}

@property (nonatomic, readwrite, retain)NSTimer *timer;
@end

@implementation UserRegisterViewController

- (void)dealloc
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //滑动式图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _mainScrollView.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight);
    _mainScrollView.backgroundColor = GrayColor;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.scrollEnabled = NO;
    [self.view addSubview:_mainScrollView];
    
    //导航栏
    for (int i = 0; i < 2; i++) {
        UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, 64)];
        naviView.backgroundColor = Mycolor;
        naviView.userInteractionEnabled = YES;
        [_mainScrollView addSubview:naviView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2.0, 20, 200, 44)];
        title.text = @"注册";
        title.font = TitleFont;
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [naviView addSubview:title];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(15, 25, 34, 34);
        backButton.tag = 210 + i;
        [backButton setImage:[UIImage imageNamed:@"g3_a"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(userRegisterbackVC:) forControlEvents:UIControlEventTouchUpInside];
        [naviView addSubview:backButton];
    }
    
    
    //绘制注册页面
    [self drawUserRegisterFirstScrollUI];
    
    [self drawUserRegisterSecondScrollUI];

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
}

#pragma mark - 绘制标题UI层
- (void)drawUserRegisterFirstScrollUI
{
    //第一页背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, KScreenWidth, 45 * 2 + 44.5)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:bgView];
    
    //绘制第一个页面textField之间相隔线
    for (int i = 0 ; i < 2; i++) {
        [self showLineImageWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5) SuperView:bgView];
    }
    
    //公司代码
    {
        UILabel *gsdmLabel = [BasicControls createLabelWithframe:CGRectMake(10, 0, 70, 44) image:nil];
        gsdmLabel.text = @"公司代码";
        gsdmLabel.font = TitleFont;
        [bgView addSubview:gsdmLabel];
        
        _gdsmTF = [BasicControls createTextFieldWithframe:CGRectMake(90, gsdmLabel.top, KScreenWidth - 100, 44) addTarget:self image:nil];
        _gdsmTF.placeholder = @"请输入公司代码";
        _gdsmTF.font = TitleFont;
        _gdsmTF.keyboardType = UIKeyboardTypePhonePad;
        [bgView addSubview:_gdsmTF];
    }
    
    //手机号
    {
        UILabel *phoneLabel = [BasicControls createLabelWithframe:CGRectMake(10, 45, 70, 44) image:nil];
        phoneLabel.text = @"手机号码";
        phoneLabel.font = TitleFont;
        [bgView addSubview:phoneLabel];
        
        _phoneTF = [BasicControls createTextFieldWithframe:CGRectMake(90, phoneLabel.top, KScreenWidth - 100, 44) addTarget:self image:nil];
        _phoneTF.placeholder = @"请输入手机号";
        _phoneTF.font = TitleFont;
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
        [bgView addSubview:_phoneTF];
    }
    
    //验证码
    {
        UILabel *smsCodeLabel = [BasicControls createLabelWithframe:CGRectMake(10, 90, 70, 44) image:nil];
        smsCodeLabel.text = @"验证码";
        smsCodeLabel.font = TitleFont;
        [bgView addSubview:smsCodeLabel];
        
        _smsCodeTF = [BasicControls createTextFieldWithframe:CGRectMake(90, smsCodeLabel.top, KScreenWidth - 90 - 100, 44) addTarget:self image:nil];
        _smsCodeTF.placeholder = @"请输入验证码";
        _smsCodeTF.font = TitleFont;
        _smsCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        [bgView addSubview:_smsCodeTF];
        
        _acquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _acquireButton.frame = CGRectMake(KScreenWidth - 90, _smsCodeTF.top + 10, 80, 25);
        [_acquireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_acquireButton setBackgroundColor:Mycolor];
        _acquireButton.titleLabel.font = ExtitleFont;
        _acquireButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _acquireButton.layer.cornerRadius = 4;
        [_acquireButton addTarget:self action:@selector(requestGetRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_acquireButton];
    }
    
    //无公司代码提示
    {
        UILabel *nogsdmLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, bgView.bottom + 18, KScreenWidth - 50, 26)];
        nogsdmLabel.text = @"提醒:如果您无公司代码,请拨打客服电话开通";
        nogsdmLabel.font = ExtitleFont;
        nogsdmLabel.textColor = ColorRGB(244, 91, 91);
        nogsdmLabel.textAlignment = NSTextAlignmentCenter;
        [_mainScrollView addSubview:nogsdmLabel];
        
        UILabel *callLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 110) / 2.0, nogsdmLabel.bottom + 5, 110, 26)];
        callLabel.font = ExtitleFont;
        callLabel.textAlignment = NSTextAlignmentCenter;
        callLabel.text = @"0512-67671677";
        callLabel.textColor = PriceColor;
        callLabel.userInteractionEnabled = YES;
        [_mainScrollView addSubview:callLabel];
        
        UITapGestureRecognizer *call = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callphone)];
        [callLabel addGestureRecognizer:call];
        
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(callLabel.left, callLabel.bottom, 110, 1)];
        redView.backgroundColor = PriceColor;
        [_mainScrollView addSubview:redView];
    }
    
    //下一步按钮
    {
        _nextButton = [BasicControls createButtonWithTitle:@"下一步" frame:CGRectMake(10, 283 + 25, KScreenWidth - 20, 45) image:nil];
        [_nextButton setBackgroundColor:Mycolor];
        [_nextButton addTarget:self action:@selector(RegisternextAction:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.layer.cornerRadius = 4;
        [_mainScrollView addSubview:_nextButton];
    }


}

- (void)drawUserRegisterSecondScrollUI
{
    //第二页背景
    UIView *nextUseregisterBgview = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth, 74, KScreenWidth, 45 + 44.5)];
    nextUseregisterBgview.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:nextUseregisterBgview];
    
    //绘制第二个页面textField之间相隔线
    [self showLineImageWithFrame:CGRectMake(20, 44.5, KScreenWidth, .5) SuperView:nextUseregisterBgview];
    
    //用户名
    {
        UILabel *userNameLabel = [BasicControls createLabelWithframe:CGRectMake(10, 0, 70, 44.5) image:nil];
        userNameLabel.text = @"用户名";
        userNameLabel.font = TitleFont;
        [nextUseregisterBgview addSubview:userNameLabel];
        
        _userNameTF = [BasicControls createTextFieldWithframe:CGRectMake(90, userNameLabel.top, KScreenWidth - 100, 44.5) addTarget:self image:nil];
        _userNameTF.placeholder = @"请输入用户名";
        _userNameTF.font = TitleFont;
        [nextUseregisterBgview addSubview:_userNameTF];
    }
    
    //登陆密码
    {
        UILabel *passwordLabel = [BasicControls createLabelWithframe:CGRectMake(10, 45, 70, 44.5) image:nil];
        passwordLabel.text = @"密码";
        passwordLabel.font = TitleFont;
        [nextUseregisterBgview addSubview:passwordLabel];
        
        _passwordTF = [BasicControls createTextFieldWithframe:CGRectMake(90, passwordLabel.top, KScreenWidth - 100, 44.5) addTarget:self image:nil];
        _passwordTF.placeholder = @"请输入6~18位有效登陆密码";
        _passwordTF.font = TitleFont;
        [nextUseregisterBgview addSubview:_passwordTF];
    }
    
    //注册按钮
    {
        _registerButton = [BasicControls createButtonWithTitle:@"注册" frame:CGRectMake(KScreenWidth + 10, 213, KScreenWidth - 20, 40) image:nil];
        _registerButton.layer.cornerRadius = 4;
        [_registerButton setBackgroundColor:Mycolor];
        [_registerButton addTarget:self action:@selector(submitNextAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:_registerButton];
    }
}

#pragma mark - 客服电话
- (void)callphone
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:0512-67671677"]]];
    [self.view addSubview:callWebView];
}


#pragma mark - UI动作
//绘制textField之间相隔线
- (void)showLineImageWithFrame:(CGRect)frame SuperView:(UIView *)superView
{
    UIImageView *imageview = [BasicControls createImageViewWithframe:frame image:nil];
    imageview.backgroundColor = LineColor;
    [superView addSubview:imageview];
}

//改变顶部位置位置
-(void)changetoptitleIndex:(float)index
{
    [_mainScrollView setContentOffset:CGPointMake(KScreenWidth * index, 0)];

}

#pragma mark - 按钮事件
//获取验证码
- (void)requestGetRegisterAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    //输入框逻辑处理1
    if (![self manageRegisterViewWithphone]) {
        return;
    }

    //获取验证码
    [self getregistersmscode];
    
}

//下一步
- (void)RegisternextAction:(UIButton *)button
{
    
    [self.view endEditing:YES];
    
    //输入框逻辑处理2
    if (![self manageRegisterViewWithphoneWithSmscode])
    {
        return;
    }
    
    //验证验证吗是否正确
    [self checksmsCodeTF];

}

//注册
- (void)submitNextAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    //输入框逻辑处理3
    if (![self manageRegisterViewWithPSWWithGSDMWithUserName])
    {
        return;
    }
    
    //注册
    [self requestUserRegister];
    
}


//返回
- (void)userRegisterbackVC:(UIButton *)button
{
    
    if (button.tag == 210) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //滑倒左边
        [self changetoptitleIndex:0];
    }
}

#pragma mark - UITextFieldDelegate
//输入框逻辑处理1
- (BOOL)manageRegisterViewWithphone
{
    if (_gdsmTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入公司代码" addTarget:nil];
        return NO;
    }
    if (_phoneTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入手机号" addTarget:nil];
        return NO;
    }
    if (_phoneTF.text.length < 11) {
        [BasicControls showAlertWithMsg:@"请输入11位有效手机号" addTarget:nil];
        return NO;
    }
    return YES;
}

//输入框逻辑处理2
- (BOOL)manageRegisterViewWithphoneWithSmscode
{

    if (_phoneTF.text.length < 11)
    {
        [BasicControls showAlertWithMsg:@"请输入11位有效号码" addTarget:nil];
        return NO;
    }
    if (_smsCodeTF.text.length != 4)
    {
        [BasicControls showAlertWithMsg:@"4位短信数字验证码" addTarget:nil];
        return NO;
    }
    return YES;
}

//输入框逻辑处理3
- (BOOL)manageRegisterViewWithPSWWithGSDMWithUserName
{
    if (_userNameTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入用户名" addTarget:nil];
        return NO;
    }
    
    if (_passwordTF.text.length <= 5  || _passwordTF.text.length > 18)
    {
        [BasicControls showAlertWithMsg:@"请输入6~18为有效登录密码" addTarget:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - 数据网络请求
//获取验证码
- (void)getregistersmscode
{
    NSString *register_getsmscode = [NSString stringWithFormat:@"%@%@",X6basemain_API,X6register_getsmscode];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneTF.text forKey:@"phone"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    [manager POST:register_getsmscode parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:@"type"] isEqualToString:@"success"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码已发" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.tag = 000002;
            [alertView show];
            //网络请求获取验证码
            _acquireButton.enabled = NO;
            NSString *title = [NSString stringWithFormat:@"%@s",[responseObject valueForKey:@"message"]];
            [_acquireButton setTitle:title forState:UIControlStateNormal];
            [_acquireButton setUserInteractionEnabled:NO];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerText:) userInfo:nil repeats:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取失败");
    }];
}


//验证验证吗是否正确
- (void)checksmsCodeTF
{
    NSString *register_checksmscode = [NSString stringWithFormat:@"%@%@",X6basemain_API,X6register_checksmscode];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_smsCodeTF.text forKey:@"yzm"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    [manager POST:register_checksmscode parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:@"type"] isEqualToString:@"success"]) {
            [self.timer invalidate];
            self.timer = nil;
            //滑倒下一页
            [self changetoptitleIndex:1];
        } else {
            [BasicControls showAlertWithMsg:[responseObject valueForKey:@"message"] addTarget:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取失败");
    }];
    
}

//注册
- (void)requestUserRegister
{
    NSString *registerString = [NSString stringWithFormat:@"%@%@",X6basemain_API,X6register];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_gdsmTF.text forKey:@"gsdm"];
    [params setObject:_phoneTF.text forKey:@"phone"];
    [params setObject:_userNameTF.text forKey:@"uname"];
    [params setObject:_passwordTF.text forKey:@"pwd"];
    if (_isleader) {
        [params setObject:@"0" forKey:@"utype"];
    } else {
        [params setObject:@"1" forKey:@"utype"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    [manager POST:registerString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject valueForKey:@"type"] isEqualToString:@"success"]) {
            UIAlertController *cantReigister = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功！请返回登陆" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [cantReigister addAction:sureAction];
            [self presentViewController:cantReigister animated:YES completion:nil];
        } else {
            UIAlertController *cantReigister = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[responseObject valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _phoneTF.text = nil;
                _smsCodeTF.text = nil;
                [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                _acquireButton.enabled = YES;
                [_acquireButton setUserInteractionEnabled:YES];
                _gdsmTF.text = nil;
                _userNameTF.text = nil;
                _passwordTF.text = nil;
                [self changetoptitleIndex:(0)];
            }];
            [cantReigister addAction:sureAction];
            [self presentViewController:cantReigister animated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取失败");
    }];
}



#pragma mark - 获取验证码倒计时
- (void)updateTimerText:(NSTimer*)theTimer
{
    NSString *countdown = _acquireButton.titleLabel.text;
    if([countdown isEqualToString:@"0s"])
    {
        [self.timer invalidate];
        self.timer = nil;
        _acquireButton.enabled = YES;
        [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_acquireButton setUserInteractionEnabled:YES];
        
    } else {
        int icountdown = [countdown intValue];
        icountdown = icountdown - 1;
        NSString *ncountdown = [[NSString alloc] initWithFormat:@"%ds", icountdown];
        
        if (isDevice4_4s){
            _acquireButton.titleLabel.text = ncountdown;
        } else {
            [_acquireButton setTitle:ncountdown forState:UIControlStateNormal];
        }
        [_acquireButton setTitle:ncountdown forState:UIControlStateNormal];
    }
}



@end
