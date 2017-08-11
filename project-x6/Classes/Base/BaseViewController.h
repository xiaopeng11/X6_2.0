//
//  BaseViewController.h
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//显示菊花
- (void)showProgress;

- (void)showProgressTitle:(NSString *)title;

//隐藏菊花
- (void)hideProgress;
@end
