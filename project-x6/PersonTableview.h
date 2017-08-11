//
//  PersonTableview.h
//  project-x6
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTableview : UITableView<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,copy)NSMutableArray *datalist;

@property(nonatomic,copy)NSString *name;
@end
