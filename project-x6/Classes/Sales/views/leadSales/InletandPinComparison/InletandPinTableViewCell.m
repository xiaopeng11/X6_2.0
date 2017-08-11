//
//  InletandPinTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InletandPinTableViewCell.h"

@implementation InletandPinTableViewCell

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
        self.backgroundView = nil;
        
        _InletandPinbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 45 + 44.5 * 2)];
        _InletandPinbgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_InletandPinbgView];
        
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10.5, 23, 23)];
        [_InletandPinbgView addSubview:_headerView];
        
        _goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.right + 16, 12, KScreenWidth - 62, 20)];
        _goodNameLabel.font = MainFont;
        [_InletandPinbgView addSubview:_goodNameLabel];
        
        for (int i = 0; i < 4; i++) {
            _titleLabel = [[UILabel alloc] init];
            _messageLabel = [[UILabel alloc] init];
            
            if (i % 2 == 0) {
                _titleLabel.frame = CGRectMake(10, 45 + 12 + (45 * (i / 2)), 60, 20);
                _messageLabel.frame = CGRectMake(70, 45 + 12 + (45 * (i / 2)), ((KScreenWidth - .5) / 2.0) - 70, 20);
            } else {
                _titleLabel.frame = CGRectMake(10 + (KScreenWidth / 2.0), 45 + 12 + (45 * (i / 2)), 40, 20);
                _messageLabel.frame = CGRectMake(50 + (KScreenWidth / 2.0), 45 + 12 + (45 * (i / 2)), ((KScreenWidth - .5) / 2.0) - 50, 20);
            }
            _titleLabel.font = MainFont;
            _messageLabel.font = MainFont;
            _titleLabel.textColor = [UIColor blackColor];
            _messageLabel.textColor = PriceColor;
            _titleLabel.tag = 481100 + i;
            _messageLabel.tag = 481200 + i;
            [_InletandPinbgView addSubview:_titleLabel];
            [_InletandPinbgView addSubview:_messageLabel];
            
            if (i > 0 && i < 3) {
                UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 45 * i, KScreenWidth, .5)];
                [_InletandPinbgView addSubview:lineView];
            }

        }
        
        UIView *middleView = [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - .5) / 2, 45, .5, 89)];
        [_InletandPinbgView addSubview:middleView];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerView.image = [UIImage imageNamed:@"y2_b"];
    
    _goodNameLabel.text = [self.dic valueForKey:@"name"];
    
    for (int i = 0; i < 4; i++) {
        _titleLabel = (UILabel *)[_InletandPinbgView viewWithTag:481100 + i];
        _messageLabel = (UILabel *)[_InletandPinbgView viewWithTag:481200 + i];
        if (i == 0) {
            _titleLabel.text = @"进货量:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"cgsl"]];
        } else if (i == 1) {
            _titleLabel.text = @"金额:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"cgje"]];
        } else if (i == 2) {
            _titleLabel.text = @"销售量:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"xssl"]];
        } else if (i == 3) {
            _titleLabel.text = @"金额:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"xsje"]];
        }
    }
}
@end
