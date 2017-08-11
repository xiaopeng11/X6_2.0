//
//  BusinessSCTableViewCell.h
//  project-x6
//
//  Created by Apple on 2016/10/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessSCTableViewCell : UITableViewCell

{
    UILabel *_titleLabel;
    UILabel *_isMoneyDefaultLabel;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
