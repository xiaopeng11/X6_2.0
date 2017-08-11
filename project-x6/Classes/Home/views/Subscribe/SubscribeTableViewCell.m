//
//  SubscribeTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/10/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SubscribeTableViewCell.h"
#import "SubscribeDetailViewController.h"
@implementation SubscribeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;
        self.backgroundView = nil;
        
        _dateBgView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 110) / 2.0, 15, 110, 19)];
        _dateBgView.backgroundColor = ColorRGB(190, 190, 190);
        _dateBgView.clipsToBounds = YES;
        _dateBgView.layer.cornerRadius = 4;
        [self.contentView addSubview:_dateBgView];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 19)];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = ExtitleFont;
        [_dateBgView addSubview:_dateLabel];
        
        _SubscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SubscribeButton.frame = CGRectMake(13, 49, KScreenWidth - 26, 86);
        _SubscribeButton.backgroundColor = [UIColor whiteColor];
        _SubscribeButton.clipsToBounds = YES;
        _SubscribeButton.layer.cornerRadius = 4;
        [_SubscribeButton addTarget:self action:@selector(dailydetailAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_SubscribeButton];
        
        _SubscribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 10, 60, 20)];
        _SubscribeLabel.font = MainFont;
        [_SubscribeButton addSubview:_SubscribeLabel];
        
        _deteedtailLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, _SubscribeLabel.bottom + 9, KScreenWidth - 60, 15)];
        _deteedtailLabel.font = MainFont;
        _deteedtailLabel.textColor = Mycolor;
        [_SubscribeButton addSubview:_deteedtailLabel];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, _deteedtailLabel.bottom + 9, KScreenWidth - 60, 15)];
        _textLabel.font = MainFont;
        [_SubscribeButton addSubview:_textLabel];
        
        _leadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 43.5, 35.5, 7.5, 15)];
        [_SubscribeButton addSubview:_leadImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *dateStr = [self.dic valueForKey:@"col0"];
    if ([dateStr containsString:@"("]) {
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"("];
        dateStr = dateArr[0];
    }
    _dateLabel.text = dateStr;
    
    if (_type == 1) {
        _SubscribeLabel.text = @"日报";
    } else if (_type == 2) {
        _SubscribeLabel.text = @"周报";
    } else if (_type == 3) {
        _SubscribeLabel.text = @"月报";
    }

    _deteedtailLabel.text = [self.dic valueForKey:@"col0"];
    
    _textLabel.text = [NSString stringWithFormat:@"销售数量%@;销售金额%@;毛利%@",[self.dic valueForKey:@"col1"],[self.dic valueForKey:@"col2"],[self.dic valueForKey:@"col3"]];
    
    _leadImageView.image = [UIImage imageNamed:@"y1_b"];

}


- (void)dailydetailAction
{
    SubscribeDetailViewController *SubscribeDetailVC = [[SubscribeDetailViewController alloc] init];
    SubscribeDetailVC.dateString = [self.dic valueForKey:@"col0"];
    SubscribeDetailVC.type = self.type;
    [self.ViewController.navigationController pushViewController:SubscribeDetailVC animated:YES];
}
@end
