//
//  BasicControls.m
//  MasterplateDemo
//
//  Created by diudiu on 15/7/30.
//  Copyright (c) 2015年 diudiu. All rights reserved.
//

#import "BasicControls.h"
#import "BDKNotifyHUD.h"
#import "Kehubanben.h"
@implementation BasicControls

+(UITextField  *)createTextFieldWithframe:(CGRect)rect
                                addTarget:(id)target
                                    image:(UIImage *)backGroudImage
{
    UITextField  *textFiled = [[UITextField  alloc]initWithFrame:rect];
    textFiled.backgroundColor = [UIColor  clearColor];
    //解决placeholder在IOS6.0和IOS6.0以上显示兼容问题
    textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFiled setBackground:backGroudImage];
    textFiled.delegate = target;
    return textFiled;
}

+ (void)setLeftImageViewToTextField:(UITextField *)field
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0, field.frame.size.height)];
    [view setBackgroundColor:[UIColor clearColor]];
    [field setLeftView:view];
    [field setLeftViewMode:UITextFieldViewModeAlways];
}

+(UIImage *)getImageWithName:(NSString *)imageName type:(NSString *)imageType
{
    //    NSString *imagePath =[[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
    UIImage *image =[UIImage imageNamed:imageName];
    
    return image;
}

+(UILabel  *)createLabelWithframe:(CGRect)rect
                            image:(UIImage *)backGroudImage
{
    UILabel  *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    //    [label setBackgroundColor:[UIColor colorWithPatternImage:backGroudImage]];
    return label;
    
}

+(void)showAlertWithMsg:(NSString *)msg
              addTarget:(id)target
{
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+(UIImageView  *)createImageViewWithframe:(CGRect )rect
                                    image:(UIImage *)backGroudImage
{
    UIImageView  *imageView  = [[UIImageView  alloc]initWithFrame:rect];
    imageView.backgroundColor = [UIColor  clearColor];
    [imageView setImage:backGroudImage];
    return imageView;
    
}

+(UIButton  *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect )rect
                              image:(UIImage *)backGroudImage
{
    UIButton  *button = [UIButton  buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:backGroudImage forState:UIControlStateNormal];
    return button;
}

+ (void)showNDKNotifyWithMsg:(NSString *)showMsg  WithDuration:(CGFloat)duration speed:(CGFloat)speed
{
    BDKNotifyHUD *notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@""] text:showMsg];
    notify.frame = CGRectMake(0, 64, 0, 0);
//    notify.center_X = KScreenWidth  / 2;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:notify];
    [notify presentWithDuration:duration speed:speed inView:window completion:^{
        [notify removeFromSuperview];
    }];
}

+ (BOOL)isNewVersion
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastVersion = [defaults objectForKey:SYSTEMVERSION];
    
    //获取当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[SYSTEMVERSION];
    
    if (![currentVersion isEqualToString:lastVersion])
    {
        [defaults setObject:currentVersion forKey:SYSTEMVERSION];
        return YES;
    }else
    {
        return NO;
    }
}



#pragma mark - 绘制风格线
+ (UIView *)drawLineWithFrame:(CGRect)frame
{
    UIView *lineview = [[UIView alloc] initWithFrame:frame];
    lineview.backgroundColor = LineColor;
    return lineview;
}


#pragma mark - 纯色生成image
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
}

+ (void)editiongroup:(dispatch_group_t)group
{
    NSString *kehuMessageString = [NSString stringWithFormat:@"%@%@",X6basemain_API,kehuMessage];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *message = [userdefault objectForKey:X6_UserMessage];
    NSString *gsdm = [message valueForKey:@"gsdm"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:gsdm forKey:@"gsdm"];
    if (group != nil) {
        dispatch_group_enter(group);
    }
    [XPHTTPRequestTool requestMothedWithPost:kehuMessageString params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *kehu = responseObject[@"ver"];
        if ([kehu isEqualToString:@"X6中端版"]) {
            kehu = @"X6经典版";
        }
        [userdefault setObject:kehu forKey:Kehuedition];
        [userdefault synchronize];
        if (group != nil) {
            dispatch_group_leave(group);
        }
    } failure:^(NSError *error) {
        NSLog(@"获取客户权限失败");
        if (group != nil) {
            dispatch_group_leave(group);
        }
    }];
}


/**
 *  该版本没有该功能
 *
 *  @param defaultImage 展示的图片
 */
+ (UIView *)noshowBusinessOrSalesUIWithDefaultImagename:(NSString *)defaultImagename
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    imageview.image = [UIImage imageNamed:defaultImagename];
    [view addSubview:imageview];
    return view;
}

+ (void)resetTalkPersonWithPersonDic:(NSDictionary *)personDic
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    [userdefalut setObject:personDic forKey:X6_TalkPerson];
    [userdefalut synchronize];
}

/**
 *  日期
 */
+ (NSString *)TurnTodayDate
{
    NSString *dateString;
    NSDate *date = [NSDate date];
    dateString = [NSString stringWithFormat:@"%@",date];
    dateString = [dateString substringToIndex:10];
    return dateString;
}


/**
 *  讲周几转为星期几
 *
 *  @param week 周几
 */
+ (NSString *)turnEnglishToChineseWithWeek:(NSString *)week
{
    NSString *weekStr;
    if ([week isEqualToString:@"周一"]) {
        weekStr = @"星期一";
    } else if ([week isEqualToString:@"周二"]) {
        weekStr = @"星期二";
    } else if ([week isEqualToString:@"周三"]) {
        weekStr = @"星期三";
    } else if ([week isEqualToString:@"周四"]) {
        weekStr = @"星期四";
    } else if ([week isEqualToString:@"周五"]) {
        weekStr = @"星期五";
    } else if ([week isEqualToString:@"周六"]) {
        weekStr = @"星期六";
    } else if ([week isEqualToString:@"周日"]) {
        weekStr = @"星期日";
    }
    return weekStr;
}

/**
 *  将星期几桩华为数字
 *
 *  @param week 周几
 */
+ (NSMutableString *)turnChineseToNumWithWeek:(NSString *)week
{
    NSMutableString *date;
    if ([week isEqualToString:@"星期一"]) {
        return date = [@"2" mutableCopy];
    } else if ([week isEqualToString:@"星期二"]) {
        return date = [@"3" mutableCopy];
    } else if ([week isEqualToString:@"星期三"]) {
        return date = [@"4" mutableCopy];
    } else if ([week isEqualToString:@"星期四"]) {
        return date = [@"5" mutableCopy];
    } else if ([week isEqualToString:@"星期五"]) {
        return date = [@"6" mutableCopy];
    } else if ([week isEqualToString:@"星期六"]) {
        return date = [@"7" mutableCopy];
    } else {
        return date = [@"1" mutableCopy];
    }
    return date;
}


/**
 *  将星期几桩华为数字
 *
 *  @param week 周几
 */
+ (NSMutableString *)turnNumToChineseWithWeek:(NSString *)week
{
    NSMutableString *date;
    if ([week isEqualToString:@"2"]) {
        return date = [@"星期一" mutableCopy];
    } else if ([week isEqualToString:@"3"]) {
        return date = [@"星期二" mutableCopy];
    } else if ([week isEqualToString:@"4"]) {
        return date = [@"星期三" mutableCopy];
    } else if ([week isEqualToString:@"5"]) {
        return date = [@"星期四" mutableCopy];
    } else if ([week isEqualToString:@"6"]) {
        return date = [@"星期五" mutableCopy];
    } else if ([week isEqualToString:@"7"]) {
        return date = [@"星期六" mutableCopy];
    } else {
        return date = [@"星期日" mutableCopy];
    }
    return date;
}


/**
 头像名字
 
 @param nameString 名称
 @return 显示名称
 */
+ (NSString *)judgeuserHeaderImageNameLenghNameString:(NSString *)nameString
{
    if (nameString.length > 2) {
        return [nameString substringWithRange:NSMakeRange(nameString.length - 2, 2)];
    } else {
        return nameString;
    }
}
@end
