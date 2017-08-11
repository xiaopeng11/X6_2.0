//
//  SubscrbedetailTableViewCell.h
//  project-x6
//
//  Created by Apple on 2016/10/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscrbedetailTableViewCell : UITableViewCell

{
    UIView *_Subscrbedetailbgview;
    
    UIView *_titleNameBgView;
    UILabel *_titleNameLabel;
    
    UIView *_textBgView;
    UILabel *_textLabel;
    
    UIButton *_moreMesageButton;
    UILabel *_buttonLabel;
}
@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,assign)NSInteger type;

@end
