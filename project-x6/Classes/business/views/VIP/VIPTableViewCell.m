//
//  VIPTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VIPTableViewCell.h"
#import "NewOrMoreMessageVIPViewController.h"
#import "MoreVIPMessageViewController.h"
@implementation VIPTableViewCell

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
        
        _VIPbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 202)];
        _VIPbgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_VIPbgView];
        
        _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 40, 21)];
        _companyLabel.font = MainFont;
        [_VIPbgView addSubview:_companyLabel];
        
        
        _moreVipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreVipButton.frame = CGRectMake(KScreenWidth - 90, 12, 80, 21);
        [_moreVipButton addTarget:self action:@selector(moreVIPmesage) forControlEvents:UIControlEventTouchUpInside];
        [_VIPbgView addSubview:_moreVipButton];
        
        UILabel *moreVipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 21)];
        moreVipLabel.text = @"查看详情";
        moreVipLabel.textColor = ExtraTitleColor;
        moreVipLabel.font = ExtitleFont;
        [_moreVipButton addSubview:moreVipLabel];
        
        UIImageView *moreVipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(72.5, 3, 7.5, 15)];
        moreVipImageView.image = [UIImage imageNamed:@"y1_b"];
        [_moreVipButton addSubview:moreVipImageView];
        
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_VIPbgView addSubview:lineView];
        
        for (int i = 0; i < 6; i++) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 52 + 25 * i, 60, 18)];
            _titleLabel.tag = 310010 + i;
            _titleLabel.font = ExtitleFont;
            [self.contentView addSubview:_titleLabel];
            
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 52 + 25 * i, KScreenWidth - 70 - 10, 18)];
            _messageLabel.tag = 310020 + i;
            _messageLabel.font = ExtitleFont;
            if (i == 1) {
                _messageLabel.textColor = Mycolor;
            } else if (i == 3) {
                _messageLabel.textColor = PriceColor;
            } else {
                _messageLabel.textColor = [UIColor blackColor];
            }
            [_VIPbgView addSubview:_titleLabel];
            [_VIPbgView addSubview:_messageLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _companyLabel.text = [_dic valueForKey:@"col1"];
    
    for (int i = 0; i < 6; i++) {
        _titleLabel = [_VIPbgView viewWithTag:310010 + i];
        _messageLabel = [_VIPbgView viewWithTag:310020 + i];
        if (i == 0) {
            _titleLabel.text = @"名      称:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col7"]];
        } else if (i == 1) {
            _titleLabel.text = @"会员类型:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
        } else if (i == 2) {
            _titleLabel.text = @"会员卡号:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
        } else if (i == 3) {
            _titleLabel.text = @"可用积分:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col4"]];
        } else if (i == 4) {
            _titleLabel.text = @"注册日期:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col5"]];
        } else if (i == 5) {
            _titleLabel.text = @"手 机 号:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col6"]];
        }
        
    }
    
}

- (void)moreVIPmesage
{
    NSLog(@"会员详情");
    MoreVIPMessageViewController *MoreMessageVIPVC = [[MoreVIPMessageViewController alloc] init];
    MoreMessageVIPVC.VIPid = [self.dic valueForKey:@"col0"];
    [self.ViewController.navigationController pushViewController:MoreMessageVIPVC animated:YES];
}
@end
