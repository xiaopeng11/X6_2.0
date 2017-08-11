//
//  EarlyWarningTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EarlyWarningTableViewCell.h"

@implementation EarlyWarningTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 26, 25)];
        [self.contentView addSubview:_image];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(51, 12.5, 90, 20)];
        _label.font = MainFont;
        [self.contentView addSubview:_label];

        _lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _image.image = [UIImage imageNamed:[_dic valueForKey:@"image"]];
    
    _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"text"]];
    
}

@end
