//
//  SelectTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SelectTableViewCell.h"

@implementation SelectTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = MainFont;
        [self.contentView addSubview:label];
        
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_button];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    label.text = [self.model valueForKey:@"name"];
    
    if (_type == YES && _BusinessSCDetailType == NO) {
        label.frame = CGRectMake(55, 10, KScreenWidth - 80 - 60, 25);
        _button.frame = CGRectMake(0, 0, 50, 45);
        if ([[self.model valueForKey:@"check"] boolValue] == NO) {
            [_button setImage:[UIImage imageNamed:@"quan_a"] forState:UIControlStateNormal];
        } else {
            [_button setImage:[UIImage imageNamed:@"quan_b"] forState:UIControlStateNormal];
        }
    } else {
        label.frame = CGRectMake(10, 10, KScreenWidth - 40, 25);
    }
   
}


@end
