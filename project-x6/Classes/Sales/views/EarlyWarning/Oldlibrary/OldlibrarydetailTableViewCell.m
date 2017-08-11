//
//  OldlibrarydetailTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibrarydetailTableViewCell.h"

@implementation OldlibrarydetailTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i = 0; i < 3; i++) {
 
            _label = [[UILabel alloc] initWithFrame:CGRectMake(10 + (KScreenWidth / 3.0) * i, 14, KScreenWidth / 3.0, 16)];
            _label.textAlignment = NSTextAlignmentCenter;
            _label.tag = 46930 + i;
            _label.font = ExtitleFont;
            if (i == 0) {
                _label.textColor = Mycolor;
            }
            [self.contentView addSubview:_label];
            
            _OldlibrarydetaillineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
            [self.contentView addSubview:_OldlibrarydetaillineView];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < 3; i++) {
        _label = (UILabel *)[self.contentView viewWithTag:46930 + i];
        if (i == 0) {
            _label.text = [_dic valueForKey:@"col0"];
        } else if (i == 1) {
            _label.text = [_dic valueForKey:@"col2"];
        } else {
            _label.text = [NSString stringWithFormat:@"%@天",[_dic valueForKey:@"col4"]];
        }
    }
}
@end
