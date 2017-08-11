//
//  SalesTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SalesTableViewCell.h"

@implementation SalesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        //初始化子视图
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20.5, 29, 29)];
        [self.contentView addSubview:_imageview];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(59, 20, 100, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = MainFont;
        [self.contentView addSubview:_label];
        
        _lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 69.5, KScreenWidth, .5)];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.text = [_dic valueForKey:@"text"];
    
    _imageview.image = [UIImage imageNamed:[_dic valueForKey:@"image"]];
    
}

@end
