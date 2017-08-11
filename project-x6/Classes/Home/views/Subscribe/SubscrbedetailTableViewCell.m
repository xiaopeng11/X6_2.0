//
//  SubscrbedetailTableViewCell.m
//  project-x6
//
//  Created by Apple on 2016/10/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SubscrbedetailTableViewCell.h"
#import "SubscribeByStoreViewController.h"

@implementation SubscrbedetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = nil;
        
        _Subscrbedetailbgview = [[UIView alloc] initWithFrame:CGRectZero];
        _Subscrbedetailbgview.backgroundColor = GrayColor;
        _Subscrbedetailbgview.userInteractionEnabled = YES;
        [self.contentView addSubview:_Subscrbedetailbgview];
        
        _titleNameBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 20, 45)];
        [_Subscrbedetailbgview addSubview:_titleNameBgView];
        
        _titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 30, 25)];
        _titleNameLabel.font = MainFont;
        _titleNameLabel.textColor = [UIColor whiteColor];
        [_Subscrbedetailbgview addSubview:_titleNameLabel];

        
        _moreMesageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreMesageButton.backgroundColor = GrayColor;
        [_moreMesageButton addTarget:self action:@selector(SubscribeByStore) forControlEvents:UIControlEventTouchUpInside];
        [_Subscrbedetailbgview addSubview:_moreMesageButton];
        
        _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 137.5, 10, 90, 25)];
        _buttonLabel.font = MainFont;
        _buttonLabel.text = @"门店详情";
        _buttonLabel.backgroundColor = GrayColor;
        _buttonLabel.textAlignment = NSTextAlignmentRight;
        [_moreMesageButton addSubview:_buttonLabel];
        UIImageView *buttonimageview = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 37.5, 15, 7.5, 15)];
        buttonimageview.image = [UIImage imageNamed:@"y1_b"];
        [_moreMesageButton addSubview:buttonimageview];
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        
        NSArray *data = [self.dic valueForKey:@"data"];
        
        _Subscrbedetailbgview.frame = CGRectMake(10, 10, KScreenWidth - 20, 45 + 47.5 * (data.count + 1));
        
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
        
        _moreMesageButton.frame = CGRectMake(0, _Subscrbedetailbgview.size.height - 45, KScreenWidth - 20, 45);

    }
}

- (void)setType:(NSInteger)type
{
    if (_type != type) {
        _type = type;
        if (_type == 1) {
            _titleNameBgView.backgroundColor = ColorRGB(239, 127, 175);
            _titleNameLabel.text = [NSString stringWithFormat:@"%@日报",[self.dic valueForKey:@"date"]];
        } else if (_type == 2) {
            _titleNameBgView.backgroundColor = ColorRGB(243, 134, 1);
            _titleNameLabel.text = [NSString stringWithFormat:@"%@周报",[self.dic valueForKey:@"date"]];
        } else if (_type == 3) {
            _titleNameBgView.backgroundColor = ColorRGB(53, 184, 158);
            _titleNameLabel.text = [NSString stringWithFormat:@"%@月报",[self.dic valueForKey:@"date"]];
        }
        _buttonLabel.textColor = _titleNameBgView.backgroundColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)SubscribeByStore
{
    SubscribeByStoreViewController *SubscribeByStoreVC = [[SubscribeByStoreViewController alloc] init];
    SubscribeByStoreVC.dateString = [self.dic valueForKey:@"date"];
    SubscribeByStoreVC.type = self.type;
    [self.ViewController.navigationController pushViewController:SubscribeByStoreVC animated:YES];
}

@end
