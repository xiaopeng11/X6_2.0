//
//  HeaderViewController.h
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
@interface HeaderViewController : BaseViewController

@property(nonatomic,strong)NSDictionary *dic;        //个人数据
@property(nonatomic,strong)NSArray *datalist;        //个人动态
@property(nonatomic,assign)BOOL type;                //判断页面
@end
