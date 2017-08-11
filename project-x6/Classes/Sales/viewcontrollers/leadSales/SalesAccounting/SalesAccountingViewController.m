//
//  SalesAccountingViewController.m
//  project-x6
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SalesAccountingViewController.h"
#import "XPDatePicker.h"
#import "X6WebView.h"
@interface SalesAccountingViewController ()<UITextFieldDelegate>

{
    XPDatePicker *_FirstDatePicker;      //第一个textfield
    XPDatePicker *_SecondDatePicker;     //第二个textfield
    
    UIButton *_slbutton;
    UIButton *_lrbutton;
    
    X6WebView *_SalesAccountingWebView;
    
    int _index;
    NSString *_SalesAccountingBody;
}
@end

@implementation SalesAccountingViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"销售占比(按类型)"];
    
    self.view.backgroundColor = [UIColor whiteColor];

    _index = 0;
    _SalesAccountingBody = [NSString string];
    //绘制UI
    [self drawSalesAccountingUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SalesAccountingDataChange) name:@"changeTodayData" object:nil];
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
- (void)drawSalesAccountingUI
{
    //获取当前的年月
    NSString *dateString = [BasicControls TurnTodayDate];
    //当前月份的第一天
    NSMutableString *monthFirstString = [NSMutableString stringWithString:dateString];
    [monthFirstString replaceCharactersInRange:NSMakeRange(dateString.length - 2, 2) withString:@"01"];
    NSString *firstDayString = [monthFirstString mutableCopy];
    
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 18, 40, 22)];
    dateLabel.text = @"日期:";
    dateLabel.font = MainFont;
    [self.view addSubview:dateLabel];
    
    _FirstDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(73, 15, (KScreenWidth - 73 - 30 - 10) / 2.0, 28) Date:firstDayString];
    _FirstDatePicker.delegate = self;
    _FirstDatePicker.font = ExtitleFont;
    _FirstDatePicker.backgroundColor = [UIColor whiteColor];
    _FirstDatePicker.textColor = [UIColor blackColor];
    _FirstDatePicker.labelString = @"  起始日期:";
    [self.view addSubview:_FirstDatePicker];
    
    UILabel *leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(_FirstDatePicker.right + 5, 18, 20, 22)];
    leadLabel.text = @"至";
    leadLabel.font = MainFont;
    leadLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:leadLabel];
    
    _SecondDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(_FirstDatePicker.right + 30, 15, (KScreenWidth - 73 - 30 - 10) / 2.0, 28) Date:dateString];
    _SecondDatePicker.delegate = self;
    _SecondDatePicker.font = ExtitleFont;
    _SecondDatePicker.backgroundColor = [UIColor whiteColor];
    _SecondDatePicker.textColor = [UIColor blackColor];
    _SecondDatePicker.labelString = @"  结束日期:";
    [self.view addSubview:_SecondDatePicker];
    
    _slbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _slbutton.frame = CGRectMake((KScreenWidth / 2.0) - 11 - 60, 63, 60, 28);
    [_slbutton setTitle:@"按数量" forState:UIControlStateNormal];
    [_slbutton.layer setMasksToBounds:YES];
    [_slbutton.layer setBorderColor:Mycolor.CGColor];
    [_slbutton.layer setBorderWidth:1];
    [_slbutton.layer setCornerRadius:4];
    [_slbutton setBackgroundColor:Mycolor];
    _slbutton.titleLabel.font = ExtitleFont;
    [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_slbutton addTarget:self action:@selector(SalesAccountingslAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_slbutton];
    
    _lrbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lrbutton.frame = CGRectMake((KScreenWidth / 2.0) + 11, 63, 60, 28);
    [_lrbutton setTitle:@"按利润" forState:UIControlStateNormal];
    [_lrbutton.layer setMasksToBounds:YES];
    [_lrbutton.layer setBorderColor:Mycolor.CGColor];
    [_lrbutton.layer setBorderWidth:1];
    [_lrbutton.layer setCornerRadius:4];
    [_lrbutton setBackgroundColor:[UIColor whiteColor]];
    _lrbutton.titleLabel.font = ExtitleFont;
    [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
    [_lrbutton addTarget:self action:@selector(SalesAccountinglrAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lrbutton];
    
    _SalesAccountingWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 91 + 10, KScreenWidth, KScreenHeight - 64 - 91 - 20)];;
    _SalesAccountingWebView.webViewString = X6_SalesAccounting;
    [self.view addSubview:_SalesAccountingWebView];
    
    [self loadSalesAccountingWebViewWithFtype:@"sl"];
}

#pragma mark - 按钮
- (void)SalesAccountingslAction
{
    if (_index == 1) {
        [_slbutton setBackgroundColor:Mycolor];
        [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lrbutton setBackgroundColor:[UIColor whiteColor]];
        [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        
        [self loadSalesAccountingWebViewWithFtype:@"sl"];
        _index--;
    }
}

- (void)SalesAccountinglrAction
{
    if (_index == 0) {
        [_lrbutton setBackgroundColor:Mycolor];
        [_lrbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_slbutton setBackgroundColor:[UIColor whiteColor]];
        [_slbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        
        [self loadSalesAccountingWebViewWithFtype:@"lr"];
        _index++;
    }
}

#pragma mark - 通知事件
- (void)SalesAccountingDataChange
{
    if (_index == 1) {
        [_slbutton setBackgroundColor:Mycolor];
        [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lrbutton setBackgroundColor:[UIColor whiteColor]];
        [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        _index--;
    }
    [self loadSalesAccountingWebViewWithFtype:@"sl"];
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

#pragma mark - web加载
- (void)loadSalesAccountingWebViewWithFtype:(NSString *)ftype
{
    _SalesAccountingBody = [NSString stringWithFormat:@"fsrqq=%@&fsrqz=%@&ftype=%@",_FirstDatePicker.text,_SecondDatePicker.text,ftype];
    [_SalesAccountingWebView loadRequestWithBody:_SalesAccountingBody];
}

@end
