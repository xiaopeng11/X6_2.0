//
//  UIViewController+ThemeNavigationController.m
//  project-x6
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "UIViewController+ThemeNavigationController.h"



@implementation UIViewController (ThemeNavigationController)


/**
 *  联系人确定按钮
 *
 *  @param selectPersons 是否添加
 */

- (void)addsurebutton
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 55, KScreenWidth, 55)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundColor:Mycolor];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 4;
    [button addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:button];
}

#pragma mark - 返回联系人信息
- (void)sureAction:(UIButton *)button
{
    NSLog(@"确定返回联系人信息");
}


/**
 *  上传文件
 *
 *  @param uuid uuid
 */
- (void)unloadFileWithUuid:(NSString *)uuid
                  Filepath:(NSString *)filepath
                  FileName:(NSString *)fileName
                    group:(dispatch_group_t)group
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *usemessage = [userdefault objectForKey:X6_UserMessage];
    NSString *userURL = [userdefault objectForKey:X6_UseUrl];
    NSString *userId = [usemessage valueForKey:@"id"];
    NSString *name = [fileName substringWithRange:NSMakeRange(0, fileName.length - 4)];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",userURL,X6_unloadFile];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uuid forKey:@"uuid"];
    [params setObject:userId forKey:@"userId"];
    if (group != nil) {
        dispatch_group_enter(group);
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:filepath] name:name fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上传成功");
        if (group != nil) {
            dispatch_group_leave(group);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败");
        if (group != nil) {
            dispatch_group_leave(group);
        }
    }];
}

/**
 *  标题
 *
 *  @param text 标题文本
 */
- (void)naviTitleWhiteColorWithText:(NSString *)text
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, 0, 100, 44)];
    title.text = text;
    title.textColor = [UIColor whiteColor];
    title.font = TitleFont;
    title.textAlignment = NSTextAlignmentCenter;
    [title sizeToFit];
    title.center = CGPointMake(KScreenWidth / 2.0, 42);

    self.navigationItem.titleView = title;
}

/**
 *  导航栏右侧视图
 *
 *  @param navbar 导航栏
 *
 *  @return 按钮视图
 */

- (UIView *)findRightBarItemView:(UINavigationBar *)navbar
{
    UIView *rightView = nil;
    for (UIView *view in navbar.subviews) {
        if (rightView == nil) {
            rightView = view;
        } else if (view.frame.origin.x > rightView.frame.origin.x) {
            rightView = view;
        }
    }
    return rightView;
}

/**
 *  图片尺寸压缩
 *
 *  @param UIImage 图片
 *
 *  @return 压缩后的图片
 */
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (height / width) * targetWidth;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  保存图片至沙盒
 *
 *  @return nil
 */
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    //压缩图片
    NSData *imageData = UIImageJPEGRepresentation(currentImage,0.1);
    
    NSLog(@"%lu",(unsigned long)imageData.length);
    // 获取沙盒目录
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //获取文件夹路径
    NSString *imageDir = [DOCSFOLDER stringByAppendingPathComponent:@"Image"];
    //判断文件夹是否存在，不存在创建
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:imageDir];
    if (!isExit) {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //指定文件夹下创建文件
    NSString *fullPath = [imageDir stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:YES];
}

/**
 *  清楚图片缓存
 *
 *  @param fullpatch 图片路径
 */
- (void)deleteImageFile
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //需要清除的文件路径
    NSString *imageDir = [DOCSFOLDER stringByAppendingPathComponent:@"Image"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:imageDir];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:imageDir error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}

/**
 *  数据加密
 *
 *  @param datalist 加密的数组
 *  @param key 加密的键
 *  @param jmdx 加密的对象
 */
- (void)passwordTodayDatalistWithDataList:(NSMutableArray *)datalist
                                      Key:(NSString *)key
                                     Jmdx:(NSString *)jmdx
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    for (NSDictionary *dic in qxList) {
        if ([[dic valueForKey:@"qxid"] isEqualToString:jmdx]) {
            if ([[dic valueForKey:@"pcb"] integerValue] == 1) {
                for (int i  = 0; i < datalist.count; i++) {
                    NSMutableDictionary *dicede = [NSMutableDictionary dictionaryWithDictionary:datalist[i]];
                    [dicede removeObjectForKey:key];
                    [datalist replaceObjectAtIndex:i withObject:dicede];
                }
            }
            break;
        }
    }
}

/**
 *  合计
 *
 *  @param dataList 需要累加的数据
 *  @param code 累加的key
 */
- (double)leijiaNumDataList:(NSMutableArray *)dataList
                       Code:(NSString *)code
{
    double totalMoney = 0;
    if (dataList.count != 0) {
        for (NSDictionary *dic in dataList) {
            totalMoney += [[dic valueForKey:code] doubleValue];
        }
    }
    return totalMoney;
}

/**
 *  是否有权限审核和撤审
 *
 *  @param string 审核／撤审的关键字
 *  @param isexamine 审核还是撤审
 */
- (BOOL)isqxToexamineorRevokeWithString:(NSString *)string Isexamine:(NSString *)isexamine
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    for (NSDictionary *dic in qxList) {
        if ([[dic valueForKey:@"qxid"] isEqualToString:string]) {
            if ([[dic valueForKey:isexamine] integerValue] == 1) {
                return YES;
            }
            break;
        }
    }
    return NO;
}


@end
