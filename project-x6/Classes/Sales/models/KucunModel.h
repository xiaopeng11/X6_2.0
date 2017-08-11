//
//  KucunModel.h
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  {
 col0 = 92;
 col1 = "\U6b65\U6b65\U9ad8-x5\U767d16G";
 col2 = 4;
 col3 = 6400;
 }
 */
@interface KucunModel : NSObject

@property(nonatomic,copy)NSNumber *col0;
@property(nonatomic,copy)NSString *col1;
@property(nonatomic,copy)NSNumber *col2;
@property(nonatomic,copy)NSNumber *col3;

@end
