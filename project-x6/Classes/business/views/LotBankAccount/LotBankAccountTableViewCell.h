//
//  LotBankAccountTableViewCell.h
//  project-x6
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotBankAccountTableViewCell : UITableViewCell
{
    UIView *_LotBankAccountBgView;
    UILabel *_dhLabel;           //单号
    UILabel *_dateLabel;         //日期
    
    UILabel *_titleLabel;
    UILabel *_textLabel;
    
    UIImageView *_leadView;
    
}

@property(nonatomic,strong)NSDictionary *dic;
@end
