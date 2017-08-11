//
//  SubscribeTableViewCell.h
//  project-x6
//
//  Created by Apple on 2016/10/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscribeTableViewCell : UITableViewCell
{
    UIView *_dateBgView;
    UILabel *_dateLabel;
    
    UIButton *_SubscribeButton;
    UILabel *_SubscribeLabel;
    UILabel *_deteedtailLabel;
    UILabel *_textLabel;
    UIImageView *_leadImageView;
}

@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,assign)NSInteger type;
@end
