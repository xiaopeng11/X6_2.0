//
//  ThirdPersonTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/7/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ThirdPersonTableViewCell.h"
#import "FirstViewController.h"
#import "AppDelegate.h"
@implementation ThirdPersonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _unloadButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 45)];
        [_unloadButton setBackgroundColor:Mycolor];
        _unloadButton.titleLabel.font = TitleFont;
        _unloadButton.clipsToBounds = YES;
        _unloadButton.layer.cornerRadius = 4;
        [_unloadButton setTitle:@"退出系统" forState:UIControlStateNormal];
        [_unloadButton addTarget:self action:@selector(unloadAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_unloadButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 退出登录
- (void)unloadAction:(UIButton *)button
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //移除本地的数据
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:@NO forKey:X6_isLoading];
        [userdefaults removeObjectForKey:X6_UseUrl];
        [userdefaults removeObjectForKey:X6_Cookie];
        [userdefaults removeObjectForKey:X6_refresh];
        [userdefaults removeObjectForKey:X6_Contactlist];
        [userdefaults removeObjectForKey:X6_UserQXList];
        [userdefaults removeObjectForKey:Kehuedition];
        [userdefaults removeObjectForKey:X6_UserIdentity];
        [userdefaults synchronize];
        
        //点击的时确定按钮
        NSFileManager *filemanager = [NSFileManager defaultManager];
        //删除文件的路径
        NSString *cachefilepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        //删除文件
        [filemanager removeItemAtPath:cachefilepath error:nil];
        [filemanager removeItemAtPath:DOCSFOLDER error:nil];
        
        //推出环信账号
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            
        } onQueue:nil];
        
        
        FirstViewController *loadVC = [[FirstViewController alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = loadVC;
        
    }];
    
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertcontroller addAction:cancelaction];
    [alertcontroller addAction:okaction];
    [self.ViewController presentViewController:alertcontroller animated:YES completion:nil];
    
}


@end
