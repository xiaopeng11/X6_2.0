//
//  BusinessPeakAnalysisViewController.m
//  project-x6
//
//  Created by Apple on 2016/11/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BusinessPeakAnalysisViewController.h"
#import "CompanyViewController.h"
#import "XPItemsControlView.h"
#import "KucunTitle.h"
#import "ChangePositionLabelView.h"


#import "XPDatePicker.h"
#import "X6WebView.h"
@interface BusinessPeakAnalysisViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    ChangePositionLabelView *_naviTitleLabel;

    XPItemsControlView *_BusinessPeakAnalysisitemsControlView;   //眉头试图
    UIScrollView *_BusinessPeakAnalysisscrollView;               //首页滑动式图
    int _BusinessPeakAnalysisindex;
    
    XPDatePicker *_FirstDatePicker;      //对比范围1起始时间

    
    X6WebView *_BusinessPeakAnalysisWebView;
    
    NSString *_companySSGS;   //所属公司
    
    UIButton *_BusinessPeakAnalysisfullButton;
    BOOL isFullScreen;
}
@property(nonatomic,copy)NSMutableArray *BusinessPeakAnalysistitledatalist;                   //库存数据
@property(nonatomic,copy)NSMutableArray *BusinessPeakAnalysistitles;
@end

@implementation BusinessPeakAnalysisViewController


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
    
    [self naviTitleWhiteColorWithText:@"业务高峰期分析"];

    
    _naviTitleLabel = [[ChangePositionLabelView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _naviTitleLabel.LabelString = @"公司";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BusinessPeakAnalysisCompany)];
    [_naviTitleLabel addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_naviTitleLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    isFullScreen = NO;
    _BusinessPeakAnalysisindex = 0;
    _companySSGS = [NSString string];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BusinessPeakAnalysisDataChange) name:@"changeTodayData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BusinessPeakAnalysisChooseCompanyChange:) name:@"ChooseCompanyssgs" object:nil];

    dispatch_group_t maingroup = dispatch_group_create();
    dispatch_group_enter(maingroup);
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucuntitleURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunTitle];
    [XPHTTPRequestTool requestMothedWithPost:mykucuntitleURL params:nil success:^(id responseObject) {
        _BusinessPeakAnalysistitledatalist = [KucunTitle mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        NSDictionary *dic = @{@"bm":@"",@"name":@"全部"};
        [_BusinessPeakAnalysistitledatalist insertObject:dic atIndex:0];
        _BusinessPeakAnalysistitles = [NSMutableArray array];
        for (NSDictionary *dic in _BusinessPeakAnalysistitledatalist) {
            [_BusinessPeakAnalysistitles addObject:[dic valueForKey:@"name"]];
        }
        dispatch_group_leave(maingroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(maingroup);
    }];
    
    dispatch_group_notify(maingroup, dispatch_get_main_queue(), ^{
        //绘制UI
        [self drawBusinessPeakAnalysisBodyUI];
        
        [self loadBusinessPeakAnalysisWebView];
        
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

#pragma mark - 绘制UI
- (void)drawBusinessPeakAnalysisBodyUI
{
    //scrollview
    _BusinessPeakAnalysisscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 129 + 10 + 40, KScreenWidth, KScreenHeight - 64 - 129 - 20 - 40)];
    _BusinessPeakAnalysisscrollView.delegate = self;
    _BusinessPeakAnalysisscrollView.pagingEnabled = YES;
    _BusinessPeakAnalysisscrollView.showsHorizontalScrollIndicator = NO;
    _BusinessPeakAnalysisscrollView.showsVerticalScrollIndicator = NO;
    _BusinessPeakAnalysisscrollView.contentSize = CGSizeMake(KScreenWidth * _BusinessPeakAnalysistitles.count, KScreenHeight - 64 - 129 - 20 - 40);
    _BusinessPeakAnalysisscrollView.backgroundColor = [UIColor clearColor];
    _BusinessPeakAnalysisscrollView.bounces = NO;
    [self.view addSubview:_BusinessPeakAnalysisscrollView];
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    if (KScreenWidth / _BusinessPeakAnalysistitles.count > 57) {
        config.itemWidth = KScreenWidth / _BusinessPeakAnalysistitles.count;
    } else {
        config.itemWidth = 57;
    }
    _BusinessPeakAnalysisitemsControlView = [[XPItemsControlView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    _BusinessPeakAnalysisitemsControlView.tapAnimation = NO;
    _BusinessPeakAnalysisitemsControlView.backgroundColor = [UIColor whiteColor];
    _BusinessPeakAnalysisitemsControlView.config = config;
    _BusinessPeakAnalysisitemsControlView.titleArray = _BusinessPeakAnalysistitles;
    
    __weak typeof (_BusinessPeakAnalysisscrollView)weakScrollView = _BusinessPeakAnalysisscrollView;
    [_BusinessPeakAnalysisitemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_BusinessPeakAnalysisitemsControlView];
    
    UIView *itemlineView = [BasicControls drawLineWithFrame:CGRectMake(0, 40, KScreenWidth, .5)];
    [self.view addSubview:itemlineView];
    
    //获取当前的年月
    NSString *dateString = [BasicControls TurnTodayDate];
    
    UILabel *dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 210) / 2.0, 40 + 18, 80, 22)];
    dateLabel1.text = @"日       期:";
    dateLabel1.font = MainFont;
    [self.view addSubview:dateLabel1];
    
    _FirstDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(dateLabel1.right + 10, 40 + 15, 120, 28) Date:dateString];
    _FirstDatePicker.delegate = self;
    _FirstDatePicker.font = ExtitleFont;
    _FirstDatePicker.textColor = [UIColor blackColor];
    _FirstDatePicker.labelString = @"起始日期:";
    [self.view addSubview:_FirstDatePicker];
    
    _BusinessPeakAnalysisWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 98, KScreenWidth, KScreenHeight - 64 - 98)];;
    _BusinessPeakAnalysisWebView.webViewString = X6_BusinessPeakAnalysis;
    [self.view addSubview:_BusinessPeakAnalysisWebView];
    
    
    _BusinessPeakAnalysisfullButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _BusinessPeakAnalysisfullButton.frame = CGRectMake(_BusinessPeakAnalysisWebView.bounds.size.width - 60, 0, 40, 40);
    [_BusinessPeakAnalysisfullButton setImage:[UIImage imageNamed:@"qp_1"] forState:UIControlStateNormal];
    [_BusinessPeakAnalysisfullButton addTarget:self action:@selector(BusinessPeakAnalysisfullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [_BusinessPeakAnalysisWebView.scrollView addSubview:_BusinessPeakAnalysisfullButton];
    
}

//全屏
- (void)BusinessPeakAnalysisfullScreenAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        isFullScreen = YES;
        [_BusinessPeakAnalysisfullButton setImage:[UIImage imageNamed:@"tc_1"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        [self rightHengpinAction];
    } else {
        isFullScreen = NO;
        [_BusinessPeakAnalysisfullButton setImage:[UIImage imageNamed:@"qp_1"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        [self firstupAction];
    }
}

#pragma mark - 横竖屏坐标事件
- (void)firstupAction
{
    [UIView animateWithDuration:0.25 animations:^{
        _BusinessPeakAnalysisWebView.transform = CGAffineTransformMakeRotation(0);
        _BusinessPeakAnalysisWebView.frame = CGRectMake(0, 98, KScreenWidth, KScreenHeight - 64 - 98);
        _BusinessPeakAnalysisfullButton.frame = CGRectMake(_BusinessPeakAnalysisWebView.bounds.size.width - 60, 0, 40, 40);
    }];
}


-(void)rightHengpinAction
{
    [UIView animateWithDuration:0.25 animations:^{
        _BusinessPeakAnalysisWebView.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        _BusinessPeakAnalysisWebView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44);
        _BusinessPeakAnalysisfullButton.frame = CGRectMake(_BusinessPeakAnalysisWebView.bounds.size.width - 60, 0, 40, 40);
    }];
}


#pragma mark - 导航栏按钮
- (void)BusinessPeakAnalysisCompany
{
    [_naviTitleLabel.timer setFireDate:[NSDate distantFuture]];

    CompanyViewController *CompanysVC  = [[CompanyViewController alloc] init];
    [self.navigationController pushViewController:CompanysVC animated:YES];
}

#pragma mark - 通知事件
- (void)BusinessPeakAnalysisDataChange
{
    [self loadBusinessPeakAnalysisWebView];
}

- (void)BusinessPeakAnalysisChooseCompanyChange:(NSNotification *)noti
{
    _naviTitleLabel.LabelString = [noti.object valueForKey:@"name"];
    _companySSGS = [noti.object valueForKey:@"bm"];
    [self loadBusinessPeakAnalysisWebView];
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
    }
    return NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_BusinessPeakAnalysisscrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_BusinessPeakAnalysisitemsControlView moveToIndex:offset];
        if (offset != _BusinessPeakAnalysisindex) {
            [self loadBusinessPeakAnalysisWebView];
            _BusinessPeakAnalysisindex = offset;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_BusinessPeakAnalysisscrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_BusinessPeakAnalysisitemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - web加载
- (void)loadBusinessPeakAnalysisWebView
{
    NSString *BusinessPeakAnalysisBody = [NSString stringWithFormat:@"fsrqq=%@&fsrqz=%@&ssgs=%@&splx=%@",_FirstDatePicker.text,_FirstDatePicker.text,_companySSGS,[_BusinessPeakAnalysistitledatalist[_BusinessPeakAnalysisindex] valueForKey:@"bm"]];
    [_BusinessPeakAnalysisWebView loadRequestWithBody:BusinessPeakAnalysisBody];
}


@end
