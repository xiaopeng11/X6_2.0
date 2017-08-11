//
//  DepositTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DepositTableViewCell.h"

@implementation DepositTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;
        
        _depositViewBg = [[UIView alloc] initWithFrame:CGRectZero];
        _depositViewBg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_depositViewBg];
        
        //订单号
        _danhaoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _danhaoLabel.font = MainFont;
        [_depositViewBg addSubview:_danhaoLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        [_depositViewBg addSubview:_dateLabel];
        
        _LineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_depositViewBg addSubview:_LineView];
        
        
       for (int i = 0; i < 2; i++)
       {
            _headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
            _headerView.tag = 3610 + i;
            [_depositViewBg addSubview:_headerView];
            _messageLabel = [[UILabel alloc] init];
            _messageLabel.frame = CGRectZero;
            _messageLabel.tag = 3630 + i;
            _messageLabel.font = MainFont;
            [_depositViewBg addSubview:_messageLabel];
        }
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        
        NSArray *array = [dic valueForKey:@"rows"];
        _depositViewBg.frame = CGRectMake(0, 10, KScreenWidth, 45 + 116 + array.count * 35);
        
        _danhaoLabel.frame = CGRectMake(10, 12, KScreenWidth - 40 - 130, 20);
        _danhaoLabel.font = MainFont;
        _danhaoLabel.textColor = ExtraTitleColor;

        _dateLabel.frame = CGRectMake(KScreenWidth - 100, 12, 90, 20);
        _dateLabel.textColor = ExtraTitleColor;
        _dateLabel.font = MainFont;
        
        long long totolNum = 0;
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dic = array[i];
            _acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 143 + 35 * i, KScreenWidth - 110 - 10, 20)];
            _acountLabel.font = MainFont;
            _acountLabel.text = [NSString stringWithFormat:@"帐户:%@",[dic valueForKey:@"zhname"]];
            [self.contentView addSubview:_acountLabel];
            _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 110, 143 + 35 * i, 100, 20)];
            _moneyLabel.font = MainFont;
            _moneyLabel.textAlignment = NSTextAlignmentRight;
            _moneyLabel.text = [NSString stringWithFormat:@"￥%@",[dic valueForKey:@"je"]];
            _moneyLabel.textColor = PriceColor;
            [self.contentView addSubview:_moneyLabel];
            totolNum += [[dic valueForKey:@"je"] longLongValue];
        }
        
        _totalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 143 + array.count * 35, 60, 20)];
        _totalTitleLabel.font = MainFont;
        _totalTitleLabel.text = @"总金额:";
        [self.contentView addSubview:_totalTitleLabel];
        
        _totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(70, 143 + array.count * 35, KScreenWidth - 158, 20)];
        _totalMoney.font = MainFont;
        _totalMoney.textColor = PriceColor;
        _totalMoney.text = [NSString stringWithFormat:@"￥%lld",totolNum];
        [self.contentView addSubview:_totalMoney];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.clipsToBounds = YES;
        _deleteButton.layer.cornerRadius = 4;
        _deleteButton.titleLabel.font = MainFont;
        _deleteButton.hidden = YES;
        if (_orderDeposit.length != 0) {
            _deleteButton.frame = CGRectMake(KScreenWidth - 98, _depositViewBg.frame.size.height - 23 - 28, 88, 28);
            if ([_orderDeposit isEqualToString:@"审核"]) {
                [_deleteButton setTitle:@"确认到账" forState:UIControlStateNormal];
            } else {
                [_deleteButton setTitle:@"取消到账" forState:UIControlStateNormal];
            }
        } else {
            _deleteButton.frame = CGRectMake(KScreenWidth - 78, _depositViewBg.frame.size.height - 8 - 28, 68, 28);
            [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        }
        [_deleteButton setBackgroundColor:Mycolor];
        [_deleteButton addTarget:self action:@selector(deletedepostAction) forControlEvents:UIControlEventTouchUpInside];
        [_depositViewBg addSubview:_deleteButton];
        
    }
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"fsrq"]];
    
    _danhaoLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"djh"]];
    
    for (int i = 0; i < 4; i++) {
        _headerView = (UIImageView *)[self.contentView viewWithTag:3610 + i];
        _messageLabel = (UILabel *)[self.contentView viewWithTag:3630 + i];
        
        _headerView.frame = CGRectMake(10, 58 + 35 * i, 20, 20);
        
        _messageLabel.frame = CGRectMake(40, 58 + 35 * i, KScreenWidth - 50, 20);
        if (i == 0) {
            _headerView.image = [UIImage imageNamed:@"y2_d"];
            _messageLabel.text = [NSString stringWithFormat:@"门店:%@",[_dic valueForKey:@"ssgsname"]];
        }  else if (i == 1) {
            _headerView.image = [UIImage imageNamed:@"y2_e"];
            _messageLabel.text = [NSString stringWithFormat:@"经办人:%@",[_dic valueForKey:@"zdrmc"]];
        }
    }
    
    if (_isBusiness || _orderDeposit.length != 0) {
        _deleteButton.hidden = NO;
    }
}

- (void)deletedepostAction
{
    if (_orderDeposit.length != 0) {
        if ([_orderDeposit isEqualToString:@"撤审"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"depositrevokeAction" object:[_dic valueForKey:@"djh"]];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"depositorderAction" object:[_dic valueForKey:@"djh"]];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deletedepostAction" object:[_dic valueForKey:@"djh"]];
    }
}



@end
