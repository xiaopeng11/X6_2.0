//
//  MoreInventoryViewController.m
//  project-x6
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MoreInventoryViewController.h"
#import "TakeInventoryModel.h"
#import "GoodsThingTableViewCell.h"
@interface MoreInventoryViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UIView *_headerBgView;
    UITextView *_InventorycheckTV;  //审批说明
    UITableView *_lessThingTableView;
    UITableView *_moreThingTableView;
    
    NSMutableArray *_lessThingDatalist;
    NSMutableArray *_moreThingDatalist;

    UIButton *_ispassORnot;
    int _isPass;
}
@end

@implementation MoreInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"盘点情况"];
    
    
    [self drawMoreInventoryUI];
    
    [self getMoreInventoryData];
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
- (void)drawMoreInventoryUI
{
    UIScrollView *MoreInventoryscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 45)];
    MoreInventoryscrollView.showsVerticalScrollIndicator = NO;
    MoreInventoryscrollView.showsHorizontalScrollIndicator = NO;
    MoreInventoryscrollView.contentSize = CGSizeMake(KScreenWidth, 30 + 140 + 45 + 210 + 45);
    [self.view addSubview:MoreInventoryscrollView];
    
    _headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 140)];
    _headerBgView.backgroundColor = [UIColor whiteColor];
    [MoreInventoryscrollView addSubview:_headerBgView];
    
    for (int i = 0; i < 2; i++) {
        UILabel *zyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + 70 * i, 80, 25)];
        zyLabel.font = MainFont;
        if (i == 0) {
            zyLabel.text = @"摘要";
        } else {
            zyLabel.text = @"审批说明";
        }
        [_headerBgView addSubview:zyLabel];
        if (i == 0) {
            UILabel *MessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 12 , KScreenWidth - 100, 46)];
            MessageLabel.font = MainFont;
            MessageLabel.numberOfLines = 0;
            MessageLabel.tag = 381000 + i;
            [_headerBgView addSubview:MessageLabel];
        }
    }
    
    _InventorycheckTV = [[UITextView alloc] initWithFrame:CGRectMake(90, 82, KScreenWidth - 100, 46)];
    _InventorycheckTV.font = MainFont;
    [_headerBgView addSubview:_InventorycheckTV];
    
    UIView *headerLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 69.5, KScreenWidth, .5)];
    [_headerBgView addSubview:headerLineView];
    
    UIView *moreMessageBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 160, KScreenWidth, 210 + 45)];
    moreMessageBgview.backgroundColor = [UIColor whiteColor];
    [MoreInventoryscrollView addSubview:moreMessageBgview];
    
    UILabel *lessThing = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, KScreenWidth / 2.0, 20)];
    lessThing.font = MainFont;
    lessThing.text = @"实物少";
    lessThing.textAlignment = NSTextAlignmentCenter;
    [moreMessageBgview addSubview:lessThing];
    
    UILabel *moreThing = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 2.0, 12, KScreenWidth/ 2.0, 20)];
    moreThing.font = MainFont;
    moreThing.text = @"实物多";
    moreThing.textAlignment = NSTextAlignmentCenter;
    [moreMessageBgview addSubview:moreThing];

    UIView *moreLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [moreMessageBgview addSubview:moreLineView];
    
    UIView *moreLowView = [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - .5) /2, 45, .5, 210)];
    [moreMessageBgview addSubview:moreLowView];
    
    _lessThingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, (KScreenWidth - .5) /2.0, 210) style:UITableViewStylePlain];
    _lessThingTableView.delegate = self;
    _lessThingTableView.dataSource = self;
    _lessThingTableView.backgroundColor = [UIColor whiteColor];
    _lessThingTableView.hidden = YES;
    _lessThingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _lessThingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [moreMessageBgview addSubview:_lessThingTableView];
    
    _moreThingTableView = [[UITableView alloc] initWithFrame:CGRectMake(((KScreenWidth - .5) /2.0) + .5, 45, (KScreenWidth - .5) /2.0, 210) style:UITableViewStylePlain];
    _moreThingTableView.delegate = self;
    _moreThingTableView.dataSource = self;
    _moreThingTableView.backgroundColor = [UIColor whiteColor];
    _moreThingTableView.hidden = YES;
    _moreThingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _moreThingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [moreMessageBgview addSubview:_moreThingTableView];
    
    UIView *lastBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 425, KScreenWidth, 45)];
    lastBgview.backgroundColor = [UIColor whiteColor];
    [MoreInventoryscrollView addSubview:lastBgview];
    
    UILabel *passornolabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 20)];
    passornolabel.font = MainFont;
    passornolabel.text = @"是否通过";
    [lastBgview addSubview:passornolabel];
    
    _ispassORnot = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 52, 10, 42, 25)];
    [_ispassORnot addTarget:self action:@selector(ispassInventory:) forControlEvents:UIControlEventTouchUpInside];
    [lastBgview addSubview:_ispassORnot];
    
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 45, KScreenWidth, 45)];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    
    UIButton *ExaminationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ExaminationButton.frame = CGRectMake((KScreenWidth - 134) / 3.0, 8.5, 67, 28);
    [ExaminationButton setTitle:@"审批" forState:UIControlStateNormal];
    [ExaminationButton setBackgroundColor:Mycolor];
    ExaminationButton.clipsToBounds = YES;
    ExaminationButton.layer.cornerRadius = 4;
    [ExaminationButton addTarget:self action:@selector(examine) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgView addSubview:ExaminationButton];
    
    UIButton *deleteExaminationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteExaminationButton.frame = CGRectMake((2 * (KScreenWidth - 134) / 3.0) + 67, 8.5, 67, 28);
    [deleteExaminationButton setTitle:@"撤审" forState:UIControlStateNormal];
    [deleteExaminationButton setBackgroundColor:Mycolor];
    deleteExaminationButton.clipsToBounds = YES;
    deleteExaminationButton.layer.cornerRadius = 4;
    [deleteExaminationButton addTarget:self action:@selector(deleteexamine) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgView addSubview:deleteExaminationButton];
}


#pragma mark - 获取数据
- (void)getMoreInventoryData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *moreInventoryURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_CheckTheDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.inventoryid forKey:@"id"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:moreInventoryURL params:params success:^(id responseObject) {
        [self hideProgress];
        NSDictionary *moreInventoryDic = responseObject[@"vo"];
        
        UILabel *label1 = (UILabel *)[_headerBgView viewWithTag:381000];
        label1.text = [moreInventoryDic valueForKey:@"comments1"];
        UILabel *label2 = (UILabel *)[_headerBgView viewWithTag:381001];
        label2.text = [moreInventoryDic valueForKey:@"comments2"];
        
        NSString *swsString = [moreInventoryDic valueForKey:@"sws"];
        NSString *swdString = [moreInventoryDic valueForKey:@"swd"];
        NSArray *swsarray = [swsString componentsSeparatedByString:@"\n"];
        NSArray *swdarray = [swdString componentsSeparatedByString:@"\n"];
        _lessThingDatalist = [NSMutableArray arrayWithArray:swsarray];
        _moreThingDatalist = [NSMutableArray arrayWithArray:swdarray];
        
        if (_lessThingDatalist.count == 0) {
            _lessThingTableView.hidden = YES;
        } else {
            _lessThingTableView.hidden = NO;
            [_lessThingTableView reloadData];
        }
        if (_moreThingDatalist.count == 0) {
            _moreThingTableView.hidden = YES;
        } else {
            _moreThingTableView.hidden = NO;
            [_moreThingTableView reloadData];
        }
        _isPass = [[moreInventoryDic valueForKey:@"shjg"] intValue];
        if (_isPass == 1) {
            [_ispassORnot setBackgroundImage:[UIImage imageNamed:@"l6_b"] forState:UIControlStateNormal];
        } else {
            [_ispassORnot setBackgroundImage:[UIImage imageNamed:@"l6_a"] forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"盘库详情失败");
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_lessThingTableView]) {
        return _lessThingDatalist.count;
    } else {
        return _moreThingDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodThingcellid = @"goodThingcellid";
    GoodsThingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodThingcellid];
    if (cell == nil) {
        cell = [[GoodsThingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goodThingcellid];
    }
    if ([tableView isEqual:_lessThingTableView]) {
        cell.things = _lessThingDatalist[indexPath.row];
    } else {
        cell.things = _moreThingDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 审批
- (void)examine
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *InventoryexamineURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_CheckSure];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.inventoryid forKey:@"id"];
    if (_InventorycheckTV.text.length == 0) {
        [params setObject:@"" forKey:@"comment2"];
    } else {
        [params setObject:_InventorycheckTV.text forKey:@"comment2"];
    }
    [params setObject:@(_isPass) forKey:@"shjg"];
    [XPHTTPRequestTool requestMothedWithPost:InventoryexamineURL params:params success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}

- (void)deleteexamine
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *InventorydeleteexamineURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_CheckCancle];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.inventoryid forKey:@"id"];
    [XPHTTPRequestTool requestMothedWithPost:InventorydeleteexamineURL params:params success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 通过按钮
- (void)ispassInventory:(UIButton *)button
{
    if (_isPass == 1) {
        [_ispassORnot setBackgroundImage:[UIImage imageNamed:@"l6_a"] forState:UIControlStateNormal];
        _isPass--;
    } else {
        [_ispassORnot setBackgroundImage:[UIImage imageNamed:@"l6_b"] forState:UIControlStateNormal];
        _isPass++;
    }
}

@end
