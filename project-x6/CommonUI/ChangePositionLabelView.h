//
//  ChangePositionLabelView.h
//  跑马灯
//
//  Created by Apple on 2016/12/6.
//  Copyright © 2016年 耿岩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePositionLabelView : UIView


@property(nonatomic,strong)NSTimer* timer;// 定义定时器
@property(nonatomic,strong)UIView *viewAnima; //装 滚动视图的容器
@property(nonatomic,weak)UILabel *customLab;

@property(nonatomic,strong)NSString *LabelString;





@end
