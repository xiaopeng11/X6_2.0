//
//  TakeInventoryModel.h
//  project-x6
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeInventoryModel : NSObject
@property(nonatomic,copy)NSNumber *takeInventoryid;   //id
@property(nonatomic,copy)NSNumber *ssgsid;            //所属公司id
@property(nonatomic,copy)NSString *djh;               //单号
@property(nonatomic,copy)NSString *fsrq;              //盘点日期
@property(nonatomic,copy)NSString *pdfw;              //盘点范围
@property(nonatomic,copy)NSString *sws;               //实物多
@property(nonatomic,copy)NSString *swd;               //实物少
@property(nonatomic,copy)NSString *comments1;         //摘要
@property(nonatomic,copy)NSString *comments2;         //审批说明
@property(nonatomic,copy)NSString *shrq;              //审批日期
@property(nonatomic,copy)NSString *shjg;              //审批结果
@property(nonatomic,copy)NSNumber *zdrdm;              //制单人代码
@property(nonatomic,copy)NSString *zdrmc;              //制单名称
@property(nonatomic,copy)NSNumber *shrdm;              //审批人代码
@property(nonatomic,copy)NSString *shrmc;              //审批状态
@property(nonatomic,copy)NSString *djzt;               //审批状态
@property(nonatomic,copy)NSString *zdrq;               //制单日期

@end
