//
//  CostumDatePicker.h
//  project-x6
//
//  Created by Apple on 2016/11/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CostumPickerView.h"
@interface CostumDatePicker : UITextField<UITextFieldDelegate>

@property(nonatomic,strong)CostumPickerView *datePicker;     //时间选择
@property(nonatomic,strong)NSString *labelString;            //提示文本
@property(nonatomic,strong)UIView *subView;           //背景
- (instancetype)initWithFrame:(CGRect)frame
                         Date:(NSArray *)data
                     IndexStr:(NSString *)indexStr
                          Key:(NSString *)key;
@end
