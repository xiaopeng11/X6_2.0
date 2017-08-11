//
//  CapitalControlTableViewCell.h
//  project-x6
//
//  Created by Apple on 2016/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CapitalControlTableViewCell : UITableViewCell

{
    UIView *_CapitalControlBgView;
    UILabel *_dhLabel;           //单号
    UILabel *_dateLabel;         //日期
    UILabel *_gstitleLabel;      //公司
    UILabel *_gsLabel;           //公司名
    UILabel *_accounttitleLabel; //账户
    UILabel *_accountLabel;      //账户名
    UILabel *_commenttitleLabel; //
    UILabel *_commentLabel;      //备注
    
    UILabel *_titleLabel;
    UILabel *_textLabel;
    
    UIImageView *_leadView;
    
    UIButton *_deleteButton;      //删除
    
}

@property(nonatomic,strong)NSDictionary *dic;

@end
