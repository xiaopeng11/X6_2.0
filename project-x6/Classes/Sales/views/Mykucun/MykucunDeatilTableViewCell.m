//
//  MykucunDeatilTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MykucunDeatilTableViewCell.h"
#import "LibrarybitdistributionViewController.h"

#define mykucunwidth ((KScreenWidth - 163) / 2.0)
@implementation MykucunDeatilTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _myKuncunView = [[UIView alloc] initWithFrame:CGRectZero];
        _myKuncunView.backgroundColor = GrayColor;
        [self.contentView addSubview:_myKuncunView];
        
        for (int i = 0; i < 5; i++) {
            _label = [[UILabel alloc] init];
            _titleLabel = [[UILabel alloc] init];
            _label.font = ExtitleFont;
            _titleLabel.font = ExtitleFont;
            _label.tag = 4110 + i;
            _titleLabel.tag = 4120 + i;
            
            if (i == 0) {
                _titleLabel.frame = CGRectMake(43, 11, 60, 16);
                _label.frame = CGRectMake(103, 11, KScreenWidth - 203, 16);
            } else {
                _label.hidden = YES;
                _titleLabel.hidden = YES;
                int withnum = (i - 1) / 2;
                int lonnum = (i - 1) % 2;
                _titleLabel.frame = CGRectMake(43 + (70 + mykucunwidth) * lonnum, 42 + 31 * withnum, 60, 16);
                if (lonnum == 1) {
                    _label.frame = CGRectMake(113 + (40 + mykucunwidth) * lonnum, 42 + 31 * withnum, mykucunwidth, 16);
                } else {
                    _label.frame = CGRectMake(103 + (70 + mykucunwidth) * lonnum, 42 + 31 * withnum, mykucunwidth, 16);
                }
            }
            _label.textColor = PriceColor;
            [_myKuncunView addSubview:_label];
            [_myKuncunView addSubview:_titleLabel];
        }
        
        _MykucunDeatilbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _MykucunDeatilbutton.frame = CGRectMake(KScreenWidth - 90, 5, 80, 29);
        [_MykucunDeatilbutton setBackgroundColor:Mycolor];
        [_MykucunDeatilbutton setTitle:@"库位分布" forState:UIControlStateNormal];
        [_MykucunDeatilbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _MykucunDeatilbutton.clipsToBounds = YES;
        _MykucunDeatilbutton.titleLabel.font = MainFont;
        _MykucunDeatilbutton.layer.cornerRadius = 4;
        [_MykucunDeatilbutton addTarget:self action:@selector(MykucunDeatilaction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_MykucunDeatilbutton];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        float height = [[dic valueForKey:@"rowheight"] floatValue];
        _myKuncunView.frame = CGRectMake(0, 0, KScreenWidth, height);
        for (int i = 1; i < 5; i++) {
            _label = [self.contentView viewWithTag:4110 + i];
            _titleLabel = [self.contentView viewWithTag:4120 + i];
            if (height == 38) {
                _label.hidden = YES;
                _titleLabel.hidden = YES;
            } else {
                _label.hidden = NO;
                _titleLabel.hidden = NO;
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < 5; i++) {
        _label = [self.contentView viewWithTag:4110 + i];
        _titleLabel = [self.contentView viewWithTag:4120 + i];
        if (i == 0) {
            _titleLabel.text = @"均       价:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zongjunjia"]];
        } else if (i == 1) {
            _titleLabel.text = @"最高进价:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zgcbdj"]];
        } else if (i == 2) {
            _titleLabel.text = @"数量:";
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"zgsl"]];
        } else if (i == 3) {
            _titleLabel.text = @"最低进价:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zdcbdj"]];
        } else if (i == 4) {
            _titleLabel.text = @"数量:";
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"zdsl"]];
        }
    }
}

- (void)MykucunDeatilaction
{
    LibrarybitdistributionViewController *LibrarybitdistributionVC = [[LibrarybitdistributionViewController alloc] init];
    LibrarybitdistributionVC.spdm = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col0"]];
    [self.ViewController.navigationController pushViewController:LibrarybitdistributionVC animated:YES];
}

@end
