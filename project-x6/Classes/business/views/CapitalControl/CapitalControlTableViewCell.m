//
//  CapitalControlTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CapitalControlTableViewCell.h"
#define HalfCapitalControlWidth ((KScreenWidth - 20.5) / 2.0)
@implementation CapitalControlTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        
        //背景
        _CapitalControlBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _CapitalControlBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_CapitalControlBgView];
        
        //订单号
        _dhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 110, 20)];
        _dhLabel.font = MainFont;
        _dhLabel.textColor = ExtraTitleColor;
        [_CapitalControlBgView addSubview:_dhLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 90, 20)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_CapitalControlBgView addSubview:_dateLabel];
        
        //间隔
        UIView *firstLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_CapitalControlBgView addSubview:firstLineView];
        
        //公司
        _gstitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _gstitleLabel.font = MainFont;
        [_CapitalControlBgView addSubview:_gstitleLabel];
        
        //公司名
        _gsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _gsLabel.font = MainFont;
        [_CapitalControlBgView addSubview:_gsLabel];
        
        //账户
        _accounttitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _accounttitleLabel.font = MainFont;
        [_CapitalControlBgView addSubview:_accounttitleLabel];
        
        //账户名
        _accountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _accountLabel.font = MainFont;
        [_CapitalControlBgView addSubview:_accountLabel];
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        
        _CapitalControlBgView.frame = [[dic valueForKey:@"frame"] CGRectValue];
        
        _dhLabel.text = [NSString stringWithFormat:@"单号:%@",[dic valueForKey:@"djh"]];
        
        _dateLabel.text = [dic valueForKey:@"fsrq"];
        
        if (![[dic allKeys] containsObject:@"zhname"] || ![[dic allKeys] containsObject:@"zh1name"]) {
            _gstitleLabel.frame = CGRectMake(10, 45 + 6, 40, 21);
            _gstitleLabel.text = @"公司:";
            
            _gsLabel.frame = CGRectMake(50, 45 + 6, KScreenWidth - 77.5, 21);
            _gsLabel.text = [dic valueForKey:@"ssgsname"];
            
            _accounttitleLabel.frame = CGRectMake(10, 45 + 6 + 27, 40, 21);
            _accounttitleLabel.text = @"账户:";
            
            _accountLabel.frame = CGRectMake(50, 45 + 6 + 27, KScreenWidth - 77.5, 21);
            if (![[dic allKeys] containsObject:@"zhname"]) {
                _accountLabel.text = [dic valueForKey:@"zh1name"];
            } else {
                _accountLabel.text = [dic valueForKey:@"zhname"];
            }
            
        } else {
            _gstitleLabel.frame = CGRectMake(10, 45 + 6, 70, 21);
            _gstitleLabel.text = @"调出账户:";
            
            _gsLabel.frame = CGRectMake(80, 45 + 6, KScreenWidth - 107.5, 21);
            _gsLabel.text = [dic valueForKey:@"zhname"];
            
            _accounttitleLabel.frame = CGRectMake(10, 45 + 6 + 27, 70, 21);
            _accounttitleLabel.text = @"调入账户:";
            
            _accountLabel.frame = CGRectMake(80, 45 + 6 + 27, KScreenWidth - 107.5, 21);
            _accountLabel.text = [dic valueForKey:@"zh1name"];
        }
 
        
        _commenttitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 + 60, 40, 21)];
        _commenttitleLabel.text = @"备注:";
        _commenttitleLabel.font = MainFont;
        _commenttitleLabel.textColor = ExtraTitleColor;
        [_CapitalControlBgView addSubview:_commenttitleLabel];
        
        CGRect commentRect = [[dic valueForKey:@"commentframe"] CGRectValue];
        _commentLabel = [[UILabel alloc] initWithFrame:commentRect];
        _commentLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"comments"]];
        _commentLabel.textColor = ExtraTitleColor;
        _commentLabel.font = MainFont;
        [_CapitalControlBgView addSubview:_commentLabel];
        
        float height = commentRect.size.height + 60 + 6;
        _leadView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 17.5, 45 + ((height - 12) / 2.0), 7.5, 15)];
        _leadView.image = [UIImage imageNamed:@"y1_b"];
        [_CapitalControlBgView addSubview:_leadView];

        
        
        for (int i = 0; i < 2; i++) {
            UIView *lowLineview = [BasicControls drawLineWithFrame:CGRectMake(0, _commentLabel.bottom + 5.5 + 45 * i, KScreenWidth, .5)];
            [_CapitalControlBgView addSubview:lowLineview];
            
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = MainFont;
            _textLabel = [[UILabel alloc] init];
            _textLabel.font = MainFont;
            _textLabel.textColor = PriceColor;
            if (i == 0) {
                _titleLabel.frame = CGRectMake(10, _commentLabel.bottom + 5.5 + 12, 40, 21);
                _titleLabel.text = @"金额:";
                _textLabel.frame = CGRectMake(50, _commentLabel.bottom + 5.5 + 12, HalfCapitalControlWidth - 40, 21);
                _textLabel.text = [NSString stringWithFormat:@"￥%@",[dic valueForKey:@"je"]];
            } else {
                _titleLabel.frame = CGRectMake(20 + HalfCapitalControlWidth + .5, _commentLabel.bottom + 5.5 + 12, 60, 21);
                _titleLabel.text = @"经手人:";
                _textLabel.frame = CGRectMake(80 + HalfCapitalControlWidth + .5, _commentLabel.bottom + 5.5 + 12, HalfCapitalControlWidth - 60, 21);
                _textLabel.text = [dic valueForKey:@"jsrname"];
            }
            [_CapitalControlBgView addSubview:_titleLabel];
            [_CapitalControlBgView addSubview:_textLabel];
        }
        
        UIView *halLineview = [BasicControls drawLineWithFrame:CGRectMake(10 + HalfCapitalControlWidth, _commentLabel.bottom + 6, .5, 45)];
        [_CapitalControlBgView addSubview:halLineview];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(KScreenWidth - 80, _commentLabel.bottom + 6 + 45 + 6, 70, 33);
        [_deleteButton setBackgroundColor:[UIColor whiteColor]];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = ExtitleFont;
        _deleteButton.clipsToBounds = YES;
        _deleteButton.layer.cornerRadius = 4;
        _deleteButton.layer.borderWidth = 1;
        _deleteButton.layer.borderColor = ColorRGB(199, 199, 205).CGColor;
        [_deleteButton addTarget:self action:@selector(deleteCapitalControl) forControlEvents:UIControlEventTouchUpInside];
        [_CapitalControlBgView addSubview:_deleteButton];
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)deleteCapitalControl
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCapitalControl" object:self.dic];
}
@end
