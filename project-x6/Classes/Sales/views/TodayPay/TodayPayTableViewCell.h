//
//  TodayPayTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayPayTableViewCell : UITableViewCell

{
    UIView *_bgView;
    UIImageView *_headerView;
    UILabel *_headerLabel;
    
    UILabel *_label;
    UILabel *_nameLabel;
}
@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,copy)NSString *source;
@end
