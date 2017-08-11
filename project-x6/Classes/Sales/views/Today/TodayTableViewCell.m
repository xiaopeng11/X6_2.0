//
//  TodayTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayTableViewCell.h"

#define todaywidth ((KScreenWidth - 154) / 3.0)
@implementation TodayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;
        
        _userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userHeaderButton.frame = CGRectMake(24, 13, 30, 30);
        _userHeaderButton.enabled = NO;
        _userHeaderButton.clipsToBounds = YES;
        _userHeaderButton.layer.cornerRadius = 15;
        _userHeaderButton.titleLabel.font = ExtitleFont;
        [self.contentView addSubview:_userHeaderButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 18, KScreenWidth - 74, 20)];
        _titleLabel.font = MainFont;
        [self.contentView addSubview:_titleLabel];
        
        for (int i = 0; i < 3; i++) {
            _nameLabel = [[UILabel alloc] init];
            _label = [[UILabel alloc] init];
            _nameLabel.frame = CGRectMake(24 + (todaywidth + 40) * i, 53, 40, 16);
            _label.frame = CGRectMake(64 + (todaywidth + 40) * i, 53, todaywidth, 16);
        
            _label.font = ExtitleFont;
            _nameLabel.font = ExtitleFont;
            _label.textColor = PriceColor;
            _label.tag = 4210 + i;
            _nameLabel.tag = 4220 + i;
            [self.contentView addSubview:_label];
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
        
       
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    
    //设置属性
    //头像
    //通过usertype判断员工还是营业员
    NSString *headerURLString = nil;
    NSString *headerpic = [_dic valueForKey:@"userpic"];
    if (headerpic.length == 0) {
        NSArray *array = HeaderBgColorArray;
        
        int x = arc4random() % 10;
        [_userHeaderButton setBackgroundColor:(UIColor *)array[x]];
        NSString *lastTwoName = _dic[@"col1"];
        lastTwoName = [BasicControls judgeuserHeaderImageNameLenghNameString:lastTwoName];
        [_userHeaderButton setTitle:lastTwoName forState:UIControlStateNormal];
    } else {
         headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[_dic valueForKey:@"userpic"]];
        NSURL *headerURL = [NSURL URLWithString:headerURLString];
        if (headerURLString) {
            [_userHeaderButton sd_setBackgroundImageWithURL:headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
            [_userHeaderButton setTitle:@"" forState:UIControlStateNormal];
        }
        
    }

    
    _titleLabel.text = [_dic valueForKey:@"col1"];
    
    for (int i = 0; i < 3; i++) {
        _label = (UILabel *)[self.contentView viewWithTag:4210 + i];
        _nameLabel = (UILabel *)[self.contentView viewWithTag:4220 + i];
        if (i == 0) {
            _nameLabel.text = @"数量:";
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
        } else if (i == 1) {
            _nameLabel.text = @"金额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col4"]];
        } else if (i == 2) {
            _nameLabel.text = @"毛利:";
            if ([[_dic allKeys] containsObject:@"col5"]) {
                _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col5"]];
            } else {
                _label.text = [NSString stringWithFormat:@"￥****"];
            }
        }
    }
    
}
@end
