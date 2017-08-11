//
//  SalesComparisonViewController.m
//  project-x6
//
//  Created by Apple on 16/9/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SalesComparisonViewController.h"
#import "CompanyViewController.h"
#import "XPItemsControlView.h"
#import "KucunTitle.h"
#import "ChangePositionLabelView.h"

#import "XPDatePicker.h"
#import "X6WebView.h"
@interface SalesComparisonViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    
    ChangePositionLabelView *_naviTitleLabel;
    
    XPItemsControlView *_SalesComparisonitemsControlView;   //眉头试图
    UIScrollView *_SalesComparisonscrollView;               //首页滑动式图
    int _SalesComparisonindex;
    
    XPDatePicker *_FirstDatePicker;      //对比范围1起始时间
    XPDatePicker *_SecondDatePicker;     //对比范围1结束时间
    XPDatePicker *_ThirdDatePicker;      //对比范围2起始时间
    XPDatePicker *_FourDatePicker;       //对比范围2结束时间
    
    UIButton *_slbutton;
    UIButton *_lrbutton;
    
    X6WebView *_SalesComparisonWebView;
    
    int _index;
    
    NSString *_companySSGS;   //所属公司
}

@property(nonatomic,copy)NSMutableArray *SalesComparisontitledatalist;                   //库存数据
@property(nonatomic,copy)NSMutableArray *SalesComparisontitles;
@end

@implementation SalesComparisonViewController

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
    [self naviTitleWhiteColorWithText:@"销售对比(按时间)"];
    
    _naviTitleLabel = [[ChangePositionLabelView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _naviTitleLabel.LabelString = @"公司";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SalesComparisonCompany)];
    [_naviTitleLabel addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_naviTitleLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _index = 0;
    _SalesComparisonindex = 0;
    _companySSGS = [NSString string];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SalesComparisonDataChange) name:@"changeTodayData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SalesComparisonChooseCompanyChange:) name:@"ChooseCompanyssgs" object:nil];

    
    dispatch_group_t maingroup = dispatch_group_create();
    dispatch_group_enter(maingroup);
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucuntitleURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunTitle];
    [XPHTTPRequestTool requestMothedWithPost:mykucuntitleURL params:nil success:^(id responseObject) {
        _SalesComparisontitledatalist = [KucunTitle mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        NSDictionary *dic = @{@"bm":@"",@"name":@"全部"};
        [_SalesComparisontitledatalist insertObject:dic atIndex:0];
        _SalesComparisontitles = [NSMutableArray array];
        for (NSDictionary *dic in _SalesComparisontitledatalist) {
            [_SalesComparisontitles addObject:[dic valueForKey:@"name"]];
        }
        dispatch_group_leave(maingroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(maingroup);
    }];
    
    dispatch_group_notify(maingroup, dispatch_get_main_queue(), ^{
        //绘制UI
        [self drawSalesComparisonBodyUI];
        
        [self loadSalesComparisonWebViewWithFtype:@"sl"];

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
- (void)drawSalesComparisonBodyUI
{
    
    _SalesComparisonWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 129 + 10 + 40, KScreenWidth, KScreenHeight - 64 - 129 - 20 - 40)];;
    _SalesComparisonWebView.webViewString = X6_SalesComparison;
    [self.view addSubview:_SalesComparisonWebView];

    //scrollview
    _SalesComparisonscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 129 + 10 + 40, KScreenWidth, KScreenHeight - 64 - 129 - 20 - 40)];
    _SalesComparisonscrollView.delegate = self;
    _SalesComparisonscrollView.pagingEnabled = YES;
    _SalesComparisonscrollView.showsHorizontalScrollIndicator = NO;
    _SalesComparisonscrollView.showsVerticalScrollIndicator = NO;
    _SalesComparisonscrollView.contentSize = CGSizeMake(KScreenWidth * _SalesComparisontitles.count, KScreenHeight - 64 - 129 - 20 - 40);
    _SalesComparisonscrollView.backgroundColor = [UIColor clearColor];
    _SalesComparisonscrollView.bounces = NO;
    [self.view addSubview:_SalesComparisonscrollView];
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    if (KScreenWidth / _SalesComparisontitles.count > 57) {
        config.itemWidth = KScreenWidth / _SalesComparisontitles.count;
    } else {
        config.itemWidth = 57;
    }
    _SalesComparisonitemsControlView = [[XPItemsControlView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    _SalesComparisonitemsControlView.tapAnimation = NO;
    _SalesComparisonitemsControlView.backgroundColor = [UIColor whiteColor];
    _SalesComparisonitemsControlView.config = config;
    _SalesComparisonitemsControlView.titleArray = _SalesComparisontitles;
    
    __weak typeof (_SalesComparisonscrollView)weakScrollView = _SalesComparisonscrollView;
    [_SalesComparisonitemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_SalesComparisonitemsControlView];

    UIView *itemlineView = [BasicControls drawLineWithFrame:CGRectMake(0, 40, KScreenWidth, .5)];
    [self.view addSubview:itemlineView];
    
    //获取当前的年月
    NSString *dateString = [BasicControls TurnTodayDate];
    //当前月份的第一天
    NSMutableString *monthFirstString = [NSMutableString stringWithString:dateString];
    [monthFirstString replaceCharactersInRange:NSMakeRange(dateString.length - 2, 2) withString:@"01"];
    NSString *firstDayString = [monthFirstString mutableCopy];
    
    UILabel *dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(23, 40 + 18, 80, 22)];
    dateLabel1.text = @"对比范围1:";
    dateLabel1.font = MainFont;
    [self.view addSubview:dateLabel1];
    
    UILabel *dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(23, 40 + 61, 80, 22)];
    dateLabel2.text = @"对比范围2:";
    dateLabel2.font = MainFont;
    [self.view addSubview:dateLabel2];
    
    _FirstDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(dateLabel1.right + 10, 40 + 15, (KScreenWidth - 113 - 30 - 10) / 2.0, 28) Date:firstDayString];
    _FirstDatePicker.delegate = self;
    _FirstDatePicker.font = ExtitleFont;
    _FirstDatePicker.backgroundColor = [UIColor whiteColor];
    _FirstDatePicker.textColor = [UIColor blackColor];
    _FirstDatePicker.labelString = @" 对比范围1起始日期:";
    [self.view addSubview:_FirstDatePicker];
    
    _SecondDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(_FirstDatePicker.right + 30, 40 + 15, (KScreenWidth - 113 - 30 - 10) / 2.0, 28) Date:dateString];
    _SecondDatePicker.delegate = self;
    _SecondDatePicker.font = ExtitleFont;
    _SecondDatePicker.backgroundColor = [UIColor whiteColor];
    _SecondDatePicker.textColor = [UIColor blackColor];
    _SecondDatePicker.labelString = @" 对比范围1结束日期:";
    [self.view addSubview:_SecondDatePicker];
    
    _ThirdDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(_FirstDatePicker.left, 40 + 58, (KScreenWidth - 113 - 30 - 10) / 2.0, 28) Date:firstDayString];
    _ThirdDatePicker.delegate = self;
    _ThirdDatePicker.font = ExtitleFont;
    _ThirdDatePicker.backgroundColor = [UIColor whiteColor];
    _ThirdDatePicker.textColor = [UIColor blackColor];
    _ThirdDatePicker.labelString = @" 对比范围2起始日期:";
    [self.view addSubview:_ThirdDatePicker];
    
    _FourDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(_SecondDatePicker.left, 40 + 58, (KScreenWidth - 113 - 30 - 10) / 2.0, 28) Date:dateString];
    _FourDatePicker.delegate = self;
    _FourDatePicker.font = ExtitleFont;
    _FourDatePicker.backgroundColor = [UIColor whiteColor];
    _FourDatePicker.textColor = [UIColor blackColor];
    _FourDatePicker.labelString = @" 对比范围2结束日期:";
    [self.view addSubview:_FourDatePicker];
    
    for (int i = 0; i < 2; i++) {
        UILabel *leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(_FirstDatePicker.right + 5, 40 + 18 + 43 * i, 20, 22)];
        leadLabel.text = @"至";
        leadLabel.font = MainFont;
        leadLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:leadLabel];
    }
    
    _slbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _slbutton.frame = CGRectMake((KScreenWidth / 2.0) - 11 - 60, 40 + 101, 60, 28);
    [_slbutton setTitle:@"按数量" forState:UIControlStateNormal];
    [_slbutton.layer setMasksToBounds:YES];
    [_slbutton.layer setBorderColor:Mycolor.CGColor];
    [_slbutton.layer setBorderWidth:1];
    [_slbutton.layer setCornerRadius:4];
    [_slbutton setBackgroundColor:Mycolor];
    _slbutton.titleLabel.font = ExtitleFont;
    [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_slbutton addTarget:self action:@selector(SalesComparisonslAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_slbutton];
    
    _lrbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lrbutton.frame = CGRectMake((KScreenWidth / 2.0) + 11, 40 + 101, 60, 28);
    [_lrbutton setTitle:@"按利润" forState:UIControlStateNormal];
    [_lrbutton.layer setMasksToBounds:YES];
    [_lrbutton.layer setBorderColor:Mycolor.CGColor];
    [_lrbutton.layer setBorderWidth:1];
    [_lrbutton.layer setCornerRadius:4];
    _lrbutton.titleLabel.font = ExtitleFont;
    [_lrbutton setBackgroundColor:[UIColor whiteColor]];
    [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
    [_lrbutton addTarget:self action:@selector(SalesComparisonlrAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lrbutton];

}

#pragma mark - 按钮
- (void)SalesComparisonslAction
{
    if (_index == 1) {
        [_slbutton setBackgroundColor:Mycolor];
        [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lrbutton setBackgroundColor:[UIColor whiteColor]];
        [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        
        [self loadSalesComparisonWebViewWithFtype:@"sl"];
        _index--;
    }
}

- (void)SalesComparisonlrAction
{
    if (_index == 0) {
        [_lrbutton setBackgroundColor:Mycolor];
        [_lrbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_slbutton setBackgroundColor:[UIColor whiteColor]];
        [_slbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        
        [self loadSalesComparisonWebViewWithFtype:@"lr"];
        _index++;
    }
}

#pragma mark - 导航栏按钮
- (void)SalesComparisonCompany
{
    [_naviTitleLabel.timer setFireDate:[NSDate distantFuture]];

    CompanyViewController *CompanysVC  = [[CompanyViewController alloc] init];
    [self.navigationController pushViewController:CompanysVC animated:YES];
}

#pragma mark - 通知事件
- (void)SalesComparisonDataChange
{
    if (_index == 1) {
        [_slbutton setBackgroundColor:Mycolor];
        [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lrbutton setBackgroundColor:[UIColor whiteColor]];
        [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        _index--;
    }
    [self loadSalesComparisonWebViewWithFtype:@"sl"];
}

- (void)SalesComparisonChooseCompanyChange:(NSNotification *)noti
{
    if (_index == 1) {
        [_slbutton setBackgroundColor:Mycolor];
        [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lrbutton setBackgroundColor:[UIColor whiteColor]];
        [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        _index--;
    }
    _naviTitleLabel.LabelString = [noti.object valueForKey:@"name"];
    _companySSGS = [noti.object valueForKey:@"bm"];
    [self loadSalesComparisonWebViewWithFtype:@"sl"];
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
    } else if (textField == _SecondDatePicker) {
        _SecondDatePicker.mindateString =_FirstDatePicker.text;
        if (_SecondDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _SecondDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_SecondDatePicker.subView];
        }
    } else if (textField == _ThirdDatePicker) {
        _ThirdDatePicker.maxdateString = _FourDatePicker.text;
        if (_ThirdDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _ThirdDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_ThirdDatePicker.subView];
        }
    } else if (textField == _FourDatePicker) {
        _FourDatePicker.mindateString = _ThirdDatePicker.text;
        if (_FourDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _FourDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_FourDatePicker.subView];
        }
    }
    return NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_SalesComparisonscrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_SalesComparisonitemsControlView moveToIndex:offset];
        if (offset != _SalesComparisonindex) {
            if (_index == 1) {
                [self loadSalesComparisonWebViewWithFtype:@"sl"];
            } else {
                [self loadSalesComparisonWebViewWithFtype:@"lr"];
            }
            _SalesComparisonindex = offset;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_SalesComparisonscrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_SalesComparisonitemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - web加载
- (void)loadSalesComparisonWebViewWithFtype:(NSString *)ftype
{
    NSString *SalesComparisonBody = [NSString stringWithFormat:@"fsrqq=%@&fsrqz=%@&fsrqq1=%@&fsrqz1=%@&ftype=%@&splx=%@&ssgs=%@",_FirstDatePicker.text,_SecondDatePicker.text,_ThirdDatePicker.text,_FourDatePicker.text,ftype,[_SalesComparisontitledatalist[_SalesComparisonindex] valueForKey:@"bm"],_companySSGS];
    [_SalesComparisonWebView loadRequestWithBody:SalesComparisonBody];
}

@end
