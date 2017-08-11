//
//  AdddepositViewController.m
//  project-x6
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AdddepositViewController.h"

#import "XPDatePicker.h"

#import "StoresViewController.h"
#import "AcountChooseViewController.h"

#import "AcuntAndMoneyTableViewCell.h"
@interface AdddepositViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UIView *_editbgView;
    
    XPDatePicker *_datePicker;
    UILabel *_companyChoose;
    UILabel *_personChoose;
    UITableView *_acountChoose;
    
    NSString *_storeid;    //门店id
    
    NSMutableArray *_acountAndmoneyDatalist;
    NSMutableArray *_acountAndmoneyArray;
}
@end

@implementation AdddepositViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.view = nil;
    _acountAndmoneyArray = nil;
    _acountAndmoneyDatalist = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"新增银行存款"];

    UIButton *saveDepositButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveDepositButton.frame = CGRectMake(0, 0, 40, 16);
    [saveDepositButton setBackgroundColor:Mycolor];
    saveDepositButton.titleLabel.font = RightTitleFont;
    [saveDepositButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveDepositButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveDepositButton addTarget:self action:@selector(uploadsupplier) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbarButton = [[UIBarButtonItem alloc] initWithCustomView:saveDepositButton];
    self.navigationItem.rightBarButtonItem = rightbarButton;
    
    [self initAdddepositUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeChoose:) name:@"storeChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AcountChoose:) name:@"sureAcounts" object:nil];
    
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

#pragma mark - initAdddepositUI
- (void)initAdddepositUI
{

    _editbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 45 * 4 + 44)];
    _editbgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_editbgView];

    
    //标题
    for (int i = 0; i < 4; i++) {
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * i, 60, 30)];
        titlelabel.font = MainFont;
        
        if (i == 0) {
            titlelabel.text = @"日期";
        } else if (i == 1) {
            titlelabel.text = @"门店";
        } else if (i == 2) {
            titlelabel.text = @"经办人";
        } else if (i == 3) {
            titlelabel.text = @"帐户";
        }
        [_editbgView addSubview:titlelabel];

        if (i < 3) {
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [_editbgView addSubview:lineView];
        }
        if (i != 2) {
            UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 17.5, 14.5 + 45 * i, 7.5, 15)];
            leaderView.image = [UIImage imageNamed:@"y1_b"];
            [_editbgView addSubview:leaderView];
        }
    }
    
    //日期选择
    NSString *dateString = [BasicControls TurnTodayDate];;
    _datePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(80, 12, KScreenWidth - 110, 20) Date:dateString];
    _datePicker.delegate = self;
    _datePicker.borderStyle = UITextBorderStyleNone;
    _datePicker.textColor = Mycolor;
    _datePicker.textAlignment = NSTextAlignmentRight;
    _datePicker.font = MainFont;
    [_editbgView addSubview:_datePicker];
    
    //门店选择
    _companyChoose = [[UILabel alloc] initWithFrame:CGRectMake(80, 57, KScreenWidth - 110, 20)];
    _companyChoose.userInteractionEnabled = YES;
    _companyChoose.font = MainFont;
    _companyChoose.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *companyChooseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyChooseTap)];
    [_companyChoose addGestureRecognizer:companyChooseTap];
    [_editbgView addSubview:_companyChoose];
    
    //经办人选择
    _personChoose = [[UILabel alloc] initWithFrame:CGRectMake(80, 102, KScreenWidth - 90, 20)];
    _personChoose.userInteractionEnabled = YES;
    _personChoose.textAlignment = NSTextAlignmentRight;
    _personChoose.font = MainFont;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    NSString *ygName = [userInformation objectForKey:@"name"];
    _personChoose.text = ygName;
    [_editbgView addSubview:_personChoose];
    
    //账号选择
    _acountChoose = [[UITableView alloc] initWithFrame:CGRectMake(80, 135, KScreenWidth - 110, 90) style:UITableViewStylePlain];
    _acountChoose.delegate = self;
    _acountChoose.dataSource = self;
    _acountChoose.backgroundColor = [UIColor clearColor];
    _acountChoose.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _acountChoose.separatorStyle = NO;
    [_editbgView addSubview:_acountChoose];
}

#pragma mark - 上传数据
- (void)uploadsupplier
{
    if (_companyChoose.text.length == 0) {
        [BasicControls showAlertWithMsg:@"门店不能为空" addTarget:nil];
    } else if (_acountAndmoneyDatalist.count == 0 ) {
        [BasicControls showAlertWithMsg:@"帐户金额不能为空" addTarget:nil];
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [userDefaults objectForKey:X6_UseUrl];
        NSString *saveacountAndmoneyURL = [NSString stringWithFormat:@"%@%@",url,X6_savedeposit];
        
        NSDictionary *userMessage = [userDefaults objectForKey:X6_UserMessage];
        NSString *userid = [userMessage valueForKey:@"id"];
        NSString *username = [userMessage valueForKey:@"name"];
        
        NSMutableArray *rows = [NSMutableArray array];
        for (int i = 1; i < _acountAndmoneyArray.count + 1; i++) {
            NSDictionary *dic = _acountAndmoneyArray[i - 1];
            NSMutableDictionary *mutabledic = [NSMutableDictionary dictionary];
            [mutabledic setObject:@"-1" forKey:@"id"];
            [mutabledic setObject:@(i) forKey:@"line"];
            [mutabledic setObject:[dic valueForKey:@"choose"] forKey:@"je"];
            [mutabledic setObject:[dic valueForKey:@"id"] forKey:@"zhid"];
            [mutabledic setObject:[dic valueForKey:@"name"] forKey:@"zhname"];
            [rows addObject:mutabledic];
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"New" forKey:@"djh"];
        [params setObject:_datePicker.text forKey:@"fsrq"];
        [params setObject:_storeid forKey:@"ssgsid"];
        [params setObject:_companyChoose.text forKey:@"ssgsname"];
        [params setObject:userid forKey:@"zdrdm"];
        [params setObject:username forKey:@"zdrmc"];
        [params setObject:@"" forKey:@"zdrq"];
        [params setObject:@"" forKey:@"comments"];
        [params setObject:rows forKey:@"rows"];
        
        [self showProgress];
        [XPHTTPRequestTool reloadMothedWithPost:saveacountAndmoneyURL params:params success:^(id responseObject) {
            [self hideProgress];
            [BasicControls showNDKNotifyWithMsg:@"保存成功" WithDuration:1 speed:1];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self hideProgress];
        }];

    }
}

/**
 *  门店选择
 */
- (void)companyChooseTap
{
    StoresViewController *storeVC = [[StoresViewController alloc] init];
    storeVC.WhichChooseString = X6_storesList;
    [self.navigationController pushViewController:storeVC animated:YES];
}

- (void)storeChoose:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    _companyChoose.text = [dic valueForKey:@"name"];
    _storeid = [dic valueForKey:@"id"];
}

/**
 *  帐户选择
*/
- (void)AcountChoose:(NSNotification *)noti
{
    _acountAndmoneyDatalist = [NSMutableArray array];
    _acountAndmoneyArray = [NSMutableArray array];
    _acountAndmoneyArray = noti.object;
    for (NSDictionary *acountAndmoney in _acountAndmoneyArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[acountAndmoney valueForKey:@"name"] forKey:@"acount"];
        [dic setObject:[acountAndmoney valueForKey:@"choose"] forKey:@"money"];
        [_acountAndmoneyDatalist addObject:dic];
    }
    
    [_acountChoose reloadData];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([[[UIApplication sharedApplication] keyWindow].subviews containsObject:_datePicker.subView]) {
        _datePicker.subView.tag = 0;
        [_datePicker.subView removeFromSuperview];
    }
    if (_datePicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _datePicker.subView.tag=1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_datePicker.subView];
    }
    return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_acountAndmoneyDatalist.count == 0) {
        return 1;
    } else {
        return _acountAndmoneyDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *acountAndmoneyCell = @"acountAndmoneyCell";
    AcuntAndMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:acountAndmoneyCell];
    if (cell == nil) {
        cell = [[AcuntAndMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:acountAndmoneyCell];
        
    }
    if (_acountAndmoneyDatalist.count != 0) {
        cell.dic = _acountAndmoneyDatalist[indexPath.row];
    } else {
        cell.dic = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_acountAndmoneyDatalist.count == 0) {
        //判断是否选择了门店
        if (_companyChoose.text == nil) {
            [BasicControls showAlertWithMsg:@"请先选择门店" addTarget:nil];
        }  else {
            AcountChooseViewController *acountChooseVC = [[AcountChooseViewController alloc] init];
            acountChooseVC.storeID = _storeid;
            [self.navigationController pushViewController:acountChooseVC animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_acountAndmoneyDatalist removeObjectAtIndex:indexPath.row];
    [_acountAndmoneyArray removeObjectAtIndex:indexPath.row];

    [_acountChoose reloadData];
}
@end
