//
//  LotBankAccountDetailViewController.m
//  project-x6
//
//  Created by Apple on 2016/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LotBankAccountDetailViewController.h"

@interface LotBankAccountDetailViewController ()<UITextFieldDelegate>

{
    UIButton *_isAlreadyArrivalButton;
    BOOL _isAlreadyArrival;
}
@end

@implementation LotBankAccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"批量银行到账详情"];
    
    //绘制UI
    [self drawLotBankAccountDetailUI];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(SaveLotBankAccountDetail)];
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
- (void)drawLotBankAccountDetailUI
{
    NSString *comment = [_dic valueForKey:@"comments"];
    float height = 27 * 9 + 6 + 45;
    if (comment.length == 0) {
        height += 21 + 6;
    } else {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 6;
        NSDictionary *attributes = @{NSFontAttributeName:MainFont,NSParagraphStyleAttributeName:paragraphStyle};
        CGSize size = [comment boundingRectWithSize:CGSizeMake(KScreenWidth - 60, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        height += size.height + 6;
    }
    
    
    UIScrollView *LotBankAccountDetailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    LotBankAccountDetailScrollView.backgroundColor = GrayColor;
    LotBankAccountDetailScrollView.contentSize = CGSizeMake(KScreenWidth, 20 + height);
    [self.view addSubview:LotBankAccountDetailScrollView];
    
    UIView *LotBankAccountDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, height)];
    LotBankAccountDetailView.backgroundColor = [UIColor whiteColor];
    [LotBankAccountDetailScrollView addSubview:LotBankAccountDetailView];
    
    NSArray *titles = @[@"单号:",@"日期:",@"类型:",@"门店:",@"POS机:",@"账户:",@"刷卡/打款金额:",@"扣款:",@"应到账金额:",@"备注:"];
    NSMutableArray *texts = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col1"]],
                                                             [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col2"]],
                                                             [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col1"]],
                                                             [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col3"]],
                                                             [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col11"]],
                                                             [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col4"]],
                                                             [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"col5"]],
                                                             [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col1"]],
                                                             [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"col6"]],
                                                             [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col10"]]]];
    //类型
    if ([[self.dic valueForKey:@"col9"] floatValue] == 0) {
        [texts replaceObjectAtIndex:2 withObject:@"刷卡消费"];
    } else {
        [texts replaceObjectAtIndex:2 withObject:@"人工打款"];
    }
    //扣款
    float koukuan = [[self.dic valueForKey:@"col5"] floatValue] - [[self.dic valueForKey:@"col6"] floatValue];
    [texts replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"￥%.2f",koukuan]];

    for (int i = 0; i < titles.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = MainFont;
        if (i == 4) {
            titleLabel.frame = CGRectMake(10, 6 + 27 * i, 60, 21);
        } else if (i == 6) {
            titleLabel.frame = CGRectMake(10, 6 + 27 * i, 110, 21);
        } else if (i == 8) {
            titleLabel.frame = CGRectMake(10, 6 + 27 * i, 90, 21);
        } else {
            titleLabel.frame = CGRectMake(10, 6 + 27 * i, 40, 21);
        }
        titleLabel.text = titles[i];
        if (i == titles.count - 1) {
            titleLabel.textColor = ExtraTitleColor;
        }
        [LotBankAccountDetailView addSubview:titleLabel];
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = MainFont;
        textLabel.text = texts[i];
        [LotBankAccountDetailView addSubview:textLabel];
        if (i < titles.count - 1) {
            textLabel.frame = CGRectMake(titleLabel.right, titleLabel.top, KScreenWidth - 20 - titleLabel.width, 21);
            if (i > 5 && i < 9) {
                textLabel.textColor = PriceColor;
            }
        } else {
            textLabel.textColor = ExtraTitleColor;
            textLabel.height = height - 45 - 6 - 6 - (27 * 9);
        }
    }
    UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, height - 45, KScreenWidth, .5)];
    [LotBankAccountDetailView addSubview:lineView];
    
    UILabel *lastTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, height - 33, 100, 21)];
    lastTitleLable.text = @"是否已到账";
    lastTitleLable.font = MainFont;
    [LotBankAccountDetailView addSubview:lastTitleLable];
    
    _isAlreadyArrival = [[self.dic valueForKey:@"col8"] boolValue];
    _isAlreadyArrivalButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 52, height - 35, 42, 25)];
    [_isAlreadyArrivalButton addTarget:self action:@selector(isAlreadyArrivalOrNot) forControlEvents:UIControlEventTouchUpInside];
    if (_isAlreadyArrival) {
        [_isAlreadyArrivalButton setBackgroundImage:[UIImage imageNamed:@"l6_b"] forState:UIControlStateNormal];
    } else {
        [_isAlreadyArrivalButton setBackgroundImage:[UIImage imageNamed:@"l6_a"] forState:UIControlStateNormal];
    }
    [LotBankAccountDetailView addSubview:_isAlreadyArrivalButton];
    
}

#pragma mark - 保存
- (void)SaveLotBankAccountDetail
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *SaveLotBankAccountURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_SaveLotBankAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.dic valueForKey:@"col0"] forKey:@"id"];
    [params setObject:[self.dic valueForKey:@"col9"] forKey:@"ywlx"];
    if (!_isAlreadyArrival) {
        [params setObject:@(0) forKey:@"shzt"];
        [params setObject:@"0" forKey:@"dzje"];
    } else {
        [params setObject:@(1) forKey:@"shzt"];
        [params setObject:[NSNumber numberWithFloat:[[self.dic valueForKey:@"col6"] floatValue]] forKey:@"dzje"];
    }
    
    NSMutableDictionary *dics = [NSMutableDictionary dictionary];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    [dics setObject:string forKey:@"postdata"];
    
    [XPHTTPRequestTool requestMothedWithPost:SaveLotBankAccountURL params:dics success:^(id responseObject) {
        [BasicControls showNDKNotifyWithMsg:@"保存成功!" WithDuration:1 speed:1];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLotBankAccountData" object:nil];
    } failure:^(NSError *error) {
        [BasicControls showNDKNotifyWithMsg:@"保存失败!" WithDuration:1 speed:1];
    }];
}

#pragma mark - 按钮事件
- (void)isAlreadyArrivalOrNot
{
    if (_isAlreadyArrival) {
        [_isAlreadyArrivalButton setBackgroundImage:[UIImage imageNamed:@"l6_a"] forState:UIControlStateNormal];
        _isAlreadyArrival = NO;
    } else {
        [_isAlreadyArrivalButton setBackgroundImage:[UIImage imageNamed:@"l6_b"] forState:UIControlStateNormal];
        _isAlreadyArrival = YES;
    }
}
@end
