//
//  VIPTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPTableViewCell : UITableViewCell

{
    UIView *_VIPbgView;
    UILabel *_companyLabel;     //所属公司
    UIButton *_moreVipButton;   //用户详情
    UILabel *_titleLabel;
    UILabel *_messageLabel;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
