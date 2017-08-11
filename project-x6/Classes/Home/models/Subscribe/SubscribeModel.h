//
//  SubscribeModel.h
//  project-x6
//
//  Created by Apple on 2016/10/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeModel : NSObject

@property(nonatomic,copy)NSString *col0;  //日期／商品类型／员工名称
@property(nonatomic,copy)NSNumber *col1;  //数量
@property(nonatomic,copy)NSNumber *col2;  //金额
@property(nonatomic,copy)NSNumber *col3;  //利润

@end
