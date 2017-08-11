//
//  OldlibraryTabelView.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibraryTabelView.h"

#import "OldlibrarydetailViewController.h"

#define oldlibraryWidth ((KScreenWidth - 150) / 3.0)
@implementation OldlibraryTabelView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        
        _OldlibrarybgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 219)];
        _OldlibrarybgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_OldlibrarybgView];
        
        for (int i = 0; i < 4; i++) {
            if (i < 2) {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13 + 30 * i, 20, 20)];
                _label = [[UILabel alloc] initWithFrame:CGRectMake(40, 13 + 30 * i, KScreenWidth - 50, 20)];
                _imageView.tag = 46810 + i;
                _label.tag = 46820 + i;
                _label.font = MainFont;
                [_OldlibrarybgView addSubview:_label];
                [_OldlibrarybgView addSubview:_imageView];
            }
            _messageLabel = [[UILabel alloc] init];
            _nameLabel = [[UILabel alloc] init];
            _nameLabel.frame = CGRectMake(40, 73 + 23 * i, 40, 16);
            _messageLabel.frame = CGRectMake(80, 73 + 23 * i, KScreenWidth - 90, 16);
            
            _nameLabel.tag = 46830 + i;
            _messageLabel.tag = 46840 + i;
            _messageLabel.textColor = PriceColor;
            _messageLabel.font = ExtitleFont;
            _nameLabel.font = ExtitleFont;
            [_OldlibrarybgView addSubview:_nameLabel];
            [_OldlibrarybgView addSubview:_messageLabel];
        }
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 174, KScreenWidth, .5)];
        [_OldlibrarybgView addSubview:lineView];        
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(KScreenWidth - 100, 174, 100, 44);
        _button.titleLabel.font = ExtitleFont;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 60, 20)];
        label.font = ExtitleFont;
        label.text = @"查看详情";
        label.textColor = ExtraTitleColor;
        [_button addSubview:label];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 16, 6, 12)];
        imageView.image = [UIImage imageNamed:@"y1_b"];
        [_button addSubview:imageView];
        [_button addTarget:self action:@selector(moreOldlibraryData) forControlEvents:UIControlEventTouchUpInside];
        [_OldlibrarybgView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    for (int i = 0; i < 4; i++) {
        _messageLabel = (UILabel *)[_OldlibrarybgView viewWithTag:46840 + i];
        _nameLabel = (UILabel *)[_OldlibrarybgView viewWithTag:46830 + i];
        if (i < 2) {
            _imageView = (UIImageView *)[_OldlibrarybgView viewWithTag:(46810 + i)];
            _label = (UILabel *)[_OldlibrarybgView viewWithTag:(46820 + i)];
            if (i == 0) {
                _imageView.image = [UIImage imageNamed:@"y2_a"];
                _label.text = [_dic valueForKey:@"col1"];
            } else {
                _imageView.image = [UIImage imageNamed:@"y2_b"];
                _label.text = [_dic valueForKey:@"col3"];
            }
        }
        
        if (i == 0) {
            _nameLabel.text = @"数量:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col6"]];
        } else if (i == 1) {
            _nameLabel.text = @"金额:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col7"]];
        } else if (i == 2) {
            _nameLabel.text = @"库龄:";
            _messageLabel.text = [NSString stringWithFormat:@"%@天",[_dic valueForKey:@"col4"]];
        } else if (i == 3) {
            _nameLabel.text = @"逾期:";
            _messageLabel.text = [NSString stringWithFormat:@"%@天",[_dic valueForKey:@"col5"]];
        }
    }

}

- (void)moreOldlibraryData
{
    OldlibrarydetailViewController *OldlibrarydetailVC = [[OldlibrarydetailViewController alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[_dic valueForKey:@"col0"] forKey:@"gysdm"];
    [dic setObject:[_dic valueForKey:@"col1"] forKey:@"gysName"];
    [dic setObject:[_dic valueForKey:@"col3"] forKey:@"hpName"];
    [dic setObject:[_dic valueForKey:@"col2"] forKey:@"spdm"];
    [dic setObject:[_dic valueForKey:@"col4"] forKey:@"kl"];
    OldlibrarydetailVC.dic = dic;
    [self.ViewController.navigationController pushViewController:OldlibrarydetailVC animated:YES];
}
@end
