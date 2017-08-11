//
//  TimeGroupChooseViewController.h
//  project-x6
//
//  Created by Apple on 2016/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface TimeGroupChooseViewController : BaseViewController
@property(nonatomic,assign)NSInteger timeChooseType;
@property(nonatomic,copy)NSString *timeSelect;

@property(nonatomic,strong)NSMutableDictionary *JPushTag;

@end
