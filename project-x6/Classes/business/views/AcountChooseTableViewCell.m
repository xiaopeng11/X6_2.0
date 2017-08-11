//
//  AcountChooseTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AcountChooseTableViewCell.h"

@implementation AcountChooseTableViewCell

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
        
        _bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 120, 20)];
        _bankLabel.font = MainFont;
        [self.contentView addSubview:_bankLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 10, 100, 20)];
        _moneyLabel.hidden = YES;
        _moneyLabel.font = ExtitleFont;
        [self.contentView addSubview:_moneyLabel];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
        
    _bankLabel.text = [_dic valueForKey:@"name"];
    
    if (![[_dic valueForKey:@"choose"] isEqualToString:@""]) {
        _moneyLabel.hidden = NO;
        _moneyLabel.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@"choose"]];
    } else {
        _moneyLabel.hidden = YES;
    }
}
@end
