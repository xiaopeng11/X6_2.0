//
//  InletandPinTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InletandPinTableViewCell : UITableViewCell

{
    
    UIView *_InletandPinbgView;
    UIImageView *_headerView;
    
    UILabel *_goodNameLabel;
    UILabel *_titleLabel;
    UILabel *_messageLabel;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
