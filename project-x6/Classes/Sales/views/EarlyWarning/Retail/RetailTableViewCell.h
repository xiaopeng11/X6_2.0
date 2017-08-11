//
//  RetailTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetailTableViewCell : UITableViewCell

{
    UIView *_RetailbgView;                 //背景
    UILabel *_rkdhLabel;             //入库单号
    UILabel *_dateLabel;             //日期
    UIImageView *_imageView;      //供应商图片
    UILabel *_label;              //供应商名
    
    UILabel *_nameLabel;             //名称
    UILabel *_messageLabel;          //详情
    UIButton *_ignoreRetailButton;

}

@property(nonatomic,copy)NSDictionary *dic;
@end
