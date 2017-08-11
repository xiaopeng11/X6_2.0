//
//  MoreAllocateStorageTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MoreAllocateStorageTableViewCell.h"

#define MoreAllocateStorageWidth ((KScreenWidth - 40.5) / 2.0)
@implementation MoreAllocateStorageTableViewCell

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
        {
            self.backgroundView = nil;
            self.backgroundColor = GrayColor;
            
            _MoreAllocateStorageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 90)];
            _MoreAllocateStorageBgView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:_MoreAllocateStorageBgView];
            
            _goodName = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 86, 21)];
            _goodName.font = MainFont;
            [_MoreAllocateStorageBgView addSubview:_goodName];
            
            _MoreGoodMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 76, 12, 60, 21)];
            _MoreGoodMessageLabel.font = ExtitleFont;
            _MoreGoodMessageLabel.textColor = ExtraTitleColor;
            [_MoreAllocateStorageBgView addSubview:_MoreGoodMessageLabel];;
            
            _moreListImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 16, 16, 6, 12)];
            [_MoreAllocateStorageBgView addSubview:_moreListImageView];
            
            
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
            [_MoreAllocateStorageBgView addSubview:lineView];
            
            
            for (int i = 0; i < 2; i++) {
                _goodNum = [[UILabel alloc] initWithFrame:CGRectMake(10 + (i * (MoreAllocateStorageWidth + 20.5)), 45 + 12, 40, 20)];
                _goodNum.font = MainFont;
                _goodNum.tag = 332110 + i;
                [_MoreAllocateStorageBgView addSubview:_goodNum];
                
                _goodMoney = [[UILabel alloc] initWithFrame:CGRectMake(50 + (i * (MoreAllocateStorageWidth + 20.5)), 45 + 12, MoreAllocateStorageWidth - 40, 20)];
                _goodMoney.font = MainFont;
                _goodMoney.tag = 332120 + i;
                [_MoreAllocateStorageBgView addSubview:_goodMoney];
                
                if (i == 1) {
                    _goodMoney.textColor = PriceColor;
                }
            }
            
            UIView *lowView = [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - .5) / 2, 45, .5, 45)];
            [_MoreAllocateStorageBgView addSubview:lowView];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _goodName.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"col1"]];
    
    _MoreGoodMessageLabel.text = @"查看详情";
    
    for (int i = 0; i < 2; i++) {
        _goodNum = (UILabel *)[_MoreAllocateStorageBgView viewWithTag:332110 + i];
        _goodMoney = (UILabel *)[_MoreAllocateStorageBgView viewWithTag:332120 + i];
        if (i == 0) {
            _goodNum.text = @"数量:";
            _goodMoney.text = [NSString stringWithFormat:@"%@个",[self.dic valueForKey:@"col2"]];
        } else {
            _goodNum.text = @"金额:";
            _goodMoney.text = [NSString stringWithFormat:@"￥%@",[self.dic valueForKey:@"col3"]];
        }

    }
    
    _moreListImageView.image = [UIImage imageNamed:@"y1_b"];
    
}
@end
