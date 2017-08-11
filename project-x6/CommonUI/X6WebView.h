//
//  X6WebView.h
//  project-x6
//
//  Created by Apple on 16/9/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface X6WebView : UIWebView<UIWebViewDelegate>
{
    UIActivityIndicatorView *_activityIndicator;  //动画
}
@property(nonatomic,strong)NSString *webViewString;
//加载数据
- (void)loadRequestWithBody:(NSString *)body;

@end
