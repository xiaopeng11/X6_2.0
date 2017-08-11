//
//  BusinessSCDetailModel.h
//  project-x6
//
//  Created by Apple on 2016/10/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessSCDetailModel : NSObject
@property(nonatomic,copy)NSString *col0;   //单据号
@property(nonatomic,copy)NSString *col1;   //发生日期
@property(nonatomic,copy)NSString *col2;   //商品名称
@property(nonatomic,copy)NSString *col3;   //商品全称
@property(nonatomic,copy)NSNumber *col4;   //数量
@property(nonatomic,copy)NSNumber *col5;   //金额

@end
