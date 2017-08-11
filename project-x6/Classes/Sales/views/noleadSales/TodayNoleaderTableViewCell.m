//
//  TodayNoleaderTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayNoleaderTableViewCell.h"
#import "LibrarybitdistributionViewController.h"

@implementation TodayNoleaderTableViewCell

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
        
        self.backgroundColor = GrayColor;
        self.backgroundView = nil;
        //初始化子视图
        _label = [[UILabel alloc] initWithFrame:CGRectMake(43, 12, 50, 21)];
        _label.font = MainFont;
        [self.contentView addSubview:_label];
        
        _moneylabel = [[UILabel alloc] initWithFrame:CGRectMake(93, 12, KScreenWidth - 193, 21)];
        _moneylabel.font = MainFont;
        _moneylabel.textColor = PriceColor;
        [self.contentView addSubview:_moneylabel];
        
        _librarybitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _librarybitbutton.frame = CGRectMake(KScreenWidth - 90, 8, 80, 29);
        [_librarybitbutton setBackgroundColor:Mycolor];
        [_librarybitbutton setTitle:@"库位分布" forState:UIControlStateNormal];
        [_librarybitbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _librarybitbutton.clipsToBounds = YES;
        _librarybitbutton.titleLabel.font = MainFont;
        _librarybitbutton.layer.cornerRadius = 4;
        [_librarybitbutton addTarget:self action:@selector(librarybit) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_librarybitbutton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.text = @"成本:";
    
    _moneylabel.text = [NSString stringWithFormat:@"￥%.2f",[[_dic valueForKey:@"col3"] floatValue]];
   
}

- (void)librarybit
{
    LibrarybitdistributionViewController *LibrarybitdistributionVC = [[LibrarybitdistributionViewController alloc] init];
    LibrarybitdistributionVC.spdm = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col0"]];
    [self.ViewController.navigationController pushViewController:LibrarybitdistributionVC animated:YES];
}

@end
