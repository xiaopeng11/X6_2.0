//
//  DepositWhetherOrderTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/8/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepositWhetherOrderTableViewCell : UITableViewCell

{
    
    UIView *_depositViewBg;       //背景
    
    UIView *_LineView;            //分割线
    
    UILabel *_danhaoLabel;        //单号
    UILabel *_dateLabel;          //日期
    
    UIImageView *_headerView;     //图片
    UILabel *_messageLabel;       //主题
    
    UILabel *_acountLabel;        //帐户
    UILabel *_moneyTitleLabel;    //金额标题
    UILabel *_moneyLabel;         //金额
    UILabel *_totalTitleLabel;    //总金额标题
    UILabel *_totalMoney;         //总金额
    
    UIButton *_deleteButton;      //删除按钮
    
}

@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,copy)NSString *orderDeposit;
@end
