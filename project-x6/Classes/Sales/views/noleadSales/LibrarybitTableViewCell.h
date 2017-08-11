//
//  LibrarybitTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibrarybitTableViewCell : UITableViewCell

{
    UILabel *_WarehouseLabel;
    UILabel *_goodNumLabel;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
