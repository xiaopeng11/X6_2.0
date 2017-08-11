//
//  WholesaleModel.h
//  project-x6
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WholesaleModel : NSObject

@property(nonatomic,copy)NSNumber *col0;     //业务员代码
@property(nonatomic,copy)NSString *col1;     //业务员名称
@property(nonatomic,copy)NSString *col2;     //业务员头像
@property(nonatomic,copy)NSNumber *col3;     //数量
@property(nonatomic,copy)NSNumber *col4;     //金额
@property(nonatomic,copy)NSNumber *col5;     //利润

@end
