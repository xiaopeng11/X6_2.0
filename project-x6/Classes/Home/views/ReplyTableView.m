//
//  ReplyTableView.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ReplyTableView.h"
#import "ReplyTableViewCell.h"

@implementation ReplyTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //背景
        self.backgroundView = nil;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *replyID = @"replyID";
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:replyID];
    if (cell == nil) {
        cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replyID];
    }
    cell.dic = _datalist[indexPath.row];
    cell.faburen = self.fabuName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float hight = 10 + 39 + 15;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [[_datalist[indexPath.row] valueForKey:@"content"] boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    hight += size.height + 15;
    return hight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:indexPath animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *replyTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    replyTableHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5, KScreenWidth - 20, 20)];
    label.font = MainFont;
    label.text = [NSString stringWithFormat:@"评论 (%@)",_replyCount];
    [replyTableHeaderView addSubview:label];
    UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [replyTableHeaderView addSubview:lineView];
    return  replyTableHeaderView;
}
@end
