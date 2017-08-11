//
//  AllocateStorageTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllocateStorageTableViewCell : UITableViewCell
{
    UIView *_AllocateStoragebgView;               //背景
    UILabel *_ddhLabel;                           //单号
    UILabel *_dateLabel;                          //日期
    UIView *_lowlineView;                         //横向间隔
    UIView *_highlineView;                        //纵向间隔
    UILabel *_movefrom;                           //移出仓库
    UILabel *_movein;                             //移入仓库

    UILabel *_messageheaderLabel;                 //详情
    UILabel *_messagebodyLabel;                   //详情
    UIButton *_sureButton;                        //确认按钮
    
    UIButton *_moreButton;                         //详情按钮
}

@property(nonatomic,copy)NSDictionary *dic;
@end
