//
//  UIBarButtonItem+Extension.m
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
    
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    button.size = button.currentBackgroundImage.size;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithName:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:imageName forState:UIControlStateNormal];
    button.titleLabel.font = ExtitleFont;
    button.size = CGSizeMake(60, 20);
    button.clipsToBounds = YES;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
