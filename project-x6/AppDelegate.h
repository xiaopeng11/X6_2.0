//
//  AppDelegate.h
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockViewController.h"
#import "BaseTabBarViewController.h"
@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    Reachability *hostReach;
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) StockViewController *stockVC;
@property (assign, nonatomic) BOOL allowRotation;
@property(nonatomic,strong)NSTimer *Usertimer;

@end
