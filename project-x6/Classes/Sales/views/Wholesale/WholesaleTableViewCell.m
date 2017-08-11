//
//  WholesaleTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "WholesaleTableViewCell.h"
#define HalfScreenWidth ((KScreenWidth - 43 - 90) / 2.0)

@implementation WholesaleTableViewCell

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
        
        _wholesalebg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
        _wholesalebg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_wholesalebg];
        
        _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
        _userHeaderButton.enabled = NO;
        _userHeaderButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_wholesalebg addSubview:_userHeaderButton];
        
        _headerViewbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 32, 32)];
        _headerViewbg.hidden = YES;
        [_wholesalebg addSubview:_headerViewbg];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 13, KScreenWidth - 53, 20)];
        _titleLabel.font = MainFont;
        [_wholesalebg addSubview:_titleLabel];
        
        for (int i = 0; i < 4; i++) {
            _nameLabel = [[UILabel alloc] init];
            _Label = [[UILabel alloc] init];
            _nameLabel.font = ExtitleFont;
            _Label.font = ExtitleFont;
            _Label.textColor = PriceColor;
            _nameLabel.tag = 4320 + i;
            _Label.tag = 4310 + i;
            
            int low = i / 2;
            int wid = i % 2;
            _nameLabel.frame = CGRectMake(43 + HalfScreenWidth * low, 45 + 25 * wid, 40, 16);
            _Label.frame = CGRectMake(83 + HalfScreenWidth * low,  45 + 25 * wid, HalfScreenWidth, 16);
       
            [_wholesalebg addSubview:_Label];
            [_wholesalebg addSubview:_nameLabel];
        }
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.soucre isEqualToString:X6_WholesaleUnits]) {
        _headerViewbg.hidden = NO;
        _headerViewbg.image = [UIImage imageNamed:@"corner_circle"];
        
        
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
        
        for (int i = 0; i < 4; i++) {
            _Label = (UILabel *)[self.contentView viewWithTag:4310 + i];
            _nameLabel = (UILabel *)[self.contentView viewWithTag:4320 + i];
            if (i == 0) {
                _nameLabel.text = @"数量:";
                _Label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
            } else if (i == 1) {
                _nameLabel.text = @"金额:";
                _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col4"]];
            } else if (i == 2) {
                _nameLabel.text = @"均毛:";
                if ([[_dic allKeys] containsObject:@"col5"]) {
                    long long junmao = [[_dic valueForKey:@"col5"] longLongValue] / [[_dic valueForKey:@"col3"] longLongValue];
                    _Label.text = [NSString stringWithFormat:@"￥%lld",junmao];
                } else {
                    _Label.text = [NSString stringWithFormat:@"￥****"];
                }
            } else{
                _nameLabel.text = @"利润:";
                if ([[_dic allKeys] containsObject:@"col5"]) {
                    _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col5"]];
                } else {
                    _Label.text = [NSString stringWithFormat:@"￥****"];
                }
            }
        }
    } else {
        if ([self.soucre isEqualToString:X6_WholesaleSales]) {
            _headerViewbg.hidden = YES;
            [_userHeaderButton setImage:[UIImage imageNamed:@"y2_c"] forState:UIControlStateNormal];;
        } else if ([self.soucre isEqualToString:X6_WholesaleSummary]) {
            _headerViewbg.hidden = YES;
            [_userHeaderButton setImage:[UIImage imageNamed:@"y2_b"] forState:UIControlStateNormal];;
        }
        
        for (int i = 0; i < 4; i++) {
            _Label = (UILabel *)[self.contentView viewWithTag:4310 + i];
            _nameLabel = (UILabel *)[self.contentView viewWithTag:4320 + i];
            if (i == 0) {
                _nameLabel.text = @"数量:";
                _Label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
            } else if (i == 1) {
                _nameLabel.text = @"金额:";
                _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col3"]];
            } else if (i == 2) {
                _nameLabel.text = @"均毛:";
                if ([[_dic allKeys] containsObject:@"col4"]) {
                    long long junmao = [[_dic valueForKey:@"col4"] longLongValue] / [[_dic valueForKey:@"col2"] longLongValue];
                    _Label.text = [NSString stringWithFormat:@"￥%lld",junmao];
                } else {
                    _Label.text = [NSString stringWithFormat:@"￥****"];
                }
            } else{
                _nameLabel.text = @"利润:";
                if ([[_dic allKeys] containsObject:@"col4"]) {
                    _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col4"]];
                } else {
                    _Label.text = [NSString stringWithFormat:@"￥****"];
                }
            }
        }
    }
    
    _titleLabel.text = [_dic valueForKey:@"col1"];
    
}
@end
