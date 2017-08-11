//
//  BusinessViewController.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BusinessViewController.h"
#import "JPUSHService.h"

#import "SupplierViewController.h"
#import "VIPViewController.h"
#import "SettingPriceViewController.h"

#import "CapitalControlViewController.h"
#import "LotBankAccountViewController.h"

#import "DepositViewController.h"
#import "AllocateStorageViewController.h"
#import "TakeInventoryViewController.h"
#import "FirstCheckViewController.h"
#import "OrderreviewViewController.h"

#define imageWidth  ((KScreenWidth - .5) / 2.0)
@interface BusinessViewController ()

{
    NSString *_edtionString;
    NSMutableArray *_firstbusDatalist;
    NSMutableArray *_secondbusDatalist;
    NSMutableArray *_thirdbusDatalist;
    UIScrollView *_businessScrollView;
    NSArray *_titleNamesed;
}

@end

@implementation BusinessViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GrayColor;
    [self naviTitleWhiteColorWithText:@"业务"];
    
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    _edtionString = [userdefalut valueForKey:Kehuedition];
    dispatch_group_t group = dispatch_group_create();
    if (_edtionString.length == 0) {
        [BasicControls editiongroup:group];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        _edtionString = [userdefalut valueForKey:Kehuedition];
        //初始化子视图
        [self intBusinessUI];
    });
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBusinessList) name:@"changeQXList" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//权限改变
- (void)changeBusinessList
{
    [self qxList];
}

//绘制UI
- (void)intBusinessUI
{
    [self qxList];
    
    long firstlines = _firstbusDatalist.count / 2;
    long secondlines = _secondbusDatalist.count / 2;
    long thirdlines = _thirdbusDatalist.count / 2;
    
    if (_thirdbusDatalist.count % 2 == 1) {
        thirdlines++;
    }
    //滑动式图
    _businessScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49)];
    _businessScrollView.showsVerticalScrollIndicator = NO;
    _businessScrollView.contentSize = CGSizeMake(KScreenWidth, 40 + 70 * (firstlines + secondlines + thirdlines - 1) + 208.5);
    [self.view addSubview:_businessScrollView];
    
    //子试图1
    UIView *firstbusinessView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 70 * (firstlines - 1) + 69.5)];
    firstbusinessView.backgroundColor = [UIColor whiteColor];
    [_businessScrollView addSubview:firstbusinessView];
    
    [self drawBusinessButtonViewWithDatalist:_firstbusDatalist BgView:firstbusinessView];
    
    [self drawBuisnessViewWithLines:firstlines BgView:firstbusinessView];
    
    //子试图2
    UIView *secondbusinessView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + 70 * (firstlines - 1) + 69.5 + 10, KScreenWidth, 70 * (secondlines - 1) + 69.5)];
    secondbusinessView.backgroundColor = [UIColor whiteColor];
    [_businessScrollView addSubview:secondbusinessView];
    
    [self drawBusinessButtonViewWithDatalist:_secondbusDatalist BgView:secondbusinessView];
    
    [self drawBuisnessViewWithLines:secondlines BgView:secondbusinessView];
    
    //子试图3
    UIView *thirdbusinessView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + 70 * (firstlines - 1) + 69.5 + 10 + 70 * (secondlines - 1) + 69.5 + 10, KScreenWidth, 70 * (thirdlines - 1) + 69.5)];
    thirdbusinessView.backgroundColor = [UIColor whiteColor];
    [_businessScrollView addSubview:thirdbusinessView];
    
    [self drawBusinessButtonViewWithDatalist:_thirdbusDatalist BgView:thirdbusinessView];
    
    [self drawBuisnessViewWithLines:thirdlines BgView:thirdbusinessView];
    
}


//数据整理
- (void)qxList
{
    //第一个页面
    NSArray *firstarrayimageed = @[@{@"title":@"sz_gys",@"Name":@"供应商",@"ExtraName":@"维护供应商",@"image":@"y_1",@"buttonTag":@"0",@"pc":@NO,@"Edition":@YES},
                                   @{@"title":@"sz_kh",@"Name":@"客户",@"ExtraName":@"维护客户",@"image":@"y_2",@"buttonTag":@"1",@"pc":@NO,@"Edition":@YES},
                                   @{@"title":@"cz_hyxx",@"Name":@"会员信息",@"ExtraName":@"会员办理",@"image":@"y_11",@"buttonTag":@"2",@"pc":@NO,@"Edition":@YES},
                                   @{@"title":@"sz_yjszkhj",@"Name":@"设置考核价",@"ExtraName":@"一键设置",@"image":@"y_7",@"buttonTag":@"3",@"pc":@NO,@"Edition":@YES}
                                   ];
    _firstbusDatalist = [NSMutableArray arrayWithArray:firstarrayimageed];
    
    //第二个页面
    NSArray *secondarrayimageed = @[@{@"title":@"cz_zjsr",@"Name":@"资金收入",@"ExtraName":@"管理资金收入",@"image":@"y_13",@"buttonTag":@"4",@"pc":@NO,@"Edition":@YES},
                                   @{@"title":@"cz_zjzc",@"Name":@"资金支出",@"ExtraName":@"管理资金支出",@"image":@"y_14",@"buttonTag":@"5",@"pc":@NO,@"Edition":@YES},
                                   @{@"title":@"cz_zjtz",@"Name":@"资金调配",@"ExtraName":@"在线调配",@"image":@"y_15",@"buttonTag":@"6",@"pc":@NO,@"Edition":@YES},
                                   @{@"title":@"cz_ywkdk",@"Name":@"银行存款",@"ExtraName":@"营业款上缴",@"image":@"y_5",@"buttonTag":@"7",@"pc":@NO,@"Edition":@YES},
                                   @{@"title":@"cz_pldz",@"Name":@"银行到账",@"ExtraName":@"设置到账金额",@"image":@"y_16",@"buttonTag":@"8",@"pc":@NO,@"Edition":@YES},
                                   ];
    _secondbusDatalist = [NSMutableArray arrayWithArray:secondarrayimageed];
    
    //第三个页面
    NSArray *thirdarrayimageed = @[@{@"title":@"cz_cgddsh",@"Name":@"采购订单审核",@"ExtraName":@"在线审核",@"image":@"y_3",@"buttonTag":@"9",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"cz_pfddsh",@"Name":@"批发订单审核",@"ExtraName":@"在线审核",@"image":@"y_4",@"buttonTag":@"10",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"cz_dbrk",@"Name":@"调拨入库",@"ExtraName":@"实时确认移库单",@"image":@"y_9",@"buttonTag":@"11",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"cz_kcpd",@"Name":@"库存盘点",@"ExtraName":@"日常盘库",@"image":@"y_10",@"buttonTag":@"12",@"pc":@NO,@"Edition":@YES},
                                    @{@"title":@"cz_qcpk",@"Name":@"期初盘库",@"ExtraName":@"初始盘库",@"image":@"y_12",@"buttonTag":@"13",@"pc":@NO,@"Edition":@YES},
                                    ];
    _thirdbusDatalist = [NSMutableArray arrayWithArray:thirdarrayimageed];
    
    //判断零售还是批发－－动态删减子模块
    if ([_edtionString isEqualToString:@"X6辉煌版"] || [_edtionString isEqualToString:@"X6旗舰版"] || [_edtionString isEqualToString:@"X6经典版"]) {
        [_thirdbusDatalist removeObjectAtIndex:1];
        if ([_edtionString isEqualToString:@"X6经典版"]) {
            //版本－－Edition是否可用
            //会员信息
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:_firstbusDatalist[2]];
            [dic1 setValue:@NO forKey:@"Edition"];
            [_firstbusDatalist replaceObjectAtIndex:2 withObject:dic1];
            //采购订单审核
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:_thirdbusDatalist[0]];
            [dic2 setValue:@NO forKey:@"Edition"];
            [_thirdbusDatalist replaceObjectAtIndex:0 withObject:dic2];
            
            //资金收入，支出，调配,银行存款，银行到账
            for (int i = 0; i < _secondbusDatalist.count; i++) {
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:_secondbusDatalist[i]];
                [diced setValue:@NO forKey:@"Edition"];
                [_secondbusDatalist replaceObjectAtIndex:i withObject:diced];
            }
        }
        
    } else if ([_edtionString isEqualToString:@"X6通信市场财务版"] || [_edtionString isEqualToString:@"X6通信市场标准版"]) {
        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
        for (int i = 2 ; i < 4; i++) {
            [indexSets addIndex:i];
        }
        [_firstbusDatalist removeObjectsAtIndexes:indexSets];
        
        [_secondbusDatalist removeObjectAtIndex:_secondbusDatalist.count - 1];
        if ([_edtionString isEqualToString:@"X6通信市场标准版"]) {
            for (int j = 0; j < _secondbusDatalist.count; j++) {
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:_secondbusDatalist[j]];
                [diced setValue:@NO forKey:@"Edition"];
                [_secondbusDatalist replaceObjectAtIndex:j withObject:diced];
            }
        }
    }
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    //获取权限列表判断授权1
    [self JudgmentAuthorizationWithDatalist:_firstbusDatalist ByData:qxList];
    //获取权限列表判断授权2
    [self JudgmentAuthorizationWithDatalist:_secondbusDatalist ByData:qxList];
    //获取权限列表判断授权3
    [self JudgmentAuthorizationWithDatalist:_thirdbusDatalist ByData:qxList];

}

#pragma mark - 按钮事件
- (void)buttonAction:(UIButton *)button
{
    NSDictionary *dic = [NSDictionary dictionary];
    long buttonTag = button.tag - 30000;
    if (buttonTag < 4) {
        for (NSDictionary *diced in _firstbusDatalist) {
            if ([[diced valueForKey:@"buttonTag"] intValue] == buttonTag) {
                dic = diced;
                break;
            }
        }
    } else if (buttonTag >= 4 && buttonTag <= 8 ) {
        for (NSDictionary *diced in _secondbusDatalist) {
            if ([[diced valueForKey:@"buttonTag"] intValue] == buttonTag) {
                dic = diced;
                break;
            }
        }
    } else if (buttonTag > 8) {
        for (NSDictionary *diced in _thirdbusDatalist) {
            if ([[diced valueForKey:@"buttonTag"] intValue] == buttonTag) {
                dic = diced;
                break;
            }
        }
    }
    if (![[dic valueForKey:@"pc"] boolValue]) {
        [BasicControls showAlertWithMsg:@"该功能未经授权，请与系统管理员联系授权" addTarget:nil];
        return;
    }
    if (button.tag == 30000) {
        //供应商
        SupplierViewController *supplierVC = [[SupplierViewController alloc] init];
        supplierVC.issupplier = YES;
        [self.navigationController pushViewController:supplierVC animated:YES];
    } else if (button.tag == 30001) {
        //客户
        SupplierViewController *supplierVC = [[SupplierViewController alloc] init];
        supplierVC.issupplier = NO;
        [self.navigationController pushViewController:supplierVC animated:YES];
    } else if (button.tag == 30002) {
        //会员信息
        VIPViewController *vipVC = [[VIPViewController alloc] init];
        vipVC.isshow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:vipVC animated:YES];
    } else if (button.tag == 30003) {
        //设置考核价
        SettingPriceViewController *settingPriceVC = [[SettingPriceViewController alloc] init];
        [self.navigationController pushViewController:settingPriceVC animated:YES];
    } else if (button.tag == 30004) {
        //资金收入
        CapitalControlViewController *CapitalIncomeVC = [[CapitalControlViewController alloc] init];
        CapitalIncomeVC.lx = 0;
        CapitalIncomeVC.isshow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:CapitalIncomeVC animated:YES];
    } else if (button.tag == 30005) {
        //资金支出
        CapitalControlViewController *CapitalExpenditureVC = [[CapitalControlViewController alloc] init];
        CapitalExpenditureVC.lx = 3;
        CapitalExpenditureVC.isshow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:CapitalExpenditureVC animated:YES];
    } else if (button.tag == 30006) {
        //资金调配
        CapitalControlViewController *CapitalDeploymentVC = [[CapitalControlViewController alloc] init];
        CapitalDeploymentVC.lx = 1;
        CapitalDeploymentVC.isshow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:CapitalDeploymentVC animated:YES];
    } else if (button.tag == 30007) {
        //银行存款
        DepositViewController *depositVC = [[DepositViewController alloc] init];
        depositVC.isshow = [[dic valueForKey:@"Edition"] boolValue];
        depositVC.isBusiness = YES;
        [self.navigationController pushViewController:depositVC animated:YES];
    } else if (button.tag == 30008) {
        //批量银行到账
        LotBankAccountViewController *LotBankAccountVC = [[LotBankAccountViewController alloc] init];
        LotBankAccountVC.isshow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:LotBankAccountVC animated:YES];
    } else if (button.tag == 30009) {
        //采购订单审核
        OrderreviewViewController *orderreviewVC = [[OrderreviewViewController alloc] init];
        orderreviewVC.isshow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:orderreviewVC animated:YES];
    } else if (button.tag == 30010) {
        //批发订单审核
        OrderreviewViewController *orderreviewVC = [[OrderreviewViewController alloc] init];
        orderreviewVC.isWholesale = YES;
        [self.navigationController pushViewController:orderreviewVC animated:YES];
    } else if (button.tag == 30011) {
        //调拨入库
        AllocateStorageViewController *allocateStorageVC = [[AllocateStorageViewController alloc] init];
        [self.navigationController pushViewController:allocateStorageVC animated:YES];
    } else if (button.tag == 30012) {
        //库存盘点
        TakeInventoryViewController *takeInventoryVC = [[TakeInventoryViewController alloc] init];
        [self.navigationController pushViewController:takeInventoryVC animated:YES];
    } else if (button.tag == 30013) {
        //期初盘库
        FirstCheckViewController *firstCheckVC = [[FirstCheckViewController alloc] init];
        [self.navigationController pushViewController:firstCheckVC animated:YES];
    }
}

#pragma mark - 绘制额外动作
//绘制按钮
- (void)drawBusinessButtonViewWithDatalist:(NSMutableArray *)datalist BgView:(UIView *)bgView
{
    for (int i = 0; i < datalist.count; i++) {
        int bus_X = i % 2;
        int bus_Y = i / 2;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((imageWidth + .5) * bus_X, 70 * bus_Y, imageWidth, 70);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 30000 + [[datalist[i] valueForKey:@"buttonTag"] integerValue];
        [bgView addSubview:button];
        
        UIImageView *buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(24, 18, 20, 20)];
        buttonImage.image = [UIImage imageNamed:[datalist[i] valueForKey:@"image"]];
        [button addSubview:buttonImage];
        
        UILabel *mainlabel = [[UILabel alloc] initWithFrame:CGRectMake(44 + 15, 18, imageWidth - 59, 18)];
        mainlabel.font = MainFont;
        mainlabel.text = [datalist[i] valueForKey:@"Name"];
        [button addSubview:mainlabel];
        
        UILabel *extralabel = [[UILabel alloc] initWithFrame:CGRectMake(44 + 15, 42, imageWidth - 59, 16)];
        extralabel.font = ExtitleFont;
        extralabel.textColor = ExtraTitleColor;
        extralabel.text = [datalist[i] valueForKey:@"ExtraName"];
        [button addSubview:extralabel];
    }
}

//绘制切割线
- (void)drawBuisnessViewWithLines:(long)lines BgView:(UIView *)bgView
{
    if (lines != 1) {
        for (int i = 0; i < lines - 1; i++) {
            //横线
            UIView *widView = [BasicControls drawLineWithFrame:CGRectMake(0, 69.5 + 70 * i, KScreenWidth, .5)];
            [bgView addSubview:widView];
        }
    }
    
    for (int j = 0; j < lines; j++) {
        //纵线
        UIView *lowView = [BasicControls drawLineWithFrame:CGRectMake(imageWidth, 10 + 70 * j, .5, 50)];
        [bgView addSubview:lowView];
    }
    
}

#pragma mark - 判断授权
- (void)JudgmentAuthorizationWithDatalist:(NSMutableArray *)datalist ByData:(NSArray *)byData
{
    for (int i = 0; i < datalist.count; i++) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:datalist[i]];
        for (NSDictionary *diced in byData) {
            if ([[diced valueForKey:@"qxid"] isEqualToString:[mutableDic valueForKey:@"title"]]) {
                if ([[diced valueForKey:@"qxid"] isEqualToString:@"cz_cgddsh"]) {
                    NSLog(@"权限为采购入库的字典%@",diced);
                }
                if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                    [mutableDic setObject:@YES forKey:@"pc"];
                    break;
                }
            }
        }
        [datalist replaceObjectAtIndex:i withObject:mutableDic];
    }
}


@end
