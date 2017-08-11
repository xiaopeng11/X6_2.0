//
//  CostumMoreDatePicker.h
//  XPDatePicker
//
//  Created by Apple on 2016/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CostumMorePickerView.h"
@interface CostumMoreDatePicker : UITextField<UITextFieldDelegate>


@property(nonatomic,strong)UIColor *MoretextColor;                 //文本颜色
@property(nonatomic,strong)UIFont *MoretextFont;                 //文本字体



@property(nonatomic,strong)CostumMorePickerView *datePicker;     //时间选择
@property(nonatomic,strong)UIView *subView;                  //背景

/**
 *  白色标题
 *
 *  @param data 标题文本
 *  @param indexStr 当前位置
 *  @param key 字符间的间隔
 
 */
- (instancetype)initWithFrame:(CGRect)frame
                         Data:(NSArray *)data
                     IndexStr:(NSString *)indexStr
                          Key:(NSString *)key;

@end
