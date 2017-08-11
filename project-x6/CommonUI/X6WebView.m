//
//  X6WebView.m
//  project-x6
//
//  Created by Apple on 16/9/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "X6WebView.h"

@implementation X6WebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //自动适应屏幕
//        self.scalesPageToFit = YES;
        //超出部分从左往右滑动
        self.paginationMode = UIWebPaginationModeTopToBottom;
//        设置是否将数据加载如内存后渲染界面
        self.suppressesIncrementalRendering = YES;
        //协议
        self.delegate = self;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [_activityIndicator setCenter:CGPointMake(KScreenWidth / 2.0, self.frame.size.height / 2.0)];
        [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityIndicator];
    }
    return self;
}

#pragma mark - 加载
- (void)loadRequestWithBody:(NSString *)body
{
    //url
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSData *cookiedata = [userdefaults objectForKey:X6_Cookie];
    if (cookiedata.length) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiedata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *webviewURLString = [NSString stringWithFormat:@"%@%@",baseURL,self.webViewString];

    NSURL *webviewURL = [NSURL URLWithString:webviewURLString];
          
    NSMutableURLRequest *assetsAccountingRequest = [[NSMutableURLRequest alloc] initWithURL:webviewURL];
    assetsAccountingRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    assetsAccountingRequest.timeoutInterval = 20;
    [assetsAccountingRequest setHTTPMethod: @"POST"];
    if (body.length != 0) {
        [assetsAccountingRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [self loadRequest:assetsAccountingRequest];
    

}

//开始加载时调用的方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator startAnimating];
}

//结束加载时调用的方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    
    for (int i = 0; i < 5; i++) {
        NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.width = '100%%'",i];
        [webView stringByEvaluatingJavaScriptFromString:str];
    }
}


//加载失败时调用的方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
}

@end
