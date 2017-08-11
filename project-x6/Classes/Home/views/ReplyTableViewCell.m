//
//  ReplyTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ReplyTableViewCell.h"

@implementation ReplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        //初始化子视图
        _headerView = [[UIButton alloc] initWithFrame:CGRectZero];
        _headerView.titleLabel.font = ExtitleFont;
        [self.contentView addSubview:_headerView];
        
        cornerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        cornerImage.image = [UIImage imageNamed:@"corner_circle"];
        [self.contentView addSubview:cornerImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = MainFont;
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = ExtitleFont;
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.lineSpacing = 6;
        _contentLabel.font = MainFont;
        _contentLabel.numberOfLines = 0;
        _contentLabel.isNeedAtAndPoundSign = YES;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributes = @{NSFontAttributeName:MainFont,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [[_dic valueForKey:@"content"] boundingRectWithSize:CGSizeMake(KScreenWidth - 69, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    //判断评论人是否为发布人自己
    NSNumber *ficfb = [self.dic valueForKey:@"zdrdm"];
    if (_faburen == [ficfb longLongValue]) {
        //所有的子视图位置靠右
        _headerView.frame = CGRectMake(KScreenWidth - 49, 10, 39, 39);
        cornerImage.frame = CGRectMake(KScreenWidth - 51.5, 7.5, 44, 44);
        _nameLabel.frame = CGRectMake(10, _headerView.top + 2, KScreenWidth - 69, 20);
        _nameLabel.textAlignment = NSTextAlignmentRight;
        
        _timeLabel.frame = CGRectMake(0, _nameLabel.bottom + 3, _nameLabel.width, 16);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        _contentLabel.frame = CGRectMake(10, _headerView.bottom + 15, KScreenWidth - 69, size.height);
        _contentLabel.textAlignment = NSTextAlignmentRight;
        
    } else {
        //所有的子视图位置靠左
        _headerView.frame = CGRectMake(10, 10, 39, 39);
        cornerImage.frame = CGRectMake(7.5, 7.5, 44, 44);
        _nameLabel.frame = CGRectMake(_headerView.right + 10, _headerView.top + 2, KScreenWidth - 69, 20);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        
        _timeLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 3, _nameLabel.width, 16);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        
        _contentLabel.frame = CGRectMake(_nameLabel.left, _headerView.bottom + 15, KScreenWidth - 69, size.height);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    //通过usertype判断员工还是营业员
    NSString *headerURLString = nil;
    NSString *headerpic = [self.dic valueForKey:@"userpic"];
    if (headerpic.length == 0) {
        NSArray *array = HeaderBgColorArray;
        
        int x = arc4random() % 10;
        [_headerView setBackgroundColor:(UIColor *)array[x]];
        NSString *lastTwoName = self.dic[@"name"];
        lastTwoName = [BasicControls judgeuserHeaderImageNameLenghNameString:lastTwoName];
        [_headerView setTitle:lastTwoName forState:UIControlStateNormal];
    } else {
        if ([[self.dic valueForKey:@"userType"] intValue] == 0) {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[self.dic valueForKey:@"userpic"]];
        } else {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[self.dic valueForKey:@"userpic"]];
        }
        NSURL *headerURL = [NSURL URLWithString:headerURLString];
        if (headerURL) {
            [_headerView sd_setBackgroundImageWithURL:headerURL forState:UIControlStateNormal placeholderImage:nil options:SDWebImageLowPriority];
            [_headerView setTitle:@"" forState:UIControlStateNormal];
        }
        
    }
    _nameLabel.text = [_dic valueForKey:@"name"];
    
    _timeLabel.text = [[_dic valueForKey:@"fsrq"] substringFromIndex:5];
    
    _contentLabel.emojiText = [_dic valueForKey:@"content"];
}


@end
