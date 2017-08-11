//
//  AllsalesTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AllsalesTableViewCell.h"

@implementation AllsalesTableViewCell

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
        _indexlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        NSArray *array = HeaderBgColorArray;
        int x = arc4random() % 10;
        [_indexlabel setBackgroundColor:(UIColor *)array[x]];
        _indexlabel.clipsToBounds = YES;
        _indexlabel.layer.cornerRadius = 15;
        _indexlabel.font = ExtitleFont;
        _indexlabel.textAlignment = NSTextAlignmentCenter;
        _indexlabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_indexlabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, KScreenWidth - 70, 21)];
        _nameLabel.font = MainFont;
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _indexlabel.text = [BasicControls judgeuserHeaderImageNameLenghNameString:[_dic valueForKey:@"index"]];
    
    _nameLabel.text = [_dic valueForKey:@"col1"];
}
@end
