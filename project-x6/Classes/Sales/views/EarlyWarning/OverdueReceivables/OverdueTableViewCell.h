//
//  OverdueTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverdueTableViewCell : UITableViewCell

{
    UIView *_OverduebgView;
    UIImageView *_kehuImageview;
    UILabel *_kuhuLabel;
    UILabel *_dateLabel;
    
    UILabel *_nameLabel;
    UILabel *_textLabel;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
