//
//  CustomerModel.m
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"supplierid":@"id"};
}
@end
