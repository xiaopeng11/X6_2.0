//
//  InletAndPinSearchViewController.m
//  project-x6
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InletAndPinSearchViewController.h"
#import "XPDatePicker.h"
#import "StoresViewController.h"
#import "GoodsTypeViewController.h"
@interface InletAndPinSearchViewController ()<UITextFieldDelegate>

{
    UIView *_InletAndPinSearchFirstBgView;
    UIView *_InletAndPinSearchSecondBgView;
    
    XPDatePicker *_beginDatePicker;
    XPDatePicker *_endDatePicker;
    
    NSString *_goodid; //商品代码
    NSString *_goodtypeid; //商品代码

}
@end

@implementation InletAndPinSearchViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"查询"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"清除" target:self action:@selector(rightNaviButton)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddInletAndPinSearchgoodtype:) name:@"goodtypeschose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddInletAndPinSearchgood:) name:@"goodTypeChange" object:nil];
    
    [self drawInletAndPinSearchView];

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


#pragma mark - 绘制查询条件UI
- (void)drawInletAndPinSearchView
{
    {
        _InletAndPinSearchFirstBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 90)];
        _InletAndPinSearchFirstBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_InletAndPinSearchFirstBgView];
        
        NSString *dateString = [BasicControls TurnTodayDate];
        _beginDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(116, 12, KScreenWidth - 126, 21) Date:dateString];
        _beginDatePicker.delegate = self;
        _beginDatePicker.backgroundColor = [UIColor whiteColor];
        _beginDatePicker.textColor = [UIColor blackColor];
        _beginDatePicker.myfont = MainFont;
        _beginDatePicker.borderStyle = UITextBorderStyleNone;
        _beginDatePicker.labelString = @"开始时间:";
        [_InletAndPinSearchFirstBgView addSubview:_beginDatePicker];
        
        _endDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(116, 57.5, KScreenWidth - 126, 21) Date:dateString];
        _endDatePicker.delegate = self;
        _endDatePicker.backgroundColor = [UIColor whiteColor];
        _endDatePicker.textColor = [UIColor blackColor];
        _endDatePicker.myfont = MainFont;
        _endDatePicker.borderStyle = UITextBorderStyleNone;
        _endDatePicker.labelString = @"结束时间:";
        [_InletAndPinSearchFirstBgView addSubview:_endDatePicker];
        
        
        NSArray *timeTitles = @[@"开始时间",@"结束时间"];
        NSArray *timeTexts = @[@"点击选择开始时间",@"点击选择结束时间"];
        for (int i = 0; i < 2; i++) {
            UILabel *timeTitlesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + (45 * i), 80, 21)];
            timeTitlesLabel.font = MainFont;
            timeTitlesLabel.text = timeTitles[i];
            [_InletAndPinSearchFirstBgView addSubview:timeTitlesLabel];
            
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 45, KScreenWidth, .5)];
            [_InletAndPinSearchFirstBgView addSubview:lineView];
            
            UIButton *timeTextsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            timeTextsButton.frame = CGRectMake(116, 12 + (45 * i), KScreenWidth - 126, 21);
            [timeTextsButton setTitle:timeTexts[i] forState:UIControlStateNormal];
            [timeTextsButton setTitleColor:[UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1] forState:UIControlStateNormal];
            [timeTextsButton setBackgroundColor:[UIColor whiteColor]];
            timeTextsButton.titleLabel.font = MainFont;
            timeTextsButton.tag = 410100 + i;
            [timeTextsButton addTarget:self action:@selector(dateChoose:) forControlEvents:UIControlEventTouchUpInside];
            [_InletAndPinSearchFirstBgView addSubview:timeTextsButton];
        }

    }

    {
        _InletAndPinSearchSecondBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, KScreenWidth, 90)];
        _InletAndPinSearchSecondBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_InletAndPinSearchSecondBgView];
        
        NSArray *typeTitles = @[@"商品类型",@"商品"];
        NSArray *typePlacers = @[@"请选择商品类型",@"请选择商品"];
        for (int i = 0; i < 2; i++) {
            UILabel *timeTitlesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + (45 * i), 80, 21)];
            timeTitlesLabel.font = MainFont;
            timeTitlesLabel.text = typeTitles[i];
            [_InletAndPinSearchSecondBgView addSubview:timeTitlesLabel];
            
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 45, KScreenWidth, .5)];
            [_InletAndPinSearchSecondBgView addSubview:lineView];
            
            UIButton *typeChooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            typeChooseButton.frame = CGRectMake(100, 12 + 45 * i, KScreenWidth - 126, 21);
            [typeChooseButton setTitle:typePlacers[i] forState:UIControlStateNormal];
            [typeChooseButton setTitleColor:[UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1] forState:UIControlStateNormal];
            typeChooseButton.clipsToBounds = YES;
            typeChooseButton.tag = 410110 + i;
            typeChooseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [typeChooseButton setBackgroundColor:[UIColor whiteColor]];
            typeChooseButton.titleLabel.font = MainFont;
            [typeChooseButton addTarget:self action:@selector(typeChoose:) forControlEvents:UIControlEventTouchUpInside];
            [_InletAndPinSearchSecondBgView addSubview:typeChooseButton];
            
            UIImageView *loadView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 16, 16 + 45 * i, 6, 12)];
            loadView.image = [UIImage imageNamed:@"y1_b"];
            [_InletAndPinSearchSecondBgView addSubview:loadView];
        }
    }
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(10, 210, KScreenWidth - 20, 45);
    [searchButton setBackgroundColor:Mycolor];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.titleLabel.font = MainFont;
    searchButton.clipsToBounds = YES;
    searchButton.layer.cornerRadius = 4;
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
}

#pragma mark - 通知事件
//商品类型
- (void)AddInletAndPinSearchgoodtype:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    UIButton *goodtypeButton = (UIButton *)[_InletAndPinSearchSecondBgView viewWithTag:410110];
    [goodtypeButton setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
    [goodtypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _goodtypeid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
}

//商品
- (void)AddInletAndPinSearchgood:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    UIButton *goodButton = (UIButton *)[_InletAndPinSearchSecondBgView viewWithTag:410111];
    [goodButton setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
    [goodButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _goodid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _beginDatePicker) {
        _beginDatePicker.maxdateString = _endDatePicker.text;
        if (_beginDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _beginDatePicker.subView.tag = 1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_beginDatePicker.subView];
        }
    } else {
        _endDatePicker.mindateString = _beginDatePicker.text;
        if (_endDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _endDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_endDatePicker.subView];
        }
    }
    return NO;
}


#pragma mark - 按钮
//清除
- (void)rightNaviButton
{
    UIButton *beginButton = (UIButton *)[_InletAndPinSearchFirstBgView viewWithTag:410100];
    UIButton *endButton = (UIButton *)[_InletAndPinSearchFirstBgView viewWithTag:410101];
    UIButton *goodtypeButton = (UIButton *)[_InletAndPinSearchSecondBgView viewWithTag:410110];
    UIButton *goodButton = (UIButton *)[_InletAndPinSearchSecondBgView viewWithTag:410111];
    beginButton.hidden = NO;
    endButton.hidden = NO;
    [goodtypeButton setTitle:@"请选择商品类型" forState:UIControlStateNormal];
    [goodtypeButton setTitleColor:[UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1] forState:UIControlStateNormal];
    [goodButton setTitle:@"请选择商品" forState:UIControlStateNormal];
    [goodButton setTitleColor:[UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1] forState:UIControlStateNormal];
}


//日期选择
- (void)dateChoose:(UIButton *)button
{
    UIButton *beginButton = (UIButton *)[_InletAndPinSearchFirstBgView viewWithTag:410100];
    UIButton *endButton = (UIButton *)[_InletAndPinSearchFirstBgView viewWithTag:410101];

    if (button.tag == 410100) {
        _beginDatePicker.maxdateString = _endDatePicker.text;
        if (_beginDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _beginDatePicker.subView.tag = 1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_beginDatePicker.subView];
        }
        beginButton.hidden = YES;
    } else {
        _endDatePicker.mindateString = _beginDatePicker.text;
        if (_endDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _endDatePicker.subView.tag = 1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_endDatePicker.subView];
        }
        endButton.hidden = YES;
    }
}

//商品,商品类型选择
- (void)typeChoose:(UIButton *)button
{
    if (button.tag == 410110) {
        StoresViewController *StoresVC = [[StoresViewController alloc] init];
        StoresVC.WhichChooseString = X6_mykucunTitle;
        [self.navigationController pushViewController:StoresVC animated:YES];
    } else {
        GoodsTypeViewController *goodsTypeVC = [[GoodsTypeViewController alloc] init];
        [self.navigationController pushViewController:goodsTypeVC animated:YES];
    }
}

//搜索
- (void)search
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    UIButton *beginButton = (UIButton *)[_InletAndPinSearchFirstBgView viewWithTag:410100];
    UIButton *endButton = (UIButton *)[_InletAndPinSearchFirstBgView viewWithTag:410101];
    UIButton *goodtypeButton = (UIButton *)[_InletAndPinSearchSecondBgView viewWithTag:410110];
    UIButton *goodButton = (UIButton *)[_InletAndPinSearchSecondBgView viewWithTag:410111];
    if (beginButton.hidden == NO) {
        [BasicControls showAlertWithMsg:@"请选择开始时间" addTarget:nil];
        return;
    } else if (endButton.hidden == NO) {
        [BasicControls showAlertWithMsg:@"请选择结束时间" addTarget:nil];
        return;
    } else if ([goodtypeButton.titleLabel.text isEqualToString:@"请选择商品类型"]){
        [BasicControls showAlertWithMsg:@"请选择商品类型" addTarget:nil];
        return;
    } else if ([goodButton.titleLabel.text isEqualToString:@"请选择商品"]){
        [BasicControls showAlertWithMsg:@"请选择商品" addTarget:nil];
        return;
    }
    [dic setObject:_beginDatePicker.text forKey:@"begindate"];
    [dic setObject:_endDatePicker.text forKey:@"enddate"];
    [dic setObject:_goodid forKey:@"good"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"InletAndPin" object:dic];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
