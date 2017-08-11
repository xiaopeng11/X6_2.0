//
//  SecondPersonTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/7/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondPersonTableViewCell : UITableViewCell

{
    UIImageView *_imageView;
    UILabel *_label;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
