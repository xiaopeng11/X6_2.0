//
//  OutboundDetailTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutboundDetailTableViewCell : UITableViewCell
{
    UIView *_outboundDetailbgView;                 //背景
    UILabel *_rkdhLabel;             //单号
    UILabel *_dateLabel;             //日期
    UIImageView *_imageView;
    UILabel *_label;
    
    UILabel *_nameLabel;             //名称
    UILabel *_messageLabel;          //详情
    
    UIButton *_ignoreOutboundDetailButton;

}


@property(nonatomic,copy)NSDictionary *dic;
@end
