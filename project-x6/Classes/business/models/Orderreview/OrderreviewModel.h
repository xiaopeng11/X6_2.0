//
//  OrderreviewModel.h
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderreviewModel : NSObject
/*
 {
 col0 = 17;
 col1 = GD000000013;
 col2 = "2015-09-01";
 col3 = "\U4f9b\U5e94\U55463";
 col4 = "\U6b65\U6b65\U9ad8-12\U7248";
 col5 = 1;
 col6 = 1500;
 col7 = 0;
 col8 = 1500;
 }
 */

@property(nonatomic,copy)NSNumber *col0;
@property(nonatomic,copy)NSString *col1;
@property(nonatomic,copy)NSString *col2;
@property(nonatomic,copy)NSString *col3;
@property(nonatomic,copy)NSString *col4;
@property(nonatomic,copy)NSNumber *col5;
@property(nonatomic,copy)NSNumber *col6;
@property(nonatomic,copy)NSNumber *col7;
@property(nonatomic,copy)NSNumber *col8;


@end
