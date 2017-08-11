//
//  OldlibraryModel.h
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldlibraryModel : NSObject

@property(nonatomic,copy)NSNumber *col0;  //供应商代码
@property(nonatomic,copy)NSString *col1;  //供应商名称
@property(nonatomic,copy)NSNumber *col2;  //商品代码
@property(nonatomic,copy)NSString *col3;  //商品全称
@property(nonatomic,copy)NSNumber *col4;  //库龄
@property(nonatomic,copy)NSNumber *col5;  //库龄逾期
@property(nonatomic,copy)NSNumber *col6;  //数量
@property(nonatomic,copy)NSNumber *col7;  //金额

@end
