//
//  AllocateStorageTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AllocateStorageTableViewCell.h"

#import "MoreAllocateStorageViewController.h"
#define AllocateStorageWidthF ((KScreenWidth - 40.5) / 2.0)
@implementation AllocateStorageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;

        //背景
        _AllocateStoragebgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45 + 79 + 90 + 44)];
        _AllocateStoragebgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_AllocateStoragebgView];
        
        //订单号
        _ddhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, KScreenWidth - 10 - 110, 20)];
        _ddhLabel.font = MainFont;
        _ddhLabel.textColor = ExtraTitleColor;
        [_AllocateStoragebgView addSubview:_ddhLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 12, 90, 20)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = ExtitleFont;
        _dateLabel.textColor = ExtraTitleColor;
        [_AllocateStoragebgView addSubview:_dateLabel];
        
        //间隔
        for (int i = 0; i < 4; i++) {
            if (i == 0) {
                _lowlineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
            } else if (i > 0){
                _lowlineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 79 + 45 * (i - 1), KScreenWidth, .5)];
            }
            _highlineView = [BasicControls drawLineWithFrame:CGRectMake((KScreenWidth - .5) / 2.0, 45 + 79, .5, 90)];
            [_AllocateStoragebgView addSubview:_lowlineView];
            [_AllocateStoragebgView addSubview:_highlineView];
        }
        
        //移出仓库
        _movefrom = [[UILabel alloc] initWithFrame:CGRectMake(10, 58, KScreenWidth - 88 - 10, 20)];
        _movefrom.font = MainFont;
        [_AllocateStoragebgView addSubview:_movefrom];
        
        //移入仓库
        _movein = [[UILabel alloc] initWithFrame:CGRectMake(10, 91, KScreenWidth - 88 - 10, 20)];
        _movein.font = MainFont;
        [_AllocateStoragebgView addSubview:_movein];
        
        //详情
        for (int i = 0; i < 4; i++) {
            int order_X = i / 2;
            int order_Y = i % 2;
            _messageheaderLabel = [[UILabel alloc] init];
            _messagebodyLabel = [[UILabel alloc] init];
            if (i < 2) {
                _messageheaderLabel.frame = CGRectMake(10 + (KScreenWidth / 2.0) * order_Y, 138 + 45 * order_X, 40, 20);
                _messagebodyLabel.frame = CGRectMake(50 + (KScreenWidth / 2.0) * order_Y, 138 + 45 * order_X, AllocateStorageWidthF - 40, 20);
            } else if (i == 2) {
                _messageheaderLabel.frame = CGRectMake(10 , 138 + 45, 60, 20);
                _messagebodyLabel.frame = CGRectMake(70, 138 + 45, AllocateStorageWidthF - 60, 20);
            } else {
                _messageheaderLabel.frame = CGRectMake(10 + (KScreenWidth / 2.0) , 138 + 45, 70, 20);
                _messagebodyLabel.frame = CGRectMake(80 + (KScreenWidth / 2.0), 138 + 45, AllocateStorageWidthF - 80, 20);
            }
            _messageheaderLabel.tag = 43310 + i;
            _messagebodyLabel.tag = 43320 + i;
            
            _messageheaderLabel.font = MainFont;
            _messagebodyLabel.font = ExtitleFont;
            
            _messagebodyLabel.textColor = PriceColor;
            [_AllocateStoragebgView addSubview:_messageheaderLabel];
            [_AllocateStoragebgView addSubview:_messagebodyLabel];
        }
        
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 77, 70.5, 67, 28)];
        [_sureButton setBackgroundColor:Mycolor];
        _sureButton.clipsToBounds = YES;
        _sureButton.layer.cornerRadius = 4;
        _sureButton.titleLabel.font = MainFont;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_AllocateStoragebgView addSubview:_sureButton];
        
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(KScreenWidth - 100, 214, 100, 44);
        _moreButton.titleLabel.font = ExtitleFont;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 60, 20)];
        label.font = ExtitleFont;
        label.text = @"查看详情";
        label.textColor = ExtraTitleColor;
        [_moreButton addSubview:label];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 16, 6, 12)];
        imageView.image = [UIImage imageNamed:@"y1_b"];
        [_moreButton addSubview:imageView];
        [_moreButton addTarget:self action:@selector(moreAllocateStorage) forControlEvents:UIControlEventTouchUpInside];
        [_AllocateStoragebgView addSubview:_moreButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _ddhLabel.text = [NSString stringWithFormat:@"单号:%@",[_dic valueForKey:@"col0"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col1"]];
    
    _movefrom.text = [NSString stringWithFormat:@"移出仓库:%@",[_dic valueForKey:@"col2"]];
    
    _movein.text = [NSString stringWithFormat:@"移入仓库:%@",[_dic valueForKey:@"col3"]];

    
    if ([[_dic valueForKey:@"isexam"] boolValue] == 1) {
        [_sureButton removeTarget:self action:@selector(revokeorderAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
    } else {
        [_sureButton removeTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton addTarget:self action:@selector(revokeorderAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:@"取消确认" forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < 4; i++) {
        _messageheaderLabel = [_AllocateStoragebgView viewWithTag:43310 + i];
        _messagebodyLabel = [_AllocateStoragebgView viewWithTag:43320 + i];
        if (i == 0) {
            _messageheaderLabel.text = @"数量:";
            _messagebodyLabel.text = [NSString stringWithFormat:@"%@台",[_dic valueForKey:@"col4"]];
        } else if (i == 1) {
            _messageheaderLabel.text = @"金额:";
            _messagebodyLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col5"]];
        } else if (i == 2) {
            _messageheaderLabel.text = @"制单人:";
            _messagebodyLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col7"]];
        } else if (i == 3) {
            _messageheaderLabel.text = @"制单日期:";
            NSString *fulldate = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col8"]];
            fulldate = [fulldate substringWithRange:NSMakeRange(5, fulldate.length - 5)];
            _messagebodyLabel.text = fulldate;
        }
    }
}

- (void)orderAction
{
    if ([self.ViewController isqxToexamineorRevokeWithString:@"cz_dbrk" Isexamine:@"ph"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllocateStorageSure" object:[_dic valueForKey:@"col0"]];
    } else {
        [BasicControls showAlertWithMsg:@"您没有权限" addTarget:nil];
    }
}

- (void)revokeorderAction
{
    if ([self.ViewController isqxToexamineorRevokeWithString:@"cz_dbrk" Isexamine:@"pch"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAllocateStorageSure" object:[_dic valueForKey:@"col0"]];
    } else {
        [BasicControls showAlertWithMsg:@"您没有权限" addTarget:nil];
    }
}

- (void)moreAllocateStorage
{
    MoreAllocateStorageViewController *moreAllocateStorageVC = [[MoreAllocateStorageViewController alloc] init];
    moreAllocateStorageVC.djh = [self.dic valueForKey:@"col0"];
    [self.ViewController.navigationController pushViewController:moreAllocateStorageVC animated:YES];
}

@end
