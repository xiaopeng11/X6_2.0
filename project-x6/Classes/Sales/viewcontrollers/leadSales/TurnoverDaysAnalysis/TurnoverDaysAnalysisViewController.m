//
//  TurnoverDaysAnalysisViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TurnoverDaysAnalysisViewController.h"
#import "CostumMoreDatePicker.h"
#import "X6WebView.h"
@interface TurnoverDaysAnalysisViewController ()<UITextFieldDelegate>

{
    CostumMoreDatePicker *_FirstDatePicker;
    CostumMoreDatePicker *_SecondDatePicker;
    
    UIButton *_fullButton;
    BOOL isFullScreen;
    X6WebView *_TurnoverDaysAnalysisWebView;
    
    NSString *_TurnoverDaysAnalysisBody;
}

@end

@implementation TurnoverDaysAnalysisViewController

- (void)dealloc{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"周转天数分析"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    isFullScreen = NO;
    _TurnoverDaysAnalysisBody = [NSString string];
    //绘制UI
    [self drawTurnoverDaysAnalysisUI];
    
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
- (void)drawTurnoverDaysAnalysisUI
{
    //当前月份的前三个月
    NSDate *firstDate = [NSDate dateWithTimeInterval:-(60 * 60 * 24 * 90) sinceDate:[NSDate date]];
    NSDateFormatter *formatternew = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatternew setLocale:usLocale];
    [formatternew setDateFormat:@"yyyy-MM"];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 40, 22)];
    dateLabel.text = @"日期:";
    dateLabel.font = MainFont;
    [self.view addSubview:dateLabel];
    
    {
        NSString *year = [[formatternew stringFromDate:[NSDate date]] substringToIndex:4];
        NSMutableArray *years = [NSMutableArray array];
        for (NSInteger i = 2000; i <= [year integerValue]; i++) {
            NSString *year = [NSString stringWithFormat:@"%ld",(long)i];
            [years addObject:year];
        }
        
        NSMutableArray *months = [NSMutableArray array];
        for (int i = 1; i < 13; i++) {
            NSString *month;
            if (i < 10) {
                month = [NSString stringWithFormat:@"0%d",i];
            } else {
                month = [NSString stringWithFormat:@"%d",i];
            }
            [months addObject:month];
        }
        NSMutableArray *datas = [NSMutableArray arrayWithObjects:years,months, nil];
        
        _FirstDatePicker = [[CostumMoreDatePicker alloc] initWithFrame:CGRectMake(50, 18, (KScreenWidth - 60 - 20 - 50 - 30) / 2.0, 28) Data:datas IndexStr:[formatternew stringFromDate:firstDate] Key:@"-"];
        _FirstDatePicker.delegate = self;
        _FirstDatePicker.MoretextColor = [UIColor blackColor];
        _FirstDatePicker.MoretextFont = ExtitleFont;
        [self.view addSubview:_FirstDatePicker];
    }
    
    UILabel *leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(_FirstDatePicker.right + 5, 18, 20, 22)];
    leadLabel.text = @"至";
    leadLabel.font = MainFont;
    leadLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:leadLabel];
    
    {
        NSString *year = [[formatternew stringFromDate:firstDate] substringToIndex:4];
        NSMutableArray *years = [NSMutableArray array];
        for (NSInteger i = 2000; i <= [year integerValue]; i++) {
            NSString *year = [NSString stringWithFormat:@"%ld",(long)i];
            [years addObject:year];
        }
        
        NSMutableArray *months = [NSMutableArray array];
        for (int i = 1; i < 13; i++) {
            NSString *month;
            if (i < 10) {
                month = [NSString stringWithFormat:@"0%d",i];
            } else {
                month = [NSString stringWithFormat:@"%d",i];
            }
            [months addObject:month];
        }
        NSMutableArray *datas = [NSMutableArray arrayWithObjects:years,months, nil];
        
        _SecondDatePicker = [[CostumMoreDatePicker alloc] initWithFrame:CGRectMake(_FirstDatePicker.right + 30, 15, (KScreenWidth - 60 - 20 - 50 - 30) / 2.0, 28) Data:datas IndexStr:[formatternew stringFromDate:[NSDate date]] Key:@"-"];
        _SecondDatePicker.delegate = self;
        _SecondDatePicker.MoretextColor = [UIColor blackColor];
        _SecondDatePicker.MoretextFont = ExtitleFont;
        [self.view addSubview:_SecondDatePicker];
    }
    
    UIButton *getdateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getdateButton.frame = CGRectMake(KScreenWidth - 70, 15, 60, 28);
    getdateButton.backgroundColor = Mycolor;
    getdateButton.layer.cornerRadius = 4;
    [getdateButton setTitle:@"查询" forState:UIControlStateNormal];
    getdateButton.titleLabel.font = ExtitleFont;
    [getdateButton addTarget:self action:@selector(loadTurnoverDaysAnalysisWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getdateButton];
    
    
    _TurnoverDaysAnalysisWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 53, KScreenWidth, KScreenHeight - 64 - 53)];;
    _TurnoverDaysAnalysisWebView.webViewString = X6_TurnoverDaysAnalysis;
    [self.view addSubview:_TurnoverDaysAnalysisWebView];
    
    _fullButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fullButton.frame = CGRectMake(_TurnoverDaysAnalysisWebView.bounds.size.width - 60, 0, 40, 40);
    [_fullButton setImage:[UIImage imageNamed:@"qp_1"] forState:UIControlStateNormal];
    [_fullButton addTarget:self action:@selector(TurnoverDaysAnalysisWebViewfullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [_TurnoverDaysAnalysisWebView.scrollView addSubview:_fullButton];
    
    
    [self loadTurnoverDaysAnalysisWebView];
    
}

//全屏
- (void)TurnoverDaysAnalysisWebViewfullScreenAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        isFullScreen = YES;
        [_fullButton setImage:[UIImage imageNamed:@"tc_1"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        [self rightHengpinAction];
    } else {
        isFullScreen = NO;
        [_fullButton setImage:[UIImage imageNamed:@"qp_1"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        [self firstupAction];
    }
}

#pragma mark - 横竖屏坐标事件
- (void)firstupAction
{
    [UIView animateWithDuration:0.25 animations:^{
        _TurnoverDaysAnalysisWebView.transform = CGAffineTransformMakeRotation(0);
        _TurnoverDaysAnalysisWebView.frame = CGRectMake(0, 53, KScreenWidth, KScreenHeight - 64 - 53);
        _fullButton.frame = CGRectMake(_TurnoverDaysAnalysisWebView.bounds.size.width - 60, 0, 40, 40);
    }];
}


-(void)rightHengpinAction
{
    [UIView animateWithDuration:0.25 animations:^{
        _TurnoverDaysAnalysisWebView.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        _TurnoverDaysAnalysisWebView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44);
        _fullButton.frame = CGRectMake(_TurnoverDaysAnalysisWebView.bounds.size.width - 60, 0, 40, 40);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _FirstDatePicker) {
        if (_FirstDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _FirstDatePicker.subView.tag = 1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_FirstDatePicker.subView];
        }
    } else {
        if (_SecondDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _SecondDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_SecondDatePicker.subView];
        }
    }
    return NO;
}

#pragma mark - web加载
- (void)loadTurnoverDaysAnalysisWebView
{
    if ([self TurnoverDaysAnalysisIsInOneYear]) {
        _TurnoverDaysAnalysisBody = [NSString stringWithFormat:@"fsrqq=%@&fsrqz=%@",_FirstDatePicker.text,_SecondDatePicker.text];
        [_TurnoverDaysAnalysisWebView loadRequestWithBody:_TurnoverDaysAnalysisBody];
    } else {
        [BasicControls showAlertWithMsg:@"周转天数分析只支持查询一年" addTarget:nil];
    }

}

#pragma mark - 判断事件是否在一年以内
- (BOOL)TurnoverDaysAnalysisIsInOneYear
{
    NSDateFormatter *formatterMM = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatterMM setLocale:usLocale];
    [formatterMM setDateFormat:@"yyyy-MM"];
    NSDate *firstDate = [formatterMM dateFromString:_FirstDatePicker.text];

    NSDate *secondDate = [formatterMM dateFromString:_SecondDatePicker.text];

    if ([secondDate timeIntervalSinceDate:firstDate] > 60 * 60 * 24 * 367) {
        return NO;
    }
    
    return YES;
}

@end
