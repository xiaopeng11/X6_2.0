//
//  UIViewController+ThemeNavigationController.h
//  project-x6
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ThemeNavigationController)

/**
 *  联系人确定按钮
 *
 *  @param selectPersons 是否添加
 */

- (void)addsurebutton;


/**
 *  上传文件
 *
 *  @param uuid UUID
 */
- (void)unloadFileWithUuid:(NSString *)uuid Filepath:(NSString *)filepath FileName:(NSString *)fileName group:(dispatch_group_t)group;

/**
 *  白色标题
 *
 *  @param text 标题文本
 */
- (void)naviTitleWhiteColorWithText:(NSString *)text;


/**
 *  导航栏右侧视图
 *
 *  @param navbar 导航栏
 *
 *  @return 按钮视图
 */

- (UIView *)findRightBarItemView:(UINavigationBar *)navbar;

/**
 *  图片尺寸压缩
 *
 *  @param UIImage 图片
 *
 *  @return 压缩后的图片
 */
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**
 *  保存图片至沙盒
 *
 *  @return nil
 */
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;

/**
 *  清楚图片缓存
 *
 *
 */
- (void)deleteImageFile;


/**
 *  数据加密
 *
 *  @param datalist 加密的数组
 *  @param key 加密的键
 *  @param jmdx 加密的对象
 */
- (void)passwordTodayDatalistWithDataList:(NSMutableArray *)datalist
                                      Key:(NSString *)key
                                     Jmdx:(NSString *)jmdx;


/**
 *  合计
 *
 *  @param dataList 需要累加的数据
 *  @param code 累加的key
 */
- (double)leijiaNumDataList:(NSMutableArray *)dataList
                       Code:(NSString *)code;


/**
 *  是否有权限审核和撤审
 *
 *  @param string 审核／撤审的关键字
 *  @param isexamine 审核还是撤审
 */
- (BOOL)isqxToexamineorRevokeWithString:(NSString *)string Isexamine:(NSString *)isexamine;

@end
