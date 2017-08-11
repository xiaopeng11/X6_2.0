//
//  RetailTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RetailTableViewCell.h"

@implementation RetailTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        
        _RetailbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 295)];
        _RetailbgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_RetailbgView];
        
        _rkdhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 95, 20)];
        _rkdhLabel.textColor = ExtraTitleColor;
        _rkdhLabel.font = MainFont;
        [_RetailbgView addSubview:_rkdhLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 85, 14, 75, 16)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_RetailbgView addSubview:_dateLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_RetailbgView addSubview:lineView];
        
        for (int i = 0; i < 5; i++) {
            if (i < 2) {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 58 + 30 * i, 20, 20)];
                _label = [[UILabel alloc] initWithFrame:CGRectMake(40, 58 + 30 * i, KScreenWidth - 50, 20)];
                _imageView.tag = 46710 + i;
                _label.tag = 46720 + i;
                _label.font = MainFont;
                [_RetailbgView addSubview:_label];
                [_RetailbgView addSubview:_imageView];
            }
            _messageLabel = [[UILabel alloc] init];
            _nameLabel = [[UILabel alloc] init];
            if (i < 3) {
                _nameLabel.frame = CGRectMake(40, 115 + 25 * i, 40, 16);
                _messageLabel.frame = CGRectMake(80, 115 + 25 * i, KScreenWidth - 90, 16);
            } else if (i == 3) {
                _nameLabel.frame = CGRectMake(40, 115 + 75, 70, 16);
                _messageLabel.frame = CGRectMake(110, 115 + 75, KScreenWidth - 120, 16);
            } else if (i == 4) {
                _nameLabel.frame = CGRectMake(40, 115 + 100, 60, 16);
                _messageLabel.frame = CGRectMake(100, 115 + 100, KScreenWidth - 110, 16);
            }
            _nameLabel.tag = 46730 + i;
            _messageLabel.tag = 46740 + i;
            if (i == 0 || i == 4) {
                _messageLabel.textColor = [UIColor blackColor];
            } else {
                _messageLabel.textColor = PriceColor;
            }
            _messageLabel.font = ExtitleFont;
            _nameLabel.font = ExtitleFont;
            [_RetailbgView addSubview:_nameLabel];
            [_RetailbgView addSubview:_messageLabel];
        }
        UIView *bottomLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 250, KScreenWidth, .5)];
        [_RetailbgView addSubview:bottomLineView];
        
        _ignoreRetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ignoreRetailButton.frame = CGRectMake(KScreenWidth - 80, 250 + 6, 70, 33);
        [_ignoreRetailButton setBackgroundColor:Mycolor];
        [_ignoreRetailButton setTitle:@"忽略" forState:UIControlStateNormal];
        [_ignoreRetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ignoreRetailButton.titleLabel.font = ExtitleFont;
        _ignoreRetailButton.clipsToBounds = YES;
        _ignoreRetailButton.layer.cornerRadius = 4;
        [_ignoreRetailButton addTarget:self action:@selector(ignoreRetail) forControlEvents:UIControlEventTouchUpInside];
        [_RetailbgView addSubview:_ignoreRetailButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _rkdhLabel.text = [NSString stringWithFormat:@"单号:  %@",[_dic valueForKey:@"col1"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
    
    
    for (int i = 0; i < 5; i++) {
        _nameLabel = (UILabel *)[_RetailbgView viewWithTag:46730 + i];
        _messageLabel = (UILabel *)[_RetailbgView viewWithTag:46740 + i];
        if (i < 2) {
            _imageView = (UIImageView *)[_RetailbgView viewWithTag:46710 + i];
            _label = (UILabel *)[_RetailbgView viewWithTag:46720 + i];
            if (i == 0) {
                _imageView.image = [UIImage imageNamed:@"y2_d"];
                _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
            } else {
                _imageView.image = [UIImage imageNamed:@"y2_b"];
                _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col7"]];
            }
        }
        
        if (i == 0) {
            _nameLabel.text = @"串号:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col6"]];
        } else if (i == 1) {
            _nameLabel.text = @"单价:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col8"]];
        } else if (i == 2) {
            _nameLabel.text = @"限价:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col9"]];
        } else if (i == 3) {
            double lowPrice = [[_dic valueForKey:@"col9"] doubleValue] - [[_dic valueForKey:@"col8"] doubleValue];
            _nameLabel.text = @"低于限价:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%.0f",lowPrice];
        } else {
            _nameLabel.text = @"营业员:";
            _messageLabel.text = [_dic valueForKey:@"col4"];
        }
    }

    
}

- (void)ignoreRetail
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ignoreRetailData" object:self.dic];
}
@end
