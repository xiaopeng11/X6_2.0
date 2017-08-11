//
//  BusinessSCTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/10/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BusinessSCTableViewCell.h"

@implementation BusinessSCTableViewCell

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
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = nil;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 150, 21)];
        _titleLabel.font = MainFont;
        [self.contentView addSubview:_titleLabel];
        
        _isMoneyDefaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 70, 21)];
        _isMoneyDefaultLabel.font = ExtitleFont;
        _isMoneyDefaultLabel.hidden = YES;
        _isMoneyDefaultLabel.textColor = PriceColor;
        _isMoneyDefaultLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_isMoneyDefaultLabel];
        
        UIView *lianeView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [self.contentView addSubview:lianeView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.text = [self.dic valueForKey:@"col0"];
    
    if ([[self.dic valueForKey:@"col1"] intValue] == 2) {
        _isMoneyDefaultLabel.hidden = NO;
        _isMoneyDefaultLabel.text = @"金额不符";
    }
    
}
@end
