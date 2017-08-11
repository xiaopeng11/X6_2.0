//
//  AllDynamicViewController.h
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeTableView.h"
@interface AllDynamicViewController : BaseViewController

@property(nonatomic,strong)HomeTableView *tableView;
@property(nonatomic,strong)NoDataView *nodataView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSTimer *URLtimer;

@end
