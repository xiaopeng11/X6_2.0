//
//  SalesTableViewCell.h
//  project-x6
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesTableViewCell : UITableViewCell

{
    UILabel *_label;
    UIImageView *_imageview;
    UIView *_lineView;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
