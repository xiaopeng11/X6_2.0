//
//  PurchaseTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PurchaseTableViewCell.h"

@implementation PurchaseTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;

        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 256)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _rkdhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 95, 20)];
        _rkdhLabel.textColor = ExtraTitleColor;
        _rkdhLabel.font = MainFont;
        [_bgView addSubview:_rkdhLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 85, 14, 75, 16)];
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_bgView addSubview:_dateLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_bgView addSubview:lineView];
        
        for (int i = 0; i < 4; i++) {
            if (i < 2) {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55 + 30 * i, 20, 20)];
                _label = [[UILabel alloc] initWithFrame:CGRectMake(40, 55 + 30 * i, KScreenWidth - 50, 20)];
                _imageView.tag = 46610 + i;
                _label.tag = 46620 + i;
                _label.font = MainFont;
                [_bgView addSubview:_label];
                [_bgView addSubview:_imageView];
            }
            _messageLabel = [[UILabel alloc] init];
            _nameLabel = [[UILabel alloc] init];
            if (i != 3) {
                _nameLabel.frame = CGRectMake(40, 115 + 22 * i, 40, 16);
                _messageLabel.frame = CGRectMake(80, 115 + 22 * i, KScreenWidth - 90, 16);
            } else {
                _nameLabel.frame = CGRectMake(40, 115 + 66, 85, 16);
                _messageLabel.frame = CGRectMake(125, 115 + 66, KScreenWidth - 135, 16);
            }
            _nameLabel.tag = 4660 + i;
            _messageLabel.tag = 4650 + i;
            _messageLabel.textColor = PriceColor;
            _messageLabel.font = ExtitleFont;
            _nameLabel.font = ExtitleFont;
            [_bgView addSubview:_nameLabel];
            [_bgView addSubview:_messageLabel];
        }
        
        UIView *bottomLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 211, KScreenWidth, .5)];
        [_bgView addSubview:bottomLineView];
        
        _ignoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ignoreButton.frame = CGRectMake(KScreenWidth - 80, 211 + 6, 70, 33);
        [_ignoreButton setBackgroundColor:Mycolor];
        [_ignoreButton setTitle:@"忽略" forState:UIControlStateNormal];
        [_ignoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ignoreButton.titleLabel.font = ExtitleFont;
        _ignoreButton.clipsToBounds = YES;
        _ignoreButton.layer.cornerRadius = 4;
        [_ignoreButton addTarget:self action:@selector(ignorePurchase) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_ignoreButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _rkdhLabel.text = [NSString stringWithFormat:@"单号:%@",[_dic valueForKey:@"col1"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
    

    
    double pencet;
    double higherLastPrice = [[_dic valueForKey:@"col8"] doubleValue] - [[_dic valueForKey:@"col6"] doubleValue];
    if (higherLastPrice > 0) {
        pencet =  ((higherLastPrice / [[_dic valueForKey:@"col8"] doubleValue]) * 100);
    } else {
        pencet =  - ((higherLastPrice / [[_dic valueForKey:@"col8"] doubleValue]) * 100);
    }
    
    for (int i = 0; i < 4; i++) {
        _messageLabel = (UILabel *)[_bgView viewWithTag:4650 + i];
        _nameLabel = (UILabel *)[_bgView viewWithTag:4660 + i];
        if (i < 2) {
            _imageView = (UIImageView *)[_bgView viewWithTag:46610 + i];
            _label = (UILabel *)[_bgView viewWithTag:46620 + i];
            if (i == 0) {
                _imageView.image = [UIImage imageNamed:@"y2_a"];
                _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
            } else {
                _imageView.image = [UIImage imageNamed:@"y2_b"];
                _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col4"]];
            }
        }

        if (i == 0) {
            _nameLabel.text = @"数量:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col5"]];
        } else if (i == 1) {
            _nameLabel.text = @"单价:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col6"]];
        } else if (i == 2) {
            _nameLabel.text = @"金额:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col7"]];
        } else if (i == 3) {
            _nameLabel.text = @"高于上次采购:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%.0f％",pencet];
        }
    }
    
}

- (void)ignorePurchase
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ignorePurchaseData" object:self.dic];
}

@end
