//
//  MyKucunViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyKucunViewController.h"

#import "XPItemsControlView.h"

#import "KucunTitle.h"
#import "KucunModel.h"
#import "KucunDeatilModel.h"
#import "MykucunDeatilTableViewCell.h"

#import "LibrarybitdistributionViewController.h"

@interface MyKucunViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    XPItemsControlView *_MyKucunitemsControlView;   //眉头试图
    UIScrollView *_MyKucunscrollView;               //首页滑动式图
    NoDataView *_NokucunView;
    UIView *_MykucuntotalView;
    int _index;
}

@property(nonatomic,copy)NSMutableArray *Kucuntitledatalist;                   //库存数据
@property(nonatomic,copy)NSMutableArray *Kucuntitles;

@property(nonatomic,copy)NSMutableArray *Kucundatalist;                 //库存数据
@property(nonatomic,copy)NSMutableDictionary *mykucunDic;               //表示图的数据
@property(nonatomic,copy)NSMutableArray *selectkucunSection;

@property(nonatomic,copy)NSMutableArray *KucunNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *KucunSearchNames;            //数据名搜索后的集合
@property(nonatomic,copy)NSMutableArray *newkucunDatalist;              //新的库存数据
@property(nonatomic, strong)UISearchController *KucunSearchController;  //搜索

@end

@implementation MyKucunViewController

- (void)dealloc
{
    _Kucundatalist = nil;
    _mykucunDic = nil;
    _selectkucunSection = nil;
    _KucunNames = nil;
    _KucunSearchNames = nil;
    _newkucunDatalist = nil;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"我的库存"];
    
    _Kucuntitledatalist = [NSMutableArray array];
    _mykucunDic = [NSMutableDictionary dictionary];
    _Kucuntitles = [NSMutableArray array];
    _Kucundatalist = [NSMutableArray array];
    _selectkucunSection = [NSMutableArray array];
    _KucunNames = [NSMutableArray array];
    _KucunSearchNames = [NSMutableArray array];
    _newkucunDatalist = [NSMutableArray array];
    _index = 0;
    
    //获取库存头数据
    dispatch_group_t maingroup = dispatch_group_create();
    dispatch_group_enter(maingroup);
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucuntitleURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunTitle];
    [XPHTTPRequestTool requestMothedWithPost:mykucuntitleURL params:nil success:^(id responseObject) {
        _Kucuntitledatalist = [KucunTitle mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        NSDictionary *dic = @{@"bm":@"",@"name":@"全部"};
        [_Kucuntitledatalist insertObject:dic atIndex:0];
        _Kucuntitles = [NSMutableArray array];
        for (NSDictionary *dic in _Kucuntitledatalist) {
            [_Kucuntitles addObject:[dic valueForKey:@"name"]];
        }
        dispatch_group_leave(maingroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(maingroup);
    }];
    
    dispatch_group_notify(maingroup, dispatch_get_main_queue(), ^{
        //绘制UI
        [self initKucunUI];
        [self requestkucundata];
    });

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_KucunSearchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_KucunSearchController.searchBar setHidden:YES];
    [_KucunSearchController setActive:NO];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.KucunSearchController.active) {
        return _newkucunDatalist.count;
    } else {
        return _Kucundatalist.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectkucunSection containsObject:string]) {
        return 1;
    } else {
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSMutableDictionary *dic = [_mykucunDic objectForKey:indexStr];
    CGFloat height = [[dic valueForKey:@"rowheight"] floatValue];
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
    
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (self.KucunSearchController.active) {
        view = [self creatTableviewWithMutableArray:_newkucunDatalist Section:section];
    } else {
        view = [self creatTableviewWithMutableArray:[_Kucundatalist mutableCopy] Section:section];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *mykucunIndet = @"mykucunIndet";
    MykucunDeatilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mykucunIndet];
    if (cell == nil) {
        cell = [[MykucunDeatilTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mykucunIndet];
    }
    if ([_selectkucunSection containsObject:indexStr]) {
        NSDictionary *mukucundic = [_mykucunDic objectForKey:indexStr];
        cell.dic = mukucundic;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LibrarybitdistributionViewController *LibrarybitdistributionVC = [[LibrarybitdistributionViewController alloc] init];
    NSDictionary *dic;
    if (self.KucunSearchController.active) {
        dic = _newkucunDatalist[indexPath.row];
    } else {
        dic = _Kucundatalist[indexPath.row];
    }
    LibrarybitdistributionVC.spdm = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col0"]];
    [self.navigationController pushViewController:LibrarybitdistributionVC animated:YES];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.KucunSearchNames removeAllObjects];
    [self.mykucunDic removeAllObjects];
    [self.selectkucunSection removeAllObjects];
    [self.newkucunDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.KucunSearchController.searchBar.text];
    self.KucunSearchNames = [[self.KucunNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.KucunSearchNames) {
        for (NSDictionary *dic in self.Kucundatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_newkucunDatalist addObject:dic];
            }
        }
    }
    [self refreshtableview];
    if (_newkucunDatalist.count != 0) {
        [self jisuanKuncunTotalDataWithDatalist:_newkucunDatalist];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self jisuanKuncunTotalDataWithDatalist:_Kucundatalist];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_MyKucunscrollView]) {
        int offset = scrollView.contentOffset.x / KScreenWidth;
        [_MyKucunitemsControlView moveToIndex:offset];
        if (offset != _index) {
            _index = offset;
            [self getMykucunDataWithTitleString:[_Kucuntitledatalist[offset] valueForKey:@"bm"] Index:offset];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_MyKucunscrollView]) {
        //滑动到指定位置
        int offset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [_MyKucunitemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 23, 21)];
    imageView.image = [UIImage imageNamed:@"y2_b"];
    [view addSubview:imageView];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(43, 12.5, KScreenWidth - 43 - 104, 20)];
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    companyTitle.font = MainFont;
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 24, 17.5, 14, 8)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    selectView.tag = 418940 + section;
    if ([_selectkucunSection containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"jiantou_a"];
    } else {
        selectView.image = [UIImage imageNamed:@"jiantou_b"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 45);
    button.tag = 4100 + section;
    [button addTarget:self action:@selector(leadmykucunSectionData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 24 - 10 - 60, 12.5, 60, 20)];
    Label.text = [NSString stringWithFormat:@"%@台",[mutableArray[section] valueForKey:@"col2"]];
    Label.textAlignment = NSTextAlignmentRight;
    Label.font = MainFont;
    [view addSubview:Label];
    
    UIView *lowLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [view addSubview:lowLineView];
    return view;
}

#pragma mark - 标题栏按钮事件
- (void)leadmykucunSectionData:(UIButton *)button
{
    //获取数据
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 4100];
    NSMutableArray *array;
    if (self.KucunSearchController.active) {
        array = _newkucunDatalist;
    } else {
        array = _Kucundatalist;
    }
    if ([_selectkucunSection containsObject:string]) {
        [_selectkucunSection removeObject:string];
        [_mykucunDic removeObjectForKey:string];
        [self refreshtableview];
    } else {
        dispatch_group_t grouped = dispatch_group_create();
        [_selectkucunSection addObject:string];
 
        [self getkucunDetailWithArray:array Section:string group:grouped];
        dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
            [self refreshtableview];
        });
    }
}

#pragma mark - 绘制我的库存UI
- (void)initKucunUI
{
    NSMutableArray *nodatatitles = [NSMutableArray array];
    for (NSString *title in _Kucuntitles) {
        NSString *nodatatitleName = [NSString stringWithFormat:@"您还没有%@的库存信息",title];
        [nodatatitles addObject:nodatatitleName];
    }
    //scrollview
    _MyKucunscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40 + 44, KScreenWidth, KScreenHeight - 60 - 64 - 40 - 44)];
    _MyKucunscrollView.delegate = self;
    _MyKucunscrollView.pagingEnabled = YES;
    _MyKucunscrollView.showsHorizontalScrollIndicator = NO;
    _MyKucunscrollView.showsVerticalScrollIndicator = NO;
    _MyKucunscrollView.contentSize = CGSizeMake(KScreenWidth * _Kucuntitles.count, KScreenHeight - 60 - 64 - 40 - 44);
    _MyKucunscrollView.bounces = NO;
    for (int i = 0; i < _Kucuntitles.count; i++) {
        UITableView *KucunTableview = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 44 - 40 - 60) style:UITableViewStylePlain];
        KucunTableview.delegate = self;
        KucunTableview.dataSource = self;
        KucunTableview.tag = 41000 + i;
        KucunTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        KucunTableview.backgroundColor = GrayColor;
        KucunTableview.hidden = YES;
        [_MyKucunscrollView addSubview:KucunTableview];
        
        _NokucunView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 64 - 44 - 40 - 60)];
        _NokucunView.text = nodatatitles[i];
        _NokucunView.tag = 41100 + i;
         _NokucunView.hidden = YES;
        [_MyKucunscrollView addSubview:_NokucunView];
        
    }
    [self.view addSubview:_MyKucunscrollView];
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    if (KScreenWidth / _Kucuntitles.count > 57) {
        config.itemWidth = KScreenWidth / _Kucuntitles.count;
    } else {
        config.itemWidth = 57;
    }
    _MyKucunitemsControlView = [[XPItemsControlView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    _MyKucunitemsControlView.tapAnimation = NO;
    _MyKucunitemsControlView.backgroundColor = [UIColor whiteColor];
    _MyKucunitemsControlView.config = config;
    _MyKucunitemsControlView.titleArray = _Kucuntitles;
    
    __weak typeof (_MyKucunscrollView)weakScrollView = _MyKucunscrollView;
    [_MyKucunitemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_MyKucunitemsControlView];
    
    //搜索框
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 44)];
    [self.view addSubview:view];
    _KucunSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _KucunSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _KucunSearchController.searchResultsUpdater = self;
    _KucunSearchController.searchBar.delegate = self;
    _KucunSearchController.dimsBackgroundDuringPresentation = NO;
    _KucunSearchController.hidesNavigationBarDuringPresentation = NO;
    _KucunSearchController.searchBar.placeholder = @"搜索";
    [_KucunSearchController.searchBar sizeToFit];
    [view addSubview:_KucunSearchController.searchBar];
    
    //统计的分割线
    UIView *totalViewTopLine = [BasicControls drawLineWithFrame:CGRectMake(0, KScreenHeight - 124, KScreenWidth, .5)];
    [self.view addSubview:totalViewTopLine];
    
    //统计按钮
    _MykucuntotalView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 123.5, KScreenWidth, 59.5)];
    _MykucuntotalView.hidden = YES;
    _MykucuntotalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_MykucuntotalView];
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
            Label.tag = 413202;
        } else if (i == 3) {
            Label.text = @"金额";
            Label.frame = CGRectMake(40 + totalWidth * 2, 7, totalWidth, 16);
        } else {
            Label.frame = CGRectMake(40 + totalWidth * 2, 37, totalWidth, 16);
            Label.textColor = PriceColor;
            Label.tag = 413204;
        }
        [_MykucuntotalView addSubview:Label];
    }
}

#pragma mark - 获取数据
//根据滑动式图的位置获取数据
- (void)requestkucundata
{
    int index =  _MyKucunscrollView.contentOffset.x / KScreenWidth;
    [self getMykucunDataWithTitleString:[_Kucuntitledatalist[index] valueForKey:@"bm"] Index:index];
}

//获取数据
- (void)getMykucunDataWithTitleString:(NSString *)titleString Index:(int)index
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucun];
    [self showProgress];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:titleString forKey:@"splx"];
    
    //获取表示图
    UITableView *kucunTableView = (UITableView *)[_MyKucunscrollView viewWithTag:41000 + index];
    NoDataView *NokucunView = (NoDataView *)[_MyKucunscrollView viewWithTag:41100 + index];
    [XPHTTPRequestTool requestMothedWithPost:mykucunURL params:params success:^(id responseObject) {
        _Kucundatalist = [KucunModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_Kucundatalist.count == 0) {
            kucunTableView.hidden = YES;
            _MykucuntotalView.hidden = YES;
            NokucunView.hidden = NO;
        } else {
            NokucunView.hidden = YES;
            kucunTableView.hidden = NO;
            _MykucuntotalView.hidden = NO;
            NSArray *sortkucunArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
            [_Kucundatalist sortUsingDescriptors:sortkucunArray];
            
            [kucunTableView reloadData];
            //统计搜索名
           if (_KucunNames.count != 0) {
               [_KucunNames removeAllObjects];
               [_selectkucunSection removeAllObjects];
               [_mykucunDic removeAllObjects];
           }
            for (NSDictionary *dic in _Kucundatalist) {
                [_KucunNames addObject:[dic valueForKey:@"col1"]];
            }
           [self jisuanKuncunTotalDataWithDatalist:_Kucundatalist];
        }
        [self hideProgress];
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}

//详情数据
- (void)getkucunDetailWithArray:(NSMutableArray *)array
                       Section:(NSString *)section
                         group:(dispatch_group_t)group
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSNumber *spdm = [[array objectAtIndex:[section longLongValue]] valueForKey:@"col0"];
    [params setObject:spdm forKey:@"spdm"];
    dispatch_group_enter(group);
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:mykucunDetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        NSMutableDictionary *kucundetailDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"vo"]];
        NSNumber *jine = [[array objectAtIndex:[section longLongValue]] valueForKey:@"col3"];
        NSNumber *numb = [[array objectAtIndex:[section longLongValue]] valueForKey:@"col2"];
        float junjia = [jine floatValue] / [numb floatValue];
        NSString *jineString = [NSString stringWithFormat:@"%.2f",[jine floatValue]];
        NSString *junjiaString = [NSString stringWithFormat:@"%.2f",junjia];
        [kucundetailDic setObject:junjiaString forKey:@"zongjunjia"];
        [kucundetailDic setObject:jineString forKey:@"zongjine"];
        [kucundetailDic setObject:spdm forKey:@"col0"];

        //增加高度参数
        CGFloat rowhight;
        if ([[kucundetailDic valueForKey:@"zgsl"] integerValue] == 0 && [[kucundetailDic valueForKey:@"zdsl"] integerValue] == 0) {
            rowhight = 38;
        } else {
            rowhight = 100;
        }
        [kucundetailDic setObject:@(rowhight) forKey:@"rowheight"];
        
        
        if ([self isqxToexamineorRevokeWithString:@"bb_mykc" Isexamine:@"pcb"]) {
            [kucundetailDic setObject:@"***" forKey:@"zongjunjia"];
            [kucundetailDic setObject:@"***" forKey:@"zgcbdj"];
            [kucundetailDic setObject:@"***" forKey:@"zdcbdj"];
        }

        [_mykucunDic setObject:kucundetailDic forKey:section];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        [self hideProgress];
        dispatch_group_leave(group);

    }];
}


#pragma mark - 统计数据
- (void)jisuanKuncunTotalDataWithDatalist:(NSMutableArray *)datalist
{
    if (datalist.count != 0) {
        float totalNum = 0,totalMoney = 0;
        totalNum = [self leijiaNumDataList:datalist Code:@"col2"];
        totalMoney = [self leijiaNumDataList:datalist Code:@"col3"];
        UILabel *label1 = (UILabel *)[_MykucuntotalView viewWithTag:413202];
        UILabel *label2 = (UILabel *)[_MykucuntotalView viewWithTag:413204];
        label1.text = [NSString stringWithFormat:@"%.0f",totalNum];
        label2.text = [NSString stringWithFormat:@"%.2f",totalMoney];
    }
}

#pragma mark - 刷新表示图
- (void)refreshtableview
{
    UITableView *kucunTableView = (UITableView *)[_MyKucunscrollView viewWithTag:41000 + _index];
    [kucunTableView reloadData];
}

@end
