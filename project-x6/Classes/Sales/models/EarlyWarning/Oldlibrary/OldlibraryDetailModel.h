//
//  OldlibraryDetailModel.h
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldlibraryDetailModel : NSObject

@property(nonatomic,copy)NSNumber *col0;  //串号
@property(nonatomic,copy)NSString *col1;  //商品全称
@property(nonatomic,copy)NSString *col2;  //仓库名称
@property(nonatomic,copy)NSNumber *col3;  //库龄
@property(nonatomic,copy)NSNumber *col4;  //库龄逾期

@end
