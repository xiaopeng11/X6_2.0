//
//  StoresTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "StoresTableViewCell.h"

@implementation StoresTableViewCell

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
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 20, 20)];
        _label.font = MainFont;
        [self.contentView addSubview:_label];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
          
    _label.text = [_dic valueForKey:_key];
}
@end
