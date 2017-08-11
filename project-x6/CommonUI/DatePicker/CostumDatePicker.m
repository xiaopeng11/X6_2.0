//
//  CostumDatePicker.m
//  project-x6
//
//  Created by Apple on 2016/11/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CostumDatePicker.h"
#define XPDataPickerwidth (KScreenWidth * .7)

@interface CostumDatePicker ()
{
    UILabel *label;
}

@end


@implementation CostumDatePicker

- (instancetype)initWithFrame:(CGRect)frame
                         Date:(NSArray *)data
                     IndexStr:(NSString *)indexStr
                          Key:(NSString *)key
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.font = [UIFont systemFontOfSize:13];
        self.text = indexStr;
        self.textAlignment = NSTextAlignmentCenter;
        
        self.datePicker = [[CostumPickerView alloc] initWithFrame:CGRectMake(0, 0,XPDataPickerwidth, XPDataPickerwidth) Date:data IndexStr:indexStr];
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
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth * .15, ((KScreenHeight - XPDataPickerwidth - 40) / 2.0) - 30, XPDataPickerwidth, 30)];
        label.textColor = [UIColor blackColor];
        [self.subView addSubview:label];
        
        UIButton *cancleDate = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleDate.frame = CGRectMake(KScreenWidth * .15, ((KScreenHeight - XPDataPickerwidth - 40) / 2.0) + XPDataPickerwidth, (XPDataPickerwidth - .5) / 2, 40);
        cancleDate.backgroundColor = [UIColor redColor];
        cancleDate.clipsToBounds = YES;
        cancleDate.layer.cornerRadius = 4;
        [cancleDate setTitle:@"取消" forState:UIControlStateNormal];
        [cancleDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancleDate addTarget:self action:@selector(cancledateChange) forControlEvents:UIControlEventTouchUpInside];
        [self.subView addSubview:cancleDate];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth * .15 + ((XPDataPickerwidth - .5) / 2), ((KScreenHeight - XPDataPickerwidth - 40) / 2.0) + XPDataPickerwidth, .5, 40)];
        lineview.backgroundColor = [UIColor whiteColor];
        [self.subView addSubview:lineview];
        
        UIButton *chooseDate = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseDate.frame = CGRectMake(KScreenWidth * .15 + ((XPDataPickerwidth - .5) / 2) + .5, ((KScreenHeight - XPDataPickerwidth - 40) / 2.0) + XPDataPickerwidth, (XPDataPickerwidth - .5) / 2, 40);
        chooseDate.backgroundColor = [UIColor redColor];
        chooseDate.clipsToBounds = YES;
        chooseDate.layer.cornerRadius = 4;
        [chooseDate setTitle:@"确定" forState:UIControlStateNormal];
        [chooseDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chooseDate addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.subView addSubview:chooseDate];
        
        
        
        UITapGestureRecognizer *pickerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancledateChange)];
        [self.subView addGestureRecognizer:pickerTap];
        [view addSubview:self.datePicker];
        
        
        
        [self.subView addSubview:view];
        
        //设置输入框
        self.delegate=self;
        
        self.borderStyle=UITextBorderStyleRoundedRect;
                
        
    }
    return self;
}

- (void)setLabelString:(NSString *)labelString
{
    if (_labelString != labelString) {
        _labelString = labelString;
        label.text = _labelString;
    }
}

#pragma mark - 日期控件点击事件
- (void)dateChange:(id)sender
{
    //改变textField的值
    self.text = [NSString stringWithString:_datePicker.dateStr];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTimeData" object:nil];
    
    [self cancledateChange];
}

- (void)cancledateChange
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
