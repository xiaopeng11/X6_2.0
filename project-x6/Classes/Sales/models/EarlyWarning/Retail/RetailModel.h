//
//  RetailModel.h
//  project-x6
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetailModel : NSObject

@property(nonatomic,copy)NSNumber *col0;    //ID
@property(nonatomic,copy)NSNumber *col1;    //单据号
@property(nonatomic,copy)NSString *col2;    //出库日期
@property(nonatomic,copy)NSString *col3;    //门店名称
@property(nonatomic,copy)NSString *col4;    //营业员名称
@property(nonatomic,copy)NSString *col5;    //营业员头像
@property(nonatomic,copy)NSNumber *col6;    //串号
@property(nonatomic,copy)NSString *col7;    //商品名称
@property(nonatomic,copy)NSNumber *col8;    //单价
@property(nonatomic,copy)NSNumber *col9;    //零售限价
@property(nonatomic,copy)NSNumber *col10;    //忽略标志

@end
