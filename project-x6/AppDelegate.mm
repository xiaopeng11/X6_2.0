//
//  AppDelegate.m
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "StartCarouselViewController.h"
#import "Reachability.h"
#import "BasicControls.h"
#import "ConversationListController.h"

//推送
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService.h"

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
@interface AppDelegate ()<EMChatManagerDelegate,JPUSHRegisterDelegate>


@end

@implementation AppDelegate

extern"C"{
    size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d )
    {
        return fwrite(a, b, c, d);
    }
    char* strerror$UNIX2003( int errnum )
    {
        return strerror(errnum);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[EaseSDKHelper shareHelper] easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"xp1100#x6" apnsCertName:@"x6chatproduct" otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    //注册apns
    [self registerRemoteNotification];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //检查网络
    [self checkNetWorkState];
    
    //限制图片缓存大小
    [SDWebImageManager sharedManager].imageCache.maxCacheSize = 1024 * 1024 * 10;
    
    //设置极光推送
    [self settingJpushMothed:launchOptions];
    
    //判断是否已经登陆    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    BOOL isloading = [[userdefaults objectForKey:X6_isLoading] boolValue];
    
    if ([BasicControls isNewVersion]) {
        StartCarouselViewController *startVC = [[StartCarouselViewController alloc] init];
        _window.rootViewController = startVC;
    } else if (!isloading) {
        FirstViewController *firstVC = [[FirstViewController alloc] init];
        _window.rootViewController = firstVC;
    } else {
        //重新登录环信号
        NSDictionary *userdic = [userdefaults objectForKey:X6_UserMessage];
        NSString *EaseID;
        NSString *phoneString = [userdic valueForKey:@"phone"];
        if (phoneString.length == 11) {
            if ([[userdic allKeys] containsObject:@"pwd"]) {
                EaseID = [NSString stringWithFormat:@"%@0%@",[userdic valueForKey:@"gsdm"],[userdic valueForKey:@"phone"]];
            } else {
                EaseID = [NSString stringWithFormat:@"%@1%@",[userdic valueForKey:@"gsdm"],[userdic valueForKey:@"phone"]];
            }
            NSString *password = @"yjxx&*()";
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:EaseID password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                NSLog(@"环信号登录成功");
            } onQueue:nil];
        }
        
        BaseTabBarViewController *baseTBVC = [[BaseTabBarViewController alloc] init];
        _window.rootViewController = baseTBVC;
        
    }
    sleep(1.5);
    [_window makeKeyAndVisible];
    
    _Usertimer = [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(getPersonMessage) userInfo:nil repeats:YES];
    [_Usertimer setFireDate:[NSDate distantPast]];
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerApp:@"197091f43eaf2" activePlatforms:@[@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
        [ShareSDKConnector connectWeChat:[WXApi class]];
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        [appInfo SSDKSetupWeChatByAppId:@"wx31f3d48f06663ee5"
                              appSecret:@"eaaf114bbc5cfbc0ac04aa3cee6eabbb"];
    }];
    
    return YES;
}

#pragma mark - 定时器
- (void)getPersonMessage
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *userQXchange = [NSString stringWithFormat:@"%@%@",baseURL,X6_userQXchange];
    [XPHTTPRequestTool requestMothedWithPost:userQXchange params:nil success:^(id responseObject) {
            if ([responseObject[@"message"] isEqualToString:@"Y"]) {
                NSString *QXhadchangeList = [NSString stringWithFormat:@"%@%@",baseURL,X6_hadChangeQX];
                [XPHTTPRequestTool requestMothedWithPost:QXhadchangeList params:nil success:^(id responseObject) {
                    [userdefaluts setObject:[responseObject valueForKey:@"qxlist"] forKey:X6_UserQXList];
                    [userdefaluts synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeQXList" object:nil];
                    //设置极光tags
                    NSMutableDictionary *loaddictionary = [userdefaluts valueForKey:X6_UserMessage];
                    NSString *ssgs = [loaddictionary valueForKey:@"ssgs"];
                    NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:ssgs, nil];
                    for (NSDictionary *dic in [responseObject valueForKey:@"qxlist"]) {
                        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
                            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                [set addObject:@"XJXC"];
                            }
                        } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]){
                            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                [set addObject:@"CGJJ"];
                            }
                        } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]){
                            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                [set addObject:@"LSXJ"];
                            }
                        }
                    }
                    for (NSString *tags in [[responseObject valueForKey:@"subvo"] allObjects]) {
                        [set addObject:tags];
                    }
                    [JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"极光的tags：%@,返回的状态吗：%d",iTags,iResCode);
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"获取权限列表失败");
                }];
            }
        } failure:^(NSError *error) {
            NSLog(@"获取权限是否更改失败");
        }];

}

#pragma mark - 检测网络状态
- (void)checkNetWorkState
{
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReach startNotifier];
}

#pragma mark - 检测网络状况Mothed
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"当前网络不给力,请稍后再试"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    
    }
}


- (void)registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings= [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType notificationTypes = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
        
    }
}


#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - 设置极光推送
- (void)settingJpushMothed:(NSDictionary *)launchOptions
{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = 0 | 1 | 2  ;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                                              categories:nil];
    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"2a34962b1321290c7871d136"
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];

}

//设置极光推送和环信推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];

    NSLog(@"------------------------------------------did Fail To Register For Remote Notifications With Error: %@", error);
}

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [self.stockVC networkChanged:connectionState];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    [self handleNotifacation:userInfo];

    [BasicControls showNDKNotifyWithMsg:@"收到离线消息" WithDuration:1 speed:1];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

    NSDictionary *alert = [userInfo objectForKey:@"aps"];
    NSString *string = [alert objectForKey:@"alert"];
    BaseTabBarViewController *baseTar = (BaseTabBarViewController *)self.window.rootViewController;

    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
    
    if (application.applicationState == UIApplicationStateActive) {
        if (![string isEqualToString:@"您有一条新消息"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您有一条异常提醒！"
                                                            message:string
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    } else
        if (application.applicationState == UIApplicationStateInactive) {
        completionHandler(UIBackgroundFetchResultNewData);
        if ([string isEqualToString:@"您有一条新消息"]) {
            baseTar.selectedIndex = 1;
        } else {
            baseTar.selectedIndex = 3;
        }
    }
    [self handleNotifacation:userInfo];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"appdelegate收到内存警告");
    // 停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    [_Usertimer setFireDate:[NSDate distantFuture]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [JPUSHService resetBadge];
    
    [_Usertimer setFireDate:[NSDate distantPast]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - 处理推送信息
- (void)handleNotifacation:(NSDictionary *)dic
{
    NSString *from = [dic objectForKey:@"from"];
    if ([from isEqualToString:@"JPush"])
    {
        NSString *text = dic[@"aps"][@"alert"];
        if (!text) {
            text = @"推送格式出错";
        }

        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:text delegate:self cancelButtonTitle:@"稍后再看！" otherButtonTitles:@"查看", nil];
        alterView.tag = 2001;
        [alterView show];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSDictionary *apsadic = [userInfo valueForKey:@"aps"];
        [BasicControls showNDKNotifyWithMsg:[apsadic valueForKey:@"alert"] WithDuration:2 speed:2];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAllDynamic" object:nil];
    }
    completionHandler(UIUserNotificationTypeSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}



- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (_allowRotation == 1) {
        return YES;
    }
    return NO;
}

@end
