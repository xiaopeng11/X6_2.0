//
//  TodaySalesTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodaySalesTableViewCell.h"
#define HalfScreenWidth (KScreenWidth / 3.0)
@implementation TodaySalesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;
        
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(37, 30, 23, 23)];
        [self.contentView addSubview:_titleImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31.5, 40, 20)];
        _titleLabel.font = ExtitleFont;
        [self.contentView addSubview:_titleLabel];
        
        for (int i = 0; i < 4; i++) {
            _nameLabel = [[UILabel alloc] init];
            _Label = [[UILabel alloc] init];
            _nameLabel.font = ExtitleFont;
            _Label.font = ExtitleFont;
            _nameLabel.tag = 4320 + i;
            _Label.tag = 4310 + i;
            _Label.textColor = PriceColor;
            if (i == 0) {
                _nameLabel.frame = CGRectMake(HalfScreenWidth, 15, 40, 18);
                _Label.frame = CGRectMake(HalfScreenWidth + 40, 15, HalfScreenWidth - 40, 18);
            } else if (i == 1) {
                _nameLabel.frame = CGRectMake(HalfScreenWidth * 2, 15, 40, 18);
                _Label.frame = CGRectMake(40 + HalfScreenWidth * 2, 15, HalfScreenWidth - 40, 18);
            } else if (i == 2) {
                _nameLabel.frame = CGRectMake(HalfScreenWidth, 49, 40, 18);
                _Label.frame = CGRectMake(HalfScreenWidth + 40, 49, HalfScreenWidth - 40, 18);
            } else {
                _nameLabel.frame = CGRectMake(HalfScreenWidth * 2, 49, 40, 18);
                _Label.frame = CGRectMake(40 + HalfScreenWidth * 2, 49, HalfScreenWidth - 40, 18);
            }
            [self.contentView addSubview:_Label];
            [self.contentView addSubview:_nameLabel];
        }
        
        _lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 82.5, KScreenWidth, .5)];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleImageView.image = [UIImage imageNamed:@"y2_b"];
        
    _titleLabel.text = [_dic valueForKey:@"col0"];
    
    
    for (int i = 0; i < 4; i++) {
        _Label = (UILabel *)[self.contentView viewWithTag:4310 + i];
        _nameLabel = (UILabel *)[self.contentView viewWithTag:4320 + i];
        if (i == 0) {
            _nameLabel.text = @"数量:";
            _Label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col1"]];
        } else if (i == 1) {
            _nameLabel.text = @"金额:";
            _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col2"]];
        } else if (i == 2) {
            _nameLabel.text = @"均毛:";
            if ([[_dic allKeys] containsObject:@"col3"]) {
                long long junmao = [[_dic valueForKey:@"col3"] longLongValue] / [[_dic valueForKey:@"col1"] longLongValue];
                _Label.text = [NSString stringWithFormat:@"￥%lld",junmao];
            } else {
                _Label.text = [NSString stringWithFormat:@"￥****"];
            }
        } else{
            _nameLabel.text = @"毛利:";
            if ([[_dic allKeys] containsObject:@"col3"]) {
                _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col3"]];
            } else {
                _Label.text = [NSString stringWithFormat:@"￥****"];
            }
        }
    }
}
@end
