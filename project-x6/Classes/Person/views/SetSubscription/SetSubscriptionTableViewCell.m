//
//  SetSubscriptionTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SetSubscriptionTableViewCell.h"

@implementation SetSubscriptionTableViewCell

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
        
        _SetSubscriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 25)];
        _SetSubscriptionLabel.font = MainFont;
        [self.contentView addSubview:_SetSubscriptionLabel];
        
        _SetSubscriptionTimeGroup = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 10, 90, 25)];
        _SetSubscriptionTimeGroup.font = MainFont;
        _SetSubscriptionTimeGroup.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_SetSubscriptionTimeGroup];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _SetSubscriptionLabel.text = [self.dic valueForKey:@"title"];
    
    _SetSubscriptionTimeGroup.text = [self.dic valueForKey:@"timeselect"];
}

@end
