//
//  ForgetpasswordViewController.m
//  project-x6
//
//  Created by Apple on 16/5/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ForgetpasswordViewController.h"

@interface ForgetpasswordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

{
    UIScrollView *_mainScrollView;             //滑动试图
    
    UITextField *_gdsmTF;                      //公司代码
    UITextField *_userNameTF;                  //用户名
    UITextField *_checkTF;                     //验证码
    
    UITextField *_newpsTF;                     //新密码
    UITextField *_checkpsTF;                   //确认密码
    
    UIButton *_firstnextbutton;                //下一步按钮
    UIButton *_surechangePasswordButton;       //确认修改按钮
    
    UIButton *_acquireButton;                  //短信验证码
    UIButton *_isOrshowButton;                 //是否显示获取验证码按钮
}
@property (nonatomic, readwrite, retain)NSTimer *timer;

@end

@implementation ForgetpasswordViewController

- (void)dealloc
{
   [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _mainScrollView.contentSize = CGSizeMake(KScreenWidth * 3, KScreenHeight);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.backgroundColor = GrayColor;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.scrollEnabled = NO;
    [self.view addSubview:_mainScrollView];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, 64)];
        naviView.backgroundColor = Mycolor;
        naviView.userInteractionEnabled = YES;
        [_mainScrollView addSubview:naviView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2.0, 20, 200, 44)];
        title.text = @"找回密码";
        title.font = TitleFont;
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [naviView addSubview:title];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(15, 25, 34, 34);
        backButton.tag = 22220 + i;
        [backButton setImage:[UIImage imageNamed:@"g3_a"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(forgetpasswordbackVC:) forControlEvents:UIControlEventTouchUpInside];
        [naviView addSubview:backButton];
    }
    
    //绘制滑动试图子试图
    [self drawforgetpasswordfirstUI];
    
    [self drawforgetpasswordsecondUI];
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

#pragma mark - 绘制UI
//绘制滑动试图子试图
- (void)drawforgetpasswordfirstUI
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
        UILabel *gsdmLabel = [BasicControls createLabelWithframe:CGRectMake(10, 0, 70, 44.5) image:nil];
        gsdmLabel.text = @"公司代码";
        gsdmLabel.font = TitleFont;
        [bgView addSubview:gsdmLabel];
        
        _gdsmTF = [BasicControls createTextFieldWithframe:CGRectMake(90, gsdmLabel.top, KScreenWidth - 100, 44.5) addTarget:self image:nil];
        _gdsmTF.placeholder = @"请输入公司代码";
        _gdsmTF.font = TitleFont;
        _gdsmTF.keyboardType = UIKeyboardTypePhonePad;
        [bgView addSubview:_gdsmTF];
    }
    
    //手机号
    {
        UILabel *phoneLabel = [BasicControls createLabelWithframe:CGRectMake(10, 45, 70, 44.5) image:nil];
        phoneLabel.text = @"手机号";
        phoneLabel.font = TitleFont;
        [bgView addSubview:phoneLabel];
        
        _userNameTF = [BasicControls createTextFieldWithframe:CGRectMake(90, phoneLabel.top, KScreenWidth - 100, 44.5) addTarget:self image:nil];
        _userNameTF.placeholder = @"请输入手机号/用户名";
        _userNameTF.font = TitleFont;
        _userNameTF.keyboardType = UIKeyboardTypePhonePad;
        [bgView addSubview:_userNameTF];
    }
    
    //验证码
    {
        UILabel *smsCodeLabel = [BasicControls createLabelWithframe:CGRectMake(10, 90, 70, 44.5) image:nil];
        smsCodeLabel.text = @"验证码";
        smsCodeLabel.font = TitleFont;
        [bgView addSubview:smsCodeLabel];
        
        _checkTF = [BasicControls createTextFieldWithframe:CGRectMake(90, smsCodeLabel.top, KScreenWidth - 90 - 100, 44.5) addTarget:self image:nil];
        _checkTF.placeholder = @"请输入验证码";
        _checkTF.font = TitleFont;
        _checkTF.keyboardType = UIKeyboardTypeNumberPad;
        [bgView addSubview:_checkTF];
        
        _acquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _acquireButton.frame = CGRectMake(KScreenWidth - 90, _checkTF.top + 10, 80, 25);
        [_acquireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_acquireButton setBackgroundColor:Mycolor];
        _acquireButton.titleLabel.font = ExtitleFont;
        _acquireButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _acquireButton.layer.cornerRadius = 4;
        [_acquireButton addTarget:self action:@selector(getchecksms:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_acquireButton];
    }
    
    //下一步按钮
    {
        _firstnextbutton = [BasicControls createButtonWithTitle:@"下一步" frame:CGRectMake(10, 258, KScreenWidth - 20, 45) image:nil];
        [_firstnextbutton setBackgroundColor:Mycolor];
        [_firstnextbutton addTarget:self action:@selector(forgetnextAction:) forControlEvents:UIControlEventTouchUpInside];
        _firstnextbutton.layer.cornerRadius = 4;
        [_mainScrollView addSubview:_firstnextbutton];
    }
}

- (void)drawforgetpasswordsecondUI
{
    //第二页背景
    UIView *nextBgview = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth, 74, KScreenWidth, 45 + 44.5)];
    nextBgview.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:nextBgview];
    
    //绘制第二个页面textField之间相隔线
    [self showLineImageWithFrame:CGRectMake(20, 44, KScreenWidth, .5) SuperView:nextBgview];
    
    //用户名
    {
        UILabel *pwLabel = [BasicControls createLabelWithframe:CGRectMake(10, 0, 70, 44.5) image:nil];
        pwLabel.text = @"新密码";
        pwLabel.font = TitleFont;
        [nextBgview addSubview:pwLabel];
        
        _newpsTF = [BasicControls createTextFieldWithframe:CGRectMake(90, pwLabel.top, KScreenWidth - 100, 44.5) addTarget:self image:nil];
        _newpsTF.placeholder = @"请输入6~18位有效登陆密码";
        _newpsTF.font = TitleFont;
        [nextBgview addSubview:_newpsTF];
    }
    
    //登陆密码
    {
        UILabel *surepwLabel = [BasicControls createLabelWithframe:CGRectMake(10, 45, 70, 44.5) image:nil];
        surepwLabel.text = @"确认密码";
        surepwLabel.font = TitleFont;
        [nextBgview addSubview:surepwLabel];
        
        _checkpsTF = [BasicControls createTextFieldWithframe:CGRectMake(90, surepwLabel.top, KScreenWidth - 100, 44.5) addTarget:self image:nil];
        _checkpsTF.placeholder = @"请输入6~18位有效登陆密码";
        _checkpsTF.font = TitleFont;
        [nextBgview addSubview:_checkpsTF];
    }
    
    //注册按钮
    {
        _surechangePasswordButton = [BasicControls createButtonWithTitle:@"确认修改" frame:CGRectMake(KScreenWidth + 10, 213, KScreenWidth - 20, 40) image:nil];
        _surechangePasswordButton.layer.cornerRadius = 4;
        [_surechangePasswordButton setBackgroundColor:Mycolor];
        [_surechangePasswordButton addTarget:self action:@selector(surechange:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:_surechangePasswordButton];
    }

}

#pragma mark - 按钮事件
//获取验证码
- (void)getchecksms:(UIButton *)button
{
    [self.view endEditing:YES];
    //输入框逻辑处理1
    if (![self manageforgetpsWithphone]) {
        return;
    }
    //数据请求
    [self forgetpasswordAction];
}

//下一步
- (void)forgetnextAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    if (![self manageWithgsdmTFAnduserNameTFAndsmscode]) {
            return;
    }
    //检查验证吗是否正确
    [self cecksmsisok];
}

//确认修改密码
- (void)surechange:(UIButton *)button
{
    [self.view endEditing:YES];
    //输入框逻辑处理1
    if (![self manageWithnewpswTFAndchecknewpswTF]) {
        return;
    }
    //数据请求
    [self changePassword];
}


//返回
- (void)forgetpasswordbackVC:(UIButton *)button
{
    if (button.tag == 22220) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //滑倒左
        [self changetoptitleIndex:0];
    }
}

#pragma mark - 逻辑处理
//输入框逻辑处理1
- (BOOL)manageforgetpsWithphone
{
    if (_gdsmTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入公司代码" addTarget:nil];
        return NO;
    }
    
    if (_userNameTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入用户名／手机号" addTarget:nil];
        return NO;
    }
    return YES;
}

//输入框逻辑处理2
- (BOOL)manageWithgsdmTFAnduserNameTFAndsmscode
{
    if (_gdsmTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入公司代码" addTarget:nil];
        return NO;
    }
    if (_userNameTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入用户名/手机号" addTarget:nil];
        return NO;
    }
    if (_checkTF.text.length != 4) {
        [BasicControls showAlertWithMsg:@"请输入4位验证码" addTarget:nil];
        return NO;
    }
    return YES;
}

//输入框逻辑处理3
- (BOOL)manageWithnewpswTFAndchecknewpswTF
{
    if (_newpsTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入新密码" addTarget:nil];
        return NO;
    }
    if (_checkpsTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入确认密码" addTarget:nil];
        return NO;
    }
    if (![_checkpsTF.text isEqualToString:_newpsTF.text]) {
        [BasicControls showAlertWithMsg:@"密码不一致，请重新输入!" addTarget:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 数据请求
//获取验证码
- (void)forgetpasswordAction
{
    NSString *forget_getsmscode = [NSString stringWithFormat:@"%@%@",X6basemain_API,X6forgetps_getsmscode];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_userNameTF.text forKey:@"uname"];
    [params setObject:_gdsmTF.text forKey:@"gsdm"];
    [params setObject:@"0" forKey:@"utype"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    [manager POST:forget_getsmscode parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject valueForKey:@"type"] isEqualToString:@"success"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码已发" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.tag = 000007;
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

//验证吗是否正确
- (void)cecksmsisok
{
    NSString *forget_checksmscode = [NSString stringWithFormat:@"%@%@",X6basemain_API,X6forgetps_checksmscode];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_checkTF.text forKey:@"yzm"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    [manager POST:forget_checksmscode parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:@"type"] isEqualToString:@"success"]) {
            [self.timer invalidate];
            self.timer = nil;
            [self changetoptitleIndex:1];
        } else {
            [BasicControls showAlertWithMsg:[responseObject valueForKey:@"message"] addTarget:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

//修改密码
- (void)changePassword
{
    NSString *forgetps = [NSString stringWithFormat:@"%@%@",X6basemain_API,X6forgetps];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_gdsmTF.text forKey:@"gsdm"];
    [params setObject:_userNameTF.text forKey:@"uname"];
    [params setObject:_newpsTF.text forKey:@"pwd"];
    if (_isleader) {
        [params setObject:@"0" forKey:@"utype"];
    } else {
        [params setObject:@"1" forKey:@"utype"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    [manager POST:forgetps parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:@"type"] isEqualToString:@"success"]) {
            UIAlertController *cantReigister = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [cantReigister addAction:sureAction];
            [self presentViewController:cantReigister animated:YES completion:nil];
        } else {
            [BasicControls showAlertWithMsg:[responseObject valueForKey:@"message"] addTarget:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
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


//获取验证码倒计时
-(void)updateTimerText:(NSTimer*)theTimer
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
        
        if (isDevice4_4s)
        {
            _acquireButton.titleLabel.text = ncountdown;
        } else {
            [_acquireButton setTitle:ncountdown forState:UIControlStateNormal];
        }
        [_acquireButton setTitle:ncountdown forState:UIControlStateNormal];
    }
}

@end
