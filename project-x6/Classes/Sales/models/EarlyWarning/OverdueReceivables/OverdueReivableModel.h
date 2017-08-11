//
//  OverdueReivableModel.h
//  project-x6
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OverdueReivableModel : NSObject

@property(nonatomic,copy)NSString *col0;          //日期
@property(nonatomic,copy)NSString *col1;          //单号
@property(nonatomic,copy)NSString *col2;          //科目
@property(nonatomic,copy)NSNumber *col3;          //客户代码
@property(nonatomic,copy)NSString *col4;          //客户名称
@property(nonatomic,copy)NSNumber *col5;          //金额
@property(nonatomic,copy)NSNumber *col6;          //逾期天数

@end
