//
//  SupplierTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplierTableViewCell : UITableViewCell

{
    
    UIView *_SupplierBgView;
    UILabel *_supplierName;    //名称
    UILabel *_moreMessageLabel;//详情
    UIImageView *_leaderView;  //箭头
    
    UILabel *_needPayMoney;    //应付款
    UILabel *_moneyLabel;      //金额
    
    UIImageView *_imageView;       //联系人
    UILabel *_label;      //电话号码
}

@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,assign)BOOL issupplier;
@end
