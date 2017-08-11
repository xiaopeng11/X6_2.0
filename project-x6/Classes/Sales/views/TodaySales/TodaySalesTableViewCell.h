//
//  TodaySalesTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodaySalesTableViewCell : UITableViewCell

{
    UIImageView *_titleImageView;
    UILabel *_titleLabel;
    UILabel *_nameLabel;
    UILabel *_Label;
    UIView *_lineView;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
