//
//  SalesTrendViewController.m
//  project-x6
//
//  Created by Apple on 16/9/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SalesTrendViewController.h"
#import "CompanyViewController.h"
#import "XPItemsControlView.h"
#import "KucunTitle.h"
#import "ChangePositionLabelView.h"

#import "XPDatePicker.h"
#import "X6WebView.h"
@interface SalesTrendViewController ()<UIScrollViewDelegate>
{
    ChangePositionLabelView *_naviTitleLabel;
    
    XPItemsControlView *_SalesTrenditemsControlView;   //眉头试图
    UIScrollView *_SalesTrendscrollView;               //首页滑动式图
    int _SalesTrendindex;
    
    UIView *_topLineView;                //顶部底线
    
    UIButton *_slbutton;
    UIButton *_lrbutton;
    
    UIButton *_fullButton;
    BOOL isFullScreen;
    X6WebView *_SalesTrendWebView;
    
    int _index;
    long _timeInteral;
    NSString *_SalesTrendBody;
    
    NSString *_companySSGS;   //所属公司
}

@property(nonatomic,copy)NSMutableArray *SalesTrendtitledatalist;                   //库存数据
@property(nonatomic,copy)NSMutableArray *SalesTrendtitles;
@end

@implementation SalesTrendViewController

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
    [self naviTitleWhiteColorWithText:@"销售走势"];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    
    _naviTitleLabel = [[ChangePositionLabelView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _naviTitleLabel.LabelString = @"公司";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SalesTrendCompany)];
    [_naviTitleLabel addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_naviTitleLabel];
    
    isFullScreen = NO;
    _index = 0;
    _timeInteral = 0;
    _SalesTrendBody = [NSString string];
    _companySSGS = [NSString string];
    _SalesTrendindex = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SalesTrendChooseCompanyChange:) name:@"ChooseCompanyssgs" object:nil];
    
    dispatch_group_t maingroup = dispatch_group_create();
    dispatch_group_enter(maingroup);
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucuntitleURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunTitle];
    [XPHTTPRequestTool requestMothedWithPost:mykucuntitleURL params:nil success:^(id responseObject) {
        _SalesTrendtitledatalist = [KucunTitle mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        NSDictionary *dic = @{@"bm":@"",@"name":@"全部"};
        [_SalesTrendtitledatalist insertObject:dic atIndex:0];
        _SalesTrendtitles = [NSMutableArray array];
        for (NSDictionary *dic in _SalesTrendtitledatalist) {
            [_SalesTrendtitles addObject:[dic valueForKey:@"name"]];
        }
        dispatch_group_leave(maingroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(maingroup);
    }];
    
    dispatch_group_notify(maingroup, dispatch_get_main_queue(), ^{
        //绘制UI
        [self drawSalesTrendBodyUI];
        
        [self loadSalesTrendWebViewWithFtype:@"sl"];
        
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
- (void)drawSalesTrendBodyUI
{
    //scrollview
    _SalesTrendscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 146, KScreenWidth, KScreenHeight - 64 - 146 - 40)];
    _SalesTrendscrollView.delegate = self;
    _SalesTrendscrollView.pagingEnabled = YES;
    _SalesTrendscrollView.showsHorizontalScrollIndicator = NO;
    _SalesTrendscrollView.showsVerticalScrollIndicator = NO;
    _SalesTrendscrollView.contentSize = CGSizeMake(KScreenWidth * _SalesTrendtitles.count, KScreenHeight - 64 - 129 - 100);
    _SalesTrendscrollView.bounces = NO;
    _SalesTrendscrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_SalesTrendscrollView];
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    if (KScreenWidth / _SalesTrendtitles.count > 57) {
        config.itemWidth = KScreenWidth / _SalesTrendtitles.count;
    } else {
        config.itemWidth = 57;
    }
    _SalesTrenditemsControlView = [[XPItemsControlView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    _SalesTrenditemsControlView.tapAnimation = NO;
    _SalesTrenditemsControlView.backgroundColor = [UIColor whiteColor];
    _SalesTrenditemsControlView.config = config;
    _SalesTrenditemsControlView.titleArray = _SalesTrendtitles;
    
    __weak typeof (_SalesTrendscrollView)weakScrollView = _SalesTrendscrollView;
    [_SalesTrenditemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_SalesTrenditemsControlView];
    
    UIView *toplineView = [BasicControls drawLineWithFrame:CGRectMake(0, 40, KScreenWidth, .5)];
    [self.view addSubview:toplineView];
    
 
    
    _slbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _slbutton.frame = CGRectMake((KScreenWidth / 2.0) - 11 - 60, 55, 60, 28);
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
    _lrbutton.frame = CGRectMake((KScreenWidth / 2.0) + 11, 55, 60, 28);
    [_lrbutton setTitle:@"按利润" forState:UIControlStateNormal];
    _lrbutton.titleLabel.font = ExtitleFont;
    [_lrbutton.layer setMasksToBounds:YES];
    [_lrbutton.layer setBorderColor:Mycolor.CGColor];
    [_lrbutton.layer setBorderWidth:1];
    [_lrbutton.layer setCornerRadius:4];
    [_lrbutton setBackgroundColor:[UIColor whiteColor]];
    [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
    [_lrbutton addTarget:self action:@selector(SalesAccountinglrAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lrbutton];
    
    UIView *bottomLineView = [BasicControls drawLineWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, .5)];
    [self.view addSubview:bottomLineView];
    
    //5个时间段按钮
    NSArray *SalesTrendtopButtonNames = @[@"按日",@"按周",@"按月",@"按季",@"按年"];
    for (int i  = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(((KScreenWidth - 300) / 10.0) + ((((KScreenWidth - 300) / 5.0) + 60) * i), KScreenHeight - 104, 60, 38);
        if (i == _index) {
            [button setTitleColor:Mycolor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        button.titleLabel.font = MainFont;
        [button setTitle:SalesTrendtopButtonNames[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = 41210 + i;
        [button addTarget:self action:@selector(SalesTrendTopButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    _topLineView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 300) / 10.0, KScreenHeight - 66, 60, 2)];
    _topLineView.backgroundColor = Mycolor;
    [self.view addSubview:_topLineView];
    
    
    
    _SalesTrendWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 98, KScreenWidth, KScreenHeight - 64 - 98 - 40)];;
    _SalesTrendWebView.webViewString = X6_SalesTrend;
    [_SalesTrendWebView setTop:98];
    [self.view addSubview:_SalesTrendWebView];
    
    _fullButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fullButton.frame = CGRectMake(_SalesTrendWebView.bounds.size.width - 60, 0, 40, 40);
    [_fullButton setImage:[UIImage imageNamed:@"qp_1"] forState:UIControlStateNormal];
    [_fullButton addTarget:self action:@selector(SalesTrendfullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [_SalesTrendWebView.scrollView addSubview:_fullButton];

}

//全屏
- (void)SalesTrendfullScreenAction:(UIButton *)btn
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
        _SalesTrendWebView.transform = CGAffineTransformMakeRotation(0);
        _SalesTrendWebView.frame = CGRectMake(0, 98 + 60, KScreenWidth, KScreenHeight - 64 - 98 - 40);
        _fullButton.frame = CGRectMake(_SalesTrendWebView.bounds.size.width - 60, 0, 40, 40);
    }];
}


-(void)rightHengpinAction
{
    [UIView animateWithDuration:0.25 animations:^{
        _SalesTrendWebView.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        _SalesTrendWebView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44);
        _fullButton.frame = CGRectMake(_SalesTrendWebView.bounds.size.width - 60, 0, 40, 40);
    }];
}


#pragma mark - 按钮
//查询按钮
- (void)getSalesTrendData
{
    if (_index == 0) {
        [self loadSalesTrendWebViewWithFtype:@"sl"];
    } else {
        [self loadSalesTrendWebViewWithFtype:@"lr"];
    }
}

- (void)SalesTrendTopButton:(UIButton *)button
{
    long bottomindex = _timeInteral;
    _timeInteral = button.tag - 41210;
    //回归数量
    if (_index == 1) {
        [_slbutton setBackgroundColor:Mycolor];
        [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lrbutton setBackgroundColor:[UIColor whiteColor]];
        [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        _index--;
    }
    
    //改变按钮颜色
    if (_timeInteral != bottomindex) {
        UIButton *lastbutton = (UIButton *)[self.view viewWithTag:bottomindex + 41210];
        [lastbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:Mycolor forState:UIControlStateNormal];
        [self changeLine:_timeInteral];
    }
    [self loadSalesTrendWebViewWithFtype:@"sl"];

}

//数量
- (void)SalesAccountingslAction
{
    if (_index == 1) {
        [_slbutton setBackgroundColor:Mycolor];
        [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lrbutton setBackgroundColor:[UIColor whiteColor]];
        [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        
        [self loadSalesTrendWebViewWithFtype:@"sl"];
        _index--;
    }
}

//利润
- (void)SalesAccountinglrAction
{
    if (_index == 0) {
        [_lrbutton setBackgroundColor:Mycolor];
        [_lrbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_slbutton setBackgroundColor:[UIColor whiteColor]];
        [_slbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        
        [self loadSalesTrendWebViewWithFtype:@"lr"];
        _index++;
    }
}

//导航栏按钮
- (void)SalesTrendCompany
{
    [_naviTitleLabel.timer setFireDate:[NSDate distantFuture]];

    CompanyViewController *CompanysVC  = [[CompanyViewController alloc] init];
    [self.navigationController pushViewController:CompanysVC animated:YES];
}

#pragma mark - 通知事件
//公司改变
- (void)SalesTrendChooseCompanyChange:(NSNotification *)noti
{
    if (_index == 1) {
        [_slbutton setBackgroundColor:Mycolor];
        [_slbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lrbutton setBackgroundColor:[UIColor whiteColor]];
        [_lrbutton setTitleColor:Mycolor forState:UIControlStateNormal];
        _index--;
    }
    _companySSGS = [noti.object valueForKey:@"bm"];
    _naviTitleLabel.LabelString = [noti.object valueForKey:@"name"];
    [self loadSalesTrendWebViewWithFtype:@"sl"];
}


#pragma mark - web加载
- (void)loadSalesTrendWebViewWithFtype:(NSString *)ftype
{
    NSString *dtype = [NSString string];
    if (_timeInteral == 0) {
        dtype = @"D";
    } else if (_timeInteral == 1) {
        dtype = @"W";
    } else if (_timeInteral == 2) {
        dtype = @"M";
    } else if (_timeInteral == 3) {
        dtype = @"S";
    } else if (_timeInteral == 4) {
        dtype = @"Y";
    }
    _SalesTrendBody = [NSString stringWithFormat:@"ftype=%@&dtype=%@&splx=%@&ssgs=%@",ftype,dtype,[_SalesTrendtitledatalist[_SalesTrendindex] valueForKey:@"bm"],_companySSGS];
    [_SalesTrendWebView loadRequestWithBody:_SalesTrendBody];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_SalesTrendscrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_SalesTrenditemsControlView moveToIndex:offset];
        if (offset != _SalesTrendindex) {
            _SalesTrendindex = offset;
            if (_index == 1) {
                [self loadSalesTrendWebViewWithFtype:@"sl"];
            } else {
                [self loadSalesTrendWebViewWithFtype:@"lr"];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_SalesTrendscrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_SalesTrenditemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - 改变线条位置
-(void)changeLine:(float)index
{
    CGRect rect = _topLineView.frame;
    rect.origin.x = ((KScreenWidth - 300) / 10.0) + ((((KScreenWidth - 300) / 5.0) + 60) * index);
    _topLineView.frame = rect;
}


@end
