//
//  XPHTTPRequestTool.h
//  project-x6
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPHTTPRequestTool : NSObject
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)requestMothedWithPost:(NSString *)url
                       params:(NSDictionary *)params
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
/**
 *  上传数据
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
//http://192.168.1.199:8080/test44/msg/msgAction_getAppMsg.action

+ (void)reloadMothedWithPost:(NSString *)url
                      params:(NSDictionary *)params
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  倒入https证书
 */
//+ (AFSecurityPolicy *)customSecurityPolicy;
@end
