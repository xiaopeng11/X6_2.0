//
//  OutboundTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OutboundTableViewCell.h"

@implementation OutboundTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        
        _userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userHeaderButton.frame = CGRectMake(10, 15, 30, 30);
        _userHeaderButton.enabled = NO;
        _userHeaderButton.clipsToBounds = YES;
        _userHeaderButton.layer.cornerRadius = 15;
        _userHeaderButton.titleLabel.font = ExtitleFont;
        [self.contentView addSubview:_userHeaderButton];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, KScreenWidth - 50 - 100, 20)];
        _label.font = ExtitleFont;
        [self.contentView addSubview:_label];
        
        _lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 52 - 80, 20, 80, 20)];
        _lastLabel.textAlignment = NSTextAlignmentRight;
        _lastLabel.font = ExtitleFont;
        [self.contentView addSubview:_lastLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    
    //设置属性
    //头像
    //通过usertype判断员工还是营业员
    NSString *headerURLString = nil;
    NSString *headerpic = [_dic valueForKey:@"userpic"];
    if (headerpic.length == 0) {
        NSArray *array = HeaderBgColorArray;
        
        int x = arc4random() % 10;
        [_userHeaderButton setBackgroundColor:(UIColor *)array[x]];
        NSString *lastTwoName = _dic[@"col0"];
        lastTwoName = [BasicControls judgeuserHeaderImageNameLenghNameString:lastTwoName];
        [_userHeaderButton setTitle:lastTwoName forState:UIControlStateNormal];
    } else {
        headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[_dic valueForKey:@"userpic"]];
        NSURL *headerURL = [NSURL URLWithString:headerURLString];
        if (headerURLString) {
            [_userHeaderButton sd_setBackgroundImageWithURL:headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
            [_userHeaderButton setTitle:@"" forState:UIControlStateNormal];
        }
        
    }

    _label.text = [_dic valueForKey:@"col0"];
    _lastLabel.text = [NSString stringWithFormat:@"异常%@次",[_dic valueForKey:@"col2"]];
}
@end
