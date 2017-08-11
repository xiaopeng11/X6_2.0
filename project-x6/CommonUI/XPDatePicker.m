//
//  XPDatePicker.m
//  DatePicker
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XPDatePicker.h"
#define XPDataPickerwidth (KScreenWidth * .7)

@implementation XPDatePicker

- (instancetype)initWithFrame:(CGRect)frame Date:(NSString *)dateString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
 
        //默认日期格式为yyyy-MM-dd
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.date = [self.dateFormatter dateFromString:dateString];

        self.font = [UIFont systemFontOfSize:11];
        self.textColor = [UIColor whiteColor];
        self.text = dateString;
        self.textAlignment = NSTextAlignmentCenter;
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, XPDataPickerwidth, XPDataPickerwidth)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.maximumDate = [NSDate date];
        self.datePicker.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth * .15, ((KScreenHeight - XPDataPickerwidth - 40) / 2.0), XPDataPickerwidth, XPDataPickerwidth)];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 4;
        view.backgroundColor = [UIColor whiteColor];
        
         //半透明背景
        self.subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        self.subView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        self.subView.tag = 0;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(view.left, view.top - 30, XPDataPickerwidth, 30)];
        label.textColor = [UIColor blackColor];
        [self.subView addSubview:label];
        
        UIButton *cancleDate = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleDate.frame = CGRectMake(view.left, view.bottom, (XPDataPickerwidth - .5) / 2, 40);
        cancleDate.backgroundColor = Mycolor;
        cancleDate.clipsToBounds = YES;
        cancleDate.layer.cornerRadius = 4;
        [cancleDate setTitle:@"取消" forState:UIControlStateNormal];
        [cancleDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancleDate addTarget:self action:@selector(cancledateChange) forControlEvents:UIControlEventTouchUpInside];
        [self.subView addSubview:cancleDate];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(view.left + ((XPDataPickerwidth - .5) / 2), view.bottom, .5, 40)];
        lineview.backgroundColor = [UIColor whiteColor];
        [self.subView addSubview:lineview];
        
        UIButton *chooseDate = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseDate.frame = CGRectMake(view.left + ((XPDataPickerwidth - .5) / 2) + .5, view.bottom, (XPDataPickerwidth - .5) / 2, 40);
        chooseDate.backgroundColor = Mycolor;
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


- (void)setMyColor:(UIColor *)myColor
{
    if (_myColor != myColor) {
        _myColor = myColor;
        self.textColor = _myColor;
    }
}

- (void)setMyfont:(UIFont *)myfont
{
    if (_myfont != myfont) {
        _myfont = myfont;
        self.font = _myfont;
    }
}

- (void)setMindateString:(NSString *)mindateString
{
    if (_mindateString != mindateString) {
        _mindateString = mindateString;
        NSDate *mindate = [self.dateFormatter dateFromString:_mindateString];
        self.datePicker.minimumDate = mindate;
    }
}

- (void)setMaxdateString:(NSString *)maxdateString
{
    if (_maxdateString != maxdateString) {
        _maxdateString = maxdateString;
        NSDate *maxdate = [self.dateFormatter dateFromString:_maxdateString];
        self.datePicker.maximumDate = maxdate;
    }
}

- (void)setNewdateString:(NSString *)newdateString
{
    if (_newdateString != newdateString) {
        _newdateString = newdateString;
        self.date = [self.dateFormatter dateFromString:newdateString];
    }
}

#pragma mark - 日期控件点击事件
- (void)dateChange:(id)sender
{
    self.date = [self.datePicker date];//获取datepicker的日期
    
    //改变textField的值
    
    self.text = [NSString stringWithString:[self.dateFormatter stringFromDate:self.date]];
    
    [self cancledateChange];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTodayData" object:[self.dateFormatter stringFromDate:self.date]];
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
