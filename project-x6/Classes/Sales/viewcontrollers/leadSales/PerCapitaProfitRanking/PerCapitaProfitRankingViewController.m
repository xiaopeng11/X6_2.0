//
//  PerCapitaProfitRankingViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PerCapitaProfitRankingViewController.h"
#import "CompanyViewController.h"
#import "ChangePositionLabelView.h"

#import "XPDatePicker.h"
#import "X6WebView.h"
@interface PerCapitaProfitRankingViewController ()<UITextFieldDelegate>

{
    ChangePositionLabelView *_naviTitleLabel;

    XPDatePicker *_FirstDatePicker;
    XPDatePicker *_SecondDatePicker;
    
    X6WebView *_PerCapitaProfitRankingWebView;
    
    NSString *_PerCapitaProfitRankingBody;
    NSString *_companySSGS;   //所属公司

}

@end

@implementation PerCapitaProfitRankingViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if ([_naviTitleLabel.timer isValid]) {
        [_naviTitleLabel.timer invalidate];
        _naviTitleLabel.timer = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_naviTitleLabel.timer setFireDate:[NSDate distantPast]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"人均毛利排名"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _PerCapitaProfitRankingBody = [NSString string];
    _companySSGS = [NSString string];

    //绘制UI
    [self drawPerCapitaProfitRankingUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PerCapitaProfitRankingDataChange) name:@"changeTodayData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PerCapitaProfitRankingChooseCompanyChange:) name:@"ChooseCompanyssgs" object:nil];

    _naviTitleLabel = [[ChangePositionLabelView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _naviTitleLabel.LabelString = @"公司";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PerCapitaProfitRankingChooseCompany)];
    [_naviTitleLabel addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_naviTitleLabel];

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
- (void)drawPerCapitaProfitRankingUI
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
    
    
    _PerCapitaProfitRankingWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 53, KScreenWidth, KScreenHeight - 64 - 53)];;
    _PerCapitaProfitRankingWebView.webViewString = X6_PerCapitaProfitRanking;
    [self.view addSubview:_PerCapitaProfitRankingWebView];
    
    [self loadPerCapitaProfitRankingWebView];
}

#pragma mark - 导航栏按钮事件
- (void)PerCapitaProfitRankingChooseCompany
{
    [_naviTitleLabel.timer setFireDate:[NSDate distantFuture]];

    CompanyViewController *CompanysVC  = [[CompanyViewController alloc] init];
    [self.navigationController pushViewController:CompanysVC animated:YES];
}

#pragma mark - 通知事件
- (void)PerCapitaProfitRankingDataChange
{
    [self loadPerCapitaProfitRankingWebView];
}

- (void)PerCapitaProfitRankingChooseCompanyChange:(NSNotification *)noti
{
    _naviTitleLabel.LabelString = [noti.object valueForKey:@"name"];
    _companySSGS = [noti.object valueForKey:@"bm"];
    [self loadPerCapitaProfitRankingWebView];
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
- (void)loadPerCapitaProfitRankingWebView
{
    _PerCapitaProfitRankingBody = [NSString stringWithFormat:@"fsrqq=%@&fsrqz=%@&ssgs=%@",_FirstDatePicker.text,_SecondDatePicker.text,_companySSGS];
    [_PerCapitaProfitRankingWebView loadRequestWithBody:_PerCapitaProfitRankingBody];
}


@end
