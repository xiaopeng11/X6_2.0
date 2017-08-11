//
//  LotBankAccountTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LotBankAccountTableViewCell.h"

@implementation LotBankAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = GrayColor;
        
        
        _LotBankAccountBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45 + 160)];
        _LotBankAccountBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_LotBankAccountBgView];
        
        //订单号
        _dhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 110, 20)];
        _dhLabel.font = MainFont;
        _dhLabel.textColor = ExtraTitleColor;
        [_LotBankAccountBgView addSubview:_dhLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 90, 20)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_LotBankAccountBgView addSubview:_dateLabel];
        
        //间隔
        UIView *lowLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_LotBankAccountBgView addSubview:lowLineView];
        
        for (int i = 0; i < 4; i++) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = MainFont;
            _textLabel = [[UILabel alloc] init];
            _textLabel.font = MainFont;
            if (i == 0) {
                _titleLabel.frame = CGRectMake(10, 45 + 15, 40, 21);
                _textLabel.frame = CGRectMake(50, _titleLabel.top, KScreenWidth - 50 - 27.5, 21);
            } else if (i == 1) {
                _titleLabel.frame = CGRectMake(10, 45 + 15 + 33, 70, 21);
                _textLabel.frame = CGRectMake(80, _titleLabel.top, KScreenWidth - 80 - 27.5, 21);
            } else if (i == 2) {
                _titleLabel.frame = CGRectMake(10, 45 + 15 + 66, 85, 21);
                _textLabel.frame = CGRectMake(95, _titleLabel.top, KScreenWidth - 95 - 27.5, 21);
                _textLabel.textColor = PriceColor;
            } else if (i == 3) {
                _titleLabel.frame = CGRectMake(10, 45 + 15 + 99, 100, 21);
                _textLabel.frame = CGRectMake(110, _titleLabel.top, KScreenWidth - 110 - 27.5, 21);
                _textLabel.textColor = PriceColor;
            }
            _titleLabel.tag = 3421110 + i;
            _textLabel.tag = 3421120 + i;
            [_LotBankAccountBgView addSubview:_titleLabel];
            [_LotBankAccountBgView addSubview:_textLabel];
        }

        //链接
        _leadView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 17.5, 45 + 72.5, 7.5, 15)];
        [_LotBankAccountBgView addSubview:_leadView];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dhLabel.text = [NSString stringWithFormat:@"单号:%@",[self.dic valueForKey:@"col1"]];
    
    _dateLabel.text = [self.dic valueForKey:@"col2"];
    
    for (int i = 0; i < 4; i++) {
        _titleLabel = (UILabel *)[_LotBankAccountBgView viewWithTag:3421110 + i];
        _textLabel = (UILabel *)[_LotBankAccountBgView viewWithTag:3421120 + i];
        if (i == 0) {
            _titleLabel.text = @"门店:";
            _textLabel.text = [self.dic valueForKey:@"col3"];
        } else if (i == 1) {
            _titleLabel.text = @"调入账户:";
            _textLabel.text = [self.dic valueForKey:@"col4"];
        } else if (i == 2) {
            _titleLabel.text = @"应到账金额:";
            _textLabel.text = [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"col6"]];
        } else if (i == 3) {
            _titleLabel.text = @"实际到账金额:";
            _textLabel.text =  [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"col7"]];
        }
    }
    
    _leadView.image = [UIImage imageNamed:@"y1_b"];
}

@end
