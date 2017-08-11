//
//  OverdueTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OverdueTableViewCell.h"

@implementation OverdueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
        
        _OverduebgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 151)];
        _OverduebgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_OverduebgView];
        
        _kehuImageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 20, 20)];
        [_OverduebgView addSubview:_kehuImageview];
        
        _kuhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 13, KScreenWidth - 100 - 40, 20)];
        _kuhuLabel.font = MainFont;
        [_OverduebgView addSubview:_kuhuLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 90, 15, 80, 16)];
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_OverduebgView addSubview:_dateLabel];
        
        for (int i = 0; i < 4; i++) {
            _nameLabel = [[UILabel alloc] init];
            _textLabel = [[UILabel alloc] init];
            _nameLabel.tag = 12210 + i;
            _textLabel.tag = 12220 + i;
            _nameLabel.font = ExtitleFont;
            _textLabel.font = ExtitleFont;
            _nameLabel.frame = CGRectMake(40, 48 + 24 * i, 40, 16);
            _textLabel.frame = CGRectMake(80, 48 + 24 * i, KScreenWidth - 90, 16);
            if (i == 1) {
                _textLabel.textColor = Mycolor;
            } else if (i == 2 || i == 3) {
                _textLabel.textColor = PriceColor;
            }
            [_OverduebgView addSubview:_nameLabel];
            [_OverduebgView addSubview:_textLabel];
        }

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _kehuImageview.image = [UIImage imageNamed:@"y2_c"];
    
    _kuhuLabel.text = [_dic valueForKey:@"col4"];
    
    _dateLabel.text = [_dic valueForKey:@"col0"];
    
    for (int i = 0; i < 4; i++) {
        _nameLabel = [_OverduebgView viewWithTag:12210 + i];
        _textLabel = [_OverduebgView viewWithTag:12220 + i];
        if (i == 0) {
            _nameLabel.text = @"单号:";
            _textLabel.text = [_dic valueForKey:@"col1"];
        } else if (i == 1) {
            _nameLabel.text = @"科目:";
            _textLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
        } else if (i == 2) {
            _nameLabel.text = @"金额:";
            _textLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col5"]];
        } else if (i == 3) {
            _nameLabel.text = @"逾期:";
            _textLabel.text = [NSString stringWithFormat:@"%@天",[_dic valueForKey:@"col6"]];
        }
    }

}

@end
