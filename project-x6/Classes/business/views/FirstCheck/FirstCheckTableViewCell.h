//
//  FirstCheckTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstCheckTableViewCell : UITableViewCell

{
    UIView *_FirstCheckBgview;
    UILabel *_WarewhouseLabel;
    UILabel *_WarewhouseMessageLabel;
    UILabel *_FirstCheckLabel;
    UILabel *_FirstCheckMessageLabel;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
