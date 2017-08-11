//
//  TodayMoneyTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayMoneyTableViewCell.h"
#define HalfScreenWidth ((KScreenWidth - 150) / 2.0)
@implementation TodayMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;
        self.backgroundView = nil;
        for (int i = 0; i < 8; i++) {
            int MyMoneyX = i / 2;
            int MyMoneyY = i % 2;
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (HalfScreenWidth + 70) * MyMoneyY, 13 + 29 * MyMoneyX, 60, 14)];
            _label = [[UILabel alloc] initWithFrame:CGRectMake(70 + (HalfScreenWidth + 70) * MyMoneyY, 13 + 29 * MyMoneyX, HalfScreenWidth, 14)];
            
            _label.tag = 4410 + i;
            _nameLabel.tag = 4420 + i;
            _label.textColor = PriceColor;
            _label.font = ExtitleFont;
            _nameLabel.font = ExtitleFont;
            [self.contentView addSubview:_label];
            [self.contentView addSubview:_nameLabel];
        }
        _lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 124.5, KScreenWidth, .5)];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 8; i++) {
        _label = (UILabel *)[self.contentView viewWithTag:4410 + i];
        _nameLabel = (UILabel *)[self.contentView viewWithTag:4420 + i];
        if (i == 0) {
            _nameLabel.text = @"昨日余额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zrye"]];
        } else if (i == 1) {
            _nameLabel.text = @"现       金:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"xjje"]];
        } else if (i == 2) {
            _nameLabel.text = @"刷       卡:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"skje"]];
        } else if (i == 3) {
            _nameLabel.text = @"抵  价  券:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"djqje"]];
        } else if (i == 4) {
            _nameLabel.text = @"门店费用:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"mdzc"]];
        } else if (i == 5) {
            _nameLabel.text = @"银行打款:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"yhdk"]];
        } else if (i == 6) {
            _nameLabel.text = @"交运营商:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"jyys"]];
        } else if (i == 7) {
            _nameLabel.text = @"今日余额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"jrye"]];
        }
    }
}

@end
