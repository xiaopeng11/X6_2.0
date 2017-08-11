//
//  WholesaleTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WholesaleTableViewCell : UITableViewCell

{
    UIView *_wholesalebg;
    UIImageView *_headerViewbg;
    UIButton *_userHeaderButton;
    UILabel *_titleLabel;
    UILabel *_nameLabel;
    UILabel *_Label;
}

@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,copy)NSString *soucre;
@end
