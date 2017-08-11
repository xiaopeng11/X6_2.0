//
//  CostumMoreDatePicker.m
//  XPDatePicker
//
//  Created by Apple on 2016/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CostumMoreDatePicker.h"

#define XPDataPickerwidth (KScreenWidth * .7)

@interface CostumMoreDatePicker ()
{
    UILabel *label;
}

@end


@implementation CostumMoreDatePicker



- (instancetype)initWithFrame:(CGRect)frame
                         Data:(NSArray *)data
                     IndexStr:(NSString *)indexStr
                          Key:(NSString *)key
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.font = ExtitleFont;
        self.text = indexStr;
        self.textAlignment = NSTextAlignmentCenter;
        
        self.datePicker = [[CostumMorePickerView alloc] initWithFrame:CGRectMake(0, 0,XPDataPickerwidth, XPDataPickerwidth) Date:data IndexStr:indexStr Key:key];
        [self.datePicker selectDay];
        self.datePicker.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth * .15, ((KScreenHeight - XPDataPickerwidth - 40) / 2.0), XPDataPickerwidth, XPDataPickerwidth)];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 4;
        view.backgroundColor = [UIColor whiteColor];
        
        //半透明背景
        self.subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight )];
        self.subView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        self.subView.tag = 0;
        
        
        UIButton *cancleDate = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleDate.frame = CGRectMake(KScreenWidth * .15, ((KScreenHeight - XPDataPickerwidth - 40) / 2.0) + XPDataPickerwidth, (XPDataPickerwidth - .5) / 2, 40);
        cancleDate.backgroundColor = Mycolor;
        cancleDate.clipsToBounds = YES;
        cancleDate.layer.cornerRadius = 4;
        [cancleDate setTitle:@"取消" forState:UIControlStateNormal];
        [cancleDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancleDate addTarget:self action:@selector(MorecancledateChange) forControlEvents:UIControlEventTouchUpInside];
        [self.subView addSubview:cancleDate];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth * .15 + ((XPDataPickerwidth - .5) / 2), ((KScreenHeight - XPDataPickerwidth - 40) / 2.0) + XPDataPickerwidth, .5, 40)];
        lineview.backgroundColor = [UIColor whiteColor];
        [self.subView addSubview:lineview];
        
        UIButton *chooseDate = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseDate.frame = CGRectMake(KScreenWidth * .15 + ((XPDataPickerwidth - .5) / 2) + .5, ((KScreenHeight - XPDataPickerwidth - 40) / 2.0) + XPDataPickerwidth, (XPDataPickerwidth - .5) / 2, 40);
        chooseDate.backgroundColor = Mycolor;;
        chooseDate.clipsToBounds = YES;
        chooseDate.layer.cornerRadius = 4;
        [chooseDate setTitle:@"确定" forState:UIControlStateNormal];
        [chooseDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chooseDate addTarget:self action:@selector(MoredateChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.subView addSubview:chooseDate];
        
        
        
        UITapGestureRecognizer *pickerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MorecancledateChange)];
        [self.subView addGestureRecognizer:pickerTap];
        [view addSubview:self.datePicker];
        
        
        
        [self.subView addSubview:view];
        
        //设置输入框
        self.delegate=self;
        
        self.borderStyle=UITextBorderStyleRoundedRect;
        
        
    }
    return self;
}

- (void)setMoretextFont:(UIFont *)MoretextFont
{
    if (_MoretextFont != MoretextFont) {
        _MoretextFont = MoretextFont;
        self.font = _MoretextFont;
    }
}

- (void)setMoretextColor:(UIColor *)MoretextColor
{
    if (_MoretextColor != MoretextColor) {
        _MoretextColor = MoretextColor;
        self.textColor = _MoretextColor;
    }
}

#pragma mark - 日期控件点击事件
- (void)MoredateChange:(id)sender
{
    //改变textField的值
    self.text = [NSString stringWithString:_datePicker.dateStr];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTimeData" object:nil];
    
    [self MorecancledateChange];
}

- (void)MorecancledateChange
{
    if(self.subView != nil){
        
        self.subView.tag = 0;
        
        [self.subView removeFromSuperview];
    }
}

#pragma mark textField delegate method

//当textField被点击时触发

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.subView.tag==0) {//若tag标志等于0，说明datepicker未显示
        
        //置tag标志为1，并显示子视图
        
        self.subView.tag=1;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.subView];
    }
    return NO;
    
}

@end
