//
//  FocusModel.h
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FocusModel : NSObject
/*
 
 {
 comment = "";
 filename = "37b122ad-8f02-4779-9d28-9f90829c1c70_1447811267082.jpg";
 shortname = "1447811267082.jpg";
 userpic = "62cab15f-0754-4194-8a89-593c44527b8d_headphoto.png";
 usertype = 1;
 zdrdm = 23;
 zdrmc = "\U5f20\U4e09";
 zdrq = "2015-11-18 15:10:15";
 },

 */

@property(nonatomic,copy)NSString *comment;
@property(nonatomic,copy)NSString *filename;
@property(nonatomic,copy)NSString *shortname;
@property(nonatomic,copy)NSString *userpic;
@property(nonatomic,copy)NSNumber *usertype;
@property(nonatomic,copy)NSNumber *zdrdm;
@property(nonatomic,copy)NSString *zdrmc;
@property(nonatomic,copy)NSString *zdrq;


@end
