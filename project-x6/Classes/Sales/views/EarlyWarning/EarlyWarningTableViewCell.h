//
//  EarlyWarningTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarlyWarningTableViewCell : UITableViewCell

{
    UIImageView *_image;
    UILabel *_label;
    UIView *_lineView;
    UIImageView *_leaderView;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
