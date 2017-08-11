//
//  StockViewController.h
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"


@interface StockViewController : BaseViewController

@property(nonatomic,strong)NSArray *datalist;          //联系人数据
@property(nonatomic,strong)NSArray *gwdatalist;        //岗位数据
@property(nonatomic,strong)NSArray *kuangjiadatalist;  //框架数据
@property(nonatomic,assign)BOOL type;                  //判断当前页面的来源是写动态
@property(nonatomic,assign)BOOL replytype;             //判断当前页面的来源是回复动态
@property(nonatomic,assign)BOOL BusinessSCDetailType;  //判断当前页面的来源是回复动态

- (void)networkChanged:(EMConnectionState)connectionState;

@end
