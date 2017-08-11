//
//  AcuntAndMoneyTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcuntAndMoneyTableViewCell : UITableViewCell

{
    UILabel *_acountLabel;
    UILabel *_moneyLabel;
}

@property(nonatomic,copy)NSDictionary *dic;

@end
