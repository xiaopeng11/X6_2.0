//
//  SubsscribeByStoreTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SubsscribeByStoreTableViewCell.h"

@implementation SubsscribeByStoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = nil;
        
        _Subscrbedetailbgview = [[UIView alloc] initWithFrame:CGRectMake(10, 2.5, KScreenWidth -20, 45)];
        _Subscrbedetailbgview.backgroundColor = GrayColor;
        [self.contentView addSubview:_Subscrbedetailbgview];
        
        for (int i = 0; i < 4; i++) {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + i * ((KScreenWidth - 30) / 4), 10, ((KScreenWidth - 10) / 4), 25)];
            _textLabel.font = MainFont;
            if (i == 0) {
                _textLabel.textAlignment = NSTextAlignmentLeft;
            } else {
                _textLabel.textAlignment = NSTextAlignmentCenter;
            }
            _textLabel.tag = 101300 + i;
            [_Subscrbedetailbgview addSubview:_textLabel];
        }

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 4; i++) {
        _textLabel = (UILabel *)[self.contentView viewWithTag:101300 + i];
        if (i == 0) {
            _textLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col0"]];
        } else if (i == 1) {
            _textLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col3"]];
        } else if (i == 2) {
            _textLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col4"]];
        } else if (i == 3) {
            _textLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col5"]];
        }
        
    }
}

@end
