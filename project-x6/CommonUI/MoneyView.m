//
//  MoneyView.m
//  project-x6
//
//  Created by Apple on 16/3/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MoneyView.h"


#import "AppDelegate.h"

#define Size            200
#define FadeDuration    0.2

#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)

#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)

#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define NUMBERS @"0123456789"

@interface MoneyView ()<UITextFieldDelegate>

+ (instancetype)instance;

@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, assign) BOOL shown;

@end

@implementation MoneyView

static MoneyView *instance;

+ (instancetype)instance {
    if (!instance) {
        instance = [[MoneyView alloc] init];
    }
    return instance;
}

- (instancetype)init {
    if ((self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)])) {
        
        [self setAlpha:0];
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [self.layer setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0.2] CGColor]];
        [self.layer setMasksToBounds:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleSetMoney)];
        [self addGestureRecognizer:tap];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2.0, 100, 200, 200)];
        bgView.clipsToBounds = YES;
        bgView.layer.cornerRadius = 10;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 75, 180, 30)];
        _moneyTextField.placeholder = @"请输入金额";
        _moneyTextField.textAlignment = NSTextAlignmentCenter;
        _moneyTextField.delegate = self;
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        [bgView addSubview:_moneyTextField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 105, 180, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [bgView addSubview:lineView];
        
        
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(0, 150, 100, 50);
        _cancleButton.backgroundColor = Mycolor;
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancleSetMoney) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_cancleButton];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(100, 150, 100, 50);
        _sureButton.backgroundColor = Mycolor;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureSetMoney) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_sureButton];

        
        [APPDELEGATE.window addSubview:self];

    }
    return self;
}


- (void)cancleSetMoney
{
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
        [_moneyTextField resignFirstResponder];
        _moneyTextField.text = nil;
    } completion:^(BOOL finished) {
        [self setShown:NO];
    }];
}

- (void)sureSetMoney
{
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
        [_moneyTextField resignFirstResponder];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addMoneyData" object:_moneyTextField.text];
        _moneyTextField.text = nil;
    }];
    
}





- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"请输入数字"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        
        [alert show];
        return NO;
        
    }
    return YES;
}







+ (void)show {
    [self dismiss:^{
        [APPDELEGATE.window bringSubviewToFront:[self instance]];
        [[self instance] setShown:YES];
        [[self instance] fadeIn];
    }];
}

+ (void)dismiss {
    if (![[self instance] shown])
        return;
    [[self instance] fadeOut];
}

+ (void)dismiss:(void(^)(void))complated {
    if (![[self instance] shown])
        return complated ();
    
    [[self instance] fadeOutComplate:^{
        complated ();
    }];
}
#pragma mark Effects


- (void)fadeIn {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:1];
        [_moneyTextField becomeFirstResponder];
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
        [_moneyTextField resignFirstResponder];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        _moneyTextField.text = nil;
    }];
}

- (void)fadeOutComplate:(void(^)(void))complated {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];

    } completion:^(BOOL finished) {
        [self setShown:NO];
        complated ();
    }];
}

@end
