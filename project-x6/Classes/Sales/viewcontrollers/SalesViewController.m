//
//  SalesViewController.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//



#import "SalesViewController.h"

#import "TodayinventoryViewController.h"
#import "MySalesViewController.h"
#import "AllSalesViewController.h"
#import "BusinessSCViewController.h"
#import "BusinessSCDetailViewController.h"
#import "SalesTableViewCell.h"
#import "BusinessSCModel.h"

#import "MyKucunViewController.h"
#import "TodayViewController.h"
#import "TodaySalesViewController.h"
#import "TodayMoneyViewController.h"
#import "TodayPayViewController.h"
#import "EarlyWarningViewController.h"
#import "MyacountViewController.h"
#import "DepositViewController.h"
#import "WholesaleViewController.h"
#import "MissyReceivableViewController.h"
#import "InletandPinViewController.h"
#import "SalesTrendViewController.h"
#import "SalesComparisonViewController.h"
#import "InventoryComparisonViewController.h"
#import "SalesAccountingViewController.h"
#import "AssetsAccountingViewController.h"
#import "PerCapitaProfitViewController.h"
#import "PerCapitaProfitRankingViewController.h"
#import "NetProfitRankingViewController.h"
#import "TurnoverDaysAnalysisViewController.h"
#import "BusinessPeakAnalysisViewController.h"
#import "TodayPurchaseViewController.h"

#import "JPUSHService.h"

#define salesWidth ((KScreenWidth - 1) / 3)
@interface SalesViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *_noleadTableView;
    NSMutableArray *_datalist;
    NSMutableArray *_BusinessSCDatalist;
    UILabel *_numLabel;
    
    
    
    NSString *_edtionString;
    
    NSMutableArray *_firstdatalist;
    NSMutableArray *_seconddatalist;
    NSMutableArray *_thirddatalist;
    
    UIScrollView *_salesScrollView;
}

@end

@implementation SalesViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"报表"];
    
    if (_isleader) {
        [self drawleaderSalesViews];
    } else {
        [self drawnoleaderSalesViews];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_isleader) {
        [self getBusinessSectionConfirmationData];
    }
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


- (void)qxlisthadchanged
{
    [self getbanbenhao];
}

#pragma mark - 不同的身份
//操作员身份
- (void)drawleaderSalesViews
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    _edtionString = [userdefalut valueForKey:Kehuedition];
    dispatch_group_t group = dispatch_group_create();
    if (_edtionString.length == 0) {
        [BasicControls editiongroup:group];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        _edtionString = [userdefalut valueForKey:Kehuedition];
        //初始化子视图
        [self initWithSubViews];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qxlisthadchanged) name:@"changeQXList" object:nil];
}

//营业员身份
- (void)drawnoleaderSalesViews
{
    _datalist = [NSMutableArray arrayWithArray:@[@{@"text":@"今日库存",@"image":@"w_1"},
                                                 @{@"text":@"我的销量",@"image":@"w_2"},
                                                 @{@"text":@"我的排名",@"image":@"w_3"},
                                                 @{@"text":@"营业款确认",@"image":@"w_4"}]];
    
    _noleadTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight - 20) style:UITableViewStylePlain];
    _noleadTableView.dataSource = self;
    _noleadTableView.delegate = self;
    _noleadTableView.showsHorizontalScrollIndicator = NO;
    _noleadTableView.backgroundColor = GrayColor;
    _noleadTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _noleadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_noleadTableView];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 50, (70 * 3) + 20, 30, 30)];
    _numLabel.hidden = YES;
    _numLabel.clipsToBounds = YES;
    _numLabel.layer.cornerRadius = 15;
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.backgroundColor = [UIColor redColor];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = ExtitleFont;
    [_noleadTableView addSubview:_numLabel];

}

- (void)initWithSubViews
{
    
    //绘制前的数据处理
    [self getbanbenhao];
    
    int secondlines = [self makeSalesSureLines:(int)_seconddatalist.count];
    int thirdlines = [self makeSalesSureLines:(int)_thirddatalist.count];
    
    //滑动试图
    _salesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49)];
    _salesScrollView.showsVerticalScrollIndicator = NO;
    _salesScrollView.contentSize = CGSizeMake(KScreenWidth, 10 + 80 + 10 + 45 + (secondlines - 1) * 95 + 94.5 + 10 + 45 + (thirdlines - 1) * 95 + 94.5);
    [self.view addSubview:_salesScrollView];
    {
        //绘制顶部背景
        UIView *topSalesView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 80)];
        topSalesView.backgroundColor = [UIColor whiteColor];
        topSalesView.userInteractionEnabled = YES;
        [_salesScrollView addSubview:topSalesView];
        
        //顶部试图绘制
        for (int i = 0; i < _firstdatalist.count; i++) {
            UIButton *topbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            topbutton.frame = CGRectMake((salesWidth + 1) * i, 0, salesWidth, 80);
            [topbutton setBackgroundImage:[BasicControls imageWithColor:[UIColor whiteColor] size:topbutton.size] forState:UIControlStateNormal];
            [topbutton setBackgroundImage:[BasicControls imageWithColor:GrayColor size:topbutton.size] forState:UIControlStateHighlighted];
            topbutton.tag = 40000 + i;
            [topbutton addTarget:self action:@selector(topbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [topSalesView addSubview:topbutton];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((salesWidth - 30) / 2, 11, 30, 30)];
            imageView.userInteractionEnabled = NO;
            imageView.image = [UIImage imageNamed:[_firstdatalist[i] valueForKey:@"imageName"]];
            [topbutton addSubview:imageView];
            
            UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake((salesWidth - 70) / 2, 49, 70, 20)];
            toplabel.font = ExtitleFont;
            toplabel.text = [_firstdatalist[i] valueForKey:@"title"];
            toplabel.textAlignment = NSTextAlignmentCenter;
            [topbutton addSubview:toplabel];
        }
    }
    
    {
        //绘制动态试图1
        UIView *secondSalesView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, KScreenWidth, 45 + (secondlines - 1) * 95 + 94.5)];
        secondSalesView.backgroundColor = [UIColor whiteColor];
        [_salesScrollView addSubview:secondSalesView];
        
        UILabel *secondSalesTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 20, 21)];
        secondSalesTopLabel.font = MainFont;
        secondSalesTopLabel.text = @"常规类报表";
        [secondSalesView addSubview:secondSalesTopLabel];
        
        [self drawSalesViewWithLines:secondlines BgView:secondSalesView];
        
        [self drawSalesButtonViewWithDatalist:_seconddatalist BgView:secondSalesView];
    }
    
    {
        //绘制动态试图2
        UIView *thirdSalesView = [[UIView alloc] initWithFrame:CGRectMake(0, 100 + 45 + (secondlines - 1) * 95 + 94.5 + 10, KScreenWidth, 45 + (thirdlines - 1) * 95 + 94.5)];
        thirdSalesView.backgroundColor = [UIColor whiteColor];
        [_salesScrollView addSubview:thirdSalesView];
        
        UILabel *thirdSalesTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 20, 21)];
        thirdSalesTopLabel.font = MainFont;
        thirdSalesTopLabel.text = @"分析类报表";
        [thirdSalesView addSubview:thirdSalesTopLabel];
        
        
        [self drawSalesViewWithLines:thirdlines BgView:thirdSalesView];
        
        [self drawAnalysisSalesButtonViewWithDatalist:_thirddatalist BgView:thirdSalesView];
    }
}


#pragma mark - 按钮事件
- (void)topbuttonAction:(UIButton *)button
{
    NSDictionary *dic = _firstdatalist[button.tag - 40000];
    if (![[dic valueForKey:@"pc"] boolValue]) {
        [BasicControls showAlertWithMsg:@"该功能未经授权，请与系统管理员联系授权" addTarget:nil];
        return;
    }
    if (button.tag == 40000) {
        MyKucunViewController *mykucunVC = [[MyKucunViewController alloc] init];
        [self.navigationController pushViewController:mykucunVC animated:YES];
    } else if (button.tag == 40001) {
        EarlyWarningViewController *earlyWarningVC = [[EarlyWarningViewController alloc] init];
        earlyWarningVC.edtionString = _edtionString;
        [self.navigationController pushViewController:earlyWarningVC animated:YES];
    } else if (button.tag == 40002) {
        MyacountViewController *myacountVC = [[MyacountViewController alloc] init];
        myacountVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:myacountVC animated:YES];
    }
}


- (void)secondbuttonAction:(UIButton *)button
{
    NSDictionary *dic = [NSDictionary dictionary];
    if (button.tag - 41000 < 11) {
        for (NSDictionary *diced in _seconddatalist) {
            if ([[diced valueForKey:@"buttonTag"] intValue] == button.tag - 41000) {
                dic = diced;
                break;
            }
        }
    } else {
        for (NSDictionary *diced in _thirddatalist) {
            if ([[diced valueForKey:@"buttonTag"] intValue] == button.tag - 41000) {
                dic = diced;
                break;
            }
        }
    }
    
    if (![[dic valueForKey:@"pc"] boolValue]) {
        [BasicControls showAlertWithMsg:@"该功能未经授权，请与系统管理员联系授权" addTarget:nil];
        return;
    }
    if (button.tag == 41000) {
        TodayViewController *todayVC = [[TodayViewController alloc] init];
        [self.navigationController pushViewController:todayVC animated:YES];
    } else if (button.tag == 41001) {
        TodaySalesViewController *todaySalesVC = [[TodaySalesViewController alloc] init];
        [self.navigationController pushViewController:todaySalesVC animated:YES];
    } else if (button.tag == 41002) {
        TodayMoneyViewController *todayMoneyVC = [[TodayMoneyViewController alloc] init];
        todayMoneyVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:todayMoneyVC animated:YES];
    } else if (button.tag == 41003) {
        WholesaleViewController *wholesalesVC = [[WholesaleViewController alloc] init];
        wholesalesVC.Viewtitle = X6_WholesaleUnits;
        [self.navigationController pushViewController:wholesalesVC animated:YES];
    } else if (button.tag == 41004) {
        WholesaleViewController *wholesalesVC = [[WholesaleViewController alloc] init];
        wholesalesVC.Viewtitle = X6_WholesaleSales;
        [self.navigationController pushViewController:wholesalesVC animated:YES];
    } else if (button.tag == 41005) {
        WholesaleViewController *wholesalesVC = [[WholesaleViewController alloc] init];
        wholesalesVC.Viewtitle = X6_WholesaleSummary;
        [self.navigationController pushViewController:wholesalesVC animated:YES];
    } else if (button.tag == 41006) {
        MissyReceivableViewController *missyReceivableVC = [[MissyReceivableViewController alloc] init];
        missyReceivableVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:missyReceivableVC animated:YES];
    } else if (button.tag == 41007) {
        TodayPayViewController *todayPayVC = [[TodayPayViewController alloc] init];
        todayPayVC.titletext = X6_todayPay;
        todayPayVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:todayPayVC animated:YES];
    } else if (button.tag == 41008) {
        TodayPayViewController *todayPayVC = [[TodayPayViewController alloc] init];
        todayPayVC.titletext = X6_todayReceivable;
        todayPayVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:todayPayVC animated:YES];
    }  else if (button.tag == 41009) {
        DepositViewController *depositVC = [[DepositViewController alloc] init];
        depositVC.isBusiness = NO;
        depositVC.isshow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:depositVC animated:YES];
    } else if (button.tag == 41010) {
        TodayPurchaseViewController *TodayPurchaseVC = [[TodayPurchaseViewController alloc] init];
        [self.navigationController pushViewController:TodayPurchaseVC animated:YES];
    }  else if (button.tag == 41011) {
        InletandPinViewController *InletandPinVC = [[InletandPinViewController alloc] init];
        [self.navigationController pushViewController:InletandPinVC animated:YES];
    } else if (button.tag == 41012) {
        SalesTrendViewController *SalesTrendVC = [[SalesTrendViewController alloc] init];
        [self.navigationController pushViewController:SalesTrendVC animated:YES];
    } else if (button.tag == 41013) {
        SalesComparisonViewController *SalesComparisonVC = [[SalesComparisonViewController alloc] init];
        [self.navigationController pushViewController:SalesComparisonVC animated:YES];
    } else if (button.tag == 41014) {
        SalesAccountingViewController *SalesAccountingVC = [[SalesAccountingViewController alloc] init];
        [self.navigationController pushViewController:SalesAccountingVC animated:YES];
    } else if (button.tag == 41015) {
        InventoryComparisonViewController *InventoryComparisonVC = [[InventoryComparisonViewController alloc] init];
        [self.navigationController pushViewController:InventoryComparisonVC animated:YES];
    } else if (button.tag == 41016) {
        AssetsAccountingViewController *AsstsAccountingVC = [[AssetsAccountingViewController alloc] init];
        AsstsAccountingVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:AsstsAccountingVC animated:YES];
    } else if (button.tag == 41017) {
        PerCapitaProfitViewController *PerCapitaProfitVC = [[PerCapitaProfitViewController alloc] init];
        [self.navigationController pushViewController:PerCapitaProfitVC animated:YES];
    } else if (button.tag == 41018) {
        PerCapitaProfitRankingViewController *PerCapitaProfitRankingVC = [[PerCapitaProfitRankingViewController alloc] init];
        [self.navigationController pushViewController:PerCapitaProfitRankingVC animated:YES];
    } else if (button.tag == 41019) {
        NetProfitRankingViewController *NetProfitRankingVC = [[NetProfitRankingViewController alloc] init];
        [self.navigationController pushViewController:NetProfitRankingVC animated:YES];
    } else if (button.tag == 41020) {
        TurnoverDaysAnalysisViewController *TurnoverDaysAnalysisVC = [[TurnoverDaysAnalysisViewController alloc] init];
        [self.navigationController pushViewController:TurnoverDaysAnalysisVC animated:YES];
    } else if (button.tag == 41021) {
        BusinessPeakAnalysisViewController *BusinessPeakAnalysisVC = [[BusinessPeakAnalysisViewController alloc] init];
        [self.navigationController pushViewController:BusinessPeakAnalysisVC animated:YES];
    }
}


#pragma mark - 数据获取
//营业员数据
- (void)getBusinessSectionConfirmationData
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *getBusinessSCDataURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_BusinessSectionConfirmationDate];
    [XPHTTPRequestTool requestMothedWithPost:getBusinessSCDataURL params:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _BusinessSCDatalist = [BusinessSCModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_BusinessSCDatalist.count > 0) {
            _numLabel.hidden = NO;
            if (_BusinessSCDatalist.count>99) {
                _numLabel.text = @"99天";
            } else {
                _numLabel.text = [NSString stringWithFormat:@"%lu天",(unsigned long)_BusinessSCDatalist.count];
            }
        } else {
            _numLabel.hidden = YES;
        }
    } failure:^(NSError *error) {
        NSLog(@"获取待确认日期失败");
    }];
}


//版本号
- (void)getbanbenhao
{
    //数据一
    NSArray *firstSalesDatalist = @[@{@"title":@"我的库存",@"imageName":@"b1_1",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"提醒",@"imageName":@"b1_2",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"我的帐户",@"imageName":@"b1_3",@"pc":@NO,@"Edition":@YES}];
    _firstdatalist = [NSMutableArray arrayWithArray:firstSalesDatalist];
    
    //数据二
    NSArray *secondSalesDatalist =@[@{@"title":@"bb_jrzb",@"Name":@"今日战报",@"image":@"b1_4",@"buttonTag":@"0",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_jrxs",@"Name":@"今日销量",@"image":@"b1_5",@"buttonTag":@"1",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_jryyk",@"Name":@"营业款",@"image":@"b1_6",@"buttonTag":@"2",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_pfzb",@"Name":@"批发战报",@"image":@"b1_11",@"buttonTag":@"3",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_pfxl",@"Name":@"批发销量",@"image":@"b1_12",@"buttonTag":@"4",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_pfhz",@"Name":@"批发汇总",@"image":@"b1_13",@"buttonTag":@"5",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_pfysmx",@"Name":@"应收明细",@"image":@"b1_7",@"buttonTag":@"6",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_jrcwfk",@"Name":@"今日付款",@"image":@"b1_8",@"buttonTag":@"7",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_jrsk",@"Name":@"今日收款",@"image":@"b1_10",@"buttonTag":@"8",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_jryhdk",@"Name":@"今日存款",@"image":@"b1_9",@"buttonTag":@"9",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_jrcg",@"Name":@"今日采购",@"image":@"b1_26",@"buttonTag":@"10",@"pc":@NO,@"Edition":@YES}
                                    ];
    
    _seconddatalist = [NSMutableArray arrayWithArray:secondSalesDatalist];
    
    //数据三
    NSArray *thirdSalesDatalist = @[@{@"title":@"bb_jxdb",@"Name":@"进销对比",@"ExtraName":@"分析过量进货",@"image":@"b1_14",@"buttonTag":@"11",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_xszs",@"Name":@"销售走势",@"ExtraName":@"最近销售走势",@"image":@"b1_15",@"buttonTag":@"12",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_xsdb",@"Name":@"销售对比(按时间)",@"ExtraName":@"可自定义时段",@"image":@"b1_16",@"buttonTag":@"13",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_xszb",@"Name":@"销售占比(按类型)",@"ExtraName":@"类型比重",@"image":@"b1_18",@"buttonTag":@"14",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_kczb",@"Name":@"库存占比",@"ExtraName":@"类型比重",@"image":@"b1_17",@"buttonTag":@"15",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_zjzb",@"Name":@"资产概要",@"ExtraName":@"资产比重",@"image":@"b1_19",@"buttonTag":@"16",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_rjml",@"Name":@"人均毛利",@"ExtraName":@"人均毛利走势",@"image":@"b1_20",@"buttonTag":@"17",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_rjmlpm",@"Name":@"人均毛利排名",@"ExtraName":@"按门店排名",@"image":@"b1_21",@"buttonTag":@"18",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_jlrpm",@"Name":@"净利润排名",@"ExtraName":@"按门店对比排名",@"image":@"b1_22",@"buttonTag":@"19",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_zztsfx",@"Name":@"周转天数分析",@"ExtraName":@"按时间走势",@"image":@"b1_23",@"buttonTag":@"20",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"bb_ywgfqfx",@"Name":@"业务高峰期分析",@"ExtraName":@"分析高峰时间段",@"image":@"b1_25",@"buttonTag":@"21",@"pc":@NO,@"Edition":@YES}];
    _thirddatalist = [NSMutableArray arrayWithArray:thirdSalesDatalist];
    
    //判断零售还是批发－－动态删减子模块
    if ([_edtionString isEqualToString:@"X6经典版"] || [_edtionString isEqualToString:@"X6辉煌版"] || [_edtionString isEqualToString:@"X6旗舰版"])
    {
        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
        for (int i = 3 ; i < 7; i++) {
            [indexSets addIndex:i];
        }
        [_seconddatalist removeObjectsAtIndexes:indexSets];
        [_seconddatalist removeObjectAtIndex:4];
        //版本－－Edition是否可用
        if ([_edtionString isEqualToString:@"X6经典版"])
        {
            //我的账户
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:_firstdatalist[2]];
            [dic1 setValue:@NO forKey:@"Edition"];
            [_firstdatalist replaceObjectAtIndex:2 withObject:dic1];
            //营业款,今日付款,今日存款
            for (int i = 2; i < 5; i++) {
                NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:_seconddatalist[i]];
                [dic2 setValue:@NO forKey:@"Edition"];
                [_seconddatalist replaceObjectAtIndex:i withObject:dic2];
            }
            //资产概论
            NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithDictionary:_thirddatalist[5]];
            [dic3 setValue:@NO forKey:@"Edition"];
            [_thirddatalist replaceObjectAtIndex:5 withObject:dic3];
            
        }

    } else if ([_edtionString isEqualToString:@"X6通信市场标准版"] || [_edtionString isEqualToString:@"X6通信市场财务版"]) {
        NSMutableIndexSet *indexSetsed = [[NSMutableIndexSet alloc] init];
        for (int i = 0 ; i < 3; i++) {
            [indexSetsed addIndex:i];
        }
        [_seconddatalist removeObjectsAtIndexes:indexSetsed];
        [_seconddatalist removeObjectAtIndex:6];
        
        NSMutableIndexSet *nextindexSet = [[NSMutableIndexSet alloc] init];
        for (int i = 7 ; i < 9; i++) {
            [nextindexSet addIndex:i];
        }
        [_thirddatalist removeObjectsAtIndexes:nextindexSet];
        [_thirddatalist removeLastObject];
        
        //版本－－Edition是否可用
        if ([_edtionString isEqualToString:@"X6通信市场标准版"])
        {
            //今日付款，今日收款，应收款明细
            for (int i = 3; i < 6; i++) {
                NSMutableDictionary *diced1 = [NSMutableDictionary dictionaryWithDictionary:_seconddatalist[i]];
                [diced1 setValue:@NO forKey:@"Edition"];
                [_seconddatalist replaceObjectAtIndex:i withObject:diced1];
            }
            
            //资产概论
            NSMutableDictionary *diced2 = [NSMutableDictionary dictionaryWithDictionary:_thirddatalist[5]];
            [diced2 setValue:@NO forKey:@"Edition"];
            [_thirddatalist replaceObjectAtIndex:5 withObject:diced2];
        }
    }
    
    //获取权限列表判断授权1
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    //授权1
    for (int i = 0; i < _firstdatalist.count; i++) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:_firstdatalist[i]];
        if (i == 0) {
            for (NSDictionary *diced in qxList) {
                if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_mykc"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@YES forKey:@"pc"];
                        break;
                    }
                }
            }
        } else if (i == 2) {
            for (NSDictionary *diced in qxList) {
                if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_myzh"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@YES forKey:@"pc"];
                        break;
                    }
                }
            }
        } else {
            NSMutableArray *pcs = [NSMutableArray array];
            for (NSDictionary *diced in qxList) {
                if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
                    [pcs addObject:[diced valueForKey:@"pc"]];
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_klyj"]) {
                    [pcs addObject:[diced valueForKey:@"pc"]];
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]) {
                    [pcs addObject:[diced valueForKey:@"pc"]];
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]) {
                    [pcs addObject:[diced valueForKey:@"pc"]];
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_yskyj"]) {
                    [pcs addObject:[diced valueForKey:@"pc"]];
                }
            }
            
            if ([pcs containsObject:@YES]) {
                [mutableDic setObject:@"b1_2a" forKey:@"imageName"];
                [mutableDic setObject:@"提醒" forKey:@"title"];
                [mutableDic setObject:@YES forKey:@"pc"];
            }
        }
        [_firstdatalist replaceObjectAtIndex:i withObject:mutableDic];
    }
    //授权2
    for (int i = 0; i < _seconddatalist.count; i++) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:_seconddatalist[i]];
        for (NSDictionary *diced in qxList) {
            if ([[diced valueForKey:@"qxid"] isEqualToString:[mutableDic valueForKey:@"title"]]) {
                if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                    [mutableDic setObject:@YES forKey:@"pc"];
                    break;
                }
            }
        }
        [_seconddatalist replaceObjectAtIndex:i withObject:mutableDic];
    }
    //授权3
    for (int i = 0; i < _thirddatalist.count; i++) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:_thirddatalist[i]];
        for (NSDictionary *diced in qxList) {
            if ([[diced valueForKey:@"qxid"] isEqualToString:[mutableDic valueForKey:@"title"]]) {
                if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                    [mutableDic setObject:@YES forKey:@"pc"];
                    break;
                }
            }
        }
        [_thirddatalist replaceObjectAtIndex:i withObject:mutableDic];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"SalesID";
    SalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[SalesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = _datalist[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        TodayinventoryViewController *todayVC = [[TodayinventoryViewController alloc] init];
        [self.navigationController pushViewController:todayVC animated:YES];
    } else if (indexPath.row == 1) {
        MySalesViewController *mySalesVC = [[MySalesViewController alloc] init];
        [self.navigationController pushViewController:mySalesVC animated:YES];
    } else if (indexPath.row == 2)  {
        AllSalesViewController *allSalesVC = [[AllSalesViewController alloc] init];
        [self.navigationController pushViewController:allSalesVC animated:YES];
    } else {
        if (_BusinessSCDatalist.count == 0) {
            BusinessSCDetailViewController *BusinessSCDetailVC =  [[BusinessSCDetailViewController alloc] init];
            [self.navigationController pushViewController:BusinessSCDetailVC animated:YES];
        } else {
            BusinessSCViewController *BusinessSCVC = [[BusinessSCViewController alloc] init];
            BusinessSCVC.datalist = _BusinessSCDatalist;
            [self.navigationController pushViewController:BusinessSCVC animated:YES];
        }
    }
    
}

/**
 *  通过按钮数量判断几行
 *
 *  @param num 按钮个数
 */
- (int)makeSalesSureLines:(int)num
{
    if (num % 3 == 0) {
        return (num / 3);
    } else {
        return ((num / 3) + 1);
    }
}

#pragma mark - 绘制UI额外动作
//绘制常规报表
- (void)drawSalesButtonViewWithDatalist:(NSMutableArray *)datalist BgView:(UIView *)bgView
{
    for (int i = 0 ; i < datalist.count; i++) {
        int low = i / 3;
        int wid = i % 3;
        UIButton *mainbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        mainbutton.frame = CGRectMake((salesWidth + 1) * wid, 45 + 95 * low, salesWidth, 94.5);
        mainbutton.tag = 41000 + [[datalist[i] valueForKey:@"buttonTag"] intValue];
        [mainbutton addTarget:self action:@selector(secondbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [mainbutton setBackgroundImage:[BasicControls imageWithColor:[UIColor whiteColor] size:mainbutton.size] forState:UIControlStateNormal];
        [mainbutton setBackgroundImage:[BasicControls imageWithColor:GrayColor size:mainbutton.size] forState:UIControlStateHighlighted];
        [bgView addSubview:mainbutton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((salesWidth - 30) / 2, 20, 30, 30)];
        imageView.userInteractionEnabled = NO;
        imageView.image = [UIImage imageNamed:[datalist[i] valueForKey:@"image"]];
        [mainbutton addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, salesWidth, 20)];
        label.font = ExtitleFont;
        label.text = [datalist[i] valueForKey:@"Name"];
        label.textAlignment = NSTextAlignmentCenter;
        [mainbutton addSubview:label];
    }
}

//绘制分析类报表
- (void)drawAnalysisSalesButtonViewWithDatalist:(NSMutableArray *)datalist BgView:(UIView *)bgView
{
    for (int i = 0 ; i < datalist.count; i++) {
        int low = i / 3;
        int wid = i % 3;
        UIButton *mainbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        mainbutton.frame = CGRectMake((salesWidth + 1) * wid, 45 + 95 * low, salesWidth, 94.5);
        mainbutton.tag = 41000 + [[datalist[i] valueForKey:@"buttonTag"] intValue];
        [mainbutton addTarget:self action:@selector(secondbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [mainbutton setBackgroundImage:[BasicControls imageWithColor:[UIColor whiteColor] size:mainbutton.size] forState:UIControlStateNormal];
        [mainbutton setBackgroundImage:[BasicControls imageWithColor:GrayColor size:mainbutton.size] forState:UIControlStateHighlighted];
        [bgView addSubview:mainbutton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((salesWidth - 30) / 2, 10, 30, 30)];
        imageView.userInteractionEnabled = NO;
        imageView.image = [UIImage imageNamed:[datalist[i] valueForKey:@"image"]];
        [mainbutton addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, salesWidth, 20)];
        label.font = ExtitleFont;
        label.text = [datalist[i] valueForKey:@"Name"];
        label.textAlignment = NSTextAlignmentCenter;
        [mainbutton addSubview:label];
        
        UILabel *Extralabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, salesWidth, 16)];
        Extralabel.font = [UIFont systemFontOfSize:11];
        Extralabel.textColor = ExtraTitleColor;
        Extralabel.text = [datalist[i] valueForKey:@"ExtraName"];
        Extralabel.textAlignment = NSTextAlignmentCenter;
        [mainbutton addSubview:Extralabel];
    }
}

//绘制切割线
- (void)drawSalesViewWithLines:(long)lines BgView:(UIView *)bgView
{
    //纵线
    for (int i = 0; i < 2; i++) {
        UIView *secondSaleslowView = [BasicControls drawLineWithFrame:CGRectMake(salesWidth + (salesWidth + 1) * i, 45, .5, 95 * (lines - 1) + 94.5)];
        [bgView addSubview:secondSaleslowView];
    }
    //横线
    for (int i = 0; i < lines; i++) {
        UIView *secondSaleswidView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 95 * i, KScreenWidth, .5)];
        [bgView addSubview:secondSaleswidView];
    }
    
}

@end
