//
//  PerCapitaProfitViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PerCapitaProfitViewController.h"
#import "CompanyViewController.h"

#import "ChangePositionLabelView.h"

#import "XPDatePicker.h"
#import "X6WebView.h"

@interface PerCapitaProfitViewController ()<UIScrollViewDelegate>
{
    ChangePositionLabelView *_naviTitleLabel;
    
    UIView *_topLineView;
    
    UIButton *_fullButton;
    BOOL isFullScreen;
    X6WebView *_PerCapitaProfitWebView;
    
    long _timeInteral;
    NSString *_PerCapitaProfitBody;
    
    NSString *_companySSGS;   //所属公司

}
@end

@implementation PerCapitaProfitViewController

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
    [self naviTitleWhiteColorWithText:@"人均毛利"];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    isFullScreen = NO;
    _timeInteral = 0;
    _PerCapitaProfitBody = [NSString string];
    _companySSGS = [NSString string];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PerCapitaProfitChooseCompanyChange:) name:@"ChooseCompanyssgs" object:nil];
    
    _naviTitleLabel = [[ChangePositionLabelView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _naviTitleLabel.LabelString = @"公司";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PerCapitaProfitChooseCompany)];
    [_naviTitleLabel addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_naviTitleLabel];
 
    //绘制UI
    [self drawPerCapitaProfitUI];
        
    [self loadPerCapitaProfitWebView];
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
- (void)drawPerCapitaProfitUI
{
    //4个时间段按钮
    NSArray *PerCapitaProfittopButtonNames = @[@"按周",@"按月",@"按季",@"按年"];
    for (int i  = 0; i < PerCapitaProfittopButtonNames.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(((KScreenWidth - 240) / 8.0) + ((((KScreenWidth - 240) / 4.0) + 60) * i), 0, 60, 38);
        if (i == _timeInteral) {
            [button setTitleColor:Mycolor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button setTitle:PerCapitaProfittopButtonNames[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = 43710 + i;
        button.titleLabel.font = MainFont;
        [button addTarget:self action:@selector(PerCapitaProfitTopButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    _topLineView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 240) / 8.0, 38, 60, 2)];
    _topLineView.backgroundColor = Mycolor;
    [self.view addSubview:_topLineView];
    
    UIView *toplineView = [BasicControls drawLineWithFrame:CGRectMake(0, 40, KScreenWidth, .5)];
    [self.view addSubview:toplineView];
    
    _PerCapitaProfitWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 40.5, KScreenWidth, KScreenHeight - 64 - 40.5)];
    _PerCapitaProfitWebView.webViewString = X6_PerCapitaProfit;
    [self.view addSubview:_PerCapitaProfitWebView];
    
    _fullButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fullButton.frame = CGRectMake(_PerCapitaProfitWebView.bounds.size.width - 60, 0, 40, 40);
    [_fullButton setImage:[UIImage imageNamed:@"qp_1"] forState:UIControlStateNormal];
    [_fullButton addTarget:self action:@selector(PerCapitaProfitfullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [_PerCapitaProfitWebView.scrollView addSubview:_fullButton];

}

#pragma mark - 按钮
- (void)PerCapitaProfitTopButton:(UIButton *)button
{
    //改变按钮颜色
    if (_timeInteral != button.tag - 43710) {
        UIButton *lastbutton = (UIButton *)[self.view viewWithTag:_timeInteral + 43710];
        [lastbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeInteral = button.tag - 43710;
        [button setTitleColor:Mycolor forState:UIControlStateNormal];
        [self changeLine:_timeInteral];
    }
    [self loadPerCapitaProfitWebView];
}

//全屏
- (void)PerCapitaProfitfullScreenAction:(UIButton *)btn
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
        _PerCapitaProfitWebView.transform = CGAffineTransformMakeRotation(0);
        _PerCapitaProfitWebView.frame = CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 40.5);
        _fullButton.frame = CGRectMake(_PerCapitaProfitWebView.bounds.size.width - 60, 0, 40, 40);
    }];
}


-(void)rightHengpinAction
{
    [UIView animateWithDuration:0.25 animations:^{
        _PerCapitaProfitWebView.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        _PerCapitaProfitWebView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44);
        _fullButton.frame = CGRectMake(_PerCapitaProfitWebView.bounds.size.width - 60, 0, 40, 40);
    }];
}

#pragma mark - 通知事件
- (void)PerCapitaProfitChooseCompanyChange:(NSNotification *)noti
{
    _naviTitleLabel.LabelString = [noti.object valueForKey:@"name"];
    _companySSGS = [noti.object valueForKey:@"bm"];
    [self loadPerCapitaProfitWebView];
}

#pragma mark - 公司选择
- (void)PerCapitaProfitChooseCompany
{
    [_naviTitleLabel.timer setFireDate:[NSDate distantFuture]];

    CompanyViewController *CompanysVC  = [[CompanyViewController alloc] init];
    [self.navigationController pushViewController:CompanysVC animated:YES];
}

#pragma mark - web加载
- (void)loadPerCapitaProfitWebView
{
    NSString *dtype = [NSString string];
    if (_timeInteral == 0) {
        dtype = @"W";
    } else if (_timeInteral == 1) {
        dtype = @"M";
    } else if (_timeInteral == 2) {
        dtype = @"S";
    } else if (_timeInteral == 3) {
        dtype = @"Y";
    }
    _PerCapitaProfitBody = [NSString stringWithFormat:@"dtype=%@&ssgs=%@",dtype,_companySSGS];
    [_PerCapitaProfitWebView loadRequestWithBody:_PerCapitaProfitBody];
}


//改变线条位置
-(void)changeLine:(float)index
{
    CGRect rect = _topLineView.frame;
    rect.origin.x = ((KScreenWidth - 240) / 8.0) + ((((KScreenWidth - 240) / 4.0) + 60) * index);
    _topLineView.frame = rect;
}

@end
