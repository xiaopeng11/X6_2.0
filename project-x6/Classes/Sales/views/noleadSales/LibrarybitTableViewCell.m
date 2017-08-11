//
//  LibrarybitTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LibrarybitTableViewCell.h"

@implementation LibrarybitTableViewCell

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
        
        _WarehouseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 20 - 100, 21)];
        _WarehouseLabel.font = MainFont;
        [self.contentView addSubview:_WarehouseLabel];
        
        _goodNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 110, 12, 100, 21)];
        _goodNumLabel.font = MainFont;
        _goodNumLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_goodNumLabel];
        
        UIView *bottomLabel = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [self.contentView addSubview:bottomLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _WarehouseLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col0"]];
    
    _goodNumLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col1"]];

}

@end
