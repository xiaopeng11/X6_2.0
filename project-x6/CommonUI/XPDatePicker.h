//
//  XPDatePicker.h
//  DatePicker
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPDatePicker : UITextField<UITextFieldDelegate>

{
    UILabel *label;
}
@property(nonatomic,strong)NSString *newdateString;                 //日期
@property(nonatomic,strong)UIDatePicker *datePicker;          //日期选择
@property(nonatomic,strong)NSString *labelString;             //提示文本
@property(nonatomic,strong)UIView *subView;                   //背景
@property(nonatomic,strong)NSDate *date;                       //日期
@property(nonatomic,strong)NSDateFormatter *dateFormatter;     //日期的样式
@property(nonatomic,strong)UIColor *myColor;                    //文本颜色
@property(nonatomic,strong)UIFont *myfont;                      //字号
@property(nonatomic,strong)NSString *mindateString;                 //最小日期
@property(nonatomic,strong)NSString *maxdateString;                 //最大日期
- (instancetype)initWithFrame:(CGRect)frame Date:(NSString *)dateString;

@end
