//
//  InletandPinViewController.m
//  project-x6
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InletandPinViewController.h"
#import "InletandPinCoparisonModel.h"
#import "InletandPinTableViewCell.h"

#import "InletAndPinSearchViewController.h"
@interface InletandPinViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *_topButtonBgView;
    UIView *_topLineView;                //顶部底线
    UITableView *_InletandPinTableView;                 //进销对比数据
    NoDataView *_NoInletandPinView;                     //没有数据
    UIView *_InletandPintotalView;                      //合计
    
    NSMutableArray *_InletandPinDatalist;               //进销数据
    
    long _InletandPinIndex;                 //顶部按钮位置
    NSString *_goodNumberString;             //商品代码
    NSArray *_days;
}


@end

@implementation InletandPinViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"进销对比"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"ss_1" highImageName:nil target:self action:@selector(dateAndThingSearch)];
    
    _InletandPinDatalist = [NSMutableArray array];
    _InletandPinIndex = 0;
    _goodNumberString = [NSString string];
    //日期集合
    //今日
    NSString *todayString = [BasicControls TurnTodayDate];
    //昨日
    NSDate *lastday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *lastdayString = [NSString stringWithFormat:@"%@",lastday];
    lastdayString = [lastdayString substringToIndex:10];
    //前七天
    NSDate *lastweek = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60*7)];
    NSString *lastweekString = [NSString stringWithFormat:@"%@",lastweek];
    lastweekString = [lastweekString substringToIndex:10];
    //前30天
    NSDate *lastmonth = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60*30)];
    NSString *lastmonthString = [NSString stringWithFormat:@"%@",lastmonth];
    lastmonthString = [lastmonthString substringToIndex:10];
    _days = [NSArray arrayWithObjects:todayString,lastdayString,lastweekString,lastmonthString, nil];

    [self drawInletAndPinUI];
    
    [self getInletAndPinDataWithFirstDay:_days[_InletandPinIndex] EndDay:_days[_InletandPinIndex] GoodNumber:_goodNumberString];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInlettandPinData:) name:@"InletAndPin" object:nil];
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
- (void)drawInletAndPinUI
{
    _topButtonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    _topButtonBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topButtonBgView];
    
    NSArray *InletandPintitles = @[@"今日",@"昨日",@"近七日",@"近30天"];
    for (int i  = 0; i < InletandPintitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(((KScreenWidth - 240) / 8.0) + ((((KScreenWidth - 240) / 4.0) + 60) * i), 0, 60, 38);
        button.titleLabel.font = MainFont;
        [button setTitle:InletandPintitles[i] forState:UIControlStateNormal];
        if (i == _InletandPinIndex) {
            [button setTitleColor:Mycolor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = 441110 + i;
        [button addTarget:self action:@selector(InletandPintitlesButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topButtonBgView addSubview:button];
    }
    
    _topLineView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 240) / 8.0, 38, 60, 2)];
    _topLineView.backgroundColor = Mycolor;
    [_topButtonBgView addSubview:_topLineView];
 
    _InletandPinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 40 - 60) style:UITableViewStylePlain];
    _InletandPinTableView.dataSource = self;
    _InletandPinTableView.delegate = self;
    _InletandPinTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _InletandPinTableView.backgroundColor = GrayColor;
    _InletandPinTableView.hidden = YES;
    _InletandPinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_InletandPinTableView];
    
    _NoInletandPinView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 40, KScreenHeight, KScreenHeight - 64 - 40 - 60)];
    _NoInletandPinView.text = @"没有数据";
    _NoInletandPinView.hidden = YES;
    [self.view addSubview:_NoInletandPinView];

    
    //统计按钮
    _InletandPintotalView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 123.5, KScreenWidth, 59.5)];
    _InletandPintotalView.backgroundColor = [UIColor whiteColor];
    _InletandPintotalView.hidden = YES;
    [self.view addSubview:_InletandPintotalView];
    for (int i = 0; i < 8; i++) {
        UILabel *Label = [[UILabel alloc] init];
        Label.textAlignment = NSTextAlignmentCenter;
        Label.font = ExtitleFont;
        if (i / 2 == 0) {
            Label.frame = CGRectMake(0, 7 + 30 * (i % 2), KScreenWidth / 6.0, 20);
        } else if (i / 2 == 1) {
            Label.frame = CGRectMake(KScreenWidth / 6.0, 7 + 30 * (i % 2), KScreenWidth / 3.0, 20);
        } else if (i / 2 == 2) {
            Label.frame = CGRectMake(KScreenWidth / 2.0, 7 + 30 * (i % 2), KScreenWidth / 6.0, 20);
        }  else if (i / 2 == 3) {
            Label.frame = CGRectMake(2 * KScreenWidth / 3.0, 7 + 30 * (i % 2), KScreenWidth / 3.0, 20);
        }
        if (i % 2 == 0) {
            Label.textColor = [UIColor blackColor];
        } else {
            Label.textColor = PriceColor;
        }
        
        if (i == 0) {
            Label.text = @"进货量";
        } else if (i == 2) {
            Label.text = @"进货金额";
        } else if (i == 4) {
            Label.text = @"销售量";
        } else if (i == 6) {
            Label.text = @"销售金额";
        }
        Label.tag = 441120 + i;
        [_InletandPintotalView addSubview:Label];
    }
    
    //统计的分割线
    UIView *totalViewTopLine = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
    [_InletandPintotalView addSubview:totalViewTopLine];
}

//改变线条位置
-(void)changeLine:(float)index
{
    CGRect rect = _topLineView.frame;
    rect.origin.x = ((KScreenWidth - 240) / 8.0) + ((((KScreenWidth - 240) / 4.0) + 60) * index);
    _topLineView.frame = rect;
}

#pragma mark - 点击搜索
- (void)dateAndThingSearch
{
    InletAndPinSearchViewController *InletAndPinSearchVC = [[InletAndPinSearchViewController alloc] init];
    [self.navigationController pushViewController:InletAndPinSearchVC animated:YES];
}

#pragma mark - 顶部按钮事件
- (void)InletandPintitlesButton:(UIButton *)button
{
    if (_InletandPinIndex != button.tag - 441110) {
        //按钮字体颜色
        UIButton *topbutton = [_topButtonBgView viewWithTag:441110 + _InletandPinIndex];
        [topbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _InletandPinIndex = button.tag - 441110;
        [button setTitleColor:Mycolor forState:UIControlStateNormal];
        //划动
        [self changeLine:_InletandPinIndex];
        
        if (_InletandPinIndex == 2 || _InletandPinIndex == 3) {
            [self getInletAndPinDataWithFirstDay:_days[_InletandPinIndex] EndDay:_days[0] GoodNumber:_goodNumberString];
        } else {
            [self getInletAndPinDataWithFirstDay:_days[_InletandPinIndex] EndDay:_days[_InletandPinIndex] GoodNumber:_goodNumberString];
        }
    }
}

#pragma mark - 通知
- (void)changeInlettandPinData:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    //判断顶部按钮是否滑动
    NSString *beginDateString = [dic valueForKey:@"begindate"];
    NSString *endDateString = [dic valueForKey:@"enddate"];
 
    if ([beginDateString isEqualToString:_days[0]] && [endDateString isEqualToString:_days[0]]) {
        if (_InletandPinIndex != 0) {
            //按钮字体颜色
            UIButton *nowbutton = [_topButtonBgView viewWithTag:441110];
            UIButton *lastbutton = [_topButtonBgView viewWithTag:441110 + _InletandPinIndex];
            [lastbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _InletandPinIndex = 0;
            [nowbutton setTitleColor:Mycolor forState:UIControlStateNormal];
            //划动
            [self changeLine:0];
            
            [self getInletAndPinDataWithFirstDay:_days[_InletandPinIndex] EndDay:_days[_InletandPinIndex] GoodNumber:_goodNumberString];
        }
    } else if ([beginDateString isEqualToString:_days[1]] && [endDateString isEqualToString:_days[1]]) {
        if (_InletandPinIndex != 1) {
            //按钮字体颜色
            UIButton *nowbutton = [_topButtonBgView viewWithTag:441111];
            UIButton *lastbutton = [_topButtonBgView viewWithTag:441110 + _InletandPinIndex];
            [lastbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _InletandPinIndex = 1;
            [nowbutton setTitleColor:Mycolor forState:UIControlStateNormal];
            //划动
            [self changeLine:1];
            
            [self getInletAndPinDataWithFirstDay:_days[_InletandPinIndex] EndDay:_days[_InletandPinIndex] GoodNumber:_goodNumberString];
        }
    } else if ([beginDateString isEqualToString:_days[2]] && [endDateString isEqualToString:_days[0]]) {
        if (_InletandPinIndex != 2) {
            //按钮字体颜色
            UIButton *nowbutton = [_topButtonBgView viewWithTag:441112];
            UIButton *lastbutton = [_topButtonBgView viewWithTag:441110 + _InletandPinIndex];
            [lastbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _InletandPinIndex = 2;
            [nowbutton setTitleColor:Mycolor forState:UIControlStateNormal];
            //划动
            [self changeLine:2];
            
            [self getInletAndPinDataWithFirstDay:_days[0] EndDay:_days[_InletandPinIndex] GoodNumber:_goodNumberString];
        }
    } else if ([beginDateString isEqualToString:_days[3]] && [endDateString isEqualToString:_days[0]]) {
        if (_InletandPinIndex != 3) {
            //按钮字体颜色
            UIButton *nowbutton = [_topButtonBgView viewWithTag:441113];
            UIButton *lastbutton = [_topButtonBgView viewWithTag:441110 + _InletandPinIndex];
            [lastbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _InletandPinIndex = 3;
            [nowbutton setTitleColor:Mycolor forState:UIControlStateNormal];
            //划动
            [self changeLine:3];
            
            [self getInletAndPinDataWithFirstDay:_days[0] EndDay:_days[_InletandPinIndex] GoodNumber:_goodNumberString];
        }
    }
    
    [self getInletAndPinDataWithFirstDay:[dic valueForKey:@"begindate"] EndDay:[dic valueForKey:@"enddate"] GoodNumber:[dic valueForKey:@"good"]];
}


#pragma mark - 获取数据
- (void)getInletAndPinDataWithFirstDay:(NSString *)firstDay
                                EndDay:(NSString *)endDay
                            GoodNumber:(NSString *)goodNumber
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_InletandPinComparison];
    [self showProgress];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:firstDay forKey:@"fsrqq"];
    [params setObject:endDay forKey:@"fsrqz"];
    if (goodNumber.length != 0) {
        [params setObject:goodNumber forKey:@"spdm"];
    }

    //获取表示图
    [XPHTTPRequestTool requestMothedWithPost:mykucunURL params:params success:^(id responseObject) {
        NSArray *cgArray = [InletandPinCoparisonModel mj_keyValuesArrayWithObjectArray:responseObject[@"cglist"]];
        NSArray *xsArray = [InletandPinCoparisonModel mj_keyValuesArrayWithObjectArray:responseObject[@"xslist"]];

        NSMutableSet *goodsNames = [NSMutableSet set];
        for (NSDictionary *dic in cgArray) {
            [goodsNames addObject:[dic valueForKey:@"col0"]];
        }
        for (NSDictionary *dic in xsArray) {
            [goodsNames addObject:[dic valueForKey:@"col0"]];
        }
        
        [_InletandPinDatalist removeAllObjects];

        for (NSString *name in goodsNames) {
            NSMutableDictionary *goodsDic = [NSMutableDictionary dictionary];
            [goodsDic setObject:name forKey:@"name"];
            [goodsDic setObject:@"0" forKey:@"cgsl"];
            [goodsDic setObject:@"0" forKey:@"cgje"];
            [goodsDic setObject:@"0" forKey:@"xssl"];
            [goodsDic setObject:@"0" forKey:@"xsje"];
            for (NSDictionary *cgdic in cgArray) {
                if ([[cgdic valueForKey:@"col0"] isEqualToString:name]) {
                    [goodsDic setObject:[cgdic valueForKey:@"col1"] forKey:@"cgsl"];
                    [goodsDic setObject:[cgdic valueForKey:@"col2"] forKey:@"cgje"];
                }
            }
            
            for (NSDictionary *xsdic in xsArray) {
                if ([[xsdic valueForKey:@"col0"] isEqualToString:name]) {
                    [goodsDic setObject:[xsdic valueForKey:@"col1"] forKey:@"xssl"];
                    [goodsDic setObject:[xsdic valueForKey:@"col2"] forKey:@"xsje"];
                }
            }
            [_InletandPinDatalist addObject:goodsDic];
        }
        
        
        if (_InletandPinDatalist.count == 0) {
            _InletandPintotalView.hidden = YES;
            _InletandPinTableView.hidden = YES;
            _NoInletandPinView.hidden = NO;
        } else {
            _NoInletandPinView.hidden = YES;
            _InletandPinTableView.hidden = NO;
            _InletandPintotalView.hidden = NO;
            [_InletandPinTableView reloadData];
            [self totalInletandPin];
        }
        [self hideProgress];
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _InletandPinDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *InletandPinIndet = @"InletandPinIndet";
    InletandPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InletandPinIndet];
    if (cell == nil) {
        cell = [[InletandPinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InletandPinIndet];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = _InletandPinDatalist[indexPath.row];
    return cell;
}

#pragma mark - 统计
- (void)totalInletandPin
{
    float cgNum = 0,cgMoney = 0,xsNum = 0,xsMoney = 0;
    for (NSDictionary *dic in _InletandPinDatalist) {
        cgNum += [[dic valueForKey:@"cgsl"] longLongValue];
        cgMoney += [[dic valueForKey:@"cgje"] longLongValue];
        xsNum += [[dic valueForKey:@"xssl"] longLongValue];
        xsMoney += [[dic valueForKey:@"xsje"] longLongValue];
    }
    
    UILabel *cgnumlabel = (UILabel *)[_InletandPintotalView viewWithTag:441121];
    UILabel *cgjinelabel = (UILabel *)[_InletandPintotalView viewWithTag:441123];
    UILabel *xsnumlabel = (UILabel *)[_InletandPintotalView viewWithTag:441125];
    UILabel *xsjinelabel = (UILabel *)[_InletandPintotalView viewWithTag:441127];

    cgnumlabel.text = [NSString stringWithFormat:@"%.0f",cgNum];
    cgjinelabel.text = [NSString stringWithFormat:@"￥%.2f",cgMoney];
    xsnumlabel.text = [NSString stringWithFormat:@"%.0f",xsNum];
    xsjinelabel.text = [NSString stringWithFormat:@"￥%.2f",xsMoney];

}

@end
