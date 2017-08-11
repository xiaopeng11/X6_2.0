
//
//  AcuntAndMoneyTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AcuntAndMoneyTableViewCell.h"

@implementation AcuntAndMoneyTableViewCell

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
        
        self.backgroundColor = [UIColor clearColor];
        _acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, KScreenWidth - 145 - 40, 20)];
        _acountLabel.font = MainFont;
        [self.contentView addSubview:_acountLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 185, 12, 90, 20)];
        _moneyLabel.font = MainFont;
        [self.contentView addSubview:_moneyLabel];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _acountLabel.text = [_dic valueForKey:@"acount"];
    
    _moneyLabel.text = [_dic valueForKey:@"money"];
}

@end
