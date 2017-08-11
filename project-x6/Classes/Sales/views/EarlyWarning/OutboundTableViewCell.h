//
//  OutboundTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutboundTableViewCell : UITableViewCell

{
    UIButton *_userHeaderButton;        //用户头像
    UILabel *_label;
    UILabel *_lastLabel;
}
@property(nonatomic,copy)NSDictionary *dic;
@end
