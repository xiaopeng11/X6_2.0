//
//  EarlyWarningViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EarlyWarningViewController.h"

#import "EarlyWarningTableViewCell.h"

#import "OutboundDetailViewController.h"
#import "OldlibraryViewController.h"
#import "PurchaseViewController.h"
#import "RetailViewController.h"
#import "OverduereceivablesViewController.h"
@interface EarlyWarningViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *datalist;
    UITableView *_tableview;
    
    UIView *_wraningView;
    UILabel *_wraningNumLabel;
}

@end

@implementation EarlyWarningViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"我的提醒"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qxlisthadchangedEarlyWarning) name:@"changeQXList" object:nil];

    [self qxlisthadchangedEarlyWarning];

    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight - 64 - 10) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.backgroundColor = GrayColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
    for (int i = 0; i < datalist.count; i++) {
        NSInteger num = [[datalist[i] valueForKey:@"buttonTag"] integerValue];
        _wraningView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth - 38 - 20, 9 + 45 * i, 26, 26)];
        _wraningView.backgroundColor = [UIColor redColor];
        _wraningView.hidden = YES;
        _wraningView.clipsToBounds = YES;
        _wraningView.layer.cornerRadius = 13;
        _wraningView.tag = 60010 + num;
        [_tableview addSubview:_wraningView];
        
        _wraningNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 38 - 20, 9 + 45 * i, 26, 26)];
        _wraningNumLabel.textColor = [UIColor whiteColor];
        _wraningNumLabel.textAlignment = NSTextAlignmentCenter;
        _wraningNumLabel.font = [UIFont systemFontOfSize:12];
        _wraningNumLabel.tag = 60020 + num;
        _wraningNumLabel.hidden = YES;
        [_tableview addSubview:_wraningNumLabel];
    }
}

- (void)qxlisthadchangedEarlyWarning
{
    NSArray *mess = @[@{@"title":@"bb_jxc_cgyc",@"image":@"b2_a",@"text":@"采购异常",@"pc":@NO,@"buttonTag":@"0",@"Edition":@YES},
                      @{@"title":@"bb_jxc_ckyc",@"image":@"b2_b",@"text":@"出库异常",@"pc":@NO,@"buttonTag":@"1",@"Edition":@YES},
                      @{@"title":@"bb_jxc_lsyc",@"image":@"b2_c",@"text":@"售价异常",@"pc":@NO,@"buttonTag":@"2",@"Edition":@YES},
                      @{@"title":@"bb_jxc_klyj",@"image":@"b2_d",@"text":@"库龄逾期",@"pc":@NO,@"buttonTag":@"3",@"Edition":@YES},
                      @{@"title":@"bb_jxc_yskyj",@"image":@"b2_e",@"text":@"应收逾期",@"pc":@NO,@"buttonTag":@"4",@"Edition":@YES}
                      ];
    datalist = [NSMutableArray arrayWithArray:mess];
    //判断零售还是批发－－动态删减子模块
    if ([_edtionString isEqualToString:@"X6经典版"] || [_edtionString isEqualToString:@"X6辉煌版"] || [_edtionString isEqualToString:@"X6旗舰版"])
    {
        [datalist removeObjectAtIndex:4];
        //版本－－Edition是否可用
        if ([_edtionString isEqualToString:@"X6经典版"] || [_edtionString isEqualToString:@"X6辉煌版"]) {
            for (int i = 0; i < 3; i++) {
                NSMutableDictionary *newmessdic = [NSMutableDictionary dictionaryWithDictionary:datalist[i]];
                [newmessdic setValue:@NO forKey:@"Edition"];
                [datalist replaceObjectAtIndex:i withObject:newmessdic];
            }
        }
    } else if ([_edtionString isEqualToString:@"X6通信市场标准版"] || [_edtionString isEqualToString:@"X6通信市场财务版"]) {
        [datalist removeObjectAtIndex:1];
        [datalist removeObjectAtIndex:2];
        //版本－－Edition是否可用
        if ([_edtionString isEqualToString:@"X6通信市场标准版"]) {
            //采购异常
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:datalist[0]];
            [dic1 setValue:@NO forKey:@"Edition"];
            [datalist replaceObjectAtIndex:0 withObject:dic1];
            //应收预期
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:datalist[2]];
            [dic2 setValue:@NO forKey:@"Edition"];
            [datalist replaceObjectAtIndex:2 withObject:dic2];
        }
    }
    //获取权限列表判断授权
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    NSMutableArray *newdatalist = [NSMutableArray array];
    for (int i = 0; i < datalist.count; i++) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:datalist[i]];
        for (NSDictionary *diced in qxList) {
            if ([[diced valueForKey:@"qxid"] isEqualToString:[mutableDic valueForKey:@"title"]]) {
                if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@YES forKey:@"pc"];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@YES forKey:@"pc"];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@YES forKey:@"pc"];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_klyj"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@YES forKey:@"pc"];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_yskyj"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@YES forKey:@"pc"];
                    }
                }
                break;
            }
        }
        [newdatalist addObject:mutableDic];
    }
    datalist = newdatalist;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getwarningMessages];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *earlyWarningCell = @"EarlyWarningCell";
    EarlyWarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:earlyWarningCell];
    if (cell == nil) {
        cell = [[EarlyWarningTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:earlyWarningCell];
        
    }
    cell.dic = datalist[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger num = [[datalist[indexPath.row] valueForKey:@"buttonTag"] integerValue];
    
    NSDictionary *dic = datalist[num];
    if (![[dic valueForKey:@"pc"] boolValue]) {
        [BasicControls showAlertWithMsg:@"该功能未经授权，请与系统管理员联系授权" addTarget:nil];
        return;
    }
    if (num == 0) {
        //采购异常
        PurchaseViewController *purchaseVC = [[PurchaseViewController alloc] init];
        purchaseVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:purchaseVC animated:YES];
    } else if (num == 1) {
        //出库异常
        OutboundDetailViewController *outboundVC = [[OutboundDetailViewController alloc] init];
        outboundVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:outboundVC animated:YES];
    } else if (num == 2) {
        //售价异常
        RetailViewController *retailVC = [[RetailViewController alloc] init];
        retailVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:retailVC animated:YES];
    } else if (num == 3){
        //库龄预警
        OldlibraryViewController *oldlibraryVC = [[OldlibraryViewController alloc] init];
        [self.navigationController pushViewController:oldlibraryVC animated:YES];
    } else {
        //应收款逾期
        OverduereceivablesViewController *overdueVC = [[OverduereceivablesViewController alloc] init];
        overdueVC.ishow = [[dic valueForKey:@"Edition"] boolValue];
        [self.navigationController pushViewController:overdueVC animated:YES];
    }
}

- (void)getwarningMessages
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *EarlyWarningNumURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_EarlyWarningNumber];

    dispatch_group_t warninggroup = dispatch_group_create();
    
    NSMutableArray *txlx = [NSMutableArray array];
    for (NSDictionary *dic in datalist) {
        if ([[dic valueForKey:@"buttonTag"] integerValue] == 0) {
            [txlx addObject:@"CGYC"];
        } else if ([[dic valueForKey:@"buttonTag"] integerValue] == 1){
            [txlx addObject:@"CKYC"];
        } else if ([[dic valueForKey:@"buttonTag"] integerValue] == 2){
            [txlx addObject:@"LSYC"];
        } else if ([[dic valueForKey:@"buttonTag"] integerValue] == 3){
            [txlx addObject:@"KLYJ"];
        } else if ([[dic valueForKey:@"buttonTag"] integerValue] == 4){
            [txlx addObject:@"YSKYJ"];
        }
    }
    for (int i = 0; i < txlx.count; i++) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:txlx[i] forKey:@"txlx"];
        dispatch_group_enter(warninggroup);
        [XPHTTPRequestTool requestMothedWithPost:EarlyWarningNumURL params:params success:^(id responseObject) {
            if ([responseObject[@"type"] isEqualToString:@"success"]) {
                _wraningView = (UIView *)[_tableview viewWithTag:60010 + i];
                _wraningNumLabel = (UILabel *)[_tableview viewWithTag:60020 + i];
                if ([responseObject[@"message"] integerValue] == 0) {
                    _wraningNumLabel.hidden = YES;
                    _wraningView.hidden = YES;
                } else {
                    NSString *num = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
                    _wraningNumLabel.hidden = NO;
                    _wraningView.hidden = NO;
                    if ([num longLongValue] > 99) {
                        _wraningNumLabel.text = @"99+";
                    } else {
                        _wraningNumLabel.text = num;
                    }
                }
            }
            dispatch_group_leave(warninggroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(warninggroup);
        }];
    }
   
    dispatch_group_notify(warninggroup, dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
    
}

@end
