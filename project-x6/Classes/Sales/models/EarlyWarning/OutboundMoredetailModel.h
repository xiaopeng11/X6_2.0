//
//  OutboundMoredetailModel.h
//  project-x6
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutboundMoredetailModel : NSObject

@property(nonatomic,copy)NSNumber *col0;  //记录id号
@property(nonatomic,copy)NSNumber *col1;  //单据号
@property(nonatomic,copy)NSString *col2;  //日期
@property(nonatomic,copy)NSString *col3;  //仓库名称
@property(nonatomic,copy)NSString *col4;  //制单人名称
@property(nonatomic,copy)NSString *col5;  //制单人头像
@property(nonatomic,copy)NSNumber *col6;  //串号
@property(nonatomic,copy)NSString *col7;  //机型
@property(nonatomic,copy)NSNumber *col8;  //忽略标志

@end
