//
//  TxtViewController.m
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TxtViewController.h"
#import "KnowledgeTableViewCell.h"
@interface TxtViewController ()<UISearchResultsUpdating>
@property(nonatomic,strong)UISearchController *TexsearchVC;
@property(nonatomic,strong)UIDocumentInteractionController *docInteractionController;

@property(nonatomic,strong)NSMutableArray *newdatalist;
@property(nonatomic,strong)NSMutableArray *nameArray;

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,strong)NSArray *txtDatalist;


@end

@implementation TxtViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"文档"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.TexsearchVC.searchBar setHidden:NO];
    if (self.TexsearchVC.active) {
        [self.TexsearchVC becomeFirstResponder];
    }
    
    //绘制UI
    [self initSearchView];
    
    [self initTableviewView];
    
    _txtDatalist = [NSArray array];
    [self getknowledgeData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"知识库－文档收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
   // [super viewWillDisappear:animated];
    [self.TexsearchVC.searchBar setHidden:YES];
    if ([self.TexsearchVC.searchBar isFirstResponder]) {
        [self.TexsearchVC.searchBar resignFirstResponder];
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark - UI
//搜索框
- (void)initSearchView
{
    _TexsearchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
    _TexsearchVC.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _TexsearchVC.searchResultsUpdater = self;
    _TexsearchVC.dimsBackgroundDuringPresentation = NO;
    _TexsearchVC.hidesNavigationBarDuringPresentation = NO;
    _TexsearchVC.searchBar.placeholder = @"搜索";
    [_TexsearchVC.searchBar sizeToFit];
    [self.view addSubview:_TexsearchVC.searchBar];
}

//瀑布流视图
- (void)initTableviewView
{

    _picTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _picTableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    _picTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _picTableview.dataSource = self;
    _picTableview.delegate = self;
    _picTableview.hidden = YES;
    _picTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_picTableview];
    
    _notextView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
    _notextView.text = @"您还未上传文件";
    _notextView.hidden = YES;
    [self.view addSubview:_notextView];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.TexsearchVC.active) {
        return _newdatalist.count;
    } else {
        return _datalist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idnet = @"indet";
    KnowledgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idnet];
    if (cell == nil) {
        cell = [[KnowledgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idnet];
        
    }
    if (self.TexsearchVC.active) {
        cell.model = _newdatalist[indexPath.row];
    } else {
        cell.model = _datalist[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //判断本地是否有文件
    FocusModel *model = nil;
    if (self.TexsearchVC.active) {
        model = _newdatalist[indexPath.row];
    } else {
        model = _datalist[indexPath.row];
    }
    NSString *filepath = [DOCSFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.filename]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:filepath]) {
        //添加没有下载／／提示是否下载
        [BasicControls showAlertWithMsg:@"您还没有下载，暂时不能预览" addTarget:nil];
    } else {
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        previewController.delegate = self;
        
        // start previewing the document at the current section index
        previewController.currentPreviewItemIndex = indexPath.row;
        [self.navigationController pushViewController:previewController animated:YES];
    }
    
}


#pragma mark - searchResultsUpdater
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.newdatalist = [NSMutableArray array];
    [self.newdatalist removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.TexsearchVC.searchBar.text];
    NSMutableArray *array;
    NSMutableSet *set = [NSMutableSet set];
    array = [[_nameArray filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    for (FocusModel *model in _datalist) {
        for (NSString *name in array) {
            if ([model.shortname isEqualToString:name]) {
                [set addObject:model];
            }
        }
    }
    self.newdatalist = [[set allObjects] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_picTableview reloadData];
    });
}


#pragma MARK - 创建预览控制器

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}


#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    if (self.TexsearchVC.active) {
        return [self.newdatalist count];
    } else {
        return [self.datalist count];

    }
}



// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    
    NSURL *fileURL = nil;
    FocusModel *model = nil;
    if (self.TexsearchVC.active) {
        model = _newdatalist[idx];
    } else {
        model = _datalist[idx];
    }
    NSString *filepath = [DOCSFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.filename]];
    fileURL = [NSURL fileURLWithPath:filepath];
    return fileURL;
}


#pragma mark - 获取数据
- (void)getknowledgeData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:X6_UseUrl];
    NSString *collectionURL = [NSString stringWithFormat:@"%@%@",url,X6_collectionView];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:collectionURL params:nil success:^(id responseObject) {
        [self hideProgress];
        _txtDatalist = [FocusModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        //处理数据
        [self getPicsAndTxtData];
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}

#pragma mark - 将数据分类
- (void)getPicsAndTxtData
{
    
    NSMutableArray *picdatalist = [NSMutableArray array];
    NSMutableArray *txtdatalist = [NSMutableArray array];
    if (_txtString.length != 0) {
        for (NSDictionary *dic in _txtDatalist) {
            if ([_txtString isEqualToString:[dic valueForKey:@"shortname"]]) {
                [txtdatalist addObject:dic];
            }
        }
    } else {
        for (NSDictionary *dic in _txtDatalist) {
            NSString *shortName = [dic valueForKey:@"shortname"];
            NSArray *newname = [shortName componentsSeparatedByString:@"."];
            if ([newname[1] isEqualToString:@"jpg"] || [newname[1] isEqualToString:@"png"] || [newname[1] isEqualToString:@"JPG"]) {
                [picdatalist addObject:dic];
            } else {
                [txtdatalist addObject:dic];
            }
        }
    }
    _datalist = [NSMutableArray array];
    for (NSDictionary *dic in txtdatalist) {
        FocusModel *model = [FocusModel mj_objectWithKeyValues:dic];
        [_datalist addObject:model];
    }
    
    //处理数据
    _nameArray = [NSMutableArray array];
    NSMutableArray *nameArray;
    nameArray = [FocusModel mj_keyValuesArrayWithObjectArray:_datalist];
    for (NSDictionary *dic in nameArray) {
        [_nameArray addObject:[dic valueForKey:@"shortname"]];
    }
    
    if (_datalist.count == 0) {
        _notextView.hidden = NO;
        _picTableview.hidden = YES;
    } else {
        _notextView.hidden = YES;
        _picTableview.hidden = NO;
        [_picTableview reloadData];
    }
}

@end
