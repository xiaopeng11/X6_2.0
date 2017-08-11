//
//  PicsViewController.m
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PicsViewController.h"
#import "PicsTableViewCell.h"
#import "FocusModel.h"

#define picWidth ((KScreenWidth - 124) / 3.0)
@interface PicsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_picsTB;
    NSMutableArray *_sections;       //行数
}
@end

@implementation PicsViewController

- (void)dealloc
{
    SDWebImageManager*manager = [SDWebImageManager sharedManager];
    [manager cancelAll];
    [manager.imageCache clearMemory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"图片"];
    
    [self initPicsTableView];
    
    [self getknowledgeData];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"知识库－照片收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

#pragma mark - UI
//瀑布流视图
- (void)initPicsTableView
{
    _picsTB = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _picsTB.delegate = self;
    _picsTB.dataSource = self;
    _picsTB.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _picsTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_picsTB];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sections.count;
}
#pragma mark - UICollectionViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = _sections[indexPath.row];
    return [[dic valueForKey:@"float"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *picsident = @"picsident";
    PicsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PicsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picsident];
    }
    cell.dic = _sections[indexPath.row];
    return cell;
}

#pragma mark - 获取数据
- (void)getknowledgeData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:X6_UseUrl];
    NSString *collectionURL = [NSString stringWithFormat:@"%@%@",url,X6_collectionView];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:collectionURL params:nil success:^(id responseObject) {
        _datalist = [FocusModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        //处理数据
        [self hideProgress];
        [self getPicsAndTxtData];
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 将数据分类
- (void)getPicsAndTxtData
{
    //剔除数据中不是图片的数据
    NSMutableArray *picdatalist = [NSMutableArray array];
    for (NSDictionary *dic in _datalist) {
        NSString *shortName = [dic valueForKey:@"shortname"];
        NSArray *newname = [shortName componentsSeparatedByString:@"."];
        if ([newname[1] isEqualToString:@"jpg"] || [newname[1] isEqualToString:@"png"] || [newname[1] isEqualToString:@"JPG"]) {
            [picdatalist addObject:dic];
        }
    }
    //时间排序
    NSMutableArray *picsarray = [NSMutableArray array];
    for (int i = 0; i < picdatalist.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_datalist[i]];
        NSString *dateString = [dic valueForKey:@"zdrq"];
        dateString  = [dateString substringToIndex:10];
        [dic setObject:dateString forKey:@"zdrq"];
        [picsarray addObject:dic];
    }
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc]initWithKey:@"zdrq" ascending:NO];
    NSMutableArray *sortDescriptors= [[NSMutableArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortArray = [picsarray sortedArrayUsingDescriptors:sortDescriptors];
    

    //添加排序，点击时确定点击的位置
    NSMutableArray *dateArray = [NSMutableArray array];
    NSMutableSet *dateSet = [NSMutableSet set];
    for (int i = 0; i < sortArray.count; i++) {
        NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:sortArray[i]];
        [diced setObject:@(i) forKey:@"index"];
        [dateArray addObject:diced];
        [dateSet addObject:[diced valueForKey:@"zdrq"]];
    }
    
    _datalist = dateArray;
    
    //日期集合排序
    NSSortDescriptor *sortered = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    NSMutableArray *sortDescriptorsed = [[NSMutableArray alloc] initWithObjects:&sortered count:1];
    NSArray *dateSeted = [dateSet sortedArrayUsingDescriptors:sortDescriptorsed];//最终日期排序
    
    _sections = [NSMutableArray array];
    for (int i = 0; i < dateSeted.count; i++) {
        NSString *date = dateSeted[i];
        NSMutableDictionary *mutdic = [NSMutableDictionary dictionary];
        NSMutableArray *sections = [NSMutableArray array];
        for (NSDictionary *dic in dateArray) {
            if ([[dic valueForKey:@"zdrq"] isEqualToString:date]) {
                [sections addObject:dic];
            }
        }
        CGFloat hight;
        long low = (sections.count + 3) / 3;
        if ((sections.count + 3) % 3 == 0) {
            low -= 1;
        }
        hight = (picWidth * low) + (low * 5) + 20;
        [mutdic setObject:sections forKey:@"data"];
        [mutdic setObject:date forKey:@"date"];
        [mutdic setObject:@(hight) forKey:@"float"];
        [_sections addObject:mutdic];
    }
    [_picsTB reloadData];
}


@end
