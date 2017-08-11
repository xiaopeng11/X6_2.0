//
//  OutboundDetailTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OutboundDetailTableViewCell.h"

@implementation OutboundDetailTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;
        
        
        _outboundDetailbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 172 + 45)];
        _outboundDetailbgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_outboundDetailbgView];
        
        _rkdhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 95, 20)];
        _rkdhLabel.font = MainFont;
        _rkdhLabel.textColor = ExtraTitleColor;
        [_outboundDetailbgView addSubview:_rkdhLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 85, 14, 75, 16)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_outboundDetailbgView addSubview:_dateLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_outboundDetailbgView addSubview:lineView];
        
        for (int i = 0; i < 2; i++) {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55 + 30 * i, 20, 20)];
            _label = [[UILabel alloc] initWithFrame:CGRectMake(40, 55 + 30 * i, KScreenWidth - 50, 20)];
            _imageView.tag = 46610 + i;
            _label.tag = 46620 + i;
            _label.font = MainFont;
            [_outboundDetailbgView addSubview:_label];
            [_outboundDetailbgView addSubview:_imageView];
            
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 115 + 25 * i, 40, 16)];
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 115 + 25 * i, KScreenWidth - 90, 16)];
            _nameLabel.tag = 46630 + i;
            _messageLabel.tag = 46640 + i;
            _nameLabel.font = ExtitleFont;
            _messageLabel.font = ExtitleFont;
            [_outboundDetailbgView addSubview:_nameLabel];
            [_outboundDetailbgView addSubview:_messageLabel];
        }
        
        UIView *bottomLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 172, KScreenWidth, .5)];
        [_outboundDetailbgView addSubview:bottomLineView];
        
        _ignoreOutboundDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ignoreOutboundDetailButton.frame = CGRectMake(KScreenWidth - 80, 172 + 6, 70, 33);
        [_ignoreOutboundDetailButton setBackgroundColor:Mycolor];
        [_ignoreOutboundDetailButton setTitle:@"忽略" forState:UIControlStateNormal];
        [_ignoreOutboundDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ignoreOutboundDetailButton.titleLabel.font = ExtitleFont;
        _ignoreOutboundDetailButton.clipsToBounds = YES;
        _ignoreOutboundDetailButton.layer.cornerRadius = 4;
        [_ignoreOutboundDetailButton addTarget:self action:@selector(ignoreOutboundDetail) forControlEvents:UIControlEventTouchUpInside];
        [_outboundDetailbgView addSubview:_ignoreOutboundDetailButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _rkdhLabel.text = [NSString stringWithFormat:@"单号:%@",[_dic valueForKey:@"col1"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
    
    for (int i = 0; i < 2; i++) {
        _imageView = (UIImageView *)[_outboundDetailbgView viewWithTag:(46610 + i)];
        _label = (UILabel *)[_outboundDetailbgView viewWithTag:(46620 + i)];
        _nameLabel = (UILabel *)[_outboundDetailbgView viewWithTag:(46630 + i)];
        _messageLabel = (UILabel *)[_outboundDetailbgView viewWithTag:(46640 + i)];
        if (i == 0) {
            _imageView.image = [UIImage imageNamed:@"y2_c"];
            _label.text = [_dic valueForKey:@"col4"];
            _nameLabel.text = @"仓库:";
            _messageLabel.text = [_dic valueForKey:@"col3"];
        } else {
            _imageView.image = [UIImage imageNamed:@"y2_b"];
            _label.text = [_dic valueForKey:@"col7"];
            _nameLabel.text = @"串号:";
            _messageLabel.text = [_dic valueForKey:@"col6"];
        }
    }
}

- (void)ignoreOutboundDetail
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ignoreOutboundDetail" object:self.dic];
}

@end
