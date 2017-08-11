//
//  SecondPersonTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/7/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SecondPersonTableViewCell.h"

@implementation SecondPersonTableViewCell

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
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
        [self.contentView addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(45, 12, KScreenWidth - 80, 20)];
        _label.font = MainFont;
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.image = [UIImage imageNamed:[_dic valueForKey:@"ImageName"]];
    
    _label.text = [_dic valueForKey:@"Title"];
    
}
@end
