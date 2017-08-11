//
//  SubscribeBySaleClerkTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SubscribeBySaleClerkTableViewCell.h"

@implementation SubscribeBySaleClerkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = nil;
        
        _Subscrbedetailbgview = [[UIView alloc] initWithFrame:CGRectZero];
        _Subscrbedetailbgview.backgroundColor = GrayColor;
        [self.contentView addSubview:_Subscrbedetailbgview];
        
        _titleNameBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleNameBgView.backgroundColor = [UIColor whiteColor];
        [_Subscrbedetailbgview addSubview:_titleNameBgView];
        
        _titleNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleNameLabel.font = MainFont;
        _titleNameLabel.textColor = [UIColor whiteColor];
        [_Subscrbedetailbgview addSubview:_titleNameLabel];
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        
        NSArray *data = [self.dic valueForKey:@"data"];
        _Subscrbedetailbgview.frame = CGRectMake(10, 10, KScreenWidth - 20, 45 + 47.5 * data.count);
        
        _titleNameBgView.frame = CGRectMake(0, 0, KScreenWidth - 20, 45);
        _titleNameLabel.frame = CGRectMake(10, 10, KScreenWidth - 40, 25);
        
        _titleNameLabel.text = [self.dic valueForKey:@"ssmd"];

        for (int i = 0; i < 4 * data.count; i++) {
            int wid = (i / 4);
            int low = (i % 4);
            _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + low * ((KScreenWidth - 30) / 4), 47.5 + 10 + 47.5 * wid, ((KScreenWidth - 30) / 4), 25)];
            _textLabel.font = MainFont;
            NSDictionary *dic = data[wid];
            if (low == 0) {
                _textLabel.textAlignment = NSTextAlignmentLeft;
                _textLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col0"]];
            } else {
                _textLabel.textAlignment = NSTextAlignmentCenter;
                if (low == 1) {
                    _textLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col1"]];
                } else if (low == 2) {
                    _textLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col2"]];
                } else if (low == 3) {
                    _textLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col3"]];
                }
            }
            [_Subscrbedetailbgview addSubview:_textLabel];
        }
        
        for (int j = 0; j < 4 * (data.count + 1); j++) {
            int wid = (j / 4);
            _textBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 + 47.5 * wid, KScreenWidth - 20, 2.5)];
            _textBgView.backgroundColor = [UIColor whiteColor];
            [_Subscrbedetailbgview addSubview:_textBgView];
            
        }
    }
}

- (void)setType:(NSInteger)type
{
    if (_type != type) {
        _type = type;
        if (self.type == 1) {
            _titleNameBgView.backgroundColor = ColorRGB(239, 127, 175);
        } else if (self.type == 2) {
            _titleNameBgView.backgroundColor = ColorRGB(243, 134, 1);
        } else if (self.type == 3) {
            _titleNameBgView.backgroundColor = ColorRGB(53, 184, 158);
        }
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end
