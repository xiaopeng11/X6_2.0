//
//  UIBarButtonItem+Extension.h
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithName:(NSString *)imageName target:(id)target action:(SEL)action;

@end
