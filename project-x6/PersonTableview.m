//
//  PersonTableview.m
//  project-x6
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PersonTableview.h"
#import "HomeTableViewCell.h"
#import "HomeModel.h"
#import "MianDynamicViewController.h"
@implementation PersonTableview

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundView = nil;
//        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;

    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_datalist.count == 0) {
        return 5;
    } else {
        return _datalist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *personsCell = @"personsCell";
    HomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personsCell];
    }
    cell.data = _datalist[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _datalist[indexPath.row];
    float height = [dict[@"frame"] CGRectValue].size.height;
    return height;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了%ld",(long)indexPath.row);
    NSDictionary *dic = [self.datalist[indexPath.row] mj_keyValues];
    MianDynamicViewController *mainVC = [[MianDynamicViewController alloc] init];
    mainVC.dic = dic;
    [self.ViewController.navigationController pushViewController:mainVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@的动态:",self.name];
}

@end
