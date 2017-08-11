//
//  BasicControls.h
//  MasterplateDemo
//
//  Created by diudiu on 15/7/30.
//  Copyright (c) 2015年 diudiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicControls : NSObject

+(UITextField  *)createTextFieldWithframe:(CGRect)rect
                                addTarget:(id)target
                                    image:(UIImage *)backGroudImage;

+ (void)setLeftImageViewToTextField:(UITextField *)field;

+(UIImage *)getImageWithName:(NSString *)imageName type:(NSString *)imageType;

+(UILabel  *)createLabelWithframe:(CGRect)rect
                            image:(UIImage *)backGroudImage;

+(void)showAlertWithMsg:(NSString *)msg
              addTarget:(id)target;

+(UIImageView  *)createImageViewWithframe:(CGRect )rect
                                    image:(UIImage *)backGroudImage;

+(UIButton  *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect )rect
                              image:(UIImage *)backGroudImage;

+ (void)showNDKNotifyWithMsg:(NSString *)showMsg
                WithDuration:(CGFloat)duration
                       speed:(CGFloat)speed;

+ (BOOL)isNewVersion;


+ (UIView *)drawLineWithFrame:(CGRect)frame;


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (void)editiongroup:(dispatch_group_t)group;

/**
 *  该版本没有该功能
 *
 *  @param defaultImage 展示的图片
 */
+ (UIView *)noshowBusinessOrSalesUIWithDefaultImagename:(NSString *)defaultImagename;


+ (void)resetTalkPersonWithPersonDic:(NSDictionary *)personDic;

+ (NSString *)TurnTodayDate;

/**
 *  讲周几转为星期几
 *
 *  @param week 周几
 */
+ (NSString *)turnEnglishToChineseWithWeek:(NSString *)week;


/**
 *  将星期几桩华为数字
 *
 *  @param week 周几
 */
+ (NSMutableString *)turnChineseToNumWithWeek:(NSString *)week;

/**
 *  将星期几桩华为数字
 *
 *  @param week 周几
 */
+ (NSMutableString *)turnNumToChineseWithWeek:(NSString *)week;

/**
 头像名字
 
 @param nameString 名称
 @return 显示名称
 */
+ (NSString *)judgeuserHeaderImageNameLenghNameString:(NSString *)nameString;
@end
