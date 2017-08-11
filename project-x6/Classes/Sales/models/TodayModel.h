//
//  TodayModel.h
//  project-x6
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayModel : NSObject
/**
 *   {
 col0 = 000100040004;
 col1 = "\U534e\U5c71";
 col2 = 1;
 col3 = 20000;
 col4 = 19000;
 }
 */

@property(nonatomic,copy)NSNumber *col0;  //门店编码
@property(nonatomic,copy)NSString *col1;  //门店名称
@property(nonatomic,copy)NSNumber *col2;  //数量
@property(nonatomic,copy)NSNumber *col3;  //金额
@property(nonatomic,copy)NSNumber *col4;  //毛利

@end
