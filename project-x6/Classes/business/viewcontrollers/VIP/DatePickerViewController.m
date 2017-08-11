//
//  DatePickerViewController.m
//  project-x6
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DatePickerViewController.h"
#import "XPDatePicker.h"
@interface DatePickerViewController ()<UITextFieldDelegate>
{
    XPDatePicker *_birthday;
}
@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:self.LabelString];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 45)];
    label.font = [UIFont systemFontOfSize:20];
    label.text = self.LabelString;
    [self.view addSubview:label];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"确定" target:self action:@selector(sureDate)];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //生日
    _birthday = [[XPDatePicker alloc] initWithFrame:CGRectMake(160, 10, 140, 45) Date:_date];
    _birthday.textAlignment = NSTextAlignmentRight;
    _birthday.delegate = self;
    _birthday.backgroundColor = [UIColor clearColor];
    _birthday.textColor = [UIColor blackColor];
    _birthday.myfont = [UIFont systemFontOfSize:20];
    _birthday.borderStyle = UITextBorderStyleNone;
    _birthday.labelString = self.LabelString;
    _birthday.maxdateString = @"2100-10-10";
    [self.view addSubview:_birthday];
    
    UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(160, 55, 140, .5)];
    [self.view addSubview:lineView];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_birthday]) {
        if (_birthday.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _birthday.subView.tag = 1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_birthday.subView];
        }
    }
    return NO;
}

- (void)sureDate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"suredate" object:_birthday.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
