//
//  AdviceViewController.m
//  project-x6
//
//  Created by Apple on 16/8/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AdviceViewController.h"

@interface AdviceViewController ()<UITextViewDelegate>

{
    UIView *_secondBG;
}
@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"意见反馈"];
    
    UITextView *firstTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 150)];
    firstTextView.font = MainFont;
    firstTextView.delegate = self;
    firstTextView.tag = 5630;
    firstTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstTextView];
    
    _secondBG = [[UIView alloc] initWithFrame:CGRectMake(10, 170, KScreenWidth - 20, 45)];
    _secondBG.backgroundColor = [UIColor whiteColor];
    _secondBG.userInteractionEnabled = YES;
    [self.view addSubview:_secondBG];
    
    UITextView *secondTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, KScreenWidth - 20, 35)];
    secondTextView.delegate = self;
    secondTextView.font = MainFont;
    secondTextView.tag = 5631;
    [_secondBG addSubview:secondTextView];
    
    NSArray *array = @[@"任何现有功能无法正常使用，用的不爽，功能建议等等都提过来吧～",@"请留下你的联系方式，以便我们更好的了解您的反馈"];
    for (int i = 0; i < 2; i++) {
        UILabel *FirstTV = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + 160 * i, KScreenWidth - 30, 45)];
        FirstTV.tag = 56321 + i;
        FirstTV.font = ExtitleFont;
        FirstTV.numberOfLines = 0;
        FirstTV.textColor = ColorRGB(190, 190, 190);
        FirstTV.enabled = NO;//lable必须设置为不可用
        FirstTV.text = array[i];
        FirstTV.backgroundColor = [UIColor clearColor];
        [self.view addSubview:FirstTV];
    }
    
    UIButton *adviceBT = [UIButton buttonWithType:UIButtonTypeCustom];
    adviceBT.frame = CGRectMake(10, 225 + 25, KScreenWidth - 20, 45);
    [adviceBT setBackgroundColor:Mycolor];
    adviceBT.titleLabel.font = TitleFont;
    adviceBT.clipsToBounds = YES;
    adviceBT.layer.cornerRadius = 4;
    [adviceBT setTitle:@"提交" forState:UIControlStateNormal];
    [adviceBT addTarget:self action:@selector(adviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:adviceBT];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 5630) {
        UILabel *FirsttextPLacerlabel = [self.view viewWithTag:56321];
        if (textView.text.length == 0) {
            FirsttextPLacerlabel.text = @"任何现有功能无法正常使用，用的不爽，功能建议等等都提过来吧～";
        }else{
            FirsttextPLacerlabel.text = @"";
        }
    } else if (textView.tag == 5631){
        UILabel *secondtextPLacerlabel = [self.view viewWithTag:56322];
        if (textView.text.length == 0) {
            secondtextPLacerlabel.text = @"请留下你的联系方式，以便我们更好的了解您的反馈";
        }else{
            secondtextPLacerlabel.text = @"";
        }
    }
}

- (void)adviceAction
{
    UITextView *textView = [self.view viewWithTag:5630];
    UITextView *phoneView = [_secondBG viewWithTag:5631];
    NSString *phone = [NSString stringWithFormat:@"%@",phoneView.text];
    if (textView.text.length == 0) {
        [BasicControls showAlertWithMsg:@"意见不能为空！" addTarget:nil];
    } else {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSString *userURL = [userdefaults objectForKey:X6_UseUrl];
        NSString *adviceURL = [NSString stringWithFormat:@"%@%@",userURL,X6_advice];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:textView.text forKey:@"question"];
        [params setObject:phone forKey:@"contact"];
        [params setObject:@(-1) forKey:@"id"];
        [self showProgress];
        [XPHTTPRequestTool reloadMothedWithPost:adviceURL params:params success:^(id responseObject) {
            [self hideProgress];
            [BasicControls showNDKNotifyWithMsg:@"您的建议已提交！" WithDuration:1 speed:1];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self hideProgress];
            [BasicControls showNDKNotifyWithMsg:@"提交失败！" WithDuration:1 speed:1];
        }];
    }
}



@end
