//
//  TodayNoleaderTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayNoleaderTableViewCell : UITableViewCell
{
    UILabel *_label;
    UILabel *_moneylabel;
    UIButton *_librarybitbutton;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
