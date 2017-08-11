//
//  MyacountTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyacountTableViewCell : UITableViewCell

{
    UIView *_bgView;
    UIImageView *_imageView;
    UILabel *_bankLabel;
    
    UILabel *_acountNameLabel;
    UILabel *_myacountLabel;
    
    
}
@property(nonatomic,copy)NSDictionary *dic;
@end
