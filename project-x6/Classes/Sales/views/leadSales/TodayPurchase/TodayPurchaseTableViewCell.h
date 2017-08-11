//
//  TodayPurchaseTableViewCell.h
//  project-x6
//
//  Created by Apple on 2016/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayPurchaseTableViewCell : UITableViewCell

{
    UIView *_todayPurchaseBgview;
    UIImageView *_imageView;
    UILabel *_label;
    
    UILabel *_titleLabel;
    UILabel *_textLabel;
}
@property(nonatomic,copy)NSDictionary *dic;
@end
