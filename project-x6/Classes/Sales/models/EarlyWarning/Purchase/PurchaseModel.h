//
//  PurchaseModel.h
//  project-x6
//
//  Created by Apple on 16/3/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseModel : NSObject
@property(nonatomic,copy)NSNumber *col0;    //ID
@property(nonatomic,copy)NSNumber *col1;    //单据号
@property(nonatomic,copy)NSString *col2;    //采购日期
@property(nonatomic,copy)NSString *col3;    //供应商名称
@property(nonatomic,copy)NSString *col4;    //商品名称
@property(nonatomic,copy)NSNumber *col5;    //数量
@property(nonatomic,copy)NSNumber *col6;    //单价
@property(nonatomic,copy)NSNumber *col7;    //金额
@property(nonatomic,copy)NSNumber *col8;    //最后一次进价
@property(nonatomic,copy)NSNumber *col9;    //忽略

@end
