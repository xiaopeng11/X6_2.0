//
//  PersonsModel.m
//  project-x6
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PersonsModel.h"
#import "MJExtension.h"
@implementation PersonsModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"userid":@"id"};
}
             
@end
