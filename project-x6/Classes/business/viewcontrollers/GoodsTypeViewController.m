//
//  GoodsTypeViewController.m
//  project-x6
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GoodsTypeViewController.h"
#import "StoreModel.h"
#import "StoresTableViewCell.h"
#import "SRSearchBar.h"
@interface GoodsTypeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    SRSearchBar             *searchBar;

    NoDataView *_noGoodsTypeView;
    UITableView *_GoodsTypeTableView;
    NSArray *_GoodsTypesdatalist;
    NSString *_searchKey;
    double _goodtypePage;
    double _goodtypePages;

}


@end

@implementation GoodsTypeViewController

- (void)dealloc
{
    _GoodsTypesdatalist = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self naviTitleWhiteColorWithText:@"商品名称选择"];

    [self initGoodsTypeUI];
    
    [self getGoodsTypeDataWith:1 Name:nil IsSearch:NO];
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
- (void)initGoodsTypeUI
{
    
    UIView *searchBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    searchBgview.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.3];
    [self.view addSubview:searchBgview];
    //搜索框
    searchBar= [[SRSearchBar alloc] initWithFrame:CGRectMake(5, 5, KScreenWidth - 10, 34)];
    searchBar.placeholder = @"搜索";
    searchBar.clearButtonMode = UITextFieldViewModeAlways;
    searchBar.keyboardType = UIKeyboardTypeEmailAddress;
    searchBar.font = MainFont;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    [searchBgview addSubview:searchBar];
    
    
    _GoodsTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _GoodsTypeTableView.delegate = self;
    _GoodsTypeTableView.dataSource = self;
    _GoodsTypeTableView.hidden = YES;
    _GoodsTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _GoodsTypeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //添加上拉加载更多，下拉刷新
    [_GoodsTypeTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(GoodsTypefooterAction)];
    [_GoodsTypeTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(GoodsTypeheaderAction)];
    [self.view addSubview:_GoodsTypeTableView];
    
    _noGoodsTypeView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _noGoodsTypeView.text = @"没有数据";
    _noGoodsTypeView.hidden = YES;
    [self.view addSubview:_noGoodsTypeView];
}

#pragma mark - 获取数据
- (void)getGoodsTypeDataWith:(double)page
                        Name:(NSString *)name
                    IsSearch:(BOOL)isSearch

{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *GoodsTypeURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_GoodsType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(20) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"name" forKey:@"sidx"];
    [params setObject:@"desc" forKey:@"sord"];
    if (name == nil) {
        [params setObject:@"" forKey:@"value"];
    } else {
        [params setObject:name forKey:@"value"];
    }
    [XPHTTPRequestTool requestMothedWithPost:GoodsTypeURL params:params success:^(id responseObject) {
        if (isSearch) {
            _GoodsTypesdatalist = [StoreModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        } else {
            if (_GoodsTypeTableView.header.isRefreshing || _GoodsTypeTableView.footer.isRefreshing) {
                [self endrefreshWithTableView:_GoodsTypeTableView];
            }
        }
        if ([[responseObject valueForKey:@"rows"] count] < 20) {
            [_GoodsTypeTableView.footer noticeNoMoreData];
        }
        _goodtypePage = [responseObject[@"page"] doubleValue];
        _goodtypePages = [responseObject[@"pages"] doubleValue];
        if (_GoodsTypesdatalist.count == 0 || _GoodsTypeTableView.header.isRefreshing) {
            _GoodsTypesdatalist = [StoreModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        } else {
            _GoodsTypesdatalist = [_GoodsTypesdatalist arrayByAddingObjectsFromArray:[StoreModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
        }
        if (_GoodsTypesdatalist.count == 0) {
            _GoodsTypeTableView.hidden = YES;
            _noGoodsTypeView.hidden = NO;
        } else {
            _noGoodsTypeView.hidden = YES;
            _GoodsTypeTableView.hidden = NO;
            [_GoodsTypeTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"银行存款");
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _GoodsTypesdatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storecellID = @"storecellID";
    StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storecellID];
    if (cell == nil) {
        cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storecellID];
        
    }
    cell.dic = _GoodsTypesdatalist[indexPath.row];
    cell.key = @"name";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _GoodsTypesdatalist[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goodTypeChange" object:dic];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchBar resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.hidden == YES) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [searchBar resignFirstResponder];
    _searchKey = textField.text;
    [self getGoodsTypeDataWith:1 Name:_searchKey IsSearch:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getGoodsTypeDataWith:1 Name:nil IsSearch:NO];
}



#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head
{
    if (head == YES) {
        //是下拉刷新
        [self getGoodsTypeDataWith:1 Name:_searchKey IsSearch:NO];
    } else {
        //上拉加载更多
        if (_goodtypePage <= _goodtypePages - 1) {
            [self getGoodsTypeDataWith:_goodtypePage + 1 Name:_searchKey IsSearch:NO];
        } else {
            [_GoodsTypeTableView.footer noticeNoMoreData];
        }
    }
}

#pragma mark - 下拉刷新，上拉加载更多
- (void)GoodsTypefooterAction
{
    [self getrefreshdataWithHead:NO];
}

- (void)GoodsTypeheaderAction
{
    [self getrefreshdataWithHead:YES];
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(UITableView *)hometableview
{
    if (_GoodsTypeTableView.header.isRefreshing) {
        //正在下拉刷新
        [_GoodsTypeTableView.header endRefreshing];
        [_GoodsTypeTableView.footer resetNoMoreData];
    } else {
        [_GoodsTypeTableView.footer endRefreshing];
    }
}

@end
