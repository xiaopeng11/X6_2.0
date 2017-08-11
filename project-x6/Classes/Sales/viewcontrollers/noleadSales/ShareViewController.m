//
//  ShareViewController.m
//  project-x6
//
//  Created by Apple on 2016/12/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ShareViewController.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "X6WebView.h"
@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"分享"];
    
    //绘制分享试图
    [self drawShareView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawShareView
{
    X6WebView *shareWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 109)];
    shareWebView.webViewString = @"";
    [self.view addSubview:shareWebView];
    
    UIView *shareBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 109, KScreenWidth, 45)];
    shareBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shareBottomView];
    
    UIView *lianeView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
    [shareBottomView addSubview:lianeView];
    
    UIButton *userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userHeaderButton.frame = CGRectMake(18, 5, 35, 35);
    userHeaderButton.titleLabel.font = ExtitleFont;
    [shareBottomView addSubview:userHeaderButton];
    
    //头像背景视图
    UIImageView *cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 3, 39, 39)];
    cornerImage.image = [UIImage imageNamed:@"corner_circle"];
    [shareBottomView addSubview:cornerImage];
    
    //取出个人数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    NSString *gsdm = [userInformation objectForKey:@"gsdm"];
    NSString *headerURLString = nil;
    NSString *headerpic = [userInformation valueForKey:@"userpic"];
    if (headerpic.length == 0) {
        NSArray *array = HeaderBgColorArray;
        int x = arc4random() % 10;
        [userHeaderButton setBackgroundColor:(UIColor *)array[x]];
        NSString *lastTwoName = [userInformation valueForKey:@"name"];
        lastTwoName = [BasicControls judgeuserHeaderImageNameLenghNameString:lastTwoName];
        [userHeaderButton setTitle:lastTwoName forState:UIControlStateNormal];
    } else {
        headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,[userInformation valueForKey:@"userpic"]];
        NSURL *headerURL = [NSURL URLWithString:headerURLString];
        if (headerURLString) {
            [userHeaderButton sd_setBackgroundImageWithURL:headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
            [userHeaderButton setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectMake(cornerImage.right + 16, 7.5, KScreenWidth - 74 - 133, 30)];
    personLabel.textColor = Mycolor;
    personLabel.font = MainFont;
    personLabel.text = [NSString stringWithFormat:@"推荐人:%@",[userInformation objectForKey:@"name"]];
    [shareBottomView addSubview:personLabel];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setBackgroundColor:ColorRGB(240, 61, 61)];
    [shareButton setTitle:@"确认分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(KScreenWidth - 133, 0, 133, 45);
    [shareButton addTarget:self action:@selector(shareGood) forControlEvents:UIControlEventTouchUpInside];
    [shareBottomView addSubview:shareButton];
    
}

- (void)shareGood
{
    NSLog(@"分享");
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:@[@"http://www.x6pt.cn/image/logo.png"]
                                        url:[NSURL URLWithString:@"http://www.x6pt.cn"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            case SSDKResponseStateCancel:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您已取消分享"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
}

@end
