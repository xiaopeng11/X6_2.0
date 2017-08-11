//
//  GwsPersonsViewController.h
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface GwsPersonsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,copy)NSArray *datalist;     //联系人数据
@property(nonatomic,copy)NSArray *gwdatalist;     //岗位数据
@property(nonatomic,copy)NSArray *comdatalist; 
@property(nonatomic,copy)NSString *titleName;    //标题


@property(nonatomic,assign)BOOL type;       //判断当前页面的来源
@property(nonatomic,assign)BOOL replytype;       //判断当前页面的来源
@property(nonatomic,assign)BOOL BusinessSCDetailType;  //判断当前页面的来源是回复动态

@end
