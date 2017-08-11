//
//  LotBankAccountModel.h
//  project-x6
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotBankAccountModel : NSObject
@property(nonatomic,copy)NSNumber *col0;    //ID
@property(nonatomic,copy)NSString *col1;    //单据号
@property(nonatomic,copy)NSString *col2;    //发生日期
@property(nonatomic,copy)NSString *col3;    //所属公司名称
@property(nonatomic,copy)NSString *col4;    //账户名称
@property(nonatomic,copy)NSNumber *col5;    //金额
@property(nonatomic,copy)NSNumber *col6;    //应到账金额
@property(nonatomic,copy)NSNumber *col7;    //实际到账金额
@property(nonatomic,copy)NSNumber *col8;    //结算状态
@property(nonatomic,copy)NSNumber *col9;    //业务状态
@property(nonatomic,copy)NSString *col10;    //备注
@property(nonatomic,copy)NSString *col11;    //pos机

@end
