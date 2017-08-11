//
//  PicsTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/8/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicsTableViewCell : UITableViewCell

{
    UIView *_daylabelView;
    UIImageView *_imageView;
    
}

@property(nonatomic,strong)NSDictionary *dic;
@end
