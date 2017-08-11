//
//  HomeTableView.h
//  project-x6
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,assign)BOOL isMyDynamic;

@end
