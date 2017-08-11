//
//  CostumMorePickerView.h
//  XPDatePicker
//
//  Created by Apple on 2016/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostumMorePickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong,readonly)NSString *dateStr;

- (instancetype)initWithFrame:(CGRect)frame
                         Date:(NSArray *)data
                     IndexStr:(NSString *)indexStr
                          Key:(NSString *)key;

- (void)selectDay;


@end
