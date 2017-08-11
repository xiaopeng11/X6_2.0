//
//  TodayPurchaseTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayPurchaseTableViewCell.h"

@implementation TodayPurchaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = GrayColor;
        
        _todayPurchaseBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 140)];
        _todayPurchaseBgview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_todayPurchaseBgview];

        for (int i = 0 ; i < 2; i++) {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13 + 31 * i, 20, 20)];
            _imageView.tag = 421010 + i;
            [_todayPurchaseBgview addSubview:_imageView];
            
            _label = [[UILabel alloc] initWithFrame:CGRectMake(44, _imageView.top, KScreenWidth - 54, 22)];
            _label.font = MainFont;
            _label.tag = 421020 + i;
            [_todayPurchaseBgview addSubview:_label];
            
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 83 + 28 * i, 40, 18)];
            _titleLabel.font = ExtitleFont;
            _titleLabel.tag = 421030 + i;
            [_todayPurchaseBgview addSubview:_titleLabel];
            
            _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 83 + 28 * i, KScreenWidth - 52, 18)];
            _textLabel.font = ExtitleFont;
            _textLabel.tag = 421040 + i;
            if (i == 1) {
                _textLabel.textColor = PriceColor;
            }
            [_todayPurchaseBgview addSubview:_textLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 2; i++) {
        _imageView = (UIImageView *)[_todayPurchaseBgview viewWithTag:421010 + i];
        _label = (UILabel *)[_todayPurchaseBgview viewWithTag:421020 + i];
        _titleLabel = (UILabel *)[_todayPurchaseBgview viewWithTag:421030 + i];
        _textLabel = (UILabel *)[_todayPurchaseBgview viewWithTag:421040 + i];
        if (i == 0) {
            _imageView.image = [UIImage imageNamed:@"y2_a"];
            _label.text = [self.dic valueForKey:@"col0"];
            _titleLabel.text = @"数量:";
            _textLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col2"]];
        } else {
            _imageView.image = [UIImage imageNamed:@"y2_b"];
            _label.text = [self.dic valueForKey:@"col1"];
            _titleLabel.text = @"金额:";
            _textLabel.text = [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"col3"]];
        }

    }
}
@end
