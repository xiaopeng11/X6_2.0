//
//  TakeInventoryTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TakeInventoryTableViewCell.h"
#import "MoreInventoryViewController.h"

@implementation TakeInventoryTableViewCell

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
        
        _takeInventoryBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 320)];
        _takeInventoryBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_takeInventoryBgView];
        
        //订单号
        _dhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 110, 20)];
        _dhLabel.font = MainFont;
        _dhLabel.textColor = ExtraTitleColor;
        [_takeInventoryBgView addSubview:_dhLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 90, 20)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_takeInventoryBgView addSubview:_dateLabel];
        
        //横向间隔
        for (int i = 0; i < 5; i++) {
            UIView *lineView;
            if (i < 3) {
                lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            } else {
                lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 205 + 70 * (i - 3), KScreenWidth, .5)];
            }
            [_takeInventoryBgView addSubview:lineView];
        }
        
        //纵向间隔
        UIView *lowView = [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - .5)/2.0, 45, .5, 90)];
        [_takeInventoryBgView addSubview:lowView];
        
        for (int i = 0; i < 4; i++) {
            int low = i / 2;
            int wid = i % 2;
            _headerLabel = [[UILabel alloc] init];
            _messageLabel = [[UILabel alloc] init];
            if (i == 0) {
                _headerLabel.frame = CGRectMake(10 , 57 , 60, 20);
                _messageLabel.frame = CGRectMake(70, 57, (KScreenWidth / 2.0) - 70.25, 20);
            } else {
                _headerLabel.frame = CGRectMake(10 + ((KScreenWidth / 2.0) * wid), 57 + 45 * low, 70, 20);
                _messageLabel.frame = CGRectMake(80 + ((KScreenWidth / 2.0) * wid), 57 + 45 * low, (KScreenWidth / 2.0) - 80.25, 20);
            }
            _headerLabel.font = MainFont;
            _messageLabel.font = MainFont;
            _headerLabel.textColor = [UIColor blackColor];
            _messageLabel.textColor = PriceColor;
            _headerLabel.tag = 380010 + i;
            _messageLabel.tag = 380020 + i;
            [_takeInventoryBgView addSubview:_headerLabel];
            [_takeInventoryBgView addSubview:_messageLabel];
        }
        
        
        //盘库范围
        _takeRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 135 + 12, KScreenWidth - 20, 46)];
        _takeRangeLabel.numberOfLines = 2;
        _takeRangeLabel.font = MainFont;
        [_takeInventoryBgView addSubview:_takeRangeLabel];
        
        
        //摘要
        _comments = [[UILabel alloc] initWithFrame:CGRectMake(10, 205 + 12, KScreenWidth - 20, 46)];
        _comments.numberOfLines = 2;
        _comments.font = MainFont;
        [_takeInventoryBgView addSubview:_comments];
        
        //盘库详情
        _more = [UIButton buttonWithType:UIButtonTypeCustom];
        _more.frame = CGRectMake(KScreenWidth - 100, 275, 100, 44);
        _more.titleLabel.font = ExtitleFont;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 80, 20)];
        label.font = ExtitleFont;
        label.text = @"查看详情";
        label.textColor = ExtraTitleColor;
        label.textAlignment = NSTextAlignmentRight;
        [_more addSubview:label];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(82.5, 14.5, 7.5, 15)];
        imageView.image = [UIImage imageNamed:@"y1_b"];
        [_more addSubview:imageView];
        [_more addTarget:self action:@selector(moretakeinventory) forControlEvents:UIControlEventTouchUpInside];
        [_takeInventoryBgView addSubview:_more];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dhLabel.text = [NSString stringWithFormat:@"单号:%@",[_dic valueForKey:@"djh"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"fsrq"]];
    
    for (int i = 0; i < 4; i++) {
        _headerLabel = (UILabel *)[_takeInventoryBgView viewWithTag:380010 + i];
        _messageLabel = (UILabel *)[_takeInventoryBgView viewWithTag:380020 + i];
        if (i == 0) {
            _headerLabel.text = @"制单人:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"zdrmc"]];
        } else if (i == 1) {
            _headerLabel.text = @"制单日期:";
            NSString *fulldate = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"zdrq"]];
            fulldate = [fulldate substringWithRange:NSMakeRange(5, fulldate.length - 5)];
            _messageLabel.text = fulldate;
        } else if (i == 2) {
            _headerLabel.text = @"审批结果:";
            if ([[_dic valueForKey:@"shjg"] integerValue] == 1) {
                _messageLabel.text = @"通过";
            } else {
                _messageLabel.text = @"未通过";
            }
        } else if (i == 3) {
            _headerLabel.text = @"审批日期:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"shrq"]];
        }
    }
    
    _takeRangeLabel.text = [NSString stringWithFormat:@"盘库范围:%@",[_dic valueForKey:@"pdfw"]];
    
    _comments.text = [NSString stringWithFormat:@"摘要:%@",[_dic valueForKey:@"comments1"]];
    
}

- (void)moretakeinventory
{
    NSLog(@"库存盘详情");
    MoreInventoryViewController *moreInventoryVC = [[MoreInventoryViewController alloc] init];
    moreInventoryVC.inventoryid = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"id"]];
    [self.ViewController.navigationController pushViewController:moreInventoryVC animated:YES];
}

@end
