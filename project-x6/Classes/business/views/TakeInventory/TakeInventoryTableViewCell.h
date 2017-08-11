//
//  TakeInventoryTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeInventoryTableViewCell : UITableViewCell

{
    UIView *_takeInventoryBgView;
    UILabel *_dhLabel;    //单号
    UILabel *_dateLabel;  //日期
    UILabel *_headerLabel;     //内容
    UILabel *_messageLabel;    //内容
    UILabel *_takeRangeLabel;  //盘库范围
    UILabel *_comments;        //摘要
    
    UIButton *_more;           //盘库详情
}

@property(nonatomic,copy)NSDictionary *dic;
@end
