//
//  TodayTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewCell : UITableViewCell

{
    UIButton *_userHeaderButton;        //用户头像
    UILabel *_titleLabel;
    UILabel *_nameLabel;
    UILabel *_label;
    UIView *_lineView;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
