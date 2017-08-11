/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ContactSelectionViewController.h"
#import "EMRemarkImageView.h"


#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"

@interface ContactSelectionViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *selectedContacts;
@property (strong, nonatomic) NSMutableArray *blockSelectedUsernames;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIScrollView *footerScrollView;
@property (strong, nonatomic) UIButton *doneButton;


@end

@implementation ContactSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _contactsSource = [NSMutableArray array];
        _selectedContacts = [NSMutableArray array];
        
        [self setObjectComparisonStringBlock:^NSString *(id object) {
            NSString *buddy = object;
            return buddy;
        }];
        
        [self setComparisonObjectSelector:^NSComparisonResult(id object1, id object2) {
            NSString *buddy1 = object1;
            NSString *buddy2 = object2;
            
            return [buddy1 caseInsensitiveCompare: buddy2];
        }];
    }
    return self;
}

- (instancetype)initWithBlockSelectedUsernames:(NSArray *)blockUsernames
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _blockSelectedUsernames = [NSMutableArray array];
        [_blockSelectedUsernames addObjectsFromArray:blockUsernames];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 34, 34)];
    [backButton setImage:[UIImage imageNamed:@"g3_a"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.footerView];
    self.tableView.editing = YES;
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height - self.footerView.frame.size.height);
    [self searchController];
    
    if ([_blockSelectedUsernames count] > 0) {
        for (NSString *username in _blockSelectedUsernames) {
            NSInteger section = [self sectionForString:username];
            NSMutableArray *tmpArray = [_dataSource objectAtIndex:section];
            if (tmpArray && [tmpArray count] > 0) {
                for (int i = 0; i < [tmpArray count]; i++) {
                    NSString *buddy = [tmpArray objectAtIndex:i];
                    if ([buddy isEqualToString:username]) {
                        [self.selectedContacts addObject:buddy];
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        
                        break;
                    }
                }
            }
        }
        
        if ([_selectedContacts count] > 0) {
            [self reloadFooterView];
        }
    }
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

#pragma mark - getter

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.editingStyle = UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactSelectionViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }

            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.textLabel.text = buddy;
            cell.username = buddy;
            
            return cell;
        }];
        
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            if ([weakSelf.blockSelectedUsernames count] > 0) {
                NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
                return ![weakSelf isBlockUsername:buddy];
            }
            
            return YES;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if (![weakSelf.selectedContacts containsObject:buddy])
            {
                NSInteger section = [weakSelf sectionForString:buddy];
                if (section >= 0) {
                    NSMutableArray *tmpArray = [weakSelf.dataSource objectAtIndex:section];
                    NSInteger row = [tmpArray indexOfObject:buddy];
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [weakSelf.selectedContacts addObject:buddy];
                [weakSelf reloadFooterView];
            }
        }];
        
        [_searchController setDidDeselectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if ([weakSelf.selectedContacts containsObject:buddy]) {
                NSInteger section = [weakSelf sectionForString:buddy];
                if (section >= 0) {
                    NSMutableArray *tmpArray = [weakSelf.dataSource objectAtIndex:section];
                    NSInteger row = [tmpArray indexOfObject:buddy];
                    [weakSelf.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO];
                }
                
                [weakSelf.selectedContacts removeObject:buddy];
                [weakSelf reloadFooterView];
            }
        }];
    }
    
    return _searchController;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _footerView.backgroundColor = [UIColor colorWithRed:207 / 255.0 green:210 /255.0 blue:213 / 255.0 alpha:0.7];
        
        _footerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 30 - 70, _footerView.frame.size.height - 5)];
        _footerScrollView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:_footerScrollView];
        
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(_footerView.frame.size.width - 80, 8, 70, _footerView.frame.size.height - 16)];
        [_doneButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
        [_doneButton setTitle:NSLocalizedString(@"accept", @"Accept") forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_doneButton setTitle:NSLocalizedString(@"ok", @"OK") forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_doneButton];
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactListCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *buddy = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"iocn-moren-n"];
    cell.textLabel.text = buddy;
    cell.username = buddy;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([_blockSelectedUsernames count] > 0) {
        NSString *buddy = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return ![self isBlockUsername:buddy];
    }
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (![self.selectedContacts containsObject:object])
    {
        [self.selectedContacts addObject:object];
        
        [self reloadFooterView];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *buddy = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([self.selectedContacts containsObject:buddy]) {
        [self.selectedContacts removeObject:buddy];
        
        [self reloadFooterView];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setCancelButtonTitle:NSLocalizedString(@"ok", @"OK")];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
#warning 该处环信的文件筛选基于parse的搜索方法，将方法制空即可
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:searchText collationStringSelector:nil resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
                
                for (NSString *buddy in results) {
                    if ([weakSelf.selectedContacts containsObject:buddy])
                    {
                        NSInteger row = [results indexOfObject:buddy];
                        [weakSelf.searchController.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                }
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.editing = YES;
}

#pragma mark - private

- (BOOL)isBlockUsername:(NSString *)username
{
    if (username && [username length] > 0) {
        if ([_blockSelectedUsernames count] > 0) {
            for (NSString *tmpName in _blockSelectedUsernames) {
                if ([username isEqualToString:tmpName]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (void)reloadFooterView
{
    [self.footerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat imageSize = self.footerScrollView.frame.size.height;
    NSInteger count = [self.selectedContacts count];
    self.footerScrollView.contentSize = CGSizeMake(imageSize * count, imageSize);
    for (int i = 0; i < count; i++) {
        NSString *buddy = [self.selectedContacts objectAtIndex:i];
        EMRemarkImageView *remarkView = [[EMRemarkImageView alloc] initWithFrame:CGRectMake(i * imageSize, 0, imageSize, imageSize)];
        remarkView.image = [UIImage imageNamed:@"pho-moren"];
        remarkView.remark = buddy;
        [self.footerScrollView addSubview:remarkView];
    }
    
    if ([self.selectedContacts count] == 0) {
        [_doneButton setTitle:NSLocalizedString(@"ok", @"OK") forState:UIControlStateNormal];
    }
    else{
        [_doneButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"doneWithCount", @"Done(%i)"), [self.selectedContacts count]] forState:UIControlStateNormal];
    }
}

#pragma mark - public

- (void)loadDataSource
{
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    [_dataSource removeAllObjects];
    [_contactsSource removeAllObjects];
    
#warning 导入联系人数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *contactList = [userdefaults objectForKey:X6_Contactlist];
    for (NSDictionary *dic in contactList) {
        if ([[dic valueForKey:@"hxflag"] integerValue] == 1) {
            [_contactsSource addObject:[dic valueForKey:@"nickname"]];
        }
    }
    
    [_dataSource addObjectsFromArray:[self sortRecords:self.contactsSource]];
    
    [self hideHud];
    [self.tableView reloadData];
}

- (void)doneAction:(id)sender
{
    BOOL isPop = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didFinishSelectedSources:)]) {
        if ([_blockSelectedUsernames count] == 0) {
            isPop = [_delegate viewController:self didFinishSelectedSources:self.selectedContacts];
        } else {
            NSMutableArray *resultArray = [NSMutableArray array];
            for (NSString *buddy in self.selectedContacts) {
                if(![self isBlockUsername:buddy])
                {
                    [resultArray addObject:buddy];
                }
            }
            //将用户昵称传给协议（协议通过昵称判断用户id，成功）
            isPop = [_delegate viewController:self didFinishSelectedSources:resultArray];
        }
    }
    
    if (isPop) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
