//
//  MyacountTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyacountTableViewCell.h"

@implementation MyacountTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 130)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 22, 22)];
        [_bgView addSubview:_imageView];
        
        _bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 14, KScreenWidth - 52, 20)];
        _bankLabel.font = MainFont;
        [_bgView addSubview:_bankLabel];
        
        for (int i = 0; i < 3; i++) {
            _acountNameLabel = [[UILabel alloc] init];
            _myacountLabel = [[UILabel alloc] init];
         
            _acountNameLabel.frame = CGRectMake(42, 49 + 27 * i, 60, 12);
            _myacountLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 49 + 27 * i, KScreenWidth - 102, 12)];
            _acountNameLabel.tag = 4720 + i;
            _myacountLabel.tag = 4710 + i;
            _myacountLabel.font = ExtitleFont;
            _acountNameLabel.font = ExtitleFont;
            _myacountLabel.textColor = PriceColor;
            [_bgView addSubview:_myacountLabel];
            [_bgView addSubview:_acountNameLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.image = [UIImage imageNamed:@"yh_1"];
    
    _bankLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col0"]];
    
    for (int i = 0; i < 3; i++) {
        _myacountLabel = (UILabel *)[self.contentView viewWithTag:4710 + i];
        _acountNameLabel = (UILabel *)[self.contentView viewWithTag:4720 + i];
        if (i == 0) {
            _acountNameLabel.text = @"今日收入:";
            _myacountLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_dic valueForKey:@"col2"] doubleValue]];
        } else if (i == 1) {
            _acountNameLabel.text = @"今日支出:";
            _myacountLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_dic valueForKey:@"col3"] doubleValue]];
        } else if (i == 2) {
            _acountNameLabel.text = @"余       额:";
            _myacountLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_dic valueForKey:@"col4"] doubleValue]];
        }
    }
}
@end
