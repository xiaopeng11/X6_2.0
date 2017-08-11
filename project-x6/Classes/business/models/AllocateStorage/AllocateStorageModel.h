//
//  AllocateStorageModel.h
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllocateStorageModel : NSObject

@property(nonatomic,copy)NSString *col0;   //单据号
@property(nonatomic,copy)NSString *col1;   //日期
@property(nonatomic,copy)NSString *col2;   //移出仓库
@property(nonatomic,copy)NSString *col3;   //移入仓库
@property(nonatomic,copy)NSNumber *col4;   //总数量
@property(nonatomic,copy)NSNumber *col5;   //总金额
@property(nonatomic,copy)NSNumber *col6;   //制单人代码
@property(nonatomic,copy)NSString *col7;   //制单人名称
@property(nonatomic,copy)NSString *col8;   //制单日期
@end
