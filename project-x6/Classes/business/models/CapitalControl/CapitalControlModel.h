//
//  CapitalControlModel.h
//  project-x6
//
//  Created by Apple on 2016/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CapitalControlModel : NSObject

@property(nonatomic,copy)NSNumber *CapitalControlID;    //ID
@property(nonatomic,copy)NSString *djh;                 //单据号
@property(nonatomic,copy)NSString *fsrq;                //发生日期
@property(nonatomic,copy)NSNumber *je;                  //金额
@property(nonatomic,copy)NSNumber *jsrdm;               //经手人ID
@property(nonatomic,copy)NSString *jsrname;             //经手人name
@property(nonatomic,copy)NSNumber *ssgsid;              //所属公司ID
@property(nonatomic,copy)NSString *ssgsname;            //所属公司名称
@property(nonatomic,copy)NSNumber *zhid;                //调出账户ID
@property(nonatomic,copy)NSString *zhname;              //调出账户名称
@property(nonatomic,copy)NSNumber *zh1id;               //调入账户ID
@property(nonatomic,copy)NSString *zh1name;             //调入账户名称
@property(nonatomic,copy)NSString *comments;            //备注

@end
