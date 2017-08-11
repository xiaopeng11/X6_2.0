//
//  BusinessSCDetailViewController.m
//  project-x6
//
//  Created by Apple on 2016/10/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BusinessSCDetailViewController.h"
#import "XPDatePicker.h"

#import "StockViewController.h"

#import "BusinessSCDetailModel.h"
#import "BusinessSCDetailTableViewCell.h"
@interface BusinessSCDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    XPDatePicker *_BusinessSCDetaildatepicker;
    NoDataView *_NoBusinessSCDetailView;
    UITableView *_BusinessSCDetailTableView;
    UIView *_totalBusinessSCDetailView;
    UIView *_talkBgView;
    
    NSString *_fsrqDateString;
    NSDictionary *_talkPersonDic;
    NSMutableArray *_datalist;
    NSMutableArray *_BusinessSCDetailDataList;
}
@end

@implementation BusinessSCDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"营业款确认"];
    
    _fsrqDateString = [NSString string];
    _talkPersonDic = [NSDictionary dictionary];
    _BusinessSCDetailDataList = [NSMutableArray array];
    _datalist = [NSMutableArray array];
    
    NSString *dateString = [BasicControls TurnTodayDate];
    
    //绘制UI
    [self drawBusinessSCDetailUI];
    
    if (_dateString.length == 0) {
        //右导航栏按钮
        _BusinessSCDetaildatepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:dateString];
        _BusinessSCDetaildatepicker.delegate = self;
        _BusinessSCDetaildatepicker.labelString = @"选择查询日期:";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_BusinessSCDetaildatepicker];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBusinessSCDetaildate) name:@"changeTodayData" object:nil];
        
        //确认无误按钮失效
        UIButton *BusinessSCButton = (UIButton *)[_totalBusinessSCDetailView viewWithTag:103430];
        [BusinessSCButton setBackgroundColor:GrayColor];
        
    } else {
        //把今天字符串转成今日的日期
        if ([_dateString isEqualToString:@"今天"]) {
            _fsrqDateString = dateString;
        } else {
            _fsrqDateString = _dateString;
        }
    }
    
    [self getBusinessSCDetailData];
    
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    NSDictionary *talkname = [userdefalut objectForKey:X6_TalkPerson];
    if (talkname != nil) {
        _talkPersonDic = talkname;
    }
    
    //聊天UI
    [self drawTalkUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawSonTalkUI:) name:@"businessSCDdic" object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self cancleshowtalkView];
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

#pragma mark - 获取营业款确认详情数据
- (void)getBusinessSCDetailData
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *getBusinessSCDataURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_BusinessSectionConfirmationDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_fsrqDateString forKey:@"fsrq"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:getBusinessSCDataURL params:params success:^(id responseObject) {
        [self hideProgress];
        _datalist = [BusinessSCDetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_datalist.count == 0) {
            _BusinessSCDetailTableView.hidden = YES;
            _totalBusinessSCDetailView.hidden = YES;
            _NoBusinessSCDetailView.hidden = NO;
        } else {
            _NoBusinessSCDetailView.hidden = YES;
            _BusinessSCDetailTableView.hidden = NO;
            _totalBusinessSCDetailView.hidden = NO;
            
            //单据号集合
            NSMutableSet *documentSet = [NSMutableSet set];
            for (NSDictionary *dic in _datalist) {
                [documentSet addObject:[dic valueForKey:@"col0"]];
            }
            NSMutableArray *documents = [[documentSet allObjects] mutableCopy];
            
            for (int i = 0; i < documents.count; i++) {
                NSMutableArray *section = [NSMutableArray array];
                //利润
                float lrsection = 0;
                for (NSDictionary *diced in _datalist) {
                    if ([[diced valueForKey:@"col0"] isEqualToString:documents[i]]) {
                        [section addObject:diced];
                        lrsection += [[diced valueForKey:@"col5"] floatValue];
                    }
                }
                
                //构建数据
                NSMutableDictionary *datadic = [NSMutableDictionary dictionary];
                datadic[@"totallr"] = [NSString stringWithFormat:@"%.2f",lrsection];
                datadic[@"data"] = section;
                datadic[@"height"] = [NSValue valueWithCGRect:CGRectMake(0, 0, KScreenWidth, 100 + section.count * 45)];
                datadic[@"date"] = _fsrqDateString;
                datadic[@"djh"] = documents[i];
                
                [_BusinessSCDetailDataList addObject:datadic];
            }
            
            [_BusinessSCDetailTableView reloadData];
            
            [self jisuanBusinessSCDetailData];

        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取营业款确认详情失败");
        [self hideProgress];
    }];
}

#pragma mark - 绘制营业款确认详情UI
- (void)drawBusinessSCDetailUI
{
    _BusinessSCDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 105) style:UITableViewStylePlain];
    _BusinessSCDetailTableView.delegate = self;
    _BusinessSCDetailTableView.dataSource = self;
    _BusinessSCDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _BusinessSCDetailTableView.backgroundColor = GrayColor;
    _BusinessSCDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _BusinessSCDetailTableView.allowsSelection = NO;
    _BusinessSCDetailTableView.hidden = YES;
    [self.view addSubview:_BusinessSCDetailTableView];
    
    _NoBusinessSCDetailView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _NoBusinessSCDetailView.text = @"您当天没有营业款";
    _NoBusinessSCDetailView.hidden = YES;
    [self.view addSubview:_NoBusinessSCDetailView];
    
    //统计按钮
    _totalBusinessSCDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 124 - 45, KScreenWidth, 60 + 45)];
    _totalBusinessSCDetailView.hidden = YES;
    _totalBusinessSCDetailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totalBusinessSCDetailView];
    
    NSArray *buttons = @[@"确认无误",@"金额不符"];
    for (int i = 0; i < 5; i++) {
        UILabel *Label = [[UILabel alloc] init];
        Label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            Label.font = MainFont;
        } else {
            Label.font = ExtitleFont;
        }
        if (i == 0) {
            Label.frame = CGRectMake(10, 20, 40, 20);
            Label.text = @"合计";
        } else if (i == 1) {
            Label.frame = CGRectMake(40 + totalWidth, 7, totalWidth, 20);
            Label.text = @"数量";
        } else if (i == 2) {
            Label.frame = CGRectMake(40 + totalWidth, 37, totalWidth, 16);
            Label.textColor = PriceColor;
            Label.tag = 134002;
        } else if (i == 3) {
            Label.text = @"金额";
            Label.frame = CGRectMake(40 + totalWidth * 2, 7, totalWidth, 16);
        } else {
            Label.frame = CGRectMake(40 + totalWidth * 2, 37, totalWidth, 16);
            Label.textColor = PriceColor;
            Label.tag = 134004;
        }
        [_totalBusinessSCDetailView addSubview:Label];
        
        
        if (i < 2) {
            UIView *totalViewTopLine = [BasicControls drawLineWithFrame:CGRectMake(0, 60 * i, KScreenWidth, .5)];
            [_totalBusinessSCDetailView addSubview:totalViewTopLine];
            
            UIButton *BusinessSCButton = [UIButton buttonWithType:UIButtonTypeCustom];
            BusinessSCButton.frame = CGRectMake((KScreenWidth - 200) / 3.0 + (((KScreenWidth - 200) / 3.0) + 100) * i, 60 + 7.5, 100, 30);
            [BusinessSCButton setBackgroundColor:Mycolor];
            [BusinessSCButton setTitle:buttons[i] forState:UIControlStateNormal];
            [BusinessSCButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            BusinessSCButton.clipsToBounds = YES;
            BusinessSCButton.layer.cornerRadius = 4;
            BusinessSCButton.tag = 103430 + i;
            [BusinessSCButton addTarget:self action:@selector(BusinessSCButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_totalBusinessSCDetailView addSubview:BusinessSCButton];
        }
    }
    
}

//聊天UI
- (void)drawTalkUI
{
    _talkBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _talkBgView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    _talkBgView.tag = 10;
    
    UITapGestureRecognizer *pickerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleshowtalkView)];
    [_talkBgView addGestureRecognizer:pickerTap];
    
    [self drawSonTalkUI];
}

//聊天子UI
- (void)drawSonTalkUI
{
    UIView *talkView = [[UIView alloc] init];
    talkView.backgroundColor = [UIColor whiteColor];
    talkView.clipsToBounds = YES;
    talkView.layer.cornerRadius = 10;
    [_talkBgView addSubview:talkView];
    
    //选择联系人
    UIButton *choosePerson = [UIButton buttonWithType:UIButtonTypeCustom];
    [choosePerson addTarget:self action:@selector(choosePersonForBusinessSCD) forControlEvents:UIControlEventTouchUpInside];
    choosePerson.titleLabel.font = MainFont;
    [choosePerson setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    if (_talkPersonDic.count == 0) {
        talkView.frame = CGRectMake(0, 40, KScreenWidth - 80, 60 + 45);
        choosePerson.frame = CGRectMake(0, 0, talkView.size.width, 60);
        [choosePerson setTitle:@"选择联系人 >>" forState:UIControlStateNormal];
        
        UIView *firstView = [BasicControls drawLineWithFrame:CGRectMake(0, 59.5, KScreenWidth - 80, .5)];
        [talkView addSubview:firstView];
        
    } else {
        talkView.frame = CGRectMake(0, 40, KScreenWidth - 80, 60 + 45 + 60);
        NSDictionary *attributes = @{NSFontAttributeName:MainFont};
        NSString *titleName = @"发送消息给:";
        NSString *fullName = [NSString stringWithFormat:@"发送消息给:%@",[_talkPersonDic valueForKey:@"name"]];
        CGSize size1 = [titleName boundingRectWithSize:CGSizeMake(KScreenWidth - 100, 25) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        CGSize size = [fullName boundingRectWithSize:CGSizeMake(KScreenWidth - 100, 25) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ((KScreenWidth - 100 - size.width) / 2.0), 17.5, size1.width, 25)];
        titleLabel.text = @"发送消息给:";
        titleLabel.font = MainFont;
        [talkView addSubview:titleLabel];
        
        UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ((KScreenWidth - 100 - size.width) / 2.0) + size1.width, 17.5, size.width - size1.width, 25)];
        personLabel.text = [_talkPersonDic valueForKey:@"name"];
        personLabel.font = MainFont;
        personLabel.textColor = Mycolor;
        [talkView addSubview:personLabel];
        //选择联系人
        choosePerson.frame = CGRectMake(0, 60, talkView.size.width, 60);
        [choosePerson setTitle:@"更改联系人 >>" forState:UIControlStateNormal];
        
        for (int i = 0 ; i < 2; i++) {
            UIView *firstView = [BasicControls drawLineWithFrame:CGRectMake(0, 59.5 + 60 * i, KScreenWidth - 80, .5)];
            [talkView addSubview:firstView];
        }
    }
    [talkView addSubview:choosePerson];
    
    [talkView setCenter:CGPointMake(KScreenWidth / 2.0, (KScreenHeight - 64) / 2.0)];
    
    //取消确定按钮
    UIButton *cancleChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleChoose.frame = CGRectMake(0, talkView.size.height - 45, (KScreenWidth - 80.5) / 2.0, 45);
    [cancleChoose setTitle:@"取消" forState:UIControlStateNormal];
    [cancleChoose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleChoose addTarget:self action:@selector(cancleshowtalkView) forControlEvents:UIControlEventTouchUpInside];
    [talkView addSubview:cancleChoose];
    
    //分割线
    UIView *low =  [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - 80.5) / 2.0, talkView.size.height - 45, .5, 45)];
    [talkView addSubview:low];
    
    //确定按钮
    UIButton *sureChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    sureChoose.backgroundColor = [UIColor clearColor];
    sureChoose.frame = CGRectMake(((KScreenWidth - 80.5) / 2.0) + .5, talkView.size.height - 45, (KScreenWidth - 80.5) / 2.0, 45);
    [sureChoose setTitle:@"确定" forState:UIControlStateNormal];
    [sureChoose setTitleColor:Mycolor forState:UIControlStateNormal];
    [sureChoose addTarget:self action:@selector(sureSentMessage) forControlEvents:UIControlEventTouchUpInside];
    [talkView addSubview:sureChoose];
}

#pragma mark -通知事件
- (void)redrawSonTalkUI:(NSNotification *)noti
{
    _talkPersonDic = noti.object;
    [self drawSonTalkUI];
}

- (void)changeBusinessSCDetaildate
{
    _fsrqDateString = _BusinessSCDetaildatepicker.text;
    [self getBusinessSCDetailData];
}

#pragma mark - 按钮事件
- (void)BusinessSCButtonAction:(UIButton *)button
{
    if (button.tag == 103430) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
        NSString *sureBusinessSCD = [NSString stringWithFormat:@"%@%@",baseURL,X6_BusinessSectionConfirmation];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_fsrqDateString forKey:@"fsrq"];
        [params setObject:@(1) forKey:@"qrbz"];
        [XPHTTPRequestTool requestMothedWithPost:sureBusinessSCD params:params success:^(id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sureBusinessSCViewDate" object:_dateString];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
        }];
    } else {
        //显示发送消息
        if (_talkBgView.tag == 10) {
            _talkBgView.tag = 11;
            [self.view insertSubview:_talkBgView aboveSubview:_totalBusinessSCDetailView];
        }
    }
}

//选择联系人
- (void)choosePersonForBusinessSCD
{
    StockViewController *stockVC = [[StockViewController alloc] init];
    stockVC.type = YES;
    stockVC.BusinessSCDetailType = YES;
    [self.navigationController pushViewController:stockVC animated:YES];
}

//确认发送消息
- (void)sureSentMessage
{
    NSString *phone = [_talkPersonDic valueForKey:@"phone"];
    if (phone.length != 11) {
        [BasicControls showAlertWithMsg:@"该用户未使用即时通讯" addTarget:nil];
    } else {
        [BasicControls resetTalkPersonWithPersonDic:_talkPersonDic];
        //本地服务器设置
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *gsdm = [[userdefault objectForKey:X6_UserMessage] valueForKey:@"gsdm"];
        NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
        NSString *sureBusinessSCD = [NSString stringWithFormat:@"%@%@",baseURL,X6_BusinessSectionConfirmation];
        NSString *easeID = [NSString stringWithFormat:@"%@%@%@",gsdm,[_talkPersonDic valueForKey:@"usertype"],phone];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_fsrqDateString forKey:@"fsrq"];
        [params setObject:@(2) forKey:@"qrbz"];
        [XPHTTPRequestTool requestMothedWithPost:sureBusinessSCD params:params success:^(id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BusinessSCViewDateMoneyDefault" object:_dateString];
            //即时消息
            [EaseSDKHelper sendTextMessage:@"日报数据问题"
                                        to:easeID
                               messageType:eMessageTypeChat
                         requireEncryption:NO
                                messageExt:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSLog(@"shibai ");
        }];

    }
   }

#pragma mark - 发送消息
- (void)setMoneyDefalutMessageAction
{
    UIView *MoneyDefalutMessageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    MoneyDefalutMessageBgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.3];
    [self.view addSubview:MoneyDefalutMessageBgView];
}

#pragma mark - 统计数据
- (void)jisuanBusinessSCDetailData
{
    if (_BusinessSCDetailDataList.count != 0) {
        float totalNum = 0,totalMoney = 0;
        totalNum = [self leijiaNumDataList:_datalist Code:@"col4"];
        totalMoney = [self leijiaNumDataList:_datalist Code:@"col5"];
        UILabel *label1 = (UILabel *)[_totalBusinessSCDetailView viewWithTag:134002];
        UILabel *label2 = (UILabel *)[_totalBusinessSCDetailView viewWithTag:134004];
        label1.text = [NSString stringWithFormat:@"%.0f",totalNum];
        label2.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _BusinessSCDetailDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _BusinessSCDetailDataList[indexPath.row];
    float height = [dict[@"height"] CGRectValue].size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BusinessSCdetailString = @"BusinessSCdetailString";
    BusinessSCDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BusinessSCDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BusinessSCdetailString];
    }
    cell.dic = _BusinessSCDetailDataList[indexPath.row];
    return cell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_BusinessSCDetaildatepicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _BusinessSCDetaildatepicker.subView.tag=1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_BusinessSCDetaildatepicker.subView];
    }
    
    return NO;
}

#pragma mark - 联系试图消失
- (void)cancleshowtalkView
{
    if(_talkBgView != nil){
        _talkBgView.tag = 10;
        [_talkBgView removeFromSuperview];
    }
}

@end
