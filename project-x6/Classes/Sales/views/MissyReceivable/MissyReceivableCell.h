//
//  MissyReceivableCell.h
//  project-x6
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissyReceivableCell : UITableViewCell
{
    UIView *_bgView;
    UIImageView *_imageView;
    UILabel *_customerLabel;
    
    UILabel *_textLabel;
    UILabel *_kemuLabel;
    UILabel *_messageLabel;
    
    UILabel *_dateLabel;
    
}
@property(nonatomic,copy)NSDictionary *dic;
@end
