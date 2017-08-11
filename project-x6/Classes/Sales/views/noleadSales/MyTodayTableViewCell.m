//
//  MyTodayTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyTodayTableViewCell.h"

@implementation MyTodayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //初始化子视图
        for (int i = 0; i < 3; i++) {
            _label = [[UILabel alloc] init];
            if (i == 0) {
                _label.frame = CGRectMake(0, 10, (KScreenWidth / 9) * 5, 25);
            } else if (i == 1) {
                _label.frame = CGRectMake((KScreenWidth / 9) * 5, 10, (KScreenWidth / 9) * 2, 25);
            } else {
                _label.frame = CGRectMake((KScreenWidth / 9) * 7, 10, (KScreenWidth / 9) * 2, 25);
            }
            _label.textAlignment = NSTextAlignmentCenter;
            _label.font = MainFont;
            _label.tag = 900 + i;
            if (i == 2) {
                _label.textColor = PriceColor;
            } else {
                _label.textColor = [UIColor blackColor];
            }
            [self.contentView addSubview:_label];
        }
        
        UIView *lineView= [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 3; i++) {
        _label = (UILabel *)[self.contentView viewWithTag:900 + i];
        if (i == 0) {
            _label.text = [_dic valueForKey:@"col2"];
        } else if (i == 1) {
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
        } else {
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col4"]];
        }
    }
}

@end
