//
//  SupplierModel.h
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplierModel : NSObject
@property(nonatomic,copy)NSNumber *supplierid;  //对象id
@property(nonatomic,copy)NSString *name;        //名称
@property(nonatomic,copy)NSString *lxr;         //联系人
@property(nonatomic,copy)NSNumber *lxhm;        //联系号码
@property(nonatomic,copy)NSString *dz;          //地址
@property(nonatomic,copy)NSString *comments;    //备注
@property(nonatomic,copy)NSNumber *yfje;        //应付金额

@end
