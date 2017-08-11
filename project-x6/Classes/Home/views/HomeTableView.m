//
//  HomeTableView.m
//  project-x6
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HomeTableView.h"
#import "MianDynamicViewController.h"
#import "MyDynamicViewController.h"
#import "SubscribeViewController.h"

#import "HomeTableViewCell.h"
@implementation HomeTableView

{
    NSMutableArray *needloadArray;
    BOOL scrollToToping;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        needloadArray = [NSMutableArray array];
        self.separatorStyle = NO;
        //代理
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datalist.count;
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homecell = @"homecell";
    HomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homecell];
    }
    if (_datalist.count != 0) {
        [self drawCell:cell withIndexPath:indexPath];
    }
    return cell;
}

- (void)drawCell:(HomeTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [_datalist objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell clear];
    cell.data = data;
    if (needloadArray.count > 0 && [needloadArray indexOfObject:indexPath] == NSNotFound) {
        [cell clear];
        return;
    }
    if (scrollToToping) {
        return;
    }
    [cell draw];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _datalist[indexPath.row];
    float height = [dict[@"frame"] CGRectValue].size.height;
    return height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [needloadArray removeAllObjects];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [self.datalist[indexPath.row] mj_keyValues];
    if ([[dic valueForKey:@"msgtype"] integerValue] == 2) {
        SubscribeViewController *SubscribeVC  = [[SubscribeViewController alloc] init];
        SubscribeVC.subscribeType = 1;
        [self.ViewController.navigationController pushViewController:SubscribeVC animated:YES];
    } else if ([[dic valueForKey:@"msgtype"] integerValue] == 3){
        SubscribeViewController *SubscribeVC  = [[SubscribeViewController alloc] init];
        SubscribeVC.subscribeType = 2;
        [self.ViewController.navigationController pushViewController:SubscribeVC animated:YES];
    } else if ([[dic valueForKey:@"msgtype"] integerValue] == 4) {
        SubscribeViewController *SubscribeVC  = [[SubscribeViewController alloc] init];
        SubscribeVC.subscribeType = 3;
        [self.ViewController.navigationController pushViewController:SubscribeVC animated:YES];
    } else {
        MianDynamicViewController *mainVC = [[MianDynamicViewController alloc] init];
        mainVC.dic = dic;
        [self.ViewController.navigationController pushViewController:mainVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isMyDynamic == YES) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"确定删除吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *url = [userDefaults objectForKey:X6_UseUrl];
            NSString *deleteString = [NSString stringWithFormat:@"%@%@",url,X6_deleteMessage];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSNumber *messgeid = [_datalist[indexPath.row] valueForKey:@"id"];
            
            [params setObject:messgeid forKey:@"msgId"];
            [XPHTTPRequestTool requestMothedWithPost:deleteString params:params success:^(id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_datalist removeObjectAtIndex:indexPath.row];

//                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                    [tableView reloadData];
                });
            } failure:^(NSError *error) {
                NSLog(@"删除失败");
                
            }];
        });
    
        
    }];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertcontroller addAction:okaction];
    [alertcontroller addAction:cancelaction];
    [self.ViewController presentViewController:alertcontroller animated:YES completion:nil];
}



//按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSIndexPath *ip = [self indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
    NSIndexPath *cip = [[self indexPathsForVisibleRows] firstObject];
    NSInteger skipCount = 8;
    if (labs(cip.row-ip.row) > skipCount) {
        NSArray *temp = [self indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.width, self.height)];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
        if (velocity.y < 0) {
            NSIndexPath *indexPath = [temp lastObject];
            if (indexPath.row + 3 < _datalist.count) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row + 3 inSection:0]];
            }
        } else {
            NSIndexPath *indexPath = [temp firstObject];
            if (indexPath.row > 3) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row - 3 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row - 2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
            }
        }
        [needloadArray addObjectsFromArray:arr];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    scrollToToping = YES;
    return YES;
}
//scrollview =

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    scrollToToping = NO;
    [self loadContent];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    scrollToToping = NO;
    [self loadContent];
}


//用户触摸时第一时间加载内容
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (!scrollToToping) {
        [needloadArray removeAllObjects];
        [self loadContent];
    }
    return [super hitTest:point withEvent:event];
}

- (void)loadContent{
    if (scrollToToping) {
        return;
    }
    if (self.indexPathsForVisibleRows.count<=0) {
        return;
    }
    if (self.visibleCells&&self.visibleCells.count>0) {
        for (id temp in [self.visibleCells copy]) {
            HomeTableViewCell *cell = (HomeTableViewCell *)temp;
            [cell draw];
        }
    }
}

- (void)removeFromSuperview{
    for (UIView *temp in self.subviews) {
        for (HomeTableViewCell *cell in temp.subviews) {
            if ([cell isKindOfClass:[HomeTableViewCell class]]) {
                [cell releaseMemory];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_datalist removeAllObjects];
    _datalist = nil;
    [self reloadData];
    self.delegate = nil;
    [needloadArray removeAllObjects];
    needloadArray = nil;
    [super removeFromSuperview];
}
@end
