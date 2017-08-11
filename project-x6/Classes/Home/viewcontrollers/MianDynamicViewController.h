//
//  MianDynamicViewController.h
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "ReplyTableView.h"

@interface MianDynamicViewController : BaseViewController<UITextFieldDelegate>

{
    UIView *_alphaView;                 //半透明遮罩
    UIView *_replyView;                 //底部回复view
    UITextView *_textfield;            //输入框
    double _page;                       //页码
    double _pages;                      //所有的数据
    UIButton *_collectButton;           //收藏
    UILabel *_collectLabel;             //收藏文字
    UIImageView *_bgView;
    ReplyTableView *_replyTableView;    //回复列表
    UILabel *_reLabel;
    
    int _clickcount;
}

@property(nonatomic,strong)NSDictionary *dic;    //动态详情数据
@property(nonatomic,strong)NSArray *datalist;    //回复列表数据
@property(nonatomic,strong)NoDataView *nodataView;

@end
