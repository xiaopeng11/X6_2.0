//
//  CostumPickerView.h
//  project-x6
//
//  Created by Apple on 2016/11/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostumPickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong,readonly)NSString *dateStr;

- (instancetype)initWithFrame:(CGRect)frame
                         Date:(NSArray *)data
                     IndexStr:(NSString *)indexStr;

- (void)selectDay;

@end
