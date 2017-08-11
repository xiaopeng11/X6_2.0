//
//  CompanyPersonsViewController.h
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface CompanyPersonsViewController : BaseViewController

@property(nonatomic,copy)NSArray *datalist;  //联系人数据
@property(nonatomic,copy)NSMutableArray *kuangjiadatalist;  //框架数据
@property(nonatomic,copy)NSString *titleName;  //标题

@property(nonatomic,assign)BOOL type;       //判断当前页面的来源
@property(nonatomic,assign)BOOL replytype;       //判断当前页面的来源是回复动态
@property(nonatomic,assign)BOOL BusinessSCDetailType;  //判断当前页面的来源是回复动态


@end
