//
//  SubscribeByStoreViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SubscribeByStoreViewController.h"
#import "XPDatePicker.h"

#import "SubscribeBySalesClerkViewController.h"

#import "SubscribeByStoreModel.h"

#import "SubsscribeByStoreTableViewCell.h"

#import "ChangePositionLabelView.h"
@interface SubscribeByStoreViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    ChangePositionLabelView *_naviTitleLabel;

    UITableView *_SubscribeByStoreTableView;
    
    NSMutableArray *_SubscribeByStoreDatalist;
    NSMutableArray *_selectSectionArray;                         //标题被选中数组
    NSMutableDictionary *_detailDic;
}

@end

@implementation SubscribeByStoreViewController

- (void)dealloc{
    if ([_naviTitleLabel.timer isValid]) {
        [_naviTitleLabel.timer invalidate];
        _naviTitleLabel.timer = nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"门店详情"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _SubscribeByStoreDatalist = [NSMutableArray array];
    _selectSectionArray = [NSMutableArray array];
    _detailDic = [NSMutableDictionary dictionary];
    
    
    [self drawSubscribeByStoreUI];
    
    [self getSubscribeByStoreData];
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

#pragma mark -  获取门店详情数据
- (void)getSubscribeByStoreData
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefalut objectForKey:X6_UseUrl];
    NSString *SubscribeDetailURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_type == 1) {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeDayBystore];
        [params setObject:_dateString forKey:@"fsrq"];
    } else if (_type == 2) {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeWeekBystore];
        [params setObject:_dateString forKey:@"wd"];
    } else {
        SubscribeDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SubscribeMonthBystore];
        [params setObject:_dateString forKey:@"wd"];
    }

    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:SubscribeDetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        
        NSMutableArray *responseArray = [SubscribeByStoreModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        
        //门店集合
        NSMutableSet *storesSet = [NSMutableSet set];
        for (NSDictionary *dic in responseArray) {
            [storesSet addObject:[dic valueForKey:@"col1"]];
        }
        NSMutableArray *stores = [[storesSet allObjects] mutableCopy];
        
        for (int i = 0; i < stores.count; i++) {
            NSMutableArray *section = [NSMutableArray array];
            NSString *ssmdsh = [NSString string];
            for (NSDictionary *diced in responseArray) {
                if ([[diced valueForKey:@"col1"] isEqualToString:stores[i]]) {
                    [section addObject:diced];
                    ssmdsh = [diced valueForKey:@"col2"];
                }
            }
            
            //添加总计
            float totalNum = 0,totalMoney = 0,totalProfit = 0;
            for (NSDictionary *dic in section) {
                totalNum += [[dic valueForKey:@"col3"] floatValue];
                totalMoney += [[dic valueForKey:@"col4"] floatValue];
                totalProfit += [[dic valueForKey:@"col5"] floatValue];
            }
            
            //构建数据
            NSMutableDictionary *datadic = [NSMutableDictionary dictionary];
            datadic[@"data"] = section;
            datadic[@"ssmd"] = stores[i];
            datadic[@"date"] = _dateString;
            datadic[@"ssmdsh"] = ssmdsh;
            datadic[@"index"] = @(i + 1);
            datadic[@"totalNum"] = @(totalNum);
            datadic[@"totalMoney"] = @(totalMoney);
            datadic[@"totalProfit"] = @(totalProfit);
            [_SubscribeByStoreDatalist addObject:datadic];
        }
        
        [_SubscribeByStoreTableView reloadData];
 
    } failure:^(NSError *error) {
        [self hideProgress];

    }];
}


#pragma mark - 绘制UI
- (void)drawSubscribeByStoreUI
{
    _naviTitleLabel = [[ChangePositionLabelView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _naviTitleLabel.LabelString = self.dateString;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_naviTitleLabel];
    
    
    _SubscribeByStoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _SubscribeByStoreTableView.dataSource = self;
    _SubscribeByStoreTableView.delegate = self;
    _SubscribeByStoreTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _SubscribeByStoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _SubscribeByStoreTableView.backgroundColor = [UIColor whiteColor];
    _SubscribeByStoreTableView.allowsSelection = NO;
    [self.view addSubview:_SubscribeByStoreTableView];
}


#pragma mark - 标题视图
- (UIView *)creatSubscribeByStoreHeaderViewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45 + 10 + 47.5)];
    headerview.backgroundColor = [UIColor whiteColor];
    
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 45)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 11, 23, 23)];

    if (self.type == 1) {
        BgView.backgroundColor = ColorRGB(239, 127, 175);
        imageView.image = [UIImage imageNamed:@"pm_1"];

    } else if (self.type == 2) {
        BgView.backgroundColor = ColorRGB(243, 134, 1);
        imageView.image = [UIImage imageNamed:@"pm_2"];

    } else if (self.type == 3)  {
        BgView.backgroundColor = ColorRGB(53, 184, 158);
        imageView.image = [UIImage imageNamed:@"pm_3"];

    }
    
    [headerview addSubview:BgView];
    [BgView addSubview:imageView];
    
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 11, 23, 23)];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = MainFont;
    indexLabel.backgroundColor = [UIColor clearColor];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.text = [NSString stringWithFormat:@"%@",[mutableArray[section] valueForKey:@"index"]];
    [BgView addSubview:indexLabel];
    
    UILabel *StoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 12, KScreenWidth - 39 - 26, 21)];
    StoreLabel.textColor = [UIColor whiteColor];
    StoreLabel.font = MainFont;
    StoreLabel.text = [NSString stringWithFormat:@"%@",[mutableArray[section] valueForKey:@"ssmd"]];
    [BgView addSubview:StoreLabel];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 46, 18.5, 14, 8)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectSectionArray containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"jt_2"];
    } else {
        selectView.image = [UIImage imageNamed:@"jt_1"];
    }
    [BgView addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 45);
    button.tag = 102000 + section;
    [button addTarget:self action:@selector(leadStoreSectionData:) forControlEvents:UIControlEventTouchUpInside];
    [BgView addSubview:button];
    
    
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(10, 55 + 2.5, KScreenWidth - 20, 45)];
    typeView.backgroundColor = GrayColor;
    [headerview addSubview:typeView];
    
    for (int i = 0; i < 4; i++) {
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + ((KScreenWidth - 35) / 4) * i, 12, (KScreenWidth - 35) / 4, 21)];
        typeLabel.font = MainFont;
        if (i == 0) {
            typeLabel.textAlignment = NSTextAlignmentLeft;
            typeLabel.text = @"类型";
        } else {
            typeLabel.textAlignment = NSTextAlignmentCenter;
            if (i == 1) {
                typeLabel.text = @"数量";
            } else if (i == 2) {
                typeLabel.text = @"金额";
            } else if (i == 3) {
                typeLabel.text = @"毛利";
            }
        }
        [typeView addSubview:typeLabel];
    }
    
    return headerview;
}

#pragma mark - 底部试图
- (UIView *)creatSubscribeByStoreFooterViewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 47.5 * 2)];
    footView.backgroundColor = [UIColor whiteColor];
    
    //总计
    UIView *totalBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 2.5, KScreenWidth - 20, 45)];
    totalBgView.backgroundColor = GrayColor;
    [footView addSubview:totalBgView];
    
    for (int i = 0; i < 4; i++) {
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + ((KScreenWidth - 35) / 4) * i, 12, (KScreenWidth - 35) / 4, 21)];
        totalLabel.font = MainFont;
        if (i == 0) {
            totalLabel.textAlignment = NSTextAlignmentLeft;
            totalLabel.text = @"总计";
        } else {
            totalLabel.textAlignment = NSTextAlignmentCenter;
            if (i == 1) {
                totalLabel.text = [NSString stringWithFormat:@"%@",[mutableArray[section] valueForKey:@"totalNum"]];
            } else if (i == 2) {
                totalLabel.text =  [NSString stringWithFormat:@"%@",[mutableArray[section] valueForKey:@"totalMoney"]];
            } else if (i == 3) {
                totalLabel.text =  [NSString stringWithFormat:@"%@",[mutableArray[section] valueForKey:@"totalProfit"]];
            }
        }
        [totalBgView addSubview:totalLabel];
    }
    
    //详情按钮
    UIButton *moreMesageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreMesageButton.frame = CGRectMake(10, 50, KScreenWidth - 20, 45);
    moreMesageButton.backgroundColor = GrayColor;
    moreMesageButton.tag = 103000 + section;
    [moreMesageButton addTarget:self action:@selector(SubscribeByStoreMore:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreMesageButton];
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 167.5, 10, 120, 25)];
    buttonLabel.font = MainFont;
    buttonLabel.text = @"营业员销售情况";
    buttonLabel.backgroundColor = GrayColor;
    buttonLabel.textAlignment = NSTextAlignmentRight;
    if (self.type == 1) {
        buttonLabel.textColor = ColorRGB(239, 127, 175);
    } else if (self.type == 2) {
        buttonLabel.textColor = ColorRGB(243, 134, 1);
    } else if (self.type == 3)  {
        buttonLabel.textColor = ColorRGB(53, 184, 158);
    }
    [moreMesageButton addSubview:buttonLabel];
    UIImageView *buttonimageview = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 37.5, 15, 7.5, 15)];
    buttonimageview.image = [UIImage imageNamed:@"y1_b"];
    [moreMesageButton addSubview:buttonimageview];
    
    return footView;
}

#pragma mark - 按钮事件
//表头点击：门店数据详情
- (void)leadStoreSectionData:(UIButton *)button
{
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 102000];
    
    if ([_selectSectionArray containsObject:string]) {
        [_selectSectionArray removeObject:string];
        [_detailDic removeObjectForKey:string];        
    } else {
        [_selectSectionArray addObject:string];
        [_detailDic setObject:[_SubscribeByStoreDatalist[button.tag - 102000] valueForKey:@"data"] forKey:string];
    }
    [_SubscribeByStoreTableView reloadData];

}

//底部按钮点击
- (void)SubscribeByStoreMore:(UIButton *)button
{
    NSInteger indextag = button.tag - 103000;
    SubscribeBySalesClerkViewController *SubscribeBySalesClerkVC = [[SubscribeBySalesClerkViewController alloc] init];
    SubscribeBySalesClerkVC.dateString = [_SubscribeByStoreDatalist[indextag] valueForKey:@"date"];
    SubscribeBySalesClerkVC.ssgsString = [_SubscribeByStoreDatalist[indextag] valueForKey:@"ssmd"];
    SubscribeBySalesClerkVC.ssgs = [_SubscribeByStoreDatalist[indextag] valueForKey:@"ssmdsh"];
    SubscribeBySalesClerkVC.type = self.type;
    [self.navigationController pushViewController:SubscribeBySalesClerkVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _SubscribeByStoreDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45 + 10 + 47.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 + 2.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectSectionArray containsObject:string]) {
        NSArray *sectionArray = [_detailDic objectForKey:string];
        return sectionArray.count;
    } else {
        return 0;
    }
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview = [self creatSubscribeByStoreHeaderViewWithMutableArray:[_SubscribeByStoreDatalist mutableCopy] Section:section];
    return headerview;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [self creatSubscribeByStoreFooterViewWithMutableArray:[_SubscribeByStoreDatalist mutableCopy] Section:section];
    return footView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *SubscribeByStoreident = @"SubscribeByStoreident";
    SubsscribeByStoreTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SubsscribeByStoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SubscribeByStoreident];
    }
    if ([_selectSectionArray containsObject:indexStr]) {
        NSArray *array = [_detailDic objectForKey:indexStr];
        cell.dic = array[indexPath.row];
    }

    return cell;
}

@end
