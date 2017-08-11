//
//  XPHTTPRequestTool.m
//  project-x6
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XPHTTPRequestTool.h"

@implementation XPHTTPRequestTool
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
//http://192.168.1.199:8080/test44/msg/msgAction_getAppMsg.action

+ (void)requestMothedWithPost:(NSString *)url
                       params:(NSDictionary *)params
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    //获得请求管理者
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    // 设置cookie
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.responseSerializer.acceptableContentTypes = [requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
   
    
    requestManager.requestSerializer.timeoutInterval = 10;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *cookiedata = [userDefaults objectForKey:X6_Cookie];

    if (cookiedata.length) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiedata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    // 加上这行代码，https ssl 验证。
//    [requestManager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    
    //发送POST请求
    [requestManager POST:url parameters:params success:^(AFHTTPRequestOperation                                                                                                                                                                                                                                                                                                                          *operation, id responseObject) {
        if (success) {
            if ([responseObject[@"type"] isEqualToString:@"success"]) {
                success(responseObject);
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setObject:data forKey:X6_Cookie];
                [userDefaults synchronize];
            } else {
                [BasicControls showAlertWithMsg:responseObject[@"message"] addTarget:nil];
            }  
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}




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
                      failure:(void (^)(NSError *error))failure
{
    //封装字典
    NSMutableDictionary *diced = [NSMutableDictionary dictionary];
    [diced setObject:params forKey:@"vo"];
    NSMutableDictionary *dics = [NSMutableDictionary dictionary];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:diced options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    [dics setObject:string forKey:@"postdata"];
    
    
    //获得请求管理者
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    // 设置cookie
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.responseSerializer.acceptableContentTypes = [requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    requestManager.requestSerializer.timeoutInterval = 10;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *cookiedata = [userDefaults objectForKey:X6_Cookie];
    
    if (cookiedata.length) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiedata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    // 加上这行代码，https ssl 验证。
//    [requestManager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    //发送POST请求
    [requestManager POST:url parameters:dics success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            if ([responseObject[@"type"] isEqualToString:@"success"]) {
                success(responseObject);
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setObject:data forKey:X6_Cookie];
                [userDefaults synchronize];
            } else {
                [BasicControls showAlertWithMsg:responseObject[@"message"] addTarget:nil];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  https证书
 */
//+ (AFSecurityPolicy *)customSecurityPolicy
//{
//    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"tomcat" ofType:@"cer"];//证书的路径
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    //validatesDomainName 是否需要验证域名，默认为YES； 
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
//    
//    securityPolicy.pinnedCertificates = @[certData];
//    
//    return securityPolicy;
//}
@end
