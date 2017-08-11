//
//  FirstCheckTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FirstCheckTableViewCell.h"

@implementation FirstCheckTableViewCell

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
        
        _FirstCheckBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 115)];
        _FirstCheckBgview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_FirstCheckBgview];
        
        _WarewhouseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 21)];
        _WarewhouseLabel.font = MainFont;
        [_FirstCheckBgview addSubview:_WarewhouseLabel];
        
        _WarewhouseMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, KScreenWidth - 70, 21)];
        _WarewhouseMessageLabel.font = MainFont;
        [_FirstCheckBgview addSubview:_WarewhouseMessageLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [_FirstCheckBgview addSubview:lineView];
        
        for (int i = 0; i < 2; i++) {
            _FirstCheckLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 + 9 + 30 * i, 50, 21)];
            _FirstCheckLabel.font = MainFont;
            _FirstCheckLabel.textColor = [UIColor blackColor];
            _FirstCheckLabel.tag = 391210 + i;
            
            _FirstCheckMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 45 + 9 + 30 * i, KScreenWidth - 70, 21)];
            _FirstCheckMessageLabel.font = MainFont;
            _FirstCheckMessageLabel.textColor = PriceColor;
            _FirstCheckMessageLabel.tag = 391220 + i;
            [_FirstCheckBgview addSubview:_FirstCheckLabel];
            [_FirstCheckBgview addSubview:_FirstCheckMessageLabel];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    _WarewhouseLabel.text = @"仓库:";
    
    _WarewhouseMessageLabel.text = [_dic valueForKey:@"col1"];
    
    for (int i = 0; i < 2; i++) {
        _FirstCheckLabel = (UILabel *)[_FirstCheckBgview viewWithTag:391210 + i];
        _FirstCheckMessageLabel = (UILabel *)[_FirstCheckBgview viewWithTag:391220 + i];
        if (i == 0) {
            _FirstCheckLabel.text = @"货品:";
            _FirstCheckMessageLabel.text = [_dic valueForKey:@"col3"];
        } else {
            _FirstCheckLabel.text = @"数量:";
            _FirstCheckMessageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col4"]];
        }
    }
}
@end
