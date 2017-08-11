//
//  OldlibraryTabelView.h
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OldlibraryTabelView : UITableViewCell

{
    UIView *_OldlibrarybgView;       //背景
    
    UIImageView *_imageView;
    UILabel *_label;
    
    UILabel *_nameLabel;             //名称
    UILabel *_messageLabel;          //详情
    UIButton *_button;

    
}

@property(nonatomic,copy)NSDictionary *dic;
@end
