//
//  AcountChooseTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcountChooseTableViewCell : UITableViewCell

{
    UILabel *_bankLabel;
    UILabel *_moneyLabel;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
