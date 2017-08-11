//
//  FirstPersonTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/7/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FirstPersonTableViewCell.h"
#import "ChangeHeaderViewViewController.h"

@implementation FirstPersonTableViewCell

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
        
        _topheaderbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 70)];
        _topheaderbgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_topheaderbgView];
        
        _headerView = [[UIButton alloc] initWithFrame:CGRectMake(10, 12.5, 45, 45)];
        _headerView.clipsToBounds = YES;
        _headerView.layer.cornerRadius = 22.5;
        _headerView.titleLabel.font = ExtitleFont;
        [_headerView addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topheaderbgView addSubview:_headerView];
        
        for (int i = 0; i < 2; i++) {
            if (i == 0) {
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, KScreenWidth - 75, 20)];
                _messageLabel.font = MainFont;
            } else {
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 42, KScreenWidth - 75, 16)];
                _messageLabel.font = ExtitleFont;
                _messageLabel.textColor = ExtraTitleColor;
            }
            _messageLabel.tag = 45000 + i;
            [_topheaderbgView addSubview:_messageLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //取出个人数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    //公司代码
    NSString *gsdm = [userInformation objectForKey:@"gsdm"];
    NSString *ygImageUrl = [userInformation objectForKey:@"userpic"];

    for (int i = 0; i < 2; i++) {
        _messageLabel = (UILabel *)[self.contentView viewWithTag:45000 + i];
        if (i == 0) {
            _messageLabel.text = [userInformation objectForKey:@"name"];
        } else {
            _messageLabel.text = [NSString stringWithFormat:@"%@  %@",[userInformation objectForKey:@"ssgsname"],[userInformation objectForKey:@"gw"]];
        }
    }
    
    
    //设置属性
    //头像
    //通过usertype判断员工还是营业员
    NSString *headerURLString = nil;
    if (ygImageUrl.length == 0) {
        NSArray *array = HeaderBgColorArray;
        int x = arc4random() % 10;
        [_headerView setBackgroundColor:(UIColor *)array[x]];
        NSString *lastTwoName = [userInformation objectForKey:@"name"];
        lastTwoName = [BasicControls judgeuserHeaderImageNameLenghNameString:lastTwoName];
        [_headerView setTitle:lastTwoName forState:UIControlStateNormal];

    } else {
        if ([[userInformation allKeys] containsObject:@"apppwd"]) {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,[userInformation valueForKey:@"userpic"]];
        } else {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,gsdm,[userInformation valueForKey:@"userpic"]];
        }
        if (headerURLString) {
            [_headerView sd_setBackgroundImageWithURL:[NSURL URLWithString:headerURLString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
            [_headerView setTitle:@"" forState:UIControlStateNormal];
        }
    }

}


#pragma mark -  点击事件
- (void)headerAction:(UIButton *)button
{
    //跳转到修改图片界面
    ChangeHeaderViewViewController *changeHeaderViewVC = [[ChangeHeaderViewViewController alloc] init];
    
    [self.ViewController.navigationController pushViewController:changeHeaderViewVC animated:YES];
    
}
@end
