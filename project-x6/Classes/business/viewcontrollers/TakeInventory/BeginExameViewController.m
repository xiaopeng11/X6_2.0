//
//  BeginExameViewController.m
//  project-x6
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BeginExameViewController.h"
#import "SerialThingModel.h"

#import "StoresViewController.h"
#import "ScanStringViewController.h"
#import "GoodsTypeViewController.h"

#import "GoodsThingTableViewCell.h"

@interface BeginExameViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UIView *_BeginExameFirstBgview;
    UIView *_BeginExameSecondBgview;
    UITableView *_lessThingBeginExameTableView;
    UITableView *_moreThingBeginExameTableView;
    
    NSMutableArray *_lessThingBeginExameDatalist;    //实物少
    NSMutableArray *_moreThingBeginExameDatalist;    //实物多
    NSArray *_scanSerials;                           //扫描的数据
    
    NSArray *_ThingBeginExameDatalisted;             //数据库数据处理前
    NSMutableArray *_ThingBeginExameDatalist;        //数据库数据
    
    NSDictionary *_Warehouseid;   //仓库id
    NSDictionary *_GoodsID;       //商品id
    
    double _examePage;
    double _examePages;
    
}
@end

@implementation BeginExameViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"开始盘点"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(saveExameData)];
    
    [self drawbeginExameInventoryUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureScanSerials:) name:@"ScanDatalist" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureWarehouseSerials:) name:@"storeChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureGoodtype:) name:@"goodtypeschose" object:nil];

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

#pragma mark - 盘点UI
- (void)drawbeginExameInventoryUI
{
    _BeginExameFirstBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 90)];
    _BeginExameFirstBgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_BeginExameFirstBgview];
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + 45 * i, 80, 21)];
        label.font = MainFont;
        if (i == 0) {
            label.text = @"仓库";
        } else {
            label.text = @"商品类型";
        }
        
        UIButton *choosebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [choosebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        choosebutton.frame = CGRectMake(90, 12 + 45 * i, KScreenWidth - 110, 21);
        choosebutton.clipsToBounds = YES;
        choosebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        choosebutton.titleLabel.font = MainFont;
        choosebutton.tag = 3112110 + i;
        [choosebutton addTarget:self action:@selector(choosedetail:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 17.5, 14.5 + 45 * i, 7.5, 15)];
        leaderView.image = [UIImage imageNamed:@"y1_b"];

        [_BeginExameFirstBgview addSubview:label];
        [_BeginExameFirstBgview addSubview:choosebutton];
        [_BeginExameFirstBgview addSubview:leaderView];
    }
    UIView *firstLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [_BeginExameFirstBgview addSubview:firstLineView];
    
    UIButton *beginExameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beginExameButton.frame = CGRectMake(10, 110, KScreenWidth - 20, 45);
    [beginExameButton setTitle:@"开始扫描" forState:UIControlStateNormal];
    [beginExameButton setBackgroundColor:Mycolor];
    [beginExameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    beginExameButton.clipsToBounds = YES;
    beginExameButton.layer.cornerRadius = 4;
    [beginExameButton addTarget:self action:@selector(beginExames) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginExameButton];
    
    _BeginExameSecondBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 165, KScreenWidth, KScreenHeight - 165 - 64)];
    _BeginExameSecondBgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_BeginExameSecondBgview];
    
    UILabel *SerialnumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 21)];
    SerialnumberLabel.font = MainFont;
    SerialnumberLabel.text = @"串号个数";
    [_BeginExameSecondBgview addSubview:SerialnumberLabel];
    
    UILabel *Serialnumber = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 90, 21)];
    Serialnumber.font = MainFont;
    Serialnumber.textColor = PriceColor;
    Serialnumber.tag = 3123242;
    [_BeginExameSecondBgview addSubview:Serialnumber];
    
    for (int i = 0; i < 3; i++) {
        UIView *secondlineview;
        if (i < 2) {
            secondlineview = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth , .5)];
            UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth / 2.0) * i, 57, KScreenWidth / 2.0, 21)];
            showLabel.font = MainFont;
            showLabel.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                showLabel.text = @"实物少";
            } else {
                showLabel.text = @"实物多";
            }
            [_BeginExameSecondBgview addSubview:showLabel];
        } else {
            secondlineview = [BasicControls drawLineWithFrame:CGRectMake(0, KScreenHeight - 70 - 165 - 64, KScreenWidth , .5)];
        }
        [_BeginExameSecondBgview addSubview:secondlineview];
    }
    
    UIView *secondLowView = [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - .5) / 2.0, 90, .5, KScreenHeight - 70 - 165 - 90 - 64)];
    [_BeginExameSecondBgview addSubview:secondLowView];
    
    
    _lessThingBeginExameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, (KScreenWidth - .5) /2.0, (KScreenHeight - 70 - 165 - 90 - 64)) style:UITableViewStylePlain];
    _lessThingBeginExameTableView.delegate = self;
    _lessThingBeginExameTableView.dataSource = self;
    _lessThingBeginExameTableView.backgroundColor = [UIColor whiteColor];
    _lessThingBeginExameTableView.hidden = YES;
    _lessThingBeginExameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _lessThingBeginExameTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_BeginExameSecondBgview addSubview:_lessThingBeginExameTableView];
    
    _moreThingBeginExameTableView = [[UITableView alloc] initWithFrame:CGRectMake(((KScreenWidth - .5) /2.0) + .5, 90, (KScreenWidth - .5) /2.0, (KScreenHeight - 70 - 165 - 90 - 64)) style:UITableViewStylePlain];
    _moreThingBeginExameTableView.delegate = self;
    _moreThingBeginExameTableView.dataSource = self;
    _moreThingBeginExameTableView.backgroundColor = [UIColor whiteColor];
    _moreThingBeginExameTableView.hidden = YES;
    _moreThingBeginExameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _moreThingBeginExameTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_BeginExameSecondBgview addSubview:_moreThingBeginExameTableView];

    UILabel *zhaiyaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, KScreenHeight - 70 - 165 + 12 - 64, 80, 21)];
    zhaiyaoLabel.font = MainFont;
    zhaiyaoLabel.text = @"摘要";
    [_BeginExameSecondBgview addSubview:zhaiyaoLabel];
    
    UILabel *zhaiyaomesageLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, KScreenHeight - 70 - 165 + 12 - 64, KScreenWidth - 100, 46)];
    zhaiyaomesageLabel.numberOfLines = 0;
    zhaiyaomesageLabel.tag = 3121234;
    zhaiyaomesageLabel.font = MainFont;
    [_BeginExameSecondBgview addSubview:zhaiyaomesageLabel];
}


#pragma mark - 数据请求
//保存盘库
- (void)saveExameData
{
    
    if (_Warehouseid == nil) {
        [BasicControls showAlertWithMsg:@"您还没选择仓库" addTarget:nil];
        return;
    } else if (_GoodsID == nil) {
        [BasicControls showAlertWithMsg:@"您还没选择商品类型" addTarget:nil];
        return;
    } else if (_scanSerials.count == 0) {
        [BasicControls showAlertWithMsg:@"您还没扫描" addTarget:nil];
        return;
    }
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *FirstCheckURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_CheckSingleSave];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //id
    [params setObject:@(-1) forKey:@"id"];
    //日期
    NSString *dateString = [BasicControls TurnTodayDate];;
    [params setObject:dateString forKey:@"fsrq"];
    //盘点范围
    NSString *pdfw = [NSString stringWithFormat:@"仓库:%@,商品类型:%@",[_Warehouseid valueForKey:@"name"],[_GoodsID valueForKey:@"name"]];
    [params setObject:pdfw forKey:@"pdfw"];
    //实物少
    NSString *lessString = [_lessThingBeginExameDatalist componentsJoinedByString:@"\n"];
    [params setObject:lessString forKey:@"sws"];
    //实物多
    NSString *moreString = [_moreThingBeginExameDatalist componentsJoinedByString:@"\n"];
    [params setObject:moreString forKey:@"swd"];
    //摘要
    UILabel *label = (UILabel *)[_BeginExameSecondBgview viewWithTag:3121234];
    [params setObject:label.text forKey:@"comments1"];
    //单据号
    [params setObject:@"New" forKey:@"djh"];
    [self showProgress];
    [XPHTTPRequestTool reloadMothedWithPost:FirstCheckURL params:params success:^(id responseObject) {
        [self hideProgress];
        [BasicControls showNDKNotifyWithMsg:@"保存成功" WithDuration:1 speed:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addnewexameData" object:nil];
    } failure:^(NSError *error) {
        [self hideProgress];
        [BasicControls showNDKNotifyWithMsg:@"提交失败！" WithDuration:1 speed:1];
    }];
}

//获取库存串号
- (void)getKuCunSerialDatalistWithPage:(double)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *FirstCheckURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_StockCode];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_Warehouseid valueForKey:@"id"]  forKey:@"ckdm"];
    [params setObject:[_GoodsID valueForKey:@"bm"] forKey:@"splx"];
    [params setObject:@(10000) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:FirstCheckURL params:params success:^(id responseObject) {
        [self hideProgress];
        _examePage = [responseObject[@"page"] doubleValue];
        _examePages = [responseObject[@"pages"] doubleValue];
        if (_ThingBeginExameDatalisted.count == 0) {
            _ThingBeginExameDatalisted = [SerialThingModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        }
//        else {
//            _ThingBeginExameDatalisted = [_ThingBeginExameDatalisted arrayByAddingObjectsFromArray:[SerialThingModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
//        }

        if (_examePages > _examePage) {
            [self getKuCunSerialDatalistWithPage:_examePage];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _ThingBeginExameDatalisted) {
                [array addObject:[dic valueForKey:@"col0"]];
            }
            _ThingBeginExameDatalist = array;
        }
    } failure:^(NSError *error) {
        NSLog(@"获取期初盘库失败");
        [self hideProgress];
    }];
}

#pragma mark - 开始扫描
- (void)beginExames
{
    if (_Warehouseid == nil) {
        [BasicControls showAlertWithMsg:@"您还没选择仓库" addTarget:nil];
        return;
    } else if (_GoodsID == nil) {
        [BasicControls showAlertWithMsg:@"您还没选择商品类型" addTarget:nil];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getKuCunSerialDatalistWithPage:1];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        ScanStringViewController *scanStringVC = [[ScanStringViewController alloc] init];
        if (_scanSerials.count != 0) {
            scanStringVC.scanStringDatalist=[_scanSerials mutableCopy];
        }
        [self presentViewController:scanStringVC animated:YES completion:nil];
    });

}

#pragma mark - 添加仓库和商品类型
- (void)choosedetail:(UIButton *)button
{
    if (button.tag == 3112110) {
        StoresViewController *storeVC = [[StoresViewController alloc] init];
        storeVC.WhichChooseString = X6_ChooseWarehous;
        [self.navigationController pushViewController:storeVC animated:YES];
    } else {
        StoresViewController *storeVC = [[StoresViewController alloc] init];
        storeVC.WhichChooseString = X6_mykucunTitle;
        [self.navigationController pushViewController:storeVC animated:YES];
    }
}

#pragma mark - 通知事件
//串号
- (void)sureScanSerials:(NSNotification *)noti
{
    _scanSerials = noti.object;
    _lessThingBeginExameDatalist = [NSMutableArray array];
    _moreThingBeginExameDatalist = [NSMutableArray array];
    for (NSString *string in _scanSerials) {
        if (![_ThingBeginExameDatalist containsObject:string]) {
            [_moreThingBeginExameDatalist addObject:string];
        }
    }
    for (NSString *string in _ThingBeginExameDatalist) {
        if (![_scanSerials containsObject:string]) {
            [_lessThingBeginExameDatalist addObject:string];
        }
    }
    if (_lessThingBeginExameDatalist.count != 0) {
        _lessThingBeginExameTableView.hidden = NO;
        [_lessThingBeginExameTableView reloadData];
    }
    if (_moreThingBeginExameDatalist.count != 0) {
        _moreThingBeginExameTableView.hidden = NO;
        [_moreThingBeginExameTableView reloadData];
    }

    UILabel *label = (UILabel *)[_BeginExameSecondBgview viewWithTag:3121234];
    if (_lessThingBeginExameDatalist.count != 0 || _moreThingBeginExameDatalist.count != 0) {
        label.text = [NSString stringWithFormat:@"实物数量:%lu,系统数量:%lu;系统与实物数量不一致,具体情况看盘点结果",(unsigned long)_scanSerials.count,_ThingBeginExameDatalist.count];
    } else {
        label.text = [NSString stringWithFormat:@"实物数量:%lu,系统数量:%lu;库存正常",(unsigned long)_scanSerials.count,_ThingBeginExameDatalist.count];
    }

}

//仓库
- (void)sureWarehouseSerials:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    UIButton *wareButton = (UIButton *)[_BeginExameFirstBgview viewWithTag:3112110];
    [wareButton setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
    _Warehouseid = dic;
}

//商品类型
- (void)sureGoodtype:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    UIButton *goodtypeButton = (UIButton *)[_BeginExameFirstBgview viewWithTag:3112111];
    [goodtypeButton setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
    _GoodsID = dic;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_lessThingBeginExameTableView]) {
        return _lessThingBeginExameDatalist.count;
    } else {
        return _moreThingBeginExameDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_lessThingBeginExameTableView]) {
        static NSString *lessgoodThingcellid = @"lessgoodThingcellid";
        GoodsThingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lessgoodThingcellid];
        if (cell == nil) {
            cell = [[GoodsThingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lessgoodThingcellid];
        }
        cell.things = _lessThingBeginExameDatalist[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *moregoodThingcellid = @"moregoodThingcellid";
        GoodsThingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moregoodThingcellid];
        if (cell == nil) {
            cell = [[GoodsThingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moregoodThingcellid];
        }
        cell.things = _moreThingBeginExameDatalist[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

@end
