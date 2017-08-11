//
//  BusinessSCDetailTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/10/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BusinessSCDetailTableViewCell.h"

@implementation BusinessSCDetailTableViewCell

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
        
        _BusinessSCDetailbgView = [[UIView alloc] initWithFrame:CGRectZero];
        _BusinessSCDetailbgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_BusinessSCDetailbgView];
        
        //订单号
        _ddhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 110, 20)];
        _ddhLabel.font = MainFont;
        _ddhLabel.textColor = ExtraTitleColor;
        [_BusinessSCDetailbgView addSubview:_ddhLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 90, 20)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_BusinessSCDetailbgView addSubview:_dateLabel];
        
        //分割线
        _lowlineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_BusinessSCDetailbgView addSubview:_lowlineView];
        
        //手机图片
        _phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45 + 11, 23, 21)];
        [_BusinessSCDetailbgView addSubview:_phoneImageView];
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        NSArray *data = [self.dic valueForKey:@"data"];
        _BusinessSCDetailbgView.frame = CGRectMake(0, 10, KScreenWidth, 90 + 45 * data.count);
        
        _ddhLabel.text = [NSString stringWithFormat:@"单号:%@",[self.dic valueForKey:@"djh"]];
        
        _dateLabel.text = [self.dic valueForKey:@"date"];
        
        _phoneImageView.image = [UIImage imageNamed:@"y2_b"];
        
        for (int i = 0; i < data.count; i++) {
            NSDictionary *dic = data[i];
            _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 45 + 12 + 45 * i, KScreenWidth - 100, 21)];
            _phoneLabel.font = MainFont;
            _phoneLabel.text = [dic valueForKey:@"col3"];
            [_BusinessSCDetailbgView addSubview:_phoneLabel];
            
            _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 45 + 12 + 45 * i, 90, 21)];
            _numLabel.font = MainFont;
            _numLabel.textColor = PriceColor;
            _numLabel.textAlignment = NSTextAlignmentRight;
            _numLabel.text = [NSString stringWithFormat:@"%@台",[dic valueForKey:@"col4"]];
            [_BusinessSCDetailbgView addSubview:_numLabel];
        }
        
        _bottomLineView = [BasicControls drawLineWithFrame:CGRectMake(0, (45 + 45 * data.count) - .5, KScreenWidth, .5)];
        [_BusinessSCDetailbgView addSubview:_bottomLineView];
        
        NSString *totallrString = [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"totallr"]];
        NSDictionary *attributes = @{NSFontAttributeName:MainFont};
        CGSize size = [totallrString boundingRectWithSize:CGSizeMake(KScreenWidth - 60, 21) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        _totallrLabeltitle = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - size.width - 50, 45 + 45 * data.count + 12, 40, 21)];
        _totallrLabeltitle.text = @"金额:";
        _totallrLabeltitle.font = MainFont;
        [_BusinessSCDetailbgView addSubview:_totallrLabeltitle];
        
        _totallrLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - size.width - 10, 45 + 45 * data.count + 12, size.width, 21)];
        _totallrLabel.font = MainFont;
        _totallrLabel.textColor = PriceColor;
        _totallrLabel.text = [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"totallr"]];
        [_BusinessSCDetailbgView addSubview:_totallrLabel];
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
