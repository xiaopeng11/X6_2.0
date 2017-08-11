//
//  PicsTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/8/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PicsTableViewCell.h"
#import "PicsViewController.h"
#import "XPPhotoViews.h"

#define picWidth ((KScreenWidth - 124) / 3.0)

@implementation PicsTableViewCell

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
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;

        _daylabelView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 70, picWidth)];
        [self.contentView addSubview:_daylabelView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        CGFloat high = [[_dic valueForKey:@"float"] floatValue];
        _imageView.frame = CGRectMake(90, 20, KScreenWidth - 114, high);
        NSMutableArray *pics = [_dic valueForKey:@"data"];
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *diced = [userdefaults objectForKey:X6_UserMessage];
        NSString *companyString = [diced objectForKey:@"gsdm"];
        NSMutableArray *picsURL = [NSMutableArray array];
        for (NSDictionary *picdic in pics) {
            NSString *imageurlString = [picdic objectForKey:@"filename"];
            NSString *picURLString = [NSString stringWithFormat:@"%@%@/%@",X6_personMessage,companyString,imageurlString];
            [picsURL addObject:picURLString];
        }
        XPPhotoViews *photos = [[XPPhotoViews alloc] initWithFrame:_imageView.bounds];
        photos.picwid = picWidth;
        photos.picsArray = picsURL;
        [_imageView addSubview:photos];
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString *dateString = [_dic valueForKey:@"date"];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *todayDateString = [dateFormatter stringFromDate:today];
    todayDateString = [todayDateString substringToIndex:10];
    NSString *thisyear = [todayDateString substringToIndex:4];
    if ([dateString isEqualToString:todayDateString]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"今天";
        [_daylabelView addSubview:label];
    } else {
        UILabel *daylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        daylabel.text = [dateString substringWithRange:NSMakeRange(8, 2)];
        daylabel.font = [UIFont boldSystemFontOfSize:22];
        [_daylabelView addSubview:daylabel];
        UILabel *month = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 40, 20)];
        month.textAlignment = NSTextAlignmentLeft;
        NSString *monthString = [dateString substringWithRange:NSMakeRange(5, 2)];
        if ([monthString integerValue] == 1) {
            month.text = @"一月";
        } else if ([monthString integerValue] == 2) {
            month.text = @"二月";
        } else if ([monthString integerValue] == 3) {
            month.text = @"三月";
        } else if ([monthString integerValue] == 4) {
            month.text = @"四月";
        } else if ([monthString integerValue] == 5) {
            month.text = @"五月";
        } else if ([monthString integerValue] == 6) {
            month.text = @"六月";
        } else if ([monthString integerValue] == 7) {
            month.text = @"七月";
        } else if ([monthString integerValue] == 8) {
            month.text = @"八月";
        } else if ([monthString integerValue] == 9) {
            month.text = @"九月";
        } else if ([monthString integerValue] == 10) {
            month.text = @"十月";
        } else if ([monthString integerValue] == 11) {
            month.text = @"十一月";
        } else if ([monthString integerValue] == 12) {
            month.text = @"十二月";
        }
        month.font = ExtitleFont;
        [_daylabelView addSubview:month];
        if (![[dateString substringToIndex:4] isEqualToString:thisyear]) {
            UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 70, 30)];
            yearLabel.text = [dateString substringToIndex:4];
            yearLabel.textAlignment = NSTextAlignmentRight;
            yearLabel.font = [UIFont systemFontOfSize:22];
            [_daylabelView addSubview:yearLabel];
        }
    }
}

@end
