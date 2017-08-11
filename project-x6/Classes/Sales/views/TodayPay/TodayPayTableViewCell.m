//
//  TodayPayTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayPayTableViewCell.h"

@implementation TodayPayTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 22, 20)];
        [_bgView addSubview:_headerView];
        
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 10, KScreenWidth - 52, 20)];
        _headerLabel.font = MainFont;
        [_bgView addSubview:_headerLabel];
        
        for (int i = 0; i < 2; i++) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + (((KScreenWidth - 122) / 2.0) + 40 + 10) * i, 40, 40, 20)];
            _nameLabel.font = ExtitleFont;
            _nameLabel.tag = 42000+ i;
            _label = [[UILabel alloc] initWithFrame:CGRectMake(82 + (((KScreenWidth - 122) / 2.0) + 40 + 10) * i , 40, (KScreenWidth - 122) / 2.0, 20)];
            _label.font = ExtitleFont;
            _label.tag = 42010 + i;
            _label.textColor = PriceColor;
            [_bgView addSubview:_label];
            [_bgView addSubview:_nameLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.source isEqualToString:X6_todayPay]) {
        _headerView.image = [UIImage imageNamed:@"y2_a"];
        _headerLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
    } else {
        _headerView.image = [UIImage imageNamed:@"y2_c"];
        _headerLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
    }
    for (int i = 0; i < 2; i++) {
        _nameLabel = [_bgView viewWithTag:(42000+ i)];
        _label = [_bgView viewWithTag:(42010 + i)];
        if (i == 0) {
            _nameLabel.text = @"帐户:";
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col1"]];
        } else {
            _nameLabel.text = @"金额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col3"]];
        }
    }

    
}
@end
