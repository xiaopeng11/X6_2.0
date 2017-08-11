//
//  HomeTableViewCell.h
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeTableViewCell : UITableViewCell<UIActionSheetDelegate>


@property (nonatomic, weak) NSDictionary *data;

- (void)draw;
- (void)clear;
- (void)releaseMemory;
@end
