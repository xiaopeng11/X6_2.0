//
//  ReplyTableView.h
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)long fabuName;
@property(nonatomic,strong)NSArray *datalist;
@property(nonatomic,copy)NSString *replyCount;
@end
