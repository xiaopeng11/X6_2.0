//
//  AddFirstCheckViewController.m
//  project-x6
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AddFirstCheckViewController.h"
#import "StoresViewController.h"
#import "ScanStringViewController.h"
#import "GoodsTypeViewController.h"

#import "SerialThingModel.h"

@interface AddFirstCheckViewController ()

{
    UIView *_AddFirstCheckBgview;
    NSMutableArray *_serialDatalist;

    NSDictionary *_supplierid;
    NSDictionary *_warehouseid;
    NSDictionary *_goodtypeid;

    double _AddFirstCheckPage;
    double _AddFirstCheckPages;

}
@end

@implementation AddFirstCheckViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"新增"];
    
    _serialDatalist = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(saveFirstCheck)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFirstChecksureScanSerials:) name:@"ScanDatalist" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFirstChecksureStore:) name:@"storeChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFirstChecksureGoodtype:) name:@"goodTypeChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddSupplierSerials:) name:@"supplierChange" object:nil];
    
    _AddFirstCheckBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 180)];
    _AddFirstCheckBgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_AddFirstCheckBgview];
    
    NSArray *chossebuttonArray = @[@"请选择供应商",@"请选择仓库",@"请选择货品"];
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + 45 * i, 80, 21)];
        label.font = MainFont;
        if (i == 0) {
            label.text = @"供应商";
        } else if (i == 1) {
            label.text = @"仓库";
        } else if (i == 2) {
            label.text = @"货品";
        } else {
            label.text = @"扫串号";
        }
        
        UIButton *choosebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [choosebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        choosebutton.frame = CGRectMake(90, 12 + 45 * i, KScreenWidth - 120, 21);
        choosebutton.clipsToBounds = YES;
        if (i == 3) {
            [choosebutton setTitleColor:PriceColor forState:UIControlStateNormal];
        } else {
            [choosebutton setTitleColor:LineColor forState:UIControlStateNormal];
            [choosebutton setTitle:chossebuttonArray[i] forState:UIControlStateNormal];
        }
        choosebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        choosebutton.titleLabel.font = MainFont;
        choosebutton.tag = 3212110 + i;
        [choosebutton addTarget:self action:@selector(addfirstchoosedetail:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 17.5, 15 + 45 * i, 7.5, 15)];
        leaderView.image = [UIImage imageNamed:@"y1_b"];
        
        [_AddFirstCheckBgview addSubview:label];
        [_AddFirstCheckBgview addSubview:choosebutton];
        [_AddFirstCheckBgview addSubview:leaderView];
        
        if (i < 3) {
            UIView *firstLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [_AddFirstCheckBgview addSubview:firstLineView];
        }
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

#pragma mark - 添加数据
- (void)addfirstchoosedetail:(UIButton *)button
{
    if (button.tag == 3212110) {
        StoresViewController *storeVC = [[StoresViewController alloc] init];
        storeVC.WhichChooseString = X6_supplier;
        [self.navigationController pushViewController:storeVC animated:YES];
    } else if (button.tag == 3212111) {
        StoresViewController *storeVC = [[StoresViewController alloc] init];
        storeVC.WhichChooseString = X6_ChooseWarehous;
        [self.navigationController pushViewController:storeVC animated:YES];
    } else if (button.tag == 3212112) {
        GoodsTypeViewController *GoodsTypeVC = [[GoodsTypeViewController alloc] init];
        [self.navigationController pushViewController:GoodsTypeVC animated:YES];
    } else {
        if (_supplierid == nil) {
            [BasicControls showAlertWithMsg:@"您还没有选择供应商" addTarget:nil];
            return;
        } else if (_warehouseid == nil) {
            [BasicControls showAlertWithMsg:@"您还没选择仓库" addTarget:nil];
            return;
        } else if (_goodtypeid == nil) {
            [BasicControls showAlertWithMsg:@"您还没选择货品" addTarget:nil];
            return;
        }
        ScanStringViewController *scanStringVC = [[ScanStringViewController alloc] init];
        [self presentViewController:scanStringVC animated:YES completion:nil];
    }
}

#pragma mark - 通知
//供应商
- (void)AddSupplierSerials:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    UIButton *SupplierButton = (UIButton *)[_AddFirstCheckBgview viewWithTag:3212110];
    [SupplierButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [SupplierButton setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
    _supplierid = dic;
}

//仓库
- (void)AddFirstChecksureStore:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    UIButton *StoreButton = (UIButton *)[_AddFirstCheckBgview viewWithTag:3212111];
    [StoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [StoreButton setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
    _warehouseid = dic;
}

//货品
- (void)AddFirstChecksureGoodtype:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    UIButton *GoodtypeButton = (UIButton *)[_AddFirstCheckBgview viewWithTag:3212112];
    [GoodtypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [GoodtypeButton setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
    _goodtypeid = dic;
}

//串号
- (void)AddFirstChecksureScanSerials:(NSNotification *)noti
{
    _serialDatalist = noti.object;
    UIButton *goodtypeButton = (UIButton *)[_AddFirstCheckBgview viewWithTag:3212113];
    [goodtypeButton setTitle:[NSString stringWithFormat:@"%lu个",(unsigned long)_serialDatalist.count] forState:UIControlStateNormal];
}

#pragma mark - 保存新增的起初盘库
- (void)saveFirstCheck
{
    NSString *serialString;
    if (_serialDatalist.count == 1) {
        serialString = _serialDatalist[0];
    } else {
        serialString = [_serialDatalist componentsJoinedByString:@","];
    }
    if (_supplierid == nil) {
        [BasicControls showAlertWithMsg:@"您还没有选择供应商" addTarget:nil];
        return;
    } else if (_warehouseid == nil) {
        [BasicControls showAlertWithMsg:@"您还没有选择仓库" addTarget:nil];
        return;
    } else if (_goodtypeid == nil) {
        [BasicControls showAlertWithMsg:@"您还没有选择货品" addTarget:nil];
        return;
    } else if (serialString == nil) {
        [BasicControls showAlertWithMsg:@"您还没有添加串号" addTarget:nil];
        return;
    }
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *TakeInventoryURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_NewFirstCheck];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_supplierid valueForKey:@"id"] forKey:@"gysdm"];
    [params setObject:[_warehouseid valueForKey:@"id"] forKey:@"ckdm"];
    [params setObject:[_goodtypeid valueForKey:@"id"] forKey:@"spdm"];
    [params setObject:serialString forKey:@"chs"];
    [XPHTTPRequestTool requestMothedWithPost:TakeInventoryURL params:params success:^(id responseObject) {
        [BasicControls showNDKNotifyWithMsg:@"保存成功" WithDuration:1 speed:1];
        //清空商品和串号
        [[NSNotificationCenter defaultCenter] postNotificationName:@"successAddFirstCheck" object:nil];
    } failure:^(NSError *error) {
        NSLog(@"获取盘库失败");
    }];
}

#pragma mark - 
- (void)resetGoodTypeAndScanSerials
{
    UIButton *GoodtypeButton = (UIButton *)[_AddFirstCheckBgview viewWithTag:3212112];
    [GoodtypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [GoodtypeButton setTitle:@"请选择货品" forState:UIControlStateNormal];
    _goodtypeid = nil;
    
    UIButton *ScanSerialsButton = (UIButton *)[_AddFirstCheckBgview viewWithTag:3212113];
    [ScanSerialsButton setTitle:@"" forState:UIControlStateNormal];
    [_serialDatalist removeAllObjects];
}

@end
