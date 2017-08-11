//
//  SerialAllocateStorageTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SerialAllocateStorageTableViewCell.h"

@implementation SerialAllocateStorageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _SerialNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, KScreenWidth, 21)];
        _SerialNumLabel.font = MainFont;
        _SerialNumLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_SerialNumLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _SerialNumLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col2"]];
}

@end
