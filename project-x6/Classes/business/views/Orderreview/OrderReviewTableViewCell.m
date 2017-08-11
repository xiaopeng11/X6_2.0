
//
//  OrderReviewTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OrderReviewTableViewCell.h"

#define orderReviewWidthF ((KScreenWidth - 21 - 80) / 2.0)
#define orderReviewWidthS (KScreenWidth - 21 - 130)
@implementation OrderReviewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        
        //背景
        _OrderbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45 + 79 + 90)];
        _OrderbgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_OrderbgView];
        
        //订单号
        _ddhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 110, 20)];
        _ddhLabel.font = MainFont;
        _ddhLabel.textColor = ExtraTitleColor;
        [_OrderbgView addSubview:_ddhLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 90, 20)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_OrderbgView addSubview:_dateLabel];
        
        //间隔
        for (int i = 0; i < 4; i++) {
            if (i == 0) {
                _lowlineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
            } else if (i > 0 && i < 3){
                _lowlineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 79 + 45 * (i - 1), KScreenWidth, .5)];
            } else {
                _lowlineView = [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - .5) / 2.0, 45 + 79, .5, 90)];
            }
            [_OrderbgView addSubview:_lowlineView];
        }
        
        //供应商
        _gysImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 58, 20, 18)];
        [_OrderbgView addSubview:_gysImageView];
        _gysLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 58, KScreenWidth - 88 - 40, 20)];
        _gysLabel.font = MainFont;
        [_OrderbgView addSubview:_gysLabel];
        
        //货品
        _huopiImageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 91, 20, 18)];
        [_OrderbgView addSubview:_huopiImageview];
        _huopinLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 91, KScreenWidth - 88 - 40, 20)];
        _huopinLabel.font = MainFont;
        [_OrderbgView addSubview:_huopinLabel];
        
        //详情
        for (int i = 0; i < 4; i++) {
            int order_X = i / 2;
            int order_Y = i % 2;
            
            if (i == 2) {
                _messageheaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (KScreenWidth / 2.0) * order_Y, 137 + 45 * order_X, 70, 20)];
                _messagebodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + (KScreenWidth / 2.0) * order_Y, 137 + 45 * order_X, (orderReviewWidthS - orderReviewWidthF), 20)];
            } else {
                _messageheaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (KScreenWidth / 2.0) * order_Y, 137 + 45 * order_X, 40, 20)];
                _messagebodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 + (KScreenWidth / 2.0) * order_Y, 137 + 45 * order_X, orderReviewWidthF, 20)];
            }
            _messageheaderLabel.tag = 3310 + i;
            _messagebodyLabel.tag = 3320 + i;
            
            _messageheaderLabel.font = MainFont;
            _messagebodyLabel.font = MainFont;
            
            _messagebodyLabel.textColor = PriceColor;
            [_OrderbgView addSubview:_messageheaderLabel];
            [_OrderbgView addSubview:_messagebodyLabel];  
        }

        _orderButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 77, 45 + 26, 67, 28)];
        [_orderButton setBackgroundColor:Mycolor];
        _orderButton.clipsToBounds = YES;
        _orderButton.layer.cornerRadius = 4;
        _orderButton.titleLabel.font = MainFont;
        [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_OrderbgView addSubview:_orderButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _ddhLabel.text = [NSString stringWithFormat:@"单号:%@",[_dic valueForKey:@"col1"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
    
    _gysLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
    
    _huopinLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col4"]];
    
    if ([[_dic valueForKey:@"isexam"] boolValue] == 1) {
        if (_iswhosalecell) {
            _gysImageView.image = [UIImage imageNamed:@"y2_c"];
        } else {
            _gysImageView.image = [UIImage imageNamed:@"y2_a"];
        }
        _huopiImageview.image = [UIImage imageNamed:@"y2_b"];
        [_orderButton removeTarget:self action:@selector(revokeorderAction) forControlEvents:UIControlEventTouchUpInside];
        [_orderButton addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
        [_orderButton setTitle:@"审核" forState:UIControlStateNormal];
    } else {
        if (_iswhosalecell) {
            _gysImageView.image = [UIImage imageNamed:@"y2_c"];
        } else {
            _gysImageView.image = [UIImage imageNamed:@"y2_a"];
        }
        _huopiImageview.image = [UIImage imageNamed:@"y2_b"];
        [_orderButton removeTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
        [_orderButton addTarget:self action:@selector(revokeorderAction) forControlEvents:UIControlEventTouchUpInside];
        [_orderButton setTitle:@"撤审" forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < 4; i++) {
        _messageheaderLabel = [self.contentView viewWithTag:3310 + i];
        _messagebodyLabel = [self.contentView viewWithTag:3320 + i];
        if (i == 0) {
            _messageheaderLabel.text = @"数量:";
            _messagebodyLabel.text = [NSString stringWithFormat:@"%@台",[_dic valueForKey:@"col5"]];
        } else if (i == 1) {
            _messageheaderLabel.text = @"单价:";
            _messagebodyLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col6"]];
        } else if (i == 2) {
            _messageheaderLabel.text = @"单台返利:";
            _messagebodyLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col7"]];
        } else if (i == 3) {
            _messageheaderLabel.text = @"金额:";
            _messagebodyLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col8"]];
        }
    }
}

- (void)orderAction
{
    if (_iswhosalecell) {
        if ([self.ViewController isqxToexamineorRevokeWithString:@"cz_pfddsh" Isexamine:@"ph"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderAction" object:[_dic valueForKey:@"col0"]];
        } else {
            [BasicControls showAlertWithMsg:@"您没有审核的权限" addTarget:nil];
        }
        return;
    } else {
        if ([self.ViewController isqxToexamineorRevokeWithString:@"cz_cgddsh" Isexamine:@"ph"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderAction" object:[_dic valueForKey:@"col0"]];
        } else {
            [BasicControls showAlertWithMsg:@"您没有审核的权限" addTarget:nil];
        }
        return;
    }
    
}

- (void)revokeorderAction
{
    if (_iswhosalecell) {
        if ([self.ViewController isqxToexamineorRevokeWithString:@"cz_pfddsh" Isexamine:@"pch"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"revokeAction" object:[_dic valueForKey:@"col0"]];
        } else {
            [BasicControls showAlertWithMsg:@"您没有撤审的权限" addTarget:nil];
        }
        return;

    } else {
        if ([self.ViewController isqxToexamineorRevokeWithString:@"cz_cgddsh" Isexamine:@"pch"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"revokeAction" object:[_dic valueForKey:@"col0"]];
        } else {
            [BasicControls showAlertWithMsg:@"您没有撤审的权限" addTarget:nil];
        }
        return;
    }
}

@end
