//
//  SupplierTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SupplierTableViewCell.h"

@implementation SupplierTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        self.backgroundView = nil;
        
        _SupplierBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 105)];
        _SupplierBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_SupplierBgView];

        
        _supplierName = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 40, 21)];
        _supplierName.font = MainFont;
        [_SupplierBgView addSubview:_supplierName];
        
        _moreMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 60, 21)];
        _moreMessageLabel.font = ExtitleFont;
        _moreMessageLabel.textColor = ExtraTitleColor;
        [_SupplierBgView addSubview:_moreMessageLabel];
        
        _leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 40, 16.5, 6, 12)];
        [_SupplierBgView addSubview:_leaderView];

        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_SupplierBgView addSubview:lineView];
        
        
        for (int i = 0 ; i < 2; i++) {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + ((KScreenWidth - 40 - 60) / 2.0 + 30) * i, 45 + 8, 20, 18)];
            _imageView.tag = 3110 + i;
            [self.contentView addSubview:_imageView];
            
            _label = [[UILabel alloc] initWithFrame:CGRectMake(40 + ((KScreenWidth - 40 - 60) / 2.0 + 30) * i, 45 + 9, (KScreenWidth - 40 - 60) / 2.0, 16)];
            _label.tag = 3120 + i;
            _label.font = ExtitleFont;
            _label.textColor = ExtraTitleColor;
            [_SupplierBgView addSubview:_imageView];
            [_SupplierBgView addSubview:_label];
        }
        
        _needPayMoney = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 + 26 + 6, 60, 20)];
        _needPayMoney.font = MainFont;
        [_SupplierBgView addSubview:_needPayMoney];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, _needPayMoney.top, KScreenWidth - 30 - 70, 20)];
        _moneyLabel.font = MainFont;
        _moneyLabel.textColor = PriceColor;
        [_SupplierBgView addSubview:_moneyLabel];
  
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _supplierName.text = [_dic valueForKey:@"name"];
    
    _moreMessageLabel.text = @"查看详情";
    
    _leaderView.image = [UIImage imageNamed:@"y1_b"];
    

    for (int i = 0; i < 2; i++) {
        _imageView = [_SupplierBgView viewWithTag:3110 + i];
        _label = [_SupplierBgView viewWithTag:3120 + i];
        if (i == 0) {
            _imageView.image = [UIImage imageNamed:@"client"];
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"lxr"]];
        } else {
            _imageView.image = [UIImage imageNamed:@"gys_1"];
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"lxhm"]];
        }
        
    }

    if (_issupplier) {
        _needPayMoney.text = @"应付款:",
        _moneyLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"yfje"]];
    } else {
        _needPayMoney.text = @"应收款:";
        _moneyLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"ysje"]];
    }
    
}
@end
