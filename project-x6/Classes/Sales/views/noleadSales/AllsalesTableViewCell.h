//
//  AllsalesTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllsalesTableViewCell : UITableViewCell

{
    UILabel *_indexlabel;
    UILabel *_nameLabel;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
