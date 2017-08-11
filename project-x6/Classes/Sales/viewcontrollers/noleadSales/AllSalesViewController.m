//
//  AllSalesViewController.m
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AllSalesViewController.h"
#import "WJItemsControlView.h"

#import "TodaydetailModel.h"
#import "AllsalesTableViewCell.h"
#define topWidth ((KScreenWidth - 240) / 5.0)
@interface AllSalesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_datalist;       //数据
    NSMutableArray *_salesDatalist;  //销量数据
    NSMutableArray *_moneyDatalist;  //利润数据
    
    UIScrollView *_scrollView;               //滑动式图
    WJItemsControlView *_itemsControlView;   //眉头试图
    NSInteger _index;                        //选择控制器选中位置
    UIView *_bgView;                         //头视图背景
    
    UIView *_line;
    NSInteger _currentIndex;

}
@end

@implementation AllSalesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"我的排名"];
    //绘制UI
    [self initSubView];
    _currentIndex = 0;
    _datalist = [NSMutableArray array];

    //获取数据
    [self getAllSalesDataWithDate:@"zr"];
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

//双滑动式图的实现
- (void)initSubView
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    //查询期限滑动式图
    NSArray *names = @[@"昨天",@"本周",@"本月",@"本季"];
    for (int i = 0; i < names.count; i++) {
        UIButton *topScrollViewButton = [[UIButton alloc] initWithFrame:CGRectMake(topWidth + (60 + topWidth) * i, 0, 60, 38)];
        topScrollViewButton.backgroundColor = [UIColor whiteColor];
        topScrollViewButton.tag = 3310 + i;
        topScrollViewButton.clipsToBounds = YES;
        if (i == 0) {
            [topScrollViewButton setTitleColor:Mycolor forState:UIControlStateNormal];
        } else {
            [topScrollViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        topScrollViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [topScrollViewButton setTitle:names[i] forState:UIControlStateNormal];
        topScrollViewButton.titleLabel.font = MainFont;
        [topScrollViewButton addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:topScrollViewButton];
    }
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(topWidth, 38, 60, 2)];
    _line.backgroundColor = Mycolor;
    [headerView addSubview:_line];
    
    //自己的信息
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, 70)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    UIButton *headView = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    //取出个人数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    //公司代码
    NSString *gsdm = [userInformation objectForKey:@"gsdm"];
    //员工头像地址
    NSString *ygImageUrl = [userdefaults objectForKey:X6_UserHeaderView];
    NSString *info_imageURL = [userInformation objectForKey:@"userpic"];
    //头像
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 25;
    
    NSString *headerURLString = nil;
    NSString *headerpic = [userInformation valueForKey:@"userpic"];
    if (headerpic.length == 0) {
        NSArray *array = HeaderBgColorArray;
        
        int x = arc4random() % 10;
        [headView setBackgroundColor:(UIColor *)array[x]];
        NSString *lastTwoName = userInformation[@"name"];
        lastTwoName = [BasicControls judgeuserHeaderImageNameLenghNameString:lastTwoName];
        [headView setTitle:lastTwoName forState:UIControlStateNormal];
        headView.titleLabel.font = ExtitleFont;
    } else {
        if ([userdefaults objectForKey:X6_UserHeaderView] != nil) {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,ygImageUrl];
        } else {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,info_imageURL];
        }
        NSURL *headerURLed = [NSURL URLWithString:headerURLString];
        if (headerURLString) {
            [headView sd_setBackgroundImageWithURL:headerURLed forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
            [headView setTitle:@"" forState:UIControlStateNormal];
        }
    }
    [_bgView addSubview:headView];


    
    for (int i = 0; i < 4; i++) {
        NSUInteger lon = i / 2;
        NSUInteger won = i % 2;
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + (((KScreenWidth - 80.5) / 2.0) + .5) * won, 9 + 30 * lon, 50, 21)];
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(130 + (((KScreenWidth - 80.5) / 2.0) + .5) * won, 9 + 30 * lon, ((KScreenWidth - 80.5) / 2.0) - 50, 21)];
        numberLabel.font = MainFont;
        headerLabel.font = MainFont;
        numberLabel.tag = 3320 + i;
        if (i == 0) {
            headerLabel.text = @"数量:";
        } else if (i == 1) {
            headerLabel.text = @"利润:";
        } else {
            headerLabel.text = @"排名:";
            numberLabel.textColor = PriceColor;
        }
        [_bgView addSubview:numberLabel];
        [_bgView addSubview:headerLabel];
    }

    //具体数据排名
    NSArray *array = @[@"数量排名",@"利润排名"];
    
    //2页内容的scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 166, KScreenWidth, KScreenHeight - 166 - 64)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(KScreenWidth * array.count, KScreenWidth - 166 - 64);
    _scrollView.bounces = NO;
    for (int i = 0; i < array.count; i++) {
        UITableView *rankTableView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 166 - 64) style:UITableViewStylePlain];
        rankTableView.backgroundColor = GrayColor;
        rankTableView.tag = 7010 + i;
        rankTableView.delegate = self;
        rankTableView.dataSource = self;
        rankTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        rankTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        rankTableView.allowsSelection = NO;
        [_scrollView addSubview:rankTableView];
        
        NoDataView *nosalesView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 166 - 36)];
        nosalesView.hidden = YES;
        nosalesView.tag = 7020 + i;
        nosalesView.text = @"没有纪录";
        [_scrollView addSubview:nosalesView];
    }
    
    [self.view addSubview:_scrollView];
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    config.itemWidth = KScreenWidth / array.count;
    
    _itemsControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, 130, KScreenWidth, 36)];
    _itemsControlView.tapAnimation = NO;
    _itemsControlView.backgroundColor = [UIColor whiteColor];
    _itemsControlView.config = config;
    _itemsControlView.titleArray = array;
    
    __weak typeof (_scrollView)weakScrollView = _scrollView;
    [_itemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
        
    }];
    [self.view addSubview:_itemsControlView];
    
}

#pragma mark - 获取数据
- (void)getAllSalesDataWithDate:(NSString *)date
{
    //获取今天的数据
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *AllSalesURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_noleaderallSales];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"searchType"];
  
    //获取表示图
    UITableView *collectionView;
    NoDataView *nocollectionView;
    if (_scrollView.contentOffset.x == 0) {
        collectionView = (UITableView *)[_scrollView viewWithTag:7010];
        nocollectionView = (NoDataView *)[_scrollView viewWithTag:7020];
    } else {
        collectionView = (UITableView *)[_scrollView viewWithTag:7011];
        nocollectionView = (NoDataView *)[_scrollView viewWithTag:7021];
    }
    
    [XPHTTPRequestTool requestMothedWithPost:AllSalesURL params:params success:^(id responseObject) {
        _datalist = [TodaydetailModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        if (_datalist.count == 0) {
            nocollectionView.hidden = NO;
            collectionView.hidden = YES;
        } else {
            nocollectionView.hidden = YES;
            collectionView.hidden = NO;
            if (_scrollView.contentOffset.x == 0) {
                [self dataordingWithTableViewidenx:0];
            } else {
                [self dataordingWithTableViewidenx:1];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"所有销量获取错去");
        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
    }];
}

#pragma mark - 数据排序
- (void)dataordingWithTableViewidenx:(int)tableViewidenx
{
    UITableView *tableView = (UITableView *)[_scrollView viewWithTag:7010 + tableViewidenx];
    _salesDatalist = [NSMutableArray arrayWithArray:_datalist];
    _moneyDatalist = [NSMutableArray arrayWithArray:_datalist];
    //当该用户的数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    NSString *ygName = [userInformation objectForKey:@"name"];
    
    NSNumber *mysales = @(0);
    NSNumber *myprice = @(0);
    double saleIndex,moneyIndex;
    
    NSMutableArray *nameArray = [NSMutableArray array];
    //获取排序中的名称集合
    for (int i = 0; i < _datalist.count; i++) {
        NSDictionary *dic = _datalist[i];
        [nameArray addObject:[dic valueForKey:@"col1"]];
    }

    UILabel *label0 = (UILabel *)[_bgView viewWithTag:3320];
    UILabel *label1 = (UILabel *)[_bgView viewWithTag:3321];
    UILabel *label2 = (UILabel *)[_bgView viewWithTag:3322];
    UILabel *label3 = (UILabel *)[_bgView viewWithTag:3323];
    
    //销量排名
    [_salesDatalist sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col3" ascending:NO]]];
    //利润排名
    [_moneyDatalist sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col5" ascending:NO]]];
    
    if ([nameArray containsObject:ygName]) {
           //自己的名字在其中
        NSDictionary *mydic = [NSDictionary dictionary];
        for (NSDictionary *dic in _datalist) {
            //自己的销量，利润数据
            if ([ygName isEqualToString:[dic valueForKey:@"col1"]]) {
                mydic = dic;
                mysales = [dic valueForKey:@"col3"];
                myprice = [dic valueForKey:@"col5"];
                break;
            }
        }
        
        saleIndex = [_salesDatalist indexOfObject:mydic];
        moneyIndex = [_moneyDatalist indexOfObject:mydic];

    } else {
        //自己的名字不在其中
        saleIndex = _datalist.count;
        moneyIndex = _datalist.count;
    }
    
    label0.text = [NSString stringWithFormat:@"%@",mysales];
    if ([self isUsercbqx]) {
        label1.text = @"***";
    } else {
        label1.text = [NSString stringWithFormat:@"%@",myprice];
    }
    label2.text = [NSString stringWithFormat:@"第%.0f名",saleIndex + 1];
    label3.text = [NSString stringWithFormat:@"第%.0f名",moneyIndex + 1];
    
    //构建
    NSMutableArray *newarray = [NSMutableArray array];
    if (tableViewidenx == 0) {
       _salesDatalist = [[_salesDatalist subarrayWithRange:NSMakeRange(0, saleIndex)] mutableCopy];
        for (int i = 0; i < _salesDatalist.count; i++) {
            NSDictionary *dic = _salesDatalist[i];
            NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newdic setObject:[NSString stringWithFormat:@"%d",i + 1] forKey:@"index"];
            [newarray addObject:newdic];
        }
        _salesDatalist = newarray;
    } else {
       _moneyDatalist= [[_moneyDatalist subarrayWithRange:NSMakeRange(0, moneyIndex)] mutableCopy];
        for (int i = 0; i < _moneyDatalist.count; i++) {
            NSDictionary *dic = _moneyDatalist[i];
            NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newdic setObject:[NSString stringWithFormat:@"%d",i + 1] forKey:@"index"];
            [newarray addObject:newdic];
        }
        _moneyDatalist = newarray;
    }
    [tableView reloadData];

}


#pragma mark - UIScrollViewDelegate
//滑动判断分段控件位置刷新数据
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        [_itemsControlView moveToIndex:offset];
        [self getdata];

    }
}


//滑动式图的头视图滑倒指定位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        //滑动到指定位置
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        [_itemsControlView endMoveToIndex:offset];
        [self getdata];
    }
}

#pragma mark - 提取方法
- (void)getdata
{
    if (_currentIndex == 0) {
        [self getAllSalesDataWithDate:@"zr"];
    } else if (_currentIndex == 1) {
        [self getAllSalesDataWithDate:@"bz"];
    } else if (_currentIndex == 2){
        [self getAllSalesDataWithDate:@"by"];
    } else {
        [self getAllSalesDataWithDate:@"bj"];
    }
}

#pragma mark - 上部按钮
- (void)topButton:(UIButton *)button
{
    NSInteger buttonTag = button.tag - 3310;
    if (buttonTag != _currentIndex) {
        UIButton *topbutton = [self.view viewWithTag:(3310 + _currentIndex)];
        //按钮颜色
        [topbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:Mycolor forState:UIControlStateNormal];
        //线条位置
        CGRect linerect = _line.frame;
        linerect.origin.x = topWidth + (60 + topWidth) * buttonTag;
        _line.frame = linerect;
        _currentIndex = buttonTag;
        //数据获取
        [self getdata];
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 7010) {
        return _salesDatalist.count;
    } else {
        return _moneyDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allsalecellid = @"allsalecellid";
    AllsalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allsalecellid];
    if (cell == nil) {
        cell = [[AllsalesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allsalecellid];
    }
    if (tableView.tag == 7010) {
        cell.dic = _salesDatalist[indexPath.row];
    } else {
        cell.dic = _moneyDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//利润是否加密
- (BOOL)isUsercbqx
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [userdefault objectForKey:X6_UserMessage];
    BOOL iscbqx = [[userdic valueForKey:@"cbqx"] boolValue];
    return iscbqx;
}

@end
