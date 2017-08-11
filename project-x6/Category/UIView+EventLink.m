//
//  UIView+EventLink.m
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "UIView+EventLink.h"

@implementation UIView (EventLink)


- (UIViewController *)ViewController
{
    UIResponder *responder = [self nextResponder];
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        } else {
            responder = [responder nextResponder];
        }
    } while (responder != nil);
    return nil;
}

@end
