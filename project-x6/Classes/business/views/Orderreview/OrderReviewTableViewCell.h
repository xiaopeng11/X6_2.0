//
//  OrderReviewTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderReviewTableViewCell : UITableViewCell
{
    UIView *_OrderbgView;               //背景
    UILabel *_ddhLabel;                 //订单号
    UILabel *_dateLabel;                //日期
    UIView *_lowlineView;               //横向间隔
    UIView *_highlineView;              //纵向间隔
    UIImageView *_gysImageView;         //供应商图片
    UILabel *_gysLabel;                 //供应商名
    UIImageView *_huopiImageview;       //货品图片
    UILabel *_huopinLabel;              //货品名
    UILabel *_messageheaderLabel;       //详情
    UILabel *_messagebodyLabel;         //详情
    UIButton *_orderButton;             //审核
}

@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,assign)BOOL iswhosalecell;
@end
