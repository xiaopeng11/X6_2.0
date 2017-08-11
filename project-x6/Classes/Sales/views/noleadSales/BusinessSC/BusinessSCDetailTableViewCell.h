//
//  BusinessSCDetailTableViewCell.h
//  project-x6
//
//  Created by Apple on 2016/10/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessSCDetailTableViewCell : UITableViewCell

{
    UIView *_BusinessSCDetailbgView;               //背景
    UILabel *_ddhLabel;                            //订单号
    UILabel *_dateLabel;                           //日期
    UIView *_lowlineView;                          //间隔
    UIImageView *_phoneImageView;                  //手机图片
    UILabel *_phoneLabel;                          //手机名称
    UILabel *_numLabel;                             //利润
    UIView *_bottomLineView;                       //底部间隔
    UILabel *_totallrLabeltitle;                        //利润
    UILabel *_totallrLabel;                             //利润金额

}
@property(nonatomic,copy)NSDictionary *dic;
@end
